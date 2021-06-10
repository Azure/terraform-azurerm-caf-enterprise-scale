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
    cat <planned_values_template.yml
sed -e 's:root-id-1:'"${ROOT_ID_1}"':g' \
    -e's:root-id-2:'"${ROOT_ID_2}"':g' \
    -e 's:root-id-3:'"${ROOT_ID_3}"':g' \
    -e 's:root-name:'"${ROOT_NAME}"':g' \
    -e's:eastus:'"${LOCATION}"':g' >planned_values.yml

echo "==> Running conftest..."
cd ../../deployment &&
    conftest test "$TF_PLAN_JSON.json" \
        -p ../opa/policy \
        -d ../opa/policy/planned_values.yml
