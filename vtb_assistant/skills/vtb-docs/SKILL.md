---
name: vtb-docs
description: Find and explain Virtual Test Bed (VTB) reactor models, retrieve VTB documentation, and generate or modify VTB input files for BISON, Griffin, SAM, Pronghorn, Grizzly, MASTODON, RELAP-7, Sockeye, Cardinal, or BlueCrab. Use when the user asks about idaholab/virtual_test_bed, virtualtestbed.inl.gov, a specific reactor concept covered by the VTB (e.g. VTR, KRUSTY, HTR-PM, MSRE, ABTR, gFHR), or wants a MOOSE-based reactor-simulation input file grounded in a real VTB example. Do NOT use for general MOOSE framework questions unrelated to the VTB, for reactor physics/engineering questions with no simulation-input angle, or for apps/models not represented in the VTB.
---

# VTB Docs

Helps find Virtual Test Bed (VTB) reactor models, explain VTB documentation,
and generate or modify VTB input files — grounded in a bundled, curated
snapshot of `idaholab/virtual_test_bed` (CC-BY-4.0; see `ATTRIBUTION.md`).

**Documentation and generation have different coverage.** Every bundled VTB
model and code can be found and explained — including non-MOOSE codes like
NekRS, OpenMC, MCNP, Serpent, and Nek5000 (check a model's `codes_used`
tag). Only the 10 MVP apps listed under "Generating or modifying an input
file" below are supported for generating or modifying an actual input
file; a model built on NekRS, OpenMC, etc. can still be found and
explained, just not authored as new input syntax. A coupled/MultiApps
model can only be generated or modified if a bundled input already
demonstrates that coupling (see "Explicitly NOT supported" below) — new
couplings between apps aren't invented.

## Before anything else

1. Check `references/model-index.json` first for "find a model" questions.
   It has one entry per VTB model with structured metadata parsed from the
   model's own `!tag` block: `name`, `summary`, `repo_path`, `doc_url`,
   `tags` (`reactor_type`, `reactor`, `geometry`, `simulation_type`,
   `codes_used`, `transient`, `fiscal_year`, `sponsor`, `institution`,
   `V_and_V`, `open_source`, ... — collection-valued fields are always
   lists), `codes_used_apps` / `tests_apps` (the apps named by the model's
   own docs vs. by its MOOSE `tests` spec file — see "Known data-quality
   notes" below), `open_source_tier`, `is_tutorial`, and `repo_path_exists`
   (`null` when `is_tutorial` — not applicable, not a failure).
2. Use `scripts/search_docs.py "<query>"` for keyword lookups across
   `references/docs/` and `references/model-inputs/input-index.json`
   before reading files individually — it's faster than grepping through
   every file yourself, and ranks by field (exact title/name match, then
   structured metadata, then heading, then body text — not raw word
   frequency, so a big unrelated page can't outrank a small, precise
   match). Add `--kind model|doc|input` to restrict which corpus is
   searched, `--exact` for only exact title/name matches, `--json` for
   machine-readable output.
3. **Always surface the `doc_url` field** (or a doc page's `source_url`
   front matter) when answering from bundled content, so the user gets a
   live link to `virtualtestbed.inl.gov`, not just a name.
4. For anything the bundled pack doesn't cover, follow **"Retrieval order"**
   below rather than reaching for live `WebFetch`/`WebSearch` by default.

## Retrieval order (bundled → pinned commit → live)

1. **Bundled content first** — `references/` and its `model-inputs/`
   input store. Always try this before fetching anything.
2. **A missing file, fetched at the pinned commit.** If something isn't
   bundled (a supporting data file a `.i` input references, a doc page
   added after this pack's `retrieved_at`, ...), fetch it at
   `model-index.json`'s top-level `source_commit` — not the live `devel`
   branch — so it's reproducible against what's actually indexed here.
   Prefer a structured GitHub file-contents connector/tool over
   `WebFetch`ing a rendered page or `WebSearch`, when one is available; it
   returns the file's own blob SHA directly rather than requiring you to
   infer one. Construct the pinned URL as
   `https://github.com/idaholab/virtual_test_bed/blob/<source_commit>/<path>`
   (raw content: swap in `raw.githubusercontent.com/idaholab/virtual_test_bed/<source_commit>/<path>`).
   Record both the commit and the blob SHA you actually got back in your
   provenance note; if a bundled record (a model-input's `source.blob_sha`)
   already claims one for that path, confirm they match rather than
   silently trusting either.
3. **A live branch, only when justified** — the user explicitly asks for
   current/latest upstream content, or the pinned commit demonstrably
   doesn't contain what's needed (e.g. a model added to `devel` after this
   pack's `retrieved_at`). Say plainly that you're looking at `devel`, not
   the pinned commit.
4. **Flag mixed versions.** If a single answer combines pinned-commit
   content with anything fetched from a live branch, label it explicitly
   as mixed-version in both the answer and any provenance you record — a
   user shouldn't have to infer that two parts of one answer came from two
   different points in the repo's history.

## Finding a model

Search or filter `references/model-index.json` by name, `reactor`,
`reactor_type`, `codes_used`, or `simulation_type`. Report the model's
`summary` and `doc_url`, and (when set) its own `repo_url` — a live link to
the model's exact source directory in the VTB repo, pinned to the commit
this pack was built from (not the same thing as an app's `repo_url` in
`execution_requirements.json` below, which points at the *application's*
source, not the *model's*). `repo_url` is `null` for tutorial pages (no
dedicated model directory) and for the small number of models whose
directory couldn't be resolved (`repo_path_exists: false`) — don't
construct a link yourself in either case. If `open_source_tier` is `null`
or not `"fully"`, say so rather than assuming the user can run it
standalone — it isn't confirmed runnable open-source, though it may still
be usable with the right access.

For *which specific codes* need special access, look up the model's
`codes_used_apps`/`tests_apps` in `references/execution_requirements.json`'s
`apps` — sourced from MOOSE's own application-access documentation
(`mooseframework.inl.gov`), not the VTB repo — and cite that entry rather
than repeating a fixed list of app names regardless of which app the model
actually uses:
- `"open_source"` — cite `repo_url` (the actual place to get the code); no
  access request needed.
- `"restricted_or_registration_required"` — NCRC-distributed. Cite
  `doc_url` (if set) and `access_levels` against
  `access_level_legend` (e.g. `local_binary` means it's usable on the
  user's own workstation via NCRC's Conda channel, not just on INL HPC),
  and point at `request_access_url` to actually get access.
- `"closed_source_no_documented_path"` — closed-source but neither an NCRC
  page nor an open-source repo turned up in either source checked. Say
  access isn't documented anywhere this pack has looked, and offer
  `request_access_url` as a best-effort general pointer — don't imply it's
  confirmed unavailable.

Every entry also has `checked_at` (when this was last verified) and
`source_url` (which of the two MOOSE pages it came from) — surface these
if the user is deciding whether to double check for themselves.

A few capability tags — `combined`, `reactor`, `subchannel`,
`thermal_hydraulics`, and `mooseapp` — name a generic MOOSE module or build
capability, not a distinct application, and deliberately have **no**
`execution_requirements.json` entry. When a model's
`codes_used_apps`/`tests_apps` is one of these, don't report the missing
entry as a gap: it's part of the open-source MOOSE framework/modules, so no
NCRC access request is needed. Point at the model's own `repo_url` and, for
building MOOSE itself, `mooseframework.inl.gov`.

## Finding / explaining documentation

`references/docs/` has **one file per top-level reactor category**
(`sfr.md`, `htgr.md`, `msr.md`, `pbfhr.md`, `microreactors.md`, `lwr.md`,
`lfr.md`, `research_reactors.md`, `fusion.md`) plus `vtb_pages.md`
(getting started, codes, running models, citing, ...) and
`vtb_tutorials.md` — not one file per page (that hit claude.ai's 200-file
zip limit). Each category file bundles multiple VTB pages, delimited by a
`<!-- vtb-page: <repo-relative-path> -->` marker followed by that page's own
`source_url`/`retrieved_at` front matter. **Use `scripts/search_docs.py`
rather than opening a category file cold** — it resolves matches to the
specific source page (e.g. `references/docs/sfr.md :: sfr/vtr/vtr_model.md`)
so you can cite the right `source_url` without having to scan a
multi-megabyte file by eye. Once you know the exact page path (from a
search result, or `references/page-index.json`), pull just that page with
`scripts/get_page.py <repo-relative-path>` (e.g.
`get_page.py sfr/abtr/abtr.md`) instead of reading the whole category file
— `get_page.py --list` prints every known page path.
`references/acronyms.md` has VTB-specific acronyms, and doubles as the
alias table `search_docs.py` expands query terms through (so "SFR" also
matches "sodium fast reactor" wherever that appears).

## Generating or modifying an input file

**Any generated or modified input needs independent engineering review
before use in safety analysis, design decisions, or licensing work** — say
this whenever handing over a generated/modified input, not just once.
This skill grounds inputs in real VTB inputs but never runs or validates
them against the actual application (see "Validation levels" below).

**In scope (MVP):** single-app MOOSE inputs for bison, griffin, sam,
pronghorn, grizzly, mastodon, relap-7, and sockeye (cardinal and blue_crab
are coupling exceptions — see below). Every VTB model with a resolved
source directory has its `.i` input files indexed automatically —
`references/model-inputs/input-index.json` (search via `search_docs.py
--kind input`, fetch a specific one with `scripts/get_input.py
<repo-relative-path>`) — not just one hand-picked exemplar per app, so an
app you're generating for usually has several real examples to draw from,
not one. Each indexed input carries:
- `model_names` (a list — a small number of directories are documented by
  more than one model page, e.g. several distinct `microreactors/gcmr`
  views) and `model_repo_path`. **A model `name` isn't guaranteed globally
  unique in VTB's own source** — a couple of names (e.g. "MRAD
  Micro-Reactor Multiphysics model") label two genuinely different
  directories. `get_input.py --model "<name>"` detects this and prints a
  warning plus results grouped by `model_repo_path` instead of silently
  pooling them — read the group headers rather than assuming a single
  flat list is one model's full input set. `search_docs.py --kind model`
  results always fold `doc_url` into `path` for the same reason (a bare
  name-based path would make two distinct results look identical).
- `is_primary` — whether the model's own documentation actually names this
  file (a run command, a markdown link, an italic mention, or a
  `!listing` directive — unioned across every doc page under that model).
  **Prefer primary inputs as your starting point** when the user hasn't
  named a specific file; `search_docs.py --kind input` already ranks
  primary results ahead of incidental ones. A `false` primary flag doesn't
  mean the file is unimportant, just that the docs don't call it out by
  name specifically (it may still be a mesh sub-input, a variant, or a
  file the docs only mention generically).
- `source` (`repository`, `commit`, `path`, `blob_sha`) and `repo_url` —
  see "Retrieval order" above for how to use these.
- Searchable structured fields already present in the lean index itself
  (no need to fetch the full record just to check these): `object_types`
  (every distinct MOOSE class name used, e.g. `PointKinetics`), a full
  `parameter_names` list, `referenced_files` (parameter values that look
  like file paths, e.g. from `restart_file_base`/`library_file`),
  `has_multiapps`/`has_transfers`, `dialect` (`"moose"` or
  `"non_moose_or_unrecognized"` — see the Serpent note below), and
  `app_hint` (this directory's models' `codes_used_apps`/`tests_apps`,
  unioned). `search_docs.py --kind input` already searches all of these —
  a query naming a MOOSE class or parameter (`"PointKinetics"`,
  `"restart_file_base"`) finds the right input even though that term
  never appears in its path or title.
- `content` (the full raw `.i` text — only present in the record
  `get_input.py` returns, not the lean search index), `blocks` (every
  block at every depth: `path`, `type`, `parameters`), `cross_references`
  (a parameter whose value matches another block actually defined in
  *this* input — reported *because* it resolved, not asserted),
  `candidate_editable_parameters` (bare numeric/boolean literals), and
  `runs` (this input's own `tests`-file entries, with
  `prereq`/`exodiff`/`csvdiff`/`cli_args`).
  **Treat `candidate_editable_parameters` as a heuristic starting point,
  not a guarantee** — it flags bare literals that aren't cross-references,
  nothing more; verify against the input before changing anything, and
  don't editorialize about parameters left unclassified (enum keywords
  like `execute_on = 'initial'` aren't literals or resolved references,
  so they're deliberately left alone rather than guessed at).

Base generated/modified input files on the closest matching indexed input
— don't invent MOOSE syntax that isn't demonstrated there or confirmed via
live search. This skill does **not** classify or chase the files an input
merely *references* (a mesh, a cross-section library, a restart
checkpoint) — say plainly that a referenced file isn't verified as
available rather than assuming it is; the model's own `repo_url` or a
live pinned-commit fetch (see "Retrieval order") is the way to actually
check.

**Cardinal and blue_crab are a documented exception, not unsupported:**
their whole purpose is coupling other codes (Cardinal → OpenMC/NekRS,
BlueCrab → Griffin+BISON+SAM), so their indexed inputs keep an active
`[MultiApps]` block — there is no non-coupled example anywhere in the VTB.
Say this plainly if the user expects a "standalone" Cardinal or blue_crab
input.

**Explicitly NOT supported — say so, don't guess:**
- NekRS-only models (parts of `msr/msre`, `pbfhr/mark1/reflector`, and a
  handful of other Nek5000/NekRS-only directories — `.udf`/`.oudf`/
  `.par`/`.re2` files, no MOOSE `.i` convention, so nothing is indexed for
  them). A few `.i`-named files in the corpus are Serpent Monte Carlo
  inputs, not MOOSE at all (a coincidence of file extension, not a MOOSE
  dialect) — check the input-index entry's `dialect` field
  (`"non_moose_or_unrecognized"` means zero blocks parsed); say so rather
  than treating the empty result as a parsing failure.
- Generating a *new* MultiApps/Transfers coupling between apps not already
  demonstrated in a bundled input (modifying an *existing* one, e.g. the
  cardinal/blue_crab inputs above, is fine).

## Validation levels — never say "runnable"/"validated"/"tested" unqualified

When discussing a generated or modified input, state the *highest level
actually reached*, not an aspirational one:

1. `source_grounded` — derived from a specific bundled VTB input (check
   `references/model-inputs/input-index.json` or a `get_input.py` record's
   `source` field). Always true for anything this skill produces.
2. `dependency_complete` — every local file the input references (a mesh,
   a cross-section library, `input_files=` sub-app inputs, a restart
   checkpoint, ...) is confirmed available. **Not machine-computed by this
   pipeline** — it deliberately does not classify or bundle an input's
   referenced files (see "Generating or modifying an input file" above).
   The input-index entry's `referenced_files` list is a starting point
   (it names the values, not whether they exist), not a substitute for
   this check: confirm each one against the model's `repo_url` directory
   listing or a live pinned-commit fetch (see
   "Retrieval order"). Say exactly which files you *did* and *didn't*
   confirm, rather than presenting the input as ready-to-run on the
   strength of `source_grounded` alone.
3. `structurally_checked` — a real MOOSE block/cross-reference/vector
   validator has confirmed the input parses correctly. **Not automated by
   this pipeline yet** — don't claim this level.
4. `application_parsed` / 5. `smoke_tested` / 6. `vtb_reproduced` — the
   actual MOOSE-based executable (bison-opt, griffin-opt, ...) accepted or
   ran the input. **This skill and its build pipeline never have that
   executable** (several are NCRC-licensed, export-controlled binaries —
   see `https://inl.gov/ncrc/`). These levels are only reachable if the
   user has the app installed and reports back after running it themselves
   — never claim them on the user's behalf.

*(Ordering note: `dependency_complete` is listed before
`structurally_checked`, the reverse of some external framings of this
vocabulary. That's deliberate, not an inconsistency to fix — dependency
completeness is at least manually checkable today (level 3 isn't
automated at all yet), so the numbering reflects what can actually be
worked toward with this pack, not an abstract escalation ladder.)*

## Known data-quality notes (don't be surprised by these)

- `model-index.json`'s `apps_mismatch: true` means the model's own
  `codes_used` tag and its `tests`-file capabilities didn't overlap when
  built — usually because one side names a generic MOOSE module/build
  capability rather than a specific app, not a real error. Don't treat it
  as "this model's app info is wrong" without checking both fields.
- `is_tutorial: true` (pages under `vtb_pages/`/`vtb_tutorials/`) means
  `repo_path`/`repo_path_exists` are `null` deliberately — these are
  conceptual/site documentation with no dedicated model directory to
  expect, not a resolution failure.
- `repo_path` prefers the page's own "Model link" URL when present (the
  authoritative source) over guessing from the doc page's directory name;
  a small number of models (no Model link in their docs) still have
  `repo_path_exists: false` — don't assume the model doesn't exist.
- `tags` values are normalized to always be lists for `codes_used`,
  `transient`, `simulation_type`, `sponsor`, and `institution` — filter/
  compare against these, not `raw_tags` (kept alongside for exact source
  fidelity only).
- Not every VTB model has a `!tag` block (only tagged models appear in
  `model-index.json`); a pure category rollup page (e.g. `htgr/index.md`)
  isn't shipped as its own doc for the same reason.
- `references/model-inputs/input-index.json` only covers models with
  `repo_path_exists: true` — a handful of those still have zero indexed
  inputs (genuinely Nek5000/NekRS-only directories with no `.i` file at
  all, not a resolution failure).
- An input-index entry's `aliases` lists other repo-relative paths that
  are git symlinks to this same file (a handful of models keep a `_Na`/
  `_base`-style variant directory of symlinks pointing at a shared
  original) — `get_input.py` resolves either the canonical path or an
  alias to the same content, so either works as a lookup key.
