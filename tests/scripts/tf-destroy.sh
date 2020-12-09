#!/usr/bin/bash

#
# Shell Script
# - Terraform Destroy
#

echo "==> Switching directories..."
cd $PWD/tests/deployment

echo "==> Destroying infrastructure..."
terraform destroy \
    -var "root_id=$TF_ROOT_ID" \
    -var "root_name=ES-$TF_VERSION-$TF_AZ_VERSION" \
    -auto-approve \
    -parallelism=256 \
    -state="./terraform-$TF_VERSION-$TF_AZ_VERSION.tfstate"