#!/usr/bin/env bash
set -e

#
# Shell Script
# - OPA Run Tests
#
# # Parameters
TF_PLAN_JSON="terraform-plan-$TF_VERSION-$TF_AZ_VERSION"

echo "==> Load planned values..."
cd "$PIPELINE_WORKSPACE/s/tests/opa/policy"
sed -e 's:root-id-1:'"${TF_ROOT_ID_1}"':g' \
    -e 's:root-id-2:'"${TF_ROOT_ID_2}"':g' \
    -e 's:root-id-3:'"${TF_ROOT_ID_3}"':g' \
    -e 's:root-name:'"ES-${TF_VERSION}-${TF_AZ_VERSION}"':g' \
    -e 's:eastus:'"$LOCATION"':g' planned_values_template.yml >"$TF_PLAN_JSON"_planned_values.yml

echo "==> Azure Root ID 1 - $ROOT_ID_1"
echo "==> Azure {TF_ROOT_ID_1} - ${TF_ROOT_ID_1}"
echo "==> Azure TF_ROOT_ID_1 - $TF_ROOT_ID_1"

cat <"$TF_PLAN_JSON"_planned_values.yml

echo "==> Get Conftest..."
which conftest
echo "$TF_PLAN_JSON"
conftest

echo "==> Running conftest..."
cd "$PIPELINE_WORKSPACE/s/tests/deployment"

echo "==> Testing management groups..."
conftest test "$TF_PLAN_JSON".json -p ../opa/policy/ ../opa/policy/"$TF_PLAN_JSON"_planned_values.yml

cat <"$TF_PLAN_JSON".json
