#!/usr/bin/bash

#
# Shell Script
# - Terraform Destroy
#

echo "==> Switching directories..."
cd $PWD/tests/deployment

echo "==> Destroying infrastructure..."
terraform destroy \
    -var "root_id_1=$TF_ROOT_ID_1" \
    -var "root_id_2=$TF_ROOT_ID_2" \
    -var "root_id_3=$TF_ROOT_ID_3" \
    -var "root_name=ES-$TF_VERSION-$TF_AZ_VERSION" \
    -auto-approve \
    -parallelism=256 \
    -state="./terraform-$TF_VERSION-$TF_AZ_VERSION.tfstate"
status=$?

if test $status -ne 0

    echo "==> Authenticating cli..."
    az login \
        --service-principal \
        --tenant $ARM_TENANT_ID \
        --username $ARM_APPLICATION_ID \
        --password $ARM_CLIENT_SECRET
    
    echo "==> Destroying infrastructure..."
    az account management-group list \
        --output json \
        | jq '.[] | select(.displayName | contains("ES-"))'

fi
