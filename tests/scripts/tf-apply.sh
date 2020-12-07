#!/usr/bin/bash

echo "==> Switching directory..."
cd $PWD/tests/deployment

echo "==> Applying terraform..."
terraform apply \
    -auto-approve \
    -parallelism=256 \
    -state="./terraform_$(TF_VERSION)_$(TF_AZ_VERSION).tfstate" \
    "terraform_plan_$(TF_VERSION)_$(TF_AZ_VERSION)"