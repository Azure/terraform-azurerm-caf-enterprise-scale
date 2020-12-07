#!/usr/bin/bash

echo "==> Switching directories..."
cd $PWD/tests/deployment

echo "==> Destroying infrastructure..."
echo "==> Root ID - $TF_ROOT_ID"
echo "==> Root Name - ES-$TF_VERSION-$TF_AZ_VERSION"
terraform destroy \
    -var "root_id=$TF_ROOT_ID" \
    -var "root_name=ES-$TF_VERSION-$TF_AZ_VERSION" \
    -auto-approve \
    -parallelism=256 \
    -state="./terraform-$TF_VERSION-$TF_AZ_VERSION.tfstate"