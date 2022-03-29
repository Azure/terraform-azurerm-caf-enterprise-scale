#!/usr/bin/env bash
set -e

#
# Shell Script
# - Conftest Install
#
# # Parameters
CONFTEST_VERSION=0.24.0
YQ_VERSION=v4.9.3
YQ_BINARY=yq_linux_amd64

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
