#!/usr/bin/bash

echo "==> Switching directories..."
cd $PWD/tests/deployment

echo "==> Initializaing infrastructure..."
terraform init