#!/usr/bin/pwsh

#
# PowerShell Script
# - Update template library in terraform-azurerm-caf-enterprise-scale repository
#

[CmdletBinding(SupportsShouldProcess)]
param (
    [Parameter()][String]$AlzToolsPath = "$PWD/enterprise-scale/src/Alz.Tools",
    [Parameter()][String]$TargetPath = "$PWD/terraform-azurerm-caf-enterprise-scale",
    [Parameter()][String]$SourcePath = "$PWD/enterprise-scale",
    [Parameter()][String]$LineEnding = "unix",
    [Parameter()][String]$ParserToolUrl = "https://github.com/Azure/arm-template-parser/releases/download/0.2.2"
)

$ErrorActionPreference = "Stop"

# This script relies on a custom set of classes and functions
# defined within the EnterpriseScaleLibraryTools PowerShell
# module.
Import-Module $AlzToolsPath -ErrorAction Stop

$parserPath = "$TargetPath/.github/scripts"
$parserExe = "Template.Parser.Cli"
if($IsWindows)
{
    $parserExe += ".exe"
}

$parser = "$parserPath/$parserExe"

if(!(Test-Path $parser))
{
    Write-Information "Downloading Template Parser." -InformationAction Continue
    Invoke-WebRequest "$ParserToolUrl/$parserExe" -OutFile $parser
    if($IsLinux)
    {
        chmod +x $parser
    }
}

# Update the policy assignments if enabled
Write-Information "Updating Policy Assignment Archetypes." -InformationAction Continue

$eslzArmSourcePath = "$SourcePath/eslzArm/eslzArm.json"
$eslzArmParametersSourcePath = "$SourcePath/eslzArm/eslzArm.terraform-sync.param.json"

$eslzArm = & $parser "-s $eslzArmSourcePath" "-f $eslzArmParametersSourcePath" "-a" | Out-String | ConvertFrom-Json

$policyAssignments = New-Object 'System.Collections.Generic.Dictionary[string,System.Collections.Generic.List[string]]'

foreach($resource in $eslzArm)
{
    $scope = $resource.scope
    $policyAssignment = $resource.properties.templateLink.uri

    if($null -ne $policyAssignment -and $policyAssignment.StartsWith("https://deploymenturi/managementGroupTemplates/policyAssignments/") -and $resource.condition)
    {
        $managementGroup = $scope.Split("/")[-1]
        $policyAssignmentFileName = $policyAssignment.Split("/")[-1]

        if(!($policyAssignmentFileName.StartsWith("fairfax")))
        {
            if(!($policyAssignments.ContainsKey($managementGroup)))
            {
                $values = New-Object 'System.Collections.Generic.List[string]'
                $values.Add($policyAssignmentFileName)
                $policyAssignments.Add($managementGroup, $values)
            }
            else
            {
                $policyAssignments[$managementGroup].Add($policyAssignmentFileName)
            }
        }
    }
}

$managementGroupMapping = @{
    "defaults" = "root"
    "management" = "management"
    "connectivity" = "connectivity"
    "corp" = "corp"
    "landingzones" = "landing_zones"
    "decommissioned" = "decommissioned"
    "sandboxes" = "sandboxes"
    "identity" = "identity"
    "platform" = "platform"
}

$logAnalyticsWorkspaceIdPlaceholder = "/subscriptions/00000000-0000-0000-0000-000000000000/resourcegroups/`${root_scope_id}-mgmt/providers/Microsoft.OperationalInsights/workspaces/`${root_scope_id}-la"

$parameters = @{
    default = @{
        nonComplianceMessagePlaceholder          = "{donotchange}"
        logAnalyticsWorkspaceName                = "`${root_scope_id}-la"
        automationAccountName                    = "`${root_scope_id}-automation"
        workspaceRegion                          = "`${default_location}"
        automationRegion                         = "`${default_location}"
        retentionInDays                          = "30"
        rgName                                   = "`${root_scope_id}-mgmt"
        logAnalyticsResourceId                   = "$logAnalyticsWorkspaceIdPlaceholder"
        topLevelManagementGroupPrefix            = "`${temp}"
        dnsZoneResourceGroupId                   = "`${private_dns_zone_prefix}"
        ddosPlanResourceId                       = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/`${root_scope_id}-mgmt/providers/Microsoft.Network/ddosProtectionPlans/`${root_scope_id}-ddos"
        emailContactAsc                          = "security_contact@replace_me"
        location                                 = "uksouth"
        listOfResourceTypesDisallowedForDeletion = "[[[Array]]]"
        userWorkspaceResourceId                  = "$logAnalyticsWorkspaceIdPlaceholder"
        userAssignedIdentityResourceId           = "`${user_assigned_managed_identity_resource_id}"
        dcrResourceId                            = "`${azure_monitor_data_collection_rule_resource_id}"
        dataCollectionRuleResourceId             = "`${azure_monitor_data_collection_rule_resource_id}"
    }
    overrides = @{
        sql_data_collection_rule_overrides = @{
            policy_assignments = @(
                "DINE-MDFCDefenderSQLAMAPolicyAssignment.json"
            )
            parameters = @{
                dcrResourceId                            = "`${azure_monitor_data_collection_rule_sql_resource_id}"
                dataCollectionRuleResourceId             = "`${azure_monitor_data_collection_rule_sql_resource_id}"
            }
        }
        vm_insights_data_collection_rule_overrides = @{
            policy_assignments = @(
                "DINE-VMHybridMonitoringPolicyAssignment.json",
                "DINE-VMMonitoringPolicyAssignment.json",
                "DINE-VMSSMonitoringPolicyAssignment.json"
            )
            parameters = @{
                dcrResourceId                            = "`${azure_monitor_data_collection_rule_vm_insights_resource_id}"
                dataCollectionRuleResourceId             = "`${azure_monitor_data_collection_rule_vm_insights_resource_id}"
            }
        }
        change_tracking_data_collection_rule_overrides = @{
            policy_assignments = @(
                "DINE-ChangeTrackingVMArcPolicyAssignment.json",
                "DINE-ChangeTrackingVMPolicyAssignment.json",
                "DINE-ChangeTrackingVMSSPolicyAssignment.json"
            )
            parameters = @{
                dcrResourceId                            = "`${azure_monitor_data_collection_rule_change_tracking_resource_id}"
                dataCollectionRuleResourceId             = "`${azure_monitor_data_collection_rule_change_tracking_resource_id}"
            }
        }
    }
}

$finalPolicyAssignments = New-Object 'System.Collections.Generic.Dictionary[string,System.Collections.Generic.List[string]]'

$policyAssignmentSourcePath = "$SourcePath/eslzArm/managementGroupTemplates/policyAssignments"
$policyAssignmentTargetPath = "$TargetPath/modules/archetypes/lib/policy_assignments"

foreach($managementGroup in $policyAssignments.Keys)
{
    $managementGroupNameFinal = $managementGroupMapping[$managementGroup.Replace("defaults-", "")]
    Write-Output "`nProcessing Archetype Policy Assignments for Management Group: $managementGroupNameFinal"

    foreach($policyAssignmentFile in $policyAssignments[$managementGroup])
    {
        Write-Output "`nProcessing Archetype Policy Assignment: $managementGroupNameFinal - $policyAssignmentFile"

        $defaultParameters = $parameters.default
        foreach($overrideKey in $parameters.overrides.Keys)
        {
            if($policyAssignmentFile -in $parameters.overrides[$overrideKey].policy_assignments)
            {
                foreach($parameter in $parameters.overrides[$overrideKey].parameters.Keys)
                {
                    $defaultParameters.$parameter = $parameters.overrides[$overrideKey].parameters.$parameter
                }
            }
        }

        $defaultParameterFormatted = $defaultParameters.GetEnumerator().ForEach({ "-p $($_.Name)=$($_.Value)" })

        $parsedAssignmentArray = & $parser "-s $policyAssignmentSourcePath/$policyAssignmentFile" $defaultParameterFormatted "-a" | Out-String | ConvertFrom-Json

        foreach($parsedAssignment in $parsedAssignmentArray)
        {
            if($parsedAssignment.type -ne "Microsoft.Authorization/policyAssignments")
            {
                continue
            }

            $policyAssignmentName = $parsedAssignment.name

            Write-Output "Parsed Assignment Name: $($parsedAssignment.name)"

            if(!(Get-Member -InputObject $parsedAssignment.properties -Name "scope" -MemberType Properties))
            {
                $parsedAssignment.properties | Add-Member -MemberType NoteProperty -Name "scope" -Value "`${current_scope_resource_id}"
            }

            if(!(Get-Member -InputObject $parsedAssignment.properties -Name "notScopes" -MemberType Properties))
            {
                $parsedAssignment.properties | Add-Member -MemberType NoteProperty -Name "notScopes" -Value @()
            }

            if(!(Get-Member -InputObject $parsedAssignment.properties -Name "parameters" -MemberType Properties))
            {
                $parsedAssignment.properties | Add-Member -MemberType NoteProperty -Name "parameters" -Value @{}
            }

            if(!(Get-Member -InputObject $parsedAssignment -Name "location" -MemberType Properties))
            {
                $parsedAssignment | Add-Member -MemberType NoteProperty -Name "location" -Value "`${default_location}"
            }

            if(!(Get-Member -InputObject $parsedAssignment -Name "identity" -MemberType Properties))
            {
                $parsedAssignment | Add-Member -MemberType NoteProperty -Name "identity" -Value @{ type = "None" }
            }

            if($parsedAssignment.properties.policyDefinitionId.StartsWith("/providers/Microsoft.Management/managementGroups/`${temp}"))
            {
                $parsedAssignment.properties.policyDefinitionId = $parsedAssignment.properties.policyDefinitionId.Replace("/providers/Microsoft.Management/managementGroups/`${temp}", "`${root_scope_resource_id}")
            }

            foreach($property in Get-Member -InputObject $parsedAssignment.properties.parameters -MemberType NoteProperty)
            {
                $propertyName = $property.Name
                Write-Verbose "Checking Parameter: $propertyName"
                if($parsedAssignment.properties.parameters.($propertyName).value.GetType() -ne [System.String])
                {
                    Write-Verbose "Skipping non-string parameter: $propertyName"
                    continue
                }

                if($parsedAssignment.properties.parameters.($propertyName).value.StartsWith("`${private_dns_zone_prefix}/providers/Microsoft.Network/privateDnsZones/"))
                {
                    $parsedAssignment.properties.parameters.($propertyName).value = $parsedAssignment.properties.parameters.($propertyName).value.Replace("`${private_dns_zone_prefix}/providers/Microsoft.Network/privateDnsZones/", "`${private_dns_zone_prefix}")
                    $parsedAssignment.properties.parameters.($propertyName).value = $parsedAssignment.properties.parameters.($propertyName).value.Replace("privatelink.uks.backup.windowsazure.com", "privatelink.`${connectivity_location_short}.backup.windowsazure.com")
                }
                if($parsedAssignment.properties.parameters.($propertyName).value.StartsWith("`${temp}"))
                {
                    $parsedAssignment.properties.parameters.($propertyName).value = $parsedAssignment.properties.parameters.($propertyName).value.Replace("`${temp}", "`${root_scope_id}")
                }
            }

            $targetPolicyAssignmentFileName = "policy_assignment_es_$($policyAssignmentName.ToLower() -replace "-", "_").tmpl.json"

            Write-Information "Writing $targetPolicyAssignmentFileName" -InformationAction Continue
            $json = $parsedAssignment | ConvertTo-Json -Depth 10
            $json | Edit-LineEndings -LineEnding $LineEnding | Out-File -FilePath "$policyAssignmentTargetPath/$targetPolicyAssignmentFileName" -Force

            Write-Verbose "Got final data for $managementGroupNameFinal and $policyAssignmentName"

            if(!($finalPolicyAssignments.ContainsKey($managementGroupNameFinal)))
            {
                $values = New-Object 'System.Collections.Generic.List[string]'
                $values.Add($policyAssignmentName)
                $finalPolicyAssignments.Add($managementGroupNameFinal, $values)
            }
            else
            {
                $finalPolicyAssignments[$managementGroupNameFinal].Add($policyAssignmentName)
            }
        }
    }
}

$policyAssignmentTargetPath = "$TargetPath/modules/archetypes/lib/archetype_definitions"

foreach($managementGroup in $finalPolicyAssignments.Keys)
{
    $archetypeFilePath = "$policyAssignmentTargetPath/archetype_definition_es_$managementGroup.tmpl.json"
    $archetypeJson = Get-Content $archetypeFilePath | ConvertFrom-Json

    $archetypeJson.("es_$managementGroup").policy_assignments = @($finalPolicyAssignments[$managementGroup] | Sort-Object)

    Write-Information "Writing $archetypeFilePath" -InformationAction Continue
    $json = $archetypeJson | ConvertTo-Json -Depth 10
    $json | Edit-LineEndings -LineEnding $LineEnding | Out-File -FilePath "$archetypeFilePath" -Force
}
