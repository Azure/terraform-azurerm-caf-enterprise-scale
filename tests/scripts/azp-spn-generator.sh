#!/usr/bin/bash
set -e

#
# Shell Script
# - Terraform Create or Update SPNs
#

echo "==> Authenticating cli..."
az login \
    --service-principal \
    --tenant "$ARM_TENANT_ID" \
    --username "$ARM_CLIENT_ID" \
    --password "$ARM_CLIENT_SECRET" \
    --query [?isDefault]

echo "==> Setting active Subscription..."
az account set \
    --subscription "$ARM_SUBSCRIPTION_ID"
az account list \
    --query "[?isDefault]"

echo "==> Create or update Resource Group..."
RSG_NAME="$DEFAULT_PREFIX"
az group create \
    --name "$RSG_NAME" \
    --location "$DEFAULT_LOCATION" \
    --query 'properties.provisioningState' \
    --out tsv

# The following logic is needed since idempotency was
# removed from the command az keyvault create in PR:
# https://github.com/Azure/azure-cli/pull/18520
# Issue raised to request fix:
# https://github.com/Azure/azure-cli/issues/19165
echo "==> Create or update Key Vault..."
KEY_VAULT_NAME="$DEFAULT_PREFIX-kv"
KV_EXISTS=$(
    az keyvault list \
        --query "[?name=='$KEY_VAULT_NAME'].name" \
        --out tsv
)
if [ -z "$KV_EXISTS" ]; then
    az keyvault create \
        --resource-group "$RSG_NAME" \
        --name "$KEY_VAULT_NAME" \
        --location "$DEFAULT_LOCATION" \
        --query 'properties.provisioningState' \
        --out tsv
else
    echo "The specified vault: $KEY_VAULT_NAME already exists (skipping)"
fi

echo "==> Create or update SPNs with Role Assignments..."
for i in {1..10}; do
    echo "[SPN ID $i] Processing SPN..."
    SPN_NAME="ES-TestFramework-Job$i"
    CERTIFICATE_PATH_PEM=$(
        az ad sp create-for-rbac \
            --name "$SPN_NAME" \
            --role "Owner" \
            --scope "/providers/Microsoft.Management/managementGroups/$ARM_TENANT_ID" \
            --create-cert \
            --only-show-errors \
            --query 'fileWithCertAndPrivateKey' \
            --out tsv
    )

    echo "[SPN ID $i] Upload certificate to Key Vault... ($CERTIFICATE_PATH_PEM)"
    CERTIFICATE_NAME=$(
        az keyvault certificate import \
            --file "$CERTIFICATE_PATH_PEM" \
            --vault-name "$KEY_VAULT_NAME" \
            --name "$SPN_NAME" \
            --query 'name' \
            --out tsv
    )
    echo "[SPN ID $i] Upload certificate complete... ($CERTIFICATE_NAME)"

    echo "[SPN ID $i] Delete certificate from local storage... ($CERTIFICATE_PATH_PEM)"
    rm "$CERTIFICATE_PATH_PEM"
done
