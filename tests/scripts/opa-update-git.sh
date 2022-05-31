#!/usr/bin/bash
set -e

#
# Shell Script
# - Run git commands to merge changes to branch and push to PR
#

echo "==> Set git config..."
git config user.name github-actions
git config user.email action@github.com

echo "==> Check git status..."
git status --short --branch

echo "==> Check git remotes..."
git remote --verbose

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
PR_USER=$(gh pr view "$SYSTEM_PULLREQUEST_PULLREQUESTNUMBER" --json headRepositoryOwner --jq ".headRepositoryOwner.login")
PR_REPO=$(gh pr view "$SYSTEM_PULLREQUEST_PULLREQUESTNUMBER" --json headRepository --jq ".headRepository.name")
if [ ${#COMMIT_LOG} -gt 0 ]; then
    echo "Pushing changes to: $PR_USER/$PR_REPO"
    git push "https://$GITHUB_TOKEN@github.com/$PR_USER/$PR_REPO.git"
else
    echo "No changes to push."
fi
