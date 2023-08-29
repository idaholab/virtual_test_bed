## Step 5

Step 5 makes the following changes to the model:

- Bottom and side/top reflector are added. The reflectors differ in their porosity. The side reflector has a porosity of 0 and thus no flow through it, while the bottom reflector has a porosity of 0.4 and has flow going thorugh it. These two reflectors are made up of graphite (see objects added in the `Materials` section).
- Dimensions of the core, inlet temperature, mass flow rate, and material properties are changed to prototypical values.

## Parameters

The inlet temperature is changed to $533.25$ K and the mass flow rate is changed to $64.3$ kg/s. These changes are are made by modifying the header of the file:

!listing htgr/generic-pbr-tutorial/step5.i start=bed_radius end=Mesh

## Geometry

The geometry is changed by updating the `[Mesh/cartesian_mesh]` block:

!listing htgr/generic-pbr-tutorial/step5.i block=cartesian_mesh

The mesh is drawn up by the inputs of dy and dx. The entries in the dx and dy represent the thickness of segments that total up to the total size of the model along the respective axis. The product of the sets of segments along the x-axis and y-axis create a grid of elements whose blocks can be set using the `subdomain_id` parameter. The entries in the `subdomain_id` parameter are ordered from the left bottom to the top right with
entries in the bottom row of the geometry being filled first before moving to the second
row and so forth.
The bottom reflector has block id 3 while the side reflector has block id 4.
The blocks present in the `subdomain_id` are named using the following lines:

!listing htgr/generic-pbr-tutorial/step5.i start=block_id end=side_reflector'

In addition to adding the bottom and side reflector, several additional sidesets (or synonymously in MOOSE: boundaries) are created in the `Mesh` block and the dimension of the pebble bed are updated.

The addition of two blocks requires updates to most of the `block` parameters in Step 5.

## Updating the Action

Step 5 is the first model with solid-only (i.e., no flow) blocks. Therefore, the blocks on which fluid flow is solved must be set in the `NavierStokesFV` and that is done using the `block` parameter:

!listing htgr/generic-pbr-tutorial/step5.i start=NavierStokesFV end=porosity

It is also imperative to block-restrict the fluid properties object to only
operate on the fluid blocks:

!listing htgr/generic-pbr-tutorial/step5.i block=fluid_props_to_mat_props

Take a particular note of the line `thermal_conductivity = kappa` which instructs the code to obtain the
functor `kappa` and use it as thermal conductivity of the fluid. The reason why we do this is detailed in
the Materials section.

## The Pebble-bed Geometry Object

The pebble-bed geometry object is used by several materials to modify properties at the
reflector wall, at the top of the pebble-bed, or in the bottom cone.
Pebble-bed geometries are special user objects.
For the simple geometry used in this tutorial, `WallDistanceCylindricalBed` is used:

!listing htgr/generic-pbr-tutorial/step5.i block=UserObjects

The pebble bed geometry is fully defined using the `inner_radius`, the `outer_radius` and the `top` of the core. `inner_radius` and `outer_radius` do not change and
are therefore set to $0$ and $1.2$, but `top` is the y-coordinate of the top end
of the core which changes when more geometry is added in the following steps. Therefore,
we define a variable `top_core` to set it.

## Materials

The goal of Step 5 is to use realistic material properties and closure relationships.

First, we define a diagonal tensor effective thermal conductivity called `effective_thermal_conductivity`. In the
pebble bed, `effective_thermal_conductivity` will contain contributions from conduction through the bed,
radiation between pebbles, and conduction through the fluid. We will use an empirical correlation in the bed.
To accomplish that, we need to define base material properties in the bed. This is accomplished by using an
`ADGenericFunctorMaterial` object:

!listing htgr/generic-pbr-tutorial/step5.i block=graphite_rho_and_cp_bed

We set the full density thermal conductivity of graphite to $26$ W/m-K.

The effective thermal conductivity in the bed is then computed using empirical models that can be
selected using the `FunctorPebbleBedKappaSolid` object:

!listing htgr/generic-pbr-tutorial/step5.i block=kappa_s_pebble_bed

This object uses the base thermal conductivity of graphite (`k_s=26`)
and produces a scalar property named `kappa_s`. The options available in
`FunctorPebbleBedKappaSolid` are detailed in the Pronghorn manual.

In the reflector regions, we use `ADGenericFunctorMaterial` and directly modify the thermal
conductivity by multiplying it by $1 - \epsilon$ where $\epsilon$ is the porosity. Note, that in the
reflector regions, we directly define the functor `kappa_s`. The two objects defining thermal
properties in the reflector regions are:

!listing htgr/generic-pbr-tutorial/step5.i start=graphite_rho_and_cp_side_reflector end=drag_pebble_bed

We want to define the property `effective_thermal_conductivity` as a
diagonal tensor property everywhere. To that end we use `ADGenericVectorFunctorMaterial` to inject `kappa_s` into `effective_thermal_conductivity`:

!listing htgr/generic-pbr-tutorial/step5.i start=effective_pebble_bed_thermal_conductivity end=kappa_f_pebble_bed

Neither `rho_s` nor `cp_s` are modified by $1 - \epsilon$ because that modification is automatically
performed in the `PINSFVEnergyTimeDerivative`.

We use the same paradigm for providing effective thermal conductivity, `kappa`, of the fluid as for providing the effective solid thermal conductivity (i.e.,`effective_thermal_conductivity`). The effective solid thermal conductivity is identical to the
molecular thermal conductivity of helium almost everywhere. The exception is the pebble bed, where the thermal conductivity of the helium is
increased to account for the braiding effect. Braiding refers to the lateral movement of fluid around pebbles on its way through the core
which is not accounted for in porous medium models. The standard way of accounting for braiding is to increase the thermal conductivity of
helium. The `fluid_props_to_mat_props` object of type `GeneralFunctorFluidProps` provides the molecular thermal conductivity of helium as
a scalar functor with name `k`. In the bed, we use `FunctorLinearPecletKappaFluid` to set `kappa`, while on all remaining fluid blocks,
we simply copy over `k` into `kappa` noting that `kappa` is a diagonal tensor and not a scalar value.

!listing htgr/generic-pbr-tutorial/step5.i start=kappa_f_pebble_bed end=pebble_bed_alpha

The volumetric heat transfer coefficient between pebbles and helium is computed
using the German Kerntechnischer Ausschuss correlation:

!listing htgr/generic-pbr-tutorial/step5.i block=pebble_bed_alpha

Pronghorn provides a wide variety of other correlations that are documented
in the Pronghorn manual.
The heat transfer coefficient in the bottom reflector is (somewhat arbitrarily)
set to $2 \times 10^4$ W/m$^3$-K.

For the pressure drop in the bottom reflector, we assume that the bottom
reflector is made up of pipes if diameter $0.1$ m. The pressure drop in these
pipes is estimated using the Churchill correlation that is available in Pronghorn via the `FunctorChurchillDragCoefficients` object:

!listing htgr/generic-pbr-tutorial/step5.i block=drag_bottom_reflector

The `multipliers` parameter makes the pressure drop in the x-direction much
larger than in the y-direction modeling a pipe oriented along
the y-direction.

Some materials based on correlations pick up a characteristic length as parameter `characteristic_length`. The characteristic length is usually different in different
parts of the model so it is good practice to set it using `PiecewiseByBlockFunctorMaterial`.

!listing htgr/generic-pbr-tutorial/step5.i block=characteristic_length

Currently, we only set the characteristic length in the pebble
bed and bottom reflector because that is where we use empirical correlations.

## Postprocessors

The appropriate way to get an average outlet temperature is to weight it by the mass flux and then integrate over the outlet boundary. This is accomplished in MOOSE using the `MassFluxWeightedFlowRate` object:

!listing htgr/generic-pbr-tutorial/step5.i block=mass_flux_weighted_Tf_out

It works very similar to the already discussed `VolumetricFlowRate` postprocessor objects that are used to compute mass flow rate and enthalpy flow rates.

## Executable

!listing
./pronghorn-opt -i step5.i

## Results

We obtain an average outlet temperature of $1132$ K which is

!media generic-pbr-tutorial/MeshP5.png
    style=width:20%
    id=step5mesh
    caption= Mesh for Step 5.

!media generic-pbr-tutorial/T_fluidP5.png
    style=width:20%
    id=step5T_fluid
    caption= Tempurature of the fluid for Step 5.

!media generic-pbr-tutorial/PressureP5.png
    style=width:20%
    id=step5Pressure
    caption= Pressure of the system for Step 5.

!media generic-pbr-tutorial/VelocityP5.png
    style=width:20%
    id=step5Velocity
    caption= Velocity of the system for Step 5.

!media generic-pbr-tutorial/T_solidP5.png
    style=width:20%
    id=step5T_solid
    caption= Tempurature of the solid for Step 5.    
