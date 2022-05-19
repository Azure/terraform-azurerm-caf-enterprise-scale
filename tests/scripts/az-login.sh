#!/usr/bin/bash
set -e

#
# Shell Script
# - Run az login command
#

echo "==> Authenticating cli..."
az login \
    --service-principal \
    --tenant "$ARM_TENANT_ID" \
    --username "$ARM_CLIENT_ID" \
    --password "$ARM_CLIENT_SECRET" \
    --query [?isDefault]
