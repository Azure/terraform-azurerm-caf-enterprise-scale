#!/usr/bin/env bash

# Parameters
VERSION=v4.9.3
BINARY=yq_linux_amd64

# Install on Linux:
if [ $(command -v yq) ]; then
    echo "--> yq exists, skip install"
else
    wget https://github.com/mikefarah/yq/releases/download/${VERSION}/${BINARY} -O /usr/bin/yq &&
        chmod +x /usr/bin/yq
fi

# Change to the module root directory
cd ..

# Convert to yaml
cat opa.json | yq e -P - | tee policy/opa.yml
