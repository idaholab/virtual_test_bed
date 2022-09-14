# Models the RCCS flow channel for the PG-26 transient
T_in = 300 # K
p_out = 101000 # Pa
m_dot_in = 0.3 # kg/s
rho = 997 # kg/s
inner_wall = 2.394 # m
outer_wall = 2.418 # m
A_channel = ${fparse (outer_wall * outer_wall) - (inner_wall * inner_wall)} # m^2
vel_in = ${fparse m_dot_in/(rho*A_channel)} # m/s
l_core = 4.880 # m
axial_elems = 35
P_hf_inner = ${fparse 4 * inner_wall} # m
P_hf_outer = ${fparse 4 * outer_wall} # m
roughness = 0.00004 # m
D_h = ${fparse (4 * A_channel)/((4 * outer_wall) + (4 * inner_wall))} # m
[GlobalParams]
  initial_p = ${p_out}
  initial_T = ${T_in}
  initial_vel = ${vel_in}
  vel_x = 0
  vel_y = 0
  closures = 1_phase
  rdg_slope_reconstruction = minmod
  roughness = ${roughness}
  fp = fp_water
  scaling_factor_1phase = '1 1e-3 1e-5'
[]
# Selects sinlge phase water as working fluid
[FluidProperties]
  [fp_water]
    type = IAPWS95LiquidFluidProperties
  []
[]
# Determines which friction factor and heat transfer correlations to use
[Closures]
  [1_phase]
    type = Closures1PhaseTRACE
  []
[]
# Necessary functions for the PG-26 Transient
[Functions]
  # Creates a function with respect to time for the RCCS inlet temperature based on a data file from the PG-26 Transient
  [inlet_temp]
    type = PiecewiseLinear
    data_file = '../PG26/PG26_RCCS_temp.txt'
    x_index_in_file = 0
    y_index_in_file = 1
    format = columns
  []
  # Creates a function with respect to time for the RCCS mass flow rate based on a data file from the PG-26 Transient
  [mdot_in_fn]
    type = PiecewiseLinear
    data_file = '../PG26/PG26_RCCS_mdot.txt'
    x_index_in_file = 0
    y_index_in_file = 1
    format = columns
  []
[]
# Creates necessary variables for multi-app execution
[AuxVariables]
  # Convective heat transfer coefficient between the RCCS water and inner panel surface
  [Hw_inner]
    family = MONOMIAL
    order = CONSTANT
  []
  # Wall temperature of the inner panel
  [T_wall_inner]
    initial_condition = 300
  []
  # Convective heat transfer coefficient between the RCCS water and outer panel surface
  [Hw_outer]
    family = MONOMIAL
    order = CONSTANT
  []
  # Wall temperature of the outer panel
  [T_wall_outer]
    initial_condition = 300
  []
[]
# Applies parameters to necessary AuxVariables
[AuxKernels]
  # Sets Hw_inner to Hw:1
  [Hw_inner_aux]
    type = ADMaterialRealAux
    variable = Hw_inner
    property = Hw:1
  []
  # Sets Hw_outer to Hw:2
  [Hw_outer_aux]
    type = ADMaterialRealAux
    variable = Hw_outer
    property = Hw:2
  []
[]
# Creates necessary elements of the thermal hydraulic system (referred to as components)
[Components]
  # Inlet which initializes the upcomer flow channel based on an inlet temperature and mass flow rate
  [channel_inlet]
    type = InletMassFlowRateTemperature1Phase
    input = 'RCCS:in'
    m_dot = ${m_dot_in} # Overwritten by ControlLogic below
    T = 300 # Overwritten by ControlLogic below
  []
  # Creates a single phase flow channel named RCCS
  [RCCS]
    type = FlowChannel1Phase
    position = '0 0 0' # Overwritten by position file used in main app
    orientation = '0 0 1' # Vertiacally oriented
    A = ${A_channel}
    D_h = ${D_h}
    length = ${l_core}
    n_elems = ${axial_elems}
  []
  # Outlet which terminates the upcomer flow channel based on supplied back pressure
  [core_outlet]
    type = Outlet1Phase
    input = 'RCCS:out'
    p = ${p_out}
  []
  # Assigns heat transfer between the RCCS and inner panel
  [heat_transfer_inner]
    type = HeatTransferFromExternalAppTemperature1Phase
    flow_channel = RCCS
    T_ext = T_wall_inner
    P_hf = ${P_hf_inner}
  []
  # Assigns heat transfer between the RCCS and outer panel
  [heat_transfer_outer]
    type = HeatTransferFromExternalAppTemperature1Phase
    flow_channel = RCCS
    T_ext = T_wall_outer
    P_hf = ${P_hf_outer}
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
 # Sets the channel_inlet m_dot parameter based on values from mdot_in_fn function
  [mdot_control]
    type = TimeFunctionComponentControl
    function = mdot_in_fn
    component = channel_inlet
    parameter = m_dot
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
  nl_rel_tol = 1e-4
  nl_abs_tol = 1e-4
  nl_max_its = 40
  [Quadrature]
    type = GAUSS
    order = SECOND
  []
[]
# Records water temperature at the inlet, mid point, and outlet of the flow channel
[Postprocessors]
  [temp_out]
    type = PointValue
    point = '0 0 ${l_core}'
    variable = T
    execute_on = 'INITIAL TIMESTEP_BEGIN'
  []
  [temp_mid]
    type = PointValue
    point = '0 0 ${fparse l_core/2}'
    variable = T
    execute_on = 'INITIAL TIMESTEP_BEGIN'
  []
  [temp_in]
    type = PointValue
    point = '0 0 0.01'
    variable = T
    execute_on = 'INITIAL TIMESTEP_BEGIN'
  []
[]
[Outputs]
  csv = true
  checkpoint = true
[]
