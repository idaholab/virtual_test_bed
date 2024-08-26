# SAM Generic PBR Model

*Contact: Zhiee Jhia Ooi, zooi@anl.gov, Stephen Bajorek, stephen.bajorek@nrc.gov*

*Model link: [HTR-PM SAM Model](https://github.com/idaholab/virtual_test_bed/tree/devel/htgr/htr-pm)*

!tag name=SAM HTR-PM Model pairs=reactor_type:HTGR
                       reactor:HTR_PM
                       geometry:Core_and_primary_loop
                       simulation_type:Thermal_hydraulic
                       transient:PLOFC
                       input_features:checkpoint_restart
                       codes_used:SAM
                       computing_needs:Workstation
                       fiscal_year:2024
                       sponsor:NRC
                       institution:ANL

This is a SAM [!citep](Hu2021) reference plant model for the 250 MWth HTR-PM reactor. The model consists of three individual models namely the core, primary loop, and reactor cavity cooling system (RCCS). The schematic of the reference plant model is shown in [htr-pm-loop-schematic]. The core is modeled using SAM's multi dimensional flow model in 2-D RZ geometry while the primary loop and RCCS are modeled with SAM's 0-D and 1-D components. The MOOSE MultiApp system [!citep](multiapp_gaston2015) is used to couple the three models.

!media htrpm_sam/loop-schematics-VTB.png
        style=width:70%
        id=htr-pm-loop-schematic
        caption=Schematic of the SAM HTR-PM reference plant model.

 The schematic of the 2-D RZ core model is shown in [htr-pm-core-schematic]. The pebble bed, top and bottom reflectors, and the top cavity are modeled as porous media with varying porosity while the side reflectors, graphite blocks, core barrel, reactor pressure vessel (RPV), and helium gaps are modeled as solid. The hot and cold plena are not meshed in the 2-D model. Instead, they are modeled as 0-D volume branches using the SAM component system in the primary loop. On the other hand, the riser and bypass channels are modeled using an approach that utilizes both the 2-D meshes and the 1-D component system. In the 2-D model, the bypass and riser channels are meshed. However, they are treated as solid components (rather than porous media) whose thermal physical properties are reduced by a factor of $1-porosity$. This means that in the 2-D mesh, there is no fluid flow in the riser and bypass channels. Instead, the fluid flow in these two channels are modeled as 1-D flow using `PBOneDFluidComponent` in the primary loop model. Conjugate heat transfer between these channels with the surrounding 2-D solid structures is also modeled. This combined approach avoids the need to mesh the two channels in the 2-D model while at the same time still captures the radial conduction of heat from the core to the surrounding reflectors.

!media htrpm_sam/htr_pm_schematics.png
        style=width:70%
        id=htr-pm-core-schematic
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

A steady-state normal operating condition is simulated with the SAM HTR-PM reference plant model. The operating conditions during steady-state are tabulated in [ss-condition]. The reactor has a power output of 250 MWth and operates at 7 MPa. It is helium cooled with a system mass flow rate of 96 kg/s where the helium enters and leaves the reactor at 523.15 K and 1023.15 K, respectively. The core contains about 420,000 fuel pebbles that are 6 cm in diameter with an average packing fraction of 0.61 [!citep](htrpm_jaradat2023). In this model, neutronics calculations are not powerformed. Instead, a power density distribution obtained from the work by Jaradat et. al. [!citep](htrpm_jaradat2023) is imposed to the 2-D core.

!media htrpm_sam/ss-condition.png
        style=width:70%
        id=ss-condition
        caption=Steady-state normal operating condition of HTR-PM [!citep](htrpm_jaradat2023).

## Pressurized Loss of Forced Cooling (PLOFC) Transient

The Pressurized Loss of Forced Cooling (PLOFC) transient is simulated. The sequence of events of the simulated PLOFC is shown in [PLOFC_sequence]. The model is first simulated until steady-state is achieved. At the start of the transient, the reactor is SCRAM and a decay heat curve is used to determine the reactor power level throughout the accident. At the same time, the helium flow rate is reduced linearly from the nominal value to zero over 13 seconds. During the accident, the pressure boundary is assumed to be intact where the system pressure is able to maintain at 7 MPa. Given the absence of forced flow, decay heat from the core is transferred first to the surrounding reflector, and then the graphite blocks, core barrel, and RPV. Heat is ultimately radiated from the outer surface of the RPV to the RCCS panel where it is ultimately removed by the water flow in the RCCS. Simultaneously, natural circulation is also established within the core due to density differences of helium at different elevations.

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

```language=bash
  gravity     = '0 -9.807 0' # SAM default is 9.8 for Z-direction
  eos         = helium
  u           = vel_x
  v           = vel_y
  pressure    = p
  temperature = T
  rho         = density
```

### Mesh

The mash file is specified in this block. In this model, the mesh file is in Exodus (.e) format.

```language=bash
  file = htr-pm-mesh-bypass-riser.e
```

### Problem

This block specifies the type of problem being solved by SAM. The type of coordinate system used in the model is also specified here. Note that if not provided, SAM assumes a Cartesian coordinate by default. If  R-Z coordinate is used, the direction of the vertical axis also needs to be specified.

```language=bash
  type = FEProblem
  coord_type = RZ
  rz_coord_axis = Y
```

To restart a simulation, the location of the check point file is specified with the `restart_file_base` parameter. The keyword `LATEST` is used to restart the problem from the most recent check point.

```language=bash
  restart_file_base = '<location_of_checkpoint_file>/LATEST'
```

### Functions

Functions are defined in this block. Some examples of function types are `PieceWiseLinear`, `CompositeFunction`, and `ParsedFunction`. The `PieceWiseLinear` function is used to define the change of a parameter with respect to position or time. Below is an example of a time-dependent `PieceWiseLinear` function:

```language=bash
  [Q_time]
    type = PiecewiseLinear
    x = '-10.0  0    1.00E-06  0.5     1.0     2.5     5.0     10.0    '
    y = '1.0    1.0  0.06426   0.06193 0.06008 0.05603 0.0518  0.04704 '
  []
```

For a position-dependent `PieceWiseLinear` function, the parameter `axis` is used to define the direction in which the position is changing.

```language=bash
  [Q_axial]
    type = PiecewiseLinear
    axis = y
    x = '3.228  3.768       4.198       4.698       5.198      '
    y = '0.500  0.56660312  0.70174359  0.84062718  0.97604136 '
  []
```

A `CompositeFunction` is used to combine multiple functions, as shown below:

```language=bash
  [Q_fn]
    type = CompositeFunction
    functions = 'Q_axial Q_time'
  []
```

A `ParsedFunction` allows operation to be performed to an variable. The variable can be postprocessor outputs or other variables. The example below shows how the average temperature is calculated using the inlet and outlet temperatures obtained from two postprocessors named 'Tin_pps' and 'Tout_pps".

```language=bash
  [T_average]
    type  = ParsedFunction
    value = '0.5 * (T_in + T_out)'
    vars  = 'T_in T_out'
    vals  = 'Tin_pps Tout_pps'
  []
```

### EOS

This block specifies the Equation of State. The user can choose from built-in fluid library for common fluids like air, nitrogen, helium, sodium, molten salts, etc. The user can also input the properties of the fluid as constants or function of temperature. This model uses a combination of constant and temperature-dependent values for helium properties:

```language=bash
  [EOS]
    [helium]
      type    =    PTFunctionsEOS
      rho     =    rhoHe
      cp      =    5240
      mu      =    muHe
      k       =    kHe
      T_min   = 500
      T_max   = 1500
    []
  []
```

### MaterialProperties

Material properties are input in this block. The values can be constants or temperature dependent as defined in the Functions block. In this model, constant material properties are used

```language=bash
  [MaterialProperties]
    [rpv-ss-mat]
      type = HeatConductionMaterialProps
      k = 38.0
      Cp = 540.0
      rho = 7800.0
    []
    [cb-ss-mat]
      type = HeatConductionMaterialProps
      k = 17.0
      Cp = 540.0
      rho = 7800.0
    []
    [graphite]
      type = HeatConductionMaterialProps
      k = 26.0
      rho = 1780
      Cp = 1697
    []
    [he]
      type = HeatConductionMaterialProps
      k = 4
      rho = 6.0
      Cp = 5000
    []
    [graphite_porous]
      type = HeatConductionMaterialProps
      k = 17.68
      rho = 1153.96
      Cp = 1210.4
    []
  []
```

### Variables

This block is used to input the variables in the model, namely velocities in the $x$ and $y$ (or $r$ and $z$) directions, pressure, fluid temperature, and solid temperature, with each variable defined in an individual sub-block. In the sub-block, the scaling factor and initial condition are defined for each variable. Additionally, the `block` parameter is used to specify the block names at which the variable exists. For instance, fluid temperature is only defined in the fluid blocks and not solid blocks.

```language=bash
  [Variables]
    # Velocity
    [vel_x]
      scaling = 1e-3
      initial_condition = 1.0E-08
      block = ${fluid_blocks}
    []
    [vel_y]
      scaling = 1e-3
      initial_condition = 1.0E-08
      block = ${fluid_blocks}
    []
    # Pressure
    [p]
      scaling = 1
      initial_condition = ${p_outlet}
      block = ${fluid_blocks}
    []
    # Fluid Temperature
    [T]
      scaling = 1.0e-6
      initial_condition = ${T_inlet}
      block = ${fluid_blocks}
    []
    # Solid temperature
    [Ts]
      scaling = 1.0e-6
      initial_condition = ${T_inlet}
      block = '${pebble_blocks} ${porous_blocks} ${solid_blocks} ${cavity_blocks}'
    []
  []
```

### AuxVariables

This block is used to input auxiliary variables, which are used to compute or store intermediate quantities that are not the main variables (the ones being solved for) of the equation system. Similar to `Variables`, initial condition and block can be specified for `AuxVariables`. Users can also set the order and family of the `AuxVariables` to fit their needs. For instance, porosity is defined as an `AuxVariable` with an order `CONSTANT` and a family `MONOMIAL`.

```language=bash
  [porosity_aux]
    order  = CONSTANT
    family = MONOMIAL
  []
```

```language=bash
  [AuxVariables]
    [density]
      block = ${fluid_blocks}
      initial_condition = ${rho_in}
    []
    [porosity_aux]
      order = CONSTANT
      family = MONOMIAL
    []
    [power_density]
      order = CONSTANT
      family = MONOMIAL
      initial_condition = 3.215251376e6
      block = '${active_core_blocks}'
    []
    [v_mag]
      initial_condition = ${v_mag}
      block = ${fluid_blocks}
    []
    [T_fluid_external_bypass]
      family = LAGRANGE
      order = FIRST
      initial_condition = ${T_inlet}
    []
    [htc_external_bypass]
      family = LAGRANGE
      order = FIRST
      initial_condition = 3.0e3
    []
    [T_fluid_external_riser]
      family = LAGRANGE
      order = FIRST
      initial_condition = ${T_inlet}
    []
    [htc_external_riser]
      family = LAGRANGE
      order = FIRST
      initial_condition = 3.0e3
    []
    [TRad]
      initial_condition =  ${T_inlet}
      block = 'rpv'
    []
  []
```

### Materials

This block is used to set material properties of solid and porous blocks using the input from the `MaterialProperties` block defined earlier. For components where heat conduction is modeled, `SAMHeatConductionMaterial` is used such as:

```language=bash
  [pebble_mat]
    type = SAMHeatConductionMaterial
    block = ${pebble_blocks}
    properties = graphite
    temperature = Ts
  []
  [graphite_mat]
    type = SAMHeatConductionMaterial
    block = 'side_reflector carbon_brick bypass_riser_reflector bypass_pebble_reflector'
    properties = graphite
    temperature = Ts
  []
  [graphite_porous_mat]
    type = SAMHeatConductionMaterial
    block = 'bypass riser'
    properties = graphite_porous
    temperature = Ts
  []
  [core_barrel_steel_mat]
    type = SAMHeatConductionMaterial
    block = 'core_barrel'
    properties = cb-ss-mat
    temperature = Ts
  []
  [rpv_steel_mat]
    type = SAMHeatConductionMaterial
    block = 'rpv'
    properties = rpv-ss-mat
    temperature = Ts
  []
  [He_gap_mat]
    type = SAMHeatConductionMaterial
    block = 'refl_barrel_gap barrel_rpv_gap'
    properties = he
    temperature = Ts
  []
```

For porous region where convection is modeled, `PorousFluidMaterial` is used, as shown below. The correlations used for computing heat transfer and frictional pressure drop coefficients are specified here along with other pebble geometry information.

```language=bash
  [pebble_bed]
    type = PorousFluidMaterial
    block = ${fluid_blocks}
    d_pebble = ${pebble_diam}
    d_bed = ${pbed_d}
    porosity = porosity_aux
    friction_model = KTA
    HTC_model = KTA
    Wall_HTC_model = Achenbach
    compute_turbulence_viscosity = true
    mixing_length = 0.2
  []
```

Heat transfer in the pebble bed is a complex phenomenon that involves pebble-pebble conduction, pebble-fluid convection, and pebble-pebble radiation. For simplicity, an effective thermal conductivity, $k_{eff}$, is often used to model these heat transfer mechanisms rather than modeling them individually. One widely used correlation to compute $k_{eff}$ is the ZBS correlation [!citep](PBMR400). In SAM, $k_{eff}$ is defined using `PebbleBedEffectiveThermalConductivity` as shown below:

```language=bash
  [pebble_keff]
    type = PebbleBedEffectiveThermalConductivity
    block = '${pebble_blocks} ${porous_blocks} ${cavity_blocks}'
    d_pebble = ${pebble_diam}
    porosity = porosity_aux
    k_effective_model = ZBS
    solid = graphite
    tsolid = Ts
  []
```

### Kernels

The block is used to define the physics of the model. In SAM, the governing equations are essentially divided into the time derivative and spatial terms. The mass equation is modeled using `PMFluidPressureTimeDerivative` and `MDFluidMassKernel` as below:

```language=bash
  [mass_time]
    type = PMFluidPressureTimeDerivative
    variable = p
    porosity = porosity_aux
    block = ${fluid_blocks}
  []
  [mass_space]
    type = MDFluidMassKernel
    variable = p
    porosity = porosity_aux
    block = ${fluid_blocks}
  []
```

The $x$ and $y$ momentum terms are modeled with `PMFluidVelocityTimeDerivative` and `MDFluidMomentumKernel`. Note that the `component` parameter in `MDFluidMomentumKernel` is defined as `0` and `1` for $x$ and $y$ momentum, respectively.

```language=bash
  # x-momentum
  [x_momentum_time]
    type = PMFluidVelocityTimeDerivative
    variable = vel_x
    block = ${fluid_blocks}
  []
  [x_momentum_space]
    type = MDFluidMomentumKernel
    variable = vel_x
    porosity = porosity_aux
    component = 0
    block = ${fluid_blocks}
  []

  # y-momentum
  [y_momentum_time]
    type = PMFluidVelocityTimeDerivative
    variable = vel_y
    block = ${fluid_blocks}
  []
  [y_momentum_space]
    type = MDFluidMomentumKernel
    variable = vel_y
    porosity = porosity_aux
    component = 1
    block = ${fluid_blocks}
  []
```

Fluid energy is modeled with `PMFluidTemperatureTimeDerivative`, `MDFluidEnergyKernel`, and `PorousMediumEnergyKernel`. The first two model the time derivative and spatial terms of the fluid heat transfer equation while the third models the heat transfer between fluid and solid.

```language=bash
  [temperature_time]
    type = PMFluidTemperatureTimeDerivative
    variable = T
    porosity = porosity_aux
    block = ${fluid_blocks}
  []
  [temperature_space]
    type = MDFluidEnergyKernel
    variable = T
    porosity = porosity_aux
    block = ${fluid_blocks}
  []
  [temperature_heat_transfer]
    type = PorousMediumEnergyKernel
    block = '${pebble_blocks} ${porous_blocks} ${cavity_blocks}'
    variable = T
    T_solid = Ts
  []
```

Pebble heat transfer is modeled with `PMSolidTemperatureTimeDerivative` and `PMSolidTemperatureKernel`. For region with heat generation, the `power_density_var` term is set to the name of the `AuxVariable` for power density.

```language=bash
  [solid_time]
    type = PMSolidTemperatureTimeDerivative
    block = '${pebble_blocks} ${porous_blocks} ${cavity_blocks}'
    variable = Ts
    porosity = porosity_aux
    solid = graphite
  []
  [solid_conduction]
    type = PMSolidTemperatureKernel
    variable = Ts
    T_fluid = T
    block    = '${porous_blocks} ${cavity_blocks}'
  []
  [solid_conduction_core]
    type = PMSolidTemperatureKernel
    block = ${active_core_blocks}
    variable = Ts
    T_fluid = T
    power_density_var = power_density # set power density in pebble bed
  []
```

Heat conduction in pure solid regions is modeled with `HeatConductionTimeDerivative` and `HeatConduction`:

```language=bash
  [transient_term_reflector]
    type = HeatConductionTimeDerivative
    variable = Ts
    block = ${solid_blocks}
  []
  [diffusion_term_reflector]
    type = HeatConduction
    variable = Ts
    block = ${solid_blocks}
  []
```

### AuxKernels

The AuxKernel system mimics the kernels system but compute values that can be defined explicitly with a known function. In SAM, density is modeled using `DensityAux` as:

```language=bash
  [rho_aux]
    type = DensityAux
    variable = density
    block = ${fluid_blocks}
  []
```

Porosities of different regions are also modeled using `ConstantAux` as:

```language=bash
  [porosity_bed]
    type = ConstantAux
    variable = porosity_aux
    block = 'pebble_bed'
    value = 0.39
  []
  [porosity_reflector_top]
    type = ConstantAux
    variable = porosity_aux
    block = 'top_reflector'
    value = 0.3
  []
  [porosity_reflector_bottom]
    type = ConstantAux
    variable = porosity_aux
    block = 'bottom_reflector'
    value = 0.3
  []
  [porosity_top_cavity]
    type = ConstantAux
    variable = porosity_aux
    block = 'top_cavity'
    value = 0.99
  []
```

Lastly, the power density is modeled using `FunctionAux` as:

```language=bash
  [power_density]
    type = FunctionAux
    variable = power_density
    function = Q_fn
  []
```

### BCs

This block sets the boundary conditions of the model. The inlet conditions are set using `MDFluidMassBC` as below where the `boundary` parameter is set to the inlet of the model.

```language=bash
  [BC_inlet_mass]
    type = MDFluidMassBC
    boundary = 'core_inlet'
    variable = p
    pressure = p
    u = vel_x
    v = vel_y
    temperature = T
    eos = helium
  []
```

The $x$ and $y$ inlet momentum boundary conditions are set using `DirichletBC` and `PostprocessorDirichletBC`, respectively as below:

```language=bash
  [BC_inlet_x_mom]
    type = DirichletBC
    boundary = 'core_inlet'
    variable = vel_x
    value = 0
  []
  [BC_inlet_y_mom]
    type = PostprocessorDirichletBC
    boundary = 'core_inlet'
    variable = vel_y
    postprocessor = 2Dreceiver_velocity_in
  []
```

In this model, the inlet is taken as the top of the core and the inlet flow is assumed to be fully vertically downward. As a result, the $x$ momentum is set to zero at the inlet. Conversely, for the $y$ velocity (momentum), the inlet value is set to the value obtained by the `2Dreceiver_velocity_in` postprocessor.

The inlet temperature is set using `INSFEFluidEnergyDirichletBC` as below where the `out_norm` parameter is used to set the outward normal of the inlet boundary or sideset.

```language=bash
  [BC_inlet_T]
    type = INSFEFluidEnergyDirichletBC
    variable = T
    boundary = 'core_inlet'
    out_norm = '0 1 0'
    T_fn = T_reactor_in
  []
```

At the outlet of the core, a pressure boundary condition is set as below using `DirichletBC`. Note that the value of the pressure is set at zero at outlet boundary because the EOS used in this model is incompressible (temperature dependent only), hence the value of the pressure has no effect on the simulation results.

```language=bash
  [BC_outlet_mass]
    type = DirichletBC
    boundary = 'core_outlet'
    variable = p
    value = 0
  []
```

Additionally, a flow direction-dependent outlet temperature is set using `INSFEFluidEnergyDirichletBC` as below. Note that this boundary condition is only applicable if the helium flow direction is reversed. Such a reversal may happen during certain transients where forced flow is lost.

```language=bash
  [BC_outlet_T]
    type = INSFEFluidEnergyDirichletBC
    variable = T
    boundary = 'core_outlet'
    out_norm = '0 -1 0'
    T_fn = T_core_out
  []
```

A zero flow boundary condition is set for flow in the $x$ direction at the wall as no fluid can enter or exit the wall.

```language=bash
  [BC_fluidWall_x_mom]
    type = DirichletBC
    boundary = '${slip_wall_vertical} ${slip_wall_vertical_outer}'
    variable = vel_x
    value = 0
  []
```

The conjugate heat transfer between the walls of the bypass and riser channels in the 2-D model and the fluids in 1-D channel in the primary loop model is modeled as below. The `T_infinity` and `htc` parameters are set to `AuxVariables` whose values are set using the MultiApp system based on their corresponding variables in the 1-D primary loop model.

```language=bash
  [HeatTransfer_bypass_inner_wall]
    type = CoupledConvectiveHeatFluxBC
    variable = Ts
    boundary = 'bypass_wall_vertical_inner'
    T_infinity = T_fluid_external_bypass
    htc = htc_external_bypass
  []
  [HeatTransfer_riser_inner_wall]
    type = CoupledConvectiveHeatFluxBC
    variable = Ts
    boundary = 'riser_wall_vertical_inner'
    T_infinity = T_fluid_external_riser
    htc = htc_external_riser
  []
```

The radiation heat transfer between the RPV outer surface and the RCCS panel in the 1-D RCCS model is modeled as below. In this approach, `TRad` is an `AuxVariable` that takes its value from the inner wall temperature of the RCCS panel in the 1-D RCCS model.

```language=bash
 [RPV_out]
   type = CoupledRadiationHeatTransferBC
   variable = Ts
   T_external = TRad
   boundary = 'rpv_outer'
   emissivity = 0.8
   emissivity_external = 0.8
 []
```

### Postprocessors

In this block, postprocessors are set up to obtain simulation results from the model. Below are some examples of of postprocessors from the input file.

```language=bash
  [Postprocessors]
    [Tsolid_pebble_avg]
      type       = ElementAverageValue
      block      = 'pebble_bed'
      variable   = Ts
      execute_on = 'initial timestep_end'
    []
    [Tfluid_pebble_avg]
      type       = ElementAverageValue
      block      = 'pebble_bed'
      variable   = T
      execute_on = 'initial timestep_end'
    []
    [Tsolid_pebble_max]
      type       = ElementExtremeValue
      block      = 'pebble_bed'
      value_type = max
      variable   = Ts
      execute_on = 'initial timestep_end'
    []
  []
```

Furthermore, using `Receiver` type postprocessors, values of postprocessors from the 1-D primary loop and RCCS models can be transferred to the 2-D model, such as

```language=bash
  [2Dreceiver_temperature_in]
    type = Receiver
    default = 523.15
  []
```

### MultiApps

THe MultiApp system is set up in this block. Two sub blocks are included here - one for each of the SubApps.  `TransientMultiApp` is used here as all of the models are set up to perform transient analyses. The `catch_up` parameter is set to `True` to allow failed solves to attempt to 'catch up' using smaller timesteps.

```language=bash
  [MultiApps]
    [primary_loop]
      type = TransientMultiApp
      input_files = 'ss-primary-loop-full.i'
      catch_up = true
      execute_on = 'TIMESTEP_END'
    []

    [rccs]
      type = TransientMultiApp
      execute_on = timestep_end
      app_type = SamApp
      input_files = 'ss-rccs-water.i'
      catch_up = true
    []
  []
```

### Transfers

This block is used to control the transfer of information between the `MainApp` and the `SubApps`.  `MultiAppPostprocessorTransfer` is used to transfer postprocessor values between the `Apps`. The example below shows the transfer of postprocessor (`2Dsource_temperature_in`) value in the 2-D model to another postprocessor (`1Dreceiver_temperature_in`) in the primary loop model.

```language=bash
  [2Dto1D_temperature_in_transfer]
    type = MultiAppPostprocessorTransfer
    to_multi_app = primary_loop
    from_postprocessor = 2Dsource_temperature_in
    to_postprocessor = 1Dreceiver_temperature_in
  []
```

`MultiAppUserObjectTransfer` is used to transfer the value of an `UserObject` from one `App` to a `variable` on the other `App` as below. The `direction` parameter is used to determine the direction of the data transfer, i.e. from `MainApp` to `SubApp` or the other way round where the `multi_app` parameter is used for setting the `SubApp` of choice.

```language=bash
  [To_subApp_Twall_riser]
    type = MultiAppUserObjectTransfer
    direction = to_multiapp
    user_object = Twall_riser_inner
    variable = Twall_riser_inner_from_main
    multi_app = primary_loop
  []
```

`MultiAppGeneralFieldNearestNodeTransfer` is used to directly transfer field data between the `Apps` based on their nodal positions:

```language=bash
  [from_subApp_T_fluid]
    type = MultiAppGeneralFieldNearestNodeTransfer
    direction = from_multiapp
    multi_app = primary_loop
    source_variable = temperature
    variable = T_fluid_external_riser
    from_blocks = 'riser'
    to_blocks = 'bypass_riser_reflector'
    execute_on = 'TIMESTEP_END'
  []
```

In this example, temperature is transferred from the primary loop model (`SubApp`) to the 2-D model (`MainApp`), hence, the `direction` is set to `from_multiapp` with the `multi_app` being the primary loop model. `source_variable` is used to set the variable in the `SubApp` that is to be transferred to the `MainApp`. On the other hand, `variable` is the name of the variable in the `MainApp` to receive the transferred value. Since the transfer mechanism is based on the positions of the models, there is a possibility that the wrong field data maybe transferred. To avoid that, the `from_blocks` and `to_blocks` options are set to make sure that the data transfer only involves the correct blocks.

### UserObjects

This `UserObjects` system is used to perform custom algorithms or calculations that may not fit well within any other system in MOOSE.

```language=bash
  [UserObjects]
    [QRad_UO]
      type = LayeredSideFluxAverage
      variable = Ts
      direction = y
      num_layers = 45
      boundary = 'rpv_outer'
      diffusivity = thermal_conductivity
      execute_on = 'TIMESTEP_END'
    []

    [Twall_riser_inner]
      type = LayeredSideAverage
      direction = y
      num_layers = 36
      sample_type = direct
      variable = Ts
      boundary = 'riser_wall_vertical_inner'
    []

    [Twall_bypass_inner]
      type = LayeredSideAverage
      direction = y
      num_layers = 36
      sample_type = direct
      variable = Ts
      boundary = 'bypass_wall_vertical_inner'
    []
  []
```

In this model, `LayeredSideAverage` is used to obtain the layered average field data such as the wall temperatures on the riser and bypass channels and the radiative heat flux on the RPV outer wall. The `num_layers` option is used to set the number of layers over which a field data is averaged and the `direction` option is used to set the averaging direction.

### Preconditioning

This block describes the preconditioner to be used by the preconditioned JFNK
solver (available through PETSc). Two options are currently available,
the single matrix preconditioner (SMP) and the finite difference preconditioner (FDP).
The theory behind the preconditioner can be found in the SAM Theory Manual [!citep](Hu2021).
New users can leave this block unchanged.

```language=bash
  [Preconditioning]
    [SMP_PJFNK]
      type = SMP
      full = true
      solve_type = 'PJFNK'
      petsc_options_iname = '-pc_type -ksp_gmres_restart'
      petsc_options_value = 'lu 100'
    []
  []
```

### Executioner

This block describes the calculation process flow. The user can specify the
start time, end time, time step size for the simulation. The user can also choose
to use an adaptive time step size with the [IterationAdaptiveDT time stepper](https://mooseframework.inl.gov/source/timesteppers/IterationAdaptiveDT.html).
Other inputs in this block include PETSc solver options, convergence tolerance,
quadrature for elements, etc.

```language=bash
  [Executioner]
    type = Transient
    dtmin = 1e-6
    dtmax = 500

    [TimeStepper]
      type = IterationAdaptiveDT
      growth_factor = 1.25
      optimal_iterations = 10
      linear_iteration_ratio = 100
      dt = 0.1
      cutback_factor = 0.8
      cutback_factor_at_failure = 0.8
    []

    nl_rel_tol = 1e-5
    nl_abs_tol = 1e-4
    nl_max_its = 15
    l_tol      = 1e-3
    l_max_its  = 100

    start_time = -200000
    end_time = 0

    picard_rel_tol                 = 1e-3
    picard_abs_tol                 = 1e-3
    fixed_point_max_its            = 10
    relaxation_factor              = 0.8
    relaxed_variables              = 'p T vel_x vel_y'
    accept_on_max_picard_iteration = true

    [Quadrature]
      type = GAUSS
      order = SECOND
    []
  []
```

### Outputs

This block is used to control the information to be output by the model. Users can choose the output format as `Exodus` and/or `CSV` files. Checkpoint files can also be produced. User can set the output frequency via the `interval` option.

```language=bash
  [Outputs]
    perf_graph = true
    print_linear_residuals = false
    [out]
      type = Exodus
      use_displaced = true
      sequence = false
    []
    [csv]
      type = CSV
    []
    [checkpoint]
      type = Checkpoint
      execute_on = FINAL
    []
    [console]
      type = Console
      fit_mode = AUTO
      execute_scalars_on = 'NONE'
    []
  []
```

## 0-D/1-D Primary Loop Model

The input file of the 0-D/1-D primary loop model is described here. Some of the blocks in this file are similar to the input file of the porous media model and will not be repeated here. These include the `[GlobalParams], [Functions], [EOS], [MaterialProperties], [Postprocessors], [Preconditioning], [Executioner]` and `[Outputs]` blocks. Instead, this section focuses on the `[Components]` block to describe the actual model.

As described earlier, the so-called domain overlapping approach is used to couple the multi-D porous media model to the 0-D/1-D primary loop. The primary loop model essentially consists of two parts: a surrogate channel to represent the multi-D core and a remainder of the primary loop with flow channels, pump, heat exchanger, etc.

The surrogate channel consists of a `PBOneDFluidComponent` with inlet and outlet boundary conditions.

```language=bash
  [core_pipe]
    type            = PBOneDFluidComponent
    eos             = helium
    A               = 7.068583471
    length          = 13.9
    Dh              = 3
    n_elems         = 1
    orientation     = '0 1 0'
    position        = '0.845 1.8 0'
    overlap_coupled = true
    overlap_pp      = dpdz_core_receive
  []
```

The geometric information such as the length, flow area, hydraulic diameter, position, etc. are the same as that in the porous media model. In the domain overlapping approach, frictional pressure drop in the porous media model is computed and then applied to the surrogate channel. The pressure drop is then used by the code to internally calculate a friction factor that is then applied to the surrogate channel. By doing so, the flow rate in the surrogate channel is ensured to tbe the same as that in the porous media model. This capability is enabled by setting `overlap_coupled` to `true`. The `overlap_pp` parameter sets the postprocessor name that receives the pressure drop information from the porous media model. Note that pressure drop is defined as the change of pressure per unit length, $dP/dZ$, with a unit of Pa/m, and NOT the total presure drop across the core.

The inlet and outlet boundary conditions are set using a coupled postprocessor time-dependent junction (CoupledPPSTDJ) and coupled postprocessor time-dependent volume (CoupledPPSTDV), respectively. At the inlet, the velocity and temperature boundary conditions are set to the mean values obtained from the inlet of the multi-D model using their respective postprocessors. On the other hand, at the outlet, using their respective postprocessors, the temperature is set to the mean temperature obtained at the outlet of the multi-D model while the pressure is set to the pressure of the hot plenum.

```language=bash
  [coupled_inlet_top]
    type              = CoupledPPSTDJ
    input             = 'core_pipe(out)'
    eos               = helium
    postprocessor_vbc = core_top_velocity_scaled
    postprocessor_Tbc = T_cold_plenum_inlet_pipe_inlet
    v_bc = -2
    T_bc = 523.15
  []

  [coupled_outlet]
    type              = CoupledPPSTDV
    input             = 'core_pipe(in)'
    eos               = helium
    postprocessor_pbc = p_hot_plenum_inlet_pipe_outlet
    postprocessor_Tbc = T_hot_plenum_inlet_pipe_outlet
    v_bc = -2
    T_bc = 523.15
  []
```

Other than the surrogate channel, the remainder of the primary loop is shown in [htr-pm-loop-schematic]. In this model, the hot plenum can be seen as the inlet and the cold plenum the outlet. To couple the outlet of the surrogate channel to the hot plenum, the outlet conditions of the surrogate channel are used as the inlet conditions of the hot plenum. The hot plenum is modeled using the `PBVolumeBranch` component as:

```language=bash
  [hot_plenum]
    type    = PBVolumeBranch
    eos     = helium
    center  = '0.845 1.4 0'
    inputs  = 'hot_plenum_inlet_pipe(in) bypass(out)'
    outputs = 'outlet_pipe(in)'
    K       = '0.0 0.0 0.0'
    width   = 0.8 # display purposes
    height  = 1.69 # display purposes
    Area    = 8.9727
    volume  = 7.17816
  []
```

Given that boundary conditions cannot be directly set to a `PBVolumeBranch`, a short pipe called the 'hot_plenum_inlet_pipe' is connected to the 'hot_plenum' on one end, while the end is set to the outlet conditions from the surrogate channel using the `CoupledPPSTDJ` component as:

```language=bash
  [coupled_inlet]
    type              = CoupledPPSTDJ
    input             = 'hot_plenum_inlet_pipe(out)'
    eos               = helium
    postprocessor_vbc = core_velocity_scaled
    postprocessor_Tbc = 1Dreceiver_temperature_out
  []
```

After the hot plenum is a horizontal flow channel known as the 'outlet_pipe':

```language=bash
  [outlet_pipe]
    type           = PBOneDFluidComponent
    A              = 0.470026997
    Dh             = 0.7746
    length         = 5.134
    n_elems        = 20
    orientation    = '1 0 0'
    position       = '2.03 1.4 0'
  []
```

Downstream of 'outlet_pipe' is a `PBVolumeBranch` known as 'SG_inlet_plenum' that connects the outlet pipe to the heat exchanger:

```language=bash
  [SG_inlet_plenum]
    type    = PBVolumeBranch
    eos     = helium
    center  = '7.433 1.4 0'
    inputs  = 'outlet_pipe(out)'
    outputs = 'IHX(primary_in)'
    K       = '0.0 0.0'
    height  = 2.598 # display purposes
    width   = 3.031 # display purposes
    Area    = 5.3011265
    volume  = 16.0677
  []
```

The heat exchanger is intended to represent the steam generator in the actual HTR-PM reactor. The geometries of the heat exchanger used in this work are obtained from publicly available information:

```language=bash
  [IHX]
    type                              = PBHeatExchanger
    HX_type                           = Countercurrent
    eos_secondary                     = water
    position                          = '7.433 1.4 0'
    orientation                       = '0 -1 0'
    A                                 = 7.618966942
    Dh                                = 1
    PoD                               = 1.5789
    HTC_geometry_type                 = Bundle
    length                            = 7.75
    n_elems                           = 20
    HT_surface_area_density           = 65.99339913
    A_secondary                       = 1.141431617
    Dh_secondary                      = 1
    length_secondary                  = 7.75
    HT_surface_area_density_secondary = 421.0526316
    hs_type                           = cylinder
    radius_i                          = 0.009080574
    wall_thickness                    = 0.000419426
    n_wall_elems                      = 3
    material_wall                     = ss-mat
    Twall_init                        = ${T_inlet}
    initial_T_secondary               = ${T_inlet}
    initial_P_secondary               = ${p_secondary}
    initial_V_secondary               = ${fparse -v_secondary}
    SC_HTC                            = 2.5 # approximation for twisted tube effect
    SC_HTC_secondary                  = 2.5
    disp_mode                         = -1
  []
```

Water is used as the coolant on the secondary side of the heat exchanger. For simplicity, the secondary side is not modeled and is simply given inlet and outlet boundary conditions:

```language=bash
  [IHX2-in]
    type  = PBTDJ
    v_bc  = ${fparse -v_secondary}
    T_bc  = ${T_in_secondary}
    eos   = water
    input = 'IHX(secondary_in)'
  []
  [IHX2-out]
    type  = PBTDV
    eos   = water
    p_bc  = ${p_secondary}
    input = 'IHX(secondary_out)'
  []
```

Similar to the inlet, the outlet of the heat exchanger is connected to a `PBVolumeBranch` component:

```language=bash
  [SG_outlet_plenum]
    type    = PBVolumeBranch
    eos     = helium
    center  = '7.433 -6.35 0'
    inputs  = 'IHX(primary_out)'
    outputs = 'SG_outlet_pipe(in)'
    K       = '0.0 0.0'
    height  = 1.732 # display purposes
    width   = 1.732 # display purposes
    Area    = 2.356056
    volume  = 10.881838
  []
```

Downstream of the heat exchanger is another flow channel that connects the outlet of the heat exchanger to the inlet of the blower:

```language=bash
  [SG_outlet_pipe]
    type           = PBOneDFluidComponent
    A              = 2.2242476
    Dh             = 0.4
    length         = 12.745
    n_elems        = 20
    orientation    = '0 1 0'
    position       = '8.299 -6.35 0'
  []
```

The outlet of 'SG_outlet_pipe' is connected to the blower through a `PBVolumeBranch`:

```language=bash
  [pump_inlet_plenum]
    type    = PBVolumeBranch
    eos     = helium
    center  = '8.299 6.395 0'
    inputs  = 'SG_outlet_pipe(out)'
    outputs = 'pump_inlet_pipe(in) ref_pressure_pipe(in)'
    K       = '0.0 0.0 0.0'
    height  = 0.7575 # display purposes
    width   = 3.928 # display purposes
    Area    = 12.118
    volume  = 18.3588
  []
```

Additionally, the reference pressure of the system is set using a `PBTDV` component that is connected to 'pump_inlet_plenum'. During steady-state, the system pressre is set to 7 MPa.

```language=bash
  [ref_pressure_pipe]
    type           = PBOneDFluidComponent
    A              = 2.2242476
    Dh             = 0.4
    length         = 1
    n_elems        = 5
    orientation    = '1 0 0'
    position       = '8.299 6.395 0'
  []
  [reference_pressure]
    type  = PBTDV
    eos   = helium
    p_fn  = p_out_fn
    input = 'ref_pressure_pipe(out)'
  []
```

Downstream of that is a flow channel that connects the `PBVolumeBranch` to the blower:

```language=bash
  [pump_inlet_pipe]
    type           = PBOneDFluidComponent
    A              = 2.2242476
    Dh             = 0.4
    length         = 1.135
    n_elems        = 20
    orientation    = '-1 0 0'
    position       = '8.299 6.395 0'
  []
```

The blower is modeled using the `PBPump` component. Note that the pump head is set using the 'f_pump_head' function via the `Head_fn` parameter. The pump head and the k-loss values are tuned such that the steady-state mass flow rate is 96 kg/s.

```language=bash
  [blower]
    type      = PBPump
    inputs    = 'pump_inlet_pipe(out)'
    outputs   = 'pump_outlet_pipe(in)'
    K         = '7500 7500'
    K_reverse = '7500 7500'
    Area      = 2.2242476
    Head_fn   = f_pump_head
  []
```

Located downstream of the blower are a pipe and a `PBVolumeBranch` that is connected to the horizontal inlet pipe:

```language=bash
  [pump_outlet_pipe]
    type           = PBOneDFluidComponent
    A              = 2.2242476
    Dh             = 0.4
    length         = 4.34781
    n_elems        = 20
    orientation    = '0 -1 0'
    position       = '7.164 6.395 0'
  []
  [pump_outlet_branch]
    type    = PBVolumeBranch
    eos     = helium
    center  = '7.164 2.04719 0'
    inputs  = 'pump_outlet_pipe(out)'
    outputs = 'inlet_pipe(in)'
    K       = '0.0 0.0'
    width   = 0.05 # display purposes
    height  = 0.05 # display purposes
    Area    = 2.2242476
    volume  = 0.01
  []
  [inlet_pipe]
    type           = PBOneDFluidComponent
    A              = 1.257280927
    Dh             = 0.61552
    length         = 5.134
    n_elems        = 20
    orientation    = '-1 0 0'
    position       = '7.164 2.04719 0'
  []
```

 The outlet of the horizontal inlet pipe is connected to the inlet of the riser. In order to accurately account for the heat transfer between the 2-D surfaces and the riser, the heat transfer area density is set via the `HT_surface_area_density` parameter.

```language=bash
   [riser]
    type                    = PBOneDFluidComponent
    A                       = 0.81631
    Dh                      = 0.2
    length                  = 13.65281
    n_elems                 = 20
    orientation             = '0 1 0'
    position                = '2.03 2.04719 0'
    HT_surface_area_density =  14.85532
  []
  [joint_outlet_1]
    type    = PBSingleJunction
    eos     = helium
    inputs  = 'inlet_pipe(out)'
    outputs = 'riser(in)'
  []
```

The outlet of the riser is connected to the cold plenum:

```language=bash
  [cold_plenum]
    type    = PBVolumeBranch
    eos     = helium
    center  = '1.065 15.85 0'
    inputs  = 'riser(out)'
    outputs = 'bypass(in) cold_plenum_outlet_pipe(out)'
    K       = '0.0 0.0 0.0'
    width   = 0.8 # display purposes
    height  = 1.69 # display purposes
    Area    = 8.9727
    volume  = 7.17816
  []
```

A bypass channel connects the cold and hot plena. Similar to the riser, the heat transfer area density of the bypass channel is set to accurately capture the heat transfer between the helium in the bypass channel and the surrounding 2-D solid structures. A friction factor, `f`, is tuned such that the flow in the bypass channel is roughly 1 kg/s:

```language=bash
  [bypass]
    type                    = PBOneDFluidComponent
    A                       = 0.42474
    length                  = 13.9
    Dh                      = 0.13
    n_elems                 = 20
    orientation             = '0 -1 0'
    position                = '1.625 15.7 0'
    HT_surface_area_density = 23.077
    f                       = 2000
  []
```

The cold plenum can be seen as the outlet of the primary loop. Similar to the hot plenum, a small pipe is connected to the cold plenum on one end where the boundary conditions are set on the other end using the `CoupledPPSTDV` component. The outlet pressure is set to the pressure at the outlet of the surrogate channel while the temperature is set to the mean temperature at the inlet of the 2-D core:

```language=bash
  [cold_plenum_outlet_pipe]
    type           = PBOneDFluidComponent
    A              = 7.068583471 # Based on pbed flow area in mainapp
    length         = 0.1
    Dh             = 3
    n_elems        = 1
    orientation    = '0 1 0'
    position       = '1.065 15.7 0' #'0.845 1.5 0'
    eos            = helium
    initial_V      = -2
  []
  [coupled_outlet_top]
    type              = CoupledPPSTDV
    input             = 'cold_plenum_outlet_pipe(in)'
    eos               = helium
    postprocessor_pbc = p_core_pipe_outlet
    postprocessor_Tbc = 1Dreceiver_temperature_in
  []
```

The wall separating the horizontal inlet and outlet pipes is modeled using a `PBCoupledHeatStructure`. The boundary conditions both sides of the wall are set to `Coupled` to model the heat transfer between the helium in the inlet and outlet pipe across the wall.

```language=bash
  [concentric-pipe-wall]
    type                          = PBCoupledHeatStructure
    position                      = '7.164 0 0'
    orientation                   = '-1 0 0'
    hs_type                       = cylinder
    length                        = 5.134
    width_of_hs                   = '0.10951'
    radius_i                      = 1.7873
    elem_number_radial            = 3
    elem_number_axial             = 20
    dim_hs                        = 2
    material_hs                   = 'ss-mat'
    Ts_init                       = ${T_inlet}
    HS_BC_type                    = 'Coupled Coupled'
    name_comp_left                = outlet_pipe
    HT_surface_area_density_left  = 5.177314
    name_comp_right               = inlet_pipe
    HT_surface_area_density_right = 1.2413889  # PI * D / A(pipe1)
  []
```

The `HeatTransferWithExternalHeatStructure` is used to model the heat transfer between the solids in the multi-D model and the 1-D bypass and riser channels in the primary loop model. In this approach, the wall temperatures from the 2-D model are transferred to 1-D channels. In return, the 2-D walls receive the fluid temperatures and the heat transfer coefficients from the 1-D channels. The `T_wall_name` is the variable name to which the MultiApp transfers the wall temperatures from the multi-D model.

```language=bash
  [from_main_app_riser]
    type           = HeatTransferWithExternalHeatStructure
    flow_component = riser
    initial_T_wall = ${T_inlet}
    T_wall_name    = Twall_riser_inner_from_main
  []

  [from_main_app_bypass]
    type           = HeatTransferWithExternalHeatStructure
    flow_component = bypass
    initial_T_wall = ${T_inlet}
    T_wall_name    = Twall_bypass_inner_from_main
  []
```

## 0-D/1-D RCCS Model

The input file of the 0-D/1-D model is described here. Similarly, blocks that are repeated in other input files will not be discussed here. Note that the RCCS model is loosely based on the actual system whose informationa is obtained from multiple sources in the public domain and the geometry information is not representative of the actual system.

The RCCS panel in the model receives heat flux from the outer surface of the RPV in the multi-D porous media model via thermal radiation. To do so, an `AuxVariable` named 'QRad' is defined to receive that flux. Note that the name of the `AuxVariable` ('QRad' in this case) must match the name provided in the `[QRad_to_subRCCS]` block in the multi-D model. At the same time, due to the difference in the surface area of the RPV and the RCCS panel, the heat flux needs to be properly scaled to ensure energy conservation. This is done through another `AuxVariable` named 'QRad_multiplied'.

```language=bash
  [AuxVariables]
    [QRad]
      block = 'rccs-panel:hs0'
    []
    [QRad_multiplied]
      block = 'rccs-panel:hs0'
    []
  []
```

The scaling of the heat flux is performed through an `AuxKernel` of type `ParsedAux`. The scaling factor is defined as the ratio between the RPV surface area to the RCCS panel surface area.

```language=bash
  [AuxKernels]
    [QRad_multiplied]
      type = ParsedAux
      block = 'rccs-panel:hs0'
      variable = QRad_multiplied
      args = 'QRad'
      function = 'QRad * 18.84955592 / 26.452210'
      execute_on = 'timestep_end'
    []
  []
```

In return, the multi-D porous media model receives a layer-averaged wall temperature from the surface of the RCCS and imposes that as the $T_{\infty}$ of the radiative boundary condition imposed on the RPV outer surface. The layer-averaging is done through a `UserObjects` of type `LayeredSideAverage`. Note that the same of the `UserObject`, 'TRad_UO' must match the `user_object` name provided in the `[TRad_from_RCCS_sub]` block in the multi-D model.

```language=bash
[UserObjects]
  [TRad_UO]
    type = LayeredSideAverage
    variable = T_solid
    direction = y
    num_layers = 45
    boundary = 'rccs-panel:inner_wall'
    execute_on = 'timestep_end'
    use_displaced_mesh = true
  []
[]
```

The components of the RCCS model are modeled in the `[Components]` block in the input file. The RCCS panel is modeled as a `PBCoupledHeatStructure` with a 'Convective' boundary condition on the inner surface and a 'Coupled' boundary condition on the outer surface. The scaled heat flux, 'QRad_multiplied' is applied to the inner surface through the `qs_external_left` parameter. On the other hand, the outer surface is coupled to a fluid component named 'rccs-heated-riser' via the `name_comp_right` parameter. The heat transfer surface area density on the right side is provided through the `HT_surface_area_density_right` parameter.

```language=bash
  [rccs-panel]
    type = PBCoupledHeatStructure
    position    = '0 0 0.0'
    orientation = '0 1 0'
    hs_type = cylinder

    length = 16.8
    width_of_hs = '0.1'
    radius_i = 4.21
    elem_number_radial = 5
    elem_number_axial = 50
    dim_hs = 2
    material_hs = 'ss-mat'
    Ts_init = ${T_inlet_rccs}

    HS_BC_type = 'Convective Coupled'
    qs_external_left = QRad_multiplied
    name_comp_right = rccs-heated-riser
    HT_surface_area_density_right = 158.748
  []
```

The riser is coupled to the outer surface of the RCCS panel. Downstream of the riser is an unheated chimney. The chimney is assumed to be fairly tall to provide sufficient thermal driving head for natural circulation.

```language=bash
  [rccs-heated-riser]
    type           = PBOneDFluidComponent
    A              = 0.170588
    Dh             = ${Dh_pipe}
    length         = 16.8
    n_elems        = 50
    orientation    = '0 1 0'
    position       = '4.31 0 0'
  []
  [rccs-chimney]
    type           = PBOneDFluidComponent
    A              = 0.170588
    Dh             = ${Dh_pipe}
    length         = 10
    n_elems        = 50
    orientation    = '0 1 0'
    position       = '4.31 16.8 0'
  []
```

The outlet of the chimney is connected to a reservoir/pool that is modeled using a `PBLiquidVolume` component with an initial level of 10 m. The pool is assumed to be at atmospheric pressure.

```language=bash
  [pool]
    type             = PBLiquidVolume
    center           = '4.81 29.3 0'
    K                = '0 0 0 0'
    orientation      = '0 1 0'
    Area             = 30
    volume           = 300
    initial_T        = 303
    initial_level    = 10
    ambient_pressure = 1.01325e5
    eos              = eos
    width            = 1 # Display purpose
    height           = 5 # Display purpose
    outputs          = 'rccs-chimney(out) rccs-downcomer(out) IHX-inlet-pipe(in) IHX-outlet-pipe(out)'
  []
```

A heat exchanger is used in the pool for decay heat removal. On the primary side, the inlet and outlet of the heat exchanger are connected to the pool while a time-dependent junction and volume are used at the inlet and outlet on the seconday side. Water enters the secondary side at 303 K. Note that a large inlet flow rate is set on the secondary side to ensure to provide sufficient cooling to the pool.

```language=bash
  [IHX]
    type                              = PBHeatExchanger
    HX_type                           = Countercurrent
    eos_secondary                     = eos
    position                          = '4.81 31.8 0'
    orientation                       = '0 -1 0'
    A                                 = 0.36571
    Dh                                = 0.0108906
    PoD                               = 1.17
    HTC_geometry_type                 = Bundle
    length                            = 5
    n_elems                           = 10
    HT_surface_area_density           = 734.582
    A_secondary                       = 0.603437
    Dh_secondary                      = 0.0196
    length_secondary                  = 5
    HT_surface_area_density_secondary = 408.166
    hs_type                           = cylinder
    radius_i                          = 0.0098
    wall_thickness                    = 0.000889
    n_wall_elems                      = 3
    material_wall                     = ss-mat
    Twall_init                        = 303
    initial_T_secondary               = 303
    initial_P_secondary               = 1e5
    initial_V_secondary               = -100
    SC_HTC                            = 2.5
    SC_HTC_secondary                  = 2.5
    disp_mode                         = -1
    eos = eos
  []
  [IHX-inlet-pipe]
    type              = PBOneDFluidComponent
    input_parameters  = CoolantChannel
    position          = '4.81 29.3 -1'
    orientation       = '0 0 1'
    length            = 1
    A                 = 0.170588481
    Dh                = 2
    HTC_geometry_type = Pipe
    n_elems           = 10
    eos               = eos
    initial_T         = 303
  []

  [IHX-outlet-pipe]
    type              = PBOneDFluidComponent
    input_parameters  = CoolantChannel
    position          = '4.81 26.8 0'
    orientation       = '0 0 -1'
    length            = 1
    A                 = 0.170588481
    Dh                = 2
    HTC_geometry_type = Pipe
    n_elems           = 10
    eos               = eos
    initial_T         = 303
  []
  [IHX-junc-out]
    type      = PBSingleJunction
    eos       = eos
    inputs    = 'IHX(primary_out)'
    outputs   = 'IHX-outlet-pipe(in)'
    initial_T = 303
  []
  [IHX-junc-in]
    type    = PBVolumeBranch
    center  = '2.72 27.8 6'
    inputs  = 'IHX-inlet-pipe(out)'
    outputs = 'IHX(primary_in)'
    K       = '0 0'
    Area    = 0.170588481
    volume  = 0.01
    width   = 0.02049
    height  = 0.3
    eos     = eos
  []
  [IHX2-in]
    type  = PBTDJ
    v_bc  = -100
    T_bc  = 303
    eos   = eos
    input = 'IHX(secondary_in)'
  []
  [IHX2-out]
    type  = PBTDV
    eos   = eos
    p_bc  = 1e5
    input = 'IHX(secondary_out)'
  []
```

Downstream of the pool is the downcomer consisting of a vertical and horizontal section. The outlet of the horizontal section is connected to the inlet of the riser, thus completing the loop.

```language=bash
  [rccs-downcomer]
    type           = PBOneDFluidComponent
    A              = 0.170588 #17.7574
    Dh             = ${Dh_pipe}
    length         = 26.8
    n_elems        = 50
    orientation    = '0 1 0'
    position       = '5.31 0 0'
  []
  [rccs-downcomer-horizontal]
    type           = PBOneDFluidComponent
    A              = 0.170588 #17.7574
    Dh             = ${Dh_pipe}
    length         = 1
    n_elems        = 5
    orientation    = '1 0 0'
    position       = '4.31 0 0'
  []
```

The flow channels are connected to each other with `PBVolumeBranch`.

```language=bash
  [junc-riser-chimney]
    type    = PBVolumeBranch
    eos     = eos
    inputs  = 'rccs-heated-riser(out)'
    outputs = 'rccs-chimney(in)'
    K       = '0 0'
    Area    = 0.170588
    center  = '4.31 16.8 0'
    volume  = 0.01
  []
  [junc-horizontal-riser]
    type    = PBVolumeBranch
    eos     = eos
    inputs  = 'rccs-downcomer-horizontal(out)'
    outputs = 'rccs-heated-riser(in)'
    K       = '0 0'
    Area    = 0.170588
    center  = '4.31 0 0'
    volume  = 0.01
  []
  [junc-downcomer-horizontal]
    type    = PBVolumeBranch
    eos     = eos
    inputs  = 'rccs-downcomer(in)'
    outputs = 'rccs-downcomer-horizontal(in)'
    K       = '0 0'
    Area    = 0.170588
    center  = '5.31 0 0'
    volume  = 0.01
  []
```

# Input File Descriptions - Pressurized Loss of Forced Cooling (PLOFC) Transient

The transient PLOFC simulation is a restart from the steady-state simulation with some minor modifications in the input files. The `[Problem]` block in all three input files are modified where the path of the restart file is specified using the `restart_file_base` parameter.

```language=bash
### multi-D model
[Problem]
  type = FEProblem
  coord_type = RZ
  rz_coord_axis = Y
  restart_file_base = 'ss-main_checkpoint_cp/LATEST'
[]

### primary loop model
[Problem]
  restart_file_base = 'ss-primary-loop_checkpoint_cp/450'
[]

### RCCS model
[Problem]
  restart_file_base = 'ss-main_out_rccs0_checkpoint_cp/450'
[]
```

The SubApp files in the `[MultiApps]` block are changed to the transient files

```language=bash
[MultiApps]
  [primary_loop]
    type = TransientMultiApp
    input_files = 'ss-primary-loop-transient.i'
    catch_up = true
    execute_on = 'TIMESTEP_END'
  []

  [rccs]
    type = TransientMultiApp
    execute_on = timestep_end
    app_type = SamApp
    input_files = 'ss-rccs-water-transient.i'
    catch_up = true
  []
[]
```

Furthermore, the `start_time` and `end_time` parameters in the `[Executioner]` blocks of all three input files are modified to the desired values.

In the multi-D input file, the `initial_condition` parameters in the `[Variables]` and `[AuxVariables]` are removed.

Lastly, as discussed previously, the primary loop is simplified where components such as the blower, heat exchanger, and reference pressures are removed and replaced with inlet and outlet boundary conditions. Note that in the `[inlet]` block, the mass flow rate is set using the `m_fn` user-defined function.

```language=bash
  [inlet]
    type  = PBTDJ
    m_fn  = m_fn
    T_bc  = ${T_inlet}
    eos   = helium
    input = 'inlet_pipe(in)'
  []
  [outlet]
    type  = PBTDV
    eos   = helium
    p_bc  = ${p_outlet}
    input = 'outlet_pipe(out)'
  []
```

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

sam-opt -i ss-main-transient.i

```

And with Blue Crab

```language=bash

blue_crab-opt -i ss-main-transient.i --app SamApp

```


# Acknowledgements

This report was prepared as an account of work sponsored by an agency of the U.S. Government. Neither the U.S. Government nor any agency thereof, nor any of their employees, makes any warranty, expressed or implied, or assumes any legal liability or responsibility for any third party’s use, or the results of such use, of any information, apparatus, product, or process disclosed in this report, or represents that its use by such third party would not infringe privately owned rights. The views expressed in this paper are not necessarily those of the U.S. Nuclear Regulatory Commission. This work is supported by the U.S. Nuclear Regulatory Commission, under Task Order Agreement No. 31310021F0005. The authors would like to acknowledge the support and assistance from Dr. Mustafa Jaradat, Dr. Sebastian Schunert, and Dr. Javier Ortensi of Idaho National Laboratory in the completion of this work.
