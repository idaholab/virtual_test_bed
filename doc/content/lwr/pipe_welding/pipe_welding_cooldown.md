# Multi-Pass Pipe Welding Model: Stage 2, 3D Cooldown

*Contact: Bipul Barua, barau@anl.gov; Cheng-Hau Yang, chenghau.yang@anl.gov*

*Sponsor: U.S. Nuclear Regulatory Commission (NRC), Office of Nuclear Regulatory Research (RES)*

*Model developed by Bipul Barua (Argonne National Laboratory); VTB integration and validation by Cheng-Hau Yang (Argonne National Laboratory)*

*Model link: [Pipe Welding Model](https://github.com/idaholab/virtual_test_bed/tree/main/lwr/pipe_welding)*

## High Level Summary of Model

The second stage continues the [welding simulation](pipe_welding_welding.md) after the last pass.
It restarts from the final welding state, releases the welding clamps, and cools the pipe to
ambient temperature by radiation and convection, to obtain the final residual stress field
(t = 9625 to 720000 s).

## Computational Model Description

The cooldown uses the same mesh, variables, kernels and materials as the welding stage
(`common_objects_R5_plas.i`), without the auxiliary variables of the element activation (`phi`,
`weld`, `a`, `tbegin`), and with three differences:

1. **Restart.** The mesh and the complete solution state, including the stateful plastic and
   creep variables, are restored from the final welding checkpoint
   (`Problem/restart_file_base = ../welding/40mm/weld_cp/LATEST`).
2. **Clamp release.** The clamp constraints of the welding stage are replaced by nodal forces equal
   to the clamp reactions at the end of welding (`rx`, `ry`, `rz`, restored from the checkpoint
   and not updated during the cooldown). These forces are reduced
   linearly to zero over `load_release_time` = 360 s, so the clamps are released smoothly.
3. **Minimal support.** Rigid-body motion is prevented by two bottom nodes, held at their
   displacements at the end of welding, and the symmetry condition on `yfix_bot`.

### Welding to cooldown transfer

Two quantities are transferred from the welding stage, both without hard-coded values:

- **State:** through the checkpoint restart (`weld_cp_dir` in `cooldown_config.i`).
- **Bottom-node displacements:** `xzfix_bot_disp_x` and `xzfix_bot_disp_z` at (-75, 450, 0), and
  `zfix_bot_disp_z` at (75, 450, 0). They are read from the welding CSV output (`weld_csv` in
  `cooldown_config.i`) by `PiecewiseLinear` functions and imposed with `ADFunctionDirichletBC`.
  `PiecewiseLinear` does not extrapolate, so for all cooldown times it returns the value at the
  last welding output time, which is the time of the final welding checkpoint.

When the model is run with `run_pipeline.sh`, the script checks before the cooldown that `LATEST`
is the final welding checkpoint and that the welding CSV ends at t = 9625 s.

Files used by this stage include:

- the main MOOSE input file `cooldown.i`, which includes `common_config.i`, `cooldown_config.i`,
  `common_objects_R5_plas.i` and `cooldown_objects.i`
- the welding outputs `../welding/40mm/weld_cp` (checkpoint) and `../welding/40mm/scl.csv` (CSV)

!listing /lwr/pipe_welding/cooldown/cooldown.i

### Parameters

!listing /lwr/pipe_welding/cooldown/cooldown_config.i

### `Problem` and `Mesh`

!listing /lwr/pipe_welding/cooldown/common_objects_R5_plas.i block=Problem

!listing /lwr/pipe_welding/cooldown/common_objects_R5_plas.i block=Mesh

### `Functions`

`release` scales the clamp reaction forces from 1 to 0 between t = 9625 s and t = 9985 s. The
three `*_weld_end` functions provide the welding-end displacements of the bottom nodes.

!listing /lwr/pipe_welding/cooldown/cooldown_objects.i block=Functions

### Clamp release: `AuxVariables`, `AuxKernels` and `NodalKernels`

The scaled reactions `rx_released = rx * release(t)` (and likewise for `ry` and `rz`) are
evaluated at the start of each time step. A `CoupledForceNodalKernel` applies each one to the
former clamp nodes.

!listing /lwr/pipe_welding/cooldown/cooldown_objects.i block=AuxVariables

!listing /lwr/pipe_welding/cooldown/cooldown_objects.i block=AuxKernels

!listing /lwr/pipe_welding/cooldown/cooldown_objects.i block=NodalKernels

### `BCs`

!listing /lwr/pipe_welding/cooldown/cooldown_objects.i block=BCs

### `Executioner` and `Outputs`

Same solver as the welding stage. The time step grows to at most 3600 s.

!listing /lwr/pipe_welding/cooldown/common_objects_R5_plas.i block=Executioner

!listing /lwr/pipe_welding/cooldown/common_objects_R5_plas.i block=Outputs

## Running the model

After the welding stage, from `lwr/pipe_welding`:

```
MOOSE_EXEC=/path/to/app/grizzly-opt ./run_pipeline.sh cooldown
```

which runs `mpiexec -n 12 grizzly-opt -i cooldown.i` in `cooldown/`, with the rank count of the
welding checkpoint. On 12 processors the 206 time steps take about 15 minutes (about 11 minutes on
20 processors). The following output files are produced in `cooldown/40mm/`:

- the Exodus results file `out.e`, whose final time step contains the residual stress field
- the CSV postprocessor history `scl.csv`
- the checkpoint directory `cooldown_cp`

Reference results of the full simulation are in `cooldown/gold/cooldown_full_scl.csv`.

## HPC Resources

| Resource | Original run | Updated run |
| :- | :- | :- |
| Machine | Workstation (2 $\times$ Intel Xeon Gold 6346, 32 cores) | same |
| Number of nodes | 1 | 1 |
| Number of processes | 12 (same as the welding stage) | 20 (same as the welding stage) |
| Number of threads per process | 1 | 1 |
| Time steps | 206 | 206 |
| Nonlinear / linear iterations | 118 / 1,510 | 118 / 1,510 |
| Failed nonlinear solves | 0 | 0 |
| Run time | 884 s (about 15 minutes) | 633 s (about 11 minutes) |
| Peak memory per process | not recorded | about 0.9 GB |

The original run produced the reference results `cooldown/gold/cooldown_full_scl.csv`. The updated
run restarts from the updated welding run (see HPC Resources on
[the welding page](pipe_welding_welding.md) for the input changes); its postprocessors agree with
the reference results to within $5 \times 10^{-10}$ relative at all 207 output times, and the final
residual stress fields to within $10^{-10}$. The run times are a reference performance comparison on
a shared workstation, not a controlled MPI scaling study.

## Results

[pipe_welding_residual_stress] shows the von Mises residual stress field at the end of the
cooldown. The highest stresses are found in the weld region at mid-height.

!media lwr/pipe_welding/fig3_vonmises_after_cooldown.png
      id=pipe_welding_residual_stress
      style=width:60%
      caption=Final von Mises residual stress on the outer surface of the pipe after cooldown, at t = 720000 s.

- **Final residual stresses** (t = 720000 s, reference results): von Mises 144.5 MPa at the inner
  surface point and 480 MPa at the outer surface point.
- **Consistency check of the displacement transfer:** the bottom-node displacements imposed in the
  cooldown are read from the welding CSV output (`PiecewiseLinear` functions applied with
  `ADFunctionDirichletBC`). To check the transfer, the values of `disp_x` and `disp_z` at these
  nodes in the cooldown solution were compared with the last row of the welding CSV. They differ
  by at most 3e-15 mm (round-off) and stay constant during the cooldown. The `cooldown_abbrev`
  test records these nodal values with `PointValue` postprocessors at every output, so its gold
  file checks the same property on the abbreviated run.

### Residual Stress and Subsequent Fracture Analysis

The residual stress field at the end of cooldown can serve as the initial stress state for
subsequent structural integrity and fracture assessments. [!citet](munday2026integrated) investigate
the integration of weld residual stress evolution and crack propagation using the extended finite
element method (XFEM). The VTB example ends with the residual stress calculation after cooldown.

!bibtex bibliography
