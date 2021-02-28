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

[CmdletBinding()]
param (
    [Parameter()][String]$targetModulePath = "$PWD/terraform-azurerm-caf-enterprise-scale",
    [Parameter()][String]$sourceModulePath = "$PWD/enterprise-scale",
    [Parameter()][Switch]$WhatIf
)

$ErrorActionPreference = "Stop"

# This script relies on a custom set of classes and functions
# defined within the EnterpriseScaleLibraryTools PowerShell
# module.
$esltModulePath = $targetModulePath + "/.github/scripts/EnterpriseScaleLibraryTools/EnterpriseScaleLibraryTools.psm1"
Import-Module $esltModulePath -ErrorAction Stop

# The defaultConfig object provides a set of default values
# to reduce verbosity within the esltConfig object.
$defaultConfig = @{
    inputFilter    = "*.json"
    typeFilter     = @()
    outputPath     = $targetModulePath + "/modules/archetypes/lib"
    fileNamePrefix = ""
    fileNameSuffix = ".json"
    asTemplate     = $true
    recurse        = $false
    whatIf         = $WhatIf ?? $true
}

# The esltConfig array controls the foreach loop used to run
# Export-LibraryArtifact. Each object provides a set of values
# used to configure each run of Export-LibraryArtifact within
# the loop. If a value needed by Export-LibraryArtifact is
# missing, it will use the default value specified in the
# defaultConfig object.
$esltConfig = @(
    @{
        inputPath      = $sourceModulePath + "/docs/reference/wingtip/armTemplates/auxiliary/policies.json"
        typeFilter     = "Microsoft.Authorization/policyDefinitions"
        fileNamePrefix = "policy_definitions/policy_definition_es_"
    }
    @{
        inputPath      = $sourceModulePath + "/docs/reference/wingtip/armTemplates/auxiliary/policies.json"
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
        -WhatIf:($config.whatIf ?? $defaultConfig.whatIf)
}
