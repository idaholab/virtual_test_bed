# Baseline simulation

This study analyzes the stress induced by temperature and radiation effects over a prolonged period. The model assumes steady-state temperature and neutron flux distributions. Radiation effects manifest as irradiation-induced dimensional changes and irradiation creep.

## Computational Model Description

[Mesh] shows the mesh of the unit cell of the MSRE graphite stringer.

!media msr/graphite_model/wear/5_mesh.png
      id=Mesh
      style=width:40%
      caption= Finite element mesh of a reflector block.

Files used by this model include:

- MOOSE input file
- Exodus mesh file

This document reviews the important elements of the input file that were not covered in previous models [Infiltration effects on graphite](infiltration_graphite.md)

!listing msr/graphite_model/wear/1_baseline/baseline.i

### Temperature and neutron flux distributions

Steady-state temperature and neutron flux are critical inputs to these simulations, and these are generally obtained from Neutronics simulations. Both of these functions are defined as a `ParsedFunction` object as shown below:

!listing msr/graphite_model/wear/1_baseline/baseline.i block=Functions

### Radiation effects

Irradiation in graphite leads to irradiation-induced dimensional changes and irradiation creep. Built-in empirical models within Grizzly for IG110 is used as shown.

!listing msr/graphite_model/wear/1_baseline/baseline.i  block=GraphiteGrade_creep graphite_irrad_strain

## Running the model

To run this model using the Grizzly executable, run the following command:

```
mpiexec -n 300 /path/to/app/grizzly-opt -i baseline.i
```

*Note: HPC resources (300 cores) were used to perform this simulation*

The following Exodus results file will be produced: `baseline_exodus.e`

The Exodus output file can be visualized with Paraview.
