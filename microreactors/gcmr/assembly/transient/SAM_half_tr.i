Area = 0.00005654866 # r = 0.6cm; A = pi*(0.6/100)^2/2
Height = 2.0 # bottom = 0.000000; top = 2.000000
Ph = 0.018849556 # Heated perimeter; Ph = C = 2*pi*r/2 (circumference for round pipe)
Dh = 0.012 # For circular pipe = D
Vin = 15 # Average flow velocity
Vint = 15 # Ultimate flow velovity
Tin = 873.15 # 600 C
Tint = 873.15 # Ultimate inlet temp
Pout = 7e+6 # 7 MPa
Poutt = 7e+6 # Ultimate outlet pressure
t0 = 10 # transition time (s)
orientation = 1 # Orientation of coolant channels
layers = 40 # Make sure the number of axial divisions in the fluid domain and solid domain are the same

[GlobalParams]
  global_init_P = ${Pout}
  global_init_V = ${Vin}
  global_init_T = ${Tin}
  gravity = '0 1e-8 0' # horizontal channel
  [PBModelParams]
    pbm_scaling_factors = '1 1e-3 1e-6'
    p_order = 2
  []
  Tsolid_sf = 1e-3 # Scaling factors for solid temperature
[]

[EOS]
  [eos]
    type = HeEquationOfState
  []
[]

[Components]
  [pipe1]
    type = PBOneDFluidComponent
    position = '0 0.0 0.0' # Position will be determined by ../../mesh/coolant_half_points.txt
    orientation = '0 0 ${orientation}'
    eos = eos

    f = 0.01
    length = ${Height}
    Ph = ${Ph}
    A = ${Area}
    Dh = ${Dh}
    n_elems = ${layers}
  []

  [ht1]
    type = HeatTransferWithExternalHeatStructure
    flow_component = pipe1
    initial_T_wall = 1150
    T_wall_name = Tw # Transferred from the solid domain
    htc_name = htc # Calculated by SAM
    elemental_vars = 1
  []

  [inlet] #Boundary components
    type = PBTDJ
    input = 'pipe1(in)'
    # v_bc = ${Vin}
    v_fn = Vin_func
    # T_bc = ${Tin}
    T_fn = Tin_func
    eos = eos
  []
  [outlet]
    type = PBTDV
    input = 'pipe1(out)'
    # p_bc = ${Pout}
    p_fn = Pout_func
    T_bc = 1123.1500 # 850 C
    eos = eos
  []
[]

[Functions]
  [Pout_func]
    type = ParsedFunction
    value = 'if(t<t0,P0+(Pt-P0)/t0*t,Pt)'
    vars = 'P0 Pt t0'
    vals = '${Pout} ${Poutt} ${t0}'
  []
  [Vin_func]
    type = ParsedFunction
    value = 'if(t<t0,V0+(Vt-V0)/t0*t,Vt)'
    vars = 'V0 Vt t0'
    vals = '${Vin} ${Vint} ${t0}'
  []
  [Tin_func]
    type = ParsedFunction
    value = 'if(t<t0,T0+(Tt-T0)/t0*t,Tt)'
    vars = 'T0 Tt t0'
    vals = '${Tin} ${Tint} ${t0}'
  []
[]

[UserObjects]
  [Tfluid_UO]
    # Creates UserObject needed for transfer
    type = LayeredAverage
    variable = temperature
    direction = z
    num_layers = ${layers}
    block = 'pipe1'
    execute_on = TIMESTEP_END
    use_displaced_mesh = true
  []
  [hfluid_UO]
    # Creates UserObject needed for transfer
    type = LayeredAverage
    variable = h_scaled # NOTE: h_scaled not htc is transferred.
    direction = z
    num_layers = ${layers}
    block = 'pipe1'
    execute_on = TIMESTEP_END
    use_displaced_mesh = true
  []
[]

[AuxVariables]
  [h_scaled]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 2500.00
    block = 'pipe1'
  []
[]

[AuxKernels]
  # HTC scaled by (real geometry surface area)/(model geometry surface area)
  [scale_htc]
    type = ParsedAux
    variable = h_scaled
    function = '1*htc' # 1 is replaced with the cli_args parameter in the multiapp block in ../solid_gcmr.i
    args = htc
  []
[]

[Preconditioning]
  active = 'SMP_PJFNK'
  [SMP_PJFNK]
    type = SMP
    full = true
    solve_type = 'PJFNK'
    petsc_options_iname = '-pc_type'
    petsc_options_value = 'lu'
  []
[]

[Executioner]
  type = Transient

  nl_rel_tol = 1e-8
  nl_abs_tol = 1e-9
  nl_max_its = 40

  start_time = 0.0 # negative start time so we can start running from t = 0
  end_time = 1e4
  dt = 1

  [Quadrature]
    type = SIMPSON
    order = SECOND
  []
[]

[Outputs]
  print_linear_residuals = false

  [console]
    type = Console
  []
  [out_displaced]
    type = Exodus
    # file_base = coolant/
    use_displaced = true
    execute_on = 'initial timestep_end'
    sequence = false
    output_material_properties = True
  []
  [csv]
    type = CSV
    # file_base = coolant/out
    execute_on = 'initial timestep_end'
  []
[]

[Postprocessors]
  [_PipeHeatRemovalRate] # Used to measure energy balance
    type = ComponentBoundaryEnergyBalance
    input = 'pipe1(in) pipe1(out)'
    eos = eos
    execute_on = 'TIMESTEP_END'
  []
  [mfr]
    type = ComponentBoundaryFlow
    input = 'pipe1(in)'
    execute_on = 'TIMESTEP_END'
  []
  [rho_in]
    type = ComponentBoundaryVariableValue
    input = 'pipe1(in)'
    variable = rho
    execute_on = 'TIMESTEP_END'
  []
  [rho_out]
    type = ComponentBoundaryVariableValue
    input = 'pipe1(out)'
    variable = rho
    execute_on = 'TIMESTEP_END'
  []
  [T_in]
    type = ComponentBoundaryVariableValue
    input = 'pipe1(in)'
    variable = temperature
    execute_on = 'TIMESTEP_END'
  []
  [T_out]
    type = ComponentBoundaryVariableValue
    input = 'pipe1(out)'
    variable = temperature
    execute_on = 'TIMESTEP_END'
  []
  [P_in]
    type = ComponentBoundaryVariableValue
    input = 'pipe1(in)'
    variable = pressure
    execute_on = 'TIMESTEP_END'
  []
  [P_out]
    type = ComponentBoundaryVariableValue
    input = 'pipe1(out)'
    variable = pressure
    execute_on = 'TIMESTEP_END'
  []
  [v_in]
    type = ComponentBoundaryVariableValue
    input = 'pipe1(in)'
    variable = velocity
    execute_on = 'TIMESTEP_END'
  []
  [v_out]
    type = ComponentBoundaryVariableValue
    input = 'pipe1(out)'
    variable = velocity
    execute_on = 'TIMESTEP_END'
  []
  [htc_avg]
    type = ElementAverageValue
    variable = htc
    execute_on = 'TIMESTEP_END'
  []
[]
