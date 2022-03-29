#!/usr/bin/bash
set -e

#
# Shell Script
# - Terraform Prepare
#

CREDENTIALS_WORKSPACE="$PIPELINE_WORKSPACE/s/tests"

echo "==> Switching directories..."
cd "$CREDENTIALS_WORKSPACE"

echo "==> Authenticating cli..."
az login \
  --service-principal \
  --tenant "$ARM_TENANT_ID" \
  --username "$ARM_CLIENT_ID" \
  --password "$ARM_CLIENT_SECRET" \
  --query [?isDefault]

echo "==> Creating SPN and Role Assignments..."
SPN_NAME="ES-TestFramework-Job$TF_JOB_ID"
KEY_VAULT_NAME="$DEFAULT_PREFIX-kv"
CERTIFICATE_CLIENT_ID=$(
  az ad sp create-for-rbac \
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
shred -uz "$SPN_NAME.pem"

echo "==> Storing Client Certificate Details"
echo "##vso[task.setvariable variable=ARM_CERTIFICATE_CLIENT_ID;]$CERTIFICATE_CLIENT_ID"
echo "##vso[task.setvariable variable=ARM_CERTIFICATE_PATH;]$CREDENTIALS_WORKSPACE/$SPN_NAME.pfx"
echo "##vso[task.setvariable variable=ARM_CERTIFICATE_PASSWORD;]$CERTIFICATE_PASSWORD"

echo "==> Terraform Variable (Root ID)   - $TF_ROOT_ID"
echo "==> Terraform Version              - $TF_VERSION"
echo "==> Terraform Provider Version     - $TF_AZ_VERSION"
echo "==> Terraform Variable (Root Name) - ES-$TF_VERSION-$TF_AZ_VERSION"
