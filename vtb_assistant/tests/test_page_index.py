import json
import re
import subprocess
import sys
from pathlib import Path

import pytest

REPO_ROOT = Path(__file__).resolve().parent.parent
SKILL_DIR = REPO_ROOT / "skills" / "vtb-docs"
REFERENCES_DIR = SKILL_DIR / "references"
PAGE_INDEX_PATH = REFERENCES_DIR / "page-index.json"
GET_PAGE_SCRIPT = SKILL_DIR / "scripts" / "get_page.py"
PAGE_MARKER_RE = re.compile(r"<!-- vtb-page: (\S+) -->")

pytestmark = pytest.mark.skipif(
    not PAGE_INDEX_PATH.is_file(),
    reason="generated pack absent; run build/build_reference_pack.py",
)


def _page_index() -> list[dict]:
    return json.loads(PAGE_INDEX_PATH.read_text(encoding="utf-8"))


def _run_get_page(*args: str) -> subprocess.CompletedProcess:
    return subprocess.run(
        [sys.executable, str(GET_PAGE_SCRIPT), *args],
        capture_output=True, text=True, check=False,
    )


def test_every_page_marker_has_exactly_one_index_entry() -> None:
    entry_counts: dict[str, int] = {}
    for entry in _page_index():
        relpath = entry["relpath"]
        entry_counts[relpath] = entry_counts.get(relpath, 0) + 1

    marker_count = 0
    for category_file in (REFERENCES_DIR / "docs").glob("*.md"):
        text = category_file.read_text(encoding="utf-8")
        for match in PAGE_MARKER_RE.finditer(text):
            marker_count += 1
            relpath = match.group(1)
            count = entry_counts.get(relpath, 0)
            assert count == 1, f"{relpath} has {count} page-index entries, expected 1"
    assert marker_count == len(_page_index())


def test_every_indexed_range_extracts_the_correct_page() -> None:
    for entry in _page_index():
        bundle_path = SKILL_DIR / entry["bundle_file"]
        text = bundle_path.read_text(encoding="utf-8")
        sliced = text[entry["start"]:entry["end"]]
        assert sliced.startswith(f"<!-- vtb-page: {entry['relpath']} -->"), entry
        assert f"source_url: {entry['source_url']}" in sliced[:250], entry


def test_get_page_extracts_a_known_page() -> None:
    entry = _page_index()[0]
    result = _run_get_page(entry["relpath"])
    assert result.returncode == 0, result.stderr
    assert result.stdout.startswith(f"<!-- vtb-page: {entry['relpath']} -->")


def test_get_page_rejects_unknown_path() -> None:
    result = _run_get_page("nonexistent/page/that/does/not/exist.md")
    assert result.returncode != 0
    assert "unknown page path" in result.stderr


def test_get_page_list_includes_every_relpath() -> None:
    result = _run_get_page("--list")
    assert result.returncode == 0
    listed = set(result.stdout.splitlines())
    assert listed == {entry["relpath"] for entry in _page_index()}
