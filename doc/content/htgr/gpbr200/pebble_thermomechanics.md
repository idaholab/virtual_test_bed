# GPBR200 Pebble Thermomechanics with Bison


*Contact: Zachary M. Prince, zachary.prince@inl.gov*

*Model link: [GPBR200 Bison Model](https://github.com/idaholab/virtual_test_bed/tree/devel/htgr/gpbr200/pebble_thermomechanics)*

Here the input for the Bison-related physics of the GPBR200 model is presented.
These physics include the heat conduction within a representative TRISO particle
and a representative pebble matrix. This stand-alone input will be utilized
later in [Multiphysics Coupling](gpbr200/coupling.md) to account for coupling
with neutronics and thermal hydraulics. The details of this pebble model is
presented in [!cite](prince2024Sensitivity); as such, this exposition will focus
on explaining specific aspects of the input file.

## Field Values

Most of the field values in this input are presented in the
[neutronics model](gpbr200/core_neutronics.md). The two unique ones are the
`initial_temperature` and `initial_power`, which are used to populate the heat
source and BCs of the simulation. Eventually, these values will become
irrelevant since the neutronics model with populate these values via coupling.

!listing gpbr200/pebble_thermomechanics/gpbr200_ss_bsht_pebble_triso.i
    start=Geometry
    end=GEOMETRY AND MESH

## Mesh

This input represents a relatively simple 1D R-spherical model of both the
pebble matrix and TRISO particle. The input creates a mesh for each of these
geometries and combines them to create a single, disjoint mesh.

!listing gpbr200/pebble_thermomechanics/gpbr200_ss_bsht_pebble_triso.i
    block=Mesh

## Physics

### Variables

A temperature variable is defined on each of the two domains, one for the pebble
temperature and TRISO temperature.

!listing gpbr200/pebble_thermomechanics/gpbr200_ss_bsht_pebble_triso.i
    block=Variables

### Kernels

This steady-state heat conduction input defines a heat diffusion and source
kernel for each variable. The source for the pebble domain occurs in the "core"
region of the pebble, i.e. where the TRISO particles are embedded. The source
for the TRISO domain occurs in the fuel kernel. For both of the sources, the
power density comes from the `porous_media_power_density` postprocessor. The
postprocessor is a constant value for now, but will eventually be populated by
the neutronics model. The power density is scaled such that integration over
just the fueled regions obtains the full power.


!listing gpbr200/pebble_thermomechanics/gpbr200_ss_bsht_pebble_triso.i
    block=Kernels Postprocessors/porous_media_power_density

### Boundary Conditions

The surface temperature for the pebble is defined by the `pebble_surface_temp`
postprocessor, which is constant for this exposition, but will eventually come
from Pronghorn solid heat conduction solve.

!listing gpbr200/pebble_thermomechanics/gpbr200_ss_bsht_pebble_triso.i
    block=BCs/pebble_surface_temp Postprocessors/pebble_surface_temp

The pebble and kernel temperatures are coupled via the boundary condition on the
surface of the kernel. This temperature is defined as the average temperature of
the fueled region of the pebble; evaluated by the `pebble_core_average_temp`
postprocessor.

!listing gpbr200/pebble_thermomechanics/gpbr200_ss_bsht_pebble_triso.i
    block=BCs/triso_surface_temp Postprocessors/pebble_core_average_temp

## Materials

This input employs materials commonly used for TRISO compacts. Some of the
parameters are not relevant to this model, but are required by the objects. This
includes parameters related to specific heat, density, and neutron damage.

!listing gpbr200/pebble_thermomechanics/gpbr200_ss_bsht_pebble_triso.i
    block=Materials

## Executioner

Since this model involves a steady-state equilibrium core, the input uses the
`Steady` executioner. The solver options shown are typical for nonlinear heat
conduction problems. The input focuses on the absolute tolerance for convergence
since the simulation gets rerun many times in the coupled simulation with
marginally different power density, where relying on a relative tolerance could
make the solver run into issues with round-off error.

!listing gpbr200/pebble_thermomechanics/gpbr200_ss_bsht_pebble_triso.i
    block=Executioner

## Postprocessing

There are two postprocessors computed in the simulation, used later for
cross-section evaluation.

!listing gpbr200/pebble_thermomechanics/gpbr200_ss_bsht_pebble_triso.i
    block=Postprocessors/fuel_average_temp Postprocessors/moderator_average_temp

## Results

The input can be run using a `bison-opt` or `blue_crab-opt` executable on a
single processor; the execution time is essentially instantaneous.

```
blue_crab-opt -i gpbr200_ss_bsht_pebble_triso.i
```

The resulting fuel and moderator average temperatures for this stand-alone model
are 1156 K and 1091 K, respectively.
