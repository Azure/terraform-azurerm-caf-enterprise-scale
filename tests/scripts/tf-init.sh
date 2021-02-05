#!/usr/bin/bash
set -e

#
# Shell Script
# - Terraform Initialize
#

echo "==> Switching directories..."
cd $(Pipeline.Workspace)/tests/deployment

echo "==> Initializaing infrastructure..."
terraform init