#!/usr/bin/bash
set -e

#
# Shell Script
# - Check that workflow has been triggered from PR and get PR details
#

echo "==> Checking pull request..."
# Consider adding input variable to set PR_NUMBER for manual trigger
PR_NUMBER="$SYSTEM_PULLREQUEST_PULLREQUESTNUMBER"
if [ ${#PR_NUMBER} -eq 0 ]; then
    echo "ERROR: Unable to find pull request details. Please check this workflow was triggered from a valid pull request."
    exit 1
fi

echo "==> Get details for pull request $PR_NUMBER..."
PR_RESPONSE=$(curl "https://api.github.com/repos/$BUILD_REPOSITORY_NAME/pulls/$PR_NUMBER" | jq -c)
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

echo "##vso[task.setvariable variable=REPOSITORY_URI;isOutput=true]$REPOSITORY_URI"
echo "##vso[task.setvariable variable=SOURCE_BRANCH;isOutput=true]$SOURCE_BRANCH"