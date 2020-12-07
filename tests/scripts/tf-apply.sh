#!/usr/bin/bash

echo "==> Switching directories..."
cd $PWD/tests/deployment

echo "==> Applying infrastructure..."
terraform apply \
    -auto-approve \
    -parallelism=256 \
    -state="./terraform-$TF_VERSION-$TF_AZ_VERSION.tfstate" \
    "terraform-plan-$TF_VERSION-$TF_AZ_VERSION"