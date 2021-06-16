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
sed -e 's:root-id-1:'"$ROOT_ID_1"':g' \
    -e 's:root-id-2:'"$ROOT_ID_2"':g' \
    -e 's:root-id-3:'"$ROOT_ID_3"':g' \
    -e 's:root-name:'"ES-${TF_VERSION}-${TF_AZ_VERSION}"':g' \
    -e 's:eastus:'"$LOCATION"':g' planned_values_template.yml >"$TF_PLAN_JSON"_planned_values.yml

echo "==> Update root-id values..."
id_1='$ROOT_ID_1' id_2=$ROOT_ID_2 id_3=$ROOT_ID_3 yq eval '(.child_modules[].resources[] |= select(.address == "*root_id_1*").values.name = strenv(id_1)) | (.child_modules[].resources[] |= select(.address == "*root_id_2*").values.name = strenv(id_2))| (.child_modules[].resources[] |= select(.address == "*root_id_3*").values.name = strenv(id_3))' -i "$TF_PLAN_JSON"_planned_values.yml

echo "==> Test Conftest..."
which conftest
echo "$TF_PLAN_JSON"
conftest

echo "==> Running conftest..."
cd "$PIPELINE_WORKSPACE/s/tests/deployment"
conftest test "$TF_PLAN_JSON".json -p ../opa/policy -d ../opa/policy/"$TF_PLAN_JSON"_planned_values.yml
