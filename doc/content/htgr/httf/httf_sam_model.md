# 2D Ring Model for the High Temperature Test Facility (HTTF)

*Contact: Thanh Hua, hua.at.anl.gov*

*Model link: [HTTF SAM 2D Ring Model](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/httf)*

!tag name=2D Ring Model for the High Temperature Test Facility pairs=reactor_type:HTGR
                       reactor:HTTF
                       geometry:core
                       code_used:SAM
                       computing_needs:workstation
                       fiscal_year:2024

## Problem Description

The High Temperature Test Facility (HTTF) [!citep](Gutowska2019) is an integral system test facility constructed and operated at the Oregon State University using General Atomics’ Modular High Temperature Gas-cooled Reactor (MHTGR) as its reference design. It is helium-cooled and electrically heated. [httf_geom] shows a rendering of the primary pressure vessel (PV), and the hot and cold legs connecting the PV to the reactor cavity simulation tank (RCST). Alumina ceramic blocks are used to simulate the core and top and bottom reflectors. Holes in the blocks provide channels for the heater rods, which consist of stacks of graphite rodlets. Coolant holes are arranged in the blocks to represent cooling and bypass flows in the core. The main objective of this test facility is to experimentally investigate thermal fluids behaviors of interest to MHTGR transients. A variety of tests were performed in the HTTF, providing experimental data to reflect system-level response, which are suitable for code benchmark of system analysis codes [!citep](OECD_NEA2023), and experimental data suitable for higher resolution thermal fluid codes such as CFD codes.

!media httf/httf_sam_model/F1_HTTF_facility.png
       style=width:50%
       id=httf_geom
       caption=The High Temperature Test Facility (used with permission, source: [OECD/NEA Benchmark Website](https://www.oecd-nea.org/jcms/pl_71708/thermal-hydraulic-code-validation-benchmark-for-high-temperature-gas-cooled-reactors-using-httf-data-htgr-t/h)).

The SAM [!citep](Hu2021) model for the HTTF is based on the so-called 2D ring model approach to approximate a 3D geometry ([2d_ring]). In this approach, all components including the ceramic matrix, graphite heaters, coolant channels, core barrel, pressure vessel, and reactor cavity cooling system (RCCS) are modeled as concentric cylindrical rings. In the 2D ring model, this heat transfer pathway is represented by the sequence heater ring – ceramic ring – coolant ring – ceramic ring – heater ring, etc. The HTTF core is modeled with 13 coolant rings, 11 heater rings,
25 ceramic rings. One ring each is used to model the stagnant helium gaps, upcomer, core barrel, reactor pressure vessel, RCCS, and the RCCS air cavity.

!media httf/httf_sam_model/F2_RingModel.png
       style=width:50%
       id=2d_ring
       caption=2D ring model of the HTTF.

In the model, it is assumed that the HTTF was operated at full power of 2.2 MW although this was not achieved in actual experiments, and that axial heating profile is uniform. Inlet helium temperature approximating MHTGR condition is specified. The helium flow rate is chosen so that its temperature increases ~420 K after passing through the core, as is typical in MHTGR. However, the HTTF was not designed to operate at the high pressure encountered in MHTGR, a pressure about $1/10^{th}$ the MHTGR nominal pressure is specified. The heat transfer boundary condition for the reactor pressure vessel is established by specifying water flow rate and inlet temperature for the RCCS. The operating conditions for steady state simulation are given in [ring_bc].

!table id=ring_bc caption=Steady state operating conditions.
|  Parameter | Unit | Value  |
| :- | :- | :- |
| Heating power | $MW$ | 2.2 |
| Helium mass flow rate    | $kg/s$ | 1.0 |
| Helium inlet temperature    | $K$ | 500 |
| Helium pressure    | $MPa$ | 0.7 |
| RCCS water mass flow rate    | $kg/s$ | 1.0 |
| RCCS water inlet temperature    | $K$ | 313.15 |
| RCCS water pressure   | $MPa$ | 0.1  |
| RCCS cavity air flow rate  | $kg/s$ | 0.025  |
| RCCS air inlet temperature   | $K$ | 300  |


## Input File Description

SAM uses a block-structured input syntax. Each block begins with square brackets which contain the type of input and ends with empty square brackets. Each block may contain sub-blocks. The blocks are described in the order as they appear in the input file.

### Global Parameters style=font-size:125%

This block contains the parameters such as global initial pressure, velocity, and temperature conditions, the scaling factors for primary variable residuals, etc.  This block also contains a sub-block PBModelParams which specifies the modeling parameters associated with the primitive-variable based fluid model. New users should leave this sub-block unchanged.

For example, to specify global pressure of 7.e5 Pa and temperature of 500 K, the user can input

!listing htgr/httf/sam_ring_model/HTTF-SS.i block=GlobalParams language=cpp

### EOS style=font-size:125%

This block specifies the Equation(s) of State. The users can choose from built-in fluid library for common fluids like air, nitrogen, helium, sodium, molten salts, etc. The users can also input the properties of the fluid as constants or function of temperature. For example, the built-in eos for air can be input as

!listing htgr/httf/sam_ring_model/HTTF-SS.i block=air_eos language=cpp

### MaterialProperties style=font-size:125%

Material properties are input in this block. The values can be constants or temperature dependent as defined in the Functions block. For example, the properties of stainless steel are input as

!listing htgr/httf/sam_ring_model/HTTF-SS.i block=ss-mat language=cpp

in which k304ss cp304ss and temperature dependent functions for 304 stainless steel thermal conductivity and specific heat. Note that all units are in SI by default.

### Functions style=font-size:125%

Users can define functions for parameters used in the model. These include temporal, spatial, and temperature dependent functions. For example, users can input enthalpy as a function of temperature, power history as a function of time, or power profile as a function of position. The input below specifies specific heat as a function of temperature.

!listing htgr/httf/sam_ring_model/HTTF-SS.i block=cp304ss language=cpp

### Components style=font-size:125%

This is the main block in the input file. It provides the specifications for all components that make up the core and the RCCS.  The inputs for a coolant channel, ceramic, and heater rings in the inner core region are shown below.

!listing htgr/httf/sam_ring_model/HTTF-SS.i language=cpp
        start=Inner core
        end=He gap surrounding graphite rods

!listing htgr/httf/sam_ring_model/HTTF-SS.i block=R6 language=cpp

Adjacent ceramic rings are coupled using +SurfaceCoupling+ to maintain temperature continuity. For example, coupling between rings 17 and 19 is input as

!listing htgr/httf/sam_ring_model/HTTF-SS.i block=Coupling_17_19 language=cpp

Likewise, a lower reflector ceramic block in contact with a core block is modeled as

!listing htgr/httf/sam_ring_model/HTTF-SS.i block=LRCore_R15 language=cpp

Pipings are modeled as one-dimensional fluid flow component, +PBOneDFluidComponent+. Their locations are specified with variables position and orientation. Flow area, hydraulic diameter, and pipe length are the main variables that define the element. An example of a pipe that models the air flow in the RCCS cavity is given below

!listing htgr/httf/sam_ring_model/HTTF-SS.i block=pipe2 language=cpp

Fluid components are connected using +PBSingleJunction+, or +PBBranch+. For example, connecting the coolant channel of ring 2 in the lower reflector region to the coolant channel in the heated core region is established as

!listing htgr/httf/sam_ring_model/HTTF-SS.i block=LRCore_R2 language=cpp

Boundary conditions can be specified using +PBTDV+ or +PBTDJ+, such as

!listing htgr/httf/sam_ring_model/HTTF-SS.i block=inlet_bc language=cpp

!listing htgr/httf/sam_ring_model/HTTF-SS.i block=outlet_bc language=cpp

### Postprocessors style=font-size:125%

This block is used to specify the output variables written to a +csv+ file that can be further processed in Excel. For example, to output the exit temperature, mass flow rate, and flow velocity from ring 2

!listing htgr/httf/sam_ring_model/HTTF-SS.i language=cpp
        start=R2C_T_out
        end=R4C_T_out

### Preconditioning style=font-size:125%

This block describes the preconditioner used by the solver.  New users can leave this block unchanged.

### Executioner style=font-size:125%

This block describes the calculation process flow. The users can specify the start time, end time, time step size for the simulation. Other inputs in this block include +PETSc+ solver options, convergence tolerance, quadrature for elements, etc which can be left unchanged.


## Output Files Description and Results

There are three types of output files:

- +HTTF-SS.csv+: this is a +csv+ file that writes the user-specified scalar and vector variables to a comma-separated-values file. The data can be imported to Excel for further processing.
- +HTTF-SS_checkpoint_cp+: this is a sub-folder that save snapshots of the simulation data including all meshes, solutions. Users can restart the run from where it ended using the file in the checkpoint folder.
- +HTTF-SS_out.displaced.e+: this is a +ExodusII+ file that has all mesh and solution data. Users can use Paraview to open this +.e+ file to visualize, plot, and analyze the data.

## Results

[core_flow] tabulates the SAM results [!citep](Hua2023) for flow distribution in different core regions and the associated number of coolant channels in each region. The bypass flow in the central and outer reflectors amounts to 12.3% of total flow which is representative of bypass flow in MHTGR. The helium temperature in each of the 13 coolant rings at blocks 1, 3, and 5 are shown in [he_temp]. The temperature increases as helium flows downward from top to bottom (block 1 is the bottom heated core block, block 10 is at the top).

!table id=core_flow caption=Steady-state flow distribution in the HTTF core.
|  - | Central Reflector | Inner Core  | Middle Core | Outer Core | Outer Reflector |
| :- | :- | :- | :- | :- | :- |
| No. of coolant channels | 6 | 138 | 144 | 234 | 36 |
| Flow ($kg/s$)    | 0.027 | 0.233 | 0.310 | 0.334 | 0.096 |

!media httf/httf_sam_model/F3_He_temp.png
       style=width:50%
       id=he_temp
       caption=Helium temperature in the 13 coolant rings.

## Running the Input File

SAM can be run in Linux, Unix, and MacOS.  Due to its dependence on MOOSE, SAM is not compatible with Windows machine.  SAM can be run from the shell prompt as shown below.

```language=bash
sam-opt -i httf-ss.i
```
