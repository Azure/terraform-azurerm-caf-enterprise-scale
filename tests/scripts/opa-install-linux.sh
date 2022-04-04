#!/usr/bin/env bash
set -e

#
# Shell Script
# - Conftest Install
#

# Parameters
CONFTEST_VERSION=0.24.0

if [ "$(command -v jq)" ]; then
    echo "==> jq exists, skip install"
    jq --version
    echo
else
    echo "==> Install jq on Linux..."
    sudo apt-get install jq
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
