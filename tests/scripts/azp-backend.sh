#!/usr/bin/bash
set -e

#
# Shell Script
# - Terraform Create or Update Azure Backend Storage
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
    --location "$PRIMARY_LOCATION" \
    --query 'properties.provisioningState' \
    --out tsv

# Set STORAGE_ACCOUNT_RSG_NAME to an output variable for downstream consumption.
echo "##vso[task.setVariable variable=STORAGE_ACCOUNT_RSG_NAME;isOutput=true]$RSG_NAME"

echo "==> Create or update Storage Account..."
# Storage account name must be lowercase alphanumeric
SA_NAME=$(
    echo "$DEFAULT_PREFIX$PRIMARY_LOCATION" |
        tr '[:upper:]' '[:lower:]' |
        tr -cd '[:alnum:]'
)
SA_ID=$(
    az storage account create \
        --name "$SA_NAME" \
        --resource-group "$RSG_NAME" \
        --location "$PRIMARY_LOCATION" \
        --kind 'StorageV2' \
        --access-tier 'Hot' \
        --sku 'Standard_LRS' \
        --min-tls-version 'TLS1_2' \
        --query 'id' \
        --out tsv
)

# Set STORAGE_ACCOUNT_NAME to an output variable for downstream consumption.
echo "##vso[task.setVariable variable=STORAGE_ACCOUNT_NAME;isOutput=true]$SA_NAME"

echo "==> Create or update Storage Account permissions..."
az role assignment create \
    --role 'Storage Blob Data Contributor' \
    --assignee "$ARM_CLIENT_ID" \
    --scope "$SA_ID"

echo "==> Create or update Storage Account container..."
SC_NAME="tfstate"
az storage container create \
    --name "$SC_NAME" \
    --auth-mode 'login' \
    --account-name "$SA_NAME" \
    --query 'created' \
    --out tsv

# Set STORAGE_CONTAINER_NAME to an output variable for downstream consumption.
echo "##vso[task.setVariable variable=STORAGE_CONTAINER_NAME;isOutput=true]$SC_NAME"
