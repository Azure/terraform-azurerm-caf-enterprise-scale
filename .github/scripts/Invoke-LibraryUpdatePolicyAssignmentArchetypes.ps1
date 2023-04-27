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
}

# Update the policy assignments if enabled
Write-Information "Updating Policy Assignment Archetypes." -InformationAction Continue

$eslzArmSourcePath = "$SourcePath/eslzArm/eslzArm.json"
$eslzArmParametersSourcePath = "$SourcePath/eslzArm/eslzArm.test.param.json"

$eslzArm = & $parser "-s $eslzArmSourcePath" "-f $eslzArmParametersSourcePath" "-a" | Out-String | ConvertFrom-Json

#Out-File -FilePath "C:\Users\jaredholgate\OneDrive - Microsoft\Desktop\temp.json" -InputObject $eslzArm -Encoding UTF8 -Force

$policyAssignments = New-Object 'System.Collections.Generic.Dictionary[string,System.Collections.Generic.List[string]]'

foreach($resource in $eslzArm)
{
    $scope = $resource.scope
    $policyAssignment = $resource.properties.templateLink.uri

    if($policyAssignment -ne $null -and $policyAssignment.StartsWith("https://deploymenturi/managementGroupTemplates/policyAssignments/"))
    {
        Write-Host "$scope - $policyAssignment"
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

$finalPolicyAssignments = New-Object 'System.Collections.Generic.Dictionary[string,System.Collections.Generic.List[string]]'

$policyAssignmentSourcePath = "$SourcePath/eslzArm/managementGroupTemplates/policyAssignments"

foreach($managementGroup in $policyAssignments.Keys)
{
    foreach($policyAssignmentFile in $policyAssignments[$managementGroup])
    {
        $parsedAssignment = & $parser "-s $policyAssignmentSourcePath/$policyAssignmentFile" | Out-String | ConvertFrom-Json
        $policyAssignmentName = $parsedAssignment.name

        if(!($finalPolicyAssignments.ContainsKey($managementGroup)))
        {
            $values = New-Object 'System.Collections.Generic.List[string]'
            $values.Add($policyAssignmentName)
            $finalPolicyAssignments.Add($managementGroup, $values)
        }
        else
        {
            $finalPolicyAssignments[$managementGroup].Add($policyAssignmentName)
        }
    }
}
