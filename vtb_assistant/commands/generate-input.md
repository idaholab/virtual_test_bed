---
description: Generate or modify a Virtual Test Bed (VTB) simulation input file
---

Use the `vtb-docs` skill to generate or modify a VTB input file for: $ARGUMENTS

Follow the skill's instructions in `skills/vtb-docs/SKILL.md` — base the
result on the closest matching indexed input from
`references/model-inputs/input-index.json` (search with `search_docs.py
--kind input`, fetch with `scripts/get_input.py`), and say plainly if the
request falls outside MVP scope (NekRS-only models, or a new MultiApps
coupling not already demonstrated in a bundled input) instead of guessing
at syntax.
