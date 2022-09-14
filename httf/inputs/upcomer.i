# Models the upcomer for the HTTF PG-26 Transient
T_in = 373.15 # K
p_out = 225000 # Pa
m_dot_in = 0.005
R_He = 2076.9 # J/kg-K
rho_He = ${fparse p_out/(R_He*T_in)} # kg/m^3
D_RPV_inner = ${fparse 2 * 0.819} # m
D_barrel_outer = ${fparse 2 * 0.762} # m
A_channel = ${fparse (pi * ((D_RPV_inner * D_RPV_inner)/4)) - (pi * ((D_barrel_outer * D_barrel_outer)/4))} # m^2
vel_in = ${fparse m_dot_in/(rho_He*A_channel)} # m
l_core = 3.477 # m
axial_elems = 35
P_hf_barrel = ${fparse pi * D_barrel_outer} # m
P_hf_RPV = ${fparse pi * D_RPV_inner} # m
roughness = 0.00004 # m
D_h = ${fparse (4 * A_channel)/((pi * D_RPV_inner) + (pi * D_barrel_outer))} # m
[GlobalParams]
  initial_p = ${p_out}
  initial_T = ${T_in}
  initial_vel = ${vel_in}
  vel_x = 0
  vel_y = 0
  closures = high_temp_gas
  rdg_slope_reconstruction = minmod
  roughness = ${roughness}
  fp = fp_helium
  scaling_factor_1phase = '1 1e-3 1e-5'
[]
# Selects Helium as working fluid
[FluidProperties]
  [fp_helium]
    type = HeliumSBTLFluidProperties
  []
[]
# Determines which friction factor and heat transfer correlations to use
[Closures]
  [high_temp_gas]
    type = Closures1PhaseHighTempGas
  []
[]
# Necessary functions for the PG-26 Transient
[Functions]
  # Creates a function with respect to time for the upcomer inlet temperature based on a data file from the PG-26 Transient
  [inlet_temp]
    type = PiecewiseLinear
    data_file = '../PG26/PG26_circ_outlet.txt'
    x_index_in_file = 0
    y_index_in_file = 1
    format = columns
  []
  # Creates a constant function which is applied to the inlet mass flow rate
  [mdot_in_fn]
    type = ConstantFunction
    value = 0.005 # kg/s
  []
[]
# Creates necessary variables for multi-app execution
[AuxVariables]
  # Convective heat transfer coefficient between the upcomer gas and core barrel outer surface
  [Hw_barrel]
    family = MONOMIAL
    order = CONSTANT
  []
  # Wall temperature of the core barrel
  [T_wall_barrel]
    initial_condition = 400
  []
  # Convective heat transfer coefficient between the upcomer gas and RPV inner surface
  [Hw_RPV]
    family = MONOMIAL
    order = CONSTANT
  []
  # Wall temperature of the RPV inner surface
  [T_wall_RPV]
    initial_condition = 300
  []
[]
# Applies parameters to necessary AuxVariables
[AuxKernels]
  # Sets Hw_barrel to the parameter Hw:1
  [Hw_barrel_aux]
    type = ADMaterialRealAux
    variable = Hw_barrel
    property = Hw:1
  []
  # Sets Hw_RPV to the parameter Hw:2
  [Hw_RPV_aux]
    type = ADMaterialRealAux
    variable = Hw_RPV
    property = Hw:2
  []
[]
# Creates necessary elements of the thermal hydraulic system (referred to as components)
[Components]
  # Inlet which initializes the upcomer flow channel based on an inlet temperature and mass flow rate
  [channel_inlet]
    type = InletMassFlowRateTemperature1Phase
    input = 'upcomer:in'
    m_dot = ${m_dot_in} # Overwritten by ControlLogic below
    T = ${T_in} # Overwritten by ControlLogic below
  []
  # Creates a single phase flow channel named upcomer
  [upcomer]
    type = FlowChannel1Phase
    position = '0 0 0' # Overwritten by postion file used in main app
    orientation = '0 0 1' # Vertically oriented
    A = ${A_channel}
    D_h = ${D_h}
    length = ${l_core}
    n_elems = ${axial_elems}
  []
  # Outlet which terminates the upcomer flow channel based on supplied back pressure
  [core_outlet]
    type = Outlet1Phase
    input = 'upcomer:out'
    p = ${p_out} # Overwritten by ControlLogic below
  []
  # Assigns heat transfer between the upcomer and core barrel outer surface
  [ht_barrel]
    type = HeatTransferFromExternalAppTemperature1Phase
    flow_channel = upcomer
    T_ext = T_wall_barrel
    P_hf = ${P_hf_barrel}
  []
  # Assigns heat transfer between the upcomer and RPV inner surface
  [ht_RPV]
    type = HeatTransferFromExternalAppTemperature1Phase
    flow_channel = upcomer
    T_ext = T_wall_RPV
    P_hf = ${P_hf_RPV}
  []
[]
# Controls desired parameters in the Components block
[ControlLogic]
  # Sets the channel_inlet T parameter based on values from inlet_temp function
  [T_in]
    type = TimeFunctionComponentControl
    function = inlet_temp
    component = channel_inlet
    parameter = T
  []
  # Creates a ParsedFunction used to control inlet mass flow rate. If t <= 180,000 s then use mdot_in_fn supplied in Functions.
  # else, set mdot to 0 (simulates coolant shutoff from experiment)
  [mdot_control]
    type = ParsedFunctionControl
    function = 'if(t <= 180000, mdot_in_fn, 0)'
    vals = 'mdot_in_fn'
    vars = 'mdot_in_fn'
  []
  # Takes value produced by mdot_control, and applies it to the channel_inlet m_dot parameter
  [mdot_applied]
    type = SetComponentRealValueControl
    component = channel_inlet
    parameter = m_dot
    value = mdot_control:value
  []
[]
[Preconditioning]
  [SMP]
    type = SMP
    full = true
  []
[]
[Executioner]
  type = Transient
  scheme = 'bdf2'
  # Preferred petsc options for relap-7 flow channel execution
  petsc_options_iname = '-pc_type'
  petsc_options_value = 'lu      '
  solve_type = 'NEWTON'
  line_search = 'basic'
  start_time = 0
  steady_state_detection = false
  dtmin = 0.1
  end_time = 270000
  dtmax = 500
  [TimeStepper]
    type = IterationAdaptiveDT
    dt = 1e-3
  []
  nl_rel_tol = 1e-5
  nl_abs_tol = 1e-5
  nl_max_its = 40
  [Quadrature]
    type = GAUSS
    order = SECOND
  []
[]
# Records outlet temperature of the upcomer
[Postprocessors]
  [temp]
    type = PointValue
    point = '0 0 ${l_core}'
    variable = T
    execute_on = 'INITIAL TIMESTEP_BEGIN'
  []
[]
[Outputs]
  exodus = true
  csv = true
[]
