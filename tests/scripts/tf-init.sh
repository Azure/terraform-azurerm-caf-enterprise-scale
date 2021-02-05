#!/usr/bin/bash
set -e

#
# Shell Script
# - Terraform Initialize
#

echo "==> Switching directories..."
cd $PIPELINE_WORKSPACE/tests/deployment

echo "==> Initializaing infrastructure..."
terraform init