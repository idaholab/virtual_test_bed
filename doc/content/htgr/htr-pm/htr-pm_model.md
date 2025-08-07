# SAM Generic PBR Model

*Contact: Zhiee Jhia Ooi, zooi@anl.gov, Stephen Bajorek, stephen.bajorek@nrc.gov*

*Model link: [HTR-PM SAM Model](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/htr-pm/ss)*

This is a SAM [!citep](Hu2021) reference plant model for the 250 MWth HTR-PM reactor. The model consists of three individual models namely the core, primary loop, and reactor cavity cooling system (RCCS). The schematic of the reference plant model is shown in [htr-pm/ss-loop-schematic]. The core is modeled using SAM's multi dimensional flow model in 2-D RZ geometry while the primary loop and RCCS are modeled with SAM's 0-D and 1-D components. The MOOSE MultiApp system [!citep](multiapp_gaston2015) is used to couple the three models.

!media htrpm_sam/loop-schematics-VTB.png
        style=width:70%
        id=htr-pm/ss-loop-schematic
        caption=Schematic of the SAM HTR-PM reference plant model.

The schematic of the 2-D RZ core model is shown in [htr-pm/ss-core-schematic]. The pebble bed, top and bottom reflectors, and the top cavity are modeled as porous media with varying porosity while the side reflectors, graphite blocks, core barrel, reactor pressure vessel (RPV), and helium gaps are modeled as solid. The hot and cold plena are not meshed in the 2-D model. Instead, they are modeled as 0-D volume branches using the SAM component system in the primary loop. On the other hand, the riser and bypass channels are modeled using an approach that utilizes both the 2-D meshes and the 1-D component system. In the 2-D model, the bypass and riser channels are meshed. However, they are treated as solid components (rather than porous media) whose thermal physical properties are reduced by a factor of $1-porosity$. This means that in the 2-D mesh, there is no fluid flow in the riser and bypass channels. Instead, the fluid flow in these two channels are modeled as 1-D flow using `PBOneDFluidComponent` in the primary loop model. Conjugate heat transfer between these channels with the surrounding 2-D solid structures is also modeled. This combined approach avoids the need to mesh the two channels in the 2-D model while at the same time still captures the radial conduction of heat from the core to the surrounding reflectors.

!media htrpm_sam/htr_pm_schematics.png
        style=width:70%
        id=htr-pm/ss-core-schematic
        caption=Schematic of the SAM 2-D RZ HTR-PM core model [!citep](htrpm_jaradat2023).

The primary loop consists of a blower, heat exchanger, and a series of flow channels. Note that the HTR-PM has a concentric channel for the inlet and outlet helium flows where the cold helium flows into the core in the outer annulus layer while the hot helium flows out of the core in the inner channel. In the primary loop model, a heat structure is added as the channel wall to model the heat transfer between the cold and hot channels. A time-dependent volume is used to provide a reference pressure of 7 MPa to the loop during steady-state normal operating condition. On the secondary side of the heat exchanger, a time-dependent junction with a velocity and temperature boundary condition is used to model the inlet while a time-dependent volume with a pressure boundary condition is used to model the outlet. The RCCS model consists of an RCCS panel, a reservoir, a heat exchanger to remove heat from the reservoir, and a series of flow channels. Heat is transferred from the RPV to the RCCS panel through thermal radiation. Flow in the RCCS loop is driven by natural circulation.

The MOOSE MultiApp system [!citep](multiapp_gaston2015) is used to couple the three models. As shown in [MultiApp], the coupled model consists of one `MainApp` and two `SubApps`. The 2-D media acts as the `MainApp` that controls and facilitates the exchange of information between itself and the two `SubApps`. Inlet and outlet boundary conditions such as pressures, velocities, and temperatures are exchanged between the 2-D core and the primary loop. Furthermore, to model the conjugate heat transfer between the riser/bypass channels with the surrounding reflectors, fluid temperatures and heat transfer coefficients are transferred from the primary loop model to the 2-D model while the wall temperature from the 2-D model is transferred to the primary loop model. Similarly, to model the heat transfer between the 2-D model and the RCCS model, radiation heat flux is transferred from the 2-D model to the RCCS model where it is set as a heat flux boundary condition on the inner surface of the RCCS panel. In return, the wall temperature of the inner surface of the RCCS panel is transferred back to the 2-D model where it is used as the $T_{\infty}$ for the radiative boundary condition set on the outer surface of the RPV. Picard iterations are used to ensure convergence between the models.

!media htrpm_sam/MultiApp.png
        style=width:70%
        id=MultiApp
        caption=Coupling of the SAM models with the MultiApp system.

The domain-overlapping approach [!citep](domain_overlap_huxford2023) is used to accurately model the mass flow rate and pressure drop between the 2-D model and the primary loop model. A graphical representation of the approach is shown in [DomainOverlap]. In the primary loop model, the 2-D core is represented with a 1-D surrogate channel. Pressure drop across the 2-D core is calculated and transferred to the primary loop where a corresponding friction factor is calculated and imposed to the 1-D surrogate channel. In addition to the exchange of pressure drop information, by ensuring that the 2-D core and 1-D surrogate channels have the same boundary conditions at the inlet and outlet, the mass flow rate and the energy balance between the two models are conserved.

!media htrpm_sam/DomainOverlap.png
        style=width:70%
        id=DomainOverlap
        caption=Domain overlapping approach used to model fluid flow.

# Problem Description

## Steady-state

A steady-state normal operating condition is simulated with the SAM HTR-PM reference plant model. The operating conditions during steady-state are tabulated in [ss-condition]. The reactor has a power output of 250 MWth and operates at 7 MPa. It is helium cooled with a system mass flow rate of 96 kg/s where the helium enters and leaves the reactor at 523.15 K and 1023.15 K, respectively. The core contains about 420,000 fuel pebbles that are 6 cm in diameter with an average packing fraction of 0.61 [!citep](htrpm_jaradat2023). In this model, neutronics calculations are not performed. Instead, a power density distribution obtained from the work by Jaradat et. al. [!citep](htrpm_jaradat2023) is imposed to the 2-D core.

!media htrpm_sam/ss-condition.png
        style=width:70%
        id=ss-condition
        caption=Steady-state normal operating condition of HTR-PM [!citep](htrpm_jaradat2023).

## Pressurized Loss of Forced Cooling (PLOFC) Transient

The Pressurized Loss of Forced Cooling (PLOFC) transient is simulated. The sequence of events of the simulated PLOFC is shown in [PLOFC_sequence]. The model is first simulated until steady-state is achieved. At the start of the transient, the reactor is SCRAM and a decay heat curve is used to determine the reactor power level throughout the accident. At the same time, the helium flow rate is reduced linearly from the nominal value to zero over 13 seconds. During the accident, the pressure boundary is assumed to be intact where the system pressure is maintained at 7 MPa. Given the absence of forced flow, decay heat from the core is transferred first to the surrounding reflector, and then the graphite blocks, core barrel, and RPV. Heat is ultimately radiated from the outer surface of the RPV to the RCCS panel where it is ultimately removed by the water flow in the RCCS. Simultaneously, natural circulation is also established within the core due to density differences of helium at different elevations.

It should be pointed out that for PLOFC, a reduced primay loop model is used. Given that the pump and heat exchanger are essentially unused during the transient, they are removed to reduce the complexity of the model. Instead, an inlet boundary condition specifying the helium flow velocity and temperature is prescribed at the inlet of the riser while a pressure boundary condition is specified at the outlet of the hot plenum.

!media htrpm_sam/PLOFC_sequence.png
        style=width:70%
        id=PLOFC_sequence
        caption=Sequence of events during PLOFC.

# Input File Descriptions - Steady-state Normal Operating Condition

SAM uses a block-structured input syntax. Each block begins with square brackets which contain the type of input and ends with empty square brackets. Each block may contain sub-blocks. The blocks in the input file are described in the order as they appear. In the subsequent sections, input file the 2-D porous medium core model is first described, followed by the 0-D/1-D primary loop model and the RCCS model.

## 2-D Porous Medium Core Model

Parameters and variables that are used repeatedly in the input file are first defined. Some of these include the block names, sideset names, geometry information, boundary conditions, etc.

### Global parameters

Parameters that are globally true are defined in this block. Some of these include the direction of gravity, the name of Equation of State (eos) used, and the name of parameters such as velocity (in x and y directions), pressure, temperature, and density. By doing so, users can avoid defining these parameters in the subsequent blocks where the definitions of these parameters are required. However, it should be pointed out that the global definition can be overwritten by simply defining them separately in a block. Note that the velocity in x and y directions are defined as `u` and `v` here, respectively.

!listing htgr/htr-pm/ss-main.i block=GlobalParams language=cpp

### Mesh

The mesh file is specified in this block. In this model, the mesh file is in Exodus (.e) format. If R-Z coordinate is used, the direction of the vertical axis also needs to be specified.

!listing htgr/htr-pm/ss-main.i block=Mesh language=cpp

### Problem

This block specifies the type of problem being solved by SAM. The type of coordinate system used in the model is also specified here. Note that if not provided, SAM assumes a Cartesian coordinate by default.

!listing htgr/htr-pm/ss-main.i block=Problem language=cpp

To restart a simulation, the location of the checkpoint file is specified with the `restart_file_base` parameter. The keyword `LATEST` is used to restart the problem from the most recent checkpoint.

```language=bash
  restart_file_base = '<location_of_checkpoint_file>/LATEST'
```

### Functions

Functions are defined in this block. Some examples of function types are `PieceWiseLinear`, `CompositeFunction`, and `ParsedFunction`. The `PieceWiseLinear` function is used to define the change of a parameter with respect to position or time. Below is an example of a time-dependent `PieceWiseLinear` function:

!listing htgr/htr-pm/ss-main.i block=Q_time language=cpp

For a position-dependent `PieceWiseLinear` function, the parameter `axis` is used to define the direction in which the position is changing.

!listing htgr/htr-pm/ss-main.i block=Q_axial language=cpp

A `CompositeFunction` is used to combine multiple functions, as shown below:

!listing htgr/htr-pm/ss-main.i block=Q_fn language=cpp

A `ParsedFunction` allows operation to be performed to an variable. The variable can be postprocessor outputs or other variables. The example below shows how the average temperature is calculated using the inlet and outlet temperatures obtained from two postprocessors named `2Dreceiver_temperature_in` and `2Dreceiver_temperature_out`.

!listing htgr/htr-pm/ss-main.i block=T_reactor_in T_core_out language=cpp

### EOS

This block specifies the Equation of State. The user can choose from built-in fluid library for common fluids like air, nitrogen, helium, sodium, molten salts, etc. The user can also input the properties of the fluid as constants or function of temperature. This model uses a combination of constant and temperature-dependent values for helium properties:

!listing htgr/htr-pm/ss-main.i block=EOS language=cpp

### MaterialProperties

Material properties are input in this block. The values can be constants or temperature dependent as defined in the Functions block. In this model, constant material properties are used

!listing htgr/htr-pm/ss-main.i block=MaterialProperties language=cpp

### Variables

This block is used to input the variables in the model, namely velocities in the $x$ and $y$ (or $r$ and $z$) directions, pressure, fluid temperature, and solid temperature, with each variable defined in an individual sub-block. In the sub-block, the scaling factor and initial condition are defined for each variable. Additionally, the `block` parameter is used to specify the block names at which the variable exists. For instance, fluid temperature is only defined in the fluid blocks and not solid blocks.

!listing htgr/htr-pm/ss-main.i block=Variables language=cpp

### AuxVariables

This block is used to input auxiliary variables, which are used to compute or store intermediate quantities that are not the main variables (the ones being solved for) of the equation system. Similar to `Variables`, initial condition and block can be specified for `AuxVariables`. Users can also set the order and family of the `AuxVariables` to fit their needs. For instance, porosity is defined as an `AuxVariable` with a `CONSTANT` order and a `MONOMIAL` family.

!listing htgr/htr-pm/ss-main.i block=AuxVariables language=cpp

### Materials

This block is used to set material properties of solid and porous blocks using the input from the `MaterialProperties` block defined earlier. For components where heat conduction is modeled, `SAMHeatConductionMaterial` is used such as:

!listing htgr/htr-pm/ss-main.i block=pebble_mat graphite_mat graphite_porous_mat core_barrel_steel_mat rpv_steel_mat He_gap_mat language=cpp

For porous region where convection is modeled, `PorousFluidMaterial` is used, as shown below. The correlations used for computing heat transfer and frictional pressure drop coefficients are specified here along with other pebble geometry information.

!listing htgr/htr-pm/ss-main.i block=pebble_bed language=cpp

Heat transfer in the pebble bed is a complex phenomenon that involves pebble-pebble conduction, pebble-fluid convection, and pebble-pebble radiation. For simplicity, an effective thermal conductivity, $k_{eff}$, is often used to model these heat transfer mechanisms rather than modeling them individually. One widely used correlation to compute $k_{eff}$ is the ZBS correlation [!citep](PBMR400). In SAM, $k_{eff}$ is defined using `PebbleBedEffectiveThermalConductivity` as shown below:

!listing htgr/htr-pm/ss-main.i block=pebble_keff language=cpp

### Kernels

The block is used to define the physics of the model. In SAM, the governing equations are essentially divided into the time derivative and spatial terms. The mass equation is modeled using `PINSFEFluidPressureTimeDerivative` and `MDFluidMassKernel` as below:

!listing htgr/htr-pm/ss-main.i block=mass_time mass_space language=cpp

The $x$ and $y$ momentum terms are modeled with `PINSFEFluidVelocityTimeDerivative` and `MDFluidMomentumKernel`. Note that the `component` parameter in `MDFluidMomentumKernel` is defined as `0` and `1` for $x$ and $y$ momentum, respectively.

!listing htgr/htr-pm/ss-main.i block=mass_time x_momentum_time x_momentum_space y_momentum_time y_momentum_space language=cpp

Fluid energy is modeled with `PINSFEFluidTemperatureTimeDerivative`, `MDFluidEnergyKernel`, and `PorousMediumEnergyKernel`. The first two model the time derivative and spatial terms of the fluid heat transfer equation while the third models the heat transfer between fluid and solid.

!listing htgr/htr-pm/ss-main.i block=temperature_time temperature_space temperature_heat_transfer language=cpp

Pebble heat transfer is modeled with `PMSolidTemperatureTimeDerivative` and `PMSolidTemperatureKernel`. For region with heat generation, the `power_density_var` term is set to the name of the `AuxVariable` for power density.

!listing htgr/htr-pm/ss-main.i block=solid_time solid_conduction solid_conduction_core language=cpp

Heat conduction in pure solid regions is modeled with `HeatConductionTimeDerivative` and `HeatConduction`:

!listing htgr/htr-pm/ss-main.i block=transient_term_reflector diffusion_term_reflector language=cpp

### AuxKernels

The AuxKernel system mimics the kernels system but compute values that can be defined explicitly with a known function. In SAM, density is modeled using `DensityAux` as:

!listing htgr/htr-pm/ss-main.i block=rho_aux language=cpp

Porosities of different regions are also modeled using `ConstantAux` as:

!listing htgr/htr-pm/ss-main.i block=porosity_bed porosity_reflector_top porosity_reflector_bottom porosity_top_cavity language=cpp

Lastly, the power density is modeled using `FunctionAux` as:

!listing htgr/htr-pm/ss-main.i block=power_density language=cpp

### BCs

This block sets the boundary conditions of the model. The inlet conditions are set using `MDFluidMassBC` as below where the `boundary` parameter is set to the inlet of the model.

!listing htgr/htr-pm/ss-main.i block=BC_inlet_mass language=cpp

The $x$ and $y$ inlet momentum boundary conditions are set using `DirichletBC` and `PostprocessorDirichletBC`, respectively as below:

!listing htgr/htr-pm/ss-main.i block=BC_inlet_x_mom BC_inlet_y_mom language=cpp

In this model, the inlet is taken as the top of the core and the inlet flow is assumed to be fully vertically downward. As a result, the $x$ momentum is set to zero at the inlet. Conversely, for the $y$ velocity (momentum), the inlet value is set to the value obtained by the `2Dreceiver_velocity_in` postprocessor.

The inlet temperature is set using `INSFEFluidEnergyDirichletBC` as below where the `out_norm` parameter is used to set the outward normal of the inlet boundary or sideset.

!listing htgr/htr-pm/ss-main.i block=BC_inlet_T language=cpp

At the outlet of the core, a pressure boundary condition is set as below using `DirichletBC`. Note that the value of the pressure is set at zero at outlet boundary because the EOS used in this model is incompressible (temperature dependent only), hence the value of the pressure has no effect on the simulation results.

!listing htgr/htr-pm/ss-main.i block=BC_outlet_mass language=cpp

Additionally, a flow direction-dependent outlet temperature is set using `INSFEFluidEnergyDirichletBC` as below. Note that this boundary condition is only applicable if the helium flow direction is reversed. Such a reversal may happen during certain transients where forced flow is lost.

!listing htgr/htr-pm/ss-main.i block=BC_outlet_T language=cpp

A zero flow boundary condition is set for flow in the $x$ direction at the wall as no fluid can enter or exit the wall.

!listing htgr/htr-pm/ss-main.i block=BC_fluidWall_x_mom language=cpp

The conjugate heat transfer between the walls of the bypass and riser channels in the 2-D model and the fluids in 1-D channel in the primary loop model is modeled as below. The `T_infinity` and `htc` parameters are set to `AuxVariables` whose values are set using the MultiApp system based on their corresponding variables in the 1-D primary loop model.

!listing htgr/htr-pm/ss-main.i block=HeatTransfer_bypass_inner_wall HeatTransfer_riser_inner_wall language=cpp

The radiation heat transfer between the RPV outer surface and the RCCS panel in the 1-D RCCS model is modeled as below. In this approach, `TRad` is an `AuxVariable` that takes its value from the inner wall temperature of the RCCS panel in the 1-D RCCS model.

!listing htgr/htr-pm/ss-main.i block=HeatTransfer_bypass_inner_wall RPV_out language=cpp

### Postprocessors

In this block, postprocessors are set up to obtain simulation results from the model. Below are some examples of of postprocessors from the input file.

!listing htgr/htr-pm/ss-main.i block=Postprocessors language=cpp

Furthermore, using `Receiver` type postprocessors, values of postprocessors from the 1-D primary loop and RCCS models can be transferred to the 2-D model, such as

!listing htgr/htr-pm/ss-main.i block=2Dreceiver_temperature_in language=cpp

### MultiApps

THe MultiApp system is set up in this block. Two sub blocks are included here - one for each of the SubApps.  `TransientMultiApp` is used here as all of the models are set up to perform transient analyses. The `catch_up` parameter is set to `True` to allow failed solves to attempt to 'catch up' using smaller timesteps.

!listing htgr/htr-pm/ss-main.i block=MultiApps language=cpp

### Transfers

This block is used to control the transfer of information between the `MainApp` and the `SubApps`.  `MultiAppPostprocessorTransfer` is used to transfer postprocessor values between the `Apps`. The example below shows the transfer of postprocessor (`2Dsource_temperature_in`) value in the 2-D model to another postprocessor (`1Dreceiver_temperature_in`) in the primary loop model.

!listing htgr/htr-pm/ss-main.i block=2Dto1D_temperature_in_transfer language=cpp

`MultiAppUserObjectTransfer` is used to transfer the value of an `UserObject` from one `App` to a `variable` on the other `App` as below. The `direction` parameter is used to determine the direction of the data transfer, i.e. from `MainApp` to `SubApp` or the other way round where the `multi_app` parameter is used for setting the `SubApp` of choice.

!listing htgr/htr-pm/ss-main.i block=To_subApp_Twall_riser language=cpp

`MultiAppGeneralFieldNearestNodeTransfer` is used to directly transfer field data between the `Apps` based on their nodal positions:

!listing htgr/htr-pm/ss-main.i block=from_subApp_T_fluid language=cpp

In this example, temperature is transferred from the primary loop model (`SubApp`) to the 2-D model (`MainApp`), hence, the `direction` is set to `from_multiapp` with the `multi_app` being the primary loop model. `source_variable` is used to set the variable in the `SubApp` that is to be transferred to the `MainApp`. On the other hand, `variable` is the name of the variable in the `MainApp` to receive the transferred value. Since the transfer mechanism is based on the positions of the models, there is a possibility that the wrong field data may be transferred. To avoid that, the `from_blocks` and `to_blocks` options are set to make sure that the data transfer only involves the correct blocks.

### UserObjects

This `UserObjects` system is used to perform custom algorithms or calculations that may not fit well within any other system in MOOSE.

!listing htgr/htr-pm/ss-main.i block=UserObjects language=cpp

In this model, `LayeredSideAverage` is used to obtain the layered average field data such as the wall temperatures on the riser and bypass channels and the radiative heat flux on the RPV outer wall. The `num_layers` option is used to set the number of layers over which a field data is averaged and the `direction` option is used to set the averaging direction.

### Preconditioning

This block describes the preconditioner to be used by the preconditioned JFNK
solver (available through PETSc). Two options are currently available,
the single matrix preconditioner (SMP) and the finite difference preconditioner (FDP) (for debugging only).
The theory behind the preconditioner can be found in the SAM Theory Manual [!citep](Hu2021).
New users can leave this block unchanged.

!listing htgr/htr-pm/ss-main.i block=Preconditioning language=cpp

### Executioner

This block describes the calculation process flow. The user can specify the
start time, end time, time step size for the simulation. The user can also choose
to use an adaptive time step size with the [IterationAdaptiveDT time stepper](https://mooseframework.inl.gov/source/timesteppers/IterationAdaptiveDT.html).
Other inputs in this block include PETSc solver options, convergence tolerance,
quadrature for elements, etc.

!listing htgr/htr-pm/ss-main.i block=Executioner language=cpp

### Outputs

This block is used to control the information to be output by the model. Users can choose the output format as `Exodus` and/or `CSV` files. Checkpoint files can also be produced. User can set the output frequency via the `interval` option.

!listing htgr/htr-pm/ss-main.i block=Outputs language=cpp

## 0-D/1-D Primary Loop Model

The input file of the 0-D/1-D primary loop model is described here. Some of the blocks in this file are similar to the input file of the porous media model and will not be repeated here. These include the `[GlobalParams], [Functions], [EOS], [MaterialProperties], [Postprocessors], [Preconditioning], [Executioner]` and `[Outputs]` blocks. Instead, this section focuses on the `[Components]` block to describe the actual model.

As described earlier, the so-called domain overlapping approach is used to couple the multi-D porous media model to the 0-D/1-D primary loop. The primary loop model essentially consists of two parts: a surrogate channel to represent the multi-D core and a remainder of the primary loop with flow channels, pump, heat exchanger, etc.

The surrogate channel consists of a `PBOneDFluidComponent` with inlet and outlet boundary conditions.

!listing htgr/htr-pm/ss-primary-loop-full.i block=core_pipe language=cpp

The geometric information such as the length, flow area, hydraulic diameter, position, etc. are the same as that in the porous media model. In the domain overlapping approach, frictional pressure drop in the porous media model is computed and then applied to the surrogate channel. The pressure drop is then used by the code to internally calculate a friction factor that is then applied to the surrogate channel. By doing so, the flow rate in the surrogate channel is ensured to be the same as that in the porous media model. This capability is enabled by setting `overlap_coupled` to `true`. The `overlap_pp` parameter sets the postprocessor name that receives the pressure drop information from the porous media model. Note that pressure drop is defined as the change of pressure per unit length, $dP/dZ$, with a unit of Pa/m, and NOT the total pressure drop across the core.

The inlet and outlet boundary conditions are set using a coupled postprocessor time-dependent junction (CoupledPPSTDJ) and coupled postprocessor time-dependent volume (CoupledPPSTDV), respectively. At the inlet, the velocity and temperature boundary conditions are set to the mean values obtained from the inlet of the multi-D model using their respective postprocessors. On the other hand, at the outlet, using their respective postprocessors, the temperature is set to the mean temperature obtained at the outlet of the multi-D model while the pressure is set to the pressure of the hot plenum.

!listing htgr/htr-pm/ss-primary-loop-full.i block=coupled_inlet_top coupled_outlet language=cpp

Other than the surrogate channel, the remainder of the primary loop is shown in [htr-pm/ss-loop-schematic]. In this model, the hot plenum can be seen as the inlet and the cold plenum the outlet. To couple the outlet of the surrogate channel to the hot plenum, the outlet conditions of the surrogate channel are used as the inlet conditions of the hot plenum. The hot plenum is modeled using the `PBVolumeBranch` component as:

!listing htgr/htr-pm/ss-primary-loop-full.i block=hot_plenum language=cpp

Given that boundary conditions cannot be directly set to a `PBVolumeBranch`, a short pipe called the 'hot_plenum_inlet_pipe' is connected to the 'hot_plenum' on one end, while the end is set to the outlet conditions from the surrogate channel using the `CoupledPPSTDJ` component as:

!listing htgr/htr-pm/ss-primary-loop-full.i block=coupled_inlet language=cpp

After the hot plenum is a horizontal flow channel known as the 'outlet_pipe':

!listing htgr/htr-pm/ss-primary-loop-full.i block=outlet_pipe language=cpp

Downstream of 'outlet_pipe' is a `PBVolumeBranch` known as 'SG_inlet_plenum' that connects the outlet pipe to the heat exchanger:

!listing htgr/htr-pm/ss-primary-loop-full.i block=SG_inlet_plenum language=cpp

The heat exchanger is intended to represent the steam generator in the actual HTR-PM reactor. The geometries of the heat exchanger used in this work are obtained from publicly available information:

!listing htgr/htr-pm/ss-primary-loop-full.i block=IHX language=cpp

Water is used as the coolant on the secondary side of the heat exchanger. For simplicity, the secondary side is not modeled and is simply given inlet and outlet boundary conditions:

!listing htgr/htr-pm/ss-primary-loop-full.i block=IHX2-in IHX2-out language=cpp

Similar to the inlet, the outlet of the heat exchanger is connected to a `PBVolumeBranch` component:

!listing htgr/htr-pm/ss-primary-loop-full.i block=SG_outlet_plenum language=cpp

Downstream of the heat exchanger is another flow channel that connects the outlet of the heat exchanger to the inlet of the blower:

!listing htgr/htr-pm/ss-primary-loop-full.i block=SG_outlet_pipe language=cpp

The outlet of 'SG_outlet_pipe' is connected to the blower through a `PBVolumeBranch`:

!listing htgr/htr-pm/ss-primary-loop-full.i block=pump_inlet_plenum language=cpp

Additionally, the reference pressure of the system is set using a `PBTDV` component that is connected to 'pump_inlet_plenum'. During steady-state, the system pressre is set to 7 MPa.

!listing htgr/htr-pm/ss-primary-loop-full.i block=ref_pressure_pipe reference_pressure language=cpp

Downstream of that is a flow channel that connects the `PBVolumeBranch` to the blower:

!listing htgr/htr-pm/ss-primary-loop-full.i block=pump_inlet_pipe language=cpp

The blower is modeled using the `PBPump` component. Note that the pump head is set using the 'f_pump_head' function via the `Head_fn` parameter. The pump head and the k-loss values are tuned such that the steady-state mass flow rate is 96 kg/s.

!listing htgr/htr-pm/ss-primary-loop-full.i block=blower language=cpp

Located downstream of the blower are a pipe and a `PBVolumeBranch` that is connected to the horizontal inlet pipe:

!listing htgr/htr-pm/ss-primary-loop-full.i block=pump_outlet_pipe pump_outlet_branch inlet_pipe language=cpp

 The outlet of the horizontal inlet pipe is connected to the inlet of the riser. In order to accurately account for the heat transfer between the 2-D surfaces and the riser, the heat transfer area density is set via the `HT_surface_area_density` parameter.

!listing htgr/htr-pm/ss-primary-loop-full.i block=riser joint_outlet_1 language=cpp

The outlet of the riser is connected to the cold plenum:

!listing htgr/htr-pm/ss-primary-loop-full.i block=cold_plenum language=cpp

A bypass channel connects the cold and hot plena. Similar to the riser, the heat transfer area density of the bypass channel is set to accurately capture the heat transfer between the helium in the bypass channel and the surrounding 2-D solid structures. A friction factor, `f`, is tuned such that the flow in the bypass channel is roughly 1 kg/s:

!listing htgr/htr-pm/ss-primary-loop-full.i block=bypass language=cpp

The cold plenum can be seen as the outlet of the primary loop. Similar to the hot plenum, a small pipe is connected to the cold plenum on one end where the boundary conditions are set on the other end using the `CoupledPPSTDV` component. The outlet pressure is set to the pressure at the outlet of the surrogate channel while the temperature is set to the mean temperature at the inlet of the 2-D core:

!listing htgr/htr-pm/ss-primary-loop-full.i block=cold_plenum_outlet_pipe coupled_outlet_top language=cpp

The wall separating the horizontal inlet and outlet pipes is modeled using a `PBCoupledHeatStructure`. The boundary conditions both sides of the wall are set to `Coupled` to model the heat transfer between the helium in the inlet and outlet pipe across the wall.

!listing htgr/htr-pm/ss-primary-loop-full.i block=concentric-pipe-wall language=cpp

The `HeatTransferWithExternalHeatStructure` is used to model the heat transfer between the solids in the multi-D model and the 1-D bypass and riser channels in the primary loop model. In this approach, the wall temperatures from the 2-D model are transferred to 1-D channels. In return, the 2-D walls receive the fluid temperatures and the heat transfer coefficients from the 1-D channels. The `T_wall_name` is the variable name to which the MultiApp transfers the wall temperatures from the multi-D model.

!listing htgr/htr-pm/ss-primary-loop-full.i block=from_main_app_riser from_main_app_bypass language=cpp

## 0-D/1-D RCCS Model

The input file of the 0-D/1-D model is described here. Similarly, blocks that are repeated in other input files will not be discussed here. Note that the RCCS model is loosely based on the actual system whose information is obtained from multiple sources in the public domain and the geometry information is not representative of the actual system.

The RCCS panel in the model receives heat flux from the outer surface of the RPV in the multi-D porous media model via thermal radiation. To do so, an `AuxVariable` named 'QRad' is defined to receive that flux. Note that the name of the `AuxVariable` ('QRad' in this case) must match the name provided in the `[QRad_to_subRCCS]` block in the multi-D model. At the same time, due to the difference in the surface area of the RPV and the RCCS panel, the heat flux needs to be properly scaled to ensure energy conservation. This is done through another `AuxVariable` named 'QRad_multiplied'.

!listing htgr/htr-pm/ss-rccs-water.i block=AuxVariables language=cpp

The scaling of the heat flux is performed through an `AuxKernel` of type `ParsedAux`. The scaling factor is defined as the ratio between the RPV surface area to the RCCS panel surface area.

!listing htgr/htr-pm/ss-rccs-water.i block=AuxKernels language=cpp

In return, the multi-D porous media model receives a layer-averaged wall temperature from the surface of the RCCS and imposes that as the $T_{\infty}$ of the radiative boundary condition imposed on the RPV outer surface. The layer-averaging is done through a `UserObjects` of type `LayeredSideAverage`. Note that the same of the `UserObject`, 'TRad_UO' must match the `user_object` name provided in the `[TRad_from_RCCS_sub]` block in the multi-D model.

!listing htgr/htr-pm/ss-rccs-water.i block=UserObjects language=cpp

The components of the RCCS model are modeled in the `[Components]` block in the input file. The RCCS panel is modeled as a `PBCoupledHeatStructure` with a 'Convective' boundary condition on the inner surface and a 'Coupled' boundary condition on the outer surface. The scaled heat flux, 'QRad_multiplied' is applied to the inner surface through the `qs_external_left` parameter. On the other hand, the outer surface is coupled to a fluid component named 'rccs-heated-riser' via the `name_comp_right` parameter. The heat transfer surface area density on the right side is provided through the `HT_surface_area_density_right` parameter.

!listing htgr/htr-pm/ss-rccs-water.i block=rccs-panel language=cpp

The riser is coupled to the outer surface of the RCCS panel. Downstream of the riser is an unheated chimney. The chimney is assumed to be fairly tall to provide sufficient thermal driving head for natural circulation.

!listing htgr/htr-pm/ss-rccs-water.i block=rccs-heated-riser rccs-chimney language=cpp

The outlet of the chimney is connected to a reservoir/pool that is modeled using a `PBLiquidVolume` component with an initial level of 10 m. The pool is assumed to be at atmospheric pressure.

!listing htgr/htr-pm/ss-rccs-water.i block=pool language=cpp

A heat exchanger is used in the pool for decay heat removal. On the primary side, the inlet and outlet of the heat exchanger are connected to the pool while a time-dependent junction and volume are used at the inlet and outlet on the seconday side. Water enters the secondary side at 303 K. Note that a large inlet flow rate is set on the secondary side to ensure to provide sufficient cooling to the pool.

!listing htgr/htr-pm/ss-rccs-water.i block=IHX IHX-inlet-pipe IHX-outlet-pipe IHX-junc-out IHX-junc-in IHX2-in IHX2-out language=cpp

Downstream of the pool is the downcomer consisting of a vertical and horizontal section. The outlet of the horizontal section is connected to the inlet of the riser, thus completing the loop.

!listing htgr/htr-pm/ss-rccs-water.i block=rccs-downcomer rccs-downcomer-horizontal language=cpp

The flow channels are connected to each other with `PBVolumeBranch`.

!listing htgr/htr-pm/ss-rccs-water.i block=junc-riser-chimney junc-horizontal-riser junc-downcomer-horizontal language=cpp

# Input File Descriptions - Pressurized Loss of Forced Cooling (PLOFC) Transient

The transient PLOFC simulation is a restart from the steady-state simulation with some minor modifications in the input files. As mentioned earlier, a simplified primary loop model is used in the PLOFC simulation. As a result, the full coupled model needs to be re-run with the simplified primary loop in lieu of the full primary loop model whose output is then used to restart the PLOFC simulation.  The `[Problem]` block in all three input files are modified where the path of the restart file is specified using the `restart_file_base` parameter. The `LATEST` keyword is used to specify the latest checkpoint as the restart time stamp. Alternatively, the restart time stamp  can be set to another time step by specifying the time-step number.

!listing htgr/htr-pm/plofc-main-transient.i block=Problem language=cpp

!listing htgr/htr-pm/plofc-primary-loop-transient.i block=Problem language=cpp

!listing htgr/htr-pm/plofc-rccs-water-transient.i block=Problem language=cpp


The SubApp files in the `[MultiApps]` block are changed to the transient files

!listing htgr/htr-pm/plofc-main-transient.i block=MultiApps language=cpp

Furthermore, the `start_time` and `end_time` parameters in the `[Executioner]` blocks of all three input files are modified to the desired values.

In the multi-D input file, the `initial_condition` parameters in the `[Variables]` and `[AuxVariables]` are removed.

Lastly, as discussed previously, the primary loop is simplified where components such as the blower, heat exchanger, and reference pressures are removed and replaced with inlet and outlet boundary conditions. Note that in the `[inlet]` block, the mass flow rate is set using the `m_fn` user-defined function.

!listing htgr/htr-pm/plofc-primary-loop-transient.i block=inlet outlet language=cpp

# Running the Simulation

SAM can be run on Linux, Unix, and MacOS.  Due to its dependence on MOOSE, SAM
is not compatible with Windows. Given that this is a MultiApp simulation, only the MainApp, i.e. `ss-main.i` needs to be run. The SubApps will be called and executed automatically by the MainApp. The model can be run from the shell prompt as shown below using SAM

```language=bash

sam-opt -i ss-main.i

```

With Blue Crab, the model can be run as below where the flag `--app` is used to specify SAM as the running application

```language=bash

blue_crab-opt -i ss-main.i --app SamApp

```

Similarly, for running the transient simulation with SAM

```language=bash

sam-opt -i plofc-main-transient.i

```

And with Blue Crab

```language=bash

blue_crab-opt -i plofc-main-transient.i --app SamApp

```


# Acknowledgements

This report was prepared as an account of work sponsored by an agency of the U.S. Government. Neither the U.S. Government nor any agency thereof, nor any of their employees, makes any warranty, expressed or implied, or assumes any legal liability or responsibility for any third party’s use, or the results of such use, of any information, apparatus, product, or process disclosed in this report, or represents that its use by such third party would not infringe privately owned rights. The views expressed in this paper are not necessarily those of the U.S. Nuclear Regulatory Commission. This work is supported by the U.S. Nuclear Regulatory Commission, under Task Order Agreement No. 31310021F0005. The authors would like to acknowledge the support and assistance from Dr. Mustafa Jaradat, Dr. Sebastian Schunert, and Dr. Javier Ortensi of Idaho National Laboratory in the completion of this work.
