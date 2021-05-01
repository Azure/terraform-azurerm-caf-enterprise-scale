#!/usr/bin/bash
set -e

#
# Shell Script
# - Terraform Plan
#

echo "==> Switching directories..."
cd "$PIPELINE_WORKSPACE/s/tests/deployment"

echo "==> Authenticating cli..."
az login \
    --service-principal \
    --tenant "$ARM_TENANT_ID" \
    --username "$ARM_CLIENT_ID" \
    --password "$ARM_CLIENT_SECRET"

echo "==> Check Azure AD replication of SPN credentials..."
echo " CERTIFICATE_THUMBPRINT_FROM_PFX   : $CERTIFICATE_THUMBPRINT_FROM_PFX"
LOOP_COUNTER=0
CERTIFICATE_THUMBPRINT_FROM_AZ_AD=""
while [ $LOOP_COUNTER -lt 10 ]
do
    CERTIFICATE_THUMBPRINT_FROM_AZ_AD=$(az ad sp credential list \
        --id "$CERTIFICATE_CLIENT_ID" \
        --cert \
        | jq -r '.[].customKeyIdentifier' \
        2> /dev/null
        )
    echo " CERTIFICATE_THUMBPRINT_FROM_AZ_AD : $CERTIFICATE_THUMBPRINT_FROM_AZ_AD"
    # Need to prefix the thumbprints with a letter to ensure
    # string comparison when value starts with a digit.
    if [[ "A$CERTIFICATE_THUMBPRINT_FROM_AZ_AD" -eq "A$CERTIFICATE_THUMBPRINT_FROM_PFX" ]]
    then
      break
    fi
    echo " Sleep for 10 seconds..."
    sleep 10s
    LOOP_COUNTER=$((LOOP_COUNTER + 1))
done

echo "==> Planning infrastructure..."
terraform plan \
    -var "root_id_1=$TF_ROOT_ID_1" \
    -var "root_id_2=$TF_ROOT_ID_2" \
    -var "root_id_3=$TF_ROOT_ID_3" \
    -var "root_name=ES-$TF_VERSION-$TF_AZ_VERSION" \
    -parallelism=256 \
    -state="./terraform-$TF_VERSION-$TF_AZ_VERSION.tfstate" \
    -out="terraform-plan-$TF_VERSION-$TF_AZ_VERSION"