# Model Inputs

The Griffin neutronics input deck for Excercise 1 is described below.

!listing htgr/mhtgr_griffin/benchmark/griffin.i

## Model Parameters

The first block is for model parameters.
This could include the reactor state point (fuel temperature,
coolant temperature/density, etc.), reactor power level, or any
user-desired information.
The cross sections for this model are not parameterized, instead, there only
exists one state point -- provided for the benchmark.
The power for the MHTGR is 350 MW and set with `tpow`.

### Global Parameters

Global parameters are parameters that may be referenced
throughout the input file.
This block is user specific; the purpose is
to simplify repeated variable entries.
However, be careful to not override a default parameter
option in a later block without meaning to.
It is common to provide cross section data for materials in
this block.
Here we include the number of energy groups for the diffusion solver with
[!style color=red](G) = 26.

!listing htgr/mhtgr_griffin/benchmark/griffin.i
         block=GlobalParams

## Geometry and Mesh

The mesh block reads in the provided Exodus mesh file.
Using the [!style color=orange](FileMeshGenerator) type, the mesh file
is identified with the [!style color=red](file) parameter.
It is common to read in the material IDs directly from the mesh if they are provided.
However, in this case, the mesh does not hold the material ids and these will be
specified in the `[Materials]` block.

!alert note
Exodus files can be viewed with an Exodus supported visualization tool (i.e. ParaView).
This allows the visualization of the computational mesh.
It also allows for easy identification of material and equivalent ids (if provided).

!listing htgr/mhtgr_griffin/benchmark/griffin.i
         block=Mesh

## Functions

User specified functions are defined in this block.
Here, we construct a function for a periodic boundary condition that
will be applied to the core segment sides of the symmetric problem.
This is accomplished using a [!style color=orange](ParsedFunction)
acting on the Cartesian coordinates specified with [!style color=orange](value).
The periodic boundary condition is imposed onto the left and right core
segments with a sin/cosine function.

!listing htgr/mhtgr_griffin/benchmark/griffin.i
         block=Functions

## Materials and User Objects

The materials block allows the user to link the cross-section library to the
computational mesh.
There are many material types that may be used.
Here, we specify the [!style color=orange](ConstantNeutronicsMaterial) type because
the cross sections are fixed for this exercise of the benchmark.
The [!style color=red](material_id) on the cross-section library is then linked
to the corresponding [!style color=red](block) on the computational mesh.

Notice that the material blocks are grouped by the axial level in the core
(provided by the benchmark): level 1 to level 10.

!listing htgr/mhtgr_griffin/benchmark/griffin.i
         block=Materials

The user objects block allows the user to develop custom objects.
Here, we define a block-wise map of reaction rates with the
[!style color=orange](FluxCartesianCoreMap) type.
In this case, the [!style color=orange](FluxCartesianCoreMap)
generates the fission neutron production rate,
power density, neutron absorption rate,
total neutron flux, and the group-wise neutron fluxes
for each block.

!listing htgr/mhtgr_griffin/benchmark/griffin.i
         block=UserObjects

The power density is not calculated implicitly and must be defined in
the `[PowerDensity]` block.
This block provides the power density with a user specified power and
the proper flux scaling factor in the postprocessor.
The two required arguments are [!style color=red](power) and
[!style color=red](power_density_variable).
The power is in units of Watts.
The [!style color=red](power_density_variable) simply sets
the variable name.
Optional arguments include the post-processors to use.
The [!style color=red](integrated_power_postprocessor) sets the
desired name for the integrated power post-processor.
Likewise, the [!style color=red](power_scaling_postprocessor)
sets the desired name for the power scaling post-processor.
Lastly, the family and order parameters are the polynomial
representations  of the power density corresponding to the
underlying FEM.

!listing htgr/mhtgr_griffin/benchmark/griffin.i
         block=PowerDensity

### Transport System

The transport system is the heart of the Griffin simulation.
We define the transport particle and eigenvalue equation with
[!style color=red](particle) and
[!style color=red](equation_type), respectively.
The number of energy groups is set to "26" in `[GlobalParameters]`.
Vacuum boundary conditions are imposed on side sets "3 4 5":
the top, bottom, and outer radial reflector boundaries.
Reflective boundary conditions are applied to side sets "1 2":
the core segments of the symmetric problem.
The reflective boundary conditions are overridden by the periodic
boundary defined in `[Functions]`.

The `[diff]` sub-block defines the method to solve the
problem.
We use Griffin's diffusion method built on the MOOSE
continuous finite element method solver.
Finite element parameters are set with the
[!style color=red](family) and
[!style color=red](order), which define the family of
functions used to approximate the solution and
polynomial order.
The last two options,
[!style color=red](assemble_scattering_jacobian) and
[!style color=red](assemble_fission_jacobian) are
required to use the "PJFNKMO" method defined in the
`[Executioner]`.
This tells the finite element solver to not update the material
cross sections at each linear iteration.

!listing htgr/mhtgr_griffin/benchmark/griffin.i
         block=TransportSystems

## Executioner

The `[Executioner]` block lets the user specify the type of problem to solve.
Here, we select an [!style color=orange](Eigenvalue) problem
which will solve for the criticality and multi-group scalar flux
(eigenvalue and eigenvectors).
We also specify to solve with a Preconditioned Jacobian Free
Newton Krylov Matrix Only method by setting
[!style color=red](solve_type) equal to "PJFNKMO".
The Matrix Only method forces the solver to not update
material properties (i.e., cross sections) in the linear iterations
of the solve.
To use this solver, the [!style color=red](constant_matrices)
parameter must be set to "true".

There are optional arguments that may also be included.
For example, we first define a few PETSc options.
The maximum number of inner iterations is set with
[!style color=red](l_max_its) which is advised for a large number
of energy groups (26 in this case).
The free power iteration scheme provides an educated initial guess of
the solution.
We set the number of [!style color=red](free_power_iterations) to 2.

!listing htgr/mhtgr_griffin/benchmark/griffin.i
         block=Executioner

### Post-processors, Debug, and Outputs

The last blocks are for post-processors, debug options, and outputs.
A post-processor can be thought of as a function to derive a variable
of interest from the solution.
For example, the power density.
This is defined with the
[!style color=orange](ElementIntegralVariablePostprocessor)
type and the power density variable we created earlier ([!style color=red](power_density)).
The blocks -- with fissile material -- at which the power density should
be computed are defined with [!style color=red](block).
Finally, the [!style color=red](execute_on) parameter
sets the time of execution.
In this case, the initial time step and at the end of each subsequent time step.

!listing htgr/mhtgr_griffin/benchmark/griffin.i
         block=Postprocessors

The debug options can be helpful when debugging a case.
These are a set of true (1) and false (0) options to print statements.

!listing htgr/mhtgr_griffin/benchmark/griffin.i
         block=Debug

The last block executes the output files from the simulation.
Two of the most common options include the exodus and csv file.
The Exodus file can be viewed with the same software as the mesh,
but now will show the solution and solution derived quantities such
as the multi-group scalar flux and power distribution.
The csv file stores a summary of the solution that includes
the criticality.
The [!style color=red](perf_graph) parameter is helpful to evaluate
the computational run time.

!listing htgr/mhtgr_griffin/benchmark/griffin.i
         block=Outputs

# How to run the model

The model can be run with Griffin in serial or parallel.

Run it via:

 `griffin-opt -i griffin.i`

 `mpirun -n 16 griffin-opt -i griffin.i`

