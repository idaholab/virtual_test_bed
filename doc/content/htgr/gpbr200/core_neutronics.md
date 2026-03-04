# GPBR200 Equilibrium Core Neutronics with Griffin

*Contact: Zachary M. Prince, zachary.prince@inl.gov*

*Model link: [GPBR200 Griffin Model](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/gpbr200/core_neutronics)*

Here the input for the Griffin-related physics [!citep](wang2025Griffin) of the GPBR200 model is
presented. These physics include the core-wide neutronics along with the
equilibrium-core pebble depletion. This stand-alone input will be modified later
in [Multiphysics Coupling](gpbr200/coupling.md) to account for coupling with TH
and pebble thermomechanics. The details of neutronics and depletion aspects of
this model is presented in [!cite](prince2024Sensitivity); as such, this
exposition will focus on explaining specific aspects of the input file.

## Input File Variables and Global Parameters

Convenient input file variables are defined in the input for several reasons:
defining a single input value to be used in multiple blocks, traceability in how
certain values are computed, and defining "perturbable" values (which becomes
evident in the [sensitivity analysis](gpbr200/sensitivity_analysis.md)).

The first set of input file variables are pretty self-evident and utilized ubiquitously
through all the physics of PBR models.

!listing gpbr200/core_neutronics/gpbr200_ss_gfnk_reactor.i
    start=Power
    end=Pebble Geometry

The second set of values involve the geometry of the TRISO particles and the
pebble they are embedded in. The values here, particularly the `triso_number`,
are used for computing the initial heavy metal mass; mainly for burnup
conversion: MWd/kgHM $\longleftrightarrow$ J/cm^3^.

!listing gpbr200/core_neutronics/gpbr200_ss_gfnk_reactor.i
    start=Pebble Geometry
    end=Compositions

The third set of values involve computing initial nuclide concentrations based
on fuel enrichment and kernel density. This allows for simple manipulation of
these quantities, which the input will automatically convert to values necessary
for object parameters.

!listing gpbr200/core_neutronics/gpbr200_ss_gfnk_reactor.i
    start=Compositions
    end=Parameters describing pebble cycling

For the same purposes, the next set of values define values involved with
defining the pebble cycling scheme.

!listing gpbr200/core_neutronics/gpbr200_ss_gfnk_reactor.i
    start=Parameters describing pebble cycling
    end=Blocks

Finally, there are a relatively large number of blocks in the mesh, so input file
variables are defined to promote clarity on where variables, kernels, etc. are
acting.

!listing gpbr200/core_neutronics/gpbr200_ss_gfnk_reactor.i
    start=Blocks
    end=GLOBAL PARAMETERS

Global parameters are also useful for propagating a certain parameter shared
across many objects. Here, `is_meter` is used to tell Griffin objects that the
mesh units are in meters (versus centimeters) for proper conversion of
cross-section values.


!listing gpbr200/core_neutronics/gpbr200_ss_gfnk_reactor.i
    block=GlobalParams

## Mesh

The mesh is retained as an Exodus file in the model directory. This mesh
contains several extra element ids that are used to describe the materials and
the streamlines of the pebble flow, shown in [!ref](fig:gpbr200_element_id). As
such, the parameter `exodus_extra_element_integers` needs to be specified to
load this data. Additionally, the 2D geometry is axisymmetric, which is
communicated to MOOSE via the `coord_type` parameter and the rotation axis is
specified by the `rz_coord_axis` parameter.

!listing gpbr200/core_neutronics/gpbr200_ss_gfnk_reactor.i
    block=Mesh

!media gpbr200/gpbr200_element_id.png
    caption=GPBR200 extra element IDs in mesh.
    id=fig:gpbr200_element_id

The `material_id`s represent the three regions where separate cross-section sets
were generated: one for the core (fuel) region, reflector (non-fuel) region, and
one specific for the upper cavity (void region). The `pebble_streamline_id`s
represent streamlines where pebbles flow down, but don't cross into other
streamlines. The `pebble_streamline_layer_id`s are used to describe the
direction of pebble flow within the streamline, flowing from the smallest ID
(inlet) to largest (discharge).

## Auxiliary Variables

The `AuxVariables` in this input define the solid temperature distribution in
the core and the porosity of the pebble-bed core. The solid temperature,
`T_solid`, is used by Griffin's material system to interpolate cross sections
based on the current state of the reactor. Without coupling, this variables is
arguably unnecessary; however, when coupling later, this temperature will be
filled by the thermal hydraulics simulation. The `porosity` is also used by
Griffin's material system to appropriately compute nuclide concentrations for
macroscopic cross-section generation and nuclide advection from pebble flow.
This quantity is required by Griffin to be a variable.

!listing gpbr200/core_neutronics/gpbr200_ss_gfnk_reactor.i
    block=AuxVariables

## Materials

There are four regions in the geometry that are treated uniquely by Griffin
materials: the reflector, control rod, upper cavity, and core.

The reflector region utilizes `CoupledFeedbackNeutronicsMaterial`, which has
constant nuclide concentrations and couples `T_solid` as its `tmod` grid
variable.

!listing gpbr200/core_neutronics/gpbr200_ss_gfnk_reactor.i
    block=Materials/reflector

The control rod region utilizes `CoupledFeedbackRoddedNeutronicsMaterial`, which
is similar to the reflector region strategy, except the nuclide concentration is
varied spatially according to a function defining the front of the control rod.
The insertion depth of the control rod in this example was chosen such that the
multiphysics simulation results in a $k_{\mathrm{eff}}$ close to unity.

!listing gpbr200/core_neutronics/gpbr200_ss_gfnk_reactor.i
    block=Materials/crs Functions

The upper cavity utilizes a special cross-section set since the region is
essentially void, which would otherwise be troublesome for the diffusion
approximation being used for the neutronics.

!listing gpbr200/core_neutronics/gpbr200_ss_gfnk_reactor.i
    block=Materials/cavity

Defining the nuclide concentration in the core region directly is quite
complicated, even at its initial state. Therefore, Griffin's `Compositions`
system is used to build up particle-packed pebble. The resulting composition is
communicated to the depletion system (explained in the next section) to build
the "depletable" materials for the core region.

!listing gpbr200/core_neutronics/gpbr200_ss_gfnk_reactor.i
    block=Compositions

## Pebble Depletion

The `PebbleBed` syntax in Griffin enables the multiscale approach Griffin
utilizes to perform pebble advection and cycling in the core. This syntax
triggers a MOOSE action that builds postprocessors, auxiliary variables/kernels,
materials, and user objects that:

1. Perform power scaling and power density evaluation
2. Compute macroscopic cross sections for the neutronics solve
3. Perform the coupled pebble advection and depletion simulation

The first set of parameters specify options related to power scaling and
computation of power density. `integrated_power_postprocessor` and
`power_density_variable` are simply names to give postprocessor and
aux-variables, to be consumed by other objects. The `family` and `order` are
specified to match the power density variable eventually used by the
thermal-hydraulics physics.

The second set of parameters relate to microscopic cross section specification,
including the XML library used for fueled region, grid variable names for
coupled physics, and fixed grid variable values, which will be adjusted for
eventual input perturbation in the stochastic analysis. Similarly, the third set
of variables specify the XML decay and transmutation data for performing
depletion calculations.

The fourth set, namely `n_fresh_pebble_types` and `fresh_pebble_compositions`,
specify the fresh pebble composition. Since this is an equilibrium-core
simulation, there is only one "type" of pebble introduced into the core.
Depleted pebbles are recycled through the core, but these do not constitute a
different type of pebble. The fifth set of parameters specify the density of
pebbles and burnup discretization for the pebble depletion, which here is 12
bins, where the last bin starts at 196.8 MWd/kgHM (converted to J/cm^3^ using
`fparse`).

The `DepletionScheme` block primarily specifies that an equilibrium-core
simulation is to be performed. The parameters in this block include
specifications on how the pebbles spatially traverse the core. Where
`pebble_unloading_rate` specifies the rate at which pebbles enter/exit the core,
`pebble_flow_rate_distribution` is the fraction of this rate for each streamline
(according to the `pebble_streamline_id` element ID), and `burnup_limit`
specifies the minimum burnup a pebble must reach upon exiting the core to be
discarded for a fresh pebble. `sweep_tol` and `sweep_max_iterations` are solver
parameters for the advection-depletion system. `exodus_streamline_output` can be
set to `true` if a full profile of isotopic concentrations throughout the core
is desired at output.

!listing gpbr200/core_neutronics/gpbr200_ss_gfnk_reactor.i
    block=PebbleBed


## Transport Systems

The last portion of the input describing the physics is the `TransportSystems`
block. This block defines what form of the transport equation is being solved,
including: type of particle (neutron), equation type (eigenvalue/criticality),
number of energy groups (9), spatial and angular discretization
(CFEM-Diffusion), and number of delay neutron precursors (6). Additionally, the
boundary conditions are defined here; note that even reflecting conditions need
to be defined with a diffusion system. Finally, which portions of the
Jacobian should be computed are also specified; it is highly recommended to include all portions
(scattering and fission) for diffusion systems.

!listing gpbr200/core_neutronics/gpbr200_ss_gfnk_reactor.i
    block=TransportSystems

## Executioner

The final relevant block of the neutronics input is the `Executioner`. Here, the
`Eigenvalue` solver is specified using the `PJFNKMO` method. This method, along
with linear and nonlinear parameters specified are common for neutron diffusion
simulations. Since the simulation is coupling neutron diffusion with pebble
depletion, the input specifies parameters enabling fixed-point iteration. The
convergence of this iteration considers the $k_{\mathrm{eff}}$, or `eigenvalue`,
convergence as its metric.

!listing gpbr200/core_neutronics/gpbr200_ss_gfnk_reactor.i
    block=Executioner

## Results

The input can be run using a `griffin-opt` or `blue_crab-opt` executable:

```
mpiexec -n 8 blue_crab-opt -i gpbr200_ss_gfnk_reactor.i
```

The resulting eigenvalue is approximately 1.01496. Additionally,
[!ref](fig:gpbr200_ss_gfnk_only) shows the resulting power density, fast scalar
flux, and thermal flux.

!media gpbr200/gpbr200_ss_gfnk_only.png
    caption=GPBR200 neutronics-only selected field variables
    id=fig:gpbr200_ss_gfnk_only

The use of 8 processors in the command listing is somewhat arbitrary,
[!ref](tab:gpbr200_ss_gfnk_only_rt) shows the expected scaling performance.

!table caption=Run times for GPBR200 neutronics-only input with varying number of processors id=tab:gpbr200_ss_gfnk_only_rt
| Processors | Run-time (min) |
| ---------- | -------------- |
|          1 | 7.3            |
|          2 | 4.7            |
|          4 | 3.7            |
|          8 | 2.6            |
|         16 | 1.9            |
|         32 | 1.4            |
