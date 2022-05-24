#!/usr/bin/bash
set -e

#
# Shell Script
# - Run git commands to merge changes to branch
#

echo "==> Set git config..."
git config user.name azure-devops
git config user.email azuredevops@microsoft.com

echo "==> Check git status..."
git status --short --branch

echo "==> Stage changes..."
STATUS_LOG=$(git status --short | grep baseline_values.json)
if [ ${#STATUS_LOG} -gt 0 ]; then
    git add --all ./tests/modules/*/baseline_values.json
else
    echo "No changes to add."
fi

echo "==> Print git diff..."
git diff --cached

echo "==> Commit changes..."
COMMIT_LOG=$(git diff --cached)
if [ ${#COMMIT_LOG} -gt 0 ]; then
    git commit --message "Add updates to baseline_values.json"
else
    echo "No changes to commit."
fi
