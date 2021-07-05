#!/usr/bin/bash
set -e

#
# Shell Script
# - Terraform Format
#

echo "==> Formatting files..."
terraform fmt -diff -check -recursive
