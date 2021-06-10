#############################################
### # # Opa Values Generator
#############################################


# # Parameters
$PLAN_NAME = "terraform-plan"


# Install Scoop
if (Get-command scoop) {
    Write-Information "==> Scoop exists, skip install"
    scoop --version
}
else {
    Write-Information "==> Install Scoop on Windows..."
    Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
}

# Install Terraform
if (Get-command -name terraform -ErrorAction SilentlyContinue) {
    Write-Information "==> Terraform exists, skip install"
    terraform version
}
else {
    Write-Information "==> Install Terraform on Windows..."
    scoop install terraform
}

# Install jq
if (Get-command -name jq -ErrorAction SilentlyContinue) {
    Write-Information "==> jq exists, skip install"
    jq --version
}
else {
    Write-Information "==> Install jq on Windows..."
    scoop install jq
}

# Install yq
if (Get-command -name yq -ErrorAction SilentlyContinue) {
    Write-Information "==> yq exists, skip install"
    yq --version
}
else {
    Write-Information "==> Install yq on Windows..."
    scoop install yq
}

# Install Conftest
if (Get-command -name conftest -ErrorAction SilentlyContinue) {
    Write-Information "==> conftest exists, skip install"
    conftest --version
}
else {
    Write-Information "==> Install conftest on Windows..."
    scoop install conftest
}

Write-Information "==> Change to the module root directory..."
Set-Location ..\deployment

Write-Information "==> Initializing infrastructure..."
terraform init

Write-Information "==> Planning infrastructure..."
terraform plan `
    -var="root_id_1=root-id-1" `
    -var="root_id_2=root-id-2" `
    -var="root_id_3=root-id-3" `
    -var="root_name=root-name" `
    -var="location=eastus" `
    -out=$PLAN_NAME

Write-Information "==> Converting plan to *.json..."
terraform show -json $PLAN_NAME | Out-File -FilePath .\$PLAN_NAME.json

Write-Information "==> Removing the original plan..."
Remove-Item -Path .\$PLAN_NAME

Write-Information "==> Saving planned values to a temporary planned_values.json..."
Get-Content -Path .\$PLAN_NAME.json | jq '.planned_values.root_module' | Out-File -FilePath .\planned_values.json

Write-Information "==> Converting to yaml..."
Get-Content -Path .\planned_values.json | yq e -P - | Tee-Object ..\opa\policy\planned_values_template.yml

Write-Information "==> Removing the temporary planned_values.json..."
Remove-Item -Path .\planned_values.json

$CONFIRM = Read-Host "Do you want to remove terraform-plan.json (y/n)?"
if ($CONFIRM -eq 'y') {
    Remove-Item -Path .\terraform-plan.json
    Write-Output "$PLAN_NAME.json has been removed from your root module" 
}
else {
    Write-Warning -Message "$PLAN_NAME.json  can contain sensitive data" 
    Write-Warning -Message  "Exposing $PLAN_NAME.json in a repository can cause security breach" 
    Write-Host "From within your terraform root module:" -NoNewline
    Write-Host " conftest test $PLAN_NAME.json -p ../opa/policy/  -d ../opa/policy/planned_values_template.yml" -ForegroundColor Green
}