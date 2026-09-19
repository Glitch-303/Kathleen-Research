#!/usr/bin/env bash
# init-project.sh <game-name> ["concept description"]
#
# Scaffolds a minimal Phaser 3 project from the bundled template into
# ./<game-name>/, ready for the AI (or student) to implement the core
# mechanic in src/scenes/MainScene.js.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$SCRIPT_DIR/../assets/template"

GAME_NAME="${1:-}"
CONCEPT="${2:-}"

if [[ -z "$GAME_NAME" ]]; then
  echo "Usage: ./init-project.sh <game-name> [\"concept description\"]" >&2
  exit 1
fi

if [[ -e "$GAME_NAME" ]]; then
  echo "Error: '$GAME_NAME' already exists in $(pwd). Choose a different name or remove it." >&2
  exit 1
fi

cp -r "$TEMPLATE_DIR" "$GAME_NAME"

CONCEPT_VALUE="${CONCEPT:-a CS concept}"

if [[ "$(uname)" == "Darwin" ]]; then
  SED_INPLACE=(sed -i '')
else
  SED_INPLACE=(sed -i)
fi

# Stamp {{GAME_NAME}} / {{CONCEPT}} into every templated file.
TEMPLATED_FILES=(
  "$GAME_NAME/README.md"
  "$GAME_NAME/index.html"
  "$GAME_NAME/src/scenes/MainScene.js"
)
for f in "${TEMPLATED_FILES[@]}"; do
  [[ -f "$f" ]] || continue
  "${SED_INPLACE[@]}" "s#{{CONCEPT}}#${CONCEPT_VALUE//#/\\#}#g" "$f"
  "${SED_INPLACE[@]}" "s#{{GAME_NAME}}#${GAME_NAME}#g" "$f"
done

echo "Created ./$GAME_NAME"
echo ""
echo "Next steps:"
echo "  1. Implement the core mechanic in $GAME_NAME/src/scenes/MainScene.js"
echo "  2. Test locally:  cd $GAME_NAME && npx serve ."
echo "  3. When ready:    ./scripts/package-local.sh $GAME_NAME"
