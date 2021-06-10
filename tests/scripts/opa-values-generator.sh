#!/usr/bin/env bash
set -e

#
# Shell Script
# - OPA Run Tests
#
# # Parameters
PLAN_NAME=terraform-plan
VERSION=v4.9.3
BINARY=yq_linux_amd64

if [ $(command -v terraform) ]; then
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

if [ $(command -v jq) ]; then
    echo "==> jq exists, skip install"
    jq --version
    echo
else
    echo "==> Install jq on Linux..."
    sudo apt-get install jq
fi

if [ $(command -v yq) ]; then
    echo "==> yq exists, skip install"
    yq --version
    echo
else
    echo "==> Install yq on Linux..."
    wget https://github.com/mikefarah/yq/releases/download/${VERSION}/${BINARY} -O /usr/bin/yq &&
        chmod +x /usr/bin/yq
fi

if [ $(command -v conftest) ]; then
    echo "--> Conftest exists, skip install"
    conftest --version
else
    wget https://github.com/open-policy-agent/conftest/releases/download/v0.24.0/conftest_0.24.0_Linux_x86_64.tar.gz
    tar xzf conftest_0.24.0_Linux_x86_64.tar.gz
    sudo mv conftest /usr/local/bin
    rm conftest_0.24.0_Linux_x86_64.tar.gz
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
terraform show -json $PLAN_NAME >$PLAN_NAME.json

echo "==> Removing the original plan..."
rm $PLAN_NAME

echo "==> Saving planned values to a temporary planned_values.json..."
cat $PLAN_NAME.json | jq '.planned_values.root_module' >planned_values.json

echo "==> Converting to yaml..."
cat planned_values.json | yq e -P - | tee ../opa/policy/planned_values_template.yml

echo "==> Removing the temporary planned_values.json..."
rm planned_values.json

echo
read -p "Do you want to remove terraform-plan.json (y/n)?" CONT
if [ "$CONT" = "y" ]; then
    rm $PLAN_NAME.json
    echo
    echo "$PLAN_NAME.json has been removed from your root module"
    echo
else
    echo
    echo "$PLAN_NAME.json  can contain sensitive data"
    echo
    echo "Exposing $PLAN_NAME.json in a repository can cause security breach"
    echo
    echo "From within your terraform root module: conftest test $PLAN_NAME.json -p ../opa/policy/  -d ../opa/policy/planned_values_template.yml"
fi
