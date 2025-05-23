mu = 0.001 # viscosity [Pa*s]
rho = 986.737 # density [kg/m^3]
von_karman_const = 0.41

advected_interp_method = 'upwind'
velocity_interp_method = 'rc'

[Mesh]
  [fmg]
    type = FileMeshGenerator
    file = '0deg_cubit_coarse_mesh.e'
  []
[]

[Problem]
  fv_bcs_integrity_check = false
[]

[GlobalParams]
  # retain behavior at time of test creation
  two_term_boundary_expansion = false
  rhie_chow_user_object = 'rc'
[]

[UserObjects]
  [rc]
    type = INSFVRhieChowInterpolator
    u = vel_x
    v = vel_y
    w = vel_z
    pressure = pressure
  []
[]

[Variables]
  [vel_x]
    type = INSFVVelocityVariable
    initial_condition = 0.1
  []
  [vel_y]
    type = INSFVVelocityVariable
    initial_condition = 0
  []
  [vel_z]
    type = INSFVVelocityVariable
    initial_condition = 0
  []
  [pressure]
    type = INSFVPressureVariable
  []
[]

[AuxVariables]
  [mixing_length]
    order = CONSTANT
    family = MONOMIAL
    fv = true
  []
[]

[FVKernels]
  [mass]
    type = INSFVMassAdvection
    variable = pressure
    advected_interp_method = ${advected_interp_method}
    velocity_interp_method = ${velocity_interp_method}
    rho = ${rho}
  []

  [u_time]
    type = INSFVMomentumTimeDerivative
    variable = vel_x
    rho = ${rho}
    momentum_component = 'x'
  []
  [u_advection]
    type = INSFVMomentumAdvection
    variable = vel_x
    advected_interp_method = ${advected_interp_method}
    velocity_interp_method = ${velocity_interp_method}
    rho = ${rho}
    momentum_component = 'x'
  []
  [u_viscosity]
    type = INSFVMomentumDiffusion
    variable = vel_x
    mu = ${mu}
    momentum_component = 'x'
  []
  [u_viscosity_rans]
    type = INSFVMixingLengthReynoldsStress
    variable = vel_x
    rho = ${rho}
    mixing_length = mixing_length
    momentum_component = 'x'
    u = vel_x
    v = vel_y
    w = vel_z
  []
  [u_pressure]
    type = INSFVMomentumPressure
    variable = vel_x
    momentum_component = 'x'
    pressure = pressure
  []
  
  [v_time]
    type = INSFVMomentumTimeDerivative
    variable = vel_y
    rho = ${rho}
    momentum_component = 'y'
  []
  [v_advection]
    type = INSFVMomentumAdvection
    variable = vel_y
    advected_interp_method = ${advected_interp_method}
    velocity_interp_method = ${velocity_interp_method}
    rho = ${rho}
    momentum_component = 'y'
  []
  [v_viscosity]
    type = INSFVMomentumDiffusion
    variable = vel_y
    mu = ${mu}
    momentum_component = 'y'
  []
  [v_viscosity_rans]
    type = INSFVMixingLengthReynoldsStress
    variable = vel_y
    rho = ${rho}
    mixing_length = mixing_length
    momentum_component = 'y'
    u = vel_x
    v = vel_y
    w = vel_z
  []
  [v_pressure]
    type = INSFVMomentumPressure
    variable = vel_y
    momentum_component = 'y'
    pressure = pressure
  []

  [w_time]
    type = INSFVMomentumTimeDerivative
    variable = vel_z
    rho = ${rho}
    momentum_component = 'z'
  []
  [w_advection]
    type = INSFVMomentumAdvection
    variable = vel_z
    advected_interp_method = ${advected_interp_method}
    velocity_interp_method = ${velocity_interp_method}
    rho = ${rho}
    momentum_component = 'z'
  []
  [w_viscosity]
    type = INSFVMomentumDiffusion
    variable = vel_z
    mu = ${mu}
    momentum_component = 'z'
  []
  [w_viscosity_rans]
    type = INSFVMixingLengthReynoldsStress
    variable = vel_z
    rho = ${rho}
    mixing_length = mixing_length
    momentum_component = 'z'
    u = vel_x
    v = vel_y
    w = vel_z
  []
  [w_pressure]
    type = INSFVMomentumPressure
    variable = vel_z
    momentum_component = 'z'
    pressure = pressure
  []
[]

[AuxKernels]
  [mixing_length]
    type = WallDistanceMixingLengthAux
    walls = 'Walls Valve'
    variable = mixing_length
    execute_on = 'initial'
    von_karman_const = ${von_karman_const}
    delta = 0.005
  []
[]

[FVBCs]
  [inlet-u]
    type = INSFVInletVelocityBC
    boundary = Inlet
    variable = vel_x
    function = 2.051481762 #m/s
  []
  [inlet-v]
    type = INSFVInletVelocityBC
    boundary = Inlet
    variable = vel_y
    function = 0
  []
  [inlet-w]
    type = INSFVInletVelocityBC
    boundary = Inlet
    variable = vel_z
    function = 0
  []

  [walls-u]
    type = INSFVNoSlipWallBC
    boundary = Walls
    variable = vel_x
    function = 0
  []
  [walls-v]
    type = INSFVNoSlipWallBC
    boundary = Walls
    variable = vel_y
    function = 0
  []
  [walls-w]
    type = INSFVNoSlipWallBC
    boundary = Walls
    variable = vel_z
    function = 0
  []
  [outlet_p]
    type = INSFVOutletPressureBC
    boundary = Outlet
    variable = pressure
    function = '0'
  []
  [valve-u]
    type = INSFVNoSlipWallBC
    boundary = Valve
    variable = vel_x
    function = 0
  []
  [valve-v]
    type = INSFVNoSlipWallBC
    boundary = Valve
    variable = vel_y
    function = 0
  []
  [valve-w]
    type = INSFVNoSlipWallBC
    boundary = Valve
    variable = vel_z
    function = 0
  []
  [symmetry_u]
    type = INSFVSymmetryVelocityBC
    variable = vel_x
    boundary = Symmetry
    momentum_component = 'x'
    mu = ${mu}
    u = vel_x
    v = vel_y
    w = vel_z
  []
  [symmetry_v]
    type = INSFVSymmetryVelocityBC
    variable = vel_y
    boundary = Symmetry
    momentum_component = 'y'
    mu = ${mu}
    u = vel_x
    v = vel_y
    w = vel_z
  []
  [symmetry_w]
    type = INSFVSymmetryVelocityBC
    variable = vel_y
    boundary = Symmetry
    momentum_component = 'y'
    mu = ${mu}
    u = vel_x
    v = vel_y
    w = vel_z
  []
  [symmetry_pressure]
    type = INSFVSymmetryPressureBC
    boundary = Symmetry
    variable = pressure
  []
[]

[Functions]
  [rampdown_mu_func]
    type = ParsedFunction
    expression = 'if(t<= 5, mu*(100*exp(-3*t)+1), 0.000463*exp(-3*(t-5))+0.000537)'
    symbol_names = 'mu'
    symbol_values = ${mu}
  []
[]

[Materials]
  [mu]
    type = ADGenericFunctorMaterial      #defines mu artificially for numerical convergence
    prop_names = 'mu rho'                     #it converges to the real mu eventually.
    prop_values = 'rampdown_mu_func ${rho}'
  []
  [total_viscosity]
    type = MixingLengthTurbulentViscosityMaterial
    u = 'vel_x' #computes total viscosity = mu_t + mu
    v = 'vel_y' #property is called total_viscosity
    w = 'vel_z'
    mixing_length = mixing_length
    mu = ${mu}
    rho = ${rho}
  []
[]

[Executioner]
  type = Transient

  # Time-stepping parameters
  start_time = 0.0
  end_time = 8
  
  [TimeStepper]
    type = IterationAdaptiveDT
    optimal_iterations = 10
    dt = 0.1
    timestep_limiting_postprocessor = 'dt_limit'
  []

  # Time integration scheme
  scheme = 'implicit-euler'

  # Solver Parameters
  solve_type = 'NEWTON'
  petsc_options_iname = '-pc_type -pc_factor_shift_type -snes_max_it -l_max_it -max_nl_its'
  petsc_options_value = 'lu       NONZERO                25	      50       20        '
  line_search = 'none'
  nl_rel_tol = 1e-6
  nl_abs_tol = 1e-10
  automatic_scaling = true
  scaling_group_variables = 'vel_x vel_y vel_z; pressure'
[]

[Outputs]
  exodus = true
  csv = true
  [dof]
    type = DOFMap
    execute_on = 'initial'
  []
[]

[Postprocessors]
  [mu_value]
    type = FunctionValuePostprocessor
    function = rampdown_mu_func
  []
  [dt_limit]
    type = Receiver
    default = 1
  []
[]
