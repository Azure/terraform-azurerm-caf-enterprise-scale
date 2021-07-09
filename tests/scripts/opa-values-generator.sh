#!/usr/bin/env bash
set -e

#
# Shell Script
# - OPA Run Tests
###############################################
# Run tests and generate testing values.
###############################################

# # Parameters
PLAN_NAME=terraform-plan
CONFIRM="y"

# shellcheck source=tests/scripts/opa-install.sh
source opa-install.sh

# Run this locally to test your terraform configuration and generate the values needed for the automation pipeline.
# The script will install all the necessary components locally and run the tests.
# After completing the tests, follow the script prompt for the next steps.
#
# # #? Run a local test against a different module configuration:
# # #* Update the path to run the tests on a different folder (example: ../deployment_2)
# # #* Copy paste the variables.tf file from deployment folder and adjust your main.tf
###############################################
# # #* Path of the tested _es terraform module
MODULE_PATH="../deployment"
###############################################

echo
if [ ! -d "$MODULE_PATH" ]; then
    echo "The ${MODULE_PATH} directory does not exist, check path on .\opa-values-generator.sh :line 26"
    exit
fi

echo "==> Change to the module root directory..."
cd $MODULE_PATH

echo "==> Initializing infrastructure..."
terraform init

echo "==> Planning infrastructure..."
terraform plan \
    -var="root_id_1=root-id-1" \
    -var="root_id_2=root-id-2" \
    -var="root_id_3=root-id-3" \
    -var="root_name=root-name" \
    -var="location=eastus" \
    -out=$PLAN_NAME

echo "==> Converting plan to *.json..."
terraform show -json "$PLAN_NAME" >"$PLAN_NAME".json

echo "==> Removing the original plan..."
rm "$PLAN_NAME"

echo "==> Saving planned values to a temporary planned_values.json..."
jq <"$PLAN_NAME.json" '.planned_values.root_module' >planned_values.json

echo "==> Converting to yaml..."
yq <planned_values.json e -P - >../opa/policy/planned_values.yml

echo "==> Check yaml for errors..."
yamllint -d relaxed ../opa/policy/planned_values.yml

echo "==> Running conftest..."
cd $MODULE_PATH
echo
echo "==> Testing management_groups..."
conftest test "$PLAN_NAME".json -p ../opa/policy/management_groups.rego -d ../opa/policy/planned_values.yml
echo
echo "==> Testing role_definitions..."
conftest test "$PLAN_NAME".json -p ../opa/policy/role_definitions.rego -d ../opa/policy/planned_values.yml
echo
echo "==> Testing role_assignments..."
conftest test "$PLAN_NAME".json -p ../opa/policy/role_assignments.rego -d ../opa/policy/planned_values.yml
echo
echo "==> Testing policy_set_definitions..."
conftest test "$PLAN_NAME".json -p ../opa/policy/policy_set_definitions.rego -d ../opa/policy/planned_values.yml
echo
echo "==> Testing policy_definitions..."
conftest test "$PLAN_NAME".json -p ../opa/policy/policy_definitions.rego -d ../opa/policy/planned_values.yml
echo
echo "==> Testing policy_assignments..."
conftest test "$PLAN_NAME".json -p ../opa/policy/policy_assignments.rego -d ../opa/policy/planned_values.yml

# # # Remove "<<-EOF $CONFIRM EOF" for CMD prompt.
echo
read -r -p "Do you want to prepare files for repository (y/n)?" CONT <<-EOF
$CONFIRM
EOF
if [ "$CONT" = "y" ]; then
    rm $PLAN_NAME.json
    echo
    echo "$PLAN_NAME.json has been removed from your root module"
    echo
    rm ../opa/policy/planned_values.yml
    echo "planned_values.yml has been removed from your /opa/policy/ directory"
    echo
else
    echo
    echo "$PLAN_NAME.json  can contain sensitive data"
    echo
    echo "Exposing $PLAN_NAME.json in a repository can cause security breach"
    echo
    echo "From within your terraform root module: conftest test $PLAN_NAME.json -p ../opa/policy/  -d ../opa/policy/planned_values.yml"
fi
