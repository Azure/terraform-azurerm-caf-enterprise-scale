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
terraform apply \
    -auto-approve \
    -parallelism="$PARALLELISM" \
    -state="$TF_STATE" \
    "$TF_PLAN_OUT"
