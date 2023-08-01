# Balance of Plant system

The startup transient and load follow input file have the same structure and only differ by their initial condition and control system governing the transient. The components are the same.

## Fluid flow

The [FluidProperties](https://mooseframework.inl.gov/modules/fluid_properties/index.html) blocks are written in the input file in order to declare the properties of the gas in each loop.


!listing microreactors/gcmr/balance_of_plant/htgr_startup_transient.i block=FluidProperties

The friction factor and heat transfer coefficient in each loop are defined using the [Closure1PhaseTHM](https://mooseframework.inl.gov/source/closures/Closures1PhaseTHM.html) closures and the default options:

-  The heat transfer coefficient sub block is defined using the Dittus-Boelter correlation ([ADWallHeatTransferCoefficient3EqnDittusBoelterMaterial](https://mooseframework.inl.gov/source/materials/ADWallHeatTransferCoefficient3EqnDittusBoelterMaterial.html)).

-  The friction factor is defined using the Churchill equation ([ADWallFrictionChurchillMaterial](https://mooseframework.inl.gov/source/materials/ADWallFrictionChurchillMaterial.html)).

!listing microreactors/gcmr/balance_of_plant/htgr_startup_transient.i block=Closures

## Solid Materials

The solid materials of the many heat structures are declared using a [HeatStructureMaterials](https://mooseframework.inl.gov/syntax/HeatStructureMaterials/index.html) block. It gives the properties of three materials: the H-451 graphite and the fuel, used in the core, and the steel, used in the heat exchanger and in the recuperator. Each solid material is defined using the [SolidMaterialProperties](https://mooseframework.inl.gov/source/userobjects/SolidMaterialProperties.html) type. Constant densities, thermal conductivities and specific heats are provided.

!listing microreactors/gcmr/balance_of_plant/htgr_startup_transient.i block=HeatStructureMaterials

## Components

### Geometry

The geometry is defined using the [Components](https://mooseframework.inl.gov/syntax/Components/index.html) system. Each component is defined using a position, orientation and length for 1D components.A width is also defined for 2D components (heat structures). Channels are defined using the  [FlowChannel1Phase](https://mooseframework.inl.gov/source/components/FlowChannel1Phase.html) components and heat structures are defined using the [HeatStructureCylindrical](https://mooseframework.inl.gov/source/components/HeatStructureCylindrical.html) or [HeatStructurePlate](https://mooseframework.inl.gov/source/components/HeatStructurePlate.html) depending on the geometry.

### Initial conditions

A common initial temperature is chosen for the whole system. It is done to avoid irregular effects in the first few seconds of the simulation due to a high temperature difference between the primary and secondary sides in the heat exchanger (`hx`). The only exceptions are the `sec_pipe1` and `hot_leg` of the secondary loop, which are respectively connected to the inlet and outlet of the cycle. Their initial temperature is 300 K.

 In the primary loop, a 90 bar pressure is defined and is equal to the steady state pressure in that loop. The secondary loop is initialized to the atmospheric pressure.

The velocities are initialized at a very small non-zero value.

### Channels

All the channels are defined using [FlowChannel1Phase](https://mooseframework.inl.gov/source/components/FlowChannel1Phase.html) blocks. Depending on the loop, helium or air is declared as the fluid. The initial conditions are those chosen for each loop.


### Primary loop components

!alert note
To make it easier to see the space variations of the pressure, mass flow rate, temperature and power through the primary loop using the "PlotOverLine" filter in Paraview, all its components, except the `pri_pipe6`, are on the same axis and in the same direction. The `pri_pipe6` has the opposite direction and is used to close the cycle.

#### Core

The core geometry is simplified to be able to use a 1D-2D representation. Only one coolant channel is used representing all the coolant channels in the core. It is coupled to a single heat structure representing the moderator and fuel as shown in [simplified_core].


This structure is defined using a [HeatStructureCylindrical](https://mooseframework.inl.gov/source/components/HeatStructureCylindrical.html) component. The radius of the coolant channel is defined in the design description, and the graphite and fuel outer radii are defined to preserve to their total volume.
The average quantity of graphite and of fuel per coolant channel is then computed and used to define the simplified geometry of the heat structure: a cylindrical heat structure, with a coolant cylinder in the middle of a hollow graphite cylinder, itself in a hollow fuel cylinder. This structure is replicated for each coolant channels using the `num_rods` parameter.


The geometrical parameters of the coolant itself are adapted to represent all the coolant channels:

- the channel section `A` is equal to the sum of all the sections of the real coolant channels, because it conducts the same mass flow rate than all the real coolant channels,

- the channel heating perimeter `P_hf` is equal to the sum of the perimeters of all the real channels,

- the hydraulic diameter `D_h` is the one of a real coolant channel because it is linked with the frictions and pressure drop.


!media media/gcmr/balance_of_plant/method_core_simplified.png
      style=display: block;margin-left:auto;margin-right:auto;width:60%;
      id=simplified_core
      caption= Method used to simplify the core

!listing microreactors/gcmr/balance_of_plant/htgr_startup_transient.i block=Components/core

 The 15 MWth power is declared using a `power` block of [TotalPower](https://mooseframework.inl.gov/source/components/TotalPower.html) type.

!listing microreactors/gcmr/balance_of_plant/htgr_startup_transient.i block=Components/total_power

#### Pressurizer

A pressurizer is added to maintain a 90 bar pressure during the whole simulation, using a [InletStagnationPressureTemperature1Phase](https://mooseframework.inl.gov/source/components/InletStagnationPressureTemperature1Phase.html) component. It is located between the core and the heat exchanger, in order to have a pressure as close as possible to 90 bar in the core.

!listing microreactors/gcmr/balance_of_plant/htgr_startup_transient.i block=Components/pressu

#### Heat exchanger

The heat exchanger is modeled as a 2 meters high structure, composed of couples of primary and secondary channels (see [heat_exchanger] ) which are replicated 20,000 times. Their diameters are respectively 3 mm and 5 mm. They are defined using [FlowChannel1Phase](https://mooseframework.inl.gov/source/components/FlowChannel1Phase.html) components. They are separated by a 1 mm steel wall defined using a [HeatStructureCylindrical](https://mooseframework.inl.gov/source/components/HeatStructureCylindrical.html) component, and the flow directions are opposite. The heat transfers are declared with [HeatTransferFromHeatStructure1Phase](https://mooseframework.inl.gov/source/components/HeatTransferFromHeatStructure1Phase.html). The wall is used as heat structure and each channel as the heated flow channel.

The same principle than for the core coolant channel is used to define the `A` section, `P_hf` heating perimeter and `D_h` hydraulic diameter parameters. The replication of the couple is done using the `num_rods` parameter of the `wall` block.

!media media/gcmr/balance_of_plant/heat_exchanger.png
      style=display: block;margin-left:auto;margin-right:auto;width:60%;
      id=heat_exchanger
      caption= Couple of primary and secondary flow channels in the heat exchanger

!listing microreactors/gcmr/balance_of_plant/htgr_startup_transient.i block=Components/hx

#### Pump

The pressure drop is compensated by a pump declared as a [ShaftConnectedPump1Phase](https://mooseframework.inl.gov/source/components/ShaftConnectedPump1Phase.html) component. It is connected to a motor, declared as [ShaftConnectedMotor](https://mooseframework.inl.gov/source/components/ShaftConnectedMotor.html), and a shaft, declared as [Shaft](https://mooseframework.inl.gov/source/components/Shaft.html), which provide its hydraulic torque. The rated values of the pump (volumetric flow rate, head, density, torque, shaft speed) are defined as close as possible to the operating values ([pump_rated_values]).

!table id=pump_rated_values caption= Pump - comparison between the rated and steady state values
| Parameter                     | Rated value | Steady state value |
| :---------------------------- | :---------- | :----------------- |
| Density (kg/m^3^)             | 5           | 4.86               |
| Volumetric flow rate (m^3^/s) | 2           | 1.92               |
| Pump head (m)                 | 350         | 293                |
| Shaft speed (rad/s)           | 5           | 4.5                |
| Torque (N.m)                  | 50          | 42                 |

The performance curves (the Bingham head and torque functions) are defined using a `head_fcn` and a `torque_fcn` functions in the [Functions](https://mooseframework.inl.gov/syntax/Functions/index.html) block, which imports data from `csv` files. The motor torque is set to match the nominal mass flow rate in the loop.

!listing microreactors/gcmr/balance_of_plant/htgr_startup_transient.i block=Components/circ

### Secondary loop components

The secondary loop is a recuperated open-air Brayton cycle and is similar to the one described in the Thermal-Hydraulics Module [Modeling Guide](https://mooseframework.inl.gov/modules/thermal_hydraulics/modeling_guide/recuperated_brayton_cycle/recuperated_brayton_cycle.html).

This input file has been adapted to achieve the nominal operating condition. In particular, the rated values for the turbine and the compressor and the geometrical parameters were adjusted.

The detail of the components is given below.

#### Boundary Conditions

Stagnation pressure and temperature are defined at the inlet of the Brayton cycle using an [InletStagnationPressureTemperature1Phase](https://mooseframework.inl.gov/source/components/InletStagnationPressureTemperature1Phase.html) component with $T_0$ = 300 K and $P_0$ = 1 bar.

!listing microreactors/gcmr/balance_of_plant/htgr_startup_transient.i block=Components/inlet

The pressure is prescribed at the outlet using an [Outlet1Phase](https://mooseframework.inl.gov/source/components/Outlet1Phase.html) component.

!listing microreactors/gcmr/balance_of_plant/htgr_startup_transient.i block=Components/outlet


#### Shaft

The compressor, the turbine, the generator, and the motor are on the same shaft. This component is defined using a [Shaft](https://mooseframework.inl.gov/source/components/Shaft.html) type.

!listing microreactors/gcmr/balance_of_plant/htgr_startup_transient.i block=Components/shaft

#### Compressor

The compressor is defined using the [ShaftConnectedCompressor1Phase](https://mooseframework.inl.gov/source/components/ShaftConnectedCompressor1Phase.html) component type. The `A_ref` section is adapted to admit enough air in the cycle. The rated values (`omega_rated`, `mdot_rated`, `c0_rated`, `rho0_rated`, see [comp_turb]) are defined to match as close as possible to the operating values. The results are given, with those of the turbine, in the next table.


These rated parameters are associated to the efficiency and pressure ratio functions of the compressor, defined in the [Functions](https://mooseframework.inl.gov/syntax/Functions/index.html) block and using data from `csv` files.

!listing microreactors/gcmr/balance_of_plant/htgr_startup_transient.i block=Components/compressor

#### Turbine

A turbine is defined using the [ShaftConnectedCompressorTurbine](https://mooseframework.inl.gov/source/components/ShaftConnectedCompressor1Phase.html) component type: a turbine can be considered as an inverted compressor. The `treat_as_turbine` parameter is defined as “true”.

Once again, the typical section defined by `A_ref` and the rated values (`omega_rated`, `mdot_rated`, `c0_rated`, `rho0_rated`, see [comp_turb]) are adapted to match as close as possible with the operating values. The results are given in [comp_turb_rated_values].

!table id=comp_turb_rated_values caption= Compressor and turbine - comparison between the rated and steady state values
|                       | Compressor   |                     | Turbine      |                     |
| :-------------------- | :----------- | :------------------ | :----------- | :------------------ |
|                       | Rated values | Steady state values | Rated values | Steady state values |
| Density (kg/m^3^)     | 1.2          | 0.8                 | 1.4          | 1.43                |
| Shaft speed (rad/s)   | 9948         | 9329                | 9948         | 9329                |
| Sound speed (m/s)     | 340          | 330                 | 670          | 676                 |
| Mass flow rate (kg/s) | 20           | 20.5                | 20           | 20.5                |

These rated parameters are associated with the efficiency and pressure ratio functions of the turbine, defined in the [Functions](https://mooseframework.inl.gov/syntax/Functions/index.html) block and using data from csv files.


!media media/gcmr/balance_of_plant/comp_turb.png
      style=display: block;margin-left:auto;margin-right:auto;width:60%;
      id=comp_turb
      caption= Compressor and turbine rated parameters

The shaft speed is smaller than the rated value. This difference is due to a margin between the rated value and the value imposed by the PID controller (presented in the next part). In a real system, the shaft speed should not be over the rated value, to avoid damage to the components.

!listing microreactors/gcmr/balance_of_plant/htgr_startup_transient.i block=Components/turbine

#### Generator

A generator is added on the same shaft than the turbine to produce electricity. The [ShaftConnectedMotor](https://mooseframework.inl.gov/source/components/ShaftConnectedMotor.html) component type is once again used. The generator torque is defined as follow:

\begin{equation}
    \Gamma=C\omega
\end{equation}

\begin{equation}
    P(generator)=\Gamma\omega
\end{equation}

C is defined to generate 2 MWe at the rated shaft speed:

\begin{equation}
    C=-0.025W.s^2
\end{equation}

This parameter is used in the [Functions](https://mooseframework.inl.gov/syntax/Functions/index.html) block by the `generator_torque_fn`. This one is used to define the torque of the generator in the component block. Not that the negative sign is because energy is extracted.

!listing microreactors/gcmr/balance_of_plant/htgr_startup_transient.i block=Components/generator

#### Motor

A motor component of [ShaftConnectedMotor](https://mooseframework.inl.gov/source/components/ShaftConnectedMotor.html) type is added and connected to the [Shaft](https://mooseframework.inl.gov/source/components/Shaft.html). Its behavior is defined by the [Control](https://mooseframework.inl.gov/syntax/Controls/index.html) and [ControlLogic](https://mooseframework.inl.gov/syntax/ControlLogic/index.html) blocks (see below).

!listing microreactors/gcmr/balance_of_plant/htgr_startup_transient.i block=Components/motor

#### Recuperator

The recuperator includes two countercurrent coolant channels (the `hot_leg` and `cold_leg`). A [HeatStructureCylindrical](https://mooseframework.inl.gov/source/components/HeatStructureCylindrical.html) component is added to couple these two channels, and two heat transfers are defined using the [HeatTransferFromHeatStructure1Phase](https://mooseframework.inl.gov/source/components/HeatTransferFromHeatStructure1Phase.html). Each of them couples a channel with the heat structure.

!listing microreactors/gcmr/balance_of_plant/htgr_startup_transient.i block=Components/cold_leg


!listing microreactors/gcmr/balance_of_plant/htgr_startup_transient.i block=Components/hot_leg


!listing microreactors/gcmr/balance_of_plant/htgr_startup_transient.i block=Components/recuperator


!listing microreactors/gcmr/balance_of_plant/htgr_startup_transient.i block=Components/heat_transfer_cold_leg


!listing microreactors/gcmr/balance_of_plant/htgr_startup_transient.i block=Components/heat_transfer_hot_leg



## Controls

A [ControlLogic](https://mooseframework.inl.gov/syntax/ControlLogic/index.html) block is added to control the motor torque.

The `initial_motor_PID` of type [PIDControl](https://mooseframework.inl.gov/source/controllogic/PIDControl.html) defines the behavior of the motor at the beginning. It depends on the `set_point` block, whose type is a [GetFunctionValueControl](https://mooseframework.inl.gov/source/controllogic/GetFunctionValueControl.html). It declares the desired shaft speed, which is the rated shaft speed minus 9000 rpm (see the turbine paragraph)

As the shaft speed  and heat transfer from the core progressively increase,  the turbine generates torque and the need of the motor torque becomes smaller. Thus, it progressively decreases, and it is finally  shut.

A `motor_PID`, whose type is [SetComponentRealValueControl](https://mooseframework.inl.gov/source/controllogic/SetComponentRealValueControl.html), decides which value must be attributed to the motor torque. If the motor torque is too small, the motor is shut, using a `motor_torque_fn_shutdown` function written in the [Functions](https://mooseframework.inl.gov/syntax/Functions/index.html) block. Else, the behavior of the motor is still defined by the [PIDControl](https://mooseframework.inl.gov/source/controllogic/PIDControl.html). This condition is defined using the `logic` block, whose type is [ParsedFunctionControl](https://mooseframework.inl.gov/source/controllogic/ParsedFunctionControl.html). In this one, a time condition is added: if the elapsed time is too small, the condition on the motor torque value is not applicable. At the beginning of the simulation: the motor torque is small and increasing, but it should not be shut.

!listing microreactors/gcmr/balance_of_plant/htgr_startup_transient.i block=ControlLogic

## Startup and load follow transient

The model description above defines mainly the model used for the startup transient. In the case of the load follow transient, some blocks and parameters are disabled, because the system starts from the operating values computed in the startup transient. The following elements are commented:

- the `initial_vel`, `initial_vel_x`, `initial_vel_y`, `initial_vel_z`, `initial_T`, `initial_p` in the [GlobalParams](https://mooseframework.inl.gov/syntax/GlobalParams/index.html) and in the various components where they were defined (pipes, junctions, etc.),

- the `is_tripped_fn`, `PID_tripped_constant_value`, `PID_tripped_status_fn`, `sec_motor_torque_fn_shutdown` [Functions](https://mooseframework.inl.gov/syntax/Functions/index.html), which defined in the startup transient the motor behavior,

- the `time_trip_aux` and `PID_trip_status_aux` [AuxScalarKernels](https://mooseframework.inl.gov/syntax/AuxScalarKernels/index.html), which associated the previous functions results to the `time_trip` and `PID_trip_status` [AuxVariables](https://mooseframework.inl.gov/syntax/AuxVariables/index.html),

- the [ControlLogic](https://mooseframework.inl.gov/syntax/ControlLogic/index.html) blocks that gave the retroaction on the motor behavior: the `set_point`, `initial_motor_PID`, `logic` and `motor_PID`,

- the [Controls](https://mooseframework.inl.gov/syntax/Controls/index.html) that are associated: `PID_trip_status` and `time_PID`.

The [AuxVariables](https://mooseframework.inl.gov/syntax/AuxVariables/index.html) defined to control the motor behavior are not disabled because the input file of the load follow transient needs to import data from the startup transient. To do so, some of the defined objects in the two input file, particularly the [AuxVariables](https://mooseframework.inl.gov/syntax/AuxVariables/index.html), need to be the same.

Two [ControlLogic](https://mooseframework.inl.gov/syntax/ControlLogic/index.html) blocks are added to impose the core power during the load follow transient. A `power_logic`, whose type is [ParsedFunctionControl](https://mooseframework.inl.gov/source/controllogic/ParsedFunctionControl.html), calls a `power_fn` function, which defines the power dependance on the time. It is then transferred to a `power_applied` sub block (of [SetComponentRealValueControl](https://mooseframework.inl.gov/source/controllogic/SetComponentRealValueControl.html)) which indicates to attribute this behavior to the `total_power` component block.

!listing microreactors/gcmr/balance_of_plant/htgr_load_follow_transient.i block=ControlLogic

The data are transferred from the startup transient results to the load follow simulation using a supplemental output in the first input file. In the [Outputs](https://mooseframework.inl.gov/syntax/Outputs/index.html) block, the `checkpoint` parameter is defined as `true`. The results saved in this output are then called in a [Problem](https://mooseframework.inl.gov/syntax/Problem/index.html) block in the load follow input file.

!listing microreactors/gcmr/balance_of_plant/htgr_startup_transient.i block=Outputs

!listing microreactors/gcmr/balance_of_plant/htgr_load_follow_transient.i block=Problem
