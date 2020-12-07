#!/usr/bin/bash

echo "==> Switching directory..."
cd $PWD/tests/deployment

echo "==> Updating provider version..."
sed -i 's/version = ""/version = "${{ matrix.azurerm_version }}"/g' main.tf