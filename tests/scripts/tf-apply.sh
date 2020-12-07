#!/usr/bin/bash

echo "==> Switching directory..."
cd $PWD/tests/deployment

echo "==> Applying terraform..."
terraform apply \
    -auto-approve \
    -parallelism=256 \
    -state="./terraform_${{ matrix.terraform_version }}_${{ matrix.azurerm_version }}.tfstate" \
    "terraform_plan_${{ matrix.terraform_version }}_${{ matrix.azurerm_version }}"