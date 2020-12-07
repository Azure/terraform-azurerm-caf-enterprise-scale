#!/usr/bin/bash

echo "==> Switching directories..."
cd $PWD/tests/deployment

echo "==> Generating root id..."
echo "TF_ROOT_ID=$RANDOM" >> $GITHUB_ENV

echo "==> Replacing provider version..."
echo "==> Provider version - $TF_AZ_VERSION"
sed -i 's/version = ""/version = "'$TF_AZ_VERSION'"/g' main.tf