import importlib.util
import json
import subprocess
import sys
from pathlib import Path

import pytest

SKILL_DIR = Path(__file__).resolve().parent.parent / "skills" / "vtb-docs"
SCRIPT = SKILL_DIR / "scripts" / "search_docs.py"
MODEL_INDEX_PATH = SKILL_DIR / "references" / "model-index.json"


def _load_search_module():
    """Import search_docs.py as a module (stdlib-only, so always importable)."""
    spec = importlib.util.spec_from_file_location("search_docs", SCRIPT)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


search_docs = _load_search_module()

needs_generated_pack = pytest.mark.skipif(
    not MODEL_INDEX_PATH.is_file(),
    reason="generated pack absent; run build/build_reference_pack.py",
)


def _run(*args: str) -> subprocess.CompletedProcess:
    return subprocess.run(
        [sys.executable, str(SCRIPT), *args],
        capture_output=True, text=True, check=False,
    )


def _json_results(*args: str) -> list[dict]:
    result = _run(*args, "--json")
    assert result.returncode == 0, result.stderr
    return json.loads(result.stdout)


def test_is_exact_match_requires_substantial_coverage() -> None:
    # Was: any title >=4 chars that was a substring of the query counted as
    # an exact match, so a short generic title floated to the top tier for
    # any query merely mentioning that word.
    assert not search_docs.is_exact_match("how to cite vtb results", "Results")
    assert not search_docs.is_exact_match("reactor core model", "Core")
    assert not search_docs.is_exact_match("getting started tutorials", "Tutorials")
    # Equality and substantial containment still qualify.
    assert search_docs.is_exact_match("Results", "Results")
    assert search_docs.is_exact_match(
        "versatile test reactor core model", "Versatile Test Reactor",
    )


def test_is_exact_match_holds_single_word_titles_to_equality() -> None:
    # Was: a bare, generic single-word title ("Results") could clear the
    # 50% char-coverage floor against a SHORT query that just appends one
    # more word ("HTTR results" -> 7/12 = 58%), even though the title
    # says nothing about that other word. The char-length ratio can't
    # distinguish this from a long query with one incidental word.
    assert not search_docs.is_exact_match("HTTR results", "Results")
    assert not search_docs.is_exact_match("VTB tutorials", "Tutorials")
    # Equality still qualifies.
    assert search_docs.is_exact_match("Results", "Results")
    assert search_docs.is_exact_match("results", "Results")


def test_filter_generic_terms_drops_stopwords_but_keeps_the_rest() -> None:
    assert search_docs.filter_generic_terms(["httr", "reactor", "model"]) == ["httr"]
    assert search_docs.filter_generic_terms(["gfhr", "using", "griffin"]) == [
        "gfhr", "griffin",
    ]


def test_filter_generic_terms_falls_back_when_everything_is_generic() -> None:
    # An all-generic query should still search *something* rather than
    # collapse to an empty, unusable token list.
    assert search_docs.filter_generic_terms(["reactor", "model"]) == [
        "reactor", "model",
    ]


def test_generic_stopwords_excludes_words_with_real_discriminating_value() -> None:
    # Direct guard against a future "helpful" broadening of the list —
    # each of these is frequent in the corpus but carries real technical
    # content or distinguishes sibling pages/models sharing a name, per
    # the plan's corpus analysis. See GENERIC_QUERY_STOPWORDS's own
    # comment for the full reasoning per word.
    must_not_be_generic = {
        "core", "steady", "state", "transient", "test", "mesh", "materials",
        "geometry", "conditions", "heat", "thermal", "multiphysics",
        "input", "parameters", "description", "results", "running",
    }
    assert not (must_not_be_generic & search_docs.GENERIC_QUERY_STOPWORDS)


def test_help_exits_zero() -> None:
    result = _run("--help")
    assert result.returncode == 0


def test_empty_query_is_an_error() -> None:
    result = _run("   ")
    assert result.returncode == 2


@needs_generated_pack
def test_known_query_finds_the_vtr_model() -> None:
    result = _run("Versatile Test Reactor")
    assert result.returncode == 0
    assert "vtr" in result.stdout.lower()


def test_unmatched_query_exits_one() -> None:
    result = _run("zzzznonexistentquerytoken")
    assert result.returncode == 1


# Golden queries covering specific ranking failures found and fixed in
# search_docs.py's scoring — each checks that exact failure mode, not just
# "some result came back."


@needs_generated_pack
def test_abtr_ranks_top_3_for_ulof_query() -> None:
    # Was: EBR-II outranked the exact ABTR SAM ULOF model.
    results = _json_results("unprotected loss of flow sodium reactor SAM")
    top_titles = [r["title"] for r in results[:3]]
    assert any("Advanced Burner Test Reactor" in t for t in top_titles), top_titles


@needs_generated_pack
def test_running_models_page_ranks_first() -> None:
    # Was: vtb_pages/running_models.md didn't appear in the top 8 at all.
    results = _json_results("how to run VTB models")
    assert results[0]["path"].endswith("running_models.md"), results[0]


@needs_generated_pack
def test_vtr_ranks_top_3_for_griffin_neutronics_query() -> None:
    results = _json_results("VTR griffin neutronics core model")
    top_titles = [r["title"] for r in results[:3]]
    assert any("Versatile Test Reactor" in t for t in top_titles), top_titles


@needs_generated_pack
def test_htr10_ranks_top_3_for_criticality_query() -> None:
    results = _json_results("HTR-10 criticality search")
    top_titles = [r["title"] for r in results[:3]]
    assert any("HTR-10" in t or "HTR10" in t for t in top_titles), top_titles


@needs_generated_pack
def test_httr_results_query_ranks_the_results_page_not_the_description_page() -> None:
    # HTTR has several sibling doc pages sharing "High Temperature
    # Engineering Test Reactor (HTTR)" in their title, differing only in
    # words like "description"/"results" — this is exactly why those two
    # words are deliberately excluded from GENERIC_QUERY_STOPWORDS despite
    # being frequent. If "results" were ever added to that list, this
    # query would degrade to matching all the HTTR siblings roughly
    # equally instead of landing on the results page specifically.
    results = _json_results("HTTR results", "--kind", "doc")
    assert results
    assert results[0]["path"].endswith("httr_model_results.md"), results[:3]


@needs_generated_pack
def test_duplicate_model_names_produce_distinct_result_paths() -> None:
    # "MRAD Micro-Reactor Multiphysics model" names two genuinely different
    # model directories in VTB's own source (a confirmed upstream naming
    # collision) — before doc_url was folded into path, both results
    # printed the identical path (and title), indistinguishable except by
    # reading source_url/snippet closely.
    name = "MRAD Micro-Reactor Multiphysics model"
    results = _json_results(name, "--kind", "model")
    matching = [r for r in results if r["title"] == name]
    assert len(matching) >= 2, results
    assert len({r["path"] for r in matching}) == len(matching), matching


@needs_generated_pack
@pytest.mark.parametrize(
    "query", ["PointKinetics", "TransientMultiApp", "NekRSProblem"],
)
def test_object_type_query_finds_input_results_as_exact_matches(query: str) -> None:
    # Gap-assessment regression: these are MOOSE class names that live 2+
    # levels deep inside a `type =` parameter value — before object_types
    # was surfaced into the lean index, these queries returned nothing at
    # all under --kind input.
    results = _json_results(query, "--kind", "input")
    assert results
    assert all(r["score"]["exact_match"] for r in results), results


@needs_generated_pack
@pytest.mark.parametrize("query", ["restart_file_base", "library_file"])
def test_parameter_name_query_finds_input_results(query: str) -> None:
    # Same gap, for parameter *names* rather than object types — these
    # aren't precise-identifier matches the way a class name is, so they
    # land in the metadata tier rather than exact_match, but they must not
    # come back empty.
    results = _json_results(query, "--kind", "input")
    assert results
    assert all(r["score"]["metadata"] > 0 for r in results), results


@needs_generated_pack
def test_exact_flag_restricts_to_exact_matches() -> None:
    results = _json_results("Versatile Test Reactor Core model", "--exact")
    assert results
    assert all(r["score"]["exact_match"] for r in results)


@needs_generated_pack
def test_kind_flag_restricts_result_kind() -> None:
    results = _json_results("griffin", "--kind", "model")
    assert results
    assert all(r["kind"] == "model" for r in results)


@needs_generated_pack
@pytest.mark.parametrize("schema_key", ["institution", "sponsor", "summary"])
def test_schema_key_words_do_not_spuriously_match_every_model(schema_key: str) -> None:
    # Was: model search scored the body tier over json.dumps(model), which
    # serializes field NAMES, so any query term equal to a schema key
    # ("institution", "sponsor", "summary", ...) matched every model on that
    # key alone. These three keys never occur as a *value* in the corpus, so
    # a value-only search must return no model results for them.
    result = _run(schema_key, "--kind", "model", "--json")
    if result.returncode == 1:
        return  # "no results" — correct
    assert result.returncode == 0, result.stderr
    assert json.loads(result.stdout) == [], schema_key
