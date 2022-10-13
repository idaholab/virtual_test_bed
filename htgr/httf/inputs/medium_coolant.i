# Model of the 1.3 cm diameter (medium) flow channels
T_in = 373.15 # K
p_out = 225000 # Pa
n_large_channels = 324
n_small_channels = 96
n_medium_channels = 96
n_large_bypass = 6
n_small_bypass = 36
D_l = 0.016 # m
A_l = ${fparse ((D_l*D_l)/4)*pi*n_large_channels} # m^2
D_m = 0.013 # m
A_m = ${fparse ((D_m*D_m)/4)*pi*n_medium_channels} # m^2
D_s = 0.01 # m
A_s = ${fparse ((D_s*D_s)/4)*pi*n_small_channels} # m^2
D_lb = 0.019 # m
A_lb = ${fparse ((D_lb*D_lb)/4)*pi*n_large_bypass} # m^2
D_sb = 0.016 # m
A_sb = ${fparse ((D_sb*D_sb)/4)*pi*n_small_bypass} # m^2
A_total = ${fparse A_l + A_m + A_s + A_lb + A_sb} # m^2
m_dot_total = 0.005 # kg/s
m_dot_in = ${fparse (m_dot_total*(A_m/A_total))/n_medium_channels} # kg/s
R_He = 2076.9 # J/kg-K
rho_He = ${fparse p_out/(R_He*T_in)} # kg/m^3
D_channel = 0.013 # m
R_channel = ${fparse D_channel/2} # m
A_channel = ${fparse R_channel * R_channel * pi} # m^2
vel_in = ${fparse m_dot_in/(rho_He*A_channel)}
l_core = 2.864 # m
axial_elems = 112
P_hf_channel = ${fparse pi * D_channel} # m
roughness = 0.00004 # m
[GlobalParams]
  initial_p = ${p_out}
  initial_T = ${T_in}
  initial_vel = ${vel_in}
  vel_x = 0
  vel_y = 0
  closures = high_temp_gas
  rdg_slope_reconstruction = full
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
  # Creates a function of the PostProcessor value received from the main app solve named upcomer_outlet
  [upcomer_temp]
    type = ParsedFunction
    value = 'upcomer_outlet'
    vals = 'upcomer_outlet'
    vars = 'upcomer_outlet'
  []
  # Creates a function with respect to time for the system pressure based on a data file from the PG-26 Transient
  [system_pressure]
    type = PiecewiseLinear
    data_file = '../PG26/PG26_primary_pressure.txt'
    x_index_in_file = 0
    y_index_in_file = 1
    format = columns
  []
  # Creates a function which calculates the inlet mass flowrate of a single medium flow channel
  [mdot_in_fn]
    type = ParsedFunction
    value = '${fparse (m_dot_total*(A_m/A_total))/n_medium_channels}'
    vars = 'm_dot_total A_m A_total n_medium_channels'
    vals = '${m_dot_total} ${A_m} ${A_total} ${n_medium_channels}'
  []
[]
# Creates necessary variables for multi-app execution
[AuxVariables]
  # Convective heat transfer coefficient between the small coolant channel and ceramic core
  [Hw_chan]
    family = MONOMIAL
    order = CONSTANT
  []
  # Wall temperature of the flow channel
  [T_wall_channel]
    initial_condition = 400
  []
[]
# Applies parameters to necessary AuxVariables
[AuxKernels]
  # Sets Hw_chan to the parameter Hw
  [Hw_channel_aux]
    type = ADMaterialRealAux
    variable = Hw_chan
    property = Hw
  []
[]
# Creates necessary elements of the thermal hydraulic system (referred to as components)
[Components]
  # Inlet which initializes the medium flow channel based on an inlet temperature and mass flow rate
  [channel_inlet]
    type = InletMassFlowRateTemperature1Phase
    input = 'core_channel:in'
    m_dot = ${m_dot_in} # Overwritten by ControlLogic below
    T = ${T_in} # Overwritten by ControlLogic below
  []
  # Creates a single phase flow channel named core_channel
  [core_channel]
    type = FlowChannel1Phase
    position = '0 0 0' # Overwritten by position file used in main app
    orientation = '0 0 -1' # Directs flow in the negative z direction
    A = ${A_channel}
    D_h = ${D_channel}
    length = ${l_core}
    n_elems = ${axial_elems}
  []
  # Outlet which terminates the upcomer flow channel based on supplied back pressure
  [core_outlet]
    type = Outlet1Phase
    input = 'core_channel:out'
    p = ${p_out} # Overwritten by ControlLogic below
  []
  # Assigns heat transfer between the core_channel and ceramic core
  [heat_transfer]
    type = HeatTransferFromExternalAppTemperature1Phase
    flow_channel = core_channel
    T_ext = T_wall_channel
    P_hf = ${P_hf_channel}
  []
[]
# Controls desired parameters in the Components block
[ControlLogic]
  # Converts the upcomer_temp function into a ParsedFunctionControl which can be applied to a Component
  [inlet_temp_logic]
    type = ParsedFunctionControl
    function = 'if(t > 0, upcomer_temp, 300)'
    vals = 'upcomer_temp'
    vars = 'upcomer_temp'
  []
  # Applies the output of inlet_temp_logic to the channel_inlet T parameter
  [inlet_temp]
    type = SetComponentRealValueControl
    component = channel_inlet
    parameter = T
    value = inlet_temp_logic:value
  []
  # Sets the core_outlet p paremeter based on values from system_pressure function
  [pressure_control]
    type = TimeFunctionComponentControl
    component = core_outlet
    parameter = p
    function = system_pressure
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

  nl_rel_tol = 1e-8
  nl_abs_tol = 1e-8
  nl_max_its = 40

  [Quadrature]
    type = GAUSS
    order = SECOND
  []
[]
# Records inlet and outlet mass flow rate and temperature
[Postprocessors]
  [mdot_out]
    type = PointValue
    variable = rhouA
    point = '0 0 ${fparse -l_core}'
    execute_on = 'TIMESTEP_END'
  []
  [mdot_in]
    type = PointValue
    variable = rhouA
    point = '0 0 0'
    execute_on = 'TIMESTEP_END'
  []
  [T_out]
    type = PointValue
    variable = T
    point = '0 0 ${fparse -l_core}'
    execute_on = 'TIMESTEP_END'
  []
  # Receives outlet temperature from the main app which originates from upcomer.i
  # used in upcomer_temp function
  [upcomer_outlet]
    type = Receiver
    execute_on = 'INITIAL TIMESTEP_BEGIN'
  []
  # Creates a weighted outlet temperature based on mass flow rate
  [T_out_weighted]
    type = ParsedPostprocessor
    pp_names = 'T_out'
    function = '${fparse (m_dot_in/m_dot_total)} * T_out'
    execute_on = 'TIMESTEP_END'
  []
[]
[Outputs]
  exodus = true
  csv = true
[]
