#!/usr/bin/bash

#
# Shell Script
# - Terraform Prepare
#

echo "==> Switching directories..."
cd $PWD/tests/deployment

echo "==> Generating root id's..."
echo "TF_ROOT_ID_1=$RANDOM" >> $GITHUB_ENV
echo "TF_ROOT_ID_2=$RANDOM" >> $GITHUB_ENV
echo "TF_ROOT_ID_3=$RANDOM" >> $GITHUB_ENV

echo "==> Replacing provider version..."
sed -i 's/version = ""/version = "'$TF_AZ_VERSION'"/g' main.tf

echo "==> Displaying environment variables..."
echo "==> Terraform Version - $TF_VERSION"
echo "==> Terraform Provider Version - $TF_AZ_VERSION"
echo "==> Terraform Variable (Root Name) - ES-$TF_VERSION-$TF_AZ_VERSION"