#!/usr/bin/env bash
set -e

#
# Shell Script
# - OPA Run Tests
#
# # Parameters
TF_WORKSPACE="$PIPELINE_WORKSPACE/s/$TEST_MODULE_PATH"
TF_PLAN_OUT="$TF_WORKSPACE/terraform-plan-$TF_VERSION-$TF_AZ_VERSION"

# # # Store data temporarily
TEMP_FILE_01=$(mktemp).json
TEMP_FILE_02=$(mktemp).json

# # # Update the planned_values.json with the latest parameters
echo "==> Update planned values..."
cd "$TF_WORKSPACE"
jq '(.. | strings) |= gsub("root-id-1"; "'"$TF_ROOT_ID"'")' planned_values.json >"$TEMP_FILE_01"
jq '(.. | strings) |= gsub("root-name"; "ES-'"$TF_VERSION"'-'"$TF_AZ_VERSION"'")' "$TEMP_FILE_01" >"$TEMP_FILE_02"
jq '(.. | strings) |= gsub("northeurope"; "northeurope")' "$TEMP_FILE_02" >"$TEMP_FILE_01"
jq '(.. | strings) |= gsub("westeurope"; "westeurope")' "$TEMP_FILE_01" >"$TF_PLAN_OUT"_updated_planned_values.json

echo "==> Module Locations - $PRIMARY_LOCATION ($SECONDARY_LOCATION)"
echo "==> Azure {TF_ROOT_ID} - ${TF_ROOT_ID}"
echo "==> Azure TF_ROOT_ID - $TF_ROOT_ID"

wait

echo "==> Converting to yaml..."
yq <"$TF_PLAN_OUT"_updated_planned_values.json e -P - >"$TF_PLAN_OUT"_updated_planned_values.yml

wait

echo "==> Check yaml for errors..."
yamllint -d relaxed "$TF_PLAN_OUT"_updated_planned_values.yml

echo "==> Running conftest..."
echo
echo "==> Testing management_groups..."
conftest test "$TF_PLAN_OUT".json -p ../../opa/policy/management_groups.rego -d "$TF_PLAN_OUT"_updated_planned_values.yml
echo
echo "==> Testing role_definitions..."
conftest test "$TF_PLAN_OUT".json -p ../../opa/policy/role_definitions.rego -d "$TF_PLAN_OUT"_updated_planned_values.yml
echo
echo "==> Testing role_assignments..."
conftest test "$TF_PLAN_OUT".json -p ../../opa/policy/role_assignments.rego -d "$TF_PLAN_OUT"_updated_planned_values.yml
echo
echo "==> Testing policy_set_definitions..."
conftest test "$TF_PLAN_OUT".json -p ../../opa/policy/policy_set_definitions.rego -d "$TF_PLAN_OUT"_updated_planned_values.yml
echo
echo "==> Testing policy_definitions..."
conftest test "$TF_PLAN_OUT".json -p ../../opa/policy/policy_definitions.rego -d "$TF_PLAN_OUT"_updated_planned_values.yml
echo
echo "==> Testing policy_assignments..."
conftest test "$TF_PLAN_OUT".json -p ../../opa/policy/policy_assignments.rego -d "$TF_PLAN_OUT"_updated_planned_values.yml
