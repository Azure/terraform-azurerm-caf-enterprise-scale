#!/usr/bin/bash
set -e

#
# Shell Script
# - Run git commands to merge changes to branch
#

echo "==> Checking pull request..."
# Consider adding input variable to set PR_NUMBER for manual trigger
PR_NUMBER="$SYSTEM_PULLREQUEST_PULLREQUESTNUMBER"
if [ ${#PR_NUMBER} -eq 0 ]; then
    echo "ERROR: Unable to find pull request details. Please check this workflow was triggered from a valid pull request."
    exit 1
fi

echo "==> Get details for pull request $PR_NUMBER..."
PR_RESPONSE=$(curl https://api.github.com/repos/$BUILD_REPOSITORY_NAME/pulls/$PR_NUMBER | jq -c)
REPOSITORY_URI=$(echo "$PR_RESPONSE" | jq -r ".head.repo.html_url")
SOURCE_BRANCH=$(echo "$PR_RESPONSE" | jq -r ".head.ref")
if [ ${#REPOSITORY_URI} -gt 0 ]; then
    echo "Found PR repository: $REPOSITORY_URI"
else
    echo "ERROR: Unable to find REPOSITORY_URI for pull request."
    exit 1
fi
if [ ${#SOURCE_BRANCH} -gt 0 ]; then
    echo "Found PR source branch: $SOURCE_BRANCH"
else
    echo "ERROR: Unable to find SOURCE_BRANCH for pull request."
    exit 1
fi

echo "==> Set git config..."
git config user.name azure-devops
git config user.email azuredevops@microsoft.com

echo "==> Switch to branch..."
git switch -c patch-opa

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

echo "==> Push changes..."
git push "$REPOSITORY_URI" patch-opa:"$SOURCE_BRANCH"
