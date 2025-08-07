################################################################################
## NEAMS Micro-Reactor Application Driver                                     ##
## Gas Cooled Microreactor Full Core Steady State                             ##
## SAM/THM Grandchild Application input file                                  ##
## Helium coolant channel model                                               ##
## If using or referring to this model, please cite as explained in           ##
## https://mooseframework.inl.gov/virtual_test_bed/citing.html                ##
################################################################################

r_channel = 0.006
Area = '${fparse pi * r_channel^2}'
Height = 2.4 # bottom = 0.000000; top = 2.400000
Ph = '${fparse 2 * pi * r_channel}' # Heated perimeter; Ph = C = 2*pi*r (circumference for round pipe)
Dh = '${fparse 2 * r_channel}' # For circular pipe = D
Vin = 15 # Average flow velocity
Tin = 873.15 # 600 C
Pout = 7e+6 # 7 MPa
layers = 40 # Make sure the number of axial divisions in the fluid domain and solid domain are the same

[GlobalParams]
  initial_p = ${Pout}
  initial_vel = ${Vin}
  initial_T = ${Tin}
  gravity_vector = '0 0 0' # horizontal channel
  rdg_slope_reconstruction = full
  scaling_factor_1phase = '1 1e-2 1e-5'
[]

[FluidProperties]
  [He]
    type = IdealGasFluidProperties
    molar_mass = 0.004003
    mu = 4.2926127588e-05
    k = 0.338475615
    gamma = 1.66
  []
[]

[Closures]
  [custom]
    type = Closures1PhaseNone
  []
[]

[Materials]
  [friction_factor_mat]
    type = ADWallFrictionChurchillMaterial
    vel = vel
    D_h = D_h
    mu = mu
    rho = rho
    f_D = f_D
  []
  [Hw_mat]
    type = ADWallHeatTransferCoefficient3EqnDittusBoelterMaterial
    vel = vel
    D_h = D_h
    mu = mu
    rho = rho
    cp = cp
    k = k
    T = T
    T_wall = T_wall
  []
[]
[Components]
  [pipe1]
    type = FlowChannel1Phase
    position = '0 0.0 0.0'
    orientation = '0 0 1'
    fp = He
    closures = custom
    length = ${Height}
    A = ${Area}
    D_h = ${Dh}
    n_elems = ${layers}
  []

  [ht1]
    type = HeatTransferFromExternalAppTemperature1Phase
    flow_channel = pipe1
    initial_T_wall = ${Tin}
    P_hf = ${Ph}
    T_ext = T_wall
  []

  [inlet] # Boundary conditions
    type = InletVelocityTemperature1Phase
    input = 'pipe1:in'
    vel = ${Vin}
    T = ${Tin}
  []

  [outlet] # Boundary conditions
    type = Outlet1Phase
    input = 'pipe1:out'
    p = ${Pout}
  []
[]

[UserObjects]
  [Tfluid_UO]
    # Creates UserObject needed for transfer
    type = LayeredAverage
    variable = T
    direction = z
    num_layers = ${layers}
    block = 'pipe1'
    execute_on = TIMESTEP_END
  []
  [hfluid_UO]
    # Creates UserObject needed for transfer
    type = LayeredAverage
    variable = htc
    direction = z
    num_layers = ${layers}
    block = 'pipe1'
    execute_on = TIMESTEP_END
  []
[]

[AuxVariables]
  [h_scaled]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 2500.00
    block = 'pipe1'
  []
  [htc]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 2500.00
    block = 'pipe1'
  []
  [Tfluid_trans]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = ${Tin}
    block = 'pipe1'
  []
  [hfluid_trans]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 2500.0
    block = 'pipe1'
  []
[]

[AuxKernels]
  [htc_aux]
    type = ADMaterialRealAux
    property = Hw
    variable = htc
  []
  # HTC scaled by (real geometry surface area)/(model geometry surface area)
  [scale_htc]
    type = ParsedAux
    variable = h_scaled
    expression = '1*htc' # 1 is replaced with the cli_args parameter in its parent app
    coupled_variables =  htc
  []
  [Tfluid_trans]
    type = SpatialUserObjectAux
    variable = Tfluid_trans
    block = 'pipe1'
    user_object = Tfluid_UO
  []
  [hfluid_trans]
    type = SpatialUserObjectAux
    variable = hfluid_trans
    block = 'pipe1'
    user_object = hfluid_UO
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
  scheme = bdf2
  solve_type = 'NEWTON'
  petsc_options_iname = '-pc_type'
  petsc_options_value = 'lu'

  line_search = basic

  nl_rel_tol = 1e-8
  nl_abs_tol = 1e-9
  nl_max_its = 40

  start_time = -2.5e5 # negative start time so we can start running from t = 0
  end_time = 0
  dt = 1e4
[]

[Outputs]
  console = true
  [out]
    type = Exodus
    execute_on = 'initial timestep_end'
    enable = false
  []
  [csv]
    type = CSV
    execute_on = 'initial timestep_end'
    enable = false
  []
[]

[Postprocessors]
  [_HeatRemovalRate] # Used to measure energy balance
    type = ADHeatRateConvection1Phase
    block = pipe1
    P_hf = ${Ph}
    execute_on = 'TIMESTEP_END'
  []
  [mfr]
    type = ADFlowBoundaryFlux1Phase
    boundary = inlet
    equation = mass
    execute_on = 'TIMESTEP_END'
  []
  [rho_in]
    type = ADSideAverageMaterialProperty
    boundary = 'pipe1:in'
    property = rho
    execute_on = 'TIMESTEP_END'
  []
  [rho_out]
    type = ADSideAverageMaterialProperty
    boundary = 'pipe1:out'
    property = rho
    execute_on = 'TIMESTEP_END'
  []
  [T_in]
    type = ADSideAverageMaterialProperty
    boundary = 'pipe1:in'
    property = T
    execute_on = 'TIMESTEP_END'
  []
  [T_out]
    type = ADSideAverageMaterialProperty
    boundary = 'pipe1:out'
    property = T
    execute_on = 'TIMESTEP_END'
  []
  [P_in]
    type = ADSideAverageMaterialProperty
    boundary = 'pipe1:in'
    property = p
    execute_on = 'TIMESTEP_END'
  []
  [P_out]
    type = ADSideAverageMaterialProperty
    boundary = 'pipe1:out'
    property = p
    execute_on = 'TIMESTEP_END'
  []
  [v_in]
    type = ADSideAverageMaterialProperty
    boundary = 'pipe1:in'
    property = vel
    execute_on = 'TIMESTEP_END'
  []
  [v_out]
    type = ADSideAverageMaterialProperty
    boundary = 'pipe1:out'
    property = vel
    execute_on = 'TIMESTEP_END'
  []
  [htc_avg]
    type = ElementAverageValue
    variable = htc
    execute_on = 'TIMESTEP_END'
  []
[]
