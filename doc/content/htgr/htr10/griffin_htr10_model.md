# HTR-10 Griffin Neutronics Model

*Contact: Javier Ortensi, Javier.Ortensi@inl.gov*

The HTR-10 is a small pebble-bed test reactor rated at a thermal power
of $10$ MWt intended as a steppingstone for the development of PBR
technology in China.
The HTR-10 is located at the Institute of Nuclear and New Energy
Technology (INET) and achieved initial criticality on
1 December 2000.
The design of the HTR-10 reactor represents the design features of
the modular High-Temperature Gas-cooled Reactor (HTGR) which is
primarily characterized by its inherent safety features.
The reactor geometry is depicted in [htr10_geom].

!media /htr10/htr-10-with-vessel.png
    style=width:80%
    id=htr10_geom
    caption=HTR-10 geometry with vessel [!citep](IRPhEP).

The following discussion of the reactor geometry and the benchmark
based thereon are taken from [!citep](IRPhEP).
This reference discusses the *initial critical*
core configuration of the HTR-10.
Overall, the relevant core for the neutronics, reflector and shielding
regions (everything inside of the boronated carbon bricks and
carbon bricks in [htr10_geom]) are 6.1 meters tall and have a
radius of 1.9 meters; the core containing the pebble bed is
split into the upper part containing the cylindrical core and
the upper cone; and a lower part containing the lower cone and
the discharge tube.
The upper part of the core during the initial critical contains a mix of
16,890 fuel and dummy graphite pebbles with a ratio of 57 : 43,
while the lower part of the core only contains dummy pebbles.
The benchmark report assumes a uniform packing
fraction of 0.61 throughout the whole core.

In addition to the *initial critical* configuration,
Ref.[!citep](TECDOC) describes the *full core* configuration
that features a significantly larger number of pebbles in
the upper core region.
This *full core* configuration is attained by loading more
pebbles starting from the *initial critical* configuration
until the core is capable of being operated at full power.
The volume of the fuel pebbles in the upper core region is
estimated to be $5$ m$^3$; at a packing fraction of $0.61$
and a pebble radius of $3$ cm, this corresponds to $26,992$
pebbles in the upper core region.

# Griffin Model

Griffin is used to model the neutronics of the HTR. This section
will present and describe the input files for the *initial critical*
and *full* cores.

## *Initial Critical* Core

The complete input file for the *initial critical* core is
shown below.

!listing htgr/htr10/steady/htr-10-critical.i

In the following sections, we will discuss each of
the input blocks.

### Model Parameters

Model parameters are specified in this block.
This could include the reactor state point (fuel temperature,
coolant temperature/density, etc.) or reactor
power level.
The cross-section library contains only
one state point, so it is not defined here.

### Global Parameters

Global parameters are parameters that may be referenced
throughout the input file.
This block is user specific with the purpose
to simplify repeated variable entries.
However, be careful to not override a default parameter
option in a later block without meaning to.

Regarding the multi-group cross section file, we define
the library name and file location.
In addition, the cross-section parameterization on the xml file
is set.
Macroscopic cross sections are always defined with the "pseudo"
denomination and a number density value of 1.

If these definitions do not make sense now, we will
clarify their uses and meanings in the subsequent
blocks.


!listing htgr/htr10/steady/htr-10-critical.i
         block=GlobalParams

### Geometry and Mesh

In this section, we will cover the mesh inputs.
The full input block can be found below.

!listing htgr/htr10/steady/htr-10-critical.i
         block=Mesh

The HTR geometry is input into CUBIT, an external code developed at
Sandia National Labs, via a CAD model to generate the computation mesh.
An internal INL tool is used to post-process the mesh to ensure
consistency with the Serpent generated multi-group cross section
library (i.e., material regions and equivalent regions).
The resulting output is an Exodus file that can be read by MOOSE
using the [!style color=orange](FileMeshGenerator) type.
We need to directly specify the ids on the mesh using
[!style color=red](exodus_extra_element_integers)
which will then read in the material ids and equivalent ids
(for the SPH factors).
This is performed with the [!style color=orange](ExtraElementIDCopyGenerator)
type by defining the "eqv_id" as the source and
"equivalence_id" as the target.

!listing htgr/htr10/steady/htr-10-critical.i
         block=fmg

!listing htgr/htr10/steady/htr-10-critical.i
         block=eqvid

Next, we need to make some modifications to the mesh.
In particular, we want to delete non-neutronics relevant
blocks on the original mesh (i.e., the boronated bricks).
This can be performed in two steps: 1) delete the boronated
bricks and 2) define the new boundary.
The deletion of the bricks requires the use of the
[!style color=orange](BlockDeletionGenerator) type.
Here, we select the blocks "3 4 5" that represent the
boronated bricks in the original mesh.
A simple way to identify the block ids is to open the mesh file
`HTR10-critical-c-rev2.e` in an Exodus supported visualization tool
(i.e., ParaView).
Next, we define the new top, bottom, and radial boundary.
The radial boundary or `[./sideset_side]`, in the model,
is given the [!style color=orange](ParsedGenerateSideset) type.
This new boundary is defined by a function introduced in
[!style color=red](combinatorial_geometry) and given a new name with
[!style color=red](new_sideset_name).

The top and bottom boundaries are defined in a similar manner.
Again, the [!style color=orange](ParsedGenerateSideset) type
is used to define a new boundary with a function declared in
[!style color=red](combinatorial_geometry).
The optional parameter, [!style color=red](normal), specifies
the normal vector on sides that are added to the new mesh.
Also note that the [!style color=red](input) parameter
is the sequential order of the named sub-blocks `[./*]`.

!listing htgr/htr10/steady/htr-10-critical.i
         block=Mesh
         remove=fmg eqvid

### Equivalence

!alert note
Equivalence factors for this model are hosted on LFS. Please refer to [LFS instructions](resources/how_to_use_vtb.md#lfs)
to download them.

The Equivalence theory block/action is used to compute or apply
equivalence factors. In this case, Super homogenization factors are applied.
Griffin also supports the use of discontinuity factors.
The equivalence library is first defined with
[!style color=red](equivalance_library) which is an xml file
generated by the ISOXML pre-processing code.
Both the [!style color=red](equivalence_grid_names) and the
[!style color=red](equivalence_grid) are then specified with values
from the equivalence library.
These variables define the SPH factor parameterization.
In this example, the cross-section library consists of only one
state point, defined with the name "default" and grid "1".
These variable names are on the equivalence library xml file.
The "diff", short for diffusion, system will be defined later.

!listing htgr/htr10/steady/htr-10-critical.i
         block=Equivalence

### AuxVariables and AuxKernels

AuxVariables are variables that can be derived from the
solution variables (i.e., scalar flux). An AuxKernel is a
procedure that uses the solution variable to compute
the AuxVariable (i.e., reaction rate).

There are two AuxVariables that are defined in this model:
the absorption reaction rate and the neutron production
reaction rate.

!listing htgr/htr10/steady/htr-10-critical.i
         block=AuxVariables

The AuxKernels are locally defined with the names
`[./AbsorptionRR]` and `[./nuFissionRR]`, and are of
the [!style color=orange](VectorReactionRate) type.
The AuxVariable that the kernel acts on is defined with
[!style color=red](variable). We also give it a
[!style color=red](cross_section) and
[!style color=red](scale_factor).
Lastly, we tell it to
[!style color=red](execute_on) the end of a time step.


!listing htgr/htr10/steady/htr-10-critical.i
         block=AuxKernels

### Materials

!alert note
The cross sections for this model are hosted on LFS. Please refer to [LFS instructions](resources/how_to_use_vtb.md#lfs)
to download them.

Material cross sections are specified with the multi-group
cross section library defined by [!style color=red](library_file)
in the `[GlobalParameters]` block.
In this example, we define three types of materials: fissile,
non-fissile, and TDC.
TDC is short for "tensor diffusion coefficient".
For each of these materials we specify the type as a
[!style color=orange](MixedMatIDNeutronicsMaterial).
This type uses neutronics properties based on mixed isotopes
from the multi-group cross section library.
In this example, we have a pseudo mixture and density that is
defined in the `[GlobalParameters]` block.
The [!style color=orange](MixedMatIDNeutronicsMaterial) type differs
from [!style color=orange](MixedNeutronicsMaterial) because it reads
in the material ids directly from the mesh.
We must specify which blocks are fissile materials with the
[!style color=red](block) card.
For each block id, we also need to identify the densities and isotopes.
For convenience, these parameters were put in the `[GlobalParameters]` block.

In a similar process, non-fissile materials are defined in the
next sub-block.
These could be any regions that have non-fissile materials such
as a reflector, structural materials, etc.
The last sub-block is for materials with a tensor diffusion
coefficient (TDC).

!listing htgr/htr10/steady/htr-10-critical.i
         block=Materials

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
representations of the power density corresponding to the
underlying FEM.

!listing htgr/htr10/steady/htr-10-critical.i
         block=PowerDensity

### Transport System

The transport system is the heart of the Griffin simulation.
We define the transport particle and eigenvalue equation with
[!style color=red](particle) and
[!style color=red](equation_type), respectively.
The number of energy groups is set to "10" with
[!style color=red](G).
Vacuum boundary conditions are imposed on side sets "1 2 3".
The `[./diff]` sub-block defines the method to solve the
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
required to use the "PJFNKMO" method defined later in the
`[Executioner]`.
This tells the finite element solver to not update the material
cross sections at each linear iteration.

!listing htgr/htr10/steady/htr-10-critical.i
         block=TransportSystems

### Executioner

The `[Executioner]` block tells the solver what type of problem
it needs to solve.
Here, we select [!style color=orange](Eigenvalue) as the executioner
type which will solve the eigenvalue problem for the criticality
and multi-group scalar flux (eigenvalue and eigenvectors).
We also specify to solve with a Preconditioned Jacobian Free
Newton Krylov Matrix Only method as shown by setting
[!style color=red](solve_type) equal to "PJFNKMO".
The Matrix Only method forces the solver to not update
material properties (i.e., cross sections) in the linear iterations
of the solve.
To use this solver, the [!style color=red](constant_matrices)
parameter must be set to "true".
There are several optional arguments that may also be included.
For example, we define a few PETSc options and non-linear solver
tolerances.

!listing htgr/htr10/steady/htr-10-critical.i
         block=Executioner

### Post-processors, Debug, and Outputs

The last blocks are for post-processors, debug options, and outputs.
A post-processor can be thought of as a function to derive a variable
of interest from the solution.
For example, the power density.
This is defined with the
[!style color=orange](ElementIntegralVariablePostprocessor)
type and the power density variable we created earlier,
[!style color=red](power_density).
The fissile blocks must be identified to compute the power density with
[!style color=red](block).
Integral properties such as the rate of neutron production, rate of
neutron absorption, and rate of neutron leakage are integrated over each
FEM element in the next two sub-blocks.
The remaining sub-blocks define the total generation with a
[!style color=orange](FluxRxnIntegral) type.

!listing htgr/htr10/steady/htr-10-critical.i
         block=Postprocessors

Finally, the output block sets the output files from the simulation.
Two of the most common options include the exodus and csv file.
The Exodus file can be viewed with the same software as the mesh,
but now will show the solution and solution derived quantities such
as the multi-group scalar flux and power distribution.
The csv file stores a summary of the solution that includes
the criticality.
The [!style color=red](perf_graph) parameter is helpful to evaluate
the computational run time.

!listing htgr/htr10/steady/htr-10-critical.i
         block=Outputs

## *Full Core*

The complete input file for the *full* core is
shown below.

!listing htgr/htr10/steady/htr-10-full.i

The input file to the *full* core is similar to that of the
*initial critical* core. Still, we will examine any
features that were not discussed previously.

### Global Parameters

In this model, there are several multi-group cross
section libraries to choose from.
Each library contains a unique state point at which
Serpent generated homogenized cross sections.
The available options are all rods in (ARI),
all rods out (ARO), one rod in (1RI), and temperatures
at 393K and 523K.
These cross-section libraries are in the "xs" folder.

If equivalence factors are to be used, make sure to select
a library in the "sph" folder that is consistent with the
cross-section library.

!listing htgr/htr10/steady/htr-10-full.i
         block=GlobalParams

## Acknowledgments

This model description section is summarized from [!citep](HTR-10Benchmark) and prepared for the VTB by Thomas Folk.
