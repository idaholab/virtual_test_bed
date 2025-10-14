# 3D Stress Analysis

This page discusses the model set-up for the stress analysis of a 3D MSRE graphite stringer subject to an user-defined infiltration amount, by using the reference solution file generated for this geometry.

## Computational Model Description

[3DMesh] shows the mesh of the unit cell of the MSRE graphite stringer.

!media msr/graphite_model/infiltration/3_3Dmesh.png
      id=3DMesh
      style=width:40%
      caption= Finite element mesh of the 3D unit cell of the graphite stringer.

Files used by this model include:

- MOOSE input file
- Exodus mesh file
- CSV file defining the variation of the coolant temperature and volumetric heat
- Exodus reference solution file for initializing the infiltration amount

This document reviews the inportant elements of the input file that were not covered in previous infiltration models ([creation of infiltration profiles](infiltration_profile.md) and [creation of a reference solution file](reference_solution_file.md)), listed in full here:

!listing msr/graphite_model/infiltration/3_stress_analysis_3D/msre3D_100percent_INF.i

### `Initializing inputs from CSV file`

Two quantities, namely, the volumetric heat (`volumetric_heat`) and the coolant temperature (`T_infinity_fn`) are read from the CSV file. These values are then used to constructe piecewise linear functions for both quantities along the z-axis.

```
  [volumetric_heat] #Axial distribution of the power density
    type = PiecewiseLinear
    data_file = interpolated_T_PD_values.csv
    x_index_in_file = 0
    y_index_in_file = 2
    format = columns
    xy_in_file_only = false
    axis = z
  []
  [T_infinity_fn] #Temperature distribution at the graphite-coolant interface
    type = PiecewiseLinear
    data_file = interpolated_T_PD_values.csv
    x_index_in_file = 0
    y_index_in_file = 5
    format = columns
    xy_in_file_only = false
    axis = z
  []
```

### `Initializing user-defined infiltration amount using the reference solution file`

First, a `SolutionUserObject` is used to read the interpolated infiltration profile, specifically the `diffuse` variable, from the reference solution file named `CombinedExodus_AllResults_out.e`. This is done at the user-defined infiltration amount of 33%, as specfied by `volume_fraction = 0.33`.

```
[UserObjects]
  [heatsource_soln]
    type = SolutionUserObject
    mesh = 'CombinedExodus_AllResults_out.e'
    time_transformation = ${volume_fraction}
    system_variables = 'diffuse'
  []
[]
```

Following this, `SolutionFunctions` below obtains the data from the `SolutionUserObject` and makes it available as a function for the current simulation.

```
[heatsource_soln_func] #Infiltration profile corresponding to user-defined amount
  type = SolutionFunction
  solution = heatsource_soln
  from_variable = diffuse
[]
```

The infiltration amount specifies the region where the volumetric heat needs to be defined. In previous steps, the infiltration profile is obtained through the `diffuse` variable. Here, the profile is binarized and then multiplied by the actual volumetric heat to define the required heat distribution. This is accomplished via the following block:

```
[bin_heatsource_soln_func]#Binarize heatsource_soln_func
  type = ParsedFunction
  symbol_names = smooth_mod
  symbol_values = heatsource_soln_func
  expression = 'if(smooth_mod>=${threshold},1,0)'
[]
[mod_heatsource_soln_func]#Obtain 3D distribution of the power density
  type = ParsedFunction
  symbol_names = 'bin_heatsource_soln_func volumetric_heat'
  symbol_values = 'bin_heatsource_soln_func volumetric_heat'
  expression = bin_heatsource_soln_func*volumetric_heat
[]

```

### Solid Mechanics Action

This block defines a MOOSE Action that automates the process of setting up the solid mechanics kernel using small strain kinematics. It simplifies the set up by automatically adding displacement variables, handling eigenstrain inputs, and generating auxillary variables for key stress components. This method reduces manual setup by leveraging [solid mechanics action](https://mooseframework.inl.gov/syntax/Physics/SolidMechanics/QuasiStatic/index.html).

```
[Physics/SolidMechanics/QuasiStatic]
  [all]
    add_variables = true
    strain = small
    automatic_eigenstrain_names = true
    generate_output = 'stress_xx stress_yy max_principal_stress vonmises_stress'
    material_output_order = FIRST
    material_output_family = LAGRANGE
  []
[]
```

## Running the model

To run this model using the MOOSE combined module executable, run the following command:

```
mpiexec -n 100 /path/to/app/combined-opt -i msre3D_100percent_INF.i
```

*Note: HPC resources were used to perform this simulation*

The following Exodus results file will be produced: `msre3D_100percent_INF_exodus.e`

The Exodus output file can be visualized with Paraview.
