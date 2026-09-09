# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A skills-only plugin (no MCP server, no hosted backend, no vector DB) that lets Claude/ChatGPT find [Virtual Test Bed (VTB)](https://github.com/idaholab/virtual_test_bed) reactor models, explain VTB documentation, and generate or modify VTB simulation input files. Everything works from a bundled, curated static snapshot of the VTB repo (`skills/vtb-docs/references/` + `assets/`) searched by keyword at runtime — there is nothing to deploy or serve.

This directory (`vtb_assistant/`) lives inside the `virtual_test_bed` repo itself, one level below its root. `build/harvest.py` harvests directly from the enclosing checkout (its own parent directory) — there is no separate `virtual_test_bed/` clone to manage.

## Commands

```sh
uv sync --all-groups                                              # install (dev + harvest groups)

# Regenerate the knowledge pack (required before most tests do anything but skip)
uv run --group harvest python build/harvest.py
uv run --group harvest python build/build_reference_pack.py

uv run ruff check .                                                # lint (also run by CI)
uv run pytest                                                      # full test suite
uv run pytest tests/test_reference_pack.py::test_name -v           # a single test

./build/package_skill.sh                                          # zip skills/vtb-docs/ for claude.ai / ChatGPT
./build/package_plugin.sh                                         # zip the full plugin for Claude Code

uv run python build/clean.py [--dry-run]                          # remove generated build output (not .venv/.vscode/.claude)

claude --plugin-dir .                                              # load this repo locally in Claude Code
```

`harvest.py` always reads from the enclosing `virtual_test_bed` checkout (this directory's parent) — pass `--source-dir` to point it at a different checkout instead.

## Architecture

**Two-stage build pipeline, output gitignored.** `build/harvest.py` extracts raw content (doc pages + `!tag` metadata, MOOSE `tests`/`hpc_tests` spec files, open-source licensing tiers) from the enclosing `virtual_test_bed` checkout into `build/_cache/raw/*.json` — it only extracts, never curates. `build/build_reference_pack.py` turns that raw JSON into everything under `skills/vtb-docs/references/` + `skills/vtb-docs/assets/` plus `ATTRIBUTION.md`. **None of the generated output is committed** — it changes as upstream VTB evolves, so committing it would mean a large, mostly-noise diff on every refresh. Only hand-authored source is tracked: `build/*.py`/`*.sh`, `skills/vtb-docs/SKILL.md`, `skills/vtb-docs/scripts/*.py`, `commands/*.md`, `.claude-plugin/plugin.json`, `tests/*.py`. `build/RECON_NOTES.md` is scratch documentation (not shipped) recording how the pack is built and known data-quality caveats — read it before touching the extraction/curation logic.

**Runtime scripts are stdlib-only.** `skills/vtb-docs/scripts/search_docs.py`, `get_page.py`, and `get_input.py` use only `argparse`/`json`/`re`/`pathlib` — no venv, no installs, no network — because they run inside claude.ai/ChatGPT/Claude Code sandboxes with no dependency-install step available. Keep it that way; the `harvest` dependency group (`httpx`, `markdownify`, `pyyaml`) is strictly build-time-only.

**Generated pack structure** (all under `skills/vtb-docs/references/` unless noted):
- `model-index.json` — one entry per VTB model with a `!tag` block: `repo_path`/`repo_url` (pinned to the exact commit the pack was built from), `doc_url`, `codes_used_apps` vs. `tests_apps` (doc-claimed vs. test-spec-derived app usage — `apps_mismatch: true` when they don't overlap), `open_source_tier`, `is_tutorial`.
- `docs/<category>.md` — one file per top-level reactor category (not one per page — claude.ai's Skills upload caps zips at 200 files), each page delimited by a `<!-- vtb-page: <path> -->` marker. `page-index.json` gives exact byte offsets so `get_page.py` can extract a single page without scanning the whole category file.
- `model-inputs/inputs.jsonl` + `input-index.json` — an automatic per-model input-file manifest: every `.i` file under each model's own resolved `repo_path` directory (not a hand-picked exemplar per app), with content, parsed MOOSE structure (blocks/cross-references/candidate editable parameters), known test runs, provenance (`source.commit`/`source.blob_sha`/`repo_url`), and an `is_primary` flag derived from whether the model's own documentation actually names the file (run commands, markdown links, `!listing`, ...). `inputs.jsonl` holds the heavy content+parse detail (one compact JSON record per line); `input-index.json` is the lean, content-free companion `search_docs.py --kind input` searches, with byte offsets so `scripts/get_input.py` can extract one record without loading the whole file. Deliberately does not classify or bundle the files an input merely *references* (meshes, cross-section libraries, restart checkpoints) — see `build/RECON_NOTES.md`.
- `execution_requirements.json` — per-application access status (`open_source` / `restricted_or_registration_required` / `closed_source_no_documented_path`). This is **hand-curated** in `build_reference_pack.py` from MOOSE's own application-access docs (`mooseframework.inl.gov`), not extracted by `harvest.py` — the `applications/` directory at the repo root (if present) is scratch reference material for a human/agent to read while updating that constant, not a build input.

**Design philosophy: never claim more than was actually checked.** This shows up throughout both the build code and `SKILL.md`'s instructions: a cross-reference is only ever recorded because the value literally matched another block defined in the same template; `execution_requirements.json` statuses are traced to a specific source page, with a third "undocumented" status used rather than guessing; `repo_url` fields are `null` (not fabricated) wherever the underlying path is already known not to resolve. `SKILL.md`'s "Validation levels" section formalizes this for generated input files: `source_grounded` → `dependency_complete` → `structurally_checked` (not automated) → `application_parsed`/`smoke_tested`/`vtb_reproduced` (require an actual MOOSE executable this project never has access to — several apps are NCRC-licensed/export-controlled).

**Distribution**: `.github/workflows/vtb-assistant-release.yml` (at the `virtual_test_bed` repo root, path-filtered to `vtb_assistant/**`) runs the full build and publishes two zips as a GitHub Release whenever `devel` is merged into `main` — `vtb-docs-skill.zip` (claude.ai/ChatGPT, `SKILL.md` at the zip root) and `vtb-assistant-plugin.zip` (Claude Code — extract to `~/.claude/skills/vtb-assistant/` to auto-load as a "skills-directory plugin", no marketplace needed). `.github/workflows/vtb-assistant-ci.yml` only lints and tests on every PR touching `vtb_assistant/**`; it does not build the pack, so reference-pack tests skip (via `pytest.mark.skipif`) rather than fail there.
