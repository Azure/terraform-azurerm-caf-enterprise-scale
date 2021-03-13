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
    [Parameter()][String]$TargetModulePath = "$PWD/terraform-azurerm-caf-enterprise-scale",
    [Parameter()][String]$SourceModulePath = "$PWD/enterprise-scale",
    [Parameter()][Switch]$UseCacheFromModule
)

$ErrorActionPreference = "Stop"

# This script relies on a custom set of classes and functions
# defined within the EnterpriseScaleLibraryTools PowerShell
# module.
$esltModuleDirectory = $TargetModulePath + "/.github/scripts/EnterpriseScaleLibraryTools"
$esltModulePath = "$esltModuleDirectory/EnterpriseScaleLibraryTools.psm1"
Import-Module $esltModulePath -ErrorAction Stop

# To avoid needing to authenticate with Azure, the following
# code will preload the ProviderApiVersions cache from a
# stored state in the module if the UseCacheFromModule flag
# is set and the ProviderApiVersions.zip file is present.
if ($UseCacheFromModule -and (Test-Path "$esltModuleDirectory/ProviderApiVersions.zip")) {
    Write-Information "Pre-loading ProviderApiVersions from saved cache." -InformationAction Continue
    Invoke-UseCacheFromModule($esltModuleDirectory)
}

# The defaultConfig object provides a set of default values
# to reduce verbosity within the esltConfig object.
$defaultConfig = @{
    inputFilter    = "*.json"
    typeFilter     = @()
    outputPath     = $TargetModulePath + "/modules/archetypes/lib"
    fileNamePrefix = ""
    fileNameSuffix = ".json"
    asTemplate     = $true
    recurse        = $false
}

# The esltConfig array controls the foreach loop used to run
# Export-LibraryArtifact. Each object provides a set of values
# used to configure each run of Export-LibraryArtifact within
# the loop. If a value needed by Export-LibraryArtifact is
# missing, it will use the default value specified in the
# defaultConfig object.
$esltConfig = @(
    @{
        inputPath      = $SourceModulePath + "/docs/reference/wingtip/armTemplates/auxiliary/policies.json"
        typeFilter     = "Microsoft.Authorization/policyDefinitions"
        fileNamePrefix = "policy_definitions/policy_definition_es_"
    }
    @{
        inputPath      = $SourceModulePath + "/docs/reference/wingtip/armTemplates/auxiliary/policies.json"
        typeFilter     = "Microsoft.Authorization/policySetDefinitions"
        fileNamePrefix = "policy_set_definitions/policy_set_definition_es_"
        fileNameSuffix = ".tmpl.json"
    }
)

foreach ($config in $esltConfig) {
    Export-LibraryArtifact `
        -InputPath ($config.inputPath ?? $defaultConfig.inputPath) `
        -InputFilter ($config.inputFilter ?? $defaultConfig.inputFilter) `
        -TypeFilter ($config.typeFilter ?? $defaultConfig.typeFilter) `
        -OutputPath ($config.outputPath ?? $defaultConfig.outputPath) `
        -FileNamePrefix ($config.fileNamePrefix ?? $defaultConfig.fileNamePrefix) `
        -FileNameSuffix ($config.fileNameSuffix ?? $defaultConfig.fileNameSuffix) `
        -AsTemplate:($config.asTemplate ?? $defaultConfig.asTemplate) `
        -Recurse:($config.recurse ?? $defaultConfig.recurse) `
        -WhatIf:$WhatIfPreference
}
