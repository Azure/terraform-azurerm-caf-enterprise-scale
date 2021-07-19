#!/usr/bin/bash
set -e

#
# Shell Script
# - Terraform Install
#

echo "==> Creating directory..."
mkdir -p /home/vsts/.terraform/bin/

echo "==> Downloading archive..."
wget 'https://releases.hashicorp.com/terraform/'"$TF_VERSION"'/terraform_'"$TF_VERSION"'_linux_amd64.zip' -P /tmp

echo "==> Expanding archive..."
unzip '/tmp/terraform_'"$TF_VERSION"'_linux_amd64.zip' -d /tmp

echo "==> Moving binaries..."
mv /tmp/terraform /home/vsts/.terraform/bin/terraform

echo "==> Exporting path..."
echo "##vso[task.prependpath]/home/vsts/.terraform/bin"
