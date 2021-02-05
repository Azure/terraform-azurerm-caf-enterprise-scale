#!/usr/bin/bash
set -e

#
# Shell Script
# - Terraform Prepare
#

echo "==> Switching directories..."
cd $PIPELINE_WORKSPACE/s/tests/deployment

echo "==> Generating root id's..."
ROOT_ID_1=$RANDOM
ROOT_ID_2=$RANDOM
ROOT_ID_3=$RANDOM

echo "==> Azure Root ID 1 - $ROOT_ID_1"
echo "##vso[task.setvariable variable=TF_ROOT_ID_1;]$ROOT_ID_1"

echo "==> Azure Root ID 2 - $ROOT_ID_2"
echo "##vso[task.setvariable variable=TF_ROOT_ID_2;]$ROOT_ID_2"

echo "==> Azure Root ID 3 - $ROOT_ID_3"
echo "##vso[task.setvariable variable=TF_ROOT_ID_3;]$ROOT_ID_3"

echo "==> Replacing provider version..."
sed -i 's/version = ""/version = "'$TF_AZ_VERSION'"/g' main.tf

echo "==> Displaying environment variables..."
echo "==> Terraform Version - $TF_VERSION"
echo "==> Terraform Provider Version - $TF_AZ_VERSION"
echo "==> Terraform Variable (Root Name) - ES-$TF_VERSION-$TF_AZ_VERSION"
