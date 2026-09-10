!config navigation breadcrumbs=False scrollspy=False

# VTB Assistant

The VTB Assistant is a skill/plugin for [Claude](https://claude.ai) and
[ChatGPT](https://chatgpt.com) that finds Virtual Test Bed reactor models,
explains VTB documentation, and generates or modifies VTB simulation input
files. It works entirely from a bundled, curated snapshot of this repository
searched by keyword at runtime.

## Getting the Assistant

Every merge of `devel` into `main` rebuilds the Assistant's knowledge from
the VTB repository's current state and republishes it as the
[latest release](https://github.com/idaholab/virtual_test_bed/releases/tag/vtb-assistant-pack-latest),
which always has two ready-to-use zips:

- [`vtb-assistant-plugin.zip`](https://github.com/idaholab/virtual_test_bed/releases/download/vtb-assistant-pack-latest/vtb-assistant-plugin.zip) (for +Claude Code+).
- [`vtb-docs-skill.zip`](https://github.com/idaholab/virtual_test_bed/releases/download/vtb-assistant-pack-latest/vtb-docs-skill.zip) (for +claude.ai / ChatGPT+).

## Installing the Assistant

### For claude.ai or ChatGPT

1. Download `vtb-docs-skill.zip` above.
2. On claude.ai, go to Customize > Skills > Add > Upload skill and upload the
   zip as-is. On ChatGPT, go to Plugins > Skills > "+" > Upload from your computer.
3. Start a conversation and ask it a VTB question (see
   [#example-prompts] below). Mentioning the VTB is usually enough for it
   to trigger automatically; to invoke it explicitly, type `/vtb-docs` on
   claude.ai or `@vtb-docs` in ChatGPT.

### For Claude Code

1. Download `vtb-assistant-plugin.zip` above.
2. Extract it to `~/.claude/skills/vtb-assistant/` to load it in every
   session, or to `<your-project>/.claude/skills/vtb-assistant/` to load it
   only for one project (the project's workspace needs to be trusted
   first). Claude Code auto-loads anything dropped into `.claude/skills/*`
   as a "skills-directory plugin," with no build step and no marketplace.
3. Alternatively, run `claude --plugin-dir path/to/vtb-assistant-plugin.zip`
   to load it for a single session without extracting it anywhere
   permanent.

## Example Prompts id=example-prompts

- +Finding a model:+ "What VTB models use Griffin?"
- +Explaining documentation:+ "Explain the MSRE SAM model."
- +Generating or modifying an input file:+ "Generate a BISON input file
  based on the closest VTB example for a TRISO fuel pellet."

!alert! warning title=Read before generating or modifying an input file
- Any generated or modified input needs independent engineering review
  before use in safety analysis, design decisions, or licensing work. The
  Assistant grounds inputs in real VTB examples but never runs or validates
  them against the actual application.
- Generating or modifying an input file is only supported for BISON,
  Griffin, SAM, Pronghorn, Grizzly, MASTODON, RELAP-7, Sockeye, Cardinal,
  and BlueCrab. Cardinal and BlueCrab are coupling-only: there is no
  standalone (non-`[MultiApps]`) example of either in the VTB.
- Not supported: NekRS-only models (parts of `msr/msre` and
  `pbfhr/mark1/reflector`), and inventing a *new* MultiApps/Transfers
  coupling that isn't already demonstrated in a bundled input.
!alert-end!

## Content Freshness

The Assistant's knowledge is a static snapshot of this whole repository,
models and documentation included, pinned to the commit it was built from
(see the bundled `ATTRIBUTION.md` for the exact commit and retrieval date).
It is not a live view of `devel`: it is regenerated whenever `devel` is
merged into `main`, so it can lag content on `devel` by however long that
merge takes, but it stays current with everything published on `main`.

## For Developers

The Assistant lives inside this repository at
[`vtb_assistant/`](https://github.com/idaholab/virtual_test_bed/tree/devel/vtb_assistant)
and ships and evolves alongside the models it documents. To build it
yourself:

```
git clone git@github.com:idaholab/virtual_test_bed.git
cd virtual_test_bed/vtb_assistant
uv sync --all-groups
uv run --group harvest python build/harvest.py
uv run --group harvest python build/build_reference_pack.py
./build/package_skill.sh    # zips skills/vtb-docs/ for claude.ai / ChatGPT
./build/package_plugin.sh   # zips the full plugin for Claude Code
```

See `vtb_assistant/README.md` and `vtb_assistant/CLAUDE.md` in the repository
for the full development workflow, testing, and packaging details. Those
files are the maintained source of truth and are not duplicated here.

## Connecting to a Coding Agent

Today the Assistant targets Claude Code, claude.ai, and ChatGPT only. In
Claude Code, load a local checkout for development with:

```
claude --plugin-dir vtb_assistant/
```

There is deliberately no MCP server, hosted backend, or public Claude Code
marketplace listing.
