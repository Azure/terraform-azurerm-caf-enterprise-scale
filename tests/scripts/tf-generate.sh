#!/usr/bin/bash

echo "==> Generating root id values..."
echo "::set-output name=root_id::$(echo $RANDOM)"