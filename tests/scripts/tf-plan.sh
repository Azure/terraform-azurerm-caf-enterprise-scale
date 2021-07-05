#!/usr/bin/bash
set -e

#
# Shell Script
# - Terraform Plan
#
TF_PLAN_JSON="terraform-plan-$TF_VERSION-$TF_AZ_VERSION"

echo "==> Switching directories..."
cd "$PIPELINE_WORKSPACE/s/tests/deployment"

echo "==> Planning infrastructure..."
terraform plan \
    -var "location=$DEFAULT_LOCATION" \
    -var "root_id_1=$TF_ROOT_ID_1" \
    -var "root_id_2=$TF_ROOT_ID_2" \
    -var "root_id_3=$TF_ROOT_ID_3" \
    -var "root_name=ES-$TF_VERSION-$TF_AZ_VERSION" \
    -state="./terraform-$TF_VERSION-$TF_AZ_VERSION.tfstate" \
    -out="terraform-plan-$TF_VERSION-$TF_AZ_VERSION"

echo "==> Convert plan to JSON..."
cd "$PIPELINE_WORKSPACE/s/tests/deployment" && terraform show -json "$TF_PLAN_JSON" >"$TF_PLAN_JSON".json

echo "==> List all plan to JSON..."
cd "$PIPELINE_WORKSPACE/s/tests/deployment" && find . -name "*.json"
