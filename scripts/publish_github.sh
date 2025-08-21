#!/usr/bin/env bash
set -euo pipefail

REPO_NAME="diyanet-vpn"
GH_USER="serkanoyanik"
BRANCH="main"

if [ -z "${GITHUB_TOKEN:-}" ]; then
  echo "GITHUB_TOKEN is not set" >&2
  exit 1
fi

# Determine correct Authorization header for GitHub API
if [[ "${GITHUB_TOKEN}" == github_pat_* ]]; then
  AUTH_HEADER="Authorization: Bearer ${GITHUB_TOKEN}"
else
  AUTH_HEADER="Authorization: token ${GITHUB_TOKEN}"
fi

cd "$(dirname -- "$0")/.."

if [ ! -d .git ]; then
  git init
  git branch -M "$BRANCH"
fi

git config user.name "${GIT_AUTHOR_NAME:-serkanoyanik}"
git config user.email "${GIT_AUTHOR_EMAIL:-nakrerkan@gmail.com}"

git add -A
if ! git diff --cached --quiet; then
  git commit -m "Initial commit"
fi

# Create the GitHub repo if it does not exist (ignore error if already exists)
if ! curl -fsS -H "$AUTH_HEADER" -H "Accept: application/vnd.github+json" \
  "https://api.github.com/repos/${GH_USER}/${REPO_NAME}" >/dev/null; then
  curl -sS -H "$AUTH_HEADER" \
    -H "Accept: application/vnd.github+json" \
    -X POST https://api.github.com/user/repos \
    -d "{\"name\":\"${REPO_NAME}\",\"private\":false}" \
    || true
fi

# Add remote and push using PAT-friendly URL (username:token)
REMOTE_URL="https://${GH_USER}:${GITHUB_TOKEN}@github.com/${GH_USER}/${REPO_NAME}.git"
if git remote get-url origin >/dev/null 2>&1; then
  git remote set-url origin "$REMOTE_URL"
else
  git remote add origin "$REMOTE_URL"
fi

git push -u origin "$BRANCH" 