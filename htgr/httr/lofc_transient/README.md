# HTTR Loss-of-Forced-Cooling Transient

This directory contains the coupled HTTR loss-of-forced-cooling model documented in
`doc/content/htgr/httr/transient.md`.

- `case/` contains the steady-state initialization and transient simulation inputs.
- `supporting_files/` contains the tracked proxy mesh, Xenon cross-section and decay
  data, and `compact_mesh.i`, which generates the ignored `compact_mesh_in.e`
  fuel-pin mesh.

Run the steady-state inputs before the corresponding transient inputs. In particular,
`C01_Pronghorn.i` generates `case/LOFC2_Steady.e`, which `C02_Pronghorn.i` consumes.
The generated Exodus file and restart/output directories are intentionally not tracked.
