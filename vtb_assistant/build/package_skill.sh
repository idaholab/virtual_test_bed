#!/usr/bin/env bash
# Zip skills/vtb-docs/ for upload to claude.ai / ChatGPT Skills.
# SKILL.md must be at the zip root, not nested under a wrapper directory.
# For Claude Code (skills-dir or --plugin-dir), see package_plugin.sh instead.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILL_DIR="$REPO_ROOT/skills/vtb-docs"
DIST_DIR="$REPO_ROOT/dist"
ZIP_PATH="$DIST_DIR/vtb-docs-skill.zip"

if [[ ! -f "$SKILL_DIR/SKILL.md" ]]; then
  echo "error: $SKILL_DIR/SKILL.md not found" >&2
  exit 1
fi
if [[ ! -f "$REPO_ROOT/ATTRIBUTION.md" ]]; then
  echo "error: $REPO_ROOT/ATTRIBUTION.md not found (run build_reference_pack.py first)" >&2
  exit 1
fi

mkdir -p "$DIST_DIR"
rm -f "$ZIP_PATH"
cp "$REPO_ROOT/ATTRIBUTION.md" "$SKILL_DIR/ATTRIBUTION.md"
# -D: skip directory entries. claude.ai's Skills upload caps zips at 200
# files; directory entries count toward that too, so don't waste the budget.
# __pycache__/*.pyc come from running scripts/*.py locally (e.g. via
# pytest) — never intended for the shipped zip.
(cd "$SKILL_DIR" && zip -r -q -D "$ZIP_PATH" . -x '.*' '*__pycache__*' '*.pyc')
rm -f "$SKILL_DIR/ATTRIBUTION.md"

echo "wrote $ZIP_PATH"
FILE_COUNT="$(unzip -l "$ZIP_PATH" | tail -1 | awk '{print $2}')"
echo "$FILE_COUNT files (claude.ai's Skills upload limit is 200)"
if [[ "$FILE_COUNT" -gt 200 ]]; then
  echo "error: over the 200-file limit — consolidate more of references/docs/" >&2
  exit 1
fi
LISTING_FILE="$(mktemp)"
unzip -l "$ZIP_PATH" > "$LISTING_FILE"
head -5 "$LISTING_FILE"
rm -f "$LISTING_FILE"
