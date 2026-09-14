"""
Keyword search over the bundled VTB reference pack.

Stdlib-only (argparse, pathlib, json, re) so it runs under any host's plain
Python — no venv, no installs, no network. Searches
references/model-index.json (by name/tags/summary), every markdown file
under references/ (docs, acronyms), and
references/model-inputs/input-index.json (every indexed model `.i` input —
use get_input.py to fetch one's full content once you have its path).

Ranked by field priority, not raw word frequency: an exact title/name
match beats a structured-metadata match, which beats a heading match,
which beats a body-text match — a huge page repeating one common word
hundreds of times no longer buries a small, precise, on-topic result. An
`input` result's `is_primary` flag adds to its metadata score, so a
model's own primary input(s) rank ahead of incidental ones it happens to
share a directory with. An `input` result's metadata score also covers
its parsed MOOSE object types, parameter names, referenced files, and
MultiApps/Transfers usage — so a query naming a MOOSE class ("PointKinetics",
"TransientMultiApp") or a parameter ("restart_file_base") finds it even
though that term never appears in the file's path or top-level block
names; a query that names an object type exactly is treated as an exact
match, same tier as a title match. Query terms are expanded through
references/acronyms.md plus a small extra table of transient/safety-
analysis abbreviations (ULOF, PLOF, ...), so "SFR" also matches "sodium
fast reactor" wherever that appears. A short, hand-picked list of words
that are true of virtually the entire corpus ("model", "reactor",
"simulation", ...) is filtered out of the query before scoring — every
VTB model is a reactor simulation, so those words dilute ranking without
ever discriminating one result from another; genuinely useful-looking
words that are merely *common* (e.g. "results", "core", "steady") are
deliberately kept, see GENERIC_QUERY_STOPWORDS.

Usage: python search_docs.py "<query>" [-n MAX_RESULTS]
       [--kind model|doc|input] [--exact] [--json]
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path

SKILL_DIR = Path(__file__).resolve().parent.parent
SNIPPET_RADIUS = 80

# references/docs/*.md files bundle multiple VTB pages per category file
# (to stay under claude.ai's 200-file zip limit); each page is prefixed
# with this marker so a match can still be attributed to its real source.
PAGE_MARKER_RE = re.compile(r"<!-- vtb-page: (?P<relpath>\S+) -->")
ACRONYM_LINE_RE = re.compile(r"^-\s+\*\*(\S+)\*\*:\s+(.+)$")
HEADING_RE = re.compile(r"^#{1,3}\s+.+$", re.MULTILINE)

# Not in the shipped acronyms.md glossary, but confirmed present in the VTB
# corpus (transient/safety-analysis shorthand) — see build/RECON_NOTES.md.
EXTRA_ALIASES = {
    "ulof": "unprotected loss of flow",
    "plof": "protected loss of flow",
    "lofc": "loss of forced circulation",
}

# Deliberately short and hand-picked, not derived from a frequency
# threshold — confirmed against the real corpus (model-index.json,
# page-index.json) that every one of these is true of virtually the whole
# corpus and never the thing that distinguishes one result from another:
# "model" appears in 55% of model names, "reactor" in 27-29% of names and
# summaries. High frequency alone is NOT the bar — several similarly
# common words are deliberately excluded because they carry real
# discriminating value in this specific corpus:
#   - "core"/"steady"/"state"/"transient"/"test": real technical/naming
#     content (steady vs. transient is a genuine simulation-type
#     distinction; "Test" is baked into proper names like "Versatile
#     Test Reactor"; "core" distinguishes sibling pages within one
#     reactor's own family, e.g. gcmr's Core/Assembly/Balance-of-Plant).
#   - "mesh"/"materials"/"geometry"/"conditions"/"heat"/"thermal"/
#     "multiphysics"/"input"/"parameters": real technical-content nouns
#     that are also common section names — filtering them loses recall
#     for legitimate technical queries.
#   - "description"/"results" (26%/31% of headings): within one
#     reactor's own page family these are often the ONLY thing
#     distinguishing sibling pages (httr_reactor_description.md vs.
#     httr_model_results.md both share "HTTR") — a query for "HTTR
#     results" needs "results" to land on the right sibling.
#   - "running" (13.6% of headings, mostly boilerplate "## Running the
#     model" sections): also the literal correct word for the one
#     site-wide page whose actual topic is "how to run VTB models"
#     (vtb_pages/running_models.md).
# Verified programmatically: no model name and no page's relpath
# basename is composed entirely of these words — nothing becomes
# unfindable-by-name by filtering this specific list.
GENERIC_QUERY_STOPWORDS = frozenset({
    # Pure grammatical function words — carry no domain meaning ever.
    "a", "an", "the", "of", "and", "for", "to", "in", "with", "on", "is",
    # True of virtually the whole corpus; never a sibling-page/model
    # discriminator.
    "model", "models", "reactor", "reactors",
    "simulation", "simulations", "using",
})


def filter_generic_terms(tokens: list[str]) -> list[str]:
    """
    Drop GENERIC_QUERY_STOPWORDS from tokens, unless that would empty the list.

    An all-generic query ("reactor model") should still search *something*
    rather than error out on an empty token list — fall back to the
    original, unfiltered tokens in that case.
    """
    filtered = [t for t in tokens if t not in GENERIC_QUERY_STOPWORDS]
    return filtered if filtered else tokens


def tokenize(text: str) -> list[str]:
    """Split text into lowercase word tokens."""
    return [t for t in re.findall(r"[A-Za-z0-9_-]+", text.lower()) if t]


def load_acronyms() -> dict[str, str]:
    """Parse references/acronyms.md's `- **TERM**: expansion` lines."""
    path = SKILL_DIR / "references" / "acronyms.md"
    if not path.is_file():
        return {}
    acronyms = {}
    for line in path.read_text(encoding="utf-8").splitlines():
        match = ACRONYM_LINE_RE.match(line)
        if match:
            acronyms[match.group(1).lower()] = match.group(2)
    return acronyms


def build_aliases() -> dict[str, list[str]]:
    """Build a token -> expansion-tokens map from the glossary plus extras."""
    aliases = {term: tokenize(expansion) for term, expansion in load_acronyms().items()}
    for term, expansion in EXTRA_ALIASES.items():
        aliases.setdefault(term, tokenize(expansion))
    return aliases


def expand_tokens(tokens: list[str], aliases: dict[str, list[str]]) -> list[str]:
    """Add each alias's expansion words alongside the original token, deduplicated."""
    seen: set[str] = set()
    expanded = []
    for token in [*tokens, *(word for t in tokens for word in aliases.get(t, []))]:
        if token not in seen:
            seen.add(token)
            expanded.append(token)
    return expanded


def token_hits(text: str, tokens: list[str]) -> tuple[int, int]:
    """
    Return (distinct tokens matched, total hit count) for text.

    Matched on word boundaries, not plain substring — otherwise "to"
    matches inside "tool", inflating unrelated pages' scores with
    accidental partial hits.
    """
    lowered = text.lower()
    counts = {
        token: len(re.findall(rf"\b{re.escape(token)}\b", lowered))
        for token in tokens
    }
    distinct = sum(1 for count in counts.values() if count)
    return distinct, sum(counts.values())


def lenient_token_hits(text: str, tokens: list[str]) -> tuple[int, int]:
    """
    Like token_hits, but tokens of length >= 3 may match as a whole-word prefix.

    A token of length >= 3 may also match as a whole-word prefix (query
    "run" matches title "Running"). Used only for the small, bounded
    name/title and heading fields where
    the extra recall for word-form variants is worth the small precision
    cost — the much larger body field stays strictly word-boundary matched
    (token_hits) since a stray prefix match there (e.g. a short token
    matching many unrelated words in a long page) would reintroduce the
    "to" matches "tool" class of problem at scale.
    """
    lowered = text.lower()
    counts = {}
    for token in tokens:
        escaped = re.escape(token)
        pattern = rf"\b{escaped}\w*\b" if len(token) >= 3 else rf"\b{escaped}\b"
        counts[token] = len(re.findall(pattern, lowered))
    distinct = sum(1 for count in counts.values() if count)
    return distinct, sum(counts.values())


def find_snippet(text: str, tokens: list[str]) -> str:
    """Return a short snippet around the first token match, if any."""
    lowered = text.lower()
    first = min((lowered.find(t) for t in tokens if t in lowered), default=-1)
    if first < 0:
        return ""
    start = max(first - SNIPPET_RADIUS, 0)
    end = min(first + SNIPPET_RADIUS, len(text))
    return text[start:end].replace("\n", " ").strip()


EXACT_MATCH_MIN_LEN = 4
EXACT_MATCH_MIN_COVERAGE = 0.5


def is_exact_match(query: str, name_or_title: str) -> bool:
    """
    Whether the query and a name/title essentially name the same thing.

    True only when one string contains the other AND the shorter of the two
    covers at least half the longer. Substring containment alone was too
    eager: a short generic title like "Results", "Core", or "Mesh" is a
    substring of any longer query that merely mentions that word ("reactor
    core model"), floating it to the top exact-match tier above genuinely
    more relevant results. The coverage floor keeps real matches — "Versatile
    Test Reactor" still matches "versatile test reactor core model" (22/33) —
    while dropping the incidental-word ones. The len>=4 floor additionally
    keeps a 3-char token ("SAM") from qualifying as a bare substring.

    A single-word title is held to a stricter bar — near-equality, not the
    lenient coverage ratio above. Confirmed real bug: two unrelated pages
    are titled bare "Results" (7 chars); against a *short* query like
    "HTTR results" (12 chars), 7/12 = 58% clears the 50% coverage floor even
    though the title says nothing about "HTTR" at all — the char-length
    ratio can't tell "short title, short query" apart from "short title,
    long query" the way it's meant to. Checked against the real corpus:
    every single-word doc-page title here (Results, Introduction, Citing,
    Contact, Registration, Tutorials) is a generic, standalone-navigation
    title with no legitimate use for the lenient rule, and no model name is
    ever a single word — so requiring equality for this case costs nothing.
    """
    q, t = query.lower().strip(), (name_or_title or "").lower().strip()
    if not q or len(t) < EXACT_MATCH_MIN_LEN or not (q in t or t in q):
        return False
    if len(tokenize(t)) <= 1:
        return q == t
    return min(len(q), len(t)) >= EXACT_MATCH_MIN_COVERAGE * max(len(q), len(t))


def matches_object_type(query: str, object_types: list[str]) -> bool:
    """
    Whether the query names one of an input's parsed MOOSE object types exactly.

    Exact equality, not substring: a MOOSE class name is a precise
    identifier (unlike a title, which can be a longer descriptive phrase),
    so there's no coverage heuristic to apply here — either the query names
    the exact type, or it doesn't.
    """
    q = query.strip().lower()
    return any(q == t.lower() for t in object_types)


DOC_TITLE_RE = re.compile(r"^#\s+(.+)$", re.MULTILINE)


def extract_title(text: str) -> str | None:
    """Extract a markdown file's first H1, if any."""
    match = DOC_TITLE_RE.search(text)
    return match.group(1).strip() if match else None


def heading_text(section: str) -> str:
    """Join every markdown heading line (#, ##, ###) in a section."""
    return "\n".join(HEADING_RE.findall(section))


def split_into_pages(text: str) -> list[tuple[str | None, str]]:
    """
    Split a references/docs/*.md category file into its per-page sections.

    Each VTB page is prefixed with a `<!-- vtb-page: <relpath> -->` marker.
    Scoring must happen per-page, not over the whole (multi-megabyte,
    multi-page) category file, or a huge file wins on raw word repetition
    and buries the actually-relevant page. Files with no marker (plain
    single-topic files) come back as one (None, text) section.
    """
    markers = list(PAGE_MARKER_RE.finditer(text))
    if not markers:
        return [(None, text)]
    sections = []
    for i, marker in enumerate(markers):
        start = marker.end()
        end = markers[i + 1].start() if i + 1 < len(markers) else len(text)
        sections.append((marker.group("relpath"), text[start:end]))
    return sections


def load_page_index() -> dict[str, dict]:
    """Load references/page-index.json keyed by relpath, for title lookups."""
    path = SKILL_DIR / "references" / "page-index.json"
    if not path.is_file():
        return {}
    entries = json.loads(path.read_text(encoding="utf-8"))
    return {entry["relpath"]: entry for entry in entries}


def make_result(
    kind: str, title: str, path: str, source_url: str | None,
    retrieved_at: str | None, query: str, name_source: str,
    heading_source: str, body_source: str, tokens: list[str],
) -> dict | None:
    """Score one candidate result; returns None if no token matched at all."""
    name_distinct, _ = lenient_token_hits(name_source, tokens)
    heading_distinct, _ = lenient_token_hits(heading_source, tokens)
    body_distinct, body_total = token_hits(body_source, tokens)
    if not (name_distinct or heading_distinct or body_distinct):
        return None
    return {
        "kind": kind,
        "title": title,
        "path": path,
        "source_url": source_url,
        "retrieved_at": retrieved_at,
        "score": {
            "exact_match": is_exact_match(query, title),
            "name_title": name_distinct,
            "metadata": 0,
            "heading": heading_distinct,
            "body_distinct": body_distinct,
            "body_total": body_total,
        },
        "snippet": find_snippet(body_source, tokens),
    }


def model_body_text(model: dict) -> str:
    """
    Concatenate a model's human-meaningful text VALUES for body scoring.

    Deliberately excludes the JSON *keys*: scoring over json.dumps(model)
    let a query term equal to a schema key ("institution", "reactor",
    "geometry", "summary", ...) spuriously match every model. URL and
    boolean fields are skipped too — their tokens ("html", "gov", "true",
    commit hashes) are noise no user searches for.
    """
    parts = [
        model.get("name", ""),
        model.get("summary", ""),
        model.get("repo_path") or "",
    ]
    for value in model.get("tags", {}).values():
        parts.append(" ".join(value) if isinstance(value, list) else str(value))
    for field in ("codes_used_apps", "tests_apps"):
        parts.extend(model.get(field) or [])
    return " ".join(parts)


def search_model_index(tokens: list[str], query: str) -> list[dict]:
    """Search model-index.json entries, scoring name/metadata/body separately."""
    index_path = SKILL_DIR / "references" / "model-index.json"
    if not index_path.is_file():
        return []
    data = json.loads(index_path.read_text(encoding="utf-8"))
    results = []
    for model in data.get("models", []):
        name = model.get("name", "")
        metadata_text = " ".join(
            " ".join(v) if isinstance(v, list) else str(v)
            for v in model.get("tags", {}).values()
        )
        name_source = f"{name} {model.get('repo_path') or ''}"
        name_distinct, _ = lenient_token_hits(name_source, tokens)
        metadata_distinct, _ = lenient_token_hits(metadata_text, tokens)
        body_distinct, body_total = token_hits(model_body_text(model), tokens)
        if not (name_distinct or metadata_distinct or body_distinct):
            continue
        # A model's `name` isn't guaranteed unique in VTB's own source (a
        # handful of directories are documented by more than one tagged
        # page, and a couple of names collide across two entirely
        # different directories) — doc_url is the one field that's
        # unique per model-index entry, so fold it into `path` unlike a
        # bare name-based label, or two distinct results would print as
        # apparent duplicates differing only in source_url/snippet.
        results.append({
            "kind": "model",
            "title": name,
            "path": f"model-index.json :: {name} ({model.get('doc_url', '')})",
            "source_url": model.get("doc_url"),
            "retrieved_at": None,
            "score": {
                "exact_match": is_exact_match(query, name),
                "name_title": name_distinct,
                "metadata": metadata_distinct,
                "heading": 0,
                "body_distinct": body_distinct,
                "body_total": body_total,
            },
            "snippet": model.get("summary", ""),
        })
    return results


def search_markdown(
    tokens: list[str], query: str, page_index: dict[str, dict],
) -> list[dict]:
    """Search every markdown file under references/ (docs, acronyms, ...)."""
    results = []
    base = SKILL_DIR / "references"
    if not base.is_dir():
        return results
    for path in sorted(base.rglob("*.md")):
        text = path.read_text(encoding="utf-8", errors="replace")
        relpath = str(path.relative_to(SKILL_DIR))
        is_doc_bundle = relpath.startswith("references/docs/")
        sections = split_into_pages(text) if is_doc_bundle else [(None, text)]
        for source_page, section in sections:
            entry = page_index.get(source_page, {}) if source_page else {}
            # Doc-bundle pages get their title from page-index.json; other
            # markdown (acronyms, ...) has no such entry, so extract its own
            # H1 rather than falling back to the bare filename stem.
            fallback_title = extract_title(section)
            title = entry.get("title") or fallback_title or path.stem
            label = f"{relpath} :: {source_page}" if source_page else relpath
            result = make_result(
                kind="doc",
                title=title,
                path=label,
                source_url=entry.get("source_url"),
                retrieved_at=entry.get("retrieved_at"),
                query=query,
                name_source=f"{title} {source_page or relpath}",
                heading_source=heading_text(section),
                body_source=section,
                tokens=tokens,
            )
            if result:
                results.append(result)
    return results


def search_model_inputs(tokens: list[str], query: str) -> list[dict]:
    """
    Search references/model-inputs/input-index.json entries.

    Reads only the lean index — never inputs.jsonl's heavy content — so a
    search never pulls a multi-megabyte file into context; fetch a
    matched path's full content with get_input.py once you have it.
    """
    index_path = SKILL_DIR / "references" / "model-inputs" / "input-index.json"
    if not index_path.is_file():
        return []
    entries = json.loads(index_path.read_text(encoding="utf-8"))
    results = []
    for entry in entries:
        model_names = " ".join(entry["model_names"])
        title = f"{Path(entry['path']).name} ({model_names})"
        name_source = f"{model_names} {entry['path']}"
        name_distinct, _ = lenient_token_hits(name_source, tokens)
        body_distinct, body_total = token_hits(entry["snippet"], tokens)
        # A MOOSE object type ("PointKinetics"), parameter name
        # ("restart_file_base"), or referenced file often never appears in
        # the path, model name, or snippet preview at all — it's parsed
        # structure, not prose — so it needs its own metadata-tier text,
        # the same way search_model_index() scores tag values. "multiapps"/
        # "transfers" are included as literal words only when the flag is
        # true, so they're query-driven like everything else here rather
        # than an unconditional boost (unlike is_primary, below).
        metadata_text = " ".join([
            *entry.get("object_types", []),
            *entry.get("parameter_names", []),
            *entry.get("referenced_files", []),
            "multiapps" if entry.get("has_multiapps") else "",
            "transfers" if entry.get("has_transfers") else "",
        ])
        metadata_distinct, _ = lenient_token_hits(metadata_text, tokens)
        if not (name_distinct or metadata_distinct or body_distinct):
            continue
        # A model's own primary input(s) should rank ahead of a secondary
        # one it happens to share a directory with, regardless of whether
        # the query mentions "primary" — added into the metadata tier
        # (below name/title, above heading/body) rather than overriding
        # genuine query relevance.
        metadata = metadata_distinct + (1 if entry["is_primary"] else 0)
        exact_match = is_exact_match(query, title) or matches_object_type(
            query, entry.get("object_types", []),
        )
        results.append({
            "kind": "input",
            "title": title,
            "path": entry["path"],
            "source_url": entry["repo_url"],
            "retrieved_at": None,
            "score": {
                "exact_match": exact_match,
                "name_title": name_distinct,
                "metadata": metadata,
                "heading": 0,
                "body_distinct": body_distinct,
                "body_total": body_total,
            },
            "snippet": entry["snippet"],
        })
    return results


def sort_key(result: dict) -> tuple:
    """Priority tuple: exact match > name/title > metadata > heading > body."""
    score = result["score"]
    return (
        score["exact_match"], score["name_title"], score["metadata"],
        score["heading"], score["body_distinct"], score["body_total"],
    )


def print_text_results(results: list[dict]) -> None:
    """Print results in the plain-text format."""
    for result in results:
        score = result["score"]
        print(f"[{result['kind']}] {result['title']} — {result['path']}")
        if result["source_url"]:
            print(f"    {result['source_url']}")
        print(
            f"    score: exact={score['exact_match']} name={score['name_title']} "
            f"metadata={score['metadata']} heading={score['heading']} "
            f"body={score['body_distinct']}/{score['body_total']}",
        )
        if result["snippet"]:
            print(f"    {result['snippet']}")


def main(argv: list[str] | None = None) -> int:
    """Run the search and print ranked results."""
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("query", help="Search terms, e.g. \"VTR griffin\"")
    parser.add_argument(
        "-n", "--max-results", type=int, default=10, help="Maximum results to print",
    )
    parser.add_argument(
        "--kind", choices=["model", "doc", "input"],
        help="Restrict to one result kind",
    )
    parser.add_argument(
        "--exact", action="store_true",
        help="Only show exact title/name matches",
    )
    parser.add_argument(
        "--json", action="store_true", dest="as_json", help="Print JSON",
    )
    args = parser.parse_args(argv)

    base_tokens = tokenize(args.query)
    if not base_tokens:
        print("error: query has no searchable terms", file=sys.stderr)
        return 2
    tokens = expand_tokens(base_tokens, build_aliases())
    tokens = filter_generic_terms(tokens)

    page_index = load_page_index()
    results = (
        search_model_index(tokens, args.query)
        + search_markdown(tokens, args.query, page_index)
        + search_model_inputs(tokens, args.query)
    )
    if args.kind:
        results = [r for r in results if r["kind"] == args.kind]
    if args.exact:
        results = [r for r in results if r["score"]["exact_match"]]
    if not results:
        print(f"no results for: {args.query}")
        return 1

    results.sort(key=sort_key, reverse=True)
    results = results[: args.max_results]

    if args.as_json:
        print(json.dumps(results, indent=2))
    else:
        print_text_results(results)
    return 0


if __name__ == "__main__":
    sys.exit(main())
