#!/usr/bin/env bash
set -e

#
# Shell Script
# - OPA Run Tests
#

# Parameters
TF_WORKSPACE="$PIPELINE_WORKSPACE/s/$TEST_MODULE_PATH"
TF_PLAN_OUT="$TF_WORKSPACE/terraform-plan-$TF_VERSION-$TF_AZ_VERSION"

# Store data temporarily
TEMP_FILE_01=$(mktemp).json
TEMP_FILE_02=$(mktemp).json

# Update baseline_values.json with the latest parameters
echo "==> Update baseline values..."
cd "$TF_WORKSPACE"
jq '(.. | strings) |= gsub("root-id-1"; "'"$TF_ROOT_ID"'")' baseline_values.json >"$TEMP_FILE_01"
jq '(.. | strings) |= gsub("root-name"; "ES-'"$TF_VERSION"'-'"$TF_AZ_VERSION"'")' "$TEMP_FILE_01" >"$TEMP_FILE_02"
jq '(.. | strings) |= gsub("northeurope"; "'"$PRIMARY_LOCATION"'")' "$TEMP_FILE_02" >"$TEMP_FILE_01"
jq '(.. | strings) |= gsub("westeurope"; "'"$SECONDARY_LOCATION"'")' "$TEMP_FILE_01" >"$TEMP_FILE_02"
jq '(.. | strings) |= gsub("ROOT-ID-1"; "'"$(echo "$TF_ROOT_ID" | tr '[:lower:]' '[:upper:]')"'")' "$TEMP_FILE_02" >"$TF_PLAN_OUT"_baseline_values.json

# Update terraform-plan.json to sort ordering (see opa-values-generator.ps1 for more information)
echo "==> Sort resource ordering in Terraform plan..."
jq '(.planned_values.root_module.child_modules[]?.child_modules // []) |= sort_by(.address)' "$TF_PLAN_OUT".json >"$TF_PLAN_OUT"_planned_values.json

echo "==> Module Locations - $PRIMARY_LOCATION ($SECONDARY_LOCATION)"
echo "==> Azure {TF_ROOT_ID} - ${TF_ROOT_ID}"
echo "==> Azure TF_ROOT_ID - $TF_ROOT_ID"

wait

echo "==> Running conftest..."
echo
echo "==> Testing azurerm_management_group resources..."
conftest test "$TF_PLAN_OUT"_planned_values.json -p ../../opa/policy/management_groups.rego -d "$TF_PLAN_OUT"_baseline_values.json
echo
echo "==> Testing azurerm_policy_definitions resources..."
conftest test "$TF_PLAN_OUT"_planned_values.json -p ../../opa/policy/policy_definitions.rego -d "$TF_PLAN_OUT"_baseline_values.json
echo
echo "==> Testing azurerm_policy_set_definition resources..."
conftest test "$TF_PLAN_OUT"_planned_values.json -p ../../opa/policy/policy_set_definitions.rego -d "$TF_PLAN_OUT"_baseline_values.json
echo
echo "==> Testing azurerm_policy_assignment resources..."
conftest test "$TF_PLAN_OUT"_planned_values.json -p ../../opa/policy/policy_assignments.rego -d "$TF_PLAN_OUT"_baseline_values.json
echo
echo "==> Testing azurerm_role_definition resources..."
conftest test "$TF_PLAN_OUT"_planned_values.json -p ../../opa/policy/role_definitions.rego -d "$TF_PLAN_OUT"_baseline_values.json
echo
echo "==> Testing azurerm_role_assignment resources..."
conftest test "$TF_PLAN_OUT"_planned_values.json -p ../../opa/policy/role_assignments.rego -d "$TF_PLAN_OUT"_baseline_values.json
echo
