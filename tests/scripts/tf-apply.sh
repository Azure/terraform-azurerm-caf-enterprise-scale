#!/usr/bin/bash

#
# Shell Script
# - Terraform Apply
#

TF_WORKSPACE="$PIPELINE_WORKSPACE/s/$TEST_MODULE_PATH"
TF_STATE="../tfstate/terraform-$TF_VERSION-$TF_AZ_VERSION.tfstate"

echo "==> Switching directories..."
cd "$TF_WORKSPACE" || exit

echo "==> Applying infrastructure..."
TF_APPLY_ATTEMPTS=1
TF_EXIT_CODE=1
while [[ $TF_APPLY_ATTEMPTS -lt 6 && $TF_EXIT_CODE -ne 0 ]]; do
  echo "==> Attempt $TF_APPLY_ATTEMPTS"
  terraform apply \
    -auto-approve \
    -parallelism="$PARALLELISM" \
    -var "root_id=$TF_ROOT_ID" \
    -var "root_name=ES-$TF_VERSION-$TF_AZ_VERSION" \
    -var "primary_location=$PRIMARY_LOCATION" \
    -var "secondary_location=$SECONDARY_LOCATION" \
    -state="$TF_STATE"

  TF_EXIT_CODE=$?
  TF_APPLY_ATTEMPTS=$((TF_APPLY_ATTEMPTS + 1))
  echo "==> Terraform apply exit code: $TF_EXIT_CODE. Attempt $TF_APPLY_ATTEMPTS"
done

