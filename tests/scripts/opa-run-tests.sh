#!/usr/bin/bash
set -e

#
# Shell Script
# - OPA Run Tests
#
# # Parameters
TF_PLAN_JSON="tfplan-$TF_VERSION-$TF_AZ_VERSION.json"

echo "==> Switching directories..."
cd "$PIPELINE_WORKSPACE/s/tests/deployment"

echo "==> Convert plan to JSON..."
terraform show -json "$TF_PLAN_JSON"

echo "==> Load planned values..."
cat planned_values.yml.template | sed 'root_id_1' | sed 'root_id_2' >planned_values.yml

echo "==> Running conftest..."
conftest test "$TF_PLAN_JSON" \
    -p ../opa/policy \
    -d ../opa/policy/planned_values.yml

#echo "==> Saving test results..."
