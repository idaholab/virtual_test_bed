"""
Parser-level regression fixtures for harvest.py's `tests`/`hpc_tests` parsing.

Unlike tests/test_reference_pack.py (which asserts against the *built*
model-index.json and skips when the pack hasn't been generated),
these exercise harvest.py's parse_tests_file() directly against synthetic
spec files, so they run in CI on every PR (no built pack needed) — harvest.py
itself is stdlib-only, same as the runtime scripts.
"""

import importlib.util
from pathlib import Path

REPO_ROOT = Path(__file__).resolve().parent.parent
HARVEST_SCRIPT = REPO_ROOT / "build" / "harvest.py"


def _load_harvest_module():
    spec = importlib.util.spec_from_file_location("harvest", HARVEST_SCRIPT)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


harvest = _load_harvest_module()


def _parse(tmp_path: Path, text: str, name: str = "tests") -> list[dict]:
    path = tmp_path / name
    path.write_text(text)
    return harvest.parse_tests_file(path, tmp_path)


def test_nested_parens_extract_only_app_tokens(tmp_path: Path) -> None:
    # capabilities is a boolean expression with nested parens — the app
    # tokens inside must come out clean regardless of nesting depth.
    text = """
[Tests]
  [nested]
    type = RunApp
    input = 'foo.i'
    capabilities = 'method=opt & (griffinapp | (bluecrabapp & samapp))'
  []
[]
"""
    tests = _parse(tmp_path, text)
    assert len(tests) == 1
    assert tests[0]["apps"] == ["blue_crab", "griffin", "sam"]
    assert tests[0]["unknown_capability_tokens"] == []


def test_inline_comment_does_not_pollute_capabilities(tmp_path: Path) -> None:
    text = """
[Tests]
  [commented]
    type = RunApp
    input = 'foo.i'
    capabilities = 'griffinapp' # only needs griffin, see docs
  []
[]
"""
    tests = _parse(tmp_path, text)
    assert tests[0]["apps"] == ["griffin"]
    assert tests[0]["capabilities"] == ["griffinapp"]


def test_multiline_quoted_value_is_captured_in_full(tmp_path: Path) -> None:
    # A quoted field value can itself span multiple lines (MOOSE allows
    # this for long cli_args strings) — confirm the full value survives,
    # collapsed to single spaces, not truncated at the first line break.
    text = """
[Tests]
  [multiline]
    type = CSVDiff
    input = 'foo.i'
    cli_args = '--app SamApp
                Executioner/num_steps=100'
    capabilities = 'samapp'
  []
[]
"""
    tests = _parse(tmp_path, text)
    assert tests[0]["cli_args"] == "--app SamApp Executioner/num_steps=100"


def test_lowercase_tests_block_is_recognized(tmp_path: Path) -> None:
    # MOOSE's hit-format parser accepts either casing for the root block.
    text = """
[tests]
  [lower]
    type = RunApp
    input = 'foo.i'
    capabilities = 'pronghornapp'
  []
[]
"""
    tests = _parse(tmp_path, text)
    assert len(tests) == 1
    assert tests[0]["apps"] == ["pronghorn"]


def test_negated_capability_is_excluded_not_required(tmp_path: Path) -> None:
    # `!bisonapp` means "must NOT have bison" -- the opposite of a required
    # app. APP_TOKEN_RE alone would match "bisonapp" inside "!bisonapp";
    # parse_tests_file must check what precedes the match and skip it.
    text = """
[Tests]
  [negated]
    type = RunApp
    input = 'foo.i'
    capabilities = 'method=opt & !bisonapp & griffinapp'
  []
[]
"""
    tests = _parse(tmp_path, text)
    assert tests[0]["apps"] == ["griffin"]
    assert "bison" not in tests[0]["apps"]
    assert tests[0]["unknown_capability_tokens"] == []


def test_unknown_capability_token_is_reported_not_dropped(tmp_path: Path) -> None:
    text = """
[Tests]
  [futureapp]
    type = RunApp
    input = 'foo.i'
    capabilities = 'brandnewapp | griffinapp'
  []
[]
"""
    tests = _parse(tmp_path, text)
    assert tests[0]["apps"] == ["brandnewapp", "griffin"]
    assert tests[0]["unknown_capability_tokens"] == ["brandnewapp"]


def test_collect_unknown_capability_tokens_aggregates_and_dedupes(
    tmp_path: Path,
) -> None:
    text = """
[Tests]
  [a]
    type = RunApp
    input = 'a.i'
    capabilities = 'brandnewapp'
  []
  [b]
    type = RunApp
    input = 'b.i'
    capabilities = 'brandnewapp | anothernewapp'
  []
[]
"""
    tests = _parse(tmp_path, text)
    assert harvest.collect_unknown_capability_tokens(tests) == [
        "anothernewapp", "brandnewapp",
    ]
