#!/usr/bin/bash
set -e

#
# Shell Script
# - Terraform Prepare
#

case $SCM in
    'AzurePipelines')
        echo "==> Switching directories..."
        cd $PWD/tests/deployment

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

        echo "==> Exporting runtime secret..."
        echo "##vso[task.setvariable variable=ARM_CLIENT_SECRET;]$(ARM_CLIENT_SECRET)"

        echo "==> Displaying environment variables..."
        echo "==> Terraform Version - $TF_VERSION"
        echo "==> Terraform Provider Version - $TF_AZ_VERSION"
        echo "==> Terraform Variable (Root Name) - ES-$TF_VERSION-$TF_AZ_VERSION"
        ;;
    'GitHubActions')
        echo "==> Switching directories..."
        cd $PWD/tests/deployment

        echo "==> Generating root id's..."
        ROOT_ID_1=$RANDOM
        ROOT_ID_2=$RANDOM
        ROOT_ID_3=$RANDOM
        
        echo "==> Azure Root ID 1 - $ROOT_ID_1"
        echo "TF_ROOT_ID_1=$ROOT_ID_1" >> $GITHUB_ENV
        
        echo "==> Azure Root ID 2 - $ROOT_ID_2"
        echo "TF_ROOT_ID_2=$ROOT_ID_2" >> $GITHUB_ENV
        
        echo "==> Azure Root ID 3 - $ROOT_ID_3"
        echo "TF_ROOT_ID_3=$ROOT_ID_3" >> $GITHUB_ENV

        echo "==> Replacing provider version..."
        sed -i 's/version = ""/version = "'$TF_AZ_VERSION'"/g' main.tf

        echo "==> Displaying environment variables..."
        echo "==> Terraform Version - $TF_VERSION"
        echo "==> Terraform Provider Version - $TF_AZ_VERSION"
        echo "==> Terraform Variable (Root Name) - ES-$TF_VERSION-$TF_AZ_VERSION"
        ;;
    *)
        echo "==> Unsupported platform..."
        exit 1
        ;;
esac


