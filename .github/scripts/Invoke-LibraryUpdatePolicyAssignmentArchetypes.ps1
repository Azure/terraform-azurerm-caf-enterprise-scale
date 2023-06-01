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

$finalPolicyAssignments = New-Object 'System.Collections.Generic.Dictionary[string,System.Collections.Generic.List[string]]'

$policyAssignmentSourcePath = "$SourcePath/eslzArm/managementGroupTemplates/policyAssignments"



foreach($managementGroup in $policyAssignments.Keys)
{
    foreach($policyAssignmentFile in $policyAssignments[$managementGroup])
    {
        $parsedAssignment = & $parser "-s $policyAssignmentSourcePath/$policyAssignmentFile" | Out-String | ConvertFrom-Json
        $policyAssignmentName = $parsedAssignment.name

        $managementGroupNameFinal = $managementGroupMapping[$managementGroup.Replace("defaults-", "")]

        Write-Information "Got final data for $managementGroupNameFinal and $policyAssignmentName" -InformationAction Continue

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
