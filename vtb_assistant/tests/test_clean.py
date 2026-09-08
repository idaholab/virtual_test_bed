import importlib.util
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
CLEAN_SCRIPT = REPO_ROOT / "build" / "clean.py"

KEEP_DIRS = (".venv", "virtual_test_bed", ".vscode", ".claude")


def _load_clean_module():
    spec = importlib.util.spec_from_file_location("clean", CLEAN_SCRIPT)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


clean = _load_clean_module()


def _build_fake_repo(tmp_path: Path) -> None:
    """Mirror the real repo's generated-vs-KEEP layout under tmp_path."""
    for relpath in clean.GENERATED_DIRS:
        d = tmp_path / relpath
        d.mkdir(parents=True)
        (d / "dummy.txt").write_text("generated")
    for relpath in clean.GENERATED_FILES:
        (tmp_path / relpath).write_text("generated")
    for root in clean.PYCACHE_SEARCH_ROOTS:
        pycache = tmp_path / root / "__pycache__"
        pycache.mkdir(parents=True)
        (pycache / "mod.cpython-314.pyc").write_text("bytecode")
        (tmp_path / root / "stray.pyc").write_text("stray bytecode")
    for relpath in KEEP_DIRS:
        d = tmp_path / relpath
        d.mkdir(parents=True)
        (d / "keep.txt").write_text("keep me")


def test_find_targets_finds_every_generated_path(tmp_path: Path) -> None:
    _build_fake_repo(tmp_path)
    target_set = set(clean.find_targets(tmp_path))
    for relpath in clean.GENERATED_DIRS:
        assert tmp_path / relpath in target_set
    for relpath in clean.GENERATED_FILES:
        assert tmp_path / relpath in target_set
    for root in clean.PYCACHE_SEARCH_ROOTS:
        assert tmp_path / root / "__pycache__" in target_set
        assert tmp_path / root / "stray.pyc" in target_set


def test_find_targets_never_looks_inside_keep_dirs(tmp_path: Path) -> None:
    _build_fake_repo(tmp_path)
    # Plant a decoy __pycache__ inside a KEEP dir — PYCACHE_SEARCH_ROOTS
    # must not reach it, since these dirs are never walked at all.
    decoy = tmp_path / ".venv" / "__pycache__"
    decoy.mkdir(parents=True)
    (decoy / "site.cpython-314.pyc").write_text("site bytecode")

    target_set = set(clean.find_targets(tmp_path))
    assert decoy not in target_set
    assert not any(tmp_path / keep_dir in target_set for keep_dir in KEEP_DIRS)


def test_remove_deletes_generated_and_keeps_everything_else(tmp_path: Path) -> None:
    _build_fake_repo(tmp_path)
    keep_files = [tmp_path / d / "keep.txt" for d in KEEP_DIRS]
    original_contents = {f: f.read_text() for f in keep_files}

    clean.remove(clean.find_targets(tmp_path), dry_run=False)

    for relpath in clean.GENERATED_DIRS:
        assert not (tmp_path / relpath).exists()
    for relpath in clean.GENERATED_FILES:
        assert not (tmp_path / relpath).exists()
    for root in clean.PYCACHE_SEARCH_ROOTS:
        assert not (tmp_path / root / "__pycache__").exists()
        assert not (tmp_path / root / "stray.pyc").exists()
    for f in keep_files:
        assert f.exists()
        assert f.read_text() == original_contents[f]


def test_dry_run_removes_nothing(tmp_path: Path) -> None:
    _build_fake_repo(tmp_path)
    targets_before = clean.find_targets(tmp_path)
    clean.remove(targets_before, dry_run=True)
    assert set(clean.find_targets(tmp_path)) == set(targets_before)


def test_running_twice_on_an_already_clean_tree_does_not_raise(tmp_path: Path) -> None:
    _build_fake_repo(tmp_path)
    clean.remove(clean.find_targets(tmp_path), dry_run=False)
    assert clean.find_targets(tmp_path) == []
    clean.remove(clean.find_targets(tmp_path), dry_run=False)  # must not raise
