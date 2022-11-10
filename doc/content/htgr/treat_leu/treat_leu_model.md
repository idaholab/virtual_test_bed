# LEU Fuel Pulse

*Contact: Adam Zabriskie, Adam.Zabriskie@inl.gov*

## Model Description

This model represents a greatly simplified version of the Transient Reactor Test Facility (TREAT).
The model explores the effect on pulse feedback mechanisms from microscale heterogeneity represented by hypothetical 20 $\mu$m LEU fuel grains.
This model couples the heat equation with the neutron governing equation for temperature feedback during a short pulse.
The pulse is produced by inserting a reactivity of 4.56 % $\Delta$ k/k.
The model's simplified geometry consists of a homogeneous cube of TREAT-like fuel surrounded by a cube shell reflector.
The simplified geometry has no cladding, coolant channels, or other structures [!citep](zabriskie2019).
To reduce computation costs, symmetric boundaries are applied to a 1/8th quadrant of the simplified reactor, which is shown in [cube].
Outer boundaries on the reflector have vacuum and adiabatic boundary conditions for neutron and heat transport.

!media /htgr/pulse/refcube.png
       style=width:50%
       id=cube
       caption=TREAT model octant

The dimensions of the macro-scale simulation model are given in [cubedim], and the fuel grain characteristics are given in [fgdim].

!table id=cubedim caption=Reflected cube reactor dimensions.
|  Characteristic | Value (cm) |
| :- | :- |
| Reactor side length | $135.17$ |
| Reflector thickness | $60.97$ |
| Total side length | $257.09$ |
| Core mesh element cube length | $5.006$ |
| Reflector mesh element cube length | $5.08$ |

!table id=fgdim caption=20 $\mu$m radius LEU fuel grain characteristics.
|  Characteristic | Value ($\mu$m) |
| :- | :- |
| Fuel grain radius | $20$ |
| Outer boundary radius | $172.76$ |
| Moderator transition thickness | $20$ |
| Moderator shell total thickness | $253$ |
| Moderator shell boundary thickness | $273$ |
| Fuel grain mesh element | $2$ |
| Moderator transition mesh element | $2$ |
| Moderator regular mesh element | $3$ |

The neutronics analysis is performed on a mesh characterized by centimeter-sized elements, while grain treatment is on the micrometer element scale where heat conduction problems are solved on microscopic domains encompassing a single fuel grain and a proportional amount of graphite.
This model makes use of the Griffin code for neutron transport and MOOSE heat conduction modules for heat transport and radiation. Serpent 2 was used to prepare cross section libraries
[!citep](zabriskie2019), [!citep](doi:10.1080/00295639.2018.1528802).

The particles are spaced $13.52$ cm apart in a regular grid lattice, and are spaced half that distance when next to a boundary.
There are $125$ particles in each octant of the full reactor.

The power density, calculated from the sampled flux at each location, is transferred to a single microscale simulation.

The MOOSE MultiApp system handles the multiscale and information transfer needs of the simulation.
The macroscale simulation provides the average temperature at each microscale simulation location as an outer boundary condition. With the sampled flux at each location and this outer boundary condition, the thermal solution of each microscale grain provides an average moderator shell temperature and fuel grain temperature to the locations in the macroscale simulation. These average temperatures then adjust the cross section, providing temperature feedback.

## Input Files

There are four input files for this model.

## Transient Pulse Initial Conditions

This input file sets the initial conditions from which the transient pulse starts.

!alert note
Some code blocks appearing in this file also appear in other files. For brevity, these common blocks are only shown in this first input file, but they will be mentioned in each input file that they appear.

### Mesh

This block creates the mesh used for the simplified reactor.

!listing htgr/treat_leu/init_refcube.i block=Mesh language=cpp

### TransportSystems

This block sets up the neutron transport governing equation in the diffusion approximation form to be used in the simulation.

!listing htgr/treat_leu/init_refcube.i block=TransportSystems language=cpp

### AuxVariables

This block sets up the auxilliary variables that will be calculated and tracked throughout the runtime of the simulation.

!listing htgr/treat_leu/init_refcube.i block=AuxVariables language=cpp

### AuxKernels

This block defines the equations used to calculate auxilliary values for use in the simulation.

!listing htgr/treat_leu/init_refcube.i block=AuxKernels language=cpp

### Postprocessors

This block processes simulation solution data for output.

!listing htgr/treat_leu/init_refcube.i block=Postprocessors language=cpp

### Materials

This block sets up the material properties for use in the governing equations.
The files [!style color=blue](`leu_20r_is_6g_d.xml`) and [!style color=blue](`leu_macro_6g.xml`) contain the cross sections.

!listing htgr/treat_leu/init_refcube.i block=Materials language=cpp

### Preconditioner

This block describes the preconditioner used by the solver.

!listing htgr/treat_leu/init_refcube.i block=Preconditioning language=cpp

### Executioner

This block describes the simulation solution approach.

!listing htgr/treat_leu/init_refcube.i block=Executioner language=cpp

## Adjoint initial conditions

This input file provides the values needed to calculate the point kinetics equation parameters.

This input file is also almost identical to the previous input file, with a few alterations:

- In the `Mesh` block, a different name is used for the mesh.
- In the `TransportSystems` block, the input `for_adjoint` is set to `true`.
- In the `AuxVariables` block, `[Boron_Conc]` sub-block, `initial_condition` is set to 2.0.

## Microscale Particles

This input file describes a microscale particle heat solution. This input is replicated at many locations in the macroscale simulation.

### Mesh

This block sets the meshes for the fission damage layer and fuel grain.

!listing htgr/treat_leu/ht_20r_leu_fl.i block=Mesh language=cpp

### Variables

This block sets the temperature variable of the governing equation.

!listing htgr/treat_leu/ht_20r_leu_fl.i block=Variables language=cpp

### Kernels

This block defines the heat conduction governing equation.

!listing htgr/treat_leu/ht_20r_leu_fl.i block=Kernels language=cpp

### AuxVariables

This block sets up the power density and integrated power auxilliary variables.

!listing htgr/treat_leu/ht_20r_leu_fl.i block=AuxVariables language=cpp

### AuxKernels

This block calculates needed auxilliary values during the simulation.

!listing htgr/treat_leu/ht_20r_leu_fl.i block=AuxKernels language=cpp

### Postprocessors

This block calculates outputs from solution data.

!listing htgr/treat_leu/ht_20r_leu_fl.i block=Postprocessors language=cpp

### Materials

This block contains material properties used in the governing equation.

!listing htgr/treat_leu/ht_20r_leu_fl.i block=Materials language=cpp

### Preconditioning

This block is identical to the `[Preconditioning]` block in the Transient Pulse Initial Conditions file.

### Executioner

This block describes the simulation solution approach.

!listing htgr/treat_leu/ht_20r_leu_fl.i block=Executioner language=cpp

## Main Input File

This is the controlling input file that must be run.
All other input files are controlled by the MultiApp system in the main input file.

### Mesh

This block is almost identical to the `Mesh` block in the Transient Pulse Initial Conditions file, with a different name used for the mesh.

### MultiApps

This block defines the MOOSE MultiApp system.
The file [!style color=blue](`refcube_sub_micro.txt`) is a list of coordinates for the positions of each of the 125 fuel grains.

!listing htgr/treat_leu/refcube.i block=MultiApps language=cpp

### Transfers

This block defines the passing of solution data between MultiApp simulations.

!listing htgr/treat_leu/refcube.i block=Transfers language=cpp

### TransportSystems

This block is almost identical to the `TransportSystems` block in the Transient Pulse Initial conditions file, with the exception being that `equation_type` is set to `transient`.

### Variables

This block sets the temperature variable of the governing equation.

!listing htgr/treat_leu/refcube.i block=Variables language=cpp

### Kernels

This block defines the heat conduction governing equation.

!listing htgr/treat_leu/refcube.i block=Kernels language=cpp

### Functions

This block is used to insert reactivity to start the pulse from the initial conditions.

!listing htgr/treat_leu/refcube.i block=Functions language=cpp

### AuxVariables

This block sets up the power density, integrated power, and other auxilliary variables

!listing htgr/treat_leu/refcube.i block=AuxVariables language=cpp

### AuxKernels

This block defines the equations used to calculate auxilliary values for use in the simulation.

!listing htgr/treat_leu/refcube.i block=AuxKernels language=cpp

### Postprocessors

This block calculates outputs from solution data.

!listing htgr/treat_leu/refcube.i block=Postprocessors language=cpp

### UserObjects

The `Terminator` user object calculates when the simulation concludes.

!listing htgr/treat_leu/refcube.i block=UserObjects language=cpp

### Materials

This block contains material properties used in the governing equation.

!listing htgr/treat_leu/refcube.i block=Materials language=cpp

### Preconditioning

This block is identical to the `[Preconditioning]` block in the Transient Pulse Initial Conditions file.

### Executioner

This block describes the simulation solution approach.

!listing htgr/treat_leu/refcube.i block=Executioner language=cpp

## Run Command

Use this command to run the main input file.

```
mpirun -np 48 /path/to/griffin-opt -i refcube.i
```

## Output Files

When the main input file is run, many output files will be generated.

Most of these have the format [!style color=blue](`out~refcube_micro_<number>`) as either CSV (.csv) or Exodus (.e) files.
These files are output by the main input file.
These files contain the postprocessor values specified in the `[Postprocessor]` block for each of the fuel grains.
The main input file will also output a CSV file containing the PKE parameters, called [!style color=blue](`out~refcube_pke_params.csv`).

Each of the four input files will output a CSV file and an Exodus file in the format [!style color=blue](`<input_file_name>_out.csv`) or [!style color=blue](`<input_file_name>_exodus.e`).
These files will contain the postprocessor values specified in the corresponding `[Postprocessor]` block.