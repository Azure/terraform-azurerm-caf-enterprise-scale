#!/usr/bin/bash
set -e

#
# Shell Script
# - OPA Run Tests
#
# # Parameters
TF_PLAN_JSON="terraform-plan-$TF_VERSION-$TF_AZ_VERSION"

echo "==> Convert plan to JSON..."
cd ../deployment && terraform show -json "$TF_PLAN_JSON" >"$TF_PLAN_JSON".json

echo "==> Load planned values..."
cd ../opa/policy &&
    <planned_values_template.yml |
    sed -e 's:root-id-1:'"${root_id_1}"':g' \
        -e's:root-id-2:'"${root_id_2}"':g' \
        -e 's:root-id-3:'"${root_id_3}"':g' \
        -e 's:root-name:'"${root_name}"':g' \
        -e's:eastus:'"${location}"':g' >planned_values.yml

echo "==> Running conftest..."
cd ../../deployment &&
    conftest test "$TF_PLAN_JSON.json" \
        -p ../opa/policy \
        -d ../opa/policy/planned_values.yml
