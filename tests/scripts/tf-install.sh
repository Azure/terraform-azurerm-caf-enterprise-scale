#!/usr/bin/bash
set -e

#
# Shell Script
# - Terraform Install
#

case $SCM in
    'AzurePipelines')
        echo "==> Creating directory..."
        mkdir -p /home/runner/.terraform/bin/

        echo "==> Downloading archive..."
        wget 'https://releases.hashicorp.com/terraform/'$TF_VERSION'/terraform_'$TF_VERSION'_linux_amd64.zip' -P /tmp
        
        echo "==> Expanding archive..."
        unzip '/tmp/terraform_'$TF_VERSION'_linux_amd64.zip' -d /tmp
        
        echo "==> Moving binaries..."
        mv /tmp/terraform /home/vsts/.terraform/bin/terraform
        
        echo "==> Exporting path..."
        echo "##vso[task.prependpath]/home/vsts/.terraform/bin"
        ;;
    'GitHubActions')
        echo "==> Creating directory..."
        mkdir -p /home/runner/.terraform/bin/
        
        echo "==> Downloading archive..."
        wget 'https://releases.hashicorp.com/terraform/'$TF_VERSION'/terraform_'$TF_VERSION'_linux_amd64.zip' -P /tmp
        
        echo "==> Expanding archive..."
        unzip '/tmp/terraform_'$TF_VERSION'_linux_amd64.zip' -d /tmp
        
        echo "==> Moving binaries..."
        mv /tmp/terraform /home/runner/.terraform/bin/terraform
        
        echo "==> Exporting path..."
        echo "/home/runner/.terraform/bin" >> $GITHUB_PATH
        ;;
    *)
        echo "==> Unsupported platform..."
        exit 1
        ;;
esac

