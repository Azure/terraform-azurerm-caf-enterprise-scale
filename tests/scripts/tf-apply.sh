#!/usr/bin/bash
set -e

#
# Shell Script
# - Terraform Apply
#

echo "==> Switching directories..."
cd "$PIPELINE_WORKSPACE/s/tests/deployment"

echo "==> Applying infrastructure..."
terraform apply \
    -auto-approve \
    -parallelism=50 \
    -state="./terraform-$TF_VERSION-$TF_AZ_VERSION.tfstate" \
    "terraform-plan-$TF_VERSION-$TF_AZ_VERSION"
