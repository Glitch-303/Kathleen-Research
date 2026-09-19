#!/usr/bin/env bash
# publish-itch.sh <game-name> <itch-user>/<itch-game-slug>
#
# LIVE PUBLISH — makes the game reachable at a public URL on itch.io.
# The AI invoking this MUST have already asked the student for explicit
# confirmation. Requires the `butler` CLI, installed and logged in
# (`butler login`). See references/publishing-guide.md for prerequisites.
set -euo pipefail

GAME_NAME="${1:-}"
ITCH_TARGET="${2:-}"

if [[ -z "$GAME_NAME" || -z "$ITCH_TARGET" ]]; then
  echo "Usage: ./publish-itch.sh <game-name> <itch-user>/<itch-game-slug>" >&2
  exit 1
fi

if ! command -v butler > /dev/null 2>&1; then
  echo "Error: 'butler' CLI not found." >&2
  echo "Install it first: https://itch.io/docs/butler/installing.html" >&2
  echo "Then run: butler login" >&2
  exit 1
fi

if [[ ! -d "$GAME_NAME" ]]; then
  echo "Error: directory '$GAME_NAME' not found. Run init-project.sh first." >&2
  exit 1
fi

echo "About to publish '$GAME_NAME' to itch.io as ${ITCH_TARGET}:html5"
echo "This will make it reachable at a public URL. Continuing..."

# Build a clean deploy folder (reuse package-local staging logic).
DEPLOY_DIR="$(mktemp -d)"
cp "$GAME_NAME/index.html" "$DEPLOY_DIR/"
[[ -d "$GAME_NAME/src" ]] && cp -r "$GAME_NAME/src" "$DEPLOY_DIR/"
[[ -d "$GAME_NAME/assets" ]] && cp -r "$GAME_NAME/assets" "$DEPLOY_DIR/"
[[ -f "$GAME_NAME/style.css" ]] && cp "$GAME_NAME/style.css" "$DEPLOY_DIR/"

butler push "$DEPLOY_DIR" "${ITCH_TARGET}:html5"

rm -rf "$DEPLOY_DIR"

echo ""
echo "Published to https://${ITCH_TARGET/\//.itch.io/}"
