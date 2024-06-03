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
    [Parameter()][String]$ParserToolUrl = "https://github.com/jaredfholgate/template-parser/releases/download/0.1.18"
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
Write-Information "Updating Policy Assignments." -InformationAction Continue
$policyAssignmentSourcePath = "$SourcePath/eslzArm/managementGroupTemplates/policyAssignments"
$policyAssignmentTargetPath = "$TargetPath/modules/archetypes/lib/policy_assignments"
$sourcePolicyAssignmentFiles = Get-ChildItem -Path $policyAssignmentSourcePath -File

$defaultParameterValues =@(
    "-p nonComplianceMessagePlaceholder={donotchange}"
    "-p logAnalyticsWorkspaceName=`${root_scope_id}-la",
    "-p automationAccountName=`${root_scope_id}-automation",
    "-p workspaceRegion=`${default_location}",
    "-p automationRegion=`${default_location}",
    "-p retentionInDays=30",
    "-p rgName=`${root_scope_id}-mgmt",
    "-p logAnalyticsResourceId=/subscriptions/00000000-0000-0000-0000-000000000000/resourcegroups/`${root_scope_id}-mgmt/providers/Microsoft.OperationalInsights/workspaces/`${root_scope_id}-la",
    "-p topLevelManagementGroupPrefix=`${temp}",
    "-p dnsZoneResourceGroupId=`${private_dns_zone_prefix}",
    "-p ddosPlanResourceId=/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/`${root_scope_id}-mgmt/providers/Microsoft.Network/ddosProtectionPlans/`${root_scope_id}-ddos",
    "-p emailContactAsc=security_contact@replace_me",
    "-p location=uksouth"
)

$parsedAssignments = @{}
foreach($sourcePolicyAssignmentFile in $sourcePolicyAssignmentFiles)
{
    Write-Output "Processing Assignment: $sourcePolicyAssignmentFile"

    $parsedAssignmentArray = & $parser "-s $sourcePolicyAssignmentFile" $defaultParameterValues "-a" | Out-String | ConvertFrom-Json

    foreach($parsedAssignment in $parsedAssignmentArray)
    {
        if($parsedAssignment.type -ne "Microsoft.Authorization/policyAssignments")
        {
            continue
        }

        Write-Output "Parsed Assignment Name: $($parsedAssignment.name)"

        $parsedAssignments[$parsedAssignment.name] = @{
            json = $parsedAssignment
            file = $sourcePolicyAssignmentFile
        }

        if(!(Get-Member -InputObject $parsedAssignments[$parsedAssignment.name].json.properties -Name "scope" -MemberType Properties))
        {
            $parsedAssignments[$parsedAssignment.name].json.properties | Add-Member -MemberType NoteProperty -Name "scope" -Value "`${current_scope_resource_id}"
        }

        if(!(Get-Member -InputObject $parsedAssignments[$parsedAssignment.name].json.properties -Name "notScopes" -MemberType Properties))
        {
            $parsedAssignments[$parsedAssignment.name].json.properties | Add-Member -MemberType NoteProperty -Name "notScopes" -Value @()
        }

        if(!(Get-Member -InputObject $parsedAssignments[$parsedAssignment.name].json.properties -Name "parameters" -MemberType Properties))
        {
            $parsedAssignments[$parsedAssignment.name].json.properties | Add-Member -MemberType NoteProperty -Name "parameters" -Value @{}
        }

        if(!(Get-Member -InputObject $parsedAssignments[$parsedAssignment.name].json -Name "location" -MemberType Properties))
        {
            $parsedAssignments[$parsedAssignment.name].json | Add-Member -MemberType NoteProperty -Name "location" -Value "`${default_location}"
        }

        if(!(Get-Member -InputObject $parsedAssignments[$parsedAssignment.name].json -Name "identity" -MemberType Properties))
        {
            $parsedAssignments[$parsedAssignment.name].json | Add-Member -MemberType NoteProperty -Name "identity" -Value @{ type = "None" }
        }

        if($parsedAssignments[$parsedAssignment.name].json.properties.policyDefinitionId.StartsWith("/providers/Microsoft.Management/managementGroups/`${temp}"))
        {
            $parsedAssignments[$parsedAssignment.name].json.properties.policyDefinitionId = $parsedAssignments[$parsedAssignment.name].json.properties.policyDefinitionId.Replace("/providers/Microsoft.Management/managementGroups/`${temp}", "`${root_scope_resource_id}")
        }

        foreach($property in Get-Member -InputObject $parsedAssignments[$parsedAssignment.name].json.properties.parameters -MemberType NoteProperty)
        {
            $propertyName = $property.Name
            Write-Verbose "Checking Parameter: $propertyName"
            if($parsedAssignments[$parsedAssignment.name].json.properties.parameters.($propertyName).value.GetType() -eq [System.Boolean])
            {
                Write-Verbose "Skipping boolean parameter: $propertyName"
                continue
            }

            if($parsedAssignments[$parsedAssignment.name].json.properties.parameters.($propertyName).value.StartsWith("`${private_dns_zone_prefix}/providers/Microsoft.Network/privateDnsZones/"))
            {
                $parsedAssignments[$parsedAssignment.name].json.properties.parameters.($propertyName).value = $parsedAssignments[$parsedAssignment.name].json.properties.parameters.($propertyName).value.Replace("`${private_dns_zone_prefix}/providers/Microsoft.Network/privateDnsZones/", "`${private_dns_zone_prefix}")
                $parsedAssignments[$parsedAssignment.name].json.properties.parameters.($propertyName).value = $parsedAssignments[$parsedAssignment.name].json.properties.parameters.($propertyName).value.Replace("privatelink.batch.azure.com", "privatelink.`${connectivity_location}.batch.azure.com")
            }
            if($parsedAssignments[$parsedAssignment.name].json.properties.parameters.($propertyName).value.StartsWith("`${temp}"))
            {
                $parsedAssignments[$parsedAssignment.name].json.properties.parameters.($propertyName).value = $parsedAssignments[$parsedAssignment.name].json.properties.parameters.($propertyName).value.Replace("`${temp}", "`${root_scope_id}")
            }
        }
    }
}

foreach($key in $parsedAssignments.Keys | Sort-Object)
{
    $targetPolicyAssignmentFileName = "policy_assignment_es_$($key.ToLower() -replace "-", "_").tmpl.json"

    Write-Information "Writing $targetPolicyAssignmentFileName" -InformationAction Continue
    $json = $parsedAssignments[$key].json | ConvertTo-Json -Depth 10
    $json | Edit-LineEndings -LineEnding $LineEnding | Out-File -FilePath "$policyAssignmentTargetPath/$targetPolicyAssignmentFileName" -Force
}
