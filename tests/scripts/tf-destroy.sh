#!/usr/bin/bash

echo "==> Switching directory..."
cd $PWD/tests/deployment

echo "==> Destroying terraform..."
terraform destroy \
    -var "root_id=${{ steps.root_id.outputs.root_id }}" \
    -var "root_name=ES-'$TF_VERSION'-'$TF_AZ_VERSION'" \
    -auto-approve \
    -parallelism=256 \
    -state="./terraform_'$TF_VERSION'_'$TF_AZ_VERSION'.tfstate"