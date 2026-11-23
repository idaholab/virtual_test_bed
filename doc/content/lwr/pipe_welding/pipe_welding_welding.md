# Multi-Pass Pipe Welding Model: Stage 1, 3D Welding

*Contact: Bipul Barua, barau@anl.gov; Cheng-Hau Yang, chenghau.yang@anl.gov*

*Sponsor: U.S. Nuclear Regulatory Commission (NRC), Office of Nuclear Regulatory Research (RES)*

*Model developed by Bipul Barua (Argonne National Laboratory); VTB integration and validation by Cheng-Hau Yang (Argonne National Laboratory)*

*Model link: [Pipe Welding Model](https://github.com/idaholab/virtual_test_bed/tree/devel/lwr/pipe_welding)*

## High Level Summary of Model

Welding introduces residual stresses that affect the integrity of pressure-retaining components
in light water reactors, such as the primary piping and the welds connecting it to the reactor
pressure vessel. Welding residual stresses result from the strongly non-uniform heating and
cooling during welding, in combination with temperature-dependent plasticity and creep of the
weld and base metal. They are a key input to integrity assessments of welded components.

This example computes the residual stresses in a multi-pass circumferential (girth) weld in a
pipe with a 40 mm thick wall. It is an internally developed pipe welding model and is not based
on external proprietary pressure vessel data. The simulation has two stages:

1. **Welding** (this page): 8 weld passes deposited one after another, t = 0 to 9625 s.
2. **[Cooldown](pipe_welding_cooldown.md)**: restart from the final welding state, release of the
   welding clamps and cooling to ambient temperature, t = 9625 to 720000 s.

The welding stage is a coupled transient heat conduction and quasi-static solid mechanics
analysis. The heat input of the welding torch is represented by a moving ellipsoidal heat source
that follows the torch path, and the deposition of weld metal by progressively activating the
elements of each weld pass as the torch passes over them.

## Computational Model Description

The model uses mm, s, MPa and K. The pipe axis is the $y$ axis; the inner and outer radii are
75 mm and 115 mm.

!media lwr/pipe_welding/fig1_geometry_and_mesh.png
      id=pipe_welding_mesh
      style=width:50%
      caption=Geometry and finite element mesh of the welded pipe section (cut-away view). The colored elements in the weld groove at mid-height are the weld-pass blocks; the gray elements are the base metal.

The mesh `vessel_40mm_coarse_v05.exo` has 16,640 hexahedral elements and 18,214 nodes in the
blocks `basemetal`, `weld_to_base` and `weldpass-1` to `weldpass-8`. Elements of a weld pass are
moved to the active block `weld_to_base` when they are deposited.

Each pass takes 1200 s and the first one starts after a 25 s delay. The heat input of pass $n$ is
scaled by a pass-dependent factor (1, 0.8, 0.66, 0.71, 0.64, 0.71, 0.58, 0.67), starting from a
base power of 500 with an efficiency of 0.8.

Files used by this stage include:

- the main MOOSE input file `weld.i`, which includes `common_config.i`, `weld_config.i`,
  `common_objects_R5_plas.i` and `weld_objects.i`
- the Exodus mesh file `vessel_40mm_coarse_v05.exo`
- the CSV file `path_txyz.csv`, which defines the torch path as piecewise-linear vertices (t, x, y, z)

!listing /lwr/pipe_welding/welding/weld.i

### Parameters

`common_config.i` and `weld_config.i` define the parameters used in the rest of the input with
the `${...}` syntax: thickness and file names, reference and melting temperatures, number and
duration of the passes, heat source size and power, and the time stepping. The `sync_times`
force a time step and output every 25 s and just after the start of each pass.

!listing /lwr/pipe_welding/welding/weld_config.i

### `Mesh`

The mesh is read from the Exodus file and the (initially empty) active weld block
`weld_to_base` is declared.

!listing /lwr/pipe_welding/welding/common_objects_R5_plas.i block=Mesh

### `Variables` and `AuxVariables`

The nonlinear variables are the temperature `T` and the displacements. The auxiliary
variables include the nodal reactions `rx`, `ry` and `rz` (saved during welding for the
[cooldown](pipe_welding_cooldown.md)), the circumferential angle `phi` and the activation
indicator `weld`.

!listing /lwr/pipe_welding/welding/common_objects_R5_plas.i block=Variables

!listing /lwr/pipe_welding/welding/common_objects_R5_plas.i block=AuxVariables

### `Physics/SolidMechanics/QuasiStatic`

Small-strain, incremental quasi-static mechanics on the active blocks with a thermal
eigenstrain. The nodal residuals of the displacements are saved in `rx`, `ry` and `rz`.

!listing /lwr/pipe_welding/welding/common_objects_R5_plas.i block=Physics/SolidMechanics/QuasiStatic

### `Kernels`

Transient heat conduction (`ADHeatConductionTimeDerivative`, `ADHeatConduction`) and the
volumetric heat of the welding torch (`ADMatHeatSource`).

!listing /lwr/pipe_welding/welding/common_objects_R5_plas.i block=Kernels

!listing /lwr/pipe_welding/welding/weld_objects.i block=Kernels

### `SpatioTemporalPaths` and heat source

The torch path is a piecewise-linear `SpatioTemporalPath` read from `path_txyz.csv`. The
`ADMovingEllipsoidalHeatSource` material evaluates the volumetric heat from the distances along
and normal to the current path segment. The semi-axes are 40 mm and 20 mm, and the
pass-dependent power fraction is the material `Pfraction`.

[pipe_welding_temperature] shows a typical temperature field during welding: the material under
the heat source in the weld groove is heated close to the melting temperature used in the model
(1700 K), and the heat spreads into the surrounding base metal.

!media lwr/pipe_welding/fig2_temp_during_welding.png
      id=pipe_welding_temperature
      style=width:50%
      caption=Temperature distribution during welding. The hottest region is located under the moving heat source in the weld groove.

!listing /lwr/pipe_welding/welding/weld_objects.i block=SpatioTemporalPaths

!listing /lwr/pipe_welding/welding/weld_objects.i block=Materials

### Weld deposition: `AuxKernels`, `MeshModifiers` and `UserObjects`

For each pass, a `ParsedAux` sets `weld = 1` in the elements whose circumferential angle `phi` has
been passed by the torch, which sweeps $2\pi$ during the 1200 s of the pass. The
`CoupledVarThresholdElementSubdomainModifier` moves these elements into the active block and
updates the moving boundary. The temperature and displacements of newly activated nodes are
initialized by first-order patch recovery from the neighboring active elements
(`NodalPatchRecoveryVariable` user objects, strategy `POLYNOMIAL_NEIGHBOR`).

!listing /lwr/pipe_welding/welding/weld_objects.i block=AuxKernels

!listing /lwr/pipe_welding/welding/weld_objects.i block=MeshModifiers

!listing /lwr/pipe_welding/welding/weld_objects.i block=UserObjects

### `BCs`

During welding the pipe is clamped at the top (`xyzfix_top_clamp`) and bottom
(`xzfix_bot_clamp`) nodesets, with a symmetry condition on `yfix_bot`. Heat is lost by radiation
and convection from the inner and outer surfaces and from the moving weld surface.

!listing /lwr/pipe_welding/welding/weld_objects.i block=BCs

### `Materials`

Temperature-dependent density, specific heat, thermal conductivity and Young's modulus
(`ADPiecewiseLinearInterpolationMaterial`), instantaneous thermal expansion, and an inelastic
response combining isotropic plasticity (yield stress 235 MPa with the hardening function
`isohard`) and power-law creep, combined by `ADComputeMultipleInelasticStress`.

!listing /lwr/pipe_welding/welding/common_objects_R5_plas.i block=Materials

### `Postprocessors`

Peak temperature, total heat input, and stresses, strains and temperatures at inner-surface
(`_id`), mid-wall (`_mid`) and outer-surface (`_od`) points. The displacements of the two bottom
nodes, `xzfix_bot_disp_x`, `xzfix_bot_disp_z` and `zfix_bot_disp_z`, are recorded as well; the
cooldown stage uses their final values as boundary conditions.

!listing /lwr/pipe_welding/welding/common_objects_R5_plas.i block=Postprocessors

!listing /lwr/pipe_welding/welding/weld_objects.i block=Postprocessors

### `Executioner`

Newton's method with a direct LU solver (SuperLU_DIST) and an iteration-adaptive time step
limited to 2.5 s.

!listing /lwr/pipe_welding/welding/common_objects_R5_plas.i block=Executioner

### `Outputs`

Exodus results (`40mm/out.e*`), CSV postprocessor history (`40mm/scl.csv`) and checkpoints
(`40mm/weld_cp`), all used by the cooldown stage.

!listing /lwr/pipe_welding/welding/common_objects_R5_plas.i block=Outputs

## Running the model

To run the welding stage, or the complete welding and cooldown pipeline, from `lwr/pipe_welding`:

```
MOOSE_EXEC=/path/to/app/grizzly-opt ./run_pipeline.sh welding   # welding only
MOOSE_EXEC=/path/to/app/grizzly-opt ./run_pipeline.sh            # welding, then cooldown
```

which runs `mpiexec -n 12 grizzly-opt -i weld.i` in `welding/`. On 12 processors (Intel Xeon Gold
6346) the 3857 time steps take about 14 hours. The following output files are produced in
`welding/40mm/`:

- Exodus results files: `out.e` and `out.e-s*` (a new file is started whenever the active mesh changes)
- the CSV postprocessor history `scl.csv`
- the checkpoint directory `weld_cp`, from which the cooldown restarts

!alert note title=Restart rank count
The cooldown must be run with the same number of processors as the welding stage, because it
restarts from the welding checkpoint. `run_pipeline.sh` takes care of this.

!alert warning title=Required BlackBear version
The model uses the piecewise-linear `SpatioTemporalPath` and the `spatiotemporal_path` parameter
of `ADMovingEllipsoidalHeatSource` introduced in BlackBear in November 2026 (BlackBear commit
25cd931). It was developed and tested with a standalone BlackBear executable that includes these
changes. Compatibility with the Grizzly version used by the VTB, which includes BlackBear as a
submodule, has not been verified yet.

Reference results of the full simulation are in `welding/gold/weld_full_scl.csv`.

## HPC Resources

| Resource | Value |
| :- | :- |
| Machine | Workstation (Intel Xeon Gold 6346, 32 cores) |
| Number of nodes | 1 |
| Number of processes | 12 |
| Number of threads per process | 1 |
| Run time | about 14 hours (3857 time steps) |
