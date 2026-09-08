#!/usr/bin/env bash
# Zip the full plugin (.claude-plugin/, commands/, skills/vtb-docs/) for
# Claude Code. Extracting the result to ~/.claude/skills/vtb-assistant/ (or
# a project's .claude/skills/vtb-assistant/) auto-loads it as a plugin,
# with no build step and no marketplace — confirmed via `claude plugin list`
# reporting it as a "Skills-directory plugin". `--plugin-dir <this-zip>`
# also loads it directly, for a single session.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIST_DIR="$REPO_ROOT/dist"
ZIP_PATH="$DIST_DIR/vtb-assistant-plugin.zip"

for required in \
  "$REPO_ROOT/.claude-plugin/plugin.json" \
  "$REPO_ROOT/skills/vtb-docs/SKILL.md" \
  "$REPO_ROOT/ATTRIBUTION.md"
do
  if [[ ! -f "$required" ]]; then
    echo "error: $required not found" >&2
    exit 1
  fi
done

mkdir -p "$DIST_DIR"
rm -f "$ZIP_PATH"
# SKILL.md's own "see ATTRIBUTION.md" link is a same-directory reference
# (it's also shipped standalone by package_skill.sh, where SKILL.md and
# ATTRIBUTION.md always end up side by side) — mirror that here so the
# link resolves correctly no matter which package someone extracts, in
# addition to the top-level copy every other plugin file expects.
cp "$REPO_ROOT/ATTRIBUTION.md" "$REPO_ROOT/skills/vtb-docs/ATTRIBUTION.md"
# No -x '.*' here: .claude-plugin/ is a required top-level dir and would be
# excluded by that pattern too (it starts with a dot, same as unwanted
# noise like .DS_Store would). -D skips directory entries (no file-count
# limit on this path, unlike package_skill.sh, but no reason to waste space).
# __pycache__/*.pyc come from running scripts/*.py locally (e.g. via
# pytest) — never intended for the shipped zip.
(cd "$REPO_ROOT" && zip -r -q -D "$ZIP_PATH" .claude-plugin commands skills/vtb-docs ATTRIBUTION.md -x '*.DS_Store' '*__pycache__*' '*.pyc')
rm -f "$REPO_ROOT/skills/vtb-docs/ATTRIBUTION.md"

echo "wrote $ZIP_PATH"
FILE_COUNT="$(unzip -l "$ZIP_PATH" | tail -1 | awk '{print $2}')"
echo "$FILE_COUNT files"
LISTING_FILE="$(mktemp)"
unzip -l "$ZIP_PATH" > "$LISTING_FILE"
head -8 "$LISTING_FILE"
rm -f "$LISTING_FILE"
