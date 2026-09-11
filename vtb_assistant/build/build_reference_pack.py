"""
Turn build/_cache/raw/* into the shipped skills/vtb-docs/references/.

Reads harvest.py's raw JSON and produces: model-index.json (one entry per
model with a MooseDocs `!tag` block, cross-checked against the `tests`-file
capabilities vocabulary), curated per-page markdown under references/docs/,
a glossary, an automatic per-model input-file manifest (every `.i` file
under each model's own resolved directory, content + parsed MOOSE
structure, under references/model-inputs/), and ATTRIBUTION.md. Run
harvest.py first.

Run with: uv run --group harvest python build/build_reference_pack.py
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from datetime import UTC, datetime
from pathlib import Path

import yaml

REPO_ROOT = Path(__file__).resolve().parent.parent
RAW_DIR = REPO_ROOT / "build" / "_cache" / "raw"
SOURCE_DIR = REPO_ROOT.parent
SKILL_DIR = REPO_ROOT / "skills" / "vtb-docs"
REFERENCES_DIR = SKILL_DIR / "references"

UPSTREAM_REPO_URL = "https://github.com/idaholab/virtual_test_bed"
UPSTREAM_LICENSE = "CC-BY-4.0"


def github_blob_url(repo_path: str, commit: str) -> str:
    """Live link to a single file, pinned to the commit this pack was built from."""
    return f"{UPSTREAM_REPO_URL}/blob/{commit}/{repo_path}"


def github_tree_url(repo_path: str, commit: str) -> str:
    """Live link to a directory, pinned to the exact commit this pack was built from."""
    return f"{UPSTREAM_REPO_URL}/tree/{commit}/{repo_path}"

# Sections of doc/content/ that are always worth shipping regardless of !tag.
SITE_WIDE_PREFIXES = ("vtb_pages/", "vtb_tutorials/")

# `!tag pairs=codes_used:...` display names, normalized (lowercased,
# non-alnum stripped), mapped to the canonical app slug used in
# harvest.py's CAPABILITY_TO_APP (i.e. the tests-file vocabulary).
CODES_USED_TO_APP = {
    "moosecombined": "moose_combined",
    "mooseheattransfer": "moose_heattransfer",
    "moosenavierstokes": "moose_navierstokes",
    "moosereactor": "moose_reactor",
    "moosesolidmechanics": "moose_solid_mechanics",
    "moosestochastictools": "moose_stochastictools",
    "moosesubchannel": "moose_subchannel",
    "moosethermalhydraulics": "moose_thermalhydraulics",
    "bison": "bison",
    "bluecrab": "blue_crab",
    "griffin": "griffin",
    "grizzly": "grizzly",
    "mastodon": "mastodon",
    "pronghorn": "pronghorn",
    "sam": "sam",
    "sockeye": "sockeye",
    "cardinal": "cardinal",
    "relap7": "relap-7",
    "salamander": "salamander",
    "tmap8": "tmap8",
}

MOOSE_MODULE_INFO = {
    "access_status": "open_source",
    "build_status_url": "https://civet.inl.gov/repo/1/",
    "access_levels": [],
    "repo_url": "https://github.com/idaholab/moose",
    "request_access_url": None,
    "source_url": "https://mooseframework.inl.gov/modules/index.html",
}
NCRC_REQUEST_URL = "https://inl.gov/ncrc/"
NCRC_APPLICATIONS_PAGE_URL = "https://mooseframework.inl.gov/help/inl/applications.html"
TRACKED_APPS_PAGE_URL = (
    "https://mooseframework.inl.gov/application_usage/tracked_apps.html"
)

# Level 1/2/4 meanings, from MOOSE's own ncrc/level_descriptions.md (no
# Level 3 exists): Level 1 is an INL-HPC account with a ready-to-use
# binary; Level 2 is a binary usable on your own workstation (NCRC's Conda
# channel); Level 4 is full source, for developers.
ACCESS_LEVEL_LEGEND = {
    "hpc_ondemand": (
        "Level 1 - HPC OnDemand Execution: an INL-HPC account with a "
        "ready-to-use binary, submitted via a web form."
    ),
    "hpc_binary": (
        "Level 1 - HPC Binary Execution: an INL-HPC account with a "
        "ready-to-use binary, run directly on INL clusters."
    ),
    "local_binary": (
        "Level 2 - Local Binary Installation: a binary usable on your own "
        "workstation or institution cluster (NCRC's Conda channel)."
    ),
    "source": (
        "Level 4 - Source Access: full source code, for developers "
        "contributing new capabilities."
    ),
}

# Hand-curated from MOOSE's own application-access documentation (dropped
# into applications/ for reference while updating this constant by hand,
# not fetched or parsed at build time — see build/RECON_NOTES.md). Sourcing
# rule per app, applied by direct inspection of the two pages above:
#   - has its own "## <Name>" section on NCRC_APPLICATIONS_PAGE_URL
#     (an applications/ncrc_root_<app>.md page) -> "restricted_or_registration_required"
#   - else listed under TRACKED_APPS_PAGE_URL's "Open-source Applications"
#     with a real link -> "open_source"
#   - else listed under TRACKED_APPS_PAGE_URL's "Closed Source Applications"
#     with no NCRC page -> "closed_source_no_documented_path" (not a guess
#     either way — sabertooth is the only VTB app in this bucket)
# Not a substitute for model-index.json's per-model `open_source_tier`:
# this is per-*code*, not per-*model* — even an NCRC-restricted code can
# have specific VTB models that run open-source (e.g. by stripping
# [MultiApps]/[Transfers]).
EXECUTION_REQUIREMENTS = {
    "moose_combined": {
        **MOOSE_MODULE_INFO,
        "description": "MOOSE with all of it's physics modules.",
        "doc_url": "https://mooseframework.inl.gov/",
        "support_forum_url": "https://github.com/idaholab/moose/discussions/categories/q-a-modules-general",
    },
    "moose_heattransfer": {
        **MOOSE_MODULE_INFO,
        "description": (
            "The heat transfer module provides various implementations of the heat "
            "conduction equation, as well as associated boundary/interface conditions, "
            "including radiation between opaque, gray, diffuse surfaces and provisions "
            "to couple temperature fields to fluid domains through boundary conditions."
        ),
        "doc_url": "https://mooseframework.inl.gov/modules/heat_transfer/index.html",
        "support_forum_url": "https://github.com/idaholab/moose/discussions/categories/q-a-modules-general",
    },
    "moose_navierstokes": {
        **MOOSE_MODULE_INFO,
        "description": (
            "The MOOSE Navier-Stokes module is a library for the implementation of "
            "simulation tools that solve the Navier-Stokes equations using continuous "
            "Galerkin finite element (CGFE), discontinuous Galerkin finite element "
            "(DGFE), hybridized discontinuous Galerkin (HDG) finite element, or finite "
            "volume (FV) methods."
        ),
        "doc_url": "https://mooseframework.inl.gov/modules/navier_stokes/index.html",
        "support_forum_url": "https://github.com/idaholab/moose/discussions/categories/q-a-modules-navier-stokes",
    },
    "moose_reactor": {
        **MOOSE_MODULE_INFO,
        "description": (
            "This reactor module aims to add advanced meshing capabilities to MOOSE so "
            "that users can create complex-geometry meshes that are related to "
            "reactors without turning to external meshing software."
        ),
        "doc_url": "https://mooseframework.inl.gov/modules/reactor/index.html",
        "support_forum_url": "https://github.com/idaholab/moose/discussions/categories/q-a-meshing",
    },
    "moose_solid_mechanics": {
        **MOOSE_MODULE_INFO,
        "description": (
            "The Solid Mechanics module is a library of simulation tools that solve "
            "continuum mechanics problems."
        ),
        "doc_url": "https://mooseframework.inl.gov/modules/solid_mechanics/index.html",
        "support_forum_url": "https://github.com/idaholab/moose/discussions/categories/q-a-modules-solid-mechanics",
    },
    "moose_stochastictools": {
        **MOOSE_MODULE_INFO,
        "description": (
            "The stochastic tools module is a toolbox designed for performing "
            "stochastic analysis for MOOSE-based applications."
        ),
        "doc_url": "https://mooseframework.inl.gov/modules/stochastic_tools/index.html",
        "support_forum_url": "https://github.com/idaholab/moose/discussions/categories/q-a-modules-general",
    },
    "moose_subchannel": {
        **MOOSE_MODULE_INFO,
        "description": (
            "Subchannel Module for performing reactor core, single-phase "
            "thermal-hydraulic subchannel simulations, for bare pin, square lattice "
            "bundles or wire-wrapped/bare pin, triangular lattice bundles."
        ),
        "doc_url": "https://mooseframework.inl.gov/modules/subchannel/index.html",
        "support_forum_url": "https://github.com/idaholab/moose/discussions/categories/q-a-modules-subchannel",
    },
    "moose_thermalhydraulics": {
        **MOOSE_MODULE_INFO,
        "description": (
            "The Thermal Hydraulics Module (THM) is an optional MOOSE physics module "
            "that provides capabilities for studying thermal hydraulic systems. Its "
            "core capability lies in assembling a network of coupled components, for "
            "instance, pipes, junctions, and valves."
        ),
        "doc_url": "https://mooseframework.inl.gov/modules/thermal_hydraulics/index.html",
        "support_forum_url": "https://github.com/idaholab/moose/discussions/categories/q-a-modules-thermal-hydraulics",
    },
    "bison": {
        "access_status": "restricted_or_registration_required",
        "description": (
            "Finite element-based nuclear fuel performance code for LWR "
            "fuel rods, TRISO particle fuel, metallic rod/plate fuel, and "
            "other fuel forms."
        ),
        "doc_url": "https://bison-docs.hpcondemand.inl.gov",
        "support_forum_url": "https://bison-discourse.hpcondemand.inl.gov",
        "build_status_url": "https://civet.inl.gov/repo/875/",
        "access_levels": ["hpc_ondemand", "hpc_binary", "local_binary", "source"],
        "repo_url": None,
        "request_access_url": NCRC_REQUEST_URL,
        "source_url": NCRC_APPLICATIONS_PAGE_URL,
    },
    "blue_crab": {
        "access_status": "restricted_or_registration_required",
        "description": (
            "Coupling of Bison, Griffin, Pronghorn, and SAM into one executable."
        ),
        "doc_url": "https://bluecrab-docs.hpcondemand.inl.gov",
        "support_forum_url": None,
        "build_status_url": "https://civet.inl.gov/repo/882/",
        "access_levels": ["hpc_ondemand", "hpc_binary", "local_binary", "source"],
        "repo_url": None,
        "request_access_url": NCRC_REQUEST_URL,
        "source_url": NCRC_APPLICATIONS_PAGE_URL,
    },
    "cardinal": {
        "access_status": "open_source",
        "description": (
            "Integration of NekRS and OpenMC with MOOSE for high-fidelity "
            "fusion and fission systems simulation."
        ),
        "doc_url": "https://cardinal.cels.anl.gov/",
        "support_forum_url": "https://github.com/neams-th-coe/cardinal/discussions",
        "build_status_url": "https://civet.inl.gov/repo/574/",
        "access_levels": [],
        "repo_url": "https://github.com/neams-th-coe/cardinal",
        "request_access_url": None,
        "source_url": TRACKED_APPS_PAGE_URL,
    },
    "dire_wolf": {
        "access_status": "restricted_or_registration_required",
        "description": "Coupling of Bison, Griffin, and Sockeye into one executable.",
        "doc_url": None,
        "support_forum_url": None,
        "build_status_url": "https://civet.inl.gov/repo/887/",
        "access_levels": ["hpc_ondemand", "hpc_binary", "local_binary", "source"],
        "repo_url": None,
        "request_access_url": NCRC_REQUEST_URL,
        "source_url": NCRC_APPLICATIONS_PAGE_URL,
    },
    "griffin": {
        "access_status": "restricted_or_registration_required",
        "description": (
            "Finite element-based reactor multiphysics application solving "
            "the linearized Boltzmann transport equation, coupled to "
            "Pronghorn/RELAP-7/SAM/Sockeye/BISON."
        ),
        "doc_url": "https://griffin-docs.hpcondemand.inl.gov/",
        "support_forum_url": "https://griffin-discourse.hpcondemand.inl.gov",
        "build_status_url": "https://civet.inl.gov/repo/822/",
        "access_levels": ["hpc_ondemand", "hpc_binary", "local_binary", "source"],
        "repo_url": None,
        "request_access_url": NCRC_REQUEST_URL,
        "source_url": NCRC_APPLICATIONS_PAGE_URL,
    },
    "grizzly": {
        "access_status": "restricted_or_registration_required",
        "description": (
            "Models degradation of nuclear power plant systems/structures/"
            "components under normal operating conditions (e.g. RPV "
            "embrittlement, concrete degradation)."
        ),
        "doc_url": "https://grizzly-docs.hpcondemand.inl.gov/",
        "support_forum_url": "https://grizzly-discourse.hpcondemand.inl.gov",
        "build_status_url": "https://civet.inl.gov/repo/856/",
        # No Conda channel for Grizzly — no Level 2 page, unlike most others.
        "access_levels": ["hpc_ondemand", "hpc_binary", "source"],
        "repo_url": None,
        "request_access_url": NCRC_REQUEST_URL,
        "source_url": NCRC_APPLICATIONS_PAGE_URL,
    },
    "mastodon": {
        "access_status": "open_source",
        "description": "Structural dynamics, seismic analysis, and risk assessment.",
        "doc_url": "https://mastodon.inl.gov/",
        "support_forum_url": None,
        "build_status_url": None,
        "access_levels": [],
        "repo_url": "https://github.com/idaholab/mastodon",
        "request_access_url": None,
        "source_url": TRACKED_APPS_PAGE_URL,
    },
    "pronghorn": {
        "access_status": "restricted_or_registration_required",
        "description": (
            "Multi-dimensional, coarse-mesh thermal-hydraulics code for "
            "advanced reactors, well-suited to gas-cooled pebble bed and "
            "prismatic reactors."
        ),
        "doc_url": "https://pronghorn-docs.hpcondemand.inl.gov/",
        "support_forum_url": "https://pronghorn-discourse.hpcondemand.inl.gov",
        "build_status_url": "https://civet.inl.gov/repo/871/",
        "access_levels": ["hpc_ondemand", "hpc_binary", "local_binary", "source"],
        "repo_url": None,
        "request_access_url": NCRC_REQUEST_URL,
        "source_url": NCRC_APPLICATIONS_PAGE_URL,
    },
    "relap-7": {
        "access_status": "restricted_or_registration_required",
        "description": (
            "Two-phase thermal systems code based on the MOOSE thermal "
            "hydraulics module, with two-phase LWR components."
        ),
        "doc_url": "https://relap7-docs.hpcondemand.inl.gov/",
        "support_forum_url": None,
        "build_status_url": "https://civet.inl.gov/repo/852/",
        "access_levels": ["hpc_ondemand", "hpc_binary", "local_binary", "source"],
        "repo_url": None,
        "request_access_url": NCRC_REQUEST_URL,
        "source_url": NCRC_APPLICATIONS_PAGE_URL,
    },
    "sabertooth": {
        # Only VTB app with neither an NCRC page nor an open-source repo in
        # either source — say so plainly, don't guess a status either way.
        "access_status": "closed_source_no_documented_path",
        "description": "Advanced reactor multiphysics simulation suite.",
        "doc_url": None,
        "support_forum_url": None,
        "build_status_url": None,
        "access_levels": [],
        "repo_url": None,
        "request_access_url": NCRC_REQUEST_URL,
        "source_url": TRACKED_APPS_PAGE_URL,
    },
    "salamander": {
        "access_status": "open_source",
        "description": (
            "Integration of Cardinal with TMAP8 for fusion blanket "
            "multiphysics simulations."
        ),
        "doc_url": "https://salamander.inl.gov/",
        "support_forum_url": "https://github.com/idaholab/salamander/discussions",
        "build_status_url": "https://civet.inl.gov/repo/1357/",
        "access_levels": [],
        "repo_url": "https://github.com/idaholab/salamander",
        "request_access_url": None,
        "source_url": TRACKED_APPS_PAGE_URL,
    },
    "sam": {
        "access_status": "restricted_or_registration_required",
        "description": (
            "Fast-running, whole-plant transient analysis code for design "
            "scoping and safety analyses of advanced non-light-water "
            "reactors."
        ),
        "doc_url": "https://www.anl.gov/nse/system-analysis-module",
        "support_forum_url": None,
        "build_status_url": "https://civet.inl.gov/repo/620/",
        # No Conda channel for SAM either — no Level 2 page.
        "access_levels": ["hpc_ondemand", "hpc_binary", "source"],
        "repo_url": None,
        "request_access_url": NCRC_REQUEST_URL,
        "source_url": NCRC_APPLICATIONS_PAGE_URL,
    },
    "sockeye": {
        "access_status": "restricted_or_registration_required",
        "description": (
            "Heat pipe analysis application for heat-pipe-cooled "
            "microreactors: 1D two-phase flow and 2D effective thermal "
            "conductivity models."
        ),
        "doc_url": "https://sockeye-docs.hpcondemand.inl.gov/",
        "support_forum_url": "https://sockeye-discourse.hpcondemand.inl.gov",
        "build_status_url": "https://civet.inl.gov/repo/837/",
        "access_levels": ["hpc_ondemand", "hpc_binary", "local_binary", "source"],
        "repo_url": None,
        "request_access_url": NCRC_REQUEST_URL,
        "source_url": NCRC_APPLICATIONS_PAGE_URL,
    },
    "tmap8": {
        "access_status": "open_source",
        "description": (
            "System-level mass and thermal transport calculations related "
            "to tritium migration."
        ),
        "doc_url": "https://tmap8.inl.gov/",
        "support_forum_url": "https://github.com/idaholab/tmap8/discussions",
        "build_status_url": "https://civet.inl.gov/repo/530/",
        "access_levels": [],
        # tracked_apps.md links TMAP8 to its own doc site, not a GitHub
        # repo — still the link the source gives, so used as-is here.
        "repo_url": "https://github.com/idaholab/TMAP8",
        "request_access_url": None,
        "source_url": TRACKED_APPS_PAGE_URL,
    },
}


def write_execution_requirements(retrieved_at: str) -> None:
    """Write references/execution_requirements.json from EXECUTION_REQUIREMENTS."""
    checked_at = retrieved_at.split("T", 1)[0]
    apps = {
        app: {**entry, "checked_at": checked_at}
        for app, entry in EXECUTION_REQUIREMENTS.items()
    }
    data = {"access_level_legend": ACCESS_LEVEL_LEGEND, "apps": apps}
    path = REFERENCES_DIR / "execution_requirements.json"
    path.write_text(json.dumps(data, indent=2))


def normalize_app_name(name: str) -> str:
    """Lowercase and strip non-alphanumerics, for fuzzy codes_used matching."""
    return re.sub(r"[^a-z0-9]", "", name.lower())


def load_raw() -> tuple[list[dict], list[dict], dict[str, str], dict]:
    """Load harvest.py's raw JSON output."""
    docs = json.loads((RAW_DIR / "docs.json").read_text())
    tests = json.loads((RAW_DIR / "tests.json").read_text())
    open_source_tiers = json.loads((RAW_DIR / "open_source_tiers.json").read_text())
    meta = json.loads((RAW_DIR / "meta.json").read_text())
    return docs, tests, open_source_tiers, meta


MAX_CODE_BLOCK_CHARS = 3000

# --- MooseDocs raw-markdown -> clean markdown conversion --------------------
#
# The doc pack used to be built from each page's rendered HTML (fetched live
# from virtualtestbed.inl.gov) specifically because raw MooseDocs markdown has
# directives (`!media`, `!alert`, `!tag`, ...) with no plain-markdown
# equivalent. That traded away something worse: KaTeX-rendered math
# (`$...$`, `\begin{equation}`) renders client-side via a bare `<script>` tag
# with no static/MathML fallback at all, so a JS-less fetch captured
# *nothing* — not missing formatting, but actively wrong shipped text (e.g.
# `UO${_2}$` -> "UO"; five distinct `T_*^*` table-row labels collapsing to
# the identical "T K"). See build/RECON_NOTES.md for the full writeup.
#
# Fix: build pages from `page["raw_markdown"]` instead (already read from
# disk by harvest.py — no network fetch needed) and only touch directives
# whose content would otherwise be genuinely missing (`!listing`,
# `!include`) or whose metadata was never meant to be visible prose (`!tag`,
# `!config`, `!devel!`, `!row!`/`!col!`). Everything else — math, `!media`,
# `!table`, `!alert`, citations, `!ac`, `!style`, `!plot`, `+text+`, ... —
# passes through completely untouched, byte-for-byte. That's a deliberate
# scope decision, not an oversight: those directives already read fine as
# plain text to an LLM/keyword-search consumer, and converting them adds
# exactly the kind of conversion-bug risk (see the markdownify escaping bug
# this change also fixes) this pivot exists to avoid.

BARE_LISTING_RE = re.compile(
    r"^!listing[ \t]*\n(?P<body>[^\n]+(?:\n[^\n]+)*)(?=\n\n|\n\Z|\Z)", re.MULTILINE,
)
INCLUDE_MD_RE = re.compile(r"^!include[ \t]+(?P<path>\S+\.md)[ \t]*$\n?", re.MULTILINE)
CONFIG_LINE_RE = re.compile(r"^!config\b.*$\n?", re.MULTILINE)
DEVEL_BLOCK_RE = re.compile(r"^!devel!.*?^!devel-end!\s*\n?", re.DOTALL | re.MULTILINE)
ROW_COL_MARKER_RE = re.compile(
    r"^!row!\s*$\n?|^!row-end!\s*$\n?|^!col!.*$\n?|^!col-end!\s*$\n?", re.MULTILINE,
)


def _render_listing_ref(ref: dict) -> str:
    """Render one resolved !listing reference as fenced code, or an honest note."""
    content = ref.get("content")
    if content is None:
        return f"*(referenced file '{ref['path']}' not resolved)*"
    if ref["block"] is None and len(content) > MAX_CODE_BLOCK_CHARS:
        # references/model-inputs/inputs.jsonl already ships this whole file
        # in full — a truncated partial here would duplicate that manifest's
        # job worse than the manifest itself does it. Point there instead.
        return (
            f"*(full file: see `{ref['path']}` in "
            "references/model-inputs/inputs.jsonl)*"
        )
    if len(content) > MAX_CODE_BLOCK_CHARS:
        head = "\n".join(content.splitlines()[:40])
        return f"```\n{head}\n... [truncated]\n```"
    return f"```\n{content}\n```"


def _substitute_listings(raw_markdown: str, listing_refs: list[dict], harvest) -> str:
    """
    Inline every `!listing <path> [block=X]` reference with its resolved content.

    harvest.LISTING_RE built `listing_refs` by scanning this same raw text in
    this same order, so zipping by match order (not re-resolving by path) is
    exact even when the same path is listed more than once.
    """
    refs = iter(listing_refs)
    return harvest.LISTING_RE.sub(
        lambda _m: _render_listing_ref(next(refs)), raw_markdown,
    )


def _substitute_bare_listings(text: str) -> str:
    """Inline a path-less `!listing` (an inline shell snippet) as fenced code."""
    return BARE_LISTING_RE.sub(
        lambda m: f"```\n{m.group('body').rstrip()}\n```\n", text,
    )


def _substitute_includes(text: str) -> str:
    """Replace a doc-content `!include <page>.md` transclusion with a pointer."""
    return INCLUDE_MD_RE.sub(lambda m: f'*(see the "{m.group("path")}" page)*\n', text)


def _strip_tag_block(text: str, harvest) -> str:
    """Remove the !tag metadata block — never rendered as visible page content."""
    match = harvest.TAG_START_RE.search(text)
    if not match:
        return text
    return text[:match.start()] + text[match.end():]


def moosedocs_to_markdown(raw_markdown: str, page: dict) -> str:
    """Convert one VTB doc page's raw MooseDocs markdown to clean shipped markdown."""
    sys.path.insert(0, str(REPO_ROOT / "build"))
    import harvest  # noqa: PLC0415

    text = _substitute_listings(raw_markdown, page["listing_refs"], harvest)
    text = _substitute_bare_listings(text)
    text = _substitute_includes(text)
    text = _strip_tag_block(text, harvest)
    text = CONFIG_LINE_RE.sub("", text)
    text = DEVEL_BLOCK_RE.sub("", text)
    text = ROW_COL_MARKER_RE.sub("", text)
    return re.sub(r"\n{3,}", "\n\n", text).strip()


# !tag pairs= keys that can carry more than one value and should always be
# normalized to a list, even though the raw MooseDocs source sometimes uses
# a bare string when there's only one value (see build/RECON_NOTES.md).
COLLECTION_TAG_FIELDS = (
    "codes_used", "transient", "simulation_type", "sponsor", "institution",
)


def normalize_tags(tags: dict) -> dict:
    """Force COLLECTION_TAG_FIELDS to always be lists, never a bare string."""
    normalized = dict(tags)
    for field in COLLECTION_TAG_FIELDS:
        if field not in normalized:
            continue
        value = normalized[field]
        if value is None:
            # A literal null is "unset", not a single-item list containing
            # null — drop the field entirely so it reads the same as never
            # having been tagged, rather than becoming the surprising [None].
            del normalized[field]
        elif not isinstance(value, list):
            normalized[field] = [value]
    return normalized


def build_model_index(
    docs: list[dict], tests: list[dict], open_source_tiers: dict[str, str],
    source_commit: str,
) -> tuple[list[dict], list[str]]:
    """
    Build model-index entries from tagged doc pages, cross-checked vs tests.

    Also returns every distinct `codes_used` display name that
    `CODES_USED_TO_APP` doesn't recognize (so `codes_used_apps` silently
    dropped it) — reported by main() rather than accepted without comment.
    """
    entries = []
    unknown_codes_used: set[str] = set()
    for page in docs:
        tag = page.get("tag")
        if not tag or "name" not in tag:
            continue
        raw_tags = tag.get("tags", {})
        tags = normalize_tags(raw_tags)
        # `tutorials` in tags is NOT a reliable signal on its own — e.g.
        # htgr/generic-pbr-tutorial has it but is a real, runnable model
        # (it's the Pronghorn exemplar). What actually distinguishes "no
        # model directory to expect" is living under the site-wide
        # vtb_pages/vtb_tutorials sections rather than a reactor category.
        is_tutorial = page["relpath"].startswith(SITE_WIDE_PREFIXES)

        # The doc-page directory doesn't always mirror the model's real repo
        # directory (e.g. doc page htgr/triso/ vs. actual htgr/triso_fuel/);
        # the page's own "Model link: [...](.../tree/<branch>/<path>)" line,
        # when present, gives the authoritative path — prefer it.
        repo_path = page.get("model_link_path") or str(Path(page["relpath"]).parent)

        codes_used = tags.get("codes_used", [])
        codes_used_apps = {
            CODES_USED_TO_APP[normalize_app_name(c)]
            for c in codes_used
            if normalize_app_name(c) in CODES_USED_TO_APP
        }
        unknown_codes_used.update(
            c for c in codes_used if normalize_app_name(c) not in CODES_USED_TO_APP
        )

        model_tests = [t for t in tests if t["tests_file"].startswith(f"{repo_path}/")]
        tests_apps = {app for t in model_tests for app in t["apps"]}

        relpath = page["relpath"]
        tier_key = relpath[:-len(".md")] if relpath.endswith(".md") else relpath
        raw_open_source = tags.get("open_source")
        open_source_tier = open_source_tiers.get(tier_key) or raw_open_source

        # Tutorial pages carry a !tag block for the VTB site's own filter UI
        # but aren't models with a dedicated input-file directory — a
        # missing repo_path for one of these isn't a data-quality gap.
        repo_path_exists = None if is_tutorial else (SOURCE_DIR / repo_path).is_dir()
        # Don't link a path we already know is wrong (repo_path_exists:
        # false) — a dead link is worse than no link.
        repo_url = (
            github_tree_url(repo_path, source_commit) if repo_path_exists else None
        )

        entries.append({
            "name": tag["name"],
            "summary": tag.get("description", ""),
            "repo_path": None if is_tutorial else repo_path,
            "repo_url": repo_url,
            "doc_url": page["doc_url"],
            "is_tutorial": is_tutorial,
            "tags": tags,
            "raw_tags": raw_tags,
            "codes_used_apps": sorted(codes_used_apps),
            "tests_apps": sorted(tests_apps),
            "apps_mismatch": bool(tests_apps) and not (codes_used_apps & tests_apps),
            "open_source_tier": open_source_tier,
            "repo_path_exists": repo_path_exists,
        })
    return entries, sorted(unknown_codes_used)


def find_cross_repo_name_collisions(
    model_index: list[dict],
) -> list[tuple[str, list[str]]]:
    """
    Model names shared by entries with different, both-real repo_paths.

    A `!tag name=` value isn't guaranteed unique in VTB's own source. Most
    repeats are harmless (several distinct tagged pages documenting one
    real model directory, e.g. microreactors/gcmr's separate
    Core-Neutronics/Core-MP pages — same repo_path, no data ever gets
    mixed since build_model_inputs() groups by repo_path first) and are
    deliberately NOT reported here. This only flags the dangerous case: two
    entries with the identical name but different, both-existing
    repo_paths — an upstream naming collision between genuinely different
    model directories (confirmed real: "MRAD Micro-Reactor Multiphysics
    model" names both microreactors/mrad and its
    3D_core_drum_rotation_tr subdirectory) that would otherwise silently
    pool unrelated inputs under one `get_input.py --model` query.
    """
    repo_paths_by_name: dict[str, set[str]] = {}
    for model in model_index:
        if model.get("repo_path_exists"):
            repo_paths_by_name.setdefault(model["name"], set()).add(model["repo_path"])
    return sorted(
        (name, sorted(paths))
        for name, paths in repo_paths_by_name.items()
        if len(paths) > 1
    )


def select_doc_pages(docs: list[dict]) -> list[dict]:
    """
    Pick which doc pages are worth shipping.

    Tagged models, their detail pages (same directory subtree), and all
    site-wide vtb_pages/vtb_tutorials pages. Pure category roll-up pages
    with no !tag and no substantive content are skipped to keep the
    bundle small.
    """
    tag_dirs = sorted({str(Path(p["relpath"]).parent) for p in docs if p.get("tag")})

    def is_under_a_tag_dir(relpath: str) -> bool:
        page_dir = str(Path(relpath).parent)
        return any(page_dir == d or page_dir.startswith(f"{d}/") for d in tag_dirs)

    selected = []
    for page in docs:
        is_site_wide = page["relpath"].startswith(SITE_WIDE_PREFIXES)
        if is_site_wide or is_under_a_tag_dir(page["relpath"]):
            selected.append(page)
    return selected


TITLE_RE = re.compile(r"^#\s+(.+)$", re.MULTILINE)


def extract_title(body: str) -> str | None:
    """Extract a page's first markdown H1, if any."""
    match = TITLE_RE.search(body)
    return match.group(1).strip() if match else None


def write_doc_pages(pages: list[dict], retrieved_at: str) -> list[dict]:
    """
    Write curated markdown under references/docs/, one file per top-level category.

    claude.ai's Skills upload rejects zips over 200 files; one file per doc
    page (265 of them) blew well past that on its own. Grouping by top-level
    category (sfr, htgr, ...) cuts that to ~11 files while keeping every
    page's content and provenance — each page is prefixed with a
    `<!-- vtb-page: <relpath> -->` marker so search_docs.py can still cite
    the specific source page, not just the category file.

    Returns (page_index, dropped): the page-index list (one entry per page,
    with the exact character offsets of its section within its category
    file) so callers can write references/page-index.json without
    re-deriving offsets later, plus the list of pages that produced no
    shippable content. `page["raw_markdown"]` is read directly from the
    checkout during harvest (no network fetch, no failure mode) — the only
    drop reason is "empty_content": the page's converted body came out
    empty, e.g. a stub whose entire content was a `!tag` block with no prose.
    """
    docs_dir = REFERENCES_DIR / "docs"
    by_category: dict[str, list[tuple[dict, str, str]]] = {}
    dropped = []
    for page in pages:
        body = moosedocs_to_markdown(page["raw_markdown"], page)
        if not body:
            dropped.append({"relpath": page["relpath"], "reason": "empty_content"})
            continue
        title = extract_title(body) or page["relpath"]
        section = (
            f"<!-- vtb-page: {page['relpath']} -->\n"
            f"---\nsource_url: {page['doc_url']}\nretrieved_at: {retrieved_at}\n---\n\n"
            f"{body}\n"
        )
        category = page["relpath"].split("/", 1)[0]
        by_category.setdefault(category, []).append((page, title, section))

    page_index = []
    for category, entries in by_category.items():
        bundle_file = f"references/docs/{category}.md"
        parts = []
        cursor = 0
        for page, title, section in entries:
            if parts:
                parts.append("\n")
                cursor += 1
            start = cursor
            parts.append(section)
            cursor += len(section)
            page_index.append({
                "relpath": page["relpath"],
                "bundle_file": bundle_file,
                "title": title,
                "source_url": page["doc_url"],
                "retrieved_at": retrieved_at,
                "start": start,
                "end": cursor,
                "category": category,
            })
        (docs_dir / f"{category}.md").write_text("".join(parts))
    return page_index, dropped


def write_acronyms() -> None:
    """Ship doc/acronyms.yml as a plain markdown glossary."""
    acronyms = yaml.safe_load((SOURCE_DIR / "doc" / "acronyms.yml").read_text())
    lines = [
        "# VTB acronym glossary",
        "",
        "Source: `doc/acronyms.yml` in the VTB repo.",
        "",
    ]
    for term in sorted(acronyms):
        lines.append(f"- **{term}**: {acronyms[term]}")
    (REFERENCES_DIR / "acronyms.md").write_text("\n".join(lines) + "\n")


def walk_all_blocks(lines: list[str]) -> list[dict]:
    """
    Recursively walk every MOOSE block in an input file, at any depth.

    Returns a flat list of {"path", "type", "parameters"} dicts, one per
    block, in document order. `path` is slash-joined ("Kernels/heat_cond")
    to encode nesting — simpler to build and to query than a nested tree,
    and just as expressive since MOOSE block names are unique per level.
    """
    # Imported lazily to avoid a hard dependency loop with harvest.py.
    sys.path.insert(0, str(REPO_ROOT / "build"))
    import harvest  # noqa: PLC0415

    param_re = re.compile(r"^\s*([A-Za-z_][A-Za-z0-9_]*)\s*=\s*(.+?)\s*$")

    def own_params(open_idx: int, close_idx: int, children: list) -> dict[str, str]:
        child_ranges = [(co, cc) for _, co, cc in children]
        params = {}
        for i in range(open_idx + 1, close_idx):
            if any(co <= i <= cc for co, cc in child_ranges):
                continue
            match = param_re.match(lines[i])
            if match:
                params[match.group(1)] = match.group(2).strip().strip("'\"")
        return params

    def walk(open_idx: int, close_idx: int, prefix: str) -> list[dict]:
        results = []
        child_spans = harvest.child_blocks(lines, open_idx, close_idx)
        for name, child_open, child_close in child_spans:
            path = f"{prefix}/{name}" if prefix else name
            children = harvest.child_blocks(lines, child_open, child_close)
            params = own_params(child_open, child_close, children)
            block = {"path": path, "type": params.get("type"), "parameters": params}
            results.append(block)
            results.extend(walk(child_open, child_close, path))
        return results

    # Treat the whole file as an implicit root span: MOOSE top-level blocks
    # ([Mesh], [Variables], ...) are siblings with no common wrapping block.
    return walk(-1, len(lines), "")


def collect_defined_names(blocks: list[dict]) -> set[str]:
    """Every block's own (unqualified) name, for cross-reference matching."""
    return {block["path"].rsplit("/", 1)[-1] for block in blocks}


NUMERIC_RE = re.compile(r"^-?\d+(\.\d+)?([eE][-+]?\d+)?$")
BOOLEAN_VALUES = {"true", "false", "on", "off", "yes", "no"}


def classify_parameters(
    blocks: list[dict], defined_names: set[str], file_ref_values: set[str],
) -> tuple[list[dict], list[dict]]:
    """
    Split every non-`type` parameter into cross-references and edit candidates.

    A cross-reference is *reported because it resolved* — its value (or,
    for MOOSE's space-separated list parameters, one of its tokens)
    matches another block actually defined in this same template — so
    nothing is asserted as a resolved reference without checking. A
    candidate editable parameter is a bare numeric/boolean literal.
    Everything else (enum-keyword strings like `execute_on = 'initial'`,
    short descriptive text) is deliberately left as-is rather than
    guessed at — see build/RECON_NOTES.md.
    """
    cross_references = []
    candidates = []
    for block in blocks:
        for key, value in block["parameters"].items():
            if key == "type" or value in file_ref_values:
                continue
            tokens = value.split()
            matched = [t for t in tokens if t in defined_names]
            if matched:
                cross_references.append({
                    "block": block["path"], "parameter": key,
                    "value": value, "matched_names": matched,
                })
                continue
            is_numeric_or_bool = tokens and all(
                NUMERIC_RE.match(t) or t.lower() in BOOLEAN_VALUES for t in tokens
            )
            if is_numeric_or_bool:
                candidate = {"block": block["path"], "parameter": key, "value": value}
                candidates.append(candidate)
    return cross_references, candidates


# Matches a parameter whose *name* is "file" or ends in "_file"
# (library_file, data_file, positions_file, ...) or is MultiApps'
# `input_files` — the sub-app inputs of a coupled/multiphysics run. The
# "_file" boundary matters: a bare `\w*file` also matches `axial_power_pro`
# + `file` = `axial_power_profile` (a function name, not a path), a false
# match the transitive walk would otherwise chase into a missing file. The
# value is captured whole (it may be a space-separated *list* of paths,
# e.g. `input_files = 'sub1.i sub2.i'`) and split by find_file_references;
# a purely numeric value like `x_index_in_file = 0` is a column index, not
# a path, and is dropped there.
FILE_REF_RE = re.compile(
    r"^\s*((?:\w+_)?file|input_files)\s*=\s*(.+?)\s*(?:#.*)?$", re.MULTILINE,
)


def find_file_references(input_path: Path) -> list[str]:
    """Find file-path-valued parameters (name ending in "file", or `input_files`)."""
    text = input_path.read_text(encoding="utf-8", errors="replace")
    refs = []
    for match in FILE_REF_RE.finditer(text):
        for token in match.group(2).strip().strip("'\"").split():
            token = token.strip("'\"")
            if token and not token.isdigit():
                refs.append(token)
    return refs


def _pages_under_dir(docs: list[dict], tag_dir: str) -> list[dict]:
    """Every doc page in the same directory subtree as `tag_dir` (itself included)."""
    return [
        p for p in docs
        if (page_dir := str(Path(p["relpath"]).parent)) == tag_dir
        or page_dir.startswith(f"{tag_dir}/")
    ]


def _top_level_block_names(blocks: list[dict]) -> list[str]:
    """Return a record's top-level (unnested) block names, in document order."""
    return [b["path"] for b in blocks if "/" not in b["path"]]


def _distinct_object_types(blocks: list[dict]) -> list[str]:
    """Sorted distinct non-null `type =` values across every block, at any depth."""
    return sorted({b["type"] for b in blocks if b.get("type")})


def _distinct_parameter_names(blocks: list[dict]) -> list[str]:
    """Sorted distinct parameter names across every block, excluding `type`."""
    return sorted({k for b in blocks for k in b["parameters"] if k != "type"})


def _input_snippet(record: dict) -> str:
    """Build a short, cheap preview for search — never requires reading inputs.jsonl."""
    if not record["blocks"]:
        return "No MOOSE blocks detected."
    names = _top_level_block_names(record["blocks"])
    lines = ["Top-level blocks: " + ", ".join(f"[{n}]" for n in names[:8])]
    object_types = record.get("object_types")
    if object_types:
        lines.append("Object types: " + ", ".join(object_types[:10]))
    return "\n".join(lines)


def build_model_inputs(
    model_index: list[dict], docs: list[dict], tests: list[dict], source_commit: str,
) -> list[dict]:
    """
    Walk every model's own repo_path directory for `.i` files and parse each one.

    Automatic and comprehensive (every model with a resolved directory, not
    a hand-picked exemplar per app), and deliberately does NOT classify or
    chase the files a `.i` input merely *references* (meshes, cross-section
    libraries, restart checkpoints) — see build/RECON_NOTES.md for why. A
    model's own input files are what gets indexed; anything they reference
    is reachable via the model's `repo_url` or a live pinned-commit fetch.

    `is_primary` comes from harvest.cited_input_basenames() against every
    doc page in the *same directory subtree as the model's own tagged page*
    (a model can span several pages — not just one), unioning `!listing`
    refs with prose run-command/markdown-link/italic citations — `!listing`
    alone would miss real cases (confirmed: sfr/abtr cites both its inputs
    only as `-i <file>.i` run commands, never via `!listing`).
    """
    sys.path.insert(0, str(REPO_ROOT / "build"))
    import harvest  # noqa: PLC0415

    docs_by_doc_url = {p["doc_url"]: p for p in docs}
    records: list[dict] = []
    canonical_by_realpath: dict[Path, dict] = {}  # dedupe symlinks by real target

    # Group by repo_path first, not by model entry: a handful of directories
    # are documented by more than one model page (e.g. four separate gcmr
    # pages -- core/assembly/balance-of-plant/etc. -- all describing files
    # in the same microreactors/gcmr directory). Walking per-model-entry
    # would let whichever model happens to iterate first silently claim
    # every file for itself, leaving its siblings with no inputs at all.
    models_by_repo_path: dict[str, list[dict]] = {}
    for model in model_index:
        repo_path = model.get("repo_path")
        if repo_path and model.get("repo_path_exists") is True:
            models_by_repo_path.setdefault(repo_path, []).append(model)
    all_repo_paths = sorted(models_by_repo_path)

    def owned_by_a_deeper_repo_path(found_relpath: str, repo_path: str) -> bool:
        # A few repo_paths nest inside another (e.g. msr/msfr/plant and
        # msr/msfr/plant/standalone_sam_model are two DIFFERENT models'
        # own directories, one inside the other) -- rglob from the
        # shallower one would otherwise recurse straight through the
        # deeper one's files and claim them under the wrong model
        # entirely, not just under a less-specific repo_path. Let the
        # deepest (longest) repo_path that actually contains a file claim
        # it; every other one skips it.
        return any(
            other != repo_path and len(other) > len(repo_path)
            and found_relpath.startswith(f"{other}/")
            for other in all_repo_paths
        )

    for repo_path, sharing_models in sorted(models_by_repo_path.items()):
        model_names = sorted({m["name"] for m in sharing_models})
        # Cheap join, not new parsing: every model sharing this repo_path
        # already has codes_used_apps/tests_apps computed by
        # build_model_index() — union them as a hint at which app(s) this
        # directory's inputs are meant for.
        app_hint = sorted({
            app for m in sharing_models
            for app in (m.get("codes_used_apps") or []) + (m.get("tests_apps") or [])
        })
        cited: set[str] = set()
        for model in sharing_models:
            own_page = docs_by_doc_url.get(model["doc_url"])
            if own_page is None:
                continue
            tag_dir = str(Path(own_page["relpath"]).parent)
            cited |= harvest.cited_input_basenames(_pages_under_dir(docs, tag_dir))

        model_dir = SOURCE_DIR / repo_path
        for found in sorted(model_dir.rglob("*.i")):
            if owned_by_a_deeper_repo_path(
                str(found.relative_to(SOURCE_DIR)), repo_path,
            ):
                continue
            real_path = found.resolve() if found.is_symlink() else found
            if not real_path.is_file():
                continue  # a broken symlink -- nothing to index
            found_relpath = str(found.relative_to(SOURCE_DIR))

            existing = canonical_by_realpath.get(real_path)
            if existing is not None:
                if found_relpath != existing["path"] and (
                    found_relpath not in existing["aliases"]
                ):
                    existing["aliases"].append(found_relpath)
                continue

            repo_relpath = str(real_path.relative_to(SOURCE_DIR))
            text = real_path.read_text(encoding="utf-8", errors="replace")
            lines = text.splitlines()
            blocks = walk_all_blocks(lines)
            defined_names = collect_defined_names(blocks)
            file_ref_values = set(find_file_references(real_path))
            cross_references, candidates = classify_parameters(
                blocks, defined_names, file_ref_values,
            )
            top_level_names = _top_level_block_names(blocks)
            is_primary = bool(cited & {real_path.name, found.name})
            model_tests = [
                t for t in tests
                if t["tests_file"].startswith(f"{repo_path}/")
                and t.get("input") in (real_path.name, found.name)
            ]
            record = {
                "path": repo_relpath,
                "model_names": model_names,
                "model_repo_path": repo_path,
                "is_primary": is_primary,
                "aliases": (
                    [] if found_relpath == repo_relpath else [found_relpath]
                ),
                "source": {
                    "repository": "idaholab/virtual_test_bed",
                    "commit": source_commit,
                    "path": repo_relpath,
                    "blob_sha": harvest.git_blob_sha(SOURCE_DIR, repo_relpath),
                },
                "repo_url": github_blob_url(repo_relpath, source_commit),
                "size_bytes": real_path.stat().st_size,
                "content": text,
                "blocks": blocks,
                "cross_references": cross_references,
                "candidate_editable_parameters": candidates,
                "runs": model_tests,
                "object_types": _distinct_object_types(blocks),
                "parameter_names": _distinct_parameter_names(blocks),
                "referenced_files": sorted(file_ref_values),
                "has_multiapps": "MultiApps" in top_level_names,
                "has_transfers": "Transfers" in top_level_names,
                # Only distinguishes "MOOSE hit-format parsed" from "did not
                # parse as MOOSE at all" (e.g. a Serpent Monte Carlo input
                # sharing the .i extension by convention, per RECON_NOTES) —
                # deliberately not a finer syntax-variant classification.
                "dialect": "moose" if blocks else "non_moose_or_unrecognized",
                "app_hint": app_hint,
            }
            canonical_by_realpath[real_path] = record
            records.append(record)

    records.sort(key=lambda r: r["path"])
    return records


def write_model_inputs(records: list[dict]) -> list[dict]:
    r"""
    Write inputs.jsonl (heavy content+parse-detail) and return the lean index.

    Offsets are BYTE offsets into the UTF-8-encoded file (not character
    offsets into read_text()'s universal-newline-translated string, the way
    page-index.json's start/end work) — get_input.py seeks in binary mode,
    which never translates line endings, so this sidesteps the
    offset-desync class of bug entirely rather than needing the same
    CRLF-normalize-before-computing-offsets discipline write_doc_pages()
    requires for markdown. Each line is one compact (no `indent=`) JSON
    object; json.dumps() escapes any literal newline *inside* a field's
    string value as the two characters `\n`, so a "line" in this file is
    always exactly one full record regardless of what a `.i` file's own
    line endings look like.
    """
    inputs_dir = REFERENCES_DIR / "model-inputs"
    inputs_dir.mkdir(parents=True, exist_ok=True)
    index_entries = []
    encoded_lines = []
    cursor = 0
    for record in records:
        encoded = (json.dumps(record, separators=(",", ":")) + "\n").encode("utf-8")
        index_entries.append({
            "path": record["path"],
            "model_names": record["model_names"],
            "model_repo_path": record["model_repo_path"],
            "is_primary": record["is_primary"],
            "aliases": record["aliases"],
            "repo_url": record["repo_url"],
            "source_commit": record["source"]["commit"],
            "blob_sha": record["source"]["blob_sha"],
            "size_bytes": record["size_bytes"],
            "snippet": _input_snippet(record),
            "object_types": record["object_types"],
            "parameter_names": record["parameter_names"],
            "referenced_files": record["referenced_files"],
            "has_multiapps": record["has_multiapps"],
            "has_transfers": record["has_transfers"],
            "dialect": record["dialect"],
            "app_hint": record["app_hint"],
            "jsonl_offset": cursor,
            "jsonl_length": len(encoded),
        })
        encoded_lines.append(encoded)
        cursor += len(encoded)
    (inputs_dir / "inputs.jsonl").write_bytes(b"".join(encoded_lines))
    return index_entries


def write_attribution(
    source_commit: str,
    doc_pages: list[dict],
    input_index: list[dict],
    retrieved_at: str,
) -> None:
    """Generate ATTRIBUTION.md covering every bundled file's provenance."""
    lines = [
        "# Attribution",
        "",
        "Content in `skills/vtb-docs/references/` "
        f"is derived from [{UPSTREAM_REPO_URL}]({UPSTREAM_REPO_URL}), licensed "
        f"under {UPSTREAM_LICENSE} (see upstream `LICENSE` and `COPYRIGHT`).",
        "",
        f"Upstream source commit: `{source_commit}`. Retrieved: {retrieved_at}.",
        "",
        "## Documentation pages",
        "",
    ]
    for page in doc_pages:
        category = page["relpath"].split("/", 1)[0]
        source = page["relpath"]
        doc_url = page["doc_url"]
        lines.append(f"- `references/docs/{category}.md` (from `{source}`) — {doc_url}")
    lines += [
        "",
        "## Model input files",
        "",
        f"{len(input_index)} MOOSE `.i` input files, one entry per model that has "
        "a resolved source directory, content and full listing in "
        "`references/model-inputs/inputs.jsonl` "
        "(index: `references/model-inputs/input-index.json`).",
        "",
    ]
    for entry in input_index:
        alias_note = f" (aka {', '.join(entry['aliases'])})" if entry["aliases"] else ""
        lines.append(f"- `{entry['path']}`{alias_note} — {entry['repo_url']}")
    lines += [
        "",
        "## Glossary",
        "",
        "- `references/acronyms.md` — from `doc/acronyms.yml`",
        "",
        "## Application access metadata",
        "",
        "- `references/execution_requirements.json` — hand-curated from MOOSE's "
        f"own application-access documentation, not from {UPSTREAM_REPO_URL}: "
        f"[{NCRC_APPLICATIONS_PAGE_URL}]({NCRC_APPLICATIONS_PAGE_URL}) and "
        f"[{TRACKED_APPS_PAGE_URL}]({TRACKED_APPS_PAGE_URL}).",
        "",
    ]
    (REPO_ROOT / "ATTRIBUTION.md").write_text("\n".join(lines) + "\n")


def main(argv: list[str] | None = None) -> int:
    """Build the reference pack."""
    parser = argparse.ArgumentParser(description=__doc__)
    parser.parse_args(argv)

    docs, tests, open_source_tiers, meta = load_raw()
    retrieved_at = datetime.now(UTC).isoformat(timespec="seconds")

    REFERENCES_DIR.mkdir(parents=True, exist_ok=True)
    (REFERENCES_DIR / "docs").mkdir(exist_ok=True)

    model_index, unknown_codes_used = build_model_index(
        docs, tests, open_source_tiers, meta["source_commit"],
    )
    (REFERENCES_DIR / "model-index.json").write_text(json.dumps({
        "source_commit": meta["source_commit"],
        "retrieved_at": retrieved_at,
        "models": model_index,
    }, indent=2))

    selected_pages = select_doc_pages(docs)
    page_index, dropped = write_doc_pages(selected_pages, retrieved_at)
    (REFERENCES_DIR / "page-index.json").write_text(json.dumps(page_index, indent=2))
    write_acronyms()
    write_execution_requirements(retrieved_at)

    input_records = build_model_inputs(
        model_index, docs, tests, meta["source_commit"],
    )
    input_index = write_model_inputs(input_records)
    (REFERENCES_DIR / "model-inputs" / "input-index.json").write_text(
        json.dumps(input_index, indent=2),
    )

    write_attribution(meta["source_commit"], selected_pages, input_index, retrieved_at)

    mismatches = [m["name"] for m in model_index if m["apps_mismatch"]]
    print(
        f"wrote {len(model_index)} model-index entries ({len(mismatches)} mismatches)",
    )
    doc_file_count = len(list((REFERENCES_DIR / "docs").glob("*.md")))
    print(
        f"wrote {len(page_index)} of {len(selected_pages)} selected doc pages "
        f"into {doc_file_count} category files",
    )
    empty = [d["relpath"] for d in dropped if d["reason"] == "empty_content"]
    if empty:
        print(f"  skipped {len(empty)} page(s) with no extractable prose")
    primary_count = sum(1 for e in input_index if e["is_primary"])
    models_with_inputs = {n for e in input_index for n in e["model_names"]}
    print(
        f"wrote {len(input_index)} model input files ({primary_count} primary) "
        f"across {len(models_with_inputs)} models",
    )
    if mismatches:
        print("apps_mismatch:", ", ".join(mismatches))
    if unknown_codes_used:
        print(
            f"WARNING: {len(unknown_codes_used)} codes_used value(s) not in "
            f"CODES_USED_TO_APP (silently excluded from codes_used_apps): "
            + ", ".join(unknown_codes_used),
        )
    unknown_capability_tokens = meta.get("unknown_capability_tokens", [])
    if unknown_capability_tokens:
        print(
            f"WARNING: {len(unknown_capability_tokens)} capability token(s) from "
            f"harvest.py not in CAPABILITY_TO_APP (see build/_cache/raw/meta.json): "
            + ", ".join(unknown_capability_tokens),
        )
    name_collisions = find_cross_repo_name_collisions(model_index)
    for name, repo_paths in name_collisions:
        print(
            f'WARNING: model name "{name}" names {len(repo_paths)} distinct, '
            f"both-real repo_paths — an upstream VTB naming collision, not a "
            f"build defect: {', '.join(repo_paths)}",
        )

    return 0


if __name__ == "__main__":
    sys.exit(main())
