# Harvest & reference-pack notes

Maintainer notes on the `harvest.py` → `build_reference_pack.py` pipeline:
non-obvious parsing decisions, data-quality caveats, and things worth
re-checking after a VTB refresh. Not shipped as part of the skill.

Counts and specific examples below were captured against upstream commit
`5c10604515d8575cb41102a74a214bdd8cf69415` (`devel`) and will drift as VTB
grows — the reasoning behind each decision is what matters going forward,
not the exact numbers.

## `!tag` metadata (`model-index.json`)

Every model's `index.md` (and some non-index pages, e.g. `sfr/abtr/abtr.md`)
carries a MooseDocs `!tag` block:

```
!tag name=Versatile Test Reactor Core model
     description=Coupled multiphysics model of the VTR core...
     pairs=reactor_type:SFR
           reactor:VTR
           codes_used:BlueCrab;Griffin;BISON;SAM
```

- Top-level attributes actually used: only `name`, `description`, `image`
  (checked every `index.md` with a `!tag` — no other top-level attribute
  appears).
- `pairs=` keys actually observed: `V_and_V`, `codes_used`, `computing_needs`,
  `fiscal_year`, `geometry`, `gpu_enabled`, `input_features`, `institution`,
  `open_source`, `reactor`, `reactor_type`, `simulation_type`, `sponsor`,
  `transient`, `tutorials` — 15 of the 16 keys declared in `doc/config.yml`'s
  `MooseDocs.extensions.tagging.allowed_keys` (only `cross_sections` is
  unused in practice). `open_source` values seen: `fully`, `partially`, and
  one stray `true` (a likely upstream typo for `fully`/`partially` — not
  corrected here, just noted).
- Not every tagged page is a model `index.md` — `build_model_index` scans
  every doc page for a `!tag` block.
- `normalize_tags` coerces every collection field (`codes_used`,
  `transient`, `simulation_type`, `sponsor`, `institution`, ...) to a list
  even when the raw value is a bare string, so consumers never need to
  branch on type. The untouched original is kept alongside as `raw_tags`.
  A collection field whose raw value is `null` is dropped entirely rather
  than becoming a one-item `[None]` list.

## `tests`/`hpc_tests`: the app↔model↔input ground truth

`capabilities = 'griffinapp | bluecrabapp'` etc. is the ground truth for
which app(s) a given input needs — far more reliable than `.i` header
comments (inconsistently present). Root `testroot`'s `known_capabilities`
is the full vocabulary; `harvest.py`'s `CAPABILITY_TO_APP` maps each token
to a canonical app slug.

Two parsing pitfalls worth knowing about if you touch `parse_tests_file`:

- The root block name is matched case-sensitively (`[Tests]`), but MOOSE's
  own harness also accepts lowercase `[tests]`, and a real minority of
  `tests` files in the repo use it — `parse_tests_file` tries both
  castings for this one root-block lookup rather than making block-name
  matching case-insensitive generally (MOOSE variable/block names
  elsewhere are case-sensitive).
- MOOSE allows a quoted field value (most commonly a long `cli_args`
  string) to span multiple lines. The generic `key = value` extraction is
  line-anchored (`re.MULTILINE`, `$` = end-of-line), so a naive quoted-value
  pattern would truncate at the first line break. `TEST_FIELD_RE`'s quoted
  alternatives (`[^"]*`/`[^']*`) match newlines too, so this works without
  needing `re.DOTALL`.

Any `*app` token in a `capabilities=` expression that isn't a
`CAPABILITY_TO_APP` key is recorded per-test (`unknown_capability_tokens`)
and aggregated into a build-time `WARNING` rather than silently dropped or
guessed at — check that warning after a refresh; it usually means a new
app or module needs a `CAPABILITY_TO_APP` entry. `build_model_index` does
the mirror-image check on the `!tag codes_used` side via
`CODES_USED_TO_APP`, warning on any display name it can't map.

`model-index.json`'s `apps_mismatch: true` fires when a model's `!tag
codes_used` and its `tests`-derived `apps` are disjoint. This is a
"worth a second look" signal, not a correctness guarantee — e.g.
`AGN-201 Model` mismatches because `codes_used: MOOSE_Reactor` (a MOOSE
module, not an app) and `tests_apps: [combined]` (a generic build
capability, not an app either) are both non-app-specific, so "no overlap"
is correct there. Expect this count to shift over time as parsing coverage
improves elsewhere (recovering previously-dropped tests can surface new,
real mismatches) — a change here isn't automatically a regression.

## `repo_path` resolution

A doc page's own `*Model link: [...](.../tree/<branch>/<path>)*` line, when
present, is authoritative and preferred over guessing a model's directory
from its doc path. Roughly a third of pages have one; the rest fall back to
a dirname guess, which is where most `repo_path_exists: false` cases
originate (e.g. doc page `htgr/triso/` vs. actual model dir
`htgr/triso_fuel/`).

**Tutorial detection**: a model is a tutorial if its page lives under the
site-wide `vtb_pages/`/`vtb_tutorials/` prefix (`SITE_WIDE_PREFIXES`), *not*
based on whether its `!tag` has a `tutorials` key — `htgr/generic-pbr-tutorial`
has that key but is a real, runnable model (it's also the Pronghorn
exemplar referenced elsewhere in this pack). A tutorial gets
`is_tutorial: true` and `repo_path: null`; a missing directory there isn't
a defect.

**Known residual mismatches** with no Model-link line to resolve them —
worth periodically re-checking as candidates for a manual `repo_path` fix
or a doc-side correction upstream:
- `fusion/salamander_external` (Divertor Monoblock) — genuinely lives in a
  different repo (`idaholab/salamander`), per the page's own text. Not a
  bug.
- `htgr/htr-pm/sam-model` → possible match `htgr/htr-pm/sam-htrpm` (name
  similarity only, moderate confidence).
- `htgr/pbmr` → possible match `htgr/pbmr400` (high confidence — exact
  prefix).
- `microreactors/mrad/hpmr_triso_failure` → possible match
  `microreactors/mrad/triso_failure` (high confidence).
- `msr/msre/multiphysics_rz_model` → possible match
  `msr/msre/multiphysics_core_model` (moderate confidence — could be a
  genuinely different geometry variant).
- `pbfhr/g_fhr` → possible match `pbfhr/gFHR` (very high confidence —
  casing difference only).

## Doc-content conversion (raw markdown, not rendered HTML)

`build_reference_pack.py` used to fetch each page's rendered HTML from
`virtualtestbed.inl.gov` and convert `div.moose-content` with
`markdownify`, specifically because raw MooseDocs markdown has directives
(`!media`, `!listing`, `!row!`/`!col!`, `!alert`, `!bibtex`, bracket-only
autolinks) with no plain-markdown equivalent. That traded away something
worse: KaTeX-rendered math (`$...$`, `\begin{equation}`) renders
client-side via a bare `<script>` tag with no static/MathML fallback, so
the JS-less `httpx.get()` fetch captured *nothing* — not missing
formatting, but actively wrong shipped text (`UO${_2}$` → "UO", several
distinct table-row labels all collapsing to the identical "T K", `$\pm$`
vanishing entirely). `markdownify`'s default `escape_underscores`/
`escape_asterisks` also inserted a literal backslash before every `_`/`*`
in ordinary prose, corrupting snake_case identifiers and filenames. Both
violate the "never claim more than was actually checked" design philosophy
(`SKILL.md`) — the shipped text was asserting things that were simply
wrong, with no signal anything had been dropped.

**Current approach: build from `page["raw_markdown"]`** (already read from
disk by `walk_doc_content()` — no network fetch needed) via
`build_reference_pack.moosedocs_to_markdown()`. Deliberately minimal scope:
only strip metadata/layout noise, and resolve the two directives whose
content would otherwise be genuinely missing:

| Directive | Handling |
|---|---|
| `!tag ...` block | Stripped (reuses `harvest.TAG_START_RE`'s span) |
| `!config ...` | Dropped (site metadata only) |
| `!devel! ... !devel-end!` | Dropped wholesale |
| `!row!`/`!row-end!`/`!col!`/`!col-end!` | Marker lines stripped; inner content (usually `!media`/prose) flows through untouched |
| `!listing <path> block=X` | Inlined as fenced code from the already-resolved `listing_refs` content, truncated past `MAX_CODE_BLOCK_CHARS=3000` |
| `!listing <path>` (whole file, no `block=`) | Inlined if <=3000 chars; otherwise a pointer to `references/model-inputs/inputs.jsonl` (which already ships the full file) instead of a truncated partial |
| `!listing` (bare, no path — an inline shell/hit-format snippet, not matched by `LISTING_RE`) | Wrapped in a fenced code block |
| Unresolved `!listing` ref | An honest `*(... not resolved)*` note, never fabricated content |
| `!include <doc>.md` (doc-content transclusion) | A pointer (`*(see the "<doc>" page)*`) — not recursively inlined; that page ships independently in the same category bundle |

**Everything else is left completely untouched, byte-for-byte** — math,
`!media`, `!table`, `!alert`, citation/reference directives, `!style`,
`!plot`, `+text+` underline, and any other directive. Those already read
fine as plain text to an LLM/keyword-search consumer, and converting them
would reintroduce exactly the kind of conversion-bug risk this design
exists to avoid.

`!listing block=X` resolution runs at roughly 94-95% (unresolved cases are
diminishing-returns edge cases like ambiguous same-name block references);
`harvest.py` degrades gracefully (`content: null`) rather than failing, and
the converter renders that as an honest "not resolved" note.

## Open-source licensing tiers

`doc/content/vtb_pages/models_by_codes_used.md` has two `!alert` sections
("Fully Open-Source", "Partially Open-Source") listing specific models by
their documentation link — a maintainer-curated view independent of (and
more complete than) the sparse per-model `!tag open_source` field. `
harvest.py` parses both into `open_source_tiers.json`; `model-index.json`'s
`open_source_tier` field prefers the narrative-page tier, falling back to
the `!tag` value. Models in neither source have `open_source_tier: null` —
most of those need NCRC-licensed codes (Griffin, SAM, BISON, etc.) and are
**not** "confirmed proprietary," just undocumented either way. `SKILL.md`
surfaces this field when discussing input-file generation so a user
without NCRC access isn't surprised.

## Per-model input-file manifest

Every model's own `.i` files are included — `build_model_inputs()` walks
`(SOURCE_DIR / repo_path).rglob("*.i")` for every model with
`repo_path_exists: true`, not one hand-picked exemplar per app. (An earlier
design shipped a single curated exemplar input per app; it only covered a
fraction of models and needed a dependency-classification step —
bundled/external/too-big — disproportionate to the benefit. `.i`-file
*detection* of references is still used for parameter classification below;
the bundling/classification machinery itself was dropped.)

A few things that took real digging to get right:

- **`is_primary` needs more than `!listing`.** Coverage of a model's own
  `.i` files by `!listing` alone ranges from 0% (`sfr/abtr` — both of its
  inputs are cited only as `sam-opt -i <file>.i` run commands in prose) to
  100% (`htgr/htr10`, `htgr/generic-pbr-tutorial`). `harvest.py`'s
  `cited_input_basenames()` unions `!listing` refs with three prose regexes
  (`-i <file>.i` run commands are the dominant real pattern, well ahead of
  markdown links or italic mentions) across every doc page under a model's
  own directory subtree, not just its single primary tagged page (a model
  can span several — e.g. 1 page for ABTR, 3 for htr10, 9 for the
  pbr-tutorial).
- **A directory can be shared by more than one model.** `htgr/httf`,
  `microreactors/KRUSTY`, and `microreactors/gcmr` each have several
  distinct `!tag` pages pointing at the same source directory (separate
  documented "views" of one input set). `model_index` is grouped by
  `repo_path` *before* walking, so every record's `model_names` is the full
  deduped list of models sharing that directory — otherwise whichever
  model iterated first would silently claim every file, leaving its
  siblings with zero inputs.
- **Symlinks are deduped to one canonical record.** A handful of `.i`
  paths in the checkout are git symlinks (e.g. some of `microreactors/mrad`'s
  transient variants, symlinked to a corresponding base input).
  `build_model_inputs()` keys a `canonical_by_realpath` registry by
  `Path.resolve()`, so a symlink's target becomes the one record, and
  every other path that resolves to it is appended to that record's
  `aliases` list rather than re-parsed and re-stored. `get_input.py`
  resolves either the canonical path or an alias to the same content.
- **Some `.i`-named files aren't MOOSE at all.** Serpent Monte Carlo inputs
  (e.g. `microreactors/gcmr/core/Serpent_Model/serpent_input.i`) share the
  `.i` extension by convention, not by any relation to MOOSE's hit format —
  `walk_all_blocks()` correctly finds zero blocks for these (no false
  structure fabricated). An empty `blocks` list isn't a parsing bug;
  `SKILL.md` says so explicitly.
- **`inputs.jsonl` + `input-index.json`** mirror the docs pipeline's
  heavy-content/lean-index split, but with byte offsets into a
  binary-mode-read file rather than character offsets into a
  `read_text()`-decoded one — a byte offset read back in binary mode never
  goes through newline translation, avoiding the class of desync bug that
  `page-index.json` has to guard against explicitly. Each line is one
  compact `json.dumps(..., separators=(",", ":"))` record, so a literal
  newline inside a field's own string value comes out as the two
  characters `\n`, never a real line break — "one line" and "one record"
  always agree regardless of a `.i` file's own line endings.
- **`blob_sha`** comes from `git rev-parse HEAD:<repo-relative-path>`
  (`harvest.git_blob_sha`) — matches what GitHub's own blob/tree API
  returns for the same path at the same commit, including for an
  LFS-tracked path (the tree entry's SHA, not a hash of a locally-smudged
  copy). This hasn't yet been exercised against a real LFS pointer among
  the indexed `.i` files; noted as a caveat in the function's own
  docstring rather than assumed away.
- **`dependency_complete` (see `SKILL.md`'s validation levels) has no
  automated check** — it's manual-verification guidance (read the input's
  own file-reference parameters, check them by hand against `repo_url` or
  a live pinned-commit fetch), same as `structurally_checked`.
- Deliberately out of scope: chasing or bundling a file an input merely
  *references* but doesn't itself contain (meshes, cross-section
  libraries, restart checkpoints). `find_file_references`/
  `classify_parameters` still detect that a parameter *looks like* a file
  reference (so it's excluded from "candidate editable parameters"), but
  nothing fetches, classifies, or copies the referenced file anywhere.

`SKILL.md`'s "Retrieval order" section governs how a missing file gets
fetched at runtime: bundled content first, then a pinned-commit fetch
(recording the blob SHA actually returned, checked against a bundled
record's `source.blob_sha` when one exists), then a live branch only on
explicit request or a demonstrated pinned-commit gap, with mixed-version
results always flagged. `test_input_provenance.py`'s
`test_blob_sha_matches_pinned_commit` is the offline regression guard:
every indexed input's recorded `blob_sha` must equal
`git rev-parse HEAD:<path>` against the local checkout.

## Execution requirements / access levels

`EXECUTION_REQUIREMENTS` in `build_reference_pack.py` is a hand-curated
constant (same style as `CODES_USED_TO_APP`), not something `harvest.py`
fetches or parses. It's sourced from MOOSE's own application-access
documentation, not from the VTB repo itself — the VTB's own one-sentence
licensing disclaimer (`vtb_pages/models_by_codes_used.md`) is incomplete on
its own and should not be trusted as the sole source:

- `applications/ncrc_root_<app>.md`-style pages (from
  `mooseframework.inl.gov/help/inl/applications.html`) are the
  "restricted" signal — having one of these pages at all means an app is
  NCRC-distributed. Easy to miss: **pronghorn, grizzly, relap-7, and
  sockeye** are all NCRC despite not being named in the VTB's own
  disclaimer sentence. Each such page lists 3-4 `Level N` access links —
  Level 1 (HPC-only binary access), Level 2 (a binary for your own
  workstation via NCRC's Conda channel), Level 4 (full source for
  developers) — there is no Level 3. Grizzly and SAM are the only two
  VTB-relevant NCRC apps without a Level 2/Conda page.
- `applications/tracked_apps.md` (from
  `mooseframework.inl.gov/application_usage/tracked_apps.html`) lists every
  MOOSE-based app as open- or closed-source. Easy to miss the other way:
  **Cardinal, MASTODON, SALAMANDER, and TMAP8 are open-source** with real
  links, despite reading like they could be NCRC apps.
  **SABERTOOTH** is the one VTB app with neither an NCRC page nor an
  open-source repo in either source — it's a plain-text "Closed Source"
  entry with no link, so it gets a distinct third status,
  `"closed_source_no_documented_path"`, rather than a guess either way.

The `applications/` directory (if present at the repo root) holds these
source pages for reference while updating the constant by hand — it's
scratch material, not a build input, and isn't fetched or parsed by any
script.

## Reused as-is

- `doc/acronyms.yml` → shipped verbatim as `references/acronyms.md`.
- `doc/config.yml`'s `navigation.menu` — useful to re-read if site-wide
  page structure ever needs re-confirming; not derived at build time.
- The enclosing `virtual_test_bed` checkout (`vtb_assistant/`'s parent
  dir) — `harvest.py`'s default `--source-dir`, since this tool lives
  inside the checkout it harvests.
