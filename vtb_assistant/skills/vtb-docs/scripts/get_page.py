"""
Extract one VTB doc page by its repo-relative path.

No need to load or scan the whole multi-page category file it's bundled
in. Stdlib-only (argparse, json, pathlib, sys) — no venv, no installs, no
network. Looks up the page in references/page-index.json (written by
build/build_reference_pack.py) and slices its exact character range out of
the category file named there.

Usage: python get_page.py sfr/abtr/abtr.md
       python get_page.py --list          # print every known page path
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

SKILL_DIR = Path(__file__).resolve().parent.parent
PAGE_INDEX_PATH = SKILL_DIR / "references" / "page-index.json"


def load_page_index() -> list[dict]:
    """Load references/page-index.json, or exit with a clear error."""
    if not PAGE_INDEX_PATH.is_file():
        print(f"error: {PAGE_INDEX_PATH} not found", file=sys.stderr)
        sys.exit(1)
    return json.loads(PAGE_INDEX_PATH.read_text(encoding="utf-8"))


def find_entry(page_index: list[dict], relpath: str) -> dict:
    """Find the unique page-index entry for relpath, or exit with an error."""
    matches = [entry for entry in page_index if entry["relpath"] == relpath]
    if not matches:
        print(f"error: unknown page path: {relpath}", file=sys.stderr)
        print("(use --list to see every known page path)", file=sys.stderr)
        sys.exit(1)
    if len(matches) > 1:
        print(
            f"error: {len(matches)} page-index entries for {relpath} — "
            "the reference pack is inconsistent, not a query problem",
            file=sys.stderr,
        )
        sys.exit(1)
    return matches[0]


def extract_page(entry: dict) -> str:
    """Slice a page's exact text out of its bundle file."""
    bundle_path = SKILL_DIR / entry["bundle_file"]
    text = bundle_path.read_text(encoding="utf-8")
    return text[entry["start"]:entry["end"]]


def main(argv: list[str] | None = None) -> int:
    """Look up and print one page, or list every known page path."""
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "relpath", nargs="?", help="Repo-relative page path, e.g. sfr/abtr/abtr.md",
    )
    parser.add_argument(
        "--list", action="store_true", help="Print every known page path and exit",
    )
    args = parser.parse_args(argv)

    page_index = load_page_index()

    if args.list:
        for entry in sorted(page_index, key=lambda e: e["relpath"]):
            print(entry["relpath"])
        return 0

    if not args.relpath:
        print("error: give a page path, or pass --list", file=sys.stderr)
        return 2

    entry = find_entry(page_index, args.relpath)
    print(extract_page(entry))
    return 0


if __name__ == "__main__":
    sys.exit(main())
