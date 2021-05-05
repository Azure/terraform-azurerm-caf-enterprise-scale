#!/usr/bin/bash
set -e

#
# Shell Script
# - Terraform Prepare
#

echo "==> Switching directories..."
cd "$PIPELINE_WORKSPACE/s/tests/deployment"

echo "==> Authenticating cli..."
az login \
    --service-principal \
    --tenant "$ARM_TENANT_ID" \
    --username "$ARM_CLIENT_ID" \
    --password "$ARM_CLIENT_SECRET"

echo "==> Creating SPN and Role Assignments..."
SPN_NAME="ES-TestFramework-Job$TF_JOB_ID"
KEY_VAULT_NAME="$DEFAULT_PREFIX-kv"
CERTIFICATE_CLIENT_ID=$(az ad sp create-for-rbac \
    --name "$SPN_NAME" \
    --role "Owner" \
    --scope "/providers/Microsoft.Management/managementGroups/$ARM_TENANT_ID" \
    --keyvault "$KEY_VAULT_NAME" \
    --cert "$SPN_NAME" \
    --only-show-errors \
    --query 'appId' \
    --out tsv
)

echo "==> Retrieving SPN certificate for authentication..."
az keyvault secret download \
    --file "$SPN_NAME.pem" \
    --vault-name "$KEY_VAULT_NAME" \
    --name "$SPN_NAME"

echo "==> Generating SPN certificate password..."
CERTIFICATE_PASSWORD='estf-'"$RANDOM"'-'"$RANDOM"'-'"$RANDOM"'-'"$RANDOM"'-pwd'

echo "==> Converting SPN certificate to PFX..."
openssl pkcs12 \
    -export \
    -in "$SPN_NAME.pem" \
    -out "$SPN_NAME.pfx" \
    -passout pass:"$CERTIFICATE_PASSWORD"

echo "==> Deleting SPN certificate in PEM format..."
rm "$SPN_NAME.pem"

echo "==> Creating provider.tf with required_provider version and credentials..."
cat > provider.tf <<TFCONFIG
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "$TF_AZ_VERSION"
    }
  }
}

provider "azurerm" {
  features {}

  subscription_id             = "$ARM_SUBSCRIPTION_ID"
  client_id                   = "$CERTIFICATE_CLIENT_ID"
  client_certificate_path     = "$SPN_NAME.pfx"
  client_certificate_password = "$CERTIFICATE_PASSWORD"
  tenant_id                   = "$ARM_TENANT_ID"
}
TFCONFIG

echo "==> Generating root id's..."
ROOT_ID_1="$RANDOM"
ROOT_ID_2="$RANDOM"
ROOT_ID_3="$RANDOM"

echo "==> Azure Root ID 1 - $ROOT_ID_1"
echo "##vso[task.setvariable variable=TF_ROOT_ID_1;]$ROOT_ID_1"

echo "==> Azure Root ID 2 - $ROOT_ID_2"
echo "##vso[task.setvariable variable=TF_ROOT_ID_2;]$ROOT_ID_2"

echo "==> Azure Root ID 3 - $ROOT_ID_3"
echo "##vso[task.setvariable variable=TF_ROOT_ID_3;]$ROOT_ID_3"

echo "==> Displaying environment variables..."
echo "==> Terraform Version - $TF_VERSION"
echo "==> Terraform Provider Version - $TF_AZ_VERSION"
echo "==> Terraform Variable (Root Name) - ES-$TF_VERSION-$TF_AZ_VERSION"
