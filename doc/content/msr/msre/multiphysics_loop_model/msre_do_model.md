# Molten Salt Reactor Experiment (MSRE) Multiphysics Primary Loop Model

*Contact: Travis Mui, tmui\@anl.gov; Ramiro Freile, ramiro.freile\@inl.gov*

*Model link: [MSRE Domain Overlapping Model](https://github.com/idaholab/virtual_test_bed/tree/devel/msr/msre/multiphysics_loop_model)*

## Overview

This model extends two previously documented MSRE models available in the Virtual Test Bed into a fully
integrated multi-scale multiphysics simulation of the MSRE primary circuit:

- The [Griffin-Pronghorn core model](multiphysics_rz_model/index.md) [!citep](mau23,Javi23),
  which couples Griffin neutronics and Pronghorn multi-dimensional thermal hydraulics on a 2D RZ
  axisymmetric core mesh.
- The [SAM system model](msre_sam_model.md) [!citep](vtb2023), which models the full MSRE
  primary loop as a one-dimensional network of components.

This model incorporates both into a single coupled framework with two key additions:

- +Saline+ — the MSD-TP thermophysical properties database, replacing simplified constant or
  linear salt properties with temperature-dependent functions derived from first-principles and
  machine-learning methods.
- The +Domain Overlapping (DO)+ coupling method [!citep](schunert2023,do_manual,osti_2998579) —
  a multi-scale coupling strategy that overlaps the SAM 1D loop with the Pronghorn multi-dimensional
  core domain, enforcing consistent pressure, mass flow, enthalpy, and delayed neutron precursor (DNP)
  distributions across both codes.

The four-code coupling strategy within the BlueCrab code suite is:

- +Pronghorn+ — 2D axisymmetric, weakly-compressible porous-medium thermal hydraulics of the core region (main application)
- +Griffin+ — multigroup neutron diffusion eigenvalue solve (sub-application)
- +SAM+ — one-dimensional system thermal hydraulics of the full primary loop (sub-application via DO coupling)
- +Saline+ — temperature-dependent thermophysical properties for the fuel salt via the MSD-TP database

Pronghorn (`ph_start.i`) is the main application. SAM (`msre_sam_do.i`) is coupled to Pronghorn
via the `[OverlappingDomainCoupling]` action. Griffin (`griffin_EV.i`) is a `FullSolveMultiApp`
sub-application called by Pronghorn at each time step, returning the normalized power source and
$k_{eff}$ and receiving temperature and DNP fields.

!media msr/msre/multiphysics_loop_model/coupling.png
       style=width:60%;margin-left:auto;margin-right:auto
       id=MSRE_coupling_scheme
       caption=Coupling scheme: Pronghorn is the main application; SAM is coupled via the OverlappingDomainCoupling block, and Griffin is a FullSolveMultiApp sub-application.

A general description of the MSRE facility and its key parameters is available in the
[MSRE description page](msre_description.md).

## Fuel Salt Thermophysical Properties via Saline

[Saline](https://mooseframework.inl.gov/source/fluidproperties/SalineMoltenSaltFluidProperties.html)
serves as the interface between the MSD-TP thermophysical properties
database and both the SAM and Pronghorn solvers [!citep](agca2021fy21) and is included
in Moose as a submodule of the [Fluid Properties Module](https://mooseframework.inl.gov/modules/fluid_properties/index.html)
It provides lookup-table-based conversions between enthalpy and temperature for arbitrary
temperature-dependent specific heat functions.
Both codes load properties from `saline_data.csv`, querying the composition
LiF-BeF$_2$-ZrF$_4$-UF$_4$ (mole fractions 0.6479, 0.2996, 0.0499, 0.0026) via
`SalineMoltenSaltFluidProperties`.

The temperature-dependent fuel salt properties are listed in [salt_tps].
The specific heat exhibits a local minimum within the MSRE operating temperature range,
derived using the CALPHAD method in Thermochimica; a linear approximation would introduce
significant errors in the enthalpy balance.
The viscosity was obtained from the Molten Salt PropNet machine-learning framework [!citep](saltpropnet).

!table id=salt_tps caption=MSRE fuel salt (LiF-BeF$_2$-ZrF$_4$-UF$_4$) thermophysical properties; temperature $T$ in Kelvin.
| Property             | Units      | Expression                                                                      |
| :------------------- | :--------- | :------------------------------------------------------------------------------ |
| Molecular weight     | g/mol      | 40.05                                                                           |
| Density              | kg/m$^3$   | $2710 - 0.562\,T$                                                               |
| Viscosity            | Pa·s       | $1.24 \times 10^{-4} \exp\!\left(3.13 \times 10^{4} / (R\,T)\right)$            |
| Specific heat        | J/(kg·mol) | $57.84 + 0.0259\,T + 4.7441 \times 10^{6}\,T^{-2} - 7.51 \times 10^{-6}\,T^{2}$ |
| Thermal conductivity | W/(m·K)    | 1.22                                                                            |

[MSRE_ss_cp] illustrates the heat capacity function and its spatial distribution in the core
at 10 MW steady state, highlighting the non-monotonic behavior within the operating range.

!media msr/msre/multiphysics_loop_model/cp_.png
       style=width:65%;margin-left:auto;margin-right:auto
       id=MSRE_ss_cp
       caption=MSRE fuel salt heat capacity as a function of temperature and its distribution in the reactor core at 10 MW steady state.

## Domain Overlapping Coupling Approach

The Domain Overlapping (DO) coupling method [!citep](schunert2023,do_manual) overlaps the
Pronghorn multi-dimensional core domain with a portion of the SAM one-dimensional primary loop.
In this framework, SAM provides Pronghorn with boundary conditions that depend on the system-level
simulation of the entire plant. In return, the overlapping SAM components — termed "surrogate
components" — receive friction factors and volumetric source terms computed dynamically from the
Pronghorn solution. This yields consistent pressure drops, flow splits, enthalpies, and passive
scalar (DNP) concentrations between the two codes.

[MSRE_simple_pipe] illustrates a simplified example of a coupled SAM-Pronghorn model for a pipe
geometry. Two coupling interfaces (Interface #1 and Interface #2) define the boundaries of the DO
region and connect to corresponding surrogate SAM components. These surrogates are joined through a
single SAM branch. On the Pronghorn side, a *reference plane* is positioned to align with the SAM
branch, establishing a one-to-one correspondence: the region between Interface #1 and the reference
plane maps to Surrogate #1, and the region between Interface #2 and the reference plane maps to
Surrogate #2. Correct placement of the reference plane relative to the SAM branch is critical in
buoyancy-driven systems, as misalignment causes errors in the buoyancy head retrieved by the
surrogate components.

!media msr/msre/multiphysics_loop_model/simple_pipe_schematics.png
       style=width:75%;margin-left:auto;margin-right:auto
       id=MSRE_simple_pipe
       caption=Schematics of a coupled SAM-Pronghorn model for a simple pipe setup, showing the two coupling interfaces, surrogate components, branch, and reference plane [!citep](do_manual).

The coupling between SAM and Pronghorn is realized through a fixed-point (Picard) iteration
strategy applied at each time step, as illustrated in [MSRE_execution_do].
For momentum coupling, friction factors are computed by Pronghorn and applied to the SAM surrogate
components to reproduce the multi-dimensional pressure drop; since these friction factors depend on
the flow rates supplied by SAM, Picard iterations are required to achieve convergence.
For energy coupling, the temperature boundary conditions sent to Pronghorn depend on the SAM thermal
response, which is itself influenced by the coupled enthalpy source; the scheme iterates the
temperature BC using the enthalpy-variation formulation, including a thermal inertia term that
provides physically consistent and numerically stable heat transport.
For scalar (DNP) coupling, inlet concentration boundary conditions for Pronghorn depend on the SAM
concentration field, which is influenced by the Pronghorn scalar source; an unsteady term is
incorporated to stabilize the iteration, replacing the earlier Newton-based approach.

!media msr/msre/multiphysics_loop_model/execution_do.png
       style=width:75%;margin-left:auto;margin-right:auto
       id=MSRE_execution_do
       caption=Execution scheme for the SAM-Pronghorn domain overlapping coupling of momentum, energy, and scalar concentration fields via Picard iterations [!citep](do_manual).

### Application to the MSRE

Two SAM surrogate components overlap the Pronghorn core domain:

| Surrogate      | Physical region                            | Pronghorn boundary |
| :------------- | :----------------------------------------- | :----------------- |
| `downcomer`    | Annular downcomer                          | `ph_inlet`         |
| `core_plenums` | Lower plenum + core + upper plenum + riser | `ph_outlet`        |

The branch connecting the two surrogates (`j_ip_c`) is co-located with the Pronghorn reference
plane. The DO coupling is configured via the `[OverlappingDomainCoupling]` block in `ph_start.i`,
which specifies the component names, boundaries, reference plane postprocessors, and passive scalar
parameters for all six DNP groups.

The full coupled model geometry — Pronghorn-Griffin 2D RZ core (a), SAM 1D primary loop (b), and
the combined domain-overlapped model (c) — is shown in [MSRE_phgeo], [MSRE_samgeo], and
[MSRE_do_model] respectively.

!media msr/msre/multiphysics_loop_model/MSRE_phgeo.png
       style=width:35%;margin-left:auto;margin-right:auto
       id=MSRE_phgeo
       caption=(a) Pronghorn-Griffin 2D axisymmetric model of the MSRE core region.

!media msr/msre/multiphysics_loop_model/MSRE_samgeo.png
       style=width:55%;margin-left:auto;margin-right:auto
       id=MSRE_samgeo
       caption=(b) SAM one-dimensional model of the MSRE primary circulation loop.

!media msr/msre/multiphysics_loop_model/MSRE_geo.png
       style=width:65%;margin-left:auto;margin-right:auto
       id=MSRE_do_model
       caption=(c) Combined MSRE domain overlapping model.

The coupling scheme — Pronghorn as main application, SAM coupled via `OverlappingDomainCoupling`,
and Griffin as a `FullSolveMultiApp` — is illustrated in [MSRE_coupling_scheme].

## Mesh Generation

The 2D RZ mesh used by both Pronghorn and Griffin is generated from scratch before the
coupled simulation. The mesh is defined in `mesh/mesh.i` and captures the core, bypass, core
barrel, lower plenum, upper plenum, downcomer, and riser regions of the MSRE reactor vessel.

```language=bash
cd msr/msre/multiphysics_loop_model
blue_crab-opt -i mesh/mesh.i --mesh-only
```

This produces `mesh/mesh_in.e`, which is read by both `ph_start.i` and `griffin_EV.i`.

!alert note
If you have a mesh figure to contribute, please place it at
`doc/content/media/msr/msre/multiphysics_loop_model/mesh.png` and add a `!media` directive here.

## Model Structure and Input Files

### Pronghorn Core Model (`ph_start.i`)

Pronghorn represents the MSRE core region as a 2D axisymmetric porous-medium domain [!citep](pfahl2025comparison).
The domain uses the following mesh blocks:

| Block          | Description                                           | Porosity |
| :------------- | :---------------------------------------------------- | :------- |
| `core`         | Graphite-moderated core (homogenized salt + graphite) | 0.222    |
| `core2`        | Core bypass (pure salt region)                        | 1.0      |
| `core_barrel`  | Steel core barrel (solid)                             | —        |
| `lower_plenum` | Lower plenum                                          | 1.0      |
| `upper_plenum` | Upper plenum                                          | 1.0      |
| `down_comer`   | Annular downcomer                                     | 1.0      |
| `riser`        | Riser                                                 | 1.0      |

Conjugate heat transfer between the core barrel and adjacent salt is modeled via
`FVConvectionCorrelationInterface`. An anisotropic friction multiplier (radial: 100000×,
axial: 200×) from `FunctorChurchillDragCoefficients` enforces predominantly axial flow
in the core, consistent with the MSRE's graphite-channel geometry.
A zero-equation mixing-length turbulence model (`MixingLengthTurbulentViscosityFunctorMaterial`)
is applied throughout all fluid regions.

#### Physics Block

The thermal-hydraulic equations are solved using the `[Physics][NavierStokes]` action system,
which replaces the deprecated `[Modules][NavierStokesFV]` syntax:

!listing msr/msre/multiphysics_loop_model/ph_start.i block=Physics

This sets up weakly-compressible porous-medium flow with upwind advection, mass-flux inlet
conditions, fixed-pressure outlet (supplied by SAM via `p_out`), and mixing-length turbulence.
Fluid properties are provided via `GeneralFunctorFluidProps` and `INSFVEnthalpyFunctorMaterial`
using the Saline salt object.

The governing equations for weakly-compressible porous-medium flow are:

\begin{equation}
\frac{\partial \gamma \rho}{\partial t} + \nabla \cdot (\rho \vec{v}) = 0 \quad \text{on } \Omega_f,
\label{eq:mass}
\end{equation}

\begin{equation}
\frac{\partial \rho \vec{v}}{\partial t} + \nabla \cdot \!\left(\gamma^{-1} \rho \vec{v} \otimes \vec{v}\right) = -\gamma \nabla p + \gamma \rho \vec{g} - W \rho \vec{v}_I + \nabla \cdot \!\left[(\mu + \rho \nu_t)(\nabla \vec{v} + \nabla \vec{v}^T)\right] \quad \text{on } \Omega_f,
\label{eq:momentum}
\end{equation}

\begin{equation}
\frac{\partial \gamma \rho h}{\partial t} + \nabla \cdot (\rho H \vec{v}) = \nabla \cdot (\kappa_f \nabla T_f) + \dot{q}_l''' \quad \text{on } \Omega_f,
\label{eq:enthalpy}
\end{equation}

\begin{equation}
(1 - \gamma)\rho_s c_{p,s} \frac{\partial T_s}{\partial t} = \nabla \cdot (\kappa_s \nabla T_s) + \alpha(T_f - T_s) \quad \text{on } \Omega_s,
\label{eq:solid_energy}
\end{equation}

where $\vec{v}$ is the superficial velocity, $h$ is the specific enthalpy, $H$ is the total
enthalpy, $T_f$ and $T_s$ are fluid and solid temperatures, $\nu_t$ is the turbulent kinematic
viscosity, $W$ is the porous-medium drag coefficient, $\kappa_f$ and $\kappa_s$ are the effective
thermal conductivities, $\alpha$ is the volumetric fluid-solid heat transfer coefficient, and
$\dot{q}_l'''$ is the volumetric heat source from Griffin.

#### DNP Transport

Six groups of delayed neutron precursors are transported as `MooseVariableFVReal` variables
with explicit kernels in `[FVKernels]`:

\begin{equation}
\frac{\partial c_i}{\partial t} + \nabla \cdot \!\left(\frac{\vec{v}}{\gamma}\, c_i\right) = \beta_i \dot{q}_f''' - \lambda_i c_i, \quad i = 1, \ldots, 6,
\label{eq:dnp}
\end{equation}

where $c_i$ is the precursor concentration, $\lambda_i$ its decay constant, and $\beta_i$ the
delayed neutron fraction for group $i$.
Advection uses `PINSFVMassAdvection` with a porosity-corrected density functor
(`c_i_porous = c_i / porosity`) defined via `ADParsedFunctorMaterial`, ensuring correct
interstitial transport across porous-medium interfaces.

!listing msr/msre/multiphysics_loop_model/ph_start.i block=FVKernels

#### Domain Overlapping Configuration

!listing msr/msre/multiphysics_loop_model/ph_start.i block=OverlappingDomainCoupling

#### MultiApps and Transfers

Griffin is called as a sub-application at the end of each Pronghorn time step.
Pronghorn sends DNP concentrations ($c_1$–$c_6$), fluid temperature ($T_\text{fluid}$), and
solid temperature ($T_\text{solid}$) to Griffin, and receives the normalized fission source,
power density, and $k_{eff}$ in return:

!listing msr/msre/multiphysics_loop_model/ph_start.i block=MultiApps

!listing msr/msre/multiphysics_loop_model/ph_start.i block=Transfers

#### Executioner

The Pronghorn solve runs as a pseudo-transient from $t = -2000$ s to $t = -1000$ s using a
`FunctionDT` time stepper, with Picard iterations (up to 50) converging the DO coupling error
at each step via `custom_pp = overlapping_coupling_error`.

!listing msr/msre/multiphysics_loop_model/ph_start.i block=Executioner

### Griffin Neutronics Model (`griffin_EV.i`)


Griffin solves the steady-state 16-group neutron diffusion eigenvalue equation [!citep](javi)
with cross sections from `xs_msre_micro.xml`, tabulated as a function of fuel salt temperature
(`T_salt`) to capture Doppler and density feedback.
A reflecting boundary condition is applied at the symmetry axis; vacuum conditions at all outer
surfaces. Atom number densities for each nuclide are updated at every time step via `ParsedAux`
kernels applying a linear density correction relative to the reference temperature.

!listing msr/msre/multiphysics_loop_model/griffin_EV.i block=TransportSystems

!listing msr/msre/multiphysics_loop_model/griffin_EV.i block=PowerDensity

!listing msr/msre/multiphysics_loop_model/griffin_EV.i block=Executioner

### SAM Primary Loop Model (`msre_sam_do.i`)

SAM models the complete MSRE primary circuit as a 1D network: downcomer, core/plena, connecting
pipes, centrifugal pump, and shell-and-tube heat exchanger.
The six DNP groups are transported as passive scalars throughout the loop with radioactive decay.
Fluid properties use `SalineMoltenSaltFluidProperties` via `saline_data.csv`.

!listing msr/msre/multiphysics_loop_model/msre_sam_do.i block=GlobalParams

!listing msr/msre/multiphysics_loop_model/msre_sam_do.i block=MaterialProperties

## Running the Model

The main application is `ph_start.i`; SAM and Griffin sub-applications launch automatically.

```language=bash
mpiexec -n 32 blue_crab-opt -i ph_start.i
```

On INL HPC:

```language=bash
module load use.moose moose-apps bluecrab
mpiexec -n 32 blue_crab-opt -i ph_start.i
```

!bibtex bibliography
