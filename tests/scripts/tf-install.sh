#!/usr/bin/bash

echo "==> Downloading archive..."
wget 'https://releases.hashicorp.com/terraform/0.14.0/terraform_'$TF_VERSION'_linux_amd64.zip' -P /tmp

echo "==> Expanding archive..."
unzip '/tmp/terraform_'$TF_VERSION'_linux_amd64.zip' -d /tmp

echo "==> Moving binaries..."
mv /tmp/terraform /usr/local/bin/
