#!/usr/bin/env bash

# Parameters
PLAN_NAME=opa

# Install on Linux:
if [ $(command -v conftest) ]; then
    echo "--> Conftest exists, skip install"
else
    wget https://github.com/open-policy-agent/conftest/releases/download/v0.24.0/conftest_0.24.0_Linux_x86_64.tar.gz
    tar xzf conftest_0.24.0_Linux_x86_64.tar.gz
    sudo mv conftest /usr/local/bin || exit 1
    rm conftest_0.24.0_Linux_x86_64.tar.gz
fi

# Change to the module root directory
cd ..

# Initialize Terraform and calculate the changes it will make.
terraform init || exit 1
echo
terraform plan --out $PLAN_NAME.test || exit 1
echo
terraform show -json $PLAN_NAME.test >$PLAN_NAME.json

# Remove the plan after converting to json
rm $PLAN_NAME.test
