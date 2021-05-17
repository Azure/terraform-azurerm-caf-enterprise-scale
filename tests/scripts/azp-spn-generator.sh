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
    --password "$ARM_CLIENT_SECRET"

echo "==> Create or update Resource Group..."
RSG_NAME="$DEFAULT_PREFIX"
az group create \
    --name "$RSG_NAME" \
    --location "$DEFAULT_LOCATION" \
    --query 'properties.provisioningState' \
    --out tsv

echo "==> Create or update Key Vault..."
KEY_VAULT_NAME="$DEFAULT_PREFIX-kv"
az keyvault create \
    --resource-group "$RSG_NAME" \
    --name "$KEY_VAULT_NAME" \
    --location "$DEFAULT_LOCATION" \
    --query 'properties.provisioningState' \
    --out tsv

echo "==> Create or update SPNs with Role Assignments..."
for i in {1..10}
do
    echo "[SPN ID $i] Processing SPN..."
    SPN_NAME="ES-TestFramework-Job$i"
    CERTIFICATE_PATH_PEM=$(az ad sp create-for-rbac \
        --name "$SPN_NAME" \
        --role "Owner" \
        --scope "/providers/Microsoft.Management/managementGroups/$ARM_TENANT_ID" \
        --create-cert \
        --only-show-errors \
        --query 'fileWithCertAndPrivateKey' \
        --out tsv
    )

    echo "[SPN ID $i] Upload certificate to Key Vault... ($CERTIFICATE_PATH_PEM)"
    CERTIFICATE_NAME=$(az keyvault certificate import \
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
