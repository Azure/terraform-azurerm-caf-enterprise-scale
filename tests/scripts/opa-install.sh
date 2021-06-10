#!/usr/bin/env bash
set -e

#
# Shell Script
# - Conftest Install
#
# # Parameters
CONFTEST_VERSION=0.24.0

echo "==> Downloading archive..."
wget 'https://github.com/open-policy-agent/conftest/releases/download/v'"$CONFTEST_VERSION"'/conftest_'"$CONFTEST_VERSION"'_Linux_x86_64.tar.gz' -P /tmp

echo "==> Expanding archive..."
cd /tmp && tar xzf 'conftest_'"$CONFTEST_VERSION"'_Linux_x86_64.tar.gz' -C /tmp

echo "==> Moving binaries..."
mv /tmp/conftest /usr/local/bin

echo "==> Exporting path..."
echo "##vso[task.prependpath]/usr/local/bin"
