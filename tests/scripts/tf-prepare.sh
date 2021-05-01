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
ARM_CLIENT=$(az ad sp create-for-rbac \
    --name "ES-$TF_VERSION-$TF_AZ_VERSION" \
    --role "Owner" \
    --scope "/providers/Microsoft.Management/managementGroups/$ARM_TENANT_ID" \
    --create-cert \
    --only-show-errors
)
CERTIFICATE_PATH_PEM=$(echo "$ARM_CLIENT" | jq -r '.fileWithCertAndPrivateKey')
CERTIFICATE_PATH_PFX=${CERTIFICATE_PATH_PEM//.pem/.pfx}
CERTIFICATE_PASSWORD='estf-'"$RANDOM"'-'"$RANDOM"'-'"$RANDOM"'-'"$RANDOM"'-pwd'
CLIENT_ID=$(echo "$ARM_CLIENT" | jq -r '.appId')
TENANT_ID=$(echo "$ARM_CLIENT" | jq -r '.tenant')

echo "==> Converting SPN certificate to PFX..."
openssl pkcs12 \
    -export \
    -out "$CERTIFICATE_PATH_PFX" \
    -in "$CERTIFICATE_PATH_PEM" \
    -passout pass:"$CERTIFICATE_PASSWORD"

echo "==> Pause to allow Azure AD replication of SPN credentials..."
CERTIFICATE_THUMBPRINT_FROM_AZ_AD=""
CERTIFICATE_THUMBPRINT_FROM_PFX=$(openssl pkcs12 \
    -nodes \
    -in "$CERTIFICATE_PATH_PFX" \
    -passin pass:$CERTIFICATE_PASSWORD \
    | openssl x509 -noout -fingerprint \
    | sed 's:.*=::g' \
    | sed 's/://g'
)

echo " CERTIFICATE_THUMBPRINT_FROM_PFX   : $CERTIFICATE_THUMBPRINT_FROM_PFX"
LOOP_COUNTER=0
while [ $LOOP_COUNTER -lt 10 ]
do
    CERTIFICATE_THUMBPRINT_FROM_AZ_AD=$(az ad sp credential list \
        --id "$CLIENT_ID" \
        --cert \
        | jq -r '.[].customKeyIdentifier'
        )
    echo " CERTIFICATE_THUMBPRINT_FROM_AZ_AD : $CERTIFICATE_THUMBPRINT_FROM_AZ_AD"
    if [[ "$CERTIFICATE_THUMBPRINT_FROM_AZ_AD" -eq "$CERTIFICATE_THUMBPRINT_FROM_PFX" ]]
    then
      break
    fi
    echo " Sleep for 10 seconds..."
    sleep 10s
    LOOP_COUNTER=$((LOOP_COUNTER + 1))
done

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
  client_id                   = "$CLIENT_ID"
  client_certificate_path     = "$CERTIFICATE_PATH_PFX"
  client_certificate_password = "$CERTIFICATE_PASSWORD"
  tenant_id                   = "$TENANT_ID"
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
