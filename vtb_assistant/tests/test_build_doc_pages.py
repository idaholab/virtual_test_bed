import importlib.util
from pathlib import Path

import pytest

# build_reference_pack.py imports yaml (the `harvest` dependency group, not
# `dev`), so this build-internals test runs only when that group is
# installed — i.e. the same environment the build runs in.
pytest.importorskip("yaml")

REPO_ROOT = Path(__file__).resolve().parent.parent
BUILD_SCRIPT = REPO_ROOT / "build" / "build_reference_pack.py"


def _load_build_module():
    spec = importlib.util.spec_from_file_location("build_reference_pack", BUILD_SCRIPT)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


build = _load_build_module()


def _convert(raw_markdown: str, listing_refs: list[dict] | None = None) -> str:
    page = {"listing_refs": listing_refs or []}
    return build.moosedocs_to_markdown(raw_markdown, page)


def test_math_passes_through_unmodified() -> None:
    # KaTeX-style single-$ math and \begin{equation} blocks are exactly the
    # content the old rendered-HTML pipeline lost entirely — they must
    # survive byte-for-byte now that pages are built from raw markdown.
    raw = (
        "The fuel is UO${_2}$ at 600$^{\\circ}$C.\n\n"
        "\\begin{equation}\\label{eq:mass}\nq = \\rho A v\n\\end{equation}\n"
    )
    body = _convert(raw)
    assert "UO${_2}$" in body
    assert "600$^{\\circ}$C" in body
    assert "\\begin{equation}\\label{eq:mass}" in body
    assert "\\end{equation}" in body


def test_tag_block_is_stripped_without_eating_surrounding_prose() -> None:
    raw = (
        "!tag name=Foo Model\n"
        "     description=A test model\n"
        "     pairs=reactor_type:SFR\n"
        "\n"
        "# Foo Model\n"
        "\n"
        "Some prose here.\n"
    )
    body = _convert(raw)
    assert "!tag" not in body
    assert "# Foo Model" in body
    assert "Some prose here." in body


def test_config_line_is_stripped() -> None:
    raw = "!config navigation breadcrumbs=False\n\n# Title\n\nBody text.\n"
    body = _convert(raw)
    assert "!config" not in body
    assert "Body text." in body


def test_devel_block_is_dropped_wholesale() -> None:
    raw = (
        "Before.\n\n"
        "!devel! style=display:none;\n"
        "Hidden dev content that should not ship.\n"
        "!devel-end!\n\n"
        "After.\n"
    )
    body = _convert(raw)
    assert "!devel" not in body
    assert "Hidden dev content" not in body
    assert "Before." in body
    assert "After." in body


def test_row_col_markers_are_stripped_but_inner_content_survives() -> None:
    raw = (
        "!row!\n"
        "!col! small=6 medium=6\n"
        "Left column text.\n"
        "!col-end!\n"
        "!col! small=6 medium=6\n"
        "Right column text.\n"
        "!col-end!\n"
        "!row-end!\n"
    )
    body = _convert(raw)
    assert "!row" not in body
    assert "!col" not in body
    assert "Left column text." in body
    assert "Right column text." in body


def test_listing_with_block_is_inlined_as_fenced_code() -> None:
    raw = "See the mesh block:\n\n!listing foo.i block=Mesh\n\nMore prose.\n"
    listing_refs = [
        {"path": "foo.i", "block": "Mesh", "content": "[Mesh]\n  type = FileMesh\n[]"},
    ]
    body = _convert(raw, listing_refs)
    assert "!listing" not in body
    assert "```" in body
    assert "[Mesh]" in body
    assert "type = FileMesh" in body
    assert "More prose." in body


def test_oversized_whole_file_listing_becomes_a_pointer_not_a_dump() -> None:
    raw = "!listing bigfile.i\n"
    big_content = "\n".join(f"line {i}" for i in range(1000))
    listing_refs = [{"path": "bigfile.i", "block": None, "content": big_content}]
    body = _convert(raw, listing_refs)
    assert "inputs.jsonl" in body
    assert "bigfile.i" in body
    assert "line 999" not in body
    assert "```" not in body


def test_small_whole_file_listing_is_inlined_in_full() -> None:
    raw = "!listing small.i\n"
    listing_refs = [{"path": "small.i", "block": None, "content": "[Mesh]\n[]"}]
    body = _convert(raw, listing_refs)
    assert "```" in body
    assert "[Mesh]" in body
    assert "inputs.jsonl" not in body


def test_bare_listing_becomes_fenced_code() -> None:
    raw = (
        "Example usage:\n\n"
        "!listing\n"
        "[MultiApps]\n"
        "  [sub]\n"
        "    type = TransientMultiApp\n"
        "  []\n"
        "[]\n"
        "\n"
        "More text.\n"
    )
    body = _convert(raw)
    assert "!listing" not in body
    assert "```" in body
    assert "[MultiApps]" in body
    assert "type = TransientMultiApp" in body
    assert "More text." in body


def test_bare_listing_at_end_of_file_with_no_trailing_newline_is_converted() -> None:
    # Regression: a page's raw markdown can end with no trailing newline at
    # all right after the listing's content (confirmed real:
    # htgr/generic-pbr-tutorial/step7.md ends exactly this way) — the body
    # capture must not require a trailing "\n" on the very last line.
    raw = "## Execution\n\n!listing\n./pronghorn-opt -i step7.i"
    body = _convert(raw)
    assert "!listing" not in body
    assert "```" in body
    assert "./pronghorn-opt -i step7.i" in body


def test_unresolved_listing_ref_becomes_an_honest_note() -> None:
    raw = "!listing missing.i\n"
    listing_refs = [{"path": "missing.i", "block": None, "content": None}]
    body = _convert(raw, listing_refs)
    assert "not resolved" in body
    assert "missing.i" in body
    assert "```" not in body


def test_include_becomes_a_pointer() -> None:
    raw = "Intro text.\n\n!include steady_hc.md\n\nOutro text.\n"
    body = _convert(raw)
    assert "!include" not in body
    assert "steady_hc.md" in body
    assert "Intro text." in body
    assert "Outro text." in body


def test_unhandled_directives_pass_through_byte_for_byte() -> None:
    # The deliberate scope decision: !media, !table, !alert, citations,
    # !ac, and +underline+ are NOT converted — they're left exactly as
    # they appear in the raw markdown. This is the test most likely to
    # catch an accidental over-eager regex added later.
    raw = (
        "!media media/foo/bar.png caption=A figure.\n\n"
        "!table id=tab:x caption=A table.\n"
        "| a | b |\n"
        "|---|---|\n"
        "| 1 | 2 |\n\n"
        "!alert note\n"
        "Some note text.\n\n"
        "See [!citep](Smith2020) for details.\n\n"
        "The [!ac](PDE) approach is used.\n\n"
        "+Underlined text+ here.\n"
    )
    body = _convert(raw)
    assert body == raw.strip()


def test_write_doc_pages_reports_empty_content_for_stub_pages(
    tmp_path, monkeypatch,
) -> None:
    # A page's raw_markdown is read directly from disk during harvest, with
    # no fetch-failure mode — the only drop reason left is a page whose
    # entire content was metadata (e.g. just a !tag block) with no prose.
    (tmp_path / "docs").mkdir(parents=True)
    monkeypatch.setattr(build, "REFERENCES_DIR", tmp_path)

    pages = [
        {
            "relpath": "cat/real.md",
            "doc_url": "https://x/cat/real.html",
            "raw_markdown": "# Real Page\n\nSome prose.\n",
            "listing_refs": [],
        },
        {
            "relpath": "cat/stub.md",
            "doc_url": "https://x/cat/stub.html",
            "raw_markdown": "!tag name=Stub\n     description=nothing else here\n",
            "listing_refs": [],
        },
    ]
    page_index, dropped = build.write_doc_pages(pages, "2026-01-01T00:00:00+00:00")

    assert {e["relpath"] for e in page_index} == {"cat/real.md"}
    dropped_reasons = {d["relpath"]: d["reason"] for d in dropped}
    assert dropped_reasons == {"cat/stub.md": "empty_content"}
