import json
import re
import shutil
import subprocess
import sys
from pathlib import Path

import pytest

REPO_ROOT = Path(__file__).resolve().parent.parent
SKILL_DIR = REPO_ROOT / "skills" / "vtb-docs"
REFERENCES_DIR = SKILL_DIR / "references"
SOURCE_DIR = REPO_ROOT.parent
MODEL_INPUTS_DIR = REFERENCES_DIR / "model-inputs"
INPUT_INDEX_PATH = MODEL_INPUTS_DIR / "input-index.json"
INPUTS_JSONL_PATH = MODEL_INPUTS_DIR / "inputs.jsonl"
MODEL_INDEX_PATH = REFERENCES_DIR / "model-index.json"
GET_INPUT_SCRIPT = SKILL_DIR / "scripts" / "get_input.py"

UPSTREAM_REPO_URL = "https://github.com/idaholab/virtual_test_bed"

# The generated pack (references/) is gitignored, not committed — these
# tests validate its structure when present, but skip on a fresh clone
# that hasn't run the build pipeline yet (same convention as
# test_reference_pack.py).
pytestmark = pytest.mark.skipif(
    not INPUT_INDEX_PATH.is_file(),
    reason="generated knowledge pack not present; run build/build_reference_pack.py",
)


def _input_index() -> list[dict]:
    return json.loads(INPUT_INDEX_PATH.read_text(encoding="utf-8"))


def _model_index() -> list[dict]:
    return json.loads(MODEL_INDEX_PATH.read_text(encoding="utf-8"))["models"]


def _record_at(entry: dict) -> dict:
    with INPUTS_JSONL_PATH.open("rb") as f:
        f.seek(entry["jsonl_offset"])
        raw = f.read(entry["jsonl_length"])
    return json.loads(raw.decode("utf-8"))


def test_input_index_is_valid_json_with_entries() -> None:
    assert _input_index()


REQUIRED_INDEX_FIELDS = {
    "path", "model_names", "model_repo_path", "is_primary", "aliases",
    "repo_url", "source_commit", "blob_sha", "size_bytes", "snippet",
    "object_types", "parameter_names", "referenced_files", "has_multiapps",
    "has_transfers", "dialect", "app_hint", "jsonl_offset", "jsonl_length",
}


def test_every_index_entry_has_the_expected_shape() -> None:
    for entry in _input_index():
        missing = REQUIRED_INDEX_FIELDS - entry.keys()
        assert not missing, (entry.get("path"), missing)
        assert entry["model_names"], entry["path"]


def test_repo_url_is_a_live_link_pinned_to_the_recorded_commit() -> None:
    for entry in _input_index():
        assert entry["repo_url"] == (
            f"{UPSTREAM_REPO_URL}/blob/{entry['source_commit']}/{entry['path']}"
        ), entry["path"]


def test_abtr_two_step_workflow_is_indexed_and_primary() -> None:
    # The central regression case for the automatic-input redesign:
    # !listing alone would miss both of these (sfr/abtr's doc page cites
    # them only as "sam-opt -i <file>.i" run commands) — is_primary must
    # come from the prose-citation detection, not just !listing refs.
    index = {e["path"]: e for e in _input_index()}
    for path in ("sfr/abtr/abtr_ss.i", "sfr/abtr/abtr_ulof.i"):
        assert path in index, path
        assert index[path]["is_primary"] is True, path
        assert index[path]["model_repo_path"] == "sfr/abtr"


def test_object_types_surface_point_kinetics() -> None:
    # The central regression case for the search-index enrichment: type =
    # PointKinetics lives 2 levels deep (Components/pke) inside a raw
    # parameter value — object_types is what makes it findable without
    # reading inputs.jsonl.
    index = {e["path"]: e for e in _input_index()}
    entry = index["htgr/generic-pbr/pbr.i"]
    assert "PointKinetics" in entry["object_types"]


def test_has_multiapps_true_for_the_cardinal_coupling_exemplar() -> None:
    # RECON_NOTES documents Cardinal/blue_crab inputs as the one case that
    # always keeps an active [MultiApps] block (coupling other codes is
    # their whole purpose) — has_multiapps must reflect that.
    index = {e["path"]: e for e in _input_index()}
    entry = index["htgr/pb67_cardinal/moose.i"]
    assert entry["has_multiapps"] is True


def test_dialect_flags_a_non_moose_serpent_input() -> None:
    # A few .i-named files are Serpent Monte Carlo inputs, not MOOSE at
    # all (a coincidence of file extension) — walk_all_blocks correctly
    # finds zero blocks for these; dialect should say so plainly rather
    # than looking like a parsing failure.
    index = {e["path"]: e for e in _input_index()}
    entry = index["microreactors/gcmr/core/Serpent_Model/serpent_input.i"]
    assert entry["dialect"] == "non_moose_or_unrecognized"


def test_referenced_files_is_non_empty_for_a_known_file_ref_input() -> None:
    index = {e["path"]: e for e in _input_index()}
    entry = index["htgr/assembly/openmc.i"]
    assert entry["referenced_files"]


def test_shared_repo_path_models_are_all_attributed() -> None:
    # A handful of directories are documented by more than one model page
    # (e.g. several distinct microreactors/gcmr views) -- every one of
    # them must appear in model_names for every input under that
    # directory, not just whichever model happened to be processed first.
    models_by_repo_path: dict[str, set[str]] = {}
    for model in _model_index():
        if model.get("repo_path") and model.get("repo_path_exists") is True:
            models_by_repo_path.setdefault(model["repo_path"], set()).add(
                model["name"],
            )
    shared = {rp: names for rp, names in models_by_repo_path.items() if len(names) > 1}
    assert shared  # confirm the scenario actually exists in this pack
    for entry in _input_index():
        expected = shared.get(entry["model_repo_path"])
        if expected is None:
            continue
        assert set(entry["model_names"]) == expected, entry["path"]


def test_every_resolvable_model_has_input_coverage_or_a_genuinely_empty_dir() -> None:
    if not SOURCE_DIR.is_dir():
        return  # local virtual_test_bed checkout not present; skip silently
    covered_repo_paths = {e["model_repo_path"] for e in _input_index()}
    for model in _model_index():
        if not model.get("repo_path") or model.get("repo_path_exists") is not True:
            continue
        repo_path = model["repo_path"]
        if repo_path in covered_repo_paths:
            continue
        # Not covered -- must be because the directory genuinely has no
        # .i files (e.g. a Nek5000/NekRS-only model), not a build gap.
        actual_inputs = list((SOURCE_DIR / repo_path).rglob("*.i"))
        assert not actual_inputs, (model["name"], repo_path, actual_inputs)


def test_symlink_aliases_are_not_also_a_separate_canonical_path() -> None:
    paths = {e["path"] for e in _input_index()}
    for entry in _input_index():
        for alias in entry["aliases"]:
            assert alias != entry["path"], entry["path"]
            assert alias not in paths, (entry["path"], alias)


def test_input_index_offsets_extract_valid_matching_records() -> None:
    for entry in _input_index():
        record = _record_at(entry)
        assert record["path"] == entry["path"], entry["path"]
        assert record["model_names"] == entry["model_names"], entry["path"]
        assert record["source"]["blob_sha"] == entry["blob_sha"], entry["path"]
        assert "content" in record, entry["path"]


def test_every_cross_reference_resolves_to_a_real_block() -> None:
    # Regression guard for the "resolves or is explicit" property: a
    # cross_reference is only ever recorded because its value matched a
    # name actually defined in this input -- verify that's still true.
    for entry in _input_index():
        record = _record_at(entry)
        block_names = {b["path"].rsplit("/", 1)[-1] for b in record["blocks"]}
        for ref in record["cross_references"]:
            for matched in ref["matched_names"]:
                assert matched in block_names, (entry["path"], ref)


NUMERIC_RE = re.compile(r"^-?\d+(\.\d+)?([eE][-+]?\d+)?$")
BOOLEAN_VALUES = {"true", "false", "on", "off", "yes", "no"}


def test_candidate_editable_parameters_are_numeric_or_boolean() -> None:
    for entry in _input_index():
        record = _record_at(entry)
        for candidate in record["candidate_editable_parameters"]:
            tokens = candidate["value"].split()
            assert tokens, (entry["path"], candidate)
            for token in tokens:
                is_valid = NUMERIC_RE.match(token) or token.lower() in BOOLEAN_VALUES
                assert is_valid, (entry["path"], candidate)


def test_runs_reference_this_inputs_own_basename() -> None:
    for entry in _input_index():
        record = _record_at(entry)
        basename = Path(entry["path"]).name
        for run in record["runs"]:
            assert run["input"] == basename, (entry["path"], run)


def _run_get_input(*args: str) -> subprocess.CompletedProcess:
    return subprocess.run(
        [sys.executable, str(GET_INPUT_SCRIPT), *args],
        capture_output=True, text=True, check=False,
    )


def test_get_input_round_trips_a_known_path() -> None:
    result = _run_get_input("sfr/abtr/abtr_ulof.i")
    assert result.returncode == 0, result.stderr
    entry = next(e for e in _input_index() if e["path"] == "sfr/abtr/abtr_ulof.i")
    record = _record_at(entry)
    assert result.stdout == record["content"] + "\n"


def test_get_input_full_prints_valid_matching_json() -> None:
    result = _run_get_input("sfr/abtr/abtr_ulof.i", "--full")
    assert result.returncode == 0, result.stderr
    record = json.loads(result.stdout)
    assert record["path"] == "sfr/abtr/abtr_ulof.i"


def test_get_input_model_lists_both_abtr_inputs_as_primary() -> None:
    result = _run_get_input(
        "--model", "Advanced Burner Test Reactor Loss of Flow Accident",
    )
    assert result.returncode == 0, result.stderr
    lines = result.stdout.splitlines()
    assert {"sfr/abtr/abtr_ss.i [primary]", "sfr/abtr/abtr_ulof.i [primary]"} <= set(
        lines,
    )


def test_get_input_unknown_path_errors_cleanly() -> None:
    result = _run_get_input("bogus/does_not_exist.i")
    assert result.returncode != 0
    assert "unknown input path" in result.stderr


def test_get_input_model_warns_and_groups_across_repo_path_collision(
    tmp_path: Path,
) -> None:
    # A model name isn't guaranteed unique in VTB's own source. A real
    # instance of this ("MRAD Micro-Reactor Multiphysics model" naming two
    # distinct directories) existed until upstream commit f98b881d renamed
    # the duplicate !tag — so this runs get_input.py, unmodified, against a
    # synthetic input-index.json rather than pinning to live doc content
    # that upstream can (and did) fix out from under the test. --model must
    # warn and group by directory rather than silently pool both sets of
    # inputs into one undifferentiated list.
    scripts_dir = tmp_path / "scripts"
    model_inputs_dir = tmp_path / "references" / "model-inputs"
    scripts_dir.mkdir(parents=True)
    model_inputs_dir.mkdir(parents=True)
    shutil.copy(GET_INPUT_SCRIPT, scripts_dir / "get_input.py")

    collision_name = "Synthetic Collision Model"
    index = [
        {
            "path": "zzz/model_a/input_a.i", "model_names": [collision_name],
            "model_repo_path": "zzz/model_a", "is_primary": True, "aliases": [],
        },
        {
            "path": "zzz/model_a/variant_b/input_b.i",
            "model_names": [collision_name],
            "model_repo_path": "zzz/model_a/variant_b", "is_primary": True,
            "aliases": [],
        },
    ]
    (model_inputs_dir / "input-index.json").write_text(json.dumps(index))
    (model_inputs_dir / "inputs.jsonl").write_text("")

    result = subprocess.run(
        [sys.executable, str(scripts_dir / "get_input.py"), "--model", collision_name],
        capture_output=True, text=True, check=False,
    )
    assert result.returncode == 0, result.stderr
    assert "warning" in result.stderr.lower()
    lines = result.stdout.splitlines()
    assert "# zzz/model_a" in lines
    assert "# zzz/model_a/variant_b" in lines
    assert "zzz/model_a/input_a.i [primary]" in lines
    assert "zzz/model_a/variant_b/input_b.i [primary]" in lines
