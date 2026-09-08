"""
Harvest raw content from the enclosing virtual_test_bed checkout into build/_cache/raw/.

This script only extracts — it does not curate or summarize. `vtb_assistant/`
lives inside the idaholab/virtual_test_bed checkout it documents, so the
source tree to harvest is just this repo's parent directory. It writes plain
JSON describing: doc pages (with their MooseDocs `!tag` metadata and
`!listing` references), MOOSE `tests`/`hpc_tests` spec files (which name the
app+input each test needs), and the open-source licensing tiers documented
in `vtb_pages/models_by_codes_used.md`. `build_reference_pack.py` turns this
raw output into the shipped skill content.

Run with: uv run --group harvest python build/harvest.py [--dry-run]
"""

from __future__ import annotations

import argparse
import json
import re
import subprocess
import sys
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
DEFAULT_SOURCE_DIR = REPO_ROOT.parent
CACHE_DIR = REPO_ROOT / "build" / "_cache"
RAW_DIR = CACHE_DIR / "raw"

DOC_SITE_BASE = "https://virtualtestbed.inl.gov"

# Directories at the repo root that never contain models or content to harvest.
NON_MODEL_DIRS = {".git", ".civet", ".github", "apps", "doc", "scripts"}

# Root `testroot`'s `known_capabilities` vocabulary, mapped to a canonical app
# slug matching the (lowercased) `apps/<slug>` submodule directory name.
CAPABILITY_TO_APP = {
    "bisonapp": "bison",
    "bluecrabapp": "blue_crab",
    "cardinalapp": "cardinal",
    "combinedapp": "combined",
    "direwolfapp": "dire_wolf",
    "griffinapp": "griffin",
    "grizzlyapp": "grizzly",
    "mastodonapp": "mastodon",
    "pronghornapp": "pronghorn",
    "reactorapp": "reactor",
    "relap7app": "relap-7",
    "mooseapp": "mooseapp",
    "sabertoothapp": "sabertooth",
    "salamanderapp": "salamander",
    "samapp": "sam",
    "sockeyeapp": "sockeye",
    "subchannelapp": "subchannel",
    "thermalhydraulicsapp": "thermal_hydraulics",
    "tmap8app": "tmap8",
}

BLOCK_LINE_RE = re.compile(r"^\s*\[([^\[\]]*)\]\s*$")
TAG_START_RE = re.compile(r"^!tag\b(?P<rest>.*(?:\n[ \t]+.*)*)", re.MULTILINE)
LISTING_RE = re.compile(r"^!listing[ \t]+(?P<path>\S+)(?P<opts>[^\n]*)$", re.MULTILINE)
BLOCK_OPT_RE = re.compile(r"\bblock=(?P<block>[A-Za-z0-9_:./]+)")
DOC_LINK_RE = re.compile(r"\[documentation\]\(([^)]+)\)")
INCLUDE_RE = re.compile(r"^!include\s+(?P<path>\S+)\s*$", re.MULTILINE)
MODEL_LINK_RE = re.compile(
    r"Model link:\s*\[[^\]]*\]\("
    r"https://github\.com/idaholab/virtual_test_bed/tree/[^/]+/([^)]+)\)",
)
# Test-spec `capabilities =` values are boolean expressions, e.g.
# "method=opt & (griffinapp | bluecrabapp)" or "griffinapp)' # times out" —
# extract just the app-name tokens, not method= predicates/parens/comments.
APP_TOKEN_RE = re.compile(r"[a-zA-Z_]\w*app\b")
# Doc-prose citations of a `.i` input file, beyond `!listing` (which only
# inlines a file's content — most model pages never use it at all). Three
# patterns cover the ways a page mentions a specific input by name:
#   - a shell run command, e.g. "sam-opt -i abtr_ss.i" (confirmed the
#     dominant real-world pattern — 117 occurrences repo-wide, vs. 12
#     markdown links and 8 italic mentions);
#   - a markdown link whose target ends in .i, e.g. "[abtr_ulof.i](...)";
#   - an italicized bare mention, e.g. "*htr-10-critical.i*".
RUN_COMMAND_INPUT_RE = re.compile(r"-i\s+([\w.\-/]+\.i)\b")
MARKDOWN_LINK_INPUT_RE = re.compile(r"\[[^\]]*\]\(([^)]*\.i)\)")
ITALIC_INPUT_RE = re.compile(r"\*([\w.\-/]+\.i)\*")
# A test-spec field's value can be a bare token or a quoted string — and a
# quoted string (e.g. multi-line `cli_args = "..."`) can itself span
# several lines, confirmed in 21 of 91 tests files. [^"]/[^'] (unlike `.`)
# match newlines too, so the quoted alternatives correctly span lines
# without needing re.DOTALL; only the field *name* is anchored to line start.
TEST_FIELD_RE = re.compile(
    r'^[ \t]*([A-Za-z_][A-Za-z0-9_]*)[ \t]*=[ \t]*'
    r'''(?:"([^"]*)"|'([^']*)'|(\S+))''',
    re.MULTILINE,
)


def parse_args(argv: list[str] | None = None) -> argparse.Namespace:
    """Parse command-line arguments."""
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--source-dir",
        type=Path,
        default=DEFAULT_SOURCE_DIR,
        help="Path to a virtual_test_bed checkout (default: this repo's parent dir)",
    )
    parser.add_argument(
        "--cache-dir",
        type=Path,
        default=CACHE_DIR,
        help="Where to write raw harvest output (default: %(default)s)",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Print what would be harvested without writing any files.",
    )
    return parser.parse_args(argv)


def ensure_source_dir(source_dir: Path, dry_run: bool) -> tuple[Path, str]:
    """Return (source_dir, commit_sha) for an existing virtual_test_bed checkout."""
    if not (source_dir / "doc" / "content").is_dir():
        sys.exit(
            f"{source_dir} doesn't look like a virtual_test_bed checkout "
            "(no doc/content/ found) — pass --source-dir to point at one."
        )
    if dry_run:
        return source_dir, "<unknown, dry-run>"
    commit = subprocess.run(
        ["git", "-C", str(source_dir), "rev-parse", "HEAD"],
        capture_output=True, text=True, check=True,
    ).stdout.strip()
    return source_dir, commit


def parse_tag_block(text: str) -> dict | None:
    """Parse a MooseDocs `!tag name=... description=... pairs=k:v ...` block."""
    match = TAG_START_RE.search(text)
    if not match:
        return None
    block = "!tag" + match.group("rest")
    lines = block.splitlines()
    lines[0] = lines[0][len("!tag"):]

    result: dict = {"tags": {}}
    in_pairs = False
    for line in lines:
        stripped = line.strip()
        if not stripped:
            continue
        if stripped.startswith("pairs="):
            in_pairs = True
            _consume_pair(stripped[len("pairs="):], result["tags"])
            continue
        if in_pairs:
            if ":" in stripped:
                _consume_pair(stripped, result["tags"])
                continue
            in_pairs = False
        if "=" in stripped:
            key, _, val = stripped.partition("=")
            result[key.strip()] = val.strip()
    return result


def _consume_pair(text: str, tags: dict) -> None:
    """Add one `key:value` (possibly `;`-separated list) pair into `tags`."""
    key, _, val = text.partition(":")
    key, val = key.strip(), val.strip()
    tags[key] = [v for v in val.split(";") if v] if ";" in val else val


def find_listing_refs(text: str) -> list[dict]:
    """Find `!listing <file> [block=<name>]` references in a doc page."""
    refs = []
    for match in LISTING_RE.finditer(text):
        block_match = BLOCK_OPT_RE.search(match.group("opts"))
        refs.append({
            "path": match.group("path").lstrip("/"),
            "block": block_match.group("block") if block_match else None,
        })
    return refs


def find_block_span(lines: list[str], name: str) -> tuple[int, int] | None:
    """Find the (open_idx, close_idx) of the first depth-0 `[name]` ... `[]` span."""
    depth = 0
    open_idx = None
    for i, line in enumerate(lines):
        match = BLOCK_LINE_RE.match(line)
        if not match:
            continue
        token = match.group(1)
        is_close = token in ("", "../")
        if open_idx is None:
            if not is_close and token.lstrip("./") == name:
                open_idx = i
                depth = 1
            continue
        if is_close:
            depth -= 1
            if depth == 0:
                return open_idx, i
        else:
            depth += 1
    return None


def child_blocks(
    lines: list[str], open_idx: int, close_idx: int,
) -> list[tuple[str, int, int]]:
    """Return the direct child (name, open_idx, close_idx) blocks within a span."""
    children = []
    depth = 0
    child_open = None
    child_name = None
    for i in range(open_idx + 1, close_idx):
        match = BLOCK_LINE_RE.match(lines[i])
        if not match:
            continue
        token = match.group(1)
        is_close = token in ("", "../")
        if depth == 0:
            if not is_close:
                depth = 1
                child_open = i
                child_name = token.lstrip("./")
            continue
        if is_close:
            depth -= 1
            if depth == 0:
                children.append((child_name, child_open, i))
        else:
            depth += 1
    return children


def find_block_anywhere(lines: list[str], name: str) -> tuple[int, int] | None:
    """
    Find a `[name]` ... `[]` span at any nesting depth (not just depth 0).

    Falls back to a prefix match (`name` followed by `-` or `/`) if there's no
    exact match, since MOOSE's newer "Physics" syntax uses composite bracket
    names like `[NavierStokes/Flow/flow]`, and some doc pages reference a
    hyphenated family (`IHX2-in`/`IHX2-out`) by its common prefix.
    """
    stack: list[tuple[int, str]] = []
    prefix_match: tuple[int, int] | None = None
    for i, line in enumerate(lines):
        match = BLOCK_LINE_RE.match(line)
        if not match:
            continue
        token = match.group(1)
        if token in ("", "../"):
            if stack:
                open_idx, open_name = stack.pop()
                if open_name == name:
                    return open_idx, i
                prefixes = (f"{name}-", f"{name}/")
                if prefix_match is None and open_name.startswith(prefixes):
                    prefix_match = (open_idx, i)
        else:
            stack.append((i, token.lstrip("./")))
    return prefix_match


def extract_hit_block(text: str, block_path: str) -> str | None:
    """
    Extract a named MOOSE hit-format block, e.g. for `!listing ... block=Mesh`.

    `block_path` may be slash-nested (`Mesh/fuel_pin_mesh`) to reach a subblock.
    The first segment may live at any nesting depth (e.g. a bare-named
    `Components` sub-block); later segments must be direct children of the
    previous segment.
    """
    lines = text.splitlines()
    parts = block_path.split("/")
    span = find_block_span(lines, parts[0]) or find_block_anywhere(lines, parts[0])
    if span is None:
        return None
    for part in parts[1:]:
        match = next(
            (c for c in child_blocks(lines, span[0], span[1]) if c[0] == part), None,
        )
        if match is None:
            return None
        span = (match[1], match[2])
    open_idx, close_idx = span
    return "\n".join(lines[open_idx:close_idx + 1])


def parse_tests_file(path: Path, source_dir: Path) -> list[dict]:
    """Parse a MOOSE `tests`/`hpc_tests` spec file into per-test dicts."""
    text = path.read_text(encoding="utf-8", errors="replace")
    lines = text.splitlines()
    # MOOSE's hit-format parser accepts either casing for this root block —
    # confirmed 10 of 91 tests files in the repo use lowercase [tests], and
    # find_block_span is otherwise case-sensitive (deliberately, elsewhere:
    # MOOSE variable/block names generally are case-sensitive) — so try
    # both here rather than making the shared helper case-insensitive.
    span = find_block_span(lines, "Tests") or find_block_span(lines, "tests")
    if not span:
        return []
    open_idx, close_idx = span
    tests = []
    for name, child_open, child_close in child_blocks(lines, open_idx, close_idx):
        body = "\n".join(lines[child_open + 1:child_close])
        fields: dict[str, str] = {}
        for match in TEST_FIELD_RE.finditer(body):
            key = match.group(1)
            raw_value = match.group(2) or match.group(3) or match.group(4) or ""
            # Continuation lines keep their original leading whitespace as
            # part of the captured value — collapse to single spaces.
            fields[key] = re.sub(r"\s+", " ", raw_value).strip()
        raw_capabilities = fields.get("capabilities", "")
        capabilities = [
            c.strip() for c in raw_capabilities.split("|") if c.strip()
        ]
        # Extract app tokens directly from the raw expression rather than
        # from the `|`-split fragments above: capabilities are boolean
        # expressions (`method=opt & (griffinapp | bluecrabapp)`), and
        # splitting on `|` first leaves `&`/parens/`method=opt`/trailing
        # comments in the fragments, polluting the app list. A token
        # immediately preceded by `!` (ignoring whitespace) is a *negated*
        # requirement (`!bisonapp` means "must NOT have bison", the opposite
        # of a required app) — APP_TOKEN_RE matches the bare token either
        # way, so check what precedes each match rather than skip it here.
        raw_tokens = [
            m.group(0)
            for m in APP_TOKEN_RE.finditer(raw_capabilities)
            if not raw_capabilities[:m.start()].rstrip().endswith("!")
        ]
        apps = sorted({CAPABILITY_TO_APP.get(token, token) for token in raw_tokens})
        # A token with no entry in CAPABILITY_TO_APP is passed through as
        # itself rather than dropped (still useful — better an honest
        # unrecognized slug than silently losing the capability), but
        # report it rather than accepting it silently: it's either a new
        # app/module this map hasn't caught up with, or evidence
        # APP_TOKEN_RE mis-extracted something. Recorded per-test so
        # main() can aggregate and warn.
        unknown_tokens = sorted({t for t in raw_tokens if t not in CAPABILITY_TO_APP})
        tests.append({
            "tests_file": str(path.relative_to(source_dir)),
            "name": name,
            "type": fields.get("type"),
            "input": fields.get("input"),
            "capabilities": capabilities,
            "apps": apps,
            "unknown_capability_tokens": unknown_tokens,
            "prereq": fields.get("prereq"),
            "exodiff": fields.get("exodiff"),
            "csvdiff": fields.get("csvdiff"),
            "cli_args": fields.get("cli_args"),
            "is_hpc": path.name == "hpc_tests",
        })
    return tests


def walk_tests_files(source_dir: Path) -> list[dict]:
    """Find and parse every `tests`/`hpc_tests` file under model-category dirs."""
    results = []
    for category_dir in source_dir.iterdir():
        skip = (
            not category_dir.is_dir()
            or category_dir.name in NON_MODEL_DIRS
            or category_dir.name.startswith(".")
        )
        if skip:
            continue
        for tests_path in category_dir.rglob("*"):
            if tests_path.is_file() and tests_path.name in ("tests", "hpc_tests"):
                results.extend(parse_tests_file(tests_path, source_dir))
    return results


def collect_unknown_capability_tokens(tests: list[dict]) -> list[str]:
    """Aggregate every `*app` token parse_tests_file couldn't map, sorted, deduped."""
    return sorted({
        token for t in tests for token in t.get("unknown_capability_tokens", [])
    })


def cited_input_basenames(pages: list[dict]) -> set[str]:
    """
    Union every `.i` file basename a set of doc pages cites, across all of them.

    A model's citations are spread over however many pages document it (one
    for ABTR, three for htr10, nine for the pbr-tutorial) — the caller is
    expected to pass every page belonging to one model. `!listing` refs
    alone are not enough: e.g. sfr/abtr's page cites both abtr_ss.i and
    abtr_ulof.i only as `-i <file>.i` run commands, never via `!listing` —
    checked directly against the source, confirmed 0-of-2 there vs. 2-of-2
    for htr10 and 8-of-8 for the pbr-tutorial, so real coverage genuinely
    varies per model and all four signals below are needed.
    """
    names: set[str] = set()
    for page in pages:
        for ref in page.get("listing_refs", []):
            path = ref.get("path", "")
            if path.endswith(".i"):
                names.add(Path(path).name)
        text = page.get("raw_markdown", "")
        for regex in (RUN_COMMAND_INPUT_RE, MARKDOWN_LINK_INPUT_RE, ITALIC_INPUT_RE):
            for match in regex.finditer(text):
                names.add(Path(match.group(1)).name)
    return names


def git_blob_sha(source_dir: Path, repo_path: str) -> str | None:
    """
    Return the git blob SHA of `repo_path` at the checkout's current HEAD.

    Uses `git rev-parse HEAD:<path>` rather than hashing file content
    directly, so it matches what GitHub's own blob/tree API would return
    for the same path at the same commit (including for a path Git LFS
    would otherwise smudge locally — the tree entry's SHA is what
    `rev-parse` reports, not a hash of locally-materialized content).
    Returns None if the path isn't tracked at HEAD (shouldn't happen for a
    path this build just walked on disk, but don't raise into a build
    failure over it — the caller can decide how to report a None).
    """
    result = subprocess.run(
        ["git", "-C", str(source_dir), "rev-parse", f"HEAD:{repo_path}"],
        capture_output=True, text=True, check=False,
    )
    if result.returncode != 0:
        return None
    return result.stdout.strip()


def doc_url_for(relpath: Path) -> str:
    """Map a doc/content-relative markdown path to its public documentation URL."""
    return f"{DOC_SITE_BASE}/{relpath.with_suffix('.html').as_posix()}"


def walk_doc_content(source_dir: Path) -> list[dict]:
    """Extract every doc/content/ markdown page, its !tag block, and !listing refs."""
    content_dir = source_dir / "doc" / "content"
    pages = []
    for md_path in sorted(content_dir.rglob("*.md")):
        if md_path.name == "template.md":
            continue
        relpath = md_path.relative_to(content_dir)
        text = md_path.read_text(encoding="utf-8", errors="replace")
        model_link_match = MODEL_LINK_RE.search(text)
        pages.append({
            "relpath": relpath.as_posix(),
            "doc_url": doc_url_for(relpath),
            "raw_markdown": text,
            "tag": parse_tag_block(text),
            "listing_refs": find_listing_refs(text),
            "model_link_path": model_link_match.group(1) if model_link_match else None,
        })
    return pages


def extract_hit_block_with_includes(
    path: Path, block_name: str, _depth: int = 0,
) -> str | None:
    """
    Extract a named hit-format block from `path`, following `!include` lines.

    `!listing file block=X` sometimes names a block that isn't directly in `file`
    but in a file it `!include`s (e.g. a shared `*_base.i`) — MOOSE resolves this
    at build time, so the harvester follows the same chain, up to a depth of 5.
    """
    if _depth > 5 or not path.is_file():
        return None
    text = path.read_text(encoding="utf-8", errors="replace")
    found = extract_hit_block(text, block_name)
    if found is not None:
        return found
    for match in INCLUDE_RE.finditer(text):
        included = path.parent / match.group("path")
        found = extract_hit_block_with_includes(included, block_name, _depth + 1)
        if found is not None:
            return found
    return None


def resolve_listing_path(
    ref_path: str, doc_relpath: str, source_dir: Path,
) -> Path | None:
    """
    Find the file a `!listing` reference points to.

    Most `!listing` paths are relative to the repo root, but some (observed in
    e.g. `htgr/gpbr200/core_neutronics.md`) are relative to the doc page's own
    top-level category directory instead. Fall back to a repo-wide filename
    search, used only when it's unambiguous, as a last resort.
    """
    direct = source_dir / ref_path
    if direct.is_file():
        return direct
    category = doc_relpath.split("/", 1)[0]
    via_category = source_dir / category / ref_path
    if via_category.is_file():
        return via_category
    matches = list(source_dir.glob(f"**/{Path(ref_path).name}"))
    return matches[0] if len(matches) == 1 else None


def resolve_listing_refs(pages: list[dict], source_dir: Path) -> None:
    """Fill in each page's listing_refs with the actual block content, in place."""
    for page in pages:
        for ref in page["listing_refs"]:
            target = resolve_listing_path(ref["path"], page["relpath"], source_dir)
            if target is None:
                ref["content"] = None
            elif ref["block"]:
                ref["content"] = extract_hit_block_with_includes(target, ref["block"])
            else:
                ref["content"] = target.read_text(encoding="utf-8", errors="replace")


def parse_open_source_tiers(source_dir: Path) -> dict[str, str]:
    """Parse fully/partially-open-source doc-page lists from models_by_codes_used."""
    path = source_dir / "doc" / "content" / "vtb_pages" / "models_by_codes_used.md"
    if not path.is_file():
        return {}
    tiers: dict[str, str] = {}
    current: str | None = None
    for line in path.read_text(encoding="utf-8", errors="replace").splitlines():
        if line.startswith("!alert note title=Fully Open-Source"):
            current = "fully"
            continue
        if line.startswith("!alert note title=Partially Open-Source"):
            current = "partially"
            continue
        is_untitled_alert = line.startswith("!alert") and "title=" not in line
        if line.startswith("##") or is_untitled_alert:
            current = None
            continue
        if current:
            for match in DOC_LINK_RE.finditer(line):
                key = match.group(1)
                if key.endswith(".md"):
                    key = key[:-len(".md")]
                tiers[key] = current
    return tiers


def main(argv: list[str] | None = None) -> int:
    """Run the harvest."""
    args = parse_args(argv)
    source_dir, commit = ensure_source_dir(args.source_dir, args.dry_run)
    print(f"source_dir={source_dir} commit={commit}")

    if args.dry_run:
        print("[dry-run] would walk doc/content/ for markdown pages")
        print("[dry-run] would walk model-category dirs for tests/hpc_tests files")
        print("[dry-run] would parse models_by_codes_used.md open-source tiers")
        return 0

    pages = walk_doc_content(source_dir)
    resolve_listing_refs(pages, source_dir)
    tests = walk_tests_files(source_dir)
    open_source_tiers = parse_open_source_tiers(source_dir)
    unknown_capability_tokens = collect_unknown_capability_tokens(tests)
    if unknown_capability_tokens:
        print(
            f"WARNING: {len(unknown_capability_tokens)} unrecognized capability "
            f"token(s) not in CAPABILITY_TO_APP (passed through as-is, not "
            f"dropped): {', '.join(unknown_capability_tokens)}",
            file=sys.stderr,
        )

    args.cache_dir.joinpath("raw").mkdir(parents=True, exist_ok=True)
    raw_dir = args.cache_dir / "raw"
    (raw_dir / "meta.json").write_text(json.dumps({
        "source_commit": commit,
        "unknown_capability_tokens": unknown_capability_tokens,
    }, indent=2))
    (raw_dir / "docs.json").write_text(json.dumps(pages, indent=2))
    (raw_dir / "tests.json").write_text(json.dumps(tests, indent=2))
    (raw_dir / "open_source_tiers.json").write_text(
        json.dumps(open_source_tiers, indent=2),
    )

    print(f"wrote {len(pages)} doc pages, {len(tests)} parsed tests, "
          f"{len(open_source_tiers)} open-source-tier entries to {raw_dir}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
