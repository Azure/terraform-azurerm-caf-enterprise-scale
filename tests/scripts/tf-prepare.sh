#!/usr/bin/bash

echo "==> Switching directories..."
cd $PWD/tests/deployment

echo "==> Generating root id..."
echo "TF_ROOT_ID=$RANDOM" >> $GITHUB_ENV

echo "==> Replacing provider version..."
sed -i 's/version = ""/version = "'$TF_AZ_VERSION'"/g' main.tf

echo "==> Displaying environment variables..."
echo "==> Terraform Version - $TF_VERSION"
echo "==> Terraform Provider Version - $TF_AZ_VERSION"
echo "==> Terraform Variable (Root ID) - $TF_ROOT_ID"
echo "==> Terraform Variable (Root Name) - ES-$TF_VERSION-$TF_AZ_VERSION"