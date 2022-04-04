#!/usr/bin/pwsh

#
# PowerShell Script
# - Conftest Install
#

# Install Scoop
if (Get-command -name scoop -ErrorAction SilentlyContinue) {
    Write-Output "==> Scoop exists, skip install"
    scoop --version
    scoop update
}
else {
    Write-Output "`n"
    Write-Output "==> To run Conftest tests on Windows, some utilities need to be installed with Scoop"
    Write-Output "==> To install Scoop on Windows, run this command from a new terminal:"
    Write-Output "`n"
    Write-Output "Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https:\\get.scoop.sh')"
    Write-Output "`n"
    Write-Output "==> After installing Scoop, run: ./opa-values-generator.ps1"
    Write-Output "`n"
    exit
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

# Install Conftest
if (Get-command -name conftest -ErrorAction SilentlyContinue) {
    Write-Output "==> conftest exists, skip install"
    conftest --version
}
else {
    Write-Output "==> Install conftest on Windows..."
    scoop bucket add instrumenta https://github.com/instrumenta/scoop-instrumenta
    scoop install conftest
}
