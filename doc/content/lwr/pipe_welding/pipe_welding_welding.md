# Multi-Pass Pipe Welding Model: Stage 1, 3D Welding

*Contact: Bipul Barua, barau@anl.gov; Cheng-Hau Yang, chenghau.yang@anl.gov*

*Sponsor: U.S. Nuclear Regulatory Commission (NRC), Office of Nuclear Regulatory Research (RES)*

*Model developed by Bipul Barua (Argonne National Laboratory); VTB integration and validation by Cheng-Hau Yang (Argonne National Laboratory)*

*Model link: [Pipe Welding Model](https://github.com/idaholab/virtual_test_bed/tree/main/lwr/pipe_welding)*

## High Level Summary of Model

Welding introduces residual stresses that affect the integrity of pressure-retaining components
in light water reactors, such as the primary piping and the welds connecting it to the reactor
pressure vessel. Welding residual stresses result from the strongly non-uniform heating and
cooling during welding, in combination with temperature-dependent plasticity and creep of the
weld and base metal. They are a key input to integrity assessments of welded components.

### Model Background

The model is based on the eight-pass circumferential weld simulation of a Type 316H stainless
steel cylindrical vessel with a 40 mm thick wall described by [!citet](barua2024assessment). The
study adapted a sample problem from the R5 procedure and modeled progressive weld metal
deposition with a moving ellipsoidal heat source. The authors compared their predicted
through-thickness axial residual stress profiles with the experimental measurements and numerical
results reported in R5.

The VTB example provides an updated BlackBear implementation in two stages.

1. **Welding** (this page): 8 weld passes deposited one after another, t = 0 to 9625 s.
2. **[Cooldown](pipe_welding_cooldown.md)**: restart from the final welding state, release of the
   welding clamps and cooling to ambient temperature, t = 9625 to 720000 s.

The welding stage is a coupled transient heat conduction and quasi-static solid mechanics
analysis. The heat input of the welding torch is represented by a moving ellipsoidal heat source
that follows the torch path, and the deposition of weld metal by progressively activating the
elements of each weld pass as the torch passes over them.

## Computational Model Description

The model uses length in mm, time in s and temperature in K. The solid mechanics part uses force
in N and stress in MPa (N/mm$^2$); the heat transfer part uses energy in J, power in W and mass in
kg, so that density is in kg/mm$^3$, specific heat in J/(kg$\cdot$K), thermal conductivity in
W/(mm$\cdot$K) and heat fluxes in W/mm$^2$. The two parts are coupled only through the temperature
and the (dimensionless) thermal strain, so this combination is consistent. The pipe axis is the
$y$ axis; the inner and outer radii are 75 mm and 115 mm.

!media lwr/pipe_welding/fig1_geometry_and_mesh.png
      id=pipe_welding_mesh
      style=width:50%
      caption=Geometry and finite element mesh of the welded pipe section (cut-away view). The colored elements in the weld groove at mid-height are the weld-pass blocks; the gray elements are the base metal.

The mesh `vessel_40mm_coarse_v05.exo` has 16,640 hexahedral elements and 18,214 nodes in the
blocks `basemetal`, `weld_to_base` and `weldpass-1` to `weldpass-8`. Elements of a weld pass are
moved to the active block `weld_to_base` when they are deposited.

Each pass takes 1200 s and the first one starts after a 25 s delay. R5 gives no details of the
welding procedure, so the heat input was calibrated so that the peak temperature of each pass is
close to the melting point of 316H [!citep](barua2024assessment). The heat input of pass $n$ is
scaled by a pass-dependent factor (1, 0.8, 0.66, 0.71, 0.64, 0.71, 0.58, 0.67) of a calibrated
base value of 500 with an efficiency of 0.8. `ADMovingEllipsoidalHeatSource` evaluates the
volumetric heat (W/mm$^3$) as

!equation
q = \frac{2 \eta P}{\pi a b} \exp\left(-\frac{2 d_t^2}{a^2} - \frac{2 d_n^2}{b^2}\right),

where $\eta$ is the efficiency, $P$ the base value times the pass factor, $a$ and $b$ the
semi-axes (mm), and $d_t$ and $d_n$ the distances along and normal to the torch path. Because
$a$ and $b$ are in mm, $P$ acts as a heat input per unit length (W/mm), not as the torch power in
W. The `total_heat` postprocessor reports the volume integral of $q$ over the active blocks (base
metal and deposited weld metal), i.e. the instantaneous rate of heat applied to the model (W), not
the cumulative energy. The part of the heat source that lies in weld metal not yet deposited is
neither applied nor included in `total_heat`.

Files used by this stage include:

- the main MOOSE input file `weld.i`, which includes `common_config.i`, `weld_config.i`,
  `common_objects_R5_plas.i` and `weld_objects.i`
- the Exodus mesh file `vessel_40mm_coarse_v05.exo`
- the CSV file `path_txyz.csv`, which defines the torch path as piecewise-linear vertices (t, x, y, z)

!listing /lwr/pipe_welding/welding/weld.i

### Parameters

`common_config.i` and `weld_config.i` define the parameters used in the rest of the input with
the `${...}` syntax: thickness and file names, reference and melting temperatures, number and
duration of the passes, heat source size and power, and the time stepping. The time stepper is
forced to hit every `output_interval` = 25 s (a `TimeIntervalTimes` object) and the
`pass_sync_times`, computed from the pass parameters: one maximum time step before the first pass
starts and 0.1 s after the start of each later pass.

!listing /lwr/pipe_welding/welding/weld_config.i

### `Problem` and `GlobalParams`

`GlobalParams/block` sets the default computational domain to the active blocks
`basemetal` and `weld_to_base`. All block-restrictable objects use these blocks unless they set
`block` themselves, and the kernel and material coverage checks are limited to them, so the
not yet deposited weld-pass blocks are excluded without disabling the checks.

!listing /lwr/pipe_welding/welding/common_objects_R5_plas.i block=Problem GlobalParams

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
eigenstrain. The displacement residuals of the stress divergence kernels are accumulated in the
`reaction` vector tag, and `TagVectorAux` kernels (in `weld_objects.i`) copy them into `rx`, `ry`
and `rz` at the end of each time step. At the clamped nodes they are the reaction forces.

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
updates the moving boundary.

!listing /lwr/pipe_welding/welding/weld_objects.i block=AuxKernels

!listing /lwr/pipe_welding/welding/weld_objects.i block=MeshModifiers

### Element Activation and Nodal Patch Recovery

As weld elements are activated, the model uses `NodalPatchRecoveryVariable` to fit first-order
polynomials for temperature and displacement on neighboring active elements. The
`POLYNOMIAL_NEIGHBOR` strategy extrapolates those polynomials to initialize the newly activated
nodes. Section 4.1 of [!citet](yang2025improved) describes this approach to initializing
variables on the updated active domain.

!listing /lwr/pipe_welding/welding/weld_objects.i block=UserObjects

### `BCs`

During welding the pipe is clamped at the top (`xyzfix_top_clamp`) and bottom
(`xzfix_bot_clamp`) nodesets, with a symmetry condition on `yfix_bot`. Heat is lost by radiation
and convection from the inner and outer surfaces and from the moving weld surface.

!listing /lwr/pipe_welding/welding/weld_objects.i block=BCs

### `Materials`

Temperature-dependent thermal conductivity and Young's modulus and constant density and specific
heat (`ADPiecewiseLinearInterpolationMaterial`), and temperature-dependent instantaneous thermal
expansion. Following [!citet](barua2024assessment), the weld residual stresses mostly depend on
the room-temperature flow stress, so the plasticity model uses the room-temperature data of R5 at
all temperatures: linear isotropic hardening from an elastic limit of 235 MPa to 480 MPa at 1%
plastic strain (hardening function `isohard`), and perfect plasticity beyond. The total strain
during welding and cooldown is the sum of thermal, elastic and plastic strains only
[!citep](barua2024assessment). A power-law creep model (`neg_creep`) is kept in
`ADComputeMultipleInelasticStress`, but its coefficient is reduced from the 316H value
$1.82 \times 10^{-4}$ MPa$^{-n}$s$^{-1}$ to $1.82 \times 10^{-40}$ MPa$^{-n}$s$^{-1}$, so that the
creep strain is negligible.

!listing /lwr/pipe_welding/welding/common_objects_R5_plas.i block=Materials

### `Postprocessors`

Peak temperature, applied heat rate (`total_heat`, W), and stresses, strains and temperatures at
inner-surface (`_id`), mid-wall (`_mid`) and outer-surface (`_od`) points. The displacements of the two bottom
nodes, `xzfix_bot_disp_x`, `xzfix_bot_disp_z` and `zfix_bot_disp_z`, are recorded as well; the
cooldown stage uses their final values as boundary conditions.

!listing /lwr/pipe_welding/welding/common_objects_R5_plas.i block=Postprocessors

!listing /lwr/pipe_welding/welding/weld_objects.i block=Postprocessors

### `Executioner`

Newton's method with a direct LU solver (SuperLU_DIST) and an iteration-adaptive time step
limited to 2.5 s.

!listing /lwr/pipe_welding/welding/common_objects_R5_plas.i block=Executioner

### `Times` and `Outputs`

Exodus results (`40mm/out.e*`), CSV postprocessor history (`40mm/scl.csv`) and checkpoints
(`40mm/weld_cp`), all used by the cooldown stage. Exodus and CSV write every time step;
checkpoints are written every 25 time steps and at the `output_times`. The time stepper hits the
sync times of all outputs: `output_times` (Exodus and checkpoint) and `pass_sync_times` (CSV).

!listing /lwr/pipe_welding/welding/common_objects_R5_plas.i block=Times Outputs

## Running the model

To run the welding stage, or the complete welding and cooldown pipeline, from `lwr/pipe_welding`:

```
MOOSE_EXEC=/path/to/app/grizzly-opt ./run_pipeline.sh welding   # welding only
MOOSE_EXEC=/path/to/app/grizzly-opt ./run_pipeline.sh            # welding, then cooldown
```

which runs `mpiexec -n 12 grizzly-opt -i weld.i` in `welding/`. On 12 processors (Intel Xeon Gold
6346) the 3857 time steps take about 14 hours; set `NP` to change the number of processors (for
example `NP=20`, about 10 hours, see HPC Resources below). The following output files
are produced in `welding/40mm/`:

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
changes.

Reference results of the full simulation are in `welding/gold/weld_full_scl.csv`.

!alert note title=Total heat in the full-run reference
`welding/gold/weld_full_scl.csv` was produced by an earlier version of the inputs in which
`total_heat` also integrated the heat source over weld metal not yet deposited. Its `total_heat`
column therefore overestimates the applied heat rate (by about a factor of two at the start of the
first pass). The heat-source kernel was already restricted to the active blocks, so the heat
applied to the model and the other columns are not affected.

## HPC Resources

| Resource | Original run | Updated run |
| :- | :- | :- |
| Machine | Workstation (2 $\times$ Intel Xeon Gold 6346, 32 cores) | same |
| Number of nodes | 1 | 1 |
| Number of processes | 12 | 20 |
| Number of threads per process | 1 | 1 |
| Time steps | 3857 | 3857 |
| Nonlinear / linear iterations | 10,183 / 104,123 | 10,183 / 104,123 |
| Failed nonlinear solves | 0 | 0 |
| Run time | 51,306 s (about 14 hours) | 36,397 s (about 10 hours) |
| Peak memory per process | not recorded | about 1.0 GB |

The original run produced the reference results `welding/gold/weld_full_scl.csv`. The updated run
uses inputs that differ from the original ones in the block restriction of the auxiliary objects and
the `total_heat` postprocessor and in how the clamp reactions are stored (a reaction vector tag
instead of `save_in`); it still used the explicit list of sync times, which the current
`output_times` and `pass_sync_times` reproduce exactly. These changes are not expected to change the
solution: the two runs take the same time steps, and all postprocessors except `total_heat` agree to
within $10^{-9}$ relative (temperature, displacement, stress and plastic strain fields at the end of
welding to within $10^{-10}$). The pass-averaged `total_heat` is 53 to 92% of the reference value
(see the note above). The runs were made on a shared workstation, so the run times are a reference
performance comparison, not a controlled MPI scaling study.

!bibtex bibliography
