#!/usr/bin/bash
set -e

#
# Shell Script
# - Run git commands to merge changes to branch and push to PR
#

echo "==> Set git config..."
GIT_USER_NAME="github-actions"
GIT_USER_EMAIL="action@github.com"
echo "git user name  : $GIT_USER_NAME"
git config user.name github-actions
echo "git user email : $GIT_USER_EMAIL"
git config user.email action@github.com

echo "==> Check git status..."
git status --short --branch

echo "==> Check git remotes..."
git remote --verbose

echo "==> Stage changes..."
mapfile -t STATUS_LOG < <(git status --short | grep baseline_values.json)
if [ ${#STATUS_LOG[@]} -gt 0 ]; then
    echo "Found changes to the following files:"
    printf "%s\n" "${STATUS_LOG[@]}"
    git add --all ./tests/modules/*/baseline_values.json
else
    echo "No changes to add."
fi

echo "==> Check git diff..."
mapfile -t GIT_DIFF < <(git diff --cached)
printf "%s\n" "${GIT_DIFF[@]}"

if [ ${#GIT_DIFF[@]} -gt 0 ]; then

    echo "==> Commit changes..."
    git commit --message "Add updates to baseline_values.json"

    echo "==> Push changes..."
    PR_USER=$(gh pr view "$SYSTEM_PULLREQUEST_PULLREQUESTNUMBER" --json headRepositoryOwner --jq ".headRepositoryOwner.login")
    PR_REPO=$(gh pr view "$SYSTEM_PULLREQUEST_PULLREQUESTNUMBER" --json headRepository --jq ".headRepository.name")
    PR_HEAD=$(gh pr view "$SYSTEM_PULLREQUEST_PULLREQUESTNUMBER" --json headRefName --jq ".headRefName")
    echo "Pushing changes to: $PR_USER/$PR_REPO"
    git push "https://$GITHUB_TOKEN@github.com/$PR_USER/$PR_REPO.git" "HEAD:$PR_HEAD"

else
    echo "No changes found."
fi
