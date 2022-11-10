# Model Inputs

The Griffin neutronics input deck for Excercise 1 is described below.

!listing htgr/mhtgr/griffin.i

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
For example, the [!style color=red](library_file), [!style color=red](fromFile),
[!style color=red](is_meter), and [!style color=red](plus) parameters
are all defined for the [!style color=orange](ConstantNeutronicsMaterial) type,
introduced later in the `[Materials]` block.
The [!style color=red](library_file) simply links the cross-section library xml file,
[!style color=red](is_meter) specifies that the cross sections are in units of meters,
and [!style color=red](fromFile) indicates that the cross sections are provided via an
external file.
The [!style color=red](plus) card indicates that absorption, fission, and
kappa fission cross sections are to be used (for fissile materials).
We also include the number of energy groups for the diffusion solver with
[!style color=red](G) = 26.

!listing htgr/mhtgr/griffin.i
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

!listing htgr/mhtgr/griffin.i
         block=Mesh

## Functions

User specified functions are defined in this block.
Here, we construct a function for a periodic boundary condition that
will be applied to the core segment sides of the symmetric problem.
This is accomplished using a [!style color=orange](ParsedFunction)
acting on the Cartesian coordinates specified with [!style color=orange](value).
The periodic boundary condition is imposed onto the left and right core
segments with a sin/cosine function.

!listing htgr/mhtgr/griffin.i
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

!listing htgr/mhtgr/griffin.i
         block=Materials

The user objects block allows the user to develop custom objects.
Here, we define a block-wise map of reaction rates with the
[!style color=orange](FluxCartesianCoreMap) type.
In this case, the [!style color=orange](FluxCartesianCoreMap)
generates the fission neutron production rate,
power density, neutron absorption rate,
total neutron flux, and the group-wise neutron fluxes
for each block.

!listing htgr/mhtgr/griffin.i
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

!listing htgr/mhtgr/griffin.i
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

!listing htgr/mhtgr/griffin.i
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

!listing htgr/mhtgr/griffin.i
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

!listing htgr/mhtgr/griffin.i
         block=Postprocessors

The debug options can be helpful when debugging a case.
These are a set of true (1) and false (0) options to print statements.

!listing htgr/mhtgr/griffin.i
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

!listing htgr/mhtgr/griffin.i
         block=Outputs

# How to run the model

The model can be run with Griffin in serial or parallel.
In parallel, with 16 Xeon Platinum 8268 processors,
the solve takes approximately 2 minutes and 4 seconds.

Run it via:

 `griffin-opt -i griffin.i`

 `mpirun -n 16 griffin-opt -i griffin.i`

The performance is shown below.

|                                Section                               | Calls |   Self(s)  |   Avg(s)   |    %   | Mem(MB) |  Total(s)  |   Avg(s)   |    %   | Mem(MB) |
| - | - | - | - | - | - | - | - | - | - |
| GriffinApp (main)                                                    |     1 |      0.025 |      0.025 |   0.02 |       4 |    123.616 |    123.616 | 100.00 |    1535 |
|   Action::SetupMeshAction::Mesh::SetupMeshAction::act::setup_mesh    |     1 |      0.001 |      0.001 |   0.00 |       0 |      0.001 |      0.001 |   0.00 |       0 |
|   Action::SetupMeshAction::Mesh::SetupMeshAction::act::set_mesh_base |     2 |      0.000 |      0.000 |   0.00 |       0 |      0.000 |      0.000 |   0.00 |       0 |
|   MooseApp::executeMeshGenerators                                    |     1 |      0.000 |      0.000 |   0.00 |       0 |      0.000 |      0.000 |   0.00 |       0 |
|   Eigenvalue::final                                                  |     1 |      0.000 |      0.000 |   0.00 |       0 |      0.001 |      0.001 |   0.00 |       0 |
|     EigenProblem::outputStep                                         |     1 |      0.001 |      0.001 |   0.00 |       0 |      0.001 |      0.001 |   0.00 |       0 |
|   EigenProblem::computeUserObjects                                   |     2 |      0.341 |      0.170 |   0.28 |       0 |      0.341 |      0.170 |   0.28 |       0 |
|   EigenProblem::computeUserObjects                                   |     2 |      0.384 |      0.192 |   0.31 |       0 |      0.384 |      0.192 |   0.31 |       0 |
|   EigenProblem::outputStep                                           |     2 |      0.002 |      0.001 |   0.00 |       0 |      0.698 |      0.349 |   0.56 |       5 |
|     Exodus::outputStep                                               |     2 |      0.693 |      0.347 |   0.56 |       5 |      0.693 |      0.347 |   0.56 |       5 |
|   Eigenvalue::PicardSolve                                            |     1 |      0.001 |      0.001 |   0.00 |       0 |    102.708 |    102.708 |  83.09 |     577 |
|     EigenProblem::computeUserObjects                                 |     1 |      0.667 |      0.667 |   0.54 |       0 |      0.667 |      0.667 |   0.54 |       0 |
|     EigenProblem::outputStep                                         |     1 |      0.001 |      0.001 |   0.00 |       0 |      0.001 |      0.001 |   0.00 |       0 |
|     EigenProblem::solve                                              |     1 |     67.458 |     67.458 |  54.57 |     339 |    101.805 |    101.805 |  82.36 |     576 |
|       EigenProblem::computeUserObjects                               |     2 |      0.379 |      0.190 |   0.31 |       0 |      0.379 |      0.190 |   0.31 |       0 |
