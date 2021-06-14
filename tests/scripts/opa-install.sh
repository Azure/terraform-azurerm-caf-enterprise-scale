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

echo "==> Downloading archive..."
wget 'https://github.com/open-policy-agent/conftest/releases/download/v'"$CONFTEST_VERSION"'/conftest_'"$CONFTEST_VERSION"'_Linux_x86_64.tar.gz' -P /tmp

echo "==> Expanding archive..."
cd /tmp && tar xzf 'conftest_'"$CONFTEST_VERSION"'_Linux_x86_64.tar.gz' -C /tmp

echo "==> Moving binaries..."
sudo mv /tmp/conftest /usr/local/bin

echo "==> Exporting path..."
echo "##vso[task.prependpath]/usr/local/bin"

if [ $(command -v yq) ]; then
    echo "==> yq exists, skip install"
    yq --version
    echo
else
    echo "==> Install yq on Linux..."
    sudo wget https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/${YQ_BINARY} -O /usr/bin/yq && sudo chmod +x /usr/bin/yq
fi
