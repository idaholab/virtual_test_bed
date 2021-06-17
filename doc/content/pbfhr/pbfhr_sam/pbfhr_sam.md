# Introduction

The SAM [!citep](Hu2017) input files (`PBFHR-SS.i` for steady state and
`PBFHR-TR.i` for loss of flow transient) were built to model the +Mark 1+
pebble-bed fluoride-salt-cooled high temperature reactor (FHR)
which was developed by the University of California Berkeley [!citep](Andreades2014).  
A schematic of the reactor is shown in [pbfhr_model].  
FHRs exhibit different thermal hydraulic phenomenon compared to conventional
advanced nuclear reactor concepts, such as decay heat removal through
natural circulation using Direct Reactor Auxiliary Cooling System (DRACS) loops.
Therefore, there is a need for modeling and simulation tools to accurately
predict the thermal response of FHRs for a range of postulated transient events.
This study focuses on modeling the FHR core under normal operation and
a loss of forced flow with SCRAM event [!citep](Ahmed2017).

The output files consist of: (1) a `csv` file that writes all user-specified variables
at each time step; (2) a checkpoint folder that saves the snapshots of
the simulation data including all meshes, solutions, and stateful object data.
They are saved for restarting the run if needed; and (3) a `ExodusII` file that
also has all mesh and solution data. Users can use Paraview to visualize
the solution and analyze the data. This tutorial describes the content of
the input file, the output files and how the model can be run using the SAM code.

!media pbfhr/pbfhr_system.png
       style=width:80%
       id=pbfhr_model
       caption=Mk-1 PB-FHR schematic (used with permission, [!cite](Andreades2014)).

# Input File Description

SAM uses a block-structured input syntax. Each block begins with
square brackets which contain the type of input and ends with
empty square brackets. Each block may contain sub-blocks. The blocks in
the input file are described in the order as they appear in the input file.

## Global Parameters

This block contains the parameters such as global initial pressure,
velocity, and temperature conditions, the scaling factors for
primary variable residuals, etc.  For example, to specify global pressure
of 1.e5 Pa, the user can input

```language=bash
global_init_P	 = 	1.e5
```

This block also contains a sub-block `PBModelParams` which specifies
the modeling parameters associated with the primitive-variable based fluid model.
New users should leave this sub-block unchanged.

## EOS

This block specifies the Equation(s) of State. The user can choose from
built-in fluid libraries for common fluids like air, nitrogen, helium, sodium,
molten salts, etc. The user can also input the properties of the fluid
as constants or function of temperature. For example,
the built-in eos for FLIBE can be input as

!listing pbfhr/sam_model/pbfhr-ss.i block=eos language=cpp

## MaterialProperties

Material properties are input in this block. The values can be constants or
temperature dependent as defined in the Functions block. For example,
the properties of stainless steel are input as

!listing pbfhr/sam_model/pbfhr-ss.i block=ss-mat language=cpp

Note that all units are in SI by default.

## Functions

Users can define functions for parameters used in the model.
These include temporal, spatial, and temperature dependent functions.
For example, users can input enthalpy as a function of temperature,
power history as a function of time, or power profile as a function of position.
The input below specifies decay heat as a function of time

!listing pbfhr/sam_model/pbfhr-ss.i block=shutdownPower language=cpp

## Components

This is the main block in the input file. It provides the specifications
for all components that make up the DRACS and primary loops. The primary loop,
shown schematically in [pbfhr_nodalization],
consists of three branches: core, DRACS heat exchanger (DHX), and coiled tube air heater (CTAH).
The components and their nodalization IDs in each branch are listed in [fhr_components].
The nodalization IDs are also specified in the input file.  
The main components in the primary loop are a reactor, the core channel,
a heat exchanger, pump, plena, tank, and piping. The reactor power and
decay heat profile are user-input

!listing pbfhr/sam_model/pbfhr-ss.i block=reactor language=cpp

The core channel is modeled using `PBCoreChannel` in which
the cylindrical fuel elements are modeled as three heat structures:
fuel sandwiched between an inner and outer material (h451).
The thickness of each structure is specified by the user and
because power is generated only in the fuel, the power fraction in the three structures
are input as `‘0 1 0’`. The power distribution in the axial direction is defined
by the user in the `Paxial` function. Explanation for other input variables
can be found in the user manual.

!media pbfhr/pbfhr_nodalization.png
       style=width:80%
       id=pbfhr_nodalization
       caption=Nodalization of the primary loop model in SAM model (used with permission, [!cite](Zweibaum2015))

!table id=fhr_components caption=Components in Mk-1 PB-FHR Primary and DRACS loops.
| Components | Details  |   |   |   |
| :- | :- | :- | :- | :- |
| +Core branch+ |   |   |   |   |
| Pebble bed | 1 | 4.58 | 0.03 | 1.33 |
| Core bypass | 2 | 4.58 | 0.01 | 0.133 |
| Hot salt collection ring | 3 | 3.96 | 0.567 | 0.252 |
| Hot salt extraction pipe | 4 | 3.77 | 0.566 | 0.251 |
| Branch | 26 | 0.5 | 0.58 | 0.264 |
| +CTAH branch+ |   |   |   |   |
| Reactor vessel to hot salt well | 5 | 3.73 | 0.58 | 0.264 |
| Hot salt well | 6 | 2 | 1.45 | 3.31 |
| Hot salt well to CTAH | 7 | 3.23 | 0.44 | 0.304 |
| CTAH hot manifold | 8 | 3.418 | 0.28 | 0.493 |
| CTAH salt side | 9 | 18.47 | 0.00457 | 0.449 |
| CTAH cold manifold | 10 | 3.418 | 0.175 | 0.192 |
| CTAH to drain tank | 11 | 3.48 | 0.438 | 0.302 |
| Standpipe | 12 | 6.51 | 0.438 | 0.302 |
| Standpipe to reactor vessel | 13 | 6.603 | 0.438 | 0.302 |
| Injection plenum | 14 | 3.04 | 0.438 | 0.302 |
| Downcomer | 15 | 4.76 | 0.056 | 0.304 |
| Branch | 27 | 0.5 | 0.056 | 0.304 |
| Inlet plenum | 28 | 0.2 | 0.03 | 1.33 |
| +DHX branch+ |   |   |   |   |
| Downcomer to DHX | 16 | 0.58 | 0.15 | 0.0353 |
| DHX shell side | 17 | 2.5 | 0.0109 | 0.222 |
| DHX to hot leg | 18 | 3.008 | 0.15 | 0.0353 |
| +DRACS loop+ |   |   |   |   |
| DHX tube side | 19 | 2.5 | 0.0109 | 0.184 |
| DRACS hot leg 1 | 20 | 3.45 | 0.15 | 0.0353 |
| DRACS hot leg 2 | 21 | 3.67 | 0.15 | 0.0353 |
| TCHX manifold | 22 | 2.6 | 0.15 | 0.0353 |
| TCHX salt tube | 23 | 6 | 0.0109 | 0.175 |
| DRACS cold leg 1 | 24 | 4.43 | 0.15 | 0.0353 |
| DRACS cold leg 2 | 25 | 5.95 | 0.15 | 0.0353 |

Pipings are modeled as one-dimensional fluid flow component, `PBOneDFluidComponent`.
Their locations are specified with variables position and orientation.
Flow area, hydraulic diameter, and pipe length are the main variables that
define the element. An example of piping is as follows

!listing pbfhr/sam_model/pbfhr-ss.i block=pipe040 language=cpp

Components are connected using `PBSingleJunction`, or `PBBranch`. For example

!listing pbfhr/sam_model/pbfhr-ss.i block=Branch611 language=cpp

The DHX is modeled using the `PBHeatExchanger` component
which models a shell-and-tube heat exchanger including the fluid flow
in the primary and secondary sides, convective heat transfer, and heat conduction in tube wall.
Either co-current or counter-current configuration can be modeled.  
Care should be taken when specifying the heat transfer surface area density
(`HT_surface_area_density`). The user is advised to consult the SAM manual for further explanation.
The heat transfer coefficients for both the shell side and tube side are calculated internally.
However, users can override them using variables `Hw` and `Hw_secondary`
(commented out in the input file)

!listing pbfhr/sam_model/pbfhr-ss.i block=DHX language=cpp

The salt pump is modeled using the PBPump component.
The user specifies a constant pump head or pump head function (`Phead`)
which is time dependent. Large reverse pump loss coefficients are
input to prevent reverse flow.

!listing pbfhr/sam_model/pbfhr-ss.i block=Pump language=cpp

The DRACS loop, shown schematically in Figure 3, consists of the tube side of
the DHX heat exchanger, manifold and piping.  The nodalization of the components
are included in [fhr_components].


!media pbfhr/pbfhr_dracs.png
       style=width:80%
       id=pbfhr_dracs
       caption=Nodalization of the DRACS loop model in SAM model (used with permission, [!cite](Zweibaum2015)).

## Postprocessors

This block is used to specify the output variables written to a `csv` file
that can be further processed in Excel. For example, to output
the exit temperature on the secondary side of the DHX:

!listing pbfhr/sam_model/pbfhr-ss.i block=DHXTubeTop language=cpp

To output the velocity and density of the flow exiting the core:

!listing pbfhr/sam_model/pbfhr-ss.i language=cpp
        start=Corev
        end=Bypassv

## Preconditioning

This block describes the preconditioner used by the solver.  New users can leave this block unchanged.

## Executioner

This block describes the calculation process flow. The user can specify the start time,
end time, time step size for the simulation. Other inputs in this block include PETSc solver options,
convergence tolerance, quadrature for elements, etc. which can be left unchanged.

## Restart

A new run can be restarted from a previous run. For example,
input file `PBFHR-TR.i` simulates a transient that starts from
the steady state results after running `PBFHR-SS.i`.

```language=bash
[Problem]
  restart_file_base = 'pbfhr-ss_out_cp/0402'
[]
```

# Output Files Description and Results

There are three types of output files:

1. +PBFHR-SS.csv+: this is a `csv` file that writes the user-specified scalar and
    vector variables to a comma-separated-values file. The data can be imported
    to `Excel` for further processing.
2. +PBFHR-SS_checkpoint_cp+: this is a sub-folder that save snapshots of
    the simulation data including all meshes, solutions. Users can restart
    the run from where it ended using the file in the checkpoint folder.
3. +PBFHR-SS_out.displaced.e+: this is an `EXodusII` file that has all mesh and solution data.
    Users can use Paraview to open this .e file to visualize, plot, and analyze the data.

Figure 4 shows the Paraview output for the primary loop temperature profile
during normal operation and the salt flow pattern is indicated by green arrows.
A companion plot of elevation vs. temperature traversing a closed loop of part of the system is also shown.
In this regime, the DHX operates as a co-current heat exchanger. The area enclosed
in the elevation-temperature plot shows that significant buoyancy force exists
to drive natural circulation, since density is a linear function of temperature.  
This is important after transient initiation, when rapid flow reversal and establishment
of natural circulation cooling is essential to minimize the maximum temperatures achieved by the system.

!media pbfhr/pbfhr_coolant_temperature.png
       style=width:80%
       id=pbfhr_temp1
       caption=Coolant temperature during steady state (t = 90s).

In this simulation, a protected loss of forced flow occurs at t = 100 s.
The power drops immediately to about 5% of nominal power and decay heat is the sole heat source in the core.
[pbfhr_temp2] shows the temperature profile and flow pattern at t=1400 s.  
Natural circulation is established in the primary-to-DHX loop as indicated by
the area enclosed in the elevation-temperature plot. The flow driven upward by the core
through pipe 2 then enters path 3-4-5, so that DHX behaves as a countercurrent heat exchanger.

!media pbfhr/pbfhr_coolant_temperature2.png
       style=width:80%
       id=pbfhr_temp2
       caption=Coolant temperature during loss of forced flow transient (at t = 1400s).

# Running the Input File

SAM can be run in Linux, Unix, and MacOS.  Due to its dependence on MOOSE,
SAM is not compatible with Windows machine.  SAM can be run from the shell prompt as shown below

```
sam-opt -I pbfhr-ss.i
```
