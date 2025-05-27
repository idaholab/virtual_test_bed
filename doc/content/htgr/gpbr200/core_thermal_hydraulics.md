# GPBR200 Thermal Hydraulics with Pronghorn

*Contact: Zachary M. Prince, zachary.prince@inl.gov*

*Model link: [GPBR200 Pronghorn Model](https://github.com/idaholab/virtual_test_bed/tree/devel/htgr/gpbr200/core_thermal_hydraulics)*

Here the input for the Pronghorn-related physics of the GPBR200 model is
presented. These physics include the core-wide coolant flow, coolant heat
transfer, and solid heat transfer. This stand-alone input will be modified later
in [Multiphysics Coupling](gpbr200/coupling.md) to account for coupling with
neutronics and pebble thermomechanics. The details of this fluid model is
presented in [!cite](prince2024Sensitivity); as such, this exposition will focus
on explaining specific aspects of the input file.

## Field Values and Global Parameters

Due to the variety of block sets in the mesh, it is first useful to define field
values so that object block restrictions are more interpretable.

!listing gpbr200/core_thermal_hydraulics/gpbr200_ss_phth_reactor.i
    start=Blocks
    end=Geometry

Geometry and various reactor property definitions are also specified as field
values.

!listing gpbr200/core_thermal_hydraulics/gpbr200_ss_phth_reactor.i
    start=Geometry
    end=BCs

The inlet velocity and initial pebble bed velocity are computed using `fparse`
expressions relating cross-sectional area, mass flow rate, and fluid density.

!listing gpbr200/core_thermal_hydraulics/gpbr200_ss_phth_reactor.i
    start=BCs
    end=GlobalParams

Finally, the `GlobalParams` block specifies common parameters used mainly in
material objects.

!listing gpbr200/core_thermal_hydraulics/gpbr200_ss_phth_reactor.i
    block=GlobalParams


## Mesh

The mesh is identical to the one in the [neutronics model](gpbr200/core_neutronics.md),
the only difference is that the element IDs are not imported from the exodus.

!listing gpbr200/core_thermal_hydraulics/gpbr200_ss_phth_reactor.i
    block=Mesh

Since the physics in this model do not cover the entire geometry provided by the
mesh, two `Problem` parameters are defined to prevent errors regarding kernel
and material definitions.

!listing gpbr200/core_thermal_hydraulics/gpbr200_ss_phth_reactor.i
    block=Problem

## Physics

This input uses MOOSE's `Physics` syntax to define the three different physics
of the problem: fluid flow, fluid heat transfer, and solid heat transfer.

### Fluid Flow

The input specifies a weakly-compressible finite-volume formulation, which is
explained in more detail in the
[MOOSE Navier-Stokes module documentation](https://mooseframework.inl.gov/modules/navier_stokes/wcnsfv.html).

!listing gpbr200/core_thermal_hydraulics/gpbr200_ss_phth_reactor.i
    block=Physics/NavierStokes/Flow

Since the initial guess for the velocity is not uniform throughout the domain,
the `pbed_superficial_vel_func` function is defined using a parsed expression
such that it has the negative y component in the pebble bed, not 0 elsewhere.

!listing gpbr200/core_thermal_hydraulics/gpbr200_ss_phth_reactor.i
    block=Functions/pbed_superficial_vel_func

### Fluid Heat Transfer

Coupled with the fluid flow physics is the fluid heat transfer physics,
implementing the fluid energy equations.

!listing gpbr200/core_thermal_hydraulics/gpbr200_ss_phth_reactor.i
    block=Physics/NavierStokes/FluidHeatTransfer

### Solid Heat Transfer

Finally, the input specifies a finite-volume formulation for the heat conduction
and radiative transfer in the solid structures of the model. This block couples
the fluid energy physics via ambient convection. Note that the material
properties for include an "effective" thermal conductivity, which considers the
porosity of the region. Additionally, the heat capacity is modified by scaling
by a factor of $10^{-5}$, so that a steady-state is reached more quickly.

!listing gpbr200/core_thermal_hydraulics/gpbr200_ss_phth_reactor.i
    block=Physics/NavierStokes/SolidHeatTransfer

The necessary boundary conditions are not included in the `Physics` syntax, so
they are added independently.

!listing gpbr200/core_thermal_hydraulics/gpbr200_ss_phth_reactor.i
    block=FVBCs


## Auxiliary Variables and Kernels

Three auxiliary variables are specified in the input: power density and the x
and y components of the velocity. The power density will eventually come from
the neutronics simulation, but for this stand-alone physics input, the total
power is simply scaled by the volume of the pebble bed. The velocity variables
represent the physical velocity of the system, used mainly for visualization,
which are converted from the superficial velocities computed by the solver.

!listing gpbr200/core_thermal_hydraulics/gpbr200_ss_phth_reactor.i
    block=AuxVariables AuxKernels

In order to prevent manual calculation of the pebble-bed volume, a
`VolumePostprocessor` is used. Note, in order to guarantee this postprocessor is
executed before the `ParsedAux`, the `force_preaux` parameter is necessary.

!listing gpbr200/core_thermal_hydraulics/gpbr200_ss_phth_reactor.i
    block=Postprocessors/volume


## Materials

The input specifies various `FunctorMaterials` to define the material properties
of the model. Most of the fluid properties are modifications considering
geometry and porosity of the `HeliumFluidProperties`. The solid thermal
properties are assumed temperature independent.

!listing gpbr200/core_thermal_hydraulics/gpbr200_ss_phth_reactor.i
    block=FluidProperties FunctorMaterials UserObjects


## Executioner

This steady-state model is solved using a pseudo-transient scheme, where a
`Transient` executioner is used to progress in time until the solution does not
change under a tolerance between timesteps. Since the fluid system is a saddle
point problem, using iterative preconditioners is not recommended, thus the
input's specification of a `lu` preconditioner.

!listing gpbr200/core_thermal_hydraulics/gpbr200_ss_phth_reactor.i
    block=Executioner

## Results

The input can be run using a `pronghorn-opt` or `blue_crab-opt` executable:

```
mpiexec -n 8 blue_crab-opt -i gpbr200_ss_phth_reactor.i
```

[!ref](fig:gpbr200_ss_phth_only) shows the resulting fluid velocity, pressure,
temperature, and solid temperature.

!media gpbr200/gpbr200_ss_phth_only.png
    caption=GPBR200 fluid-only selected field variables
    id=fig:gpbr200_ss_phth_only

The use of 8 processors in the command listing is somewhat arbitrary,
[!ref](tab:gpbr200_ss_phth_only_rt) shows the expected scaling performance.

!table caption=Run times for GPBR200 fluid-only input with varying number of processors id=tab:gpbr200_ss_phth_only_rt
| Processors | Run-time (sec) |
| ---------- | -------------- |
|          1 | 133            |
|          2 | 80             |
|          4 | 64             |
|          8 | 39             |
|         16 | 31             |
|         32 | 21             |
