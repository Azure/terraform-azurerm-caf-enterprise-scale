#!/usr/bin/bash

echo "==> Switching directory..."
cd $PWD/tests/deployment

echo "==> Destroying terraform..."
terraform destroy \
    -var "root_id=${{ steps.root_id.outputs.root_id }}" \
    -var "root_name=ES-${{ matrix.terraform_version }}-${{ matrix.azurerm_version }}" \
    -auto-approve \
    -parallelism=256 \
    -state="./terraform_${{ matrix.terraform_version }}_${{ matrix.azurerm_version }}.tfstate"