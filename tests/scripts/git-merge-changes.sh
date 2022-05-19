#!/usr/bin/bash
set -e

#
# Shell Script
# - Run git commands to merge changes to branch
#

echo "==> Checking git status..."
git status --short --branch

echo "==> Add changes to baseline_values.json files..."
STATUS_LOG=$(git status --short | grep baseline_values.json)
if [ ${#STATUS_LOG} -gt 0 ]; then
    git add --all ./tests/modules/*/baseline_values.json
else
    echo "No changes found to add."
fi

echo "==> Commit changes..."
COMMIT_LOG=$(git diff --cached)
if [ ${#COMMIT_LOG} -gt 0 ]; then
    git commit --message "Add updates to baseline_values.json"
else
    echo "No changes found to commit."
fi
