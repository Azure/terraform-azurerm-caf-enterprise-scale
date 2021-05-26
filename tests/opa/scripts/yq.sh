#!/usr/bin/env bash

# # Parameters
VERSION=v4.9.3
BINARY=yq_linux_amd64

# # Install on Linux:
if [ $(command -v yq) ]; then
    echo "--> yq exists, skip install"
else
    wget https://github.com/mikefarah/yq/releases/download/${VERSION}/${BINARY} -O /usr/bin/yq &&
        chmod +x /usr/bin/yq
fi

# # Change to the module root directory
cd ..

# # Extract the planned values from the tfplan.json in a temporary *.json file.
# # To avoid an error from Conftest, "bad yml type", use '.planned_values.root_module' with jq.
cat opa.json | jq '.planned_values.root_module' >planned_values.json

# # Convert to yaml.
cat planned_values.json | yq e -P - | tee policy/planned_values.yml

# # Delete the *.json after converting to *.yml
rm planned_values.json
