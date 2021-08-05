#!/usr/bin/pwsh

#
# PowerShell Script
# - Update the ProviderApiVersions.zip file stored in the module
#
# Requires an authentication session PowerShell session to Azure
# and should be run from the same location as the script unless
# the -Directory parameter is specified.
#

[CmdletBinding(SupportsShouldProcess)]
param (
    [Parameter()][String]$Directory = "$PWD/EnterpriseScaleLibraryTools"
)

$ErrorActionPreference = "Stop"

# This script relies on a custom set of classes and functions
# defined within the EnterpriseScaleLibraryTools PowerShell
# module.
$esltModulePath = "$Directory/EnterpriseScaleLibraryTools.psm1"
Import-Module $esltModulePath -ErrorAction Stop

Write-Information "Updating ProviderApiVersions in module." -InformationAction Continue
if ($PSCmdlet.ShouldProcess($Directory)) {
    Invoke-UpdateCacheInModule($Directory)
}

Write-Information "... Complete" -InformationAction Continue
