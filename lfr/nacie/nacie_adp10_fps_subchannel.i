flow_area = 654.1503e-6  
mass_flux_in = ${fparse 2.5595/flow_area} #experimental data
P_out = 8.356458e+05 
T_in = 498.3 

[TriSubChannelMesh]
  [subchannel]
    type = SCMTriAssemblyMeshGenerator
    nrings = 3
    n_cells = 263
    flat_to_flat = 3.934e-2
    heated_length = 1.315
    pin_diameter = 6.55e-3
    pitch = 8.39972e-3
    dwire = 1.75e-3
    hwire = 0.262
    spacer_z = '0'
    spacer_k = '0'
  []
[]

[FluidProperties]
  [LBE]
    type = LeadBismuthFluidProperties
  []
[]

[AuxVariables]
  [mdot]
    block = subchannel
  []
  [SumWij]
    block = subchannel
  []
  [P]
    block = subchannel
  []
  [DP]
    block = subchannel
  []
  [h]
    block = subchannel
  []
  [T]
    block = subchannel
  []
  [rho]
    block = subchannel
  []
  [S]
    block = subchannel
  []
  [Sij]
    block = subchannel
  []
  [w_perim]
    block = subchannel
  []
  [q_prime]
    block = fuel_pins
  []
  [mu]
    block = subchannel
  []
  [dmT] 
    block = subchannel
  []
  [dmh] 
    block = subchannel
  []
  [displacement]
    block = subchannel
  []
  [Tpin]
    block = fuel_pins
  []
  [Dpin]
    block = fuel_pins
  []
[]

[SubChannel]
  type = TriSubChannel1PhaseProblem
  fp = LBE
  n_blocks = 1
  P_out = P_out_bc
  compute_density = true
  compute_viscosity = true
  compute_power = true
  P_tol = 1.0e-5
  T_tol = 1.0e-5
  implicit = true
  segregated = false
  staggered_pressure = false
  interpolation_scheme = 'upwind'
  pin_HTC_closure = 'kazimi_carelli'
  friction_closure = 'cheng'
  mixing_closure = 'cheng_todreas'
[]

[SCMClosures]
  [cheng]
    type = SCMFrictionUpdatedChengTodreas
  []
  [kazimi_carelli]
    type = SCMHTCKazimiCarelli
  []
  [cheng_todreas]
    type = SCMMixingChengTodreas
    CT = 1.0
  []
[]

[ICs]
  [S_IC]
    type = SCMTriFlowAreaIC
    variable = S
  []

  [w_perim_IC]
    type = SCMTriWettedPerimIC
    variable = w_perim
  []

  [q_prime_IC]
    type = SCMTriPowerIC
    variable = q_prime
    power = 30000.0 # W
    axial_heat_rate = axial_heat_rate
    filename = "uniform_19_pins.txt"
 []

  [T_ic]
    type = ConstantIC
    variable = T
    value = ${T_in}
  []

  [P_ic]
    type = ConstantIC
    variable = P
    value = 0.0
  []

  [DP_ic]
    type = ConstantIC
    variable = DP
    value = 0.0
  []

  [Dpin_ic]
    type = ConstantIC
    variable = Dpin
    value = 6.55e-3
  []

  [Viscosity_ic]
    type = ViscosityIC
    variable = mu
    p = ${P_out}
    T = T
    fp = LBE
  []

  [rho_ic]
    type = RhoFromPressureTemperatureIC
    variable = rho
    p = ${P_out}
    T = T
    fp = LBE
  []

  [h_ic]
    type = SpecificEnthalpyFromPressureTemperatureIC
    variable = h
    p = ${P_out}
    T = T
    fp = LBE
  []

  [mdot_ic]
    type = ConstantIC
    variable = mdot
    value = 0.0
  []

  [dmt_ic]
    type = ConstantIC
    variable = dmT
    value = ${fparse mass_flux_in*T_in}
  []
[]

[AuxKernels]
  [dmT_aux]
    type = ParsedAux
    variable = dmT
    block = subchannel
    coupled_variables = 'mdot T'
    expression = 'mdot * T'
  []
  [dmh_aux]
    type = ParsedAux
    variable = dmh
    block = subchannel
    coupled_variables = 'mdot h'
    expression = 'mdot * h'
  []

  [T_in_bc]
    type = FunctionAux
    variable = T
    block = subchannel
    boundary = inlet
    function = T_inlet_function
    execute_on = 'timestep_begin'
  []

  [mdot_in_bc]
    type = SCMMassFlowRateAux
    variable = mdot
    block = subchannel
    boundary = inlet
    area = S
    mass_flux = mass_flux_SAM
    execute_on = 'timestep_begin'
  []
[]

[Functions]
  [T_inlet_function]
    type = ParsedFunction
    expression = 'T_inlet'
    symbol_names = 'T_inlet'
    symbol_values = 'T_in_bc'
  []

  [axial_heat_rate]
    type = PiecewiseConstant
    x    =  '0             0.615            1.215              1.315'
    y    =  '0.158621190772  1.984965956725  0.264683936400  0.264683936400'
    direction = left
    axis = z
  []
[]

[Postprocessors]
  [T_heated_outlet_average]
    type = SCMPlanarMean
    variable = T
    height = 1.315
    execute_on = 'INITIAL TIMESTEP_END'
  []

  [total_pressure_drop_SC]
    type = SubChannelDelta
    variable = P
    execute_on = 'TIMESTEP_END'
  []

  [dpdz_core]
    type = ParsedPostprocessor
    expression = 'total_pressure_drop_SC / 1.315'
    pp_names = 'total_pressure_drop_SC'
    execute_on = 'TIMESTEP_END'
  []

  [sum_m_T]
    type = NodalSum
    variable = dmT
    boundary = outlet
    execute_on = 'TIMESTEP_END'
  []

  [sum_m_h]
    type = NodalSum
    variable = dmh
    boundary = outlet
    execute_on = 'TIMESTEP_END'
  []

  [sum_m_h_in]
    type = NodalSum
    variable = dmh
    boundary = inlet
    execute_on = 'TIMESTEP_END'
  []

  [P_in]
    type = AverageNodalVariableValue
    variable = P
    boundary = inlet
    execute_on = 'TIMESTEP_END'
  []

  [P_outlet]
    type = AverageNodalVariableValue
    variable = P
    boundary = outlet
    execute_on = 'TIMESTEP_END'
  []

  [P_out_bc]
    type = Receiver
    default = ${P_out}
  []

  [T_in_bc]
    type = Receiver
    default = ${T_in}
  []

  [mass_flux_SAM]
    type = Receiver
    default = ${fparse mass_flux_in}
  []

  [P_in_0]
    type = SubChannelPointValue
    variable = P
    index = 34
    execute_on = 'TIMESTEP_END'
    height = 0
  []

  [P_in_1]
    type = SubChannelPointValue
    variable = P
    index = 11
    execute_on = 'TIMESTEP_END'
    height = 0
  []

  [P_in_2]
    type = SubChannelPointValue
    variable = P
    index = 3
    execute_on = 'TIMESTEP_END'
    height = 0
  []

  [TCFPS01]
    type = SubChannelPointValue
    variable = T
    index = 3 #S2
    execute_on = 'TIMESTEP_END'
    height = 0.653
  []

  [TCFPS02]
    type = SubChannelPointValue
    variable = T
    index = 0 #S5
    execute_on = 'TIMESTEP_END'
    height = 0.653
  []

  [TCFPS03]
    type = SubChannelPointValue
    variable = T
    index = 11 # S22
    execute_on = 'TIMESTEP_END'
    height = 0.653
  []

  [TCFPS04]
    type = SubChannelPointValue
    variable = T
    index = 36 # S22
    execute_on = 'TIMESTEP_END'
    height = 0.653
  []

  [TCFPS05]
    type = SubChannelPointValue
    variable = T
    index = 34 #S33
    execute_on = 'TIMESTEP_END'
    height = 0.653
  []

  [TCFPS06]
    type = SubChannelPointValue
    variable = T
    index = 3
    execute_on = 'TIMESTEP_END'
    height = 0.915
  []

  [TCFPS07]
    type = SubChannelPointValue
    variable = T
    index = 0
    execute_on = 'TIMESTEP_END'
    height = 0.915
  []

  [TCFPS08]
    type = SubChannelPointValue
    variable = T
    index = 11
    execute_on = 'TIMESTEP_END'
    height = 0.915
  []

  [TCFPS09]
    type = SubChannelPointValue
    variable = T
    index = 36
    execute_on = 'TIMESTEP_END'
    height = 0.915
  []

  [TCFPS10]
    type = SubChannelPointValue
    variable = T
    index = 34
    execute_on = 'TIMESTEP_END'
    height = 0.915
  []

  [TCFPS11]
    type = SubChannelPointValue
    variable = T
    index = 3
    execute_on = 'TIMESTEP_END'
    height = 1.177
  []

  [TCFPS12]
    type = SubChannelPointValue
    variable = T
    index = 0
    execute_on = 'TIMESTEP_END'
    height = 1.177
  []

  [TCFPS13]
    type = SubChannelPointValue
    variable = T
    index = 11
    execute_on = 'TIMESTEP_END'
    height = 1.177
  []

  [TCFPS14]
    type = SubChannelPointValue
    variable = T
    index = 36
    execute_on = 'TIMESTEP_END'
    height = 1.177
  []

  [TCFPS15]
    type = SubChannelPointValue
    variable = T
    index = 34
    execute_on = 'TIMESTEP_END'
    height = 1.177
  []

  [T_out_2]
    type = SubChannelPointValue
    variable = T
    index = 3
    execute_on = 'TIMESTEP_END'
    height = 1.215
  []

  [T_out_1]
    type = SubChannelPointValue
    variable = T
    index = 11
    execute_on = 'TIMESTEP_END'
    height = 1.215
  []

  [T_out_0]
    type = SubChannelPointValue
    variable = T
    index = 34
    execute_on = 'TIMESTEP_END'
    height = 1.215
  []

  [T_out]
    type = ParsedPostprocessor
    expression = 'sum_m_T / mFlow_out'
    pp_names = 'sum_m_T mFlow_out'
    execute_on = 'TIMESTEP_END'
  []

  [h_out]
    type = ParsedPostprocessor
    expression = 'sum_m_h / mFlow_out'
    pp_names = 'sum_m_h mFlow_out'
    execute_on = 'TIMESTEP_END'
  []

  [h_in]
    type = ParsedPostprocessor
    expression = 'sum_m_h_in / mFlow_in'
    pp_names = 'sum_m_h_in mFlow_in'
    execute_on = 'TIMESTEP_END'
  []

  [dh]
    type = ParsedPostprocessor
    expression = 'h_out - h_in'
    pp_names = 'h_in h_out'
    execute_on = 'TIMESTEP_END'
  []

  [mFlow_out]
    type = NodalSum
    variable = mdot
    boundary = outlet
    execute_on = 'TIMESTEP_END'
  []

  [mFlow_in]
    type = NodalSum
    variable = mdot
    boundary = inlet
    execute_on = 'TIMESTEP_END'
  []

  [rho_out]
    type = AverageNodalVariableValue
    variable = rho
    boundary = outlet
    execute_on = 'TIMESTEP_END'
  []
[]

[Preconditioning]
  active = 'SMP_PJFNK'
  [SMP_PJFNK]
    type = SMP
    full = true
    solve_type = 'PJFNK'
    petsc_options_iname = '-pc_type -ksp_gmres_restart'
    petsc_options_value = 'lu 101'
  []
[]

[Executioner]
  type = Transient

  start_time = -10000
  end_time = 8000 
  dtmax = 50

  [TimeStepper]
    type = IterationAdaptiveDT
    growth_factor = 1.25
    optimal_iterations = 15
    linear_iteration_ratio = 100
    dt = 0.5
    cutback_factor = 0.5
    cutback_factor_at_failure = 0.5
  []

  [Quadrature]
    type = TRAP
    order = FIRST
  []
[]

[Outputs]
  perf_graph = true
  [out]
    type = Checkpoint        
  []
  [console]
    type = Console
  []
  [out_displaced]
    type = Exodus
    execute_on = 'initial timestep_end'
    sequence = false
  []
  [csv]
    type = CSV
  []
[]
