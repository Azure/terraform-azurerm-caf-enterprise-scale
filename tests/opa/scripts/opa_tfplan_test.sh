#!/usr/bin/env bash

# Shell color parameters
GREEN='\033[0;32m'
NC='\033[0m'

set -e

# Parameters
PLAN_NAME=opa
VERSION=v4.9.3
BINARY=yq_linux_amd64

# Install Conftest on Linux:
if [ $(command -v conftest) ]; then
    echo "--> Conftest exists, skip install"
else
    wget https://github.com/open-policy-agent/conftest/releases/download/v0.24.0/conftest_0.24.0_Linux_x86_64.tar.gz
    tar xzf conftest_0.24.0_Linux_x86_64.tar.gz
    sudo mv conftest /usr/local/bin
    rm conftest_0.24.0_Linux_x86_64.tar.gz
fi

# # Install yq on Linux:
if [ $(command -v yq) ]; then
    echo "--> yq exists, skip install"
else
    wget https://github.com/mikefarah/yq/releases/download/${VERSION}/${BINARY} -O /usr/bin/yq &&
        chmod +x /usr/bin/yq
fi

# Change to the module root directory
cd ..

# Initialize Terraform and calculate the changes it will make.
terraform init
echo
terraform plan --out $PLAN_NAME.test
echo
terraform show -json $PLAN_NAME.test >$PLAN_NAME.json

# Remove the plan after converting to json
rm $PLAN_NAME.test

# # Extract the planned values from the tfplan.json in a temporary *.json file.
# # To avoid an error from Conftest, "bad yml type", use '.planned_values.root_module' with jq.
cat opa.json | jq '.planned_values.root_module' >planned_values.json

# # Convert to yaml.
cat planned_values.json | yq e -P - | tee policy/planned_values.yml

# # Delete the *.json after converting to *.yml
rm planned_values.json
echo
echo
echo
echo -e "| > | > | >${GREEN} 'All Done!'${NC}\n"
echo
echo -e "From within your root module:${GREEN} conftest test opa.json  -d policy/planned_values.yml${NC}\n"
echo
