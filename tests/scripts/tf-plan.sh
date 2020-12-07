#!/usr/bin/bash

echo "==> Switching directory..."
cd $PWD/tests/deployment

echo "==> Planning terraform..."
echo "==> Root ID - $TF_ROOT_ID"
echo "==> Root Name - ES-$TF_VERSION-$TF_AZ_VERSION"
terraform plan \
    -var "root_id=$TF_ROOT_ID" \
    -var "root_name=ES-$TF_VERSION-$TF_AZ_VERSION" \
    -parallelism=256 \
    -state="./terraform-$TF_VERSION-$TF_AZ_VERSION.tfstate" \
    -out="terraform-plan-$TF_VERSION-$TF_AZ_VERSION"