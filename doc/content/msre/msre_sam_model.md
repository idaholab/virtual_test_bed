# Molten Salt Reactor Experiment (MSRE) SAM Modeling

## MSRE Description

The MSRE was a graphite moderated flowing salt type reactor with a design maximum operating power of 10 MW(th) developed by Oak Ridge National Laboratory [!citep](Robertson1965). 
The fuel salt was a mixture of lithium, beryllium, and zirconium fluoride containing uranium or thorium and uranium fluoride. 
The coolant salt was a mixture of lithium fluoride and beryllium fluoride. 
The reactor consisted of two flow loops: a primary loop and a secondary loop. 
The primary loop connected the reactor vessel to a fuel salt centrifugal pump and the shell side of the shell-and-tube heat exchanger. 
The secondary loop connected the tube-side of the shell-and-tube heat exchanger to a coolant salt centrifugal pump and the tube side of an air-cooled radiator. 
Two axial blowers supplied cooling air to the radiator. Piping, drain tanks and “freeze valves” made up the remaining components of the heat transport circuits. 
The heat generated in the core was transferred to the secondary loop through the heat exchanger and ultimately rejected to the atmosphere through the radiator. 
The current 1-D MSRE model focuses on the primary loop with all the key reactor components represented.


## Material Properties and MSRE Setup

The fuel salt in the MSRE primary loop was LiF-BeF4-ZrF4-UF4 according to the design specifications of the MSRE [!citep](Beall1964,Cantor1968), 
of which the thermophysical properties are listed in [fuel_salt_properties]

!table id=fuel_salt_properties caption=Thermophysical properties of the fuel salt.
|   |   | Unit  | LiF-BeF$_4$-ZrF$_4$-UF$_4$  |
| :- | :- | :- | :- |
| Melting temperature | $T_{melt}$ | $K$ | $722.15$  |
| Density | $\rho$ | $kg/m^3$  | $2553.3-0.562\bullet T$ |
| Dynamic viscosity | $\mu$ | $Pa\bullet s$ | $8.4\times 10^{-5} exp(4340/T)$ |
| Thermal conductivity | $k$ | $W/(m\bullet K)$ | $1.0$ |
| Specific heat capacity | $c_p$ | $J/(kg\bullet K)$ | $2009.66$ |

A conventional, cross-baffled, shell-and-tube type heat exchanger was used in MSRE. 
The fuel salt flows on the shell side while the coolant salt flows through the tube side. 
The coolant salt in the heat changer is LiF-BeF$_2$ (0.66-0.34) [!citep](Guymon1973), of which the major thermophysical properties are summarized in [coolant_salt_properties]. 
Due to the space limitation in the reactor cell, a U-tube configuration is adopted, which results in a heat exchanger of roughly 2.5 m in length. 
The shell diameter is 0.41 m while the tube has a diameter of 1.27 cm and a thickness of 1.07 mm. Given a triangular arrangement of the tubes, the hydraulic diameters are 2.09 cm (shell-side) and 1.06 cm (tube-side). 
The construction material of heat exchanger is Hastelloy® N alloy with the properties listed in [steel_properties]. 
All the connecting pipes have a default diameter of 0.127 m. A centrifugal pump is utilized, and its head is adjusted to sustain the flow circulation. The downcomer and lower plenum to the MSRE core are modeled with SAM 1-D components.

!table id=coolant_salt_properties caption=Thermophysical properties of the coolant salt in heat exchanger.
|   |   | Unit  | LiF-BeF$_2$ (0.66-0.34)  |
| :- | :- | :- | :- |
| Melting temperature | $T_{melt}$ | $K$ | $728$  |
| Density | $\rho$ | $kg/m^3$  | $2146.3-0.488\bullet T$ |
| Dynamic viscosity | $\mu$ | $Pa\bullet s$ | $1.16\times 10^{-4} exp(3755/T)$ |
| Thermal conductivity | $k$ | $W/(m\bullet K)$ | $1.1$ |
| Specific heat capacity | $c_p$ | $J/(kg\bullet K)$ | $2390.0$ |

!table id=steel_properties caption=Thermophysical properties of Hastelloy® N alloy used in the heat exchanger.
|   |   | Unit  | Hastelloy® N alloy  |
| :- | :- | :- | :- |
| Density | $\rho$ | $kg/m^3$  | $8860$ |
| Thermal conductivity | $k$ | $W/(m\bullet K)$ | $23.6$ |
| Specific heat capacity | $c_p$ | $J/(kg\bullet K)$ | $578$ |


## Input Description

The SAM input file adopts a block structured syntax, and each block contains the detailed settings of specific SAM components. In this section, we will go through all the important blocks in the input file and explain the key model specifications: 

### GlobalParams

This block contains the global parameters that are applied to all SAM components, such as the initial pressure, temperature, and so on. A snippet is illustrated below: 

```language=bash

  global_init_P = 1e5                        # Global initial fluid pressure
  global_init_V = 0.0                        # Global initial fluid velocity
  global_init_T = 908.15                     
  Tsolid_sf     = 1e-3
  gravity       = '0 -9.8 0'

```

### EOS

EOS is short for Equation Of State. This block specifies the material properties, such as the thermophysical properties of the fuel salt and the coolant salt in the heat exchanger listed in the Section above. SAM supports both constants and user-defined functions for the specific parameters. The properties of common materials are implemented SAM repository, and can be readily used by simply refering to the material ids, such as the air, or molten salt FLiBe. 

!listing msre/msre_loop_1d.i block=EOS language=cpp

### Components

This is the most important block that defines all the reactor components represented in the MSRE primary loop, such as the core, the heat exchanger, the pump, and all the connecting pipes. The Table below listed all the reactor components considered

!table id=msre_components caption=The reactor components represented in MSRE primary loop.
|  | ID | Description  |
| :- | :- | :- |
| Downcomer | $downcomer$ | The annular channel from the flow distributor to the inlet/lower plenum |
| Inlet plenum | $iplnm$ | The space underneath the MSRE core |
| Core | $core$ | The active core region with the fuel salt flowing through graphite matrix |
| Upper plenum | $uplnm$ | The space on top of the active core |
| Primary pump | $pump$ | The pump driving the fuel salt to circulate in the primary loop |
| Primary heat exchanger | $hx$ | The heat exchanger cooling down the molten salt before it returns to the core |


Specifically, the MSRE core is modeled with a 1-D channel and total heat source of 10 MW is uniformly distributed along the channel in this simplified demonstration model. 
The primary pump is placed between the core and the heat exchanger. As for the shell-and-tube heat exchanger, the shell side is modeled with one 1-D channel while the tube side is modeled with three 1-D channels, 2 long ones and 1 short connecting in a U-structure. 
The heat is exchanged through the 1-D wall coupling the shell and tube sides. The coolant slat temperature and velocity are specified at the inlet of the tube side as shown in the code snippet below.
A reference pipe is connected to the system to ensure a fixed pressure boundary condition at the exit of HX primary side, which helps the SAM model better converge. 
The component types involved include `PBOneDFluidComponent`, `PBPump`, `PBCoupledHeatStructure`, and `PBBranch`, and the boundary conditions involved include `PBTDV`, `PBTDJ`. 
The detailed instructions of these SAM components can be found in the SAM user manual, which are not repeated here for brevity. 

!listing msre/msre_loop_1d.i block=hx_s_in language=cpp

### Postprocessors

The Postprocessors block is used to monitor the SAM solutions during the simulations, and variables of interest can be printed out in the log file. For example, to check out the core outlet temperature, one can add the following snippet:

!listing msre/msre_loop_1d.i block=Core_T_out language=cpp

### Preconditioning

This block describes the preconditioner used by the solver.  New user can leave this block unchanged.

### Executioner

This block describes the calculation process flow. The user can specify the start time, end time, time step size for the simulation. Other inputs in this block include PETSc solver options, convergence tolerance, quadrature for elements, etc., which can be left unchanged.


## Results

There are three types of output files:

1. +msre_loop_1d_csv.csv+: this is a `csv` file that writes the user-specified scalar 
    and vector variables to a comma-separated-values file. The data can be imported 
    to Excel for further processing.

2. +msre_loop_1d_checkpoint_cp+: this is a sub-folder that save snapshots of the simulation 
    data including all meshes, solutions. Users can restart the run from where it ended 
    using the file in the checkpoint folder.

3. +msre_loop_1d_out.displaced.e+: this is a `EXodusII` file that has all mesh and 
    solution data. Users can use Paraview to open this .e file to visualize, plot, 
    and analyze the data. 


[msre_sam] shows the steady state fuel salt temperature in the primary loop during the normal operating condition. 
The fuel salt enters the MSRE core at an average temeprature of 908K, and through the nuclear reactions in the core region, leaves the core at an average temperature of 937K.
The primary pump is located at the top-right corner, driving the fuel salt in the system. 
The U-tube primiary heat exchanger cools down the fuel salt, which returns to the core through the connecting pipes, downcomer and the core inlet plenum. The overall layout shown in [msre_sam] follows that of the original MSRE designs. 

!media msre/SAM_MSRE_1D.png
       style=width:60%
       id=msre_sam
       caption=The steady-state temperature distribution in the 1-D MSRE primary loop.
