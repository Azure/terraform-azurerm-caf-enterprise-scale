#!/usr/bin/env bash
set -e

#
# Shell Script
# - OPA Run Tests
###############################################
# Run tests and generate testing values.
###############################################

# Run this locally to test your terraform configuration and generate the values needed for the automation pipeline.
# The script will install all the necessary components locally and run the tests.
# After completing the tests, follow the script prompt for the next steps.
#

# # Parameters
PLAN_NAME=terraform-plan
YQ_VERSION=v4.9.3
YQ_BINARY=yq_linux_amd64
CONFTEST_VERSION=0.24.0

if [ "$(command -v terraform)" ]; then
    echo "==> Terraform exists, skip install"
    terraform version
    echo
else
    echo "==> Install Terraform on Linux..."
    sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
    sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
    sudo apt-get update && sudo apt-get install terraform
fi

if [ "$(command -v jq)" ]; then
    echo "==> jq exists, skip install"
    jq --version
    echo
else
    echo "==> Install jq on Linux..."
    sudo apt-get install jq
fi

if [ "$(command -v yamllint)" ]; then
    echo "==> yamllint exists, skip install"
    yamllint -v
    echo
else
    echo "==> Install yamllint on Linux..."
    sudo apt-get install yamllint -y
fi

if [ "$(command -v yq)" ]; then
    echo "==> yq exists, skip install"
    yq --version
    echo
else
    echo "==> Install yq on Linux..."
    sudo wget https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/${YQ_BINARY} -O /usr/bin/yq &&
        sudo chmod +x /usr/bin/yq
fi

if [ "$(command -v conftest)" ]; then
    echo "--> Conftest exists, skip install"
    conftest --version
else
    wget https://github.com/open-policy-agent/conftest/releases/download/v${CONFTEST_VERSION}/conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz
    tar xzf conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz
    sudo mv conftest /usr/local/bin
    rm conftest_${CONFTEST_VERSION}_Linux_x86_64.tar.gz
fi

echo "==> Change to the module root directory..."
cd ../deployment

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
cd ../deployment
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

echo
read -r -p "Do you want to prepare files for repository (y/n)?" CONT
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
