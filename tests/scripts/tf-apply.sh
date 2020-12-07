#!/usr/bin/bash

echo "==> Switching directory..."
cd $PWD/tests/deployment

echo "==> Applying terraform..."
terraform apply \
    -auto-approve \
    -parallelism=256 \
    -state="./terraform-$TF_VERSION-$TF_AZ_VERSION.tfstate" \
    "terraform-plan-$TF_VERSION-$TF_AZ_VERSION"