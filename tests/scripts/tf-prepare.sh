#!/usr/bin/bash
set -e

#
# Shell Script
# - Terraform Prepare
#

echo "==> Switching directories..."
cd $PWD/tests/deployment

echo "==> Generating root id's..."
ROOT_ID_1=$RANDOM
echo "==> Azure Root ID 1 - $ROOT_ID_1"
echo "TF_ROOT_ID_1=$ROOT_ID_1" >> $GITHUB_ENV
ROOT_ID_2=$RANDOM
echo "==> Azure Root ID 2 - $ROOT_ID_2"
echo "TF_ROOT_ID_2=$ROOT_ID_2" >> $GITHUB_ENV
ROOT_ID_3=$RANDOM
echo "==> Azure Root ID 3 - $ROOT_ID_3"
echo "TF_ROOT_ID_3=$ROOT_ID_3" >> $GITHUB_ENV

echo "==> Replacing provider version..."
sed -i 's/version = ""/version = "'$TF_AZ_VERSION'"/g' main.tf

echo "==> Displaying environment variables..."
echo "==> Terraform Version - $TF_VERSION"
echo "==> Terraform Provider Version - $TF_AZ_VERSION"
echo "==> Terraform Variable (Root Name) - ES-$TF_VERSION-$TF_AZ_VERSION"