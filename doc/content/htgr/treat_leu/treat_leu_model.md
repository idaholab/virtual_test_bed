# TREAT-like LEU Model: DRAFT

*Contact: Adam Zabriskie, Adam.Zabriskie@inl.gov*

## Model Description

This model represents a greatly simplified version of the Transient Reactor Test Facility (TREAT) that simulates the effect of a power pulse on a single 20 $\mu$m LEU fuel grain with an inserted reactivity of 4.56 % $\Delta$k/k.
The model's simplified geometry consists of a single, unit cell TREAT fuel element surrounded by a cube shell reflector, excluding air channels and cladding.
Reflective boundaries are applied on the left, right, front, and back boundaries (±x, ±y), while the top and bottom of the fueled portion of the fuel element are covered by a graphite reflector with vacuum boundary conditions.

The neutronics analysis is performed on a mesh characterized by centimeter-sized elements, while grain treatment is on the micrometer element scale where heat conduction problems are solved on microscopic domains encompassing a single fuel grain and the proportional amount of graphite.
This model makes use of the Griffin code for neutronics and radiation transport, as well as Serpent 2 for calculation of cross-sections.
[!citep](zabriskie2019), [!citep](doi:10.1080/00295639.2018.1528802). 
The dimensions of the fuel element are given in [dim].
[!citep](doi:10.1080/00295639.2018.1528802)

!table id=dim caption=Fuel element model dimensions.
|  Characteristic | Value (cm) |
| :- | :- |
| Fuel element cross-section length | 9.65 |
| Fuel element cross-section width | 9.65 |
| Fueled height | 120.97 |
| Top reflector height | 65.98 |
| Bottom reflector height | 65.98 |
| Macroscale mesh element length | 2.41 |
| Macroscale mesh element width | 2.41 |
| Macroscale mesh element height | 5.50 |

Four equidistant locations on the x-y plane 2.413 cm from the x-z and y-z edge of the simplified fuel element are spaced every 10.997 cm in the z-direction in the fuel starting 5.498 cm from the graphite reflector.
Thus, 44 locations within the fueled region of the fuel element are selected as sites for the microsimulations.
The power density, calculated from the sampled flux at each location, is transferred to a single microscale simulation.
A transition region next to the fuel grain in the moderator shell features mesh elements of a different size than found in the rest of the moderator shell.

The MOOSE MultiApp system handles the multiscale and information transfer needs of the proposed method.
To supply the macrosimulation with the informed feedback temperature, the average temperature value of the graphite, the fuel grain, or both are transferred to the macrodomain from each microsimulation.

## Input Files

There are four input files for this model.
The first three files must be run before the main file to initialize the meshes and perform other necessary tasks.

## Transient Pulse Initial Conditions (init_refcube.i)

This input file sets the initial conditions from which the transient pulse starts.

*Note: some code blocks appearing in this file also appear in other files. For brevity, these common blocks are only shown in this first section, but they will be mentioned in each section that they appear.*

### Mesh

This block creates the mesh used for the unit cell reactor.
Identical `Mesh` blocks also appear in the PKE parameters and Main input files.

!listing htgr/treat_leu/treat_leu_final/init_refcube.i block=Mesh language=cpp

### TransportSystems

This block sets up the radiation transport to be used in the simulation (?)

!listing htgr/treat_leu/treat_leu_final/init_refcube.i block=TransportSystems language=cpp

### AuxVariables

This block sets up the variables that will be calculated and tracked throughout the runtime of the simulation.

!listing htgr/treat_leu/treat_leu_final/init_refcube.i block=AuxVariables language=cpp

### AuxKernels

This block defines the equations used to calculate some of the previously defined `AuxVariables`.

!listing htgr/treat_leu/treat_leu_final/init_refcube.i block=AuxKernels language=cpp

### Postprocessors

This block concerns the variables that will be output by the simulation. Here, (?)

!listing htgr/treat_leu/treat_leu_final/init_refcube.i block=Postprocessors language=cpp

### Materials

This block sets up the material properties for the reflector (?)

!listing htgr/treat_leu/treat_leu_final/init_refcube.i block=Materials language=cpp

### Preconditioner

This block describes the preconditioner used by the solver. (?)

!listing htgr/treat_leu/treat_leu_final/init_refcube.i block=Preconditioning language=cpp

### Executioner

This block describes the calculation process flow. The user can specify
the start time, end time, time step size for the simulation. Other inputs
in this block include PETSc solver options, convergence tolerance,
quadrature for elements, etc. which can be left unchanged.

!listing htgr/treat_leu/treat_leu_final/init_refcube.i block=Executioner language=cpp

### Outputs

This block defines the types of outputs, such as CSV files or `ExodusII` files, that the simulation will produce. It also specifies whether there will be output printed onto the console.

!listing htgr/treat_leu/treat_leu_final/init_refcube.i block=Outputs language=cpp

## PKE Parameters (adj_refcube.i)

This input file calculates the point kinetics equation parameters that describe the pulse that was set up in the previous input file.

This input file is also almost identical to the previous input file, with a few alterations that will be described below.

In the `Mesh` block a different name is used for the mesh.\\
In the `TransportSystems` block, the input `for_adjoint` is set to `true`.\\
In the `AuxVariables` block, `[./Boron_Conc]` sub-block, `initial_condition` is set to 2.0.

## Microscale Particles (ht_20r_leu_fl.i)

This input file describes microscale particles that affect heat transport from generation.

### Problem

This block defines the coordinates in which the heat transport will be solved.

!listing htgr/treat_leu/treat_leu_final/ht_20r_leu_fl.i block=Problem language=cpp

### Mesh

This block sets the meshes for the fission damage layer and fuel grain.

!listing htgr/treat_leu/treat_leu_final/ht_20r_leu_fl.i block=Mesh language=cpp

### Variables

This block sets the temperature variable for use in calculating the temperatures of the fuel grain and moderator (?)

!listing htgr/treat_leu/treat_leu_final/ht_20r_leu_fl.i block=Variables language=cpp

### Kernels

This block defines the heat conduction and heat source equations (?)

!listing htgr/treat_leu/treat_leu_final/ht_20r_leu_fl.i block=Kernels language=cpp

### AuxVariables

This block sets up the power density and integrated power variables (?)

!listing htgr/treat_leu/treat_leu_final/ht_20r_leu_fl.i block=AuxVariables language=cpp

### AuxKernels

This block does something related to calculating the integrated power and power density (?)

!listing htgr/treat_leu/treat_leu_final/ht_20r_leu_fl.i block=AuxKernels language=cpp

### Postprocessors

This block sets different variables whose values will be stored in the output CSV and Exodus files (?)

!listing htgr/treat_leu/treat_leu_final/ht_20r_leu_fl.i block=Postprocessors language=cpp

### Materials

This block contains the material properties for the pure graphite, fission damaged graphite, and fuel grain portions of the simulation.

!listing htgr/treat_leu/treat_leu_final/ht_20r_leu_fl.i block=Materials language=cpp

### Preconditioning

This block is identical to the `Preconditioning` block in the Transient Pulse Initial Conditions file.

### Executioner

This block does something related to actually solving the various equations (?)

!listing htgr/treat_leu/treat_leu_final/ht_20r_leu_fl.i block=Executioner language=cpp

### Outputs

This block is identical to the `Outputs` block in the Transient Pulse Initial Conditions file.

## Main Input File (refcube.i)

This is the main input file that runs the overall simulation.

### Mesh

This block is almost identical to the `Mesh` block in the Transient Pulse Initial conditions file, with a different name used for the mesh.

### MultiApps

This block creates different applications that are used to focus on different parts of the simulation (?) - needs more detail

!listing htgr/treat_leu/treat_leu_final/refcube.i block=MultiApps language=cpp

### Transfers

This block does something related to transferring data and variables between the different applications (?)

!listing htgr/treat_leu/treat_leu_final/refcube.i block=Transfers language=cpp

### TransportSystems

This block is almost identical to the `TransportSystems` block in the Transient Pulse Initial conditions file, with the exception being that `equation_type` is set to transient.

### Variables

This block does something related to variables - not sure of the difference between Variables and AuxVariables (?)

!listing htgr/treat_leu/treat_leu_final/refcube.i block=Variables language=cpp

### Kernels

This block does something related to setting up the equations that the Variables correspond to - also not sure of the difference between Kernels and AuxKernels (?)

!listing htgr/treat_leu/treat_leu_final/refcube.i block=Kernels language=cpp

### Functions

This block does something (?)

!listing htgr/treat_leu/treat_leu_final/refcube.i block=Functions language=cpp

### AuxVariables

This block does something related to defining the variables that are used in the simulation (?)

!listing htgr/treat_leu/treat_leu_final/refcube.i block=AuxVariables language=cpp

### AuxKernels

This block does something related to the equations that make use of the AuxVariables (?)

!listing htgr/treat_leu/treat_leu_final/refcube.i block=AuxKernels language=cpp

### Postprocessors

Thi block has something to do with defining variables that will be output with the CSV and Exodus files (?)

!listing htgr/treat_leu/treat_leu_final/refcube.i block=Postprocessors language=cpp

### UserObjects

This block is a custom object, designed by the user to shut down the pulse when it is over.

!listing htgr/treat_leu/treat_leu_final/refcube.i block=UserObjects language=cpp

### Materials

Tis block defines material properties for the reflectors - need more detail (?)

!listing htgr/treat_leu/treat_leu_final/refcube.i block=Materials language=cpp

### Preconditioning

This block is identical to the `Preconditioning` block in the Transient Pulse Initial Conditions file.

### Executioner

This block sets the length and growth factor of the timesteps, as well as various tolerances - need more detail (?)

!listing htgr/treat_leu/treat_leu_final/refcube.i block=Executioner language=cpp

### Outputs

This block is identical to the `Outputs` block in the Transient Pulse Initial Conditions file.