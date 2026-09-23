import importlib.util
import json
import re
from pathlib import Path

import pytest

REPO_ROOT = Path(__file__).resolve().parent.parent
REFERENCES_DIR = REPO_ROOT / "skills" / "vtb-docs" / "references"
SOURCE_DIR = REPO_ROOT.parent
BUILD_SCRIPT = REPO_ROOT / "build" / "build_reference_pack.py"


def _load_build_module():
    spec = importlib.util.spec_from_file_location("build_reference_pack", BUILD_SCRIPT)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module

UPSTREAM_REPO_URL = "https://github.com/idaholab/virtual_test_bed"

REQUIRED_MODEL_FIELDS = {
    "name", "summary", "repo_path", "repo_url", "doc_url", "tags", "raw_tags",
    "codes_used_apps", "tests_apps", "apps_mismatch", "is_tutorial",
    "open_source_tier", "repo_path_exists",
}

COLLECTION_TAG_FIELDS = (
    "codes_used", "transient", "simulation_type", "sponsor", "institution",
)

# The knowledge pack (references/) is generated, not committed —
# see README. These tests validate its structure when present, but skip
# rather than fail on a fresh clone that hasn't run the build pipeline yet.
MODEL_INDEX_PATH = REFERENCES_DIR / "model-index.json"
pytestmark = pytest.mark.skipif(
    not MODEL_INDEX_PATH.is_file(),
    reason="generated knowledge pack not present; run build/build_reference_pack.py",
)


def _model_index() -> dict:
    return json.loads(MODEL_INDEX_PATH.read_text(encoding="utf-8"))


def test_model_index_is_valid_json_with_models() -> None:
    data = _model_index()
    assert data["models"]


def test_every_model_has_required_fields() -> None:
    for model in _model_index()["models"]:
        missing = REQUIRED_MODEL_FIELDS - model.keys()
        assert not missing, f"{model.get('name')} missing fields: {missing}"


def test_cross_repo_name_collision_is_detected() -> None:
    # A model name isn't guaranteed unique in VTB's own source. A real
    # instance of this ("MRAD Micro-Reactor Multiphysics model" naming both
    # microreactors/mrad and its 3D_core_drum_rotation_tr subdirectory)
    # existed until upstream commit f98b881d renamed the duplicate !tag —
    # so this is exercised against a synthetic model list rather than
    # pinned to live doc content that upstream can (and did) fix out from
    # under the test. Must flag: same name, different, both-existing
    # repo_paths. Must NOT flag: same name pointing at a repo_path that
    # doesn't resolve, or the harmless case of several doc pages sharing one
    # real directory (e.g. microreactors/KRUSTY).
    pytest.importorskip("yaml")
    build = _load_build_module()
    models = [
        {"name": "Collides", "repo_path": "zzz/a", "repo_path_exists": True},
        {"name": "Collides", "repo_path": "zzz/a/variant", "repo_path_exists": True},
        {"name": "Unresolved half", "repo_path": "zzz/a", "repo_path_exists": True},
        {"name": "Unresolved half", "repo_path": "zzz/b", "repo_path_exists": False},
        {"name": "Same dir twice", "repo_path": "zzz/c", "repo_path_exists": True},
        {"name": "Same dir twice", "repo_path": "zzz/c", "repo_path_exists": True},
    ]
    collisions = dict(build.find_cross_repo_name_collisions(models))
    assert collisions.get("Collides") == ["zzz/a", "zzz/a/variant"]
    assert "Unresolved half" not in collisions
    assert "Same dir twice" not in collisions


def test_repo_path_exists_flag_is_accurate() -> None:
    # Not every repo_path resolves (doc/content doesn't perfectly mirror the
    # model tree in every case — e.g. fusion/salamander_external's doc page
    # vs. its actual fusion/mcf/salamander_external model dir), which is why
    # this is a flag rather than a hard assumption. Check the flag itself is
    # truthful rather than asserting every path exists.
    if not SOURCE_DIR.is_dir():
        return  # local virtual_test_bed checkout not present; skip silently
    for model in _model_index()["models"]:
        if model["is_tutorial"]:
            assert model["repo_path"] is None
            assert model["repo_path_exists"] is None
            continue
        actual = (SOURCE_DIR / model["repo_path"]).is_dir()
        assert model["repo_path_exists"] == actual, model["repo_path"]


def test_repo_url_set_exactly_when_repo_path_resolves() -> None:
    # repo_url should never be fabricated for a path we already know is
    # wrong (repo_path_exists: false) or for a tutorial (no repo_path at
    # all) — and should always be a live link pinned to a commit when the
    # path does resolve.
    for model in _model_index()["models"]:
        if model["repo_path_exists"] is not True:
            assert model["repo_url"] is None, model["name"]
            continue
        repo_url = model["repo_url"]
        assert repo_url is not None, model["name"]
        assert repo_url.startswith(f"{UPSTREAM_REPO_URL}/tree/"), model["name"]
        assert repo_url.endswith(model["repo_path"]), model["name"]


def test_tests_apps_are_clean_app_names() -> None:
    # capabilities = 'method=opt & (griffinapp | bluecrabapp)' is a boolean
    # expression, not a plain list — regression guard against tests_apps
    # picking up "method=opt", "&", "(", trailing comments, etc.
    app_name_re = re.compile(r"^[a-z][a-z0-9_-]*$")
    for model in _model_index()["models"]:
        for app in model["tests_apps"]:
            assert app_name_re.match(app), (model["name"], app)


def test_collection_tag_fields_are_always_lists() -> None:
    for model in _model_index()["models"]:
        for field in COLLECTION_TAG_FIELDS:
            if field in model["tags"]:
                assert isinstance(model["tags"][field], list), (model["name"], field)


PAGE_MARKER_RE = re.compile(r"<!-- vtb-page: (\S+) -->\n")


def test_every_category_file_has_at_least_one_page() -> None:
    # One file per top-level category (not per page) keeps the zip under
    # claude.ai's 200-file upload limit; each page inside is delimited by a
    # <!-- vtb-page: <relpath> --> marker.
    category_files = list((REFERENCES_DIR / "docs").glob("*.md"))
    assert category_files
    for category_file in category_files:
        text = category_file.read_text(encoding="utf-8")
        assert PAGE_MARKER_RE.search(text), category_file


def test_every_doc_page_has_source_url_and_retrieved_at() -> None:
    for category_file in (REFERENCES_DIR / "docs").glob("*.md"):
        text = category_file.read_text(encoding="utf-8")
        sections = PAGE_MARKER_RE.split(text)[1:]  # drop text before first marker
        pairs = list(zip(sections[0::2], sections[1::2], strict=True))
        assert pairs, category_file
        for relpath, body in pairs:
            assert body.startswith("---\n"), (category_file, relpath)
            front_matter = body.split("---\n", 2)[1]
            assert "source_url:" in front_matter, (category_file, relpath)
            assert "retrieved_at:" in front_matter, (category_file, relpath)


EXECUTION_REQUIREMENTS_PATH = REFERENCES_DIR / "execution_requirements.json"
EXECUTION_REQUIREMENTS_REQUIRED_FIELDS = {
    "access_status", "description", "doc_url", "support_forum_url",
    "build_status_url", "access_levels", "repo_url", "request_access_url",
    "source_url", "checked_at",
}
ACCESS_STATUS_VALUES = {
    "open_source",
    "restricted_or_registration_required",
    "closed_source_no_documented_path",
}
ACCESS_LEVEL_VALUES = {"hpc_ondemand", "hpc_binary", "local_binary", "source"}
# capabilities tokens that name a generic MOOSE module/build capability
# rather than a specific application a user would seek access to (see
# harvest.py's CAPABILITY_TO_APP, which maps each of these to itself) —
# excluded from execution_requirements.json coverage on purpose.
GENERIC_MODULE_TAGS = {
    "combined", "reactor", "subchannel", "thermal_hydraulics", "mooseapp",
}


def _execution_requirements() -> dict:
    data = json.loads(EXECUTION_REQUIREMENTS_PATH.read_text(encoding="utf-8"))
    return data["apps"]


def test_execution_requirements_entries_have_required_fields() -> None:
    for app, entry in _execution_requirements().items():
        missing = EXECUTION_REQUIREMENTS_REQUIRED_FIELDS - entry.keys()
        assert not missing, (app, missing)


def test_execution_requirements_access_status_is_a_fixed_vocabulary() -> None:
    for app, entry in _execution_requirements().items():
        status = entry["access_status"]
        assert status in ACCESS_STATUS_VALUES, (app, status)
        for level in entry["access_levels"]:
            assert level in ACCESS_LEVEL_VALUES, (app, level)


def test_execution_requirements_entries_have_fields_matching_their_status() -> None:
    for app, entry in _execution_requirements().items():
        assert entry["description"], app
        assert entry["source_url"], app
        assert entry["checked_at"], app
        if entry["access_status"] == "open_source":
            assert entry["repo_url"], app
            assert entry["request_access_url"] is None, app
        elif entry["access_status"] == "restricted_or_registration_required":
            assert entry["access_levels"], app
            assert entry["request_access_url"], app
            assert entry["repo_url"] is None, app


def test_every_model_index_app_has_execution_requirements_coverage() -> None:
    # A real app silently missing from EXECUTION_REQUIREMENTS (e.g. a new
    # app added to CAPABILITY_TO_APP later) should fail loudly here, not
    # surface as a silent gap in SKILL.md's per-code lookup — covers every
    # app named anywhere in model-index.json, including
    # dire_wolf/sabertooth/salamander/tmap8.
    known = set(_execution_requirements().keys()) | GENERIC_MODULE_TAGS
    for model in _model_index()["models"]:
        for app in model["codes_used_apps"] + model["tests_apps"]:
            assert app in known, (model["name"], app)
