#!/usr/bin/bash

#
# Shell Script
# - Terraform Format
#

echo "==> Formatting files..."
terraform fmt -diff -check -recursive