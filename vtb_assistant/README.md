# Virtual Test Bed Assistant

A skills-only plugin for Claude and ChatGPT to find [Virtual Test Bed
(VTB)](https://github.com/idaholab/virtual_test_bed) reactor models, explain
VTB documentation, and generate or modify VTB simulation input files. Lives
inside the VTB repo itself (`vtb_assistant/`) so it ships and evolves
alongside the models it documents.

## Why no server

The shipped skill (`skills/vtb-docs/`) works entirely from a bundled,
curated snapshot of the VTB repo — no MCP server, no hosted backend, no
vector database. The VTB corpus is modest (~80 indexed models, ~265 doc
pages) and only changes as PRs land, so a static reference pack
searched by keyword is enough; a hosted RAG backend would add hosting and
embeddings-refresh burden this project doesn't need. Live `WebFetch`/
`WebSearch` (already available on every target host) is a fallback for
freshness, not a requirement for basic operation.

## Layout

```
skills/vtb-docs/          the portable Skill — works standalone anywhere
  SKILL.md                 what it does, when it triggers (tracked in git)
  scripts/search_docs.py   stdlib-only runtime keyword search (tracked)
  references/              generated knowledge pack (NOT tracked — see below)
build/                     dev-machine tooling, not shipped
  harvest.py                 extracts raw content from the enclosing virtual_test_bed checkout
  build_reference_pack.py    turns that into skills/vtb-docs/references/
  package_skill.sh            zips skills/vtb-docs/ for claude.ai / ChatGPT upload
  package_plugin.sh           zips the full plugin for Claude Code
  clean.py                    removes generated build output (not .venv/.vscode/.claude)
commands/                 Claude Code slash commands (thin wrappers around the skill)
.claude-plugin/plugin.json Claude Code plugin manifest
```

## If you're a developer working on vtb_assistant

`skills/vtb-docs/references/` (the generated knowledge pack —
model-index.json, curated docs, the per-model input-file manifest) is
**not committed**. It's regenerated content that changes as the repo
evolves; committing it would mean a large, mostly-noise diff on every
refresh. Regenerate it locally before using `--plugin-dir .`
or running the reference-pack tests:

```sh
uv sync --all-groups
uv run --group harvest python build/harvest.py
uv run --group harvest python build/build_reference_pack.py
uv run ruff check . && uv run pytest   # reference-pack tests skip gracefully if you don't do the above
```

To start over, `uv run python build/clean.py` (`--dry-run` to preview first) removes
everything the build/lint/test/package tooling generates — `build/_cache/`,
`skills/vtb-docs/references/`, `ATTRIBUTION.md`, `dist/`, `.pytest_cache`,
`.ruff_cache`, and `__pycache__`/`*.pyc` under this subdirectory's own
tracked Python source. Deliberately narrower than `git clean`: it never touches
`.venv/`, `.vscode/`, `.claude/`, or anything outside `vtb_assistant/` (a
blanket `git clean -fdx` from here would also nuke unrelated untracked VTB
model files).

`harvest.py` always reads straight from the enclosing `virtual_test_bed`
checkout (`vtb_assistant`'s parent directory) — no cloning, since this tool
lives inside the checkout it harvests. Pass `--source-dir` to point it at a
different checkout instead (e.g. a different branch checked out elsewhere).
See `build/RECON_NOTES.md` for how the pack is built: the MooseDocs `!tag`
metadata block that backs `model-index.json`, why `tests`-file
`capabilities=` is the authoritative app↔model↔input mapping, and known
data-quality/coverage limitations.

Once regenerated, use it locally in Claude Code with:

```sh
claude --plugin-dir .
```

`.github/workflows/vtb-assistant-ci.yml` lints and tests on every PR touching
`vtb_assistant/` (the reference-pack tests skip rather than fail, since CI
doesn't build the pack on every PR).
`.github/workflows/vtb-assistant-release.yml` does the full build and
publishes both packaged zips as a GitHub Release whenever `devel` is merged
into `main` — see the next section.

## If you just want to use it (no cloning, no build)

The [latest release](https://github.com/idaholab/virtual_test_bed/releases/tag/vtb-assistant-pack-latest)
always has two ready-to-use zips, rebuilt (and the release's assets
overwritten in place) whenever `devel` merges into `main`. No older builds
are kept — this is the only release this workflow publishes.

- **`vtb-assistant-plugin.zip`** — for **Claude Code**. Download and
  extract it to `~/.claude/skills/vtb-assistant/` (user-level, loads in
  every session) or `<your-project>/.claude/skills/vtb-assistant/`
  (project-level, needs the workspace trusted first). No build, no
  marketplace — Claude Code auto-loads anything dropped into
  `.claude/skills/*` as a "skills-directory plugin". Confirmed with
  `claude plugin list`:
  ```
  Skills-directory plugins (.claude/skills/*):
    ❯ vtb-assistant@skills-dir
      Status: ✔ loaded
  ```
  (Or use `claude --plugin-dir path/to/vtb-assistant-plugin.zip` to load
  it for a single session without extracting it anywhere permanent.)
- **`vtb-docs-skill.zip`** — for **claude.ai / ChatGPT**. Upload it as-is
  via claude.ai's Settings → Skills, or ChatGPT's Skills → Create →
  Upload (`SKILL.md` is at the zip root, as both platforms require).

## License and attribution

`vtb_assistant/` doesn't carry its own license file — by default it falls
under this repo's top-level CC-BY-4.0, a content license that predates
this subdirectory and wasn't written with software in mind; that's an
open question, not a settled answer. Content in the generated
`skills/vtb-docs/references/` is derived from this repo's own
documentation and models, under that same license. `ATTRIBUTION.md`
(generated alongside the pack, not committed, but bundled into both
release zips) lists the full source URLs, retrieval dates, and the pinned
source commit.
