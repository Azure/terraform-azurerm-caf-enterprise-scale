#!/usr/bin/bash

echo "==> Switching directory..."
cd $PWD/tests/deployment

echo "==> Updating provider version..."
sed -i 's/version = ""/version = "$(TF_AZ_VERSION)"/g' main.tf