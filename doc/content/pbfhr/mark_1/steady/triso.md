# Microscale simulation of the TRISO fuel matrix

The microscale system is a subset of the mesoscale system, over which the mesoscale solution may
be approximated as constant. TRISO particles are packed randomly in the fuel matrix layer of the fuel
pebble, and the size of each particle is about three times smaller than the width of the layer.
In the fuel pebble, the microscale system is a TRISO particle and an additional layer of graphite
from the fuel matrix.

## Geometry

Similar to the pebbles, we represent the extended TRISO particle with a 1D spherical mesh.
The [CartesianMeshGenerator](https://mooseframework.inl.gov/source/meshgenerators/CartesianMeshGenerator.html) allows us to align mesh boundaries with the geometrical
boundaries of each material in the TRISO. The graphite matrix around the TRISO particles is
represented by an additional layer of graphite, sized to preserve the total packing fraction of graphite.

!listing /pbfhr/mark1/steady/ss5_fuel_matrix.i block=Mesh

## Defining the equation: variables and kernels

The temperature variable in this simulation is the unshifted temperature, or the
temperature solution of the microscale equation, not the physical temperature. We use the
auxiliary system, an [AuxKernel](https://mooseframework.inl.gov/moose/syntax/AuxKernels/) and an [AuxVariable](https://mooseframework.inl.gov/syntax/AuxVariables/) to compute the physical temperature, which
would be used to compute the material properties.

!listing /pbfhr/mark1/steady/ss5_fuel_matrix.i block=Variables AuxVariables AuxKernels

The microscale equation is decomposed in four kernels:

- the time derivative kernel. It's inactive by default as we neglect the time dependence of the
  temperature at the microscale. The time scale for the evolution of the microscale is much smaller.
  We instead solve a steady state problem.

!listing /pbfhr/mark1/steady/ss5_fuel_matrix.i block=Kernels/time

- the heat conduction kernel. We only need to specify the name of the thermal conductivity material property
  and the name of the temperature variable.

!listing /pbfhr/mark1/steady/ss5_fuel_matrix.i block=Kernels/diffusion

- the heat source. This term is only present in the center of the TRISO particle, in the fuel.
  It is assumed uniform, as we neglect spatial self-shielding over
  the particle for the heat deposition. We rescale it based on the actual UO2 volume, as the heat source was
  averaged over the solid phase / fuel matrix at various stages of the simulation.

!listing /pbfhr/mark1/steady/ss5_fuel_matrix.i block=Kernels/heat_source

- the heat sink. This term makes the total heat source have a zero average,
  so that it represents the fluctuation term in our
  multiscale approach. It is distributed over the entire microscale fuel matrix.

!listing /pbfhr/mark1/steady/ss5_fuel_matrix.i block=Kernels/heat_sink_for_zero_average_over_matrix


We add a boundary condition to this heat diffusion problem. This boundary condition, null temperature on the right
for the unshifted temperature, is arbitrary, but it is required for the diffusion problem. The default zero gradient
boundary conditions on both sides would allow an infinity of solutions, all offset by a constant. This boundary condition is
superseded by the normalization condition imposed later on the shifted temperature.

!listing /pbfhr/mark1/steady/ss5_fuel_matrix.i block=BCs

## Outputs

We measure using [Postprocessors](https://mooseframework.inl.gov/syntax/Postprocessors/index.html) the maximum and average temperatures of each phase, which will be transferred for
visualization and analysis purposes to a core-scale application.

!listing /pbfhr/mark1/steady/ss5_fuel_matrix.i block=Postprocessors
