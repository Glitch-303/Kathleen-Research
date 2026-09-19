#!/usr/bin/env bash
# publish-github-pages.sh <game-name>
#
# LIVE PUBLISH — makes the game reachable at a public URL.
# The AI invoking this MUST have already asked the student for explicit
# confirmation. See references/publishing-guide.md for prerequisites.
set -euo pipefail

GAME_NAME="${1:-}"

if [[ -z "$GAME_NAME" ]]; then
  echo "Usage: ./publish-github-pages.sh <game-name>" >&2
  exit 1
fi

if [[ ! -d "$GAME_NAME" ]]; then
  echo "Error: directory '$GAME_NAME' not found. Run init-project.sh first." >&2
  exit 1
fi

pushd "$GAME_NAME" > /dev/null

if [[ ! -d .git ]]; then
  echo "Error: $GAME_NAME is not a git repository." >&2
  echo "Run 'git init && git remote add origin <your-repo-url>' first." >&2
  popd > /dev/null
  exit 1
fi

if ! git remote get-url origin > /dev/null 2>&1; then
  echo "Error: no 'origin' remote configured." >&2
  echo "Run 'git remote add origin <your-github-repo-url>' first." >&2
  popd > /dev/null
  exit 1
fi

echo "About to publish '$GAME_NAME' to GitHub Pages (gh-pages branch)."
echo "This will make it reachable at a public URL. Continuing..."

# Build a clean deploy folder (reuse package-local staging logic).
DEPLOY_DIR="$(mktemp -d)"
cp index.html "$DEPLOY_DIR/"
[[ -d src ]] && cp -r src "$DEPLOY_DIR/"
[[ -d assets ]] && cp -r assets "$DEPLOY_DIR/"
[[ -f style.css ]] && cp style.css "$DEPLOY_DIR/"

# Deploy via a temporary worktree on an orphan gh-pages branch.
if git show-ref --verify --quiet refs/heads/gh-pages; then
  git worktree add /tmp/gh-pages-deploy gh-pages
else
  git worktree add -B gh-pages /tmp/gh-pages-deploy
  (cd /tmp/gh-pages-deploy && git checkout --orphan gh-pages && git rm -rf . > /dev/null 2>&1 || true)
fi

rm -rf /tmp/gh-pages-deploy/*
cp -r "$DEPLOY_DIR"/* /tmp/gh-pages-deploy/

pushd /tmp/gh-pages-deploy > /dev/null
git add -A
git commit -m "Publish $GAME_NAME" --allow-empty
git push origin gh-pages
popd > /dev/null

git worktree remove /tmp/gh-pages-deploy --force
rm -rf "$DEPLOY_DIR"

REMOTE_URL="$(git remote get-url origin)"
REPO_PATH="$(echo "$REMOTE_URL" | sed -E 's#.*github\.com[:/]##; s#\.git$##')"
USER_NAME="$(echo "$REPO_PATH" | cut -d/ -f1)"
REPO_NAME="$(echo "$REPO_PATH" | cut -d/ -f2)"

popd > /dev/null

echo ""
echo "Published. It may take a minute to go live at:"
echo "  https://${USER_NAME}.github.io/${REPO_NAME}/"
echo ""
echo "(If Pages isn't enabled yet, enable it in the repo's Settings > Pages,"
echo "source: gh-pages branch.)"
