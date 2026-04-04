# MSRE Multiphysics Xenon Poisoning Model

*Contact: Jun Fang, fangj.at.anl.gov*

*Model link: [MSRE Xe Poisoning Model](https://github.com/hapfang/virtual_test_bed/tree/xe/msr/msre/xe_poisoning)*

!tag name=Molten Salt Reactor Experiment SAM Model
     description=Steady state and reactivity insertion accident models of the MSRE primary loop
     image=https://github.com/hapfang/virtual_test_bed/blob/xe/doc/content/media/msr/msre/xe_poisoning/ss_results.png
     pairs=reactor_type:MSR
                       reactor:MSRE
                       geometry:primary_loop
                       codes_used:BlueCrab;Griffin;Pronghorn
                       transient:steady_state;RIA
                       V_and_V:validation
                       input_features:checkpoint_restart
                       computing_needs:Workstation
                       fiscal_year:2024
                       sponsor:NEAMS
                       institution:ANL;INL

## Summary

In addition to the previously reported Xe poisoning study using the coupled SAM-Griffin model, this page documents a parallel effort that extends the existing MSRE multiphysics Griffin-Pronghorn framework by incorporating Xe poisoning physics. The objective is to integrate fission-product transport and reactivity feedback effects into the established loop-scale multiphysics model so reactor dynamics reflect both thermal-hydraulic and neutronic responses to $^{135}Xe$ and $^{135}I$ behavior in circulating fuel salt.

## Model Description

The model utilizes a 2-D axisymmetric configuration representing the full MSRE primary loop. Compared with the SAM-Griffin configuration, this Griffin-Pronghorn model resolves the complete loop in a computationally efficient 2-D form while preserving the dominant system-level transport and feedback behavior. For foundational details on the base mesh and geometry, refer to the [MSRE Multiphysics Core Model](https://mooseframework.inl.gov/virtual_test_bed/msr/msre/multiphysics_rz_model/msre_multiphysics_core_model.html).

## Computational Model Description

### Geometry and Mesh

The computational domain includes the core, lower plenum, upper plenum, downcomer, riser, pump bowl, and return-line regions of the MSRE primary loop. As shown in [msre_2d], the 2-D loop-wide representation provides improved geometric fidelity relative to reduced-order configurations while remaining computationally tractable for tightly coupled multiphysics analysis. The core region is modeled using a porous-medium approach with a porosity of 22.28%, representing the fuel-salt volume fraction in the homogenized fuel-graphite region.

!media msr/msre/xe_poisoning/msre_model.png
       style=width:20%
       id=msre_2d
       caption=2-D axisymmetric model components for the MSRE multiphysics model.

### Physics and Coupling Strategy

To model Xe poisoning in the existing Griffin-Pronghorn MSRE framework, the +MOOSE MultiApps+ hierarchy is configured with +Pronghorn+ as the master application and +Griffin+ as the sub-application. This mirrors the SAM-Griffin coupling philosophy: the thermal-hydraulics application drives simulation flow and data exchange, while Griffin performs neutronics calculations for reactivity and power updates. At a high level, the coupling workflow is:

- +Thermal Hydraulics (Pronghorn):+ Solves weakly compressible porous-media conservation equations for mass, momentum, and energy to obtain temperature, pressure, and flow fields.
- +Neutronics (Griffin):+ Solves a multigroup diffusion eigenvalue problem to obtain neutron flux and power distribution.
- +Species Transport (Pronghorn):+ Evolves $^{135}Xe$ and $^{135}I$ concentrations in the circulating fuel salt, including production, decay, and transport effects.
- +Gas Removal Representation:+ Includes a pump-bowl treatment to represent stripping/removal of gaseous fission products such as $^{135}Xe$ during circulation.
- +Coupling/Feedback:+ Power and temperature fields are exchanged between applications, and local xenon concentration updates absorption for neutronics.

### Governing Equations and Closure Models

#### Species Transport (Pronghorn)

The transport of $^{135}Xe$ and $^{135}I$ is modeled as advection-diffusion-reaction of scalar concentrations in the fuel salt:

\begin{equation}
\frac{\partial \epsilon C_i}{\partial t} +
\nabla \cdot (\vec{u} C_i) -
\nabla \cdot \left( \epsilon \left( D_{m,i} + \frac{\nu_t}{Sc_t} \right) \nabla C_i \right) = S_i - \lambda_i \epsilon C_i
\end{equation}

where $\epsilon$ is porosity (salt volume fraction), $\vec{u}$ is superficial velocity, $D_{m,i}$ is molecular diffusion coefficient, $\nu_t$ is turbulent eddy viscosity, $Sc_t$ is turbulent Schmidt number, $S_i$ is source term, and $\lambda_i$ is decay constant.

For the xenon-iodine chain, the source terms are:

- For $^{135}I$: $S_I = \gamma_I \Sigma_f \phi$
- For $^{135}Xe$: $S_{Xe} = \gamma_{Xe} \Sigma_f \phi + \lambda_I C_I$

#### Thermal Hydraulics (Pronghorn)

Pronghorn uses a weakly compressible porous-media formulation. Momentum conservation follows Darcy-Forchheimer behavior:

\begin{equation}
\frac{\rho}{\epsilon} \left( \frac{\partial \vec{u}}{\partial t} + \frac{(\vec{u} \cdot \nabla) \vec{u}}{\epsilon} \right) = -\nabla P + \rho \vec{g} - \left( \frac{\mu}{K} + \frac{\rho C_d}{\sqrt{K}} |\vec{u}| \right) \vec{u}
\end{equation}

#### Neutronics (Griffin)

The neutron flux is computed with a 16-group diffusion approximation:

\begin{equation}
-\nabla \cdot D_g \nabla \phi_g + \Sigma_{r,g} \phi_g - \sum_{g' \neq g} \Sigma_{s,g' \to g} \phi_{g'} = \frac{\chi_g}{k_{eff}} \sum_{g'} \nu \Sigma_{f,g'} \phi_{g'}
\end{equation}

#### Reactivity Feedback and Xenon Poisoning

Coupling between physics is achieved through cross-section updates. The macroscopic absorption cross section in Griffin is updated with local xenon concentration from Pronghorn:

\begin{equation}
\Sigma_{a,g}(\vec{r}) = \Sigma_{a,g}^{base}(\vec{r}, T) + \sigma_{a,g}^{Xe135} C_{Xe135}(\vec{r})
\end{equation}

where $\sigma_{a,g}^{Xe135}$ is the microscopic absorption cross section for $^{135}Xe$ in energy group $g$. This local feedback captures net reactivity loss and the spatial xenon burnout effect in high-flux regions.

#### Key Model Parameters

Key parameters used in the governing equations include:

- $\epsilon$: Porosity (fuel-salt volume fraction in porous regions).
- $C_i$: Species concentration for isotope $i$ (e.g., $^{135}I$, $^{135}Xe$).
- $\vec{u}$: Superficial velocity vector in the porous medium.
- $D_{m,i}$: Molecular diffusion coefficient for species $i$.
- $\nu_t$: Turbulent eddy viscosity.
- $Sc_t$: Turbulent Schmidt number.
- $S_i$: Net source term for species $i$ (fission yield and/or parent decay contribution).
- $\lambda_i$: Radioactive decay constant for species $i$.
- $\rho$: Fluid density.
- $\mu$: Dynamic viscosity.
- $K$: Permeability of the porous region.
- $C_d$: Forchheimer drag coefficient.
- $D_g$: Diffusion coefficient for neutron energy group $g$.
- $\phi_g$: Neutron flux in group $g$.
- $\Sigma_{r,g}$: Removal macroscopic cross section in group $g$.
- $\Sigma_{s,g' \to g}$: Scattering macroscopic cross section from group $g'$ to group $g$.
- $\nu \Sigma_{f,g}$: Production macroscopic cross section in group $g$.
- $\chi_g$: Fission spectrum fraction in group $g$.
- $k_{eff}$: Effective neutron multiplication factor.
- $\Sigma_{a,g}^{base}$: Baseline macroscopic absorption cross section in group $g$ (temperature dependent).
- $\sigma_{a,g}^{Xe135}$: Microscopic absorption cross section of $^{135}Xe$ in group $g$.
- $C_{Xe135}$: Local concentration of $^{135}Xe$ used for reactivity feedback.

## Input Descriptions

There are two primary input files in this coupled Xe-poisoning model:

- Pronghorn thermal-hydraulics/species master input: `msr/msre/xe_poisoning/th_xe.i`
- Griffin neutronics sub-application input: `msr/msre/xe_poisoning/neu_xe.i`

### Pronghorn Input File (`th_xe.i`)

The Pronghorn input file acts as the **Master Application**. It is responsible for solving fluid flow, heat transfer, and the transport of physical species (iodine and xenon) throughout the primary loop.

#### Mesh

The simulation uses a 2-D axisymmetric (RZ) coordinate system.

- **Geometry:** The mesh represents the full primary loop, including the core, plenums, and piping regions.
- **Initialization:** `FileMeshGenerator` loads a pre-existing mesh and restart-ready state. In practice, using Exodus restart settings (e.g., `use_for_exodus_restart = true`) allows the xenon study to start from a previously converged flow field.

!listing msr/msre/xe_poisoning/th_xe.i block=Mesh language=cpp

#### Variables

This block defines the finite-volume primary variables for the coupled thermal-hydraulic and species problem:

- **Flow & energy:** Superficial velocity components ($u_x$, $u_y$), pressure ($P$), fluid temperature ($T_{fluid}$), and solid temperature ($T_{solid}$).
- **Delayed neutron precursors (DNP):** Six groups (`c1` through `c6`) that drift with circulating salt.
- **Fission-product species:** `I135` and `Xe135` as transport scalars for poisoning-chain dynamics.

!listing msr/msre/xe_poisoning/th_xe.i block=Variables language=cpp

#### Modules / NavierStokesFV

`NavierStokesFV` streamlines porous-media thermal-hydraulic setup:

- **Physics:** Weakly compressible porous-media formulation with Darcy-Forchheimer resistance to represent pressure loss in core and piping.
- **Coupling:** `external_heat_source = 'power_density'` links TH energy deposition to Griffin-computed neutronics power.
- **Numerics:** Upwind advection interpolation supports robust transport in high-velocity loop regions.

!listing msr/msre/xe_poisoning/th_xe.i block=Modules language=cpp

#### FVBCs

Boundary conditions for species transport primarily enforce symmetry:

- Symmetry scalar BCs on centerline/top boundaries for `I135` and `Xe135` preserve the 2-D axisymmetric assumption and prevent non-physical cross-axis species flux.

!listing msr/msre/xe_poisoning/th_xe.i block=FVBCs language=cpp

#### FVKernels

This section contains the governing transport/source terms:

- **Transport terms:** Advection and turbulent-diffusion kernels for isotopes and DNP circulation.
- **Reaction/source terms:**
  - `I135` production from fission and depletion by decay.
  - `Xe135` production from direct fission and I-135 decay growth, plus depletion pathways.
- **Stripping model:** A dedicated kernel (e.g., pump-bowl stripping treatment) represents physical xenon removal from circulating salt.

!listing msr/msre/xe_poisoning/th_xe.i block=FVKernels language=cpp

#### FVInterfaceKernels

Conjugate heat transfer (CHT) across fluid/structure interfaces is handled here:

- Interface kernels (e.g., convection-correlation based) compute local heat transfer between fuel salt and structures such as the core barrel, ensuring realistic thermal coupling.

!listing msr/msre/xe_poisoning/th_xe.i block=FVInterfaceKernels language=cpp

#### Materials

Material models provide local properties and closures:

- **Porosity:** Core porosity set to 22.28% to represent effective salt-channel volume fraction.
- **Fluid properties:** Temperature-dependent (and pressure-dependent when needed) density, viscosity, and thermal conductivity.
- **Xenon mass transfer:** Parsed/functor-based closures can be used for stripping coefficients (often tied to Reynolds/Schmidt correlations).

!listing msr/msre/xe_poisoning/th_xe.i block=Materials language=cpp

#### MultiApps

This block defines multiphysics execution hierarchy:

- Griffin (`neu_xe.i`) is launched as a sub-application and typically executed at the end of each Pronghorn timestep/Picard update.

!listing msr/msre/xe_poisoning/th_xe.i block=MultiApps language=cpp

#### Transfers

Transfers implement two-way coupling data exchange:

- **To Griffin:** Pronghorn sends thermal state (e.g., `T_salt`), flow-related fields, DNP groups, and `Xe135` concentration.
- **From Griffin:** Pronghorn receives `power_density` and `fission_source` to update heat deposition and isotope source terms.

!listing msr/msre/xe_poisoning/th_xe.i block=Transfers language=cpp

### Griffin Input File (`neu_xe.i`)

The Griffin input file is the **Sub-Application**. It solves neutronics to determine flux, power generation, and xenon-driven reactivity effects.

#### TransportSystems

Griffin uses a 16-group CFEM-diffusion transport system:

- **Eigenvalue solve:** Computes $k_{eff}$ and flux distribution.
- **DNP linkage:** External DNP settings allow Griffin to consume precursor information transferred from Pronghorn instead of solving an independent precursor transport problem.

!listing msr/msre/xe_poisoning/neu_xe.i block=TransportSystems language=cpp

#### Mesh

The neutronics solve uses an RZ mesh loaded via `FileMeshGenerator`, consistent with loop geometry used by the master app.

!listing msr/msre/xe_poisoning/neu_xe.i block=Mesh language=cpp

#### AuxVariables

Aux variables store transferred and derived feedback fields (e.g., salt temperature, velocity components, isotope-density-related auxiliaries).

!listing msr/msre/xe_poisoning/neu_xe.i block=AuxVariables language=cpp

#### AuxKernels

Aux kernels process coupled state updates:

- Build array representations for precursor groups (`c1`-`c6`) when needed by transport systems.
- Use parsed expressions to update atomic densities (e.g., `ad_Xe135`, fuel/isotope densities) as local TH conditions evolve.

!listing msr/msre/xe_poisoning/neu_xe.i block=AuxKernels language=cpp

#### UserObjects

User objects support restart and solution persistence:

- Solution vectors (transport and auxiliary state) are written for restartability and postprocessing continuity.

!listing msr/msre/xe_poisoning/neu_xe.i block=UserObjects language=cpp

#### PowerDensity

This block converts fission rate into volumetric power density ($W/m^3$):

- Power is normalized to the operating reactor level (5.0 MW) so the returned thermal source is physically consistent for Pronghorn energy equations.

!listing msr/msre/xe_poisoning/neu_xe.i block=PowerDensity language=cpp

#### Materials

`CoupledFeedbackNeutronicsMaterial` is the core poisoning-feedback mechanism:

- **Cross-section feedback:** Microscopic cross-sections are interpolated versus local fuel temperature (`T_{salt}`).
- **Xenon integration:** Including `XE135` in isotope feedback and linking to `ad_Xe135` adds explicit xenon absorption penalties in the eigenvalue calculation.
- **Reactivity impact:** This coupling pathway enables prediction of xenon-induced reactivity loss (e.g., the ~-410 pcm level reported in results).

!listing msr/msre/xe_poisoning/neu_xe.i block=Materials language=cpp

## Results

The current Pronghorn-Griffin configuration represents an initial implementation of Xe-poisoning physics in a 2-D MSRE multiphysics framework. At this stage, results are limited to steady-state behavior; transient cases and additional Xe interactions with graphite and circulating bubbles are reserved for future studies.

The coupled model was run on Idaho National Laboratory's Sawtooth cluster using the NEAMS BlueCRAB suite for a total simulated time of 400,000 s (about 111 h).

### Steady-State Xenon Convergence

The core-averaged $^{135}Xe$ concentration increases monotonically and asymptotically approaches a steady value, with practical convergence reached at approximately 80 h.

!media msr/msre/xe_poisoning/xe_feedback.png
       style=width:45%
       id=xe_feedback
       caption=Development of core-averaged $^{135}Xe$ concentration during the steady-state coupled simulation.

The converged average core concentration is $3.86\times10^{-11}$ atoms/barn-cm. The curve shows a rapid early rise followed by a saturation regime, consistent with the balance between I-135 decay production, Xe-135 burnout in high-flux regions, and loop transport.

### Steady-State Field Distributions in the Primary Loop

[ss_results] shows the steady-state scaled fission source and $^{135}Xe$ concentration distributions.

!media msr/msre/xe_poisoning/ss_results.png
       style=width:60%
       id=ss_results
       caption=Steady-state distributions in the MSRE loop: (a) scaled fission source and (b) $^{135}Xe$ concentration.

Key observations from the spatial fields include:

- The highest fission source is concentrated in the core region, with expected attenuation toward ex-core loop components.
- $^{135}Xe$ remains relatively low in most core regions because strong neutron flux drives Xe burnout to $^{136}Xe$ by absorption.
- A comparatively elevated $^{135}Xe$ band appears near the upper core / outlet region, where transport and production-decay competition produce localized accumulation.
- Ex-core regions retain higher Xe than the core until recirculation through the lower plenum returns salt to high-flux zones.

### Reactivity Impact of Xe Poisoning

A reference case without Xe poisoning was also evaluated. Comparison of $k_{eff}$ between poisoned and unpoisoned coupled cases indicates an estimated reactivity penalty of approximately -410 pcm, which is in good agreement with trends from the SAM-Griffin coupled study.

### Current Status and Future Work

These results demonstrate that the 2-D Pronghorn-Griffin MSRE model can capture first-order Xe-poisoning behavior in a fully coupled loop simulation. Ongoing development will expand the model to transient operation and include additional physics for Xe interactions with graphite and circulating bubbles.

## Run Command

The MSRE Xenon Poisoning Model is executed using the BlueCRAB physics suite, which provides the necessary coupling between Pronghorn (thermal-hydraulics) and Griffin (neutronics). The following example demonstrates how to initialize the environment and launch a parallel simulation on the INL Sawtooth cluster.

### 1. Environment Setup

Before launching on the INL Sawtooth cluster (or a similar MOOSE-based HPC environment), load the required modules so dependencies, MPI libraries, and executables are available in your shell environment.

```language=bash
# Initialize the MOOSE environment and load the BlueCRAB application suite
module load use.moose moose-apps bluecrab
```

### 2. Executing the Coupled Simulation

Use `mpiexec` to distribute the coupled solve. For this 2-D axisymmetric case, 6 cores are a practical balance between computational speed and communication overhead.

```language=bash
# Execute the master input file using 6 processors
mpiexec -n 6 blue_crab-opt -i th_xe.i 2>&1 | tee logfile
```

### 3. Detailed Command Breakdown

!table id=xe_run_cmd_breakdown caption=Breakdown of the coupled run command.
| Component | Function |
| :- | :- |
| `mpiexec -n 6` | Launches MPI with 6 parallel processes. |
| `blue_crab-opt` | Optimized executable containing both Pronghorn and Griffin physics. |
| `-i th_xe.i` | Specifies the master input file; the sub-app input (`neu_xe.i`) is launched via the `[MultiApps]` block. |
| `2>&1` | Redirects standard error to standard output so all messages are captured together. |
| `tee logfile` | Writes console output to `logfile` while still printing to screen for live monitoring. |
