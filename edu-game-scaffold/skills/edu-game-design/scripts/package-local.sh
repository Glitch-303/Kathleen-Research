#!/usr/bin/env bash
# package-local.sh <game-name> [session-file-or-dir]
#
# Bundles the game into <game-name>/dist/<game-name>.zip for offline
# use, submission, or handoff. Safe to run any time; no network access,
# no account, no confirmation needed beyond invoking it.
#
# Also bundles the AI session transcript(s) for this game into a
# transcripts/ subfolder, regardless of scaffold or control condition —
# this is primary research data, not optional.
#
# Pi stores sessions outside the project folder, at
# ~/.pi/agent/sessions/ (or $PI_CODING_AGENT_DIR/sessions if that's
# set), organized by working directory — not inside <game-name>/ itself.
# The most reliable way to find the right one is to pass it explicitly:
# run /session inside your pi session first to see the current session
# file's path, then pass that path as the second argument here. If no
# path is given, this script makes a best-effort guess at the standard
# location; it prints a warning if it can't find anything, since a
# format change on pi's side could make that guess wrong.
set -euo pipefail

GAME_NAME="${1:-}"
SESSION_ARG="${2:-}"

if [[ -z "$GAME_NAME" ]]; then
  echo "Usage: ./package-local.sh <game-name> [session-file-or-dir]" >&2
  exit 1
fi

if [[ ! -d "$GAME_NAME" ]]; then
  echo "Error: directory '$GAME_NAME' not found. Run init-project.sh first." >&2
  exit 1
fi

DIST_DIR="$GAME_NAME/dist"
STAGE_DIR="$DIST_DIR/$GAME_NAME"

rm -rf "$STAGE_DIR"
mkdir -p "$STAGE_DIR"

# ---- Copy the game's playable files ----
if [[ ! -f "$GAME_NAME/index.html" ]]; then
  echo "ERROR: $GAME_NAME/index.html not found." >&2
  echo "  The entry point must be a file named exactly index.html at the" >&2
  echo "  root of the project folder for this to package correctly." >&2
  echo "  Rename your entry file to index.html and try again." >&2
  exit 1
fi

cp "$GAME_NAME/index.html" "$STAGE_DIR/"
[[ -d "$GAME_NAME/src" ]] && cp -r "$GAME_NAME/src" "$STAGE_DIR/"
[[ -d "$GAME_NAME/assets" ]] && cp -r "$GAME_NAME/assets" "$STAGE_DIR/"
[[ -f "$GAME_NAME/style.css" ]] && cp "$GAME_NAME/style.css" "$STAGE_DIR/"
[[ -f "$GAME_NAME/questions.html" ]] && cp "$GAME_NAME/questions.html" "$STAGE_DIR/"
[[ -f "$GAME_NAME/answers.md" ]] && cp "$GAME_NAME/answers.md" "$STAGE_DIR/"

# ---- Bundle the AI session transcript(s) ----
mkdir -p "$STAGE_DIR/transcripts"
TRANSCRIPTS_FOUND=0

if [[ -n "$SESSION_ARG" && -e "$SESSION_ARG" ]]; then
  # Explicit path given (a single .jsonl file, or a directory of them).
  if [[ -d "$SESSION_ARG" ]]; then
    cp "$SESSION_ARG"/*.jsonl "$STAGE_DIR/transcripts/" 2>/dev/null || true
  else
    cp "$SESSION_ARG" "$STAGE_DIR/transcripts/"
  fi
  TRANSCRIPTS_FOUND=$(find "$STAGE_DIR/transcripts" -name "*.jsonl" | wc -l | tr -d ' ')
else
  # Best-effort auto-discovery at pi's documented default location.
  # Sessions are keyed by the encoded absolute path of the working
  # directory they were run from: strip the leading slash, replace the
  # rest with dashes, wrap in double-dashes.
  SESSIONS_ROOT="${PI_CODING_AGENT_DIR:-$HOME/.pi/agent}/sessions"
  ABS_PATH="$(cd "$GAME_NAME" && pwd)"
  STRIPPED="${ABS_PATH#/}"
  ENCODED="$(echo "$STRIPPED" | tr '/' '-')"
  GUESS_DIR="$SESSIONS_ROOT/--$ENCODED--"

  if [[ -d "$GUESS_DIR" ]]; then
    cp "$GUESS_DIR"/*.jsonl "$STAGE_DIR/transcripts/" 2>/dev/null || true
    TRANSCRIPTS_FOUND=$(find "$STAGE_DIR/transcripts" -name "*.jsonl" | wc -l | tr -d ' ')
  fi
fi

if [[ "$TRANSCRIPTS_FOUND" -eq 0 ]]; then
  echo "WARNING: no session transcript found automatically." >&2
  echo "  Run /session inside pi to see the current session file's path," >&2
  echo "  then re-run: ./scripts/package-local.sh $GAME_NAME <that-path>" >&2
  rmdir "$STAGE_DIR/transcripts" 2>/dev/null || true
else
  echo "Bundled $TRANSCRIPTS_FOUND session transcript(s)."
fi

pushd "$DIST_DIR" > /dev/null
rm -f "$GAME_NAME.zip"
zip -rq "$GAME_NAME.zip" "$GAME_NAME"
popd > /dev/null

echo "Packaged: $DIST_DIR/$GAME_NAME.zip"
echo ""
echo "To test the packaged build:"
echo "  cd $STAGE_DIR && npx serve ."
