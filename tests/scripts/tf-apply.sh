#!/usr/bin/bash
set -e

#
# Shell Script
# - Terraform Apply
#

TF_WORKSPACE="$PIPELINE_WORKSPACE/s/$TEST_MODULE_PATH"
TF_PLAN_OUT="$TF_WORKSPACE/terraform-plan-$TF_VERSION-$TF_AZ_VERSION"
TF_STATE="../tfstate/terraform-$TF_VERSION-$TF_AZ_VERSION.tfstate"

echo "==> Switching directories..."
cd "$TF_WORKSPACE"

echo "==> Applying infrastructure..."
TF_APPLY_ATTEMPTS=1
while [[ TF_APPLY_ATTEMPTS -lt 6 && $? -ne 1 ]]; do
  echo "==> Attempt $TF_APPLY_ATTEMPTS"
  terraform apply \
    -auto-approve \
    -parallelism="$PARALLELISM" \
    -state="$TF_STATE" \
    "$TF_PLAN_OUT"

  TF_APPLY_ATTEMPTS=$((TF_APPLY_ATTEMPTS + 1))
done

