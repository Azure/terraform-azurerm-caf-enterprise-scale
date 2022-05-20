#!/usr/bin/pwsh

###############################################
# Run tests and generate testing values.
###############################################

# Run this locally to test your terraform configuration and generate the values needed for the automation pipeline.
# The script will install all the necessary components locally and run the tests.
# After completing the tests, follow the script prompt for the next steps.

# Parameters
param (
    [string]$MODULE_BASE_PATH = $(Get-Location).Path,
    [switch]$GENERATE_AUTO_TFVARS,
    [bool]$CLEANUP = $true
)

# #? Run a local test against a different module configuration:
# #* Update the path to run the tests on a different folder (example: ../deployment_2)
# #* Copy paste the variables.tf file from deployment folder and adjust your main.tf
###############################################
# #* Path of the tested Terraform module

$MODULE_PATHS = @(
    "$($MODULE_BASE_PATH)/tests/modules/test_001_baseline"
    "$($MODULE_BASE_PATH)/tests/modules/test_002_add_custom_core"
    "$($MODULE_BASE_PATH)/tests/modules/test_003_add_mgmt_conn"
)
###############################################

$PWSH_OS = $PSVersionTable.OS
$PWSH_PLATFORM = $PSVersionTable.Platform

Write-Output "################################################"
Write-Output "==> Initiate installation of pre-requisites..."
Write-Output "==> OS       : $PWSH_OS"
Write-Output "==> Platform : $PWSH_PLATFORM"
Write-Output "`n"

if (($PWSH_OS -like "*Windows*") -and ($PWSH_PLATFORM -eq "Win32NT")) {
    . "$($MODULE_BASE_PATH)/tests/scripts/opa-install-windows.ps1"
}
elseif (($PWSH_OS -like "Darwin*") -and ($PWSH_PLATFORM -eq "Unix")) {
    Write-Output "Support for MacOS still in development. Please ensure pre-requisites are manually installed and re-run this script if errors occur due to missing software."
}
elseif (($PWSH_OS -like "Linux*") -and ($PWSH_PLATFORM -eq "Unix")) {
    . "$($MODULE_BASE_PATH)/tests/scripts/opa-install-linux.sh"
}

Write-Output "`n"
Write-Output "==> Completed installation of pre-requisites."
Write-Output "################################################"
Write-Output "`n"

foreach ($MODULE_PATH in $MODULE_PATHS) {

    if (-not ($MODULE_PATH | Test-Path)) { Throw "The directory does not exist, check entries in MODULE_PATHS variable on .\opa-values-generator.ps1 :line 18" }

    $TF_PLAN_OUT = "$MODULE_PATH/terraform_plan"
    $BASELINE_VALUES = "$MODULE_PATH/baseline_values"
    $AUTO_TFVARS_OUT = "$MODULE_PATH/opa.auto.tfvars.json"
    $MODULE_NAME = Split-Path $MODULE_PATH -Leaf

    Write-Output "==> ($MODULE_NAME) - Change to the module root directory..."
    Set-Location $MODULE_PATH

    # Optionally auto-generate a set of TFVARS for the environment
    if ($GENERATE_AUTO_TFVARS) {
        Write-Output "==> ($MODULE_NAME) - Generating auto.tfvars.json file..."
        $autoTfvars = [ordered]@{}
        if ($DEFAULT_SUBSCRIPTION_ID_CONNECTIVITY -or $env:DEFAULT_SUBSCRIPTION_ID_CONNECTIVITY) {
            $autoTfvars.add('subscription_id_connectivity', $DEFAULT_SUBSCRIPTION_ID_CONNECTIVITY ?? $env:DEFAULT_SUBSCRIPTION_ID_CONNECTIVITY)
        }
        if ($DEFAULT_SUBSCRIPTION_ID_MANAGEMENT -or $env:DEFAULT_SUBSCRIPTION_ID_MANAGEMENT) {
            $autoTfvars.add('subscription_id_management', $DEFAULT_SUBSCRIPTION_ID_MANAGEMENT ?? $env:DEFAULT_SUBSCRIPTION_ID_MANAGEMENT)
        }
        $autoTfvars | ConvertTo-Json -Depth 10 | Out-File $AUTO_TFVARS_OUT
        Write-Output "==> ($MODULE_NAME) - Saved file: $AUTO_TFVARS_OUT"
        Write-Output "`n"
        Get-Content -Path $AUTO_TFVARS_OUT
        Write-Output "`n"
    }

    Write-Output "==> ($MODULE_NAME) - Initializing infrastructure..."
    terraform init -upgrade

    Write-Output "==> ($MODULE_NAME) - Planning infrastructure..."
    terraform plan `
        -var="root_id=root-id-1" `
        -var="root_name=root-name" `
        -var="primary_location=northeurope" `
        -var="secondary_location=westeurope" `
        -out="$TF_PLAN_OUT" `
    | Out-Null

    Write-Output "==> ($MODULE_NAME) - Converting plan to *.json..."
    terraform show -json "$TF_PLAN_OUT" | Out-File -FilePath "$TF_PLAN_OUT.json"

    Write-Output "==> ($MODULE_NAME) - Removing the original plan..."
    Remove-Item -Path "$TF_PLAN_OUT"

    Write-Output "==> ($MODULE_NAME) - Saving planned values to baseline_values.json..."
    Get-Content -Path "$TF_PLAN_OUT.json" |
    # Extract the `.planned_values` to reduce file size
    jq '.planned_values' |
    # Ensure the child_modules are correctly and consistently
    # sorted by `.address` field to prevent issues with Git
    # diff being detected incorrectly.
    # This appears to be a "bug" in Terraform, but any fix
    # would only work for future releases, hence the fix below.
    jq '(.root_module.child_modules[]?.child_modules // []) |= sort_by(.address)' |
    Out-File -FilePath "$BASELINE_VALUES.json"

    #  Run OPA Tests
    Set-Location $MODULE_PATH
    Write-Output "==> ($MODULE_NAME) - Running conftest..."

    Write-Output "==> ($MODULE_NAME) - Testing azurerm_management_group resources..."
    conftest test "$TF_PLAN_OUT.json" -p ../../opa/policy/management_groups.rego -d "$BASELINE_VALUES.json"

    Write-Output "==> ($MODULE_NAME) - Testing azurerm_policy_definition resources..."
    conftest test "$TF_PLAN_OUT.json" -p ../../opa/policy/policy_definitions.rego -d "$BASELINE_VALUES.json"

    Write-Output "==> ($MODULE_NAME) - Testing azurerm_policy_set_definition resources..."
    conftest test "$TF_PLAN_OUT.json" -p ../../opa/policy/policy_set_definitions.rego -d "$BASELINE_VALUES.json"

    Write-Output "==> ($MODULE_NAME) - Testing azurerm_policy_assignment resources..."
    conftest test "$TF_PLAN_OUT.json" -p ../../opa/policy/policy_assignments.rego -d "$BASELINE_VALUES.json"

    Write-Output "==> ($MODULE_NAME) - Testing azurerm_role_definition resources..."
    conftest test "$TF_PLAN_OUT.json" -p ../../opa/policy/role_definitions.rego -d "$BASELINE_VALUES.json"

    Write-Output "==> ($MODULE_NAME) - Testing azurerm_role_assignment resources..."
    conftest test "$TF_PLAN_OUT.json" -p ../../opa/policy/role_assignments.rego -d "$BASELINE_VALUES.json"

    # Remove comments and $CLEANUP parameter for CMD prompt.
    # $CLEANUP = Read-Host "Do you want to prepare files for repository (y/n)?"
    if ($CLEANUP) {
        Write-Output "`n"
        Remove-Item -Path "$TF_PLAN_OUT.json"
        Write-Output "==> ($MODULE_NAME) - Removed file: $TF_PLAN_OUT.json"
    }
    else {
        Write-Warning -Message "($MODULE_NAME) - $TF_PLAN_OUT.json  can contain sensitive data"
        Write-Warning -Message "($MODULE_NAME) - Exposing $TF_PLAN_OUT.json in a repository can cause security breach"
        Write-Output "`n"
        Write-Output "($MODULE_NAME) - From within your terraform root module: conftest test $TF_PLAN_OUT.json -p ../../opa/policy/  -d $BASELINE_VALUES.json"
        Write-Output "`n"
    }
    if ($CLEANUP -and $GENERATE_AUTO_TFVARS) {
        Remove-Item -Path $AUTO_TFVARS_OUT
        Write-Output "==> ($MODULE_NAME) - Removed file: $AUTO_TFVARS_OUT"
    }
    elseif ($GENERATE_AUTO_TFVARS) {
        Write-Output "($MODULE_NAME) - Consider deleting $AUTO_TFVARS_OUT to avoid unexpected planned values."
        Write-Output "`n"
    }

    Write-Output "==> ($MODULE_NAME) - Return to scripts directory..."
    Set-Location $MODULE_BASE_PATH

}
