#!/usr/bin/pwsh

#
# PowerShell Script
# - Update template library in terraform-azurerm-caf-enterprise-scale repository
#
# Valid object schema for Export-LibraryArtifact function loop:
#
# @{
#     inputPath      = [String]
#     inputFilter    = [String]
#     typeFilter     = [String[]]
#     outputPath     = [String]
#     fileNamePrefix = [String]
#     fileNameSuffix = [String]
#     asTemplate     = [Boolean]
#     recurse        = [Boolean]
#     whatIf         = [Boolean]
# }
#

[CmdletBinding(SupportsShouldProcess)]
param (
    [Parameter()][String]$AlzToolsPath = "$PWD/enterprise-scale/src/Alz.Tools",
    [Parameter()][String]$TargetPath = "$PWD/terraform-azurerm-caf-enterprise-scale",
    [Parameter()][String]$SourcePath = "$PWD/enterprise-scale",
    [Parameter()][String]$LineEnding = "unix",
    [Parameter()][Switch]$Reset,
    [Parameter()][Switch]$UpdateProviderApiVersions
)

$ErrorActionPreference = "Stop"

# This script relies on a custom set of classes and functions
# defined within the EnterpriseScaleLibraryTools PowerShell
# module.
Import-Module $AlzToolsPath -ErrorAction Stop

# To avoid needing to authenticate with Azure, the following
# code will preload the ProviderApiVersions cache from a
# stored state in the module if the UseCacheFromModule flag
# is set and the ProviderApiVersions.zip file is present.
if (!$UpdateProviderApiVersions -and (Test-Path "$AlzToolsPath/ProviderApiVersions.zip")) {
    Write-Information "Pre-loading ProviderApiVersions from saved cache." -InformationAction Continue
    Invoke-UseCacheFromModule($AlzToolsPath)
}

# The defaultConfig object provides a set of default values
# to reduce verbosity within the exportConfig object.
$defaultConfig = @{
    inputFilter        = "*.json"
    resourceTypeFilter = @()
    outputPath         = $TargetPath + "/modules/archetypes/lib"
    fileNamePrefix     = ""
    fileNameSuffix     = ".json"
    exportFormat       = "Terraform"
    recurse            = $false
}

# File locations from Enterprise-scale repository for
# resources, organised by type
$policyDefinitionFilePaths = (
    Get-ChildItem -Path "$SourcePath/src/resources/Microsoft.Authorization/policyDefinitions/*" `
        -File `
        -Include "*.json" `
        -Exclude "*.AzureChinaCloud.json", "*.AzureUSGovernment.json"
).FullName
$policySetDefinitionFilePaths = (
    Get-ChildItem -Path "$SourcePath/src/resources/Microsoft.Authorization/policySetDefinitions/*" `
        -File `
        -Include "*.json" `
        -Exclude "*.AzureChinaCloud.json", "*.AzureUSGovernment.json"
).FullName

# The exportConfig array controls the foreach loop used to run
# Export-LibraryArtifact. Each object provides a set of values
# used to configure each run of Export-LibraryArtifact within
# the loop. If a value needed by Export-LibraryArtifact is
# missing, it will use the default value specified in the
# defaultConfig object.
$exportConfig = @()
# Add Policy Definition source files to $exportConfig
$exportConfig += $policyDefinitionFilePaths |
ForEach-Object {
    [PsCustomObject]@{
        inputPath          = $_
        resourceTypeFilter = "Microsoft.Authorization/policyDefinitions"
        fileNamePrefix     = "policy_definitions/policy_definition_es_"
    }
}
# Add Policy Set Definition source files to $exportConfig
$exportConfig += $policySetDefinitionFilePaths | ForEach-Object {
    [PsCustomObject]@{
        inputPath          = $_
        resourceTypeFilter = "Microsoft.Authorization/policySetDefinitions"
        fileNamePrefix     = "policy_set_definitions/policy_set_definition_es_"
        fileNameSuffix     = ".tmpl.json"
    }
}

# If the -Reset parameter is set, delete all existing
# artefacts (by resource type) from the library
if ($Reset) {
    Write-Information "Deleting existing Policy Definitions from library." -InformationAction Continue
    Remove-Item -Path "$TargetPath/modules/archetypes/lib/policy_definitions/" -Recurse -Force
    Write-Information "Deleting existing Policy Set Definitions from library." -InformationAction Continue
    Remove-Item -Path "$TargetPath/modules/archetypes/lib/policy_set_definitions/" -Recurse -Force
}

# Process the files added to $exportConfig, to add content
# to the library
foreach ($config in $exportConfig) {
    Export-LibraryArtifact `
        -InputPath ($config.inputPath ?? $defaultConfig.inputPath) `
        -InputFilter ($config.inputFilter ?? $defaultConfig.inputFilter) `
        -ResourceTypeFilter ($config.resourceTypeFilter ?? $defaultConfig.resourceTypeFilter) `
        -OutputPath ($config.outputPath ?? $defaultConfig.outputPath) `
        -FileNamePrefix ($config.fileNamePrefix ?? $defaultConfig.fileNamePrefix) `
        -FileNameSuffix ($config.fileNameSuffix ?? $defaultConfig.fileNameSuffix) `
        -ExportFormat:($config.exportFormat ?? $defaultConfig.exportFormat) `
        -Recurse:($config.recurse ?? $defaultConfig.recurse) `
        -LineEnding $LineEnding `
        -WhatIf:$WhatIfPreference
}

# Get a list of current Policy Definition names
$policyDefinitionFiles = Get-ChildItem -Path "$TargetPath/modules/archetypes/lib/policy_definitions/"
$policyDefinitionNames = $policyDefinitionFiles | ForEach-Object {
    (Get-Content -Path $_ | ConvertFrom-Json).Name
}

# Get a list of current Policy Set Definition names
$policySetDefinitionFiles = Get-ChildItem -Path "$TargetPath/modules/archetypes/lib/policy_set_definitions/"
$policySetDefinitionNames = $policySetDefinitionFiles | ForEach-Object {
    (Get-Content -Path $_ | ConvertFrom-Json).Name
}

# Update the es_root archetype definition to reflect
# the current list of Policy Definitions and Policy
# Set Definitions
$esRootFilePath = $TargetPath + "/modules/archetypes/lib/archetype_definitions/archetype_definition_es_root.tmpl.json"
Write-Information "Loading `"es_root`" archetype definition." -InformationAction Continue
$esRootConfig = Get-Content -Path $esRootFilePath | ConvertFrom-Json
Write-Information "Updating Policy Definitions in `"es_root`" archetype definition." -InformationAction Continue
$esRootConfig.es_root.policy_definitions = $policyDefinitionNames
Write-Information "Updating Policy Set Definitions in `"es_root`" archetype definition." -InformationAction Continue
$esRootConfig.es_root.policy_set_definitions = $policySetDefinitionNames
Write-Information "Saving `"es_root`" archetype definition." -InformationAction Continue
$esRootConfig | ConvertTo-Json -Depth 10 | Edit-LineEndings -LineEnding $LineEnding | Out-File -FilePath $esRootFilePath -Force
