# SAM generic PBR model

*Contact: Zhiee Jhia Ooi, zooi@anl.gov*

The input file (pbr.i) is a model for the generic 200 MW pebble bed reactor
developed using SAM [!citep](Hu2021). The model focuses only on the core of the
reactor where the auxiliary components and power conversion system are not
included. The design and operation information of the core is obtained primarily
from the work by Stewart et al. [!citep](Stewart2021), who obtained geometric
data of the core from publicly available figures and models, supplemented with
information from the PBMR-400 report published by the Nuclear Energy
Agency [!citep](PBMR2013).

The schematic of the core model is shown in [core-geometry]. The core consists
of the pebble bed, reflector, core barrel, reactor pressure vessels (RPV),
reactor cavity cooling system (RCCS) panel, and helium layers. Note that the
angled lower region of the pebble bed is known as the fuel chute. In the model,
helium enters from the bottom of the core and flows upward to the upper inlet
plenum via the upcomer. It then flows downward through the pebble bed, carrying
heat from the pebbles, to the lower outlet plenum before leaving the core.

!media generic-pbr/core-geometry.png
        style=width:70%
        id=core-geometry
        caption=Schematic of the core model of the generic pebble bed reactor.

The SAM model is developed with the so-called core channel approach where the
pebble bed is modeled with a number of `PbCoreChannel` components while the
reflectors and other solid structures are modeled with the `PbCoupledHeatStructure`
component. Along with them are the `PbOneDFluidCompoenent` used for modeling the
flow channels. As shown in the above figure, the pebble bed is partitioned into
five individual blocks radially where each block is a `PbCoreChannel` component.
In this model, the number of `PbCoreChannel` components in the radial direction
is chosen to match the partitioning of the reactivity feedback coefficients in
the work by Stewart et al. [!citep](Stewart2021). Furthermore, the fuel chute is
modeled with multiple smaller blocks of `PbCoreChannel` components to account
for its complex geometry. Note that the `PbCoreChannel` in SAM is essentially a
one-dimensional hydraulic component with built-in multi-dimensional heat
structures. This allows the specification of hydraulic parameters such as flow
area, hydraulic diameter, and surface roughness, as well as solid parameters such
as the geometry and material properties of the heat structure. Furthermore, heat
transfer parameters such as the heat transfer area density can be provided to
the component. Solid, fluid, and heat transfer behaviors are then calculated
internally by the `PbCoreChannel` component according to the provided information.
In this model, the `PbCoreChannel` component is set to have spherical heat
structures where the heat-transfer geometry is set as pebble bed.

The solid structures outside of the pebble bed are modeled as concentric rings
with the `PbCoupledHeatStructure` components and are thermally coupled to the
adjacent `PbOneDFluidComponents` when necessary. To ensure proper heat transfer
between adjacent solid components, they are thermally coupled in both the radial
and axial directions using the `SurfaceCoupling` component with an arbitrarily
large heat transfer coefficient. Furthermore, similar approach is applied to
thermally couple adjacent `PbCoreChannels` to model the core wide radial heat
conduction in the pebble bed where the outermost `PbCoreChannel` is further
coupled to the inner surface of the reflector. It is important that the core
wide radial heat conduction is modeled correctly as it is one of the primary
heat removal mechanisms during loss of forced flow transient scenarios. Heat
transfer between solid structures across the helium layers is modeled as
radiation heat transfer. Note that the helium layers are assumed as stagnant
with no natural convection.

Point kinetics are included in the model for the transient load-following
simulation. The point kinetics parameters such as the delayed neutron fractions,
the neutron lifetimes, the delayed neutron precursor decay constant, the prompt
neutron lifetime, and the reactivity feedback coefficients are obtained from the
work by Stewart et al. [!citep](Stewart2021). In this model only temperature
reactivity feedback from the fuel, moderator, and reflector regions are considered.
Other mechanisms such as coolant reactivity feedback, xenon reactivity feedback,
and core expansion reactivity feedback are not considered both in this work and
the work by Stewart et al. [!citep](Stewart2021). The distribution of the local
reactivity coefficients are illustrated in [reactivity-coefficients] where the
reactivity of the pebble bed is shown to be influenced by the feedback from the
fuel, moderator, and reflector. To properly account for the reactivity feedback
from different regions, it is necessary to divide the pebble heat structures
into three layers of fuel, moderator, and reflector with the correct reactivity
coefficients prescribed to each layer. Furthermore, this step is necessary
because SAM treats fuel (Doppler) reactivity coefficients differently than
moderator/reflector reactivity coefficients. Note that no such distinction is
made by SAM between the moderator and reflector reactivity coefficients. This
means that in the reflector region where the fuel (Doppler) reactivity
coefficients are absent, the local moderator and reflector reactivity coefficients
from Stewart et al. [!citep](Stewart2021) can be summed and prescribed directly
to the heat structures.

!media generic-pbr/reactivity-coefficients.png
        style=width:100%
        id=reactivity-coefficients
        caption=Distribution of local reactivity coefficients from Griffin/Pronghorn by Stewart et al. [!citep](Stewart2021).

During steady-state, the one-dimensional fluid components of the model has an
inlet velocity 7.17 m/s whose value is determined from the work by Stewart
et al. [!citep](Stewart2021) and a pressure outlet boundary condition of 6 MPa.
For the solid structures, the top and bottom surfaces are adiabatic while the
outer surface of the RCCS panel is given a constant temperature boundary
condition of 293.15 K. The total power of the reactor is set at 200 MW. During the
transient, the coolant flow rate is reduced to 25% of its nominal value in a
span of 900 s, then kept constant at that level for 1800 s, and lastly raised
back to the nominal value over 900 s and is held constant to the end of the
simulation. Note that other than the coolant flow rate, the other boundary
conditions are kept unchanged.

The output files consist of: (1) a `csv` file that writes all user-specified
variables and postprocessors at each time step; (2) a checkpoint folder that saves the snapshots
of the simulation data including all meshes, solutions, and stateful object data.
They are saved for restarting the run if needed; and (3) an `ExodusII` file that
also has all mesh and solution data. Users can use Paraview to visualize the
solution and analyze the data. This tutorial describes the content of the input
file, the output files and how the model can be run using the SAM code.

# Input Description

SAM uses a block-structured input syntax. Each block begins with square brackets
which contain the type of input and ends with empty square brackets. Each block
may contain sub-blocks. The blocks in the input file are described in the order
as they appear. Before the first block entries, users can define variables and
specify their values which are subsequently used in the input model. For example,

!listing
emissivity   = 0.8.             # Material emissivity
T_RCCS       = 293.15           # Temperature of RCCS panel
V_in         = 7.186055         # Coolant inlet velocity

In SAM, comments are entered after the `#` sign

## Global parameters

This block contains the parameters such as global initial pressure, velocity,
and temperature conditions, the scaling factors for primary variable residuals,
etc.  For example, to specify global pressure of 6.0e6 Pa, the user can input

```language=bash

global_init_P	 = 	6.0e6

```

This block also contains a sub-block `PBModelParams` which specifies the modeling
parameters associated with the primitive-variable based fluid model. New users
should leave this sub-block unchanged.

## EOS

This block specifies the Equation of State. The user can choose from built-in
fluid library for common fluids like air, nitrogen, helium, sodium, molten salts,
etc. The user can also input the properties of the fluid as constants or function
of temperature. For example, the built-in eos for helium can be input as

!listing htgr/generic-pbr/pbr.i block=eos language=cpp

## Functions

Users can define functions for parameters used in the model. These include
temporal, spatial, and temperature dependent functions. For example, users
can input enthalpy as a function of temperature, power history as a function
of time, or power profile as a function of position. Users should be cautious 
when time-dependent and temperature-dependent functions are in use to avoid
confusion between time (*t*) and temperature (*T*). Currently, only certain 
parameters can be made temperature-dependent. These include material properties
and the `h_gap` for the `SurfaceCoupling` component. The input below specifies
the thermal conductivity of fuel pebbles as a function of temperature (in K).

!listing htgr/generic-pbr/pbr.i block=k_TRISO language=cpp

## MaterialProperties

Material properties are input in this block. The values can be constants or
temperature dependent as defined in the Functions block. For example, the
properties of fuel pebbles are input as

!listing htgr/generic-pbr/pbr.i block=fuel-mat language=cpp

The thermal conductivity is defined by the function `k_TRISO` which appears
under the `Functions` block.

## ComponentInputParameters

This block is used to input common features for `Components` (section below) so
that these common features do not need to be repeated in the inputs for
`Components` later on. For example, if pipes are used in various parts of the
model and the pipes all have the same diameter, then the diameter can be
specified in `ComponentsInputParameters` and it applies to all pipes used
in the model.

!listing htgr/generic-pbr/pbr.i block=ComponentInputParameters

## Components

This block provides the specifications for all components that make up the core.
The components consist of: reactor, core channels, coolant channels, heat
structures (fuel, reflectors, core barrel, RPV and RCCS), junctions for connecting
components, and point kinetics. In the reactor component, the reactor power is
an input and this includes normal operating power and decay heat. Point kinetics
can also be enabled for the core channels through the reactor component.

!listing htgr/generic-pbr/pbr.i block=reactor language=cpp

Additional point kinetics information is needed by the model and can be provided
through the PKE component. Such information includes the delayed neutron fractions,
the prompt neutron lifetimes, the delayed neutron precursor decay constant,
the names of components with reactivity feedback, and the time for reactivity
feedback to start.

!listing htgr/generic-pbr/pbr.i block=pke language=cpp

The coolant channels are modeled as 1-D fluid flow components, and heat
structures are modeled as 2-D components. In the bottom reflector region, each
coolant channel communicates with its adjacent heat structures through the
`name_comp_left` and `name_comp_right` variables such as shown below

!listing htgr/generic-pbr/pbr.i block=BR-6 language=cpp

Adjacent heat structures are thermally coupled using `SurfaceCoupling` to ensure
temperature continuity in the radial direction

!listing htgr/generic-pbr/pbr.i block=coupling_radial_R9_R10 language=cpp

and axial direction

!listing htgr/generic-pbr/pbr.i block=coupling_axial_R5_R8 language=cpp

Note that the coupling in the radial direction is performed on the `inner_wall`
and `outer_wall` of a heat structure while the coupling in the axial direction
is performed on the `top_wall` and `bottom_wall`. In both cases the heat transfer
coefficient, `h_gap`, is set to an arbitrarily large value to ensure temperature
continuity.

Similarly, `SurfaceCoupling` is used to thermally couple adjacent core channels
to allow for radial heat transfer between the core channels

!listing htgr/generic-pbr/pbr.i block=coupling_radial_F1_F2 language=cpp

Note the difference in `coupling_type` used for the heat structures and the core
channels. The former uses `GapHeatTransfer` and the latter uses `PebbleBedHeatTransfer`.

In SAM, 1-D fluid components are connected using `PBSingleJunction`. The following
input is used to connect the outlet of component `CH-1` to the inlet of
component `CH-3`

!listing htgr/generic-pbr/pbr.i block=junc_CH1_CH3 language=cpp

Note that core channels can also be connected with the same approach.

For the components with point kinetics, additional information is required.
As mentioned previously, the pebbles in the core channels are divided into three
layers of fuel, moderator, and reflector. Using the `F-6` core channel block as
an example,

!listing htgr/generic-pbr/pbr.i block=F-6 language=cpp start=n_heatstruct end=fuel_kernel_temperature

the number of layers can be set using the `n_heatstruct` option. The names, materials,
widths, numbers of elements in the radial direction, and power fractions can
be provided as a string using the `name_of_hs`, `material_hs`, `width_of_hs`,
`elem_number_of_hs`, and `power_fraction` options, respectively. Note that
because heat is generated only in the fuel region, the power fraction of the
this region is set to the desired value with those of the moderator and reflector
regions are set to zero. The types of reactivity feedback of each region is
specified with the `pke_material_type` option. The fuel (Doppler) reactivity
coefficients are provided with the `fuel_doppler_coef` option while the
moderator/reflector reactivity coefficients are provided with the
`moderator_reactivity_coefficients` option. The numbers of axial elements for
point kinetics calculation in the fuel (Doppler) and moderator/reflector regions
are provided with the `n_layers_doppler` and `n_layers_moderator` options,
respectively. Note that the number of PKE axial elements must match the length
of the provided reactivity coefficients.

By default, the reactivity feedback in the heat structures of a core channel
is calculated using the layered-average solid temperature. However, users can
choose to calculate the reactivity feedback in the fuel region with the fuel
kernel temperature instead. This can be done by setting

!listing htgr/generic-pbr/pbr.i block=F-6 language=cpp start=fuel_kernel_temperature end=molar_mass_uranium

Currently, the fuel kernel temperature is calculated using the analytical model
implemented in the TINTE code [!citep](TINTE2010). Additional information is
needed as,

!listing htgr/generic-pbr/pbr.i block=F-6 language=cpp start=molar_mass_uranium end=[../]

Detailed descriptions of these parameters are available in the SAM Theory Manual
[!citep](Hu2021) and the TINTE report [!citep](TINTE2010).

## Postprocessors

This block is used to specify the output quantities written to a `csv` file that
can be further processed in Excel or other processing tools such as Python and
Matlab. For example, to output the maximum fuel temperature in `F-1`:

!listing htgr/generic-pbr/pbr.i block=max_Tsolid_F1

and the mass flow rate in `F-1`

!listing htgr/generic-pbr/pbr.i block=TotalMassFlowRateInlet_1

## Preconditioning

This block describes the preconditioner to be used by the preconditioned JFNK 
solver (available through PETSc). Two options are currently available, 
the single matrix preconditioner (SMP) and the finite difference preconditioner (FDP).
The theory behind the preconditioner can be found in the SAM Theory Manual [!citep](Hu2021).
New users can leave this block unchanged.

!listing htgr/generic-pbr/pbr.i block=Preconditioning

## Executioner

This block describes the calculation process flow. The user can specify the
start time, end time, time step size for the simulation. The user can also choose
to use an adaptive time step size with the [IterationAdaptiveDT time stepper](https://mooseframework.inl.gov/source/timesteppers/IterationAdaptiveDT.html).
Other inputs in this block include PETSc solver options, convergence tolerance,
quadrature for elements, etc. which can be left unchanged.

!listing htgr/generic-pbr/pbr.i block=Executioner

# Running the Simulation

SAM can be run on Linux, Unix, and MacOS.  Due to its dependence on MOOSE, SAM
is not compatible with Windows. SAM can be run from the shell prompt as shown
below

```language=bash

sam-opt -i pbr.i

```

# Acknowledgements

This work is supported by U.S. DOE Office of Nuclear Energy’s Nuclear Energy
Advanced Modeling and Simulation (NEAMS) program. The submitted manuscript has
been created by UChicago Argonne LLC, Operator of Argonne National Laboratory
(“Argonne”). Argonne, a U.S. Department of Energy Office of Science laboratory,
is operated under Contract No. DE-AC02-06CH11357. The authors would like to
acknowledge the support and assistance from Dr. Ryan Stewart and Dr. Paolo
Balestra of Idaho National Laboratory in the completion of this work.
