#!/usr/bin/pwsh

#
# PowerShell Script
# - Generate Azure Pipelines Strategy
#

Write-Information "==> Generating Azure Pipelines Strategy Matrix..." -InformationAction Continue

$jsonDepth = 4
$terraformUrl = "https://api.github.com/repos/hashicorp/terraform/tags"
$azurermProviderUrl = "https://registry.terraform.io/v1/providers/hashicorp/azurerm"

########################################
# Terraform Versions
# - Base Version: "0.13.2"
# - Latest Versions:
#     0.13.* (latest 1)
#     0.14.* (latest 1)
#     0.15.* (latest 1)
########################################

$terraformVersionsResponse = Invoke-RestMethod -Method Get -Uri $terraformUrl
$terraformVersionsAll = $terraformVersionsResponse.name -replace "v", ""

$terraformVersions = @("0.13.2")
$terraformVersions += $terraformVersionsAll | Where-Object { $_ -match "^0.13.\d{1,2}(?!-)" } | Select-Object -First 1
$terraformVersions += $terraformVersionsAll | Where-Object { $_ -match "^0.14.\d{1,2}(?!-)" } | Select-Object -First 1
$terraformVersions += $terraformVersionsAll | Where-Object { $_ -match "^0.15.\d{1,2}(?!-)" } | Select-Object -First 1

$terraformVersions = $terraformVersions | Sort-Object

#######################################
# Terraform AzureRM Provider Versions
# - Base Version: (2.41.0)
# - Latest Versions: (latest 1)
#######################################

$azurermProviderVersionBase = "2.41.0"
$azurermProviderVersionLatest = (Invoke-RestMethod -Method Get -Uri $azurermProviderUrl).version

#############################################################################
# Set a multi-job output variable to control strategy matrix for test jobs.
#############################################################################

$matrixObject = [PSCustomObject]@{}
for ($i = 0; $i -lt $terraformVersions.Count; $i++) {
    $terraformVersion = $terraformVersions[$i]
    $job1 = ($i * 2) + 1
    $job2 = ($i * 2) + 2
    $matrixObject | Add-Member `
        -NotePropertyName "$job1. (TF: $terraformVersion, AZ: $azurermProviderVersionBase)" `
        -NotePropertyValue @{
        TF_VERSION    = $terraformVersion;
        TF_AZ_VERSION = $azurermProviderVersionBase
        TF_JOB_ID     = $job1
    }
    $matrixObject | Add-Member `
        -NotePropertyName "$job2. (TF: $terraformVersion, AZ: $azurermProviderVersionLatest)" `
        -NotePropertyValue @{
        TF_VERSION    = $terraformVersion;
        TF_AZ_VERSION = $azurermProviderVersionLatest
        TF_JOB_ID     = $job2
    }
}

# Convert PSCustomObject to JSON.
$matrixJsonOutput = $matrixObject | ConvertTo-Json -Depth $jsonDepth -Compress

# Save the matrix value to an output variable for downstream consumption .
Write-Output "##vso[task.setVariable variable=matrix_json;isOutput=true]$matrixJsonOutput"
