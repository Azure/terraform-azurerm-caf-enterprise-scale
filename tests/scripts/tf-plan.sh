#!/usr/bin/bash
set -e

#
# Shell Script
# - Terraform Plan
#

TF_WORKSPACE="$PIPELINE_WORKSPACE/s/$TEST_MODULE_PATH"
TF_PLAN_OUT="$TF_WORKSPACE/terraform-plan-$TF_VERSION-$TF_AZ_VERSION"
TF_STATE="../tfstate/terraform-$TF_VERSION-$TF_AZ_VERSION.tfstate"

echo "==> Switching directories..."
cd "$TF_WORKSPACE"

echo "==> Planning infrastructure..."
terraform plan \
    -var "root_id=$TF_ROOT_ID" \
    -var "root_name=ES-$TF_VERSION-$TF_AZ_VERSION" \
    -var "primary_location=$PRIMARY_LOCATION" \
    -var "secondary_location=$SECONDARY_LOCATION" \
    -state="$TF_STATE" \
    -out="$TF_PLAN_OUT"

echo "==> Convert plan to JSON..."
terraform show -json "$TF_PLAN_OUT" >"$TF_PLAN_OUT".json

echo "==> List all plan to JSON..."
find . -name "*.json"
