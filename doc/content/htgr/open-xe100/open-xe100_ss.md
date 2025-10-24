# Griffin Open Xe-100 Steady-State

## Input Description

Griffin uses a block-structured input syntax. Each block begins with square brackets
that contain the type of input and ends with empty square brackets. Each block
may contain sub-blocks. The blocks in the input file are described in the order
as they appear. Before the first block entries, users can define variables and
specify their values, which are subsequently used in the input model. For example:

`fuel_blocks         = '  1  2  3  4  5  ...'`  # Fuel block identities (IDs).\\ 
`ref_blocks          = '  63  64  65  ...'`     # Reflector block IDs.\\ 
`total_power         = 200.0e+6`                # Total reactor power (W).\\ 
`initial_temperature = 900.0`                   # Initial reactor core temperature (K).

Comments are denoted by the `#` symbol.

Each number in the block ID fields corresponds to a matching subdomain of the
mesh declared in the `Mesh` block. These IDs are used to declare initial
conditions and material properties, and calculate average temperatures for the
specified mesh elements.

!listing htgr/open-xe100/xe100_ss.i

### Global Parameters

This block contains global parameters. In this case, the cross sections from
Serpent in ISOXML format as a `library_file`, `htgr_exp` as a `libary_name`, and
`is_meter = true`, which specifies that the unit of length for the mesh is meters.

!listing htgr/open-xe100/xe100_ss.i block=GlobalParams

### Mesh

This block defines the mesh. The mesh is a 2D representation of the reactor core.
It includes the lower reflector, the cone from which fuel is discharged, the fuel
region, and the upper reflector.

`coord_type` specifies the coordinate system for the mesh. `rz_coord_axis`
specifies the rotation axis for axisymmetric coordinates.

The specified mesh generator has the user defined name `cartesian_mesh` of type
`CartesianMeshGenerator` which takes the following parameters:

`dim`, the number of dimensions.\\ 
`dx`, the number of intervals in the X direction.\\ 
`dy`, the number of intervals in the Y direction.\\ 
`ix`, the number of grids in all intervals in the X direction.\\ 
`iy`, the number of grids in all intervals in the Y direction.\\ 
`subdomain_id`, identification numbers for defined mesh elements in the X-Y plane.

The `subdomain_id` field is formatted to roughly represent the mesh visually;
white space is used to distinguish the different components of the core. By
assigning an identification number to the mesh elements, material properties and
superhomogenized cross sections can be set by identification number.

The next sub-block is named `cartesian_mesh_ids` and is of type
`ExtraElementIDCopyGenerator`. This creates a copy of `subdomain_id` named
`materials_id` which is used by Griffin's `CoupledFeedbackMatIDNeutronicsMaterial`
object for assigning material properties to the mesh elements.

!listing htgr/open-xe100/xe100_ss.i block=Mesh

### AuxVariables

Auxiliary variables are used to set an initial fuel, moderator, and reflector
temperature. Each auxiliary variable is given a user-defined name (Tfuel, Tmod, Tref)
and has the following parameters:

`family`, the type of the finite element shape function to use for this variable.\\ 
`order`, the order of the finite element shape function to use for this variable.\\ 
`initial_condition`, a constant initial condition for this variable.\\ 
`block`, the list of blocks (IDs or names) that this variable will be applied to.

!listing htgr/open-xe100/xe100_ss.i block=AuxVariables

### Materials

Sub-blocks for eachgroup cross section region/material (fuel, reflector, cavity)
are declared here. Each is of type `CoupledFeedbackMatIDNeutronicsMaterial` which
uses coupled variables to interpolate tabulated cross sections provided in the
ISOXML file. The sub-blocks have the following additional parameters:

`grid_names`, the grids in the ISOXML file to interpolate on.\\ 
`grid_variables`, the Griffin variables to associate with the interpolation.\\ 
`plus`, to indicate if absorption, fission, and kappa fission are evaluated.\\ 
`isotopes`, the isotopes that compose the material.\\ 
`densities`, the densities of the isotopes in the material.\\ 
`block`, the list of blocks that this material will be applied to.

The `pseudo` option for `isotopes` indicates that the ISOXML file cross sections
are for a "pseudo" material that is an aggregate. The `density` parameter is
set to 1.0 because of this averaging.

!listing htgr/open-xe100/xe100_ss.i block=Materials

### PowerDensity

A user object block named `PowerDensity` is defined that automatically creates
a power density auxiliary variable such that its integral over the entire fueled
domain is equal to the user-specified power. This object takes the following
parameters:

`power`, the user supplied power, and in this case, the total_power variable is equal
to 200.0e+6 (W).\\ 
`power_density_variable`, the name for the power density variable.\\ 
`integrated_power_postprocessor`, the name for the integrated power postprocessor.\\ 
`family`, the type of the finite element shape function to use for this variable.\\ 
`order`, the order of the finite element shape function to use for this variable.

!listing htgr/open-xe100/xe100_ss.i block=PowerDensity

### UserObjects

User objects are defined to write data to a binary file. These binary files are
read by the null transient and IQS transient runs for their initial conditions.

!listing htgr/open-xe100/xe100_ss.i block=UserObjects

### TransportSystems

The `TransportSystems` block is a Griffin object that provides the variables
and kernels for the diffusion equation, automating the implementation of the
basic conservation equations necessary for this model. Details about the neutron
transport equations can be found in the Griffin theory manual. This block has
the following parameters:

`particle`, the particle type this transport system is for.\\ 
`equation_type`, the type of transport equation.\\ 
`G`, the number of energy groups.\\ 
`ReflectingBoundary`, the reflecting boundary of the model (axisymmetric center).\\ 
`VacuumBoundary`, the vacuum boundaries of the model (remaining edges).

There is a sub-block with the user defined name `diff`, for diffusion.
This is the discretization scheme sub-block and it has the following parameters:

`scheme`, the discretization scheme. In this case, a continuous finite element scheme.\\ 
`n_delay_groups`, the number of delayed neutron groups.\\ 
`assemble_scattering_jacobian`, tells Griffin to include the scattering term
when assembling the Jacobian.\\ 
`assemble_fission_jacobian`, tells Griffin to include the fission term when
assembling the Jacobian.\\ 
`family`, the type of the finite element shape function to use for the transport
system variables.\\ 
`order`, the order of the finite element shape function to use for the transport
system variables.\\ 

!listing htgr/open-xe100/xe100_ss.i block=TransportSystems

### Executioner

The `Executioner` block sets up the problem type and numerical methods used
to solve the neutronics. The Eigenvalue executioner type drives the calculation
for this steady-state eigenvalue problem. This block has the following parameters:

`solve_type`, the solve type for the system.\\ 
`petsc_options_iname`, names of PETSc name/value pairs.\\ 
`petsc_options_value`, values of PETSc name/value pairs.\\ 
`line_search`, specifies the PETSc line search type.\\ 
`l_max_its`, specifies the maximum number of linear iterations.\\ 
`l_tol`, the linear relative tolerance.\\ 
`nl_max_its`, specifies the maximum number of non-linear iterations.\\ 
`nl_rel_tol`, the nonlinear relative tolerance.\\ 
`nl_abs_tol`, the nonlinear absolute tolerance.\\ 
`free_power_iterations`, the number of free power iterations to perform. This is
significant for determining the fundamental mode.

Details about the `Quadrature` sub-block can be read in the MOOSE syntax documentation.

!listing htgr/open-xe100/xe100_ss.i block=Executioner

### Postprocessors

The `PostProcessors` block allows the user to set up calculations of reactor
parameters. This is useful for determining if the model is correctly implemented.
The average temperature of the fuel elements, moderator elements, and reflector
elements are calculated.

!listing htgr/open-xe100/xe100_ss.i block=Postprocessors

### Outputs

Output in various formats are requested or suppressed in this block. Notably,
the `csv` file that can be used for regression testing is requested.

!listing htgr/open-xe100/xe100_ss.i block=Outputs

## Running the Simulation

Griffin can be run on Linux, Unix, MacOS, and Windows in Windows Subsystem
for Linux (WSL). Griffin can be run from the shell prompt as shown below:

```language=bash

griffin-opt -i xe100_ss.i

```

\\ 

### Links

[Griffin Open Xe-100 index](open-xe100/index.md)

[Griffin Open Xe-100 null transient](open-xe100/open-xe100_null.md)

[Griffin Open Xe-100 IQS transient](open-xe100/open-xe100_iqs.md)

[Griffin Open Xe-100 PKE transient](open-xe100/open-xe100_pke.md)

[Griffin Open Xe-100 results](open-xe100/open-xe100_results.md)

[Griffin Open Xe-100 model](https://github.com/idaholab/virtual_test_bed/tree/devel/htgr/open-xe100)