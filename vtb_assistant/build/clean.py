"""
Remove this project's own generated build output.

Deliberately narrower than `git clean`: this repo's .gitignore also covers
things that are expensive or annoying to lose (.venv, editor/tool state) —
a blanket `git clean -fdx` can't tell those apart from actual build output,
and run from the enclosing virtual_test_bed checkout it would also nuke
unrelated untracked model files. This script targets only the former: the
harvest/build-pack cache, the generated reference pack, ATTRIBUTION.md,
packaged zips, and Python/tool caches under this project's own tracked
source directories. It never touches .venv, .vscode, .claude, or anything
outside vtb_assistant/.

Usage: python build/clean.py [--dry-run]
"""

from __future__ import annotations

import argparse
import shutil
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent

# Whole directories this project's own build/package scripts write to.
GENERATED_DIRS = [
    "build/_cache",
    "skills/vtb-docs/references",
    "skills/vtb-docs/assets",
    "dist",
    ".pytest_cache",
    ".ruff_cache",
]

# Individual generated files.
GENERATED_FILES = [
    "ATTRIBUTION.md",
]

# Only searched under these roots — the directories that actually contain
# this project's own tracked Python source (build/*.py,
# skills/vtb-docs/scripts/*.py, tests/*.py) — never repo-wide, so this can
# never reach into .venv/ or virtual_test_bed/'s own bytecode caches.
PYCACHE_SEARCH_ROOTS = ["build", "skills", "tests"]


def find_targets(repo_root: Path) -> list[Path]:
    """Resolve every generated-output path that currently exists, deduplicated."""
    targets: list[Path] = []
    seen: set[Path] = set()

    def add(path: Path) -> None:
        if path.exists() and path not in seen:
            seen.add(path)
            targets.append(path)

    for relpath in GENERATED_DIRS:
        add(repo_root / relpath)
    for relpath in GENERATED_FILES:
        add(repo_root / relpath)
    for root in PYCACHE_SEARCH_ROOTS:
        root_path = repo_root / root
        if not root_path.is_dir():
            continue
        for pattern in ("__pycache__", "*.py[co]"):
            for match in root_path.rglob(pattern):
                add(match)

    return targets


def remove(paths: list[Path], dry_run: bool) -> None:
    """Delete each path, printing as it goes; one failure doesn't stop the rest."""
    if not paths:
        print("nothing to clean")
        return
    for path in paths:
        if not path.exists():
            # A *.py[co] match inside a __pycache__ dir that an earlier
            # entry already rmtree'd — not a failure, just a now-redundant
            # list entry.
            continue
        label = f"{path} ({'dir' if path.is_dir() else 'file'})"
        if dry_run:
            print(f"would remove {label}")
            continue
        try:
            if path.is_dir():
                shutil.rmtree(path)
            else:
                path.unlink()
            print(f"removed {label}")
        except OSError as exc:
            print(f"WARNING: failed to remove {label}: {exc}", file=sys.stderr)


def main(argv: list[str] | None = None) -> int:
    """Find and remove every generated-output path."""
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--dry-run", action="store_true",
        help="Print what would be removed without removing anything.",
    )
    args = parser.parse_args(argv)

    targets = find_targets(REPO_ROOT)
    remove(targets, args.dry_run)
    if targets and not args.dry_run:
        print(
            "regenerate with: uv run --group harvest python build/harvest.py "
            "&& uv run --group harvest python build/build_reference_pack.py",
        )
    return 0


if __name__ == "__main__":
    sys.exit(main())
