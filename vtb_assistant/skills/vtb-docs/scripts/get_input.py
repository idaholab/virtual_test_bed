"""
Fetch one VTB model's MOOSE `.i` input file by its repo-relative path.

No need to load the whole multi-megabyte inputs.jsonl into context. Looks
up the path (or any recorded alias, for a symlinked file) in
references/model-inputs/input-index.json, then seeks directly to that
record's exact byte range in inputs.jsonl. Stdlib-only (argparse, json,
pathlib, sys) — no venv, no installs, no network.

Usage: python get_input.py sfr/abtr/abtr_ulof.i
       python get_input.py sfr/abtr/abtr_ulof.i --full
       python get_input.py --model "Advanced Burner Test Reactor Loss of Flow Accident"
       python get_input.py --list
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

SKILL_DIR = Path(__file__).resolve().parent.parent
MODEL_INPUTS_DIR = SKILL_DIR / "references" / "model-inputs"
INPUT_INDEX_PATH = MODEL_INPUTS_DIR / "input-index.json"
INPUTS_JSONL_PATH = MODEL_INPUTS_DIR / "inputs.jsonl"


def load_input_index() -> list[dict]:
    """Load references/model-inputs/input-index.json, or exit with a clear error."""
    if not INPUT_INDEX_PATH.is_file():
        print(f"error: {INPUT_INDEX_PATH} not found", file=sys.stderr)
        sys.exit(1)
    return json.loads(INPUT_INDEX_PATH.read_text(encoding="utf-8"))


def find_entry(index: list[dict], relpath: str) -> dict:
    """Find the unique index entry for relpath, matching its own path or an alias."""
    matches = [e for e in index if e["path"] == relpath or relpath in e["aliases"]]
    if not matches:
        print(f"error: unknown input path: {relpath}", file=sys.stderr)
        print("(use --list to see every known input path)", file=sys.stderr)
        sys.exit(1)
    if len(matches) > 1:
        print(
            f"error: {len(matches)} input-index entries for {relpath} — "
            "the reference pack is inconsistent, not a query problem",
            file=sys.stderr,
        )
        sys.exit(1)
    return matches[0]


def load_record(entry: dict) -> dict:
    """Seek to this entry's exact byte range in inputs.jsonl and decode it."""
    with INPUTS_JSONL_PATH.open("rb") as f:
        f.seek(entry["jsonl_offset"])
        raw = f.read(entry["jsonl_length"])
    return json.loads(raw.decode("utf-8"))


def print_listing(entries: list[dict]) -> None:
    """Print one path per line, flagging primary inputs, sorted primary-first."""
    for entry in sorted(entries, key=lambda e: (not e["is_primary"], e["path"])):
        marker = " [primary]" if entry["is_primary"] else ""
        print(f"{entry['path']}{marker}")


def main(argv: list[str] | None = None) -> int:
    """Print one input's content (or full record), or list inputs by model."""
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "relpath", nargs="?",
        help="Repo-relative input path, e.g. sfr/abtr/abtr_ulof.i",
    )
    parser.add_argument(
        "--full", action="store_true",
        help="Print the full record (blocks, cross-references, candidate "
        "editable parameters, known test runs) as JSON instead of just the "
        "raw file content",
    )
    parser.add_argument(
        "--model",
        help="List every indexed input for one model (exact model-index.json "
        "\"name\", primary inputs first)",
    )
    parser.add_argument(
        "--list", action="store_true", help="Print every known input path and exit",
    )
    args = parser.parse_args(argv)

    index = load_input_index()

    if args.list:
        print_listing(index)
        return 0

    if args.model:
        matches = [e for e in index if args.model in e["model_names"]]
        if not matches:
            print(f"error: no indexed inputs for model: {args.model}", file=sys.stderr)
            print(
                '(model names must match model-index.json\'s "name" field exactly '
                "— search_docs.py --kind model can confirm the exact spelling)",
                file=sys.stderr,
            )
            return 1
        repo_paths = sorted({e["model_repo_path"] for e in matches})
        if len(repo_paths) > 1:
            # A model name isn't guaranteed unique in VTB's own source — this
            # is a real upstream naming collision between distinct model
            # directories, not a broken index. Group rather than silently
            # pool, so the two aren't mistaken for one model's full input set.
            print(
                f'warning: "{args.model}" matches inputs across '
                f"{len(repo_paths)} distinct model directories in VTB's own "
                "source (an upstream naming collision, not a broken index) "
                "— grouping below, not merging:",
                file=sys.stderr,
            )
            for repo_path in repo_paths:
                print(f"\n# {repo_path}")
                print_listing([e for e in matches if e["model_repo_path"] == repo_path])
            return 0
        print_listing(matches)
        return 0

    if not args.relpath:
        print("error: give an input path, or pass --model/--list", file=sys.stderr)
        return 2

    entry = find_entry(index, args.relpath)
    record = load_record(entry)
    print(json.dumps(record, indent=2) if args.full else record["content"])
    return 0


if __name__ == "__main__":
    sys.exit(main())
