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
    --only-show-errors \
    --query 'appId' \
    --out tsv
)

echo "==> Storing Client Certificate Details"
echo "##vso[task.setvariable variable=ARM_CERTIFICATE_CLIENT_ID;]$CERTIFICATE_CLIENT_ID"

echo "==> Terraform Variable (Root ID)   - $TF_ROOT_ID"
echo "==> Terraform Version              - $TF_VERSION"
echo "==> Terraform Provider Version     - $TF_AZ_VERSION"
echo "==> Terraform Variable (Root Name) - ES-$TF_VERSION-$TF_AZ_VERSION"
