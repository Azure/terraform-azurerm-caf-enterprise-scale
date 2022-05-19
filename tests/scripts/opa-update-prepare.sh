#!/usr/bin/bash
set -e

#
# Shell Script
# - Prepare environment for OPA values generator
#

echo "==> Creating local.ignore.auto.tfvars with subscription IDs..."
tee local.ignore.auto.tfvars <<TFCONFIG
subscription_id_connectivity = "$DEFAULT_SUBSCRIPTION_ID_CONNECTIVITY"
subscription_id_management   = "$DEFAULT_SUBSCRIPTION_ID_MANAGEMENT"
TFCONFIG
