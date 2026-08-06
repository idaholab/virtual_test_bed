# SAM System Model for the Molten Salt Separate Effects Loop (SEL)

*Contact: Thanh Hua, thua.at.anl.gov; Jun Fang, fangj.at.anl.gov*

*Model link: [SEL SAM System Model](https://github.com/idaholab/virtual_test_bed/tree/devel/msr/sel)*

!tag name=SEL SAM System Model
     description=A system-level SAM model representing the Molten Salt Separate Effects Loop (SEL)
     image=https://mooseframework.inl.gov/virtual_test_bed/media/msr/sel/sel_loop_temp.png
     pairs=reactor_type:MSR
                       reactor:SEL
                       geometry:System-Level
                       codes_used:SAM
                       computing_needs:Workstation
                       gpu_enabled:false
                       transient:steady/transient
                       V_and_V:demonstration
                       fiscal_year:2025
                       sponsor:ARPA-E
                       institution:ANL

## Model Overview

The SEL SAM model is a system-level representation of the Molten Salt Separate Effects Loop (SEL). The working fluid is a molten salt mixture of MgCl2-NaCl. The model simulates the primary loop with forced convection (salt mass flow rate of 1 kg/s) in an electrically heated 1-pin test section configuration (11 kW heating power). 

In addition to the primary loop, the model includes a secondary loop where pressurized air cools the primary heat exchanger (PHX) and is subsequently cooled by a water-based secondary heat exchanger (SHX) before being safely vented. This is in accordance with building safety requirements which mandate the air to be reduced in temperature (< 60°C) before venting to the environment.

The SAM model is designed to simulate both steady-state forced flow conditions and transient natural circulation scenarios, such as a loss of flow transient induced by a pump coast-down. The model is currently focused on a single-pin configuration but is structured to easily expand to 7-pin and conjugate heat transfer configurations in the future.


## Input File Description

The model has two main input files:

- `OnepinSS.i`: Simulates the steady-state operating conditions with forced flow.

- `OnepinNC.i`: Simulates a loss-of-flow transient (pump trip) and the resulting natural circulation.

The SAM input file adopts a block-structured syntax, and each block contains the detailed settings of specific SAM components. In this section, we will go through the important blocks in the input file and explain the key model specifications.

### GlobalParams style=font-size:125%

This block contains the global parameters that are applied to all SAM components, such as the initial pressure (`1.e5` Pa), initial velocity (`2.0` m/s), and global initial temperature (`773.15` K). This section also specifies variable scaling factors (`scaling_factor_var = '1 1e-2 1e-5'`), which is a crucial numerical setup in SAM (based on MOOSE's PJFNK solver). Scaling handles variables like pressure, velocity, and temperature that have drastically different magnitudes, ensuring robust matrix preconditioning and solver convergence.

!listing msr/sel/OnepinSS.i block=GlobalParams language=cpp

### EOS (Equations of State) style=font-size:125%

This block specifies the material equations of state for the three working fluids in the system. The primary loop uses `PTFunctionsEOS` to define the temperature-dependent thermophysical properties of the molten salt (MgCl2-NaCl) via piece-wise linear interpolations (`PiecewiseLinear` functions defined in the `Functions` block). The secondary and tertiary loops use `AirEquationOfState` for pressurized air and `PTConstantEOS` for the cooling water, respectively.

!listing msr/sel/OnepinSS.i block=EOS language=cpp

### Components style=font-size:125%

This is the main block in the input file. It provides the specifications for all physical components that make up the loop, converting the 3D facility geometry into an equivalent 1D system network using components such as the test section, heat exchangers, pumps, and connecting pipes.

The test section is modeled as a `PBCoreChannel` incorporating the electrically heated `heater` pin. Key parameters such as hydraulic diameter (`Dh = 0.015494`) and flow area are carefully specified to represent the annular flow path between the single heater pin and the surrounding pipe wall. Heat transfer correlations are enhanced (`SC_HTC = 1.3`) to account for local flow phenomena:

!listing msr/sel/OnepinSS.i block=Components/CH1 language=cpp

The primary (IHX) and secondary (SHX) heat exchangers are modeled using the `PBHeatExchanger` component, which simulates 1D counter-current heat exchange across a shared wall. The IHX couples the primary salt loop to the pressurized air loop, while the SHX couples the air loop to the final water cooling sink, allowing the air to be safely discharged to the environment below 60°C:

!listing msr/sel/OnepinSS.i block=Components/IHX language=cpp

The molten salt pump (`Pump_p`) uses a `PBPump` component to drive forced convection. Its pressure head is defined via a time-dependent function (`pump_head`) that is central to both the steady-state and transient simulations. To reach the steady-state initial condition, the pump head is held at a constant value from a pseudo-transient start time of -20000 s up to 0 s to establish a steady 1 kg/s salt mass flow rate. For transient loss of flow simulations, a pump trip is initiated at time > 0, where the pump head function coasts down towards zero.

!listing msr/sel/OnepinSS.i block=Components/Pump_p language=cpp

### Postprocessors style=font-size:125%

The Postprocessors block is used to extract and monitor macroscopic quantities of interest during the simulation, such as mass flow rates, average temperatures, and total heat transfer. These values are printed to the console and saved to a CSV file to easily verify steady-state energy balances and track transient behaviors.

!listing msr/sel/OnepinSS.i block=Postprocessors language=cpp

### Executioner style=font-size:125%

This block orchestrates the overall calculation process flow. It sets the solver type (e.g., `Transient`), start time, end time, and time-stepping scheme. It also configures the PETSc solver options (such as using the `lu` preconditioner with `petsc_options_value = '300 lu'`) to ensure that the highly non-linear fluid flow and conjugate heat transfer equations converge efficiently.

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
       style=width:80%

!table id=steady_state_conditions caption=Steady State Operating Conditions
| Component | Fluid | Inlet Temperature (K) | Outlet Temperature (K) | Mass flow rate (kg/s) |
| :- | :- | :- | :- | :- |
| PHX | Salt | 772.5 | 783.8 | 1.0 |
| PHX | Air | 300.0 | 781.3 | 0.022 |
| SHX | Air | 778.2 | 319.8 | 0.022 |
| SHX | Water | 300.0 | 319.8 | 0.13 |

### Natural Circulation in Pump Trip Transient

To simulate a loss-of-flow scenario, a pump trip is initiated at $t = 0$. The pump head is programmed to coast down, eventually reaching zero at $t = 100$ seconds.

- +Flow Transition+: As the forced flow decays, the flow rate drops from the initial 1.0 kg/s but does not go to zero. Instead, a stable natural circulation flow of approximately 0.12 kg/s is successfully established in the loop, driven by the buoyancy difference between the hot salt in the heater test section and the cooler salt in the heat exchangers.
- +Test Section Temperatures+: Due to the significantly reduced mass flow rate under constant 11 kW heating, the temperature rise across the test section ($\Delta T$) increases dramatically. The salt inlet temperature gradually drops to ~700 K as cooler salt returns from the PHX. Meanwhile, the outlet temperature experiences a transient peak near 825 K before settling around 795 K. This results in a steady-state natural circulation $\Delta T$ of approximately 95 K, up from the initial 11.3 K in forced flow.
- +Heat Exchanger Performance+: Both the primary (PHX) and secondary (SHX) heat exchangers continue to operate effectively throughout the transient. In the PHX, the air outlet temperature smoothly tracks the transient peak of the incoming hot salt. Crucially, the SHX continues to successfully dump this heat into the water cooling sink, maintaining an extremely stable air discharge temperature of ~320 K (well below the 60°C / 333 K facility safety requirement).

!media msr/sel/sel_transient_flowrate.png
       id=sel_transient_flowrate
       caption=Normalized Pump Head and Flow Rate During the Transient
       style=width:40%

!media msr/sel/sel_transient_saltTemp.png
       id=sel_transient_saltTemp
       caption=Transient Salt Temperatures at Test Section Inlet and Outlet
       style=width:40%

!media msr/sel/sel_transient_PHX.png
       id=sel_transient_PHX
       caption=Transient Fluid Temperatures on Both Sides of PHX
       style=width:40%

!media msr/sel/sel_transient_SHX.png
       id=sel_transient_SHX
       caption=Transient Fluid Temperatures on Both Sides of SHX
       style=width:40%

## Run Command

Both the steady-state and transient models are lightweight and can be run efficiently on a local workstation or laptop. Note that the transient input model relies on the final checkpoint file from the steady-state case to set its initial condition. Therefore, the steady-state model must be run first.

Below is a simple example of how to run the models sequentially:

```language=bash
# Run the steady-state case first to generate the checkpoint file
/path/to/sam-opt -i OnepinSS.i

# Run the transient case
/path/to/sam-opt -i OnepinNC.i
```
