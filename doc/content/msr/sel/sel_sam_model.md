# SAM System Model for the Molten Salt Separate Effects Loop (SEL)

*Contact: Thanh Hua, thua@anl.gov*

*Model link: [SEL SAM System Model](https://github.com/idaholab/virtual_test_bed/tree/devel/msr/sel)*

!tag name=sel_sam_model
      description=A system-level SAM model representing the Molten Salt Separate Effects Loop (SEL)
      image=
      pairs=reactor_type:MSR
                       reactor:SEL
                       geometry:1D system
                       simulation_type:System Modeling
                       input_features:
                       transient:steady/transient
                       codes_used:SAM
                       open_source:true
                       computing_needs:Workstation
                       fiscal_year:2025
                       institution:ANL
                       sponsor:ARPA-E

## High Level Summary of Model

The SEL SAM model is a system-level representation of the Molten Salt Separate Effects Loop (SEL). The working fluid is a molten salt mixture of MgCl2-NaCl. The model simulates the primary loop with forced convection (salt mass flow rate of 1 kg/s) in an electrically heated 1-pin test section configuration (11 kW heating power). 

In addition to the primary loop, the model includes a secondary loop where pressurized air cools the primary heat exchanger (PHX) and is subsequently cooled by a water-based secondary heat exchanger (SHX) before being safely vented. This is in accordance with building safety requirements which mandate the air to be reduced in temperature (< 60°C) before venting to the environment.

The SAM model is designed to simulate both steady-state forced flow conditions and transient natural circulation scenarios, such as a loss of flow transient induced by a pump coast-down. The model is currently focused on a single-pin configuration but is structured to easily expand to 7-pin and conjugate heat transfer configurations in the future.

### Project Description

This modeling effort is part of the "Stable Salt Reactor – Digital Twins Development and Separate Effects Test" project, funded by ARPA-E. The project is a collaborative effort led by Argonne National Laboratory (ANL), in partnership with the University of Michigan and Moltex Energy.

The primary goal is to develop a digital twin to support the design, development, and operation of the experimental SEL test rig, which supports thermal-convection testing for Moltex’s liquid-filled fuel pin design. The modeling work will be used in tandem with experimental data to validate SAM's heat transfer coefficient and pressure drop correlations for molten salt systems, aiding in the broader deployment and regulatory approval of Stable Salt Reactors (fixes issue #848).

## Input File Description

The model has two main input files:
- `OnepinSS.i`: Simulates the steady-state operating conditions with forced flow.
- `OnepinNC.i`: Simulates a loss-of-flow transient (pump trip) and the resulting natural circulation.

The SAM input file adopts a block-structured syntax, and each block contains the detailed settings of specific SAM components. In this section, we will go through the important blocks in the input file and explain the key model specifications.

### GlobalParams style=font-size:125%

This block contains the global parameters that are applied to all SAM components, such as the initial pressure, velocity, and temperature.
!listing msr/sel/OnepinSS.i block=GlobalParams language=cpp

### EOS (Equations of State) style=font-size:125%

This block specifies the material properties, such as the thermophysical properties. This includes the fuel salt (MgCl2-NaCl), water, and pressurized air.
!listing msr/sel/OnepinSS.i block=EOS language=cpp

### Components style=font-size:125%

This is the main block in the input file. It provides the specifications for all components that make up the loop, such as the test section, heat exchangers, pumps, and connecting pipes.

The test section is modeled as a `PBCoreChannel` containing the heater heat structure:
!listing msr/sel/OnepinSS.i block=Components/CH1 language=cpp

The primary and secondary heat exchangers are modeled using `PBHeatExchanger`:
!listing msr/sel/OnepinSS.i block=Components/IHX language=cpp

The molten salt pump is modeled using `PBPump`:
!listing msr/sel/OnepinSS.i block=Components/Pump_p language=cpp

### Postprocessors style=font-size:125%

The Postprocessors block is used to monitor the SAM solutions during the simulations, outputting quantities of interest to the log file and a CSV file.
!listing msr/sel/OnepinSS.i block=Postprocessors language=cpp

### Executioner style=font-size:125%

This block describes the calculation process flow. It specifies the start time, end time, and time step size for the simulation.
!listing msr/sel/OnepinSS.i block=Executioner language=cpp

## Results

### Steady State Operating Conditions

For a base case, salt flow rate 1 kg/s, and heater power of 11 kW:
- 11.3 K coolant temperature rise
- Peak pin centerline temperature 1135 K, pin surface temperature 1008 K
- Air temperature rises to 780 K in PHX, cools down to 320 K in SHX for discharge to the environment.

!media msr/sel/sel_loop_temp.png
       id=sel_loop_temp
       caption=Steady State Loop Temperature
       style=width:60%

!table id=steady_state_conditions caption=Steady State Operating Conditions
| | Inlet | Outlet |
| :- | :- | :- |
| **PHX: salt** | | |
| Temperature (K) | 772.5 | 783.8 |
| Mass flow rate (kg/s) | 1 | 1 |
| **PHX: air** | | |
| Temperature (K) | 300.0 | 781.3 |
| Mass flow rate (kg/s) | 0.022 | 0.022 |
| **SHX: air** | | |
| Temperature (K) | 778.2 | 319.8 |
| Mass flow rate (kg/s) | 0.022 | 0.022 |
| **SHX: water** | | |
| Temperature (K) | 300 | 319.8 |
| Mass flow rate (kg/s) | 0.13 | 0.13 |

### Natural Circulation in Loss of Flow Transient

A pump trip is initiated, causing the pump to coast-down with a halving time of 10 seconds, eventually coming to a complete stop at 100 seconds.
- After forced flow is terminated, natural circulation flow is established in the loop.
- The flow rate is reduced from 1 kg/s to 0.12 kg/s.
- Temperature rise of 93.1 K is noted along the test section (up from 11.3 K).

Both heat exchangers continue to operate normally during the transient. There is an increasing salt temperature difference due to the lower flow rate in natural circulation mode. There is little change in air and water temperatures, and air temperature is maintained under 60°C for safe discharge.

!media msr/sel/sel_transient_flowrate.png
       id=sel_transient_flowrate
       caption=Transient Flow Rate
       style=width:50%

!media msr/sel/sel_transient_saltTemp.png
       id=sel_transient_saltTemp
       caption=Transient Salt Temperature
       style=width:50%

!media msr/sel/sel_transient_PHX.png
       id=sel_transient_PHX
       caption=Transient PHX Temperatures
       style=width:50%

!media msr/sel/sel_transient_SHX.png
       id=sel_transient_SHX
       caption=Transient SHX Temperatures
       style=width:50%

## Run Command

The model can be run on a local workstation. Below is a simple example of how to run the steady-state SAM system modeling job:

```language=bash
/path/to/sam-opt -i OnepinSS.i
```
