"""
Commit-aware retrieval regression guard.

The offline form of "a requested pinned file has the expected blob SHA":
every indexed model input's recorded source.blob_sha must equal
`git rev-parse HEAD:<path>` against the local virtual_test_bed checkout,
proving the pack's recorded provenance is internally consistent with the
commit it claims to be pinned to.
"""

import json
import subprocess
from pathlib import Path

import pytest

REPO_ROOT = Path(__file__).resolve().parent.parent
REFERENCES_DIR = REPO_ROOT / "skills" / "vtb-docs" / "references"
SOURCE_DIR = REPO_ROOT.parent
INPUT_INDEX_PATH = REFERENCES_DIR / "model-inputs" / "input-index.json"
MODEL_INDEX_PATH = REFERENCES_DIR / "model-index.json"

pytestmark = pytest.mark.skipif(
    not INPUT_INDEX_PATH.is_file() or not SOURCE_DIR.is_dir(),
    reason="needs both the generated pack and a local virtual_test_bed checkout",
)


def _git_blob_sha(repo_path: str) -> str | None:
    result = subprocess.run(
        ["git", "-C", str(SOURCE_DIR), "rev-parse", f"HEAD:{repo_path}"],
        capture_output=True, text=True, check=False,
    )
    return result.stdout.strip() if result.returncode == 0 else None


def test_source_commit_matches_the_local_checkouts_head() -> None:
    model_index = json.loads(MODEL_INDEX_PATH.read_text(encoding="utf-8"))
    head = subprocess.run(
        ["git", "-C", str(SOURCE_DIR), "rev-parse", "HEAD"],
        capture_output=True, text=True, check=True,
    ).stdout.strip()
    assert model_index["source_commit"] == head


def test_every_input_blob_sha_matches_the_pinned_commit() -> None:
    index = json.loads(INPUT_INDEX_PATH.read_text(encoding="utf-8"))
    assert index
    for entry in index:
        assert entry["blob_sha"] == _git_blob_sha(entry["path"]), entry["path"]
