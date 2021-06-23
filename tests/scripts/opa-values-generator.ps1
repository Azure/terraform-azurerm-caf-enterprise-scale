###############################################
# Run tests and generate testing values.
###############################################

# Run this locally to test your terraform configuration and generate the values needed for the automation pipeline.
# The script will install all the necessary components locally and run the tests.
# After completing the tests, follow the script prompt for the next steps.


# # Parameters
$PLAN_NAME = "terraform-plan"


# Install Scoop
if (Get-command -name scoop) {
    Write-Output "==> Scoop exists, skip install"
    scoop --version
}
else {
    Write-Output "==> To install Scoop on Windows, run this command from a new terminal:"
    Write-Output "Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https:\\get.scoop.sh')"

}

# Install Terraform
if (Get-command -name terraform -ErrorAction SilentlyContinue) {
    Write-Output "==> Terraform exists, skip install"
    terraform version
}
else {
    Write-Output "==> Install Terraform on Windows..."
    scoop install terraform
}

# Install jq
if (Get-command -name jq -ErrorAction SilentlyContinue) {
    Write-Output "==> jq exists, skip install"
    jq --version
}
else {
    Write-Output "==> Install jq on Windows..."
    scoop install jq
}

# Install yq
if (Get-command -name yq -ErrorAction SilentlyContinue) {
    Write-Output "==> yq exists, skip install"
    yq --version
}
else {
    Write-Output "==> Install yq on Windows..."
    scoop install yq
}

# Install Conftest
if (Get-command -name conftest -ErrorAction SilentlyContinue) {
    Write-Output "==> conftest exists, skip install"
    conftest --version
}
else {
    Write-Output "==> Install conftest on Windows..."
    scoop bucket add instrumenta https:\\github.com\instrumenta\scoop-instrumenta
    scoop install conftest
}

Write-Output "==> Change to the module root directory..."
Set-Location ..\deployment

Write-Output "==> Initializing infrastructure..."
terraform init

Write-Output "==> Planning infrastructure..."
terraform plan `
    -var="root_id_1=root-id-1" `
    -var="root_id_2=root-id-2" `
    -var="root_id_3=root-id-3" `
    -var="root_name=root-name" `
    -var="location=eastus" `
    -out="$PLAN_NAME"

Write-Output "==> Converting plan to *.json..."
terraform show -json $PLAN_NAME | Out-File -FilePath .\$PLAN_NAME.json

Write-Output "==> Removing the original plan..."
Remove-Item -Path .\$PLAN_NAME

Write-Output "==> Saving planned values to a temporary planned_values.json..."
Get-Content -Path .\$PLAN_NAME.json | jq '.planned_values.root_module' | Out-File -FilePath .\planned_values.json

Write-Output "==> Converting to yaml..."
Get-Content -Path .\planned_values.json | yq e -P - | Tee-Object ..\opa\policy\planned_values.yml


# # #  Run OPA Tests
Set-Location ..\deployment
Write-Output "==> Running conftest..."

Write-Output "==> Testing management_groups..."
conftest test "$PLAN_NAME.json" -p ..\opa\policy\management_groups.rego -d ..\opa\policy\planned_values.yml

Write-Output "==> Testing role_definitions..."
conftest test "$PLAN_NAME.json" -p ..\opa\policy\role_definitions.rego -d ..\opa\policy\planned_values.yml

Write-Output "==> Testing role_assignments..."
conftest test "$PLAN_NAME.json" -p ..\opa\policy\role_assignments.rego -d ..\opa\policy\planned_values.yml

Write-Output "==> Testing policy_set_definitions..."
conftest test "$PLAN_NAME.json" -p ..\opa\policy\policy_set_definitions.rego -d ..\opa\policy\planned_values.yml

Write-Output "==> Testing policy_definitions..."
conftest test "$PLAN_NAME.json" -p ..\opa\policy\policy_definitions.rego -d ..\opa\policy\planned_values.yml

Write-Output "==> Testing policy_assignments..."
conftest test "$PLAN_NAME.json" -p ..\opa\policy\policy_assignments.rego -d ..\opa\policy\planned_values.yml

$CONFIRM = Read-Host "Do you want to prepare files for repository (y/n)?"
if ($CONFIRM -eq 'y') {
    Remove-Item -Path .\$PLAN_NAME.json
    Write-Output "$PLAN_NAME.json has been removed from your root module"
    Remove-Item -Path ..\opa\policy\planned_values.yml
    Write-Output "planned_values.yml has been removed from your \opa\policy\ directory"
}
else {
    Write-Warning -Message "$PLAN_NAME.json  can contain sensitive data"
    Write-Warning -Message  "Exposing $PLAN_NAME.json in a repository can cause security breach"
    Write-Output "From within your terraform root module: conftest test $PLAN_NAME.json -p ..\opa\policy\  -d ..\opa\policy\planned_values.yml"
}

