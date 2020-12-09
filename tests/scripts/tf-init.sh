#!/usr/bin/bash

#
# Shell Script
# - Terraform Initialize
#

echo "==> Switching directories..."
cd $PWD/tests/deployment

echo "==> Initializaing infrastructure..."
terraform init