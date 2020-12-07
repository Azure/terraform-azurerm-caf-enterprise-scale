#!/usr/bin/bash

echo "==> Switching directory..."
cd $PWD/tests/deployment

echo "==> Updating provider version..."
echo "==> Provider version - $TF_AZ_VERSION"
sed -i 's/version = ""/version = "'$TF_AZ_VERSION'"/g' main.tf