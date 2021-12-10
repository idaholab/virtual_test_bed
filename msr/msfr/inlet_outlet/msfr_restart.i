advected_interp_method='upwind'
velocity_interp_method='rc'

# Material properties
rho = 1.  # density [kg / m^3]

# Turbulent properties
#nu_t = 1e-1  # kinematic eddy viscosity / eddy diffusivity for momentum
#nu = 2.46e-6 #ref = http://samofar.eu/wp-content/uploads/2016/11/2016_Lantzos_Ioannis_MSc-thesis.pdf
mu = 0.0005 #https://www.researchgate.net/publication/337161399_Development_of_a_control-oriented_power_plant_simulator_for_the_molten_salt_fast_reactor/fulltext/5dc95c9da6fdcc57503eec39/Development-of-a-control-oriented-power-plant-simulator-for-the-molten-salt-fast-reactor.pdf
# Derived turbulent properties
#mu_t = ${fparse nu_t * rho}  # dynamic eddy viscosity
von_karman_const = 0.41

[Mesh]
  file = msfr_inlet_outlet_out.e
[]

#[Mesh]
#  uniform_refine = 1
#  [fmg]
#    type = FileMeshGenerator
#    file = 'msfr_2d_elbow_copy.msh'
#  []
#[]

[Outputs]
  csv = true
  exodus = true
[]


[Problem]
  kernel_coverage_check = false
  coord_type = 'RZ'
  rz_coord_axis = 'X'
  solve = false
[]

[GlobalParams]
  two_term_boundary_expansion = true
[]

[Variables]
  [v_x]
    type = INSFVVelocityVariable
    #initial_condition = 1e-6
    # initial_from_file_var = v_x
  []
  [v_y]
    type = INSFVVelocityVariable
    #initial_condition = 1e-6
    # initial_from_file_var = v_y
  []
  [pressure]
    type = INSFVPressureVariable
    # initial_from_file_var = pressure
  []
  [lambda]
    family = SCALAR
    order = FIRST
    #initial_condition = 1e-6
    # initial_from_file_var = lambda
  []
[]

[AuxVariables]
  [mixing_len]
    order = CONSTANT
    family = MONOMIAL
    fv = true
    # initial_from_file_var = mixing_len
  []
  [wall_shear_stress]
    order = CONSTANT
    family = MONOMIAL
    fv = true
  []
  [wall_yplus]
    order = CONSTANT
    family = MONOMIAL
    fv = true
  []
  [eddy_viscosity]
    order = CONSTANT
    family = MONOMIAL
    fv = true
    #initial_from_file_var = eddy_viscosity
  []
[]

[FVKernels]
  [mass]
    type = INSFVMassAdvection
    variable = pressure
    velocity_interp_method = ${velocity_interp_method}
    vel = 'velocity'
    pressure = pressure
    u = v_x
    v = v_y
    mu =  ${mu}
    rho = ${rho}
  []
  [mean_zero_pressure]
    type = FVScalarLagrangeMultiplier
    variable = pressure
    lambda = lambda
  []

  [u_time]
    type = INSFVMomentumTimeDerivative
    variable = v_x
    rho = ${rho}
  []
  [u_advection]
    type = INSFVMomentumAdvection
    variable = v_x
    advected_quantity = 'rhou'
    vel = 'velocity'
    advected_interp_method = ${advected_interp_method}
    velocity_interp_method = ${velocity_interp_method}
    pressure = pressure
    u = v_x
    v = v_y
    mu =  ${mu}
    rho = ${rho}
  []
  [u_turbulent_diffusion_rans]
    type = INSFVMixingLengthReynoldsStress
    variable = v_x
    rho = ${rho}
    mixing_length = mixing_len
    momentum_component = 'x'
    u = v_x
    v = v_y
  []
  [u_molecular_diffusion]      #Modify this
    type = FVDiffusion
    variable = v_x
    coeff =  ${mu}
  []
  [u_pressure]
    type = INSFVMomentumPressure
    variable = v_x
    momentum_component = 'x'
    p = pressure
  []

  [v_time]
    type = INSFVMomentumTimeDerivative
    variable = v_x
    rho = ${rho}
  []
  [v_advection]
    type = INSFVMomentumAdvection
    variable = v_y
    advected_quantity = 'rhov'
    vel = 'velocity'
    advected_interp_method = ${advected_interp_method}
    velocity_interp_method = ${velocity_interp_method}
    pressure = pressure
    u = v_x
    v = v_y
    mu =  ${mu}
    rho = ${rho}
  []
  [v_turbulent_diffusion_rans]
    type = INSFVMixingLengthReynoldsStress
    variable = v_y
    rho = ${rho}
    mixing_length = mixing_len
    momentum_component = 'y'
    u = v_x
    v = v_y
  []
  [v_molecular_diffusion]      #Modify this
    type = FVDiffusion
    variable = v_y
    coeff =  ${mu}
  []
  [v_pressure]
    type = INSFVMomentumPressure
    variable = v_y
    momentum_component = 'y'
    p = pressure
  []
[]

[AuxKernels]
  [mixing_len]
    type = WallDistanceMixingLengthAux
    walls = 'Wall'
    variable = mixing_len
    von_karman_const = ${von_karman_const}
    execute_on = 'INITIAL TIMESTEP_END'
  []
  # [wall_shear_stress]
  #   type = WallFunctionWallShearStressAux
  #   variable = wall_shear_stress
  #   walls = 'Wall'
  #   u = v_x
  #   v = v_y
  #   mu =  ${mu}
  #   rho = ${rho}
  # []
  # [wall_yplus]
  #   type = WallFunctionYPlusAux
  #   variable = wall_yplus
  #   walls = 'Wall'
  #   u = v_x
  #   v = v_y
  #   mu =  ${mu}
  #   rho = ${rho}
  # []
  # [turbulent_viscosity]
  #   type = INSFVMixingLengthTurbulentViscosityAux
  #   variable = eddy_viscosity
  #   mixing_length = mixing_len
  #   u = v_x
  #   v = v_y
  # []
[]

[FVBCs]
  #[walls_u]
  #  type = INSFVWallFunctionBC
  #  variable = v_x
  #  boundary = 'Wall'
  #  u = v_x
  #  v = v_y
  #  mu =  ${mu}
  #  rho = ${rho}
  #  momentum_component = x
  #[]
  #[walls_v]
  #  type = INSFVWallFunctionBC
  #  variable = v_y
  #  boundary = 'Wall'
  #  u = v_x
  #  v = v_y
  #  mu =  ${mu}
  #  rho = ${rho}
  #  momentum_component = y
  #[]
  [no-slip-wall-u]
    type = INSFVNoSlipWallBC
    boundary = 'Wall'
    variable = v_x
    function = 0
  []
  [no-slip-wall-v]
    type = INSFVNoSlipWallBC
    boundary = 'Wall'
    variable = v_y
    function = 0
  []

  [symmetry_u]
    type = INSFVSymmetryVelocityBC
    boundary = 'symmetry'
    variable = v_x
    u = v_x
    v = v_y
    momentum_component = 'x'
    mu = 'mu'
  []
  [symmetry_v]
    type = INSFVSymmetryVelocityBC
    boundary = 'symmetry'
    variable = v_y
    u = v_x
    v = v_y
    momentum_component = 'y'
    mu = 'mu'
  []
  [symmetry_pressure]
    type = INSFVSymmetryPressureBC
    boundary = 'symmetry'
    variable = pressure
  []

  [inlet_u]
    type = INSFVInletVelocityBC
    variable = v_x
    boundary = 'inlet'
    function = 'Inlet_Function'
  []
  [inlet_v]
    type = INSFVInletVelocityBC
    variable = v_y
    boundary = 'inlet'
    function = '0'
  []

  [outlet_p]
    type = INSFVOutletPressureBC
    boundary = 'outlet'
    variable = pressure
    function = '-0'
  []
[]

[Functions]
  [Inlet_Function]
    type = ParsedFunction
    value = '-1.72845874696*(1-(y-2.0525)*(y-2.0525)/0.01380625)'
  []
[]

[Materials]
  [mu]
   type = ADGenericFunctionMaterial      #defines mu artificially for numerical convergence
   prop_names =  'mu'                    #it converges to the real mu eventually.
   prop_values = ${mu}
  []
  # [total_viscosity]
  #   type = INSADMixingLengthTurbulentViscosityMaterial
  #   u = 'v_x'                             #computes total viscosity = mu_t + mu
  #   v = 'v_y'                             #property is called total_viscosity
  #   mixing_length = mixing_len
  #   mu =  ${mu}
  #   rho = ${rho}
  # []
  [ins_fv]
    type = INSFVMaterial
    u = 'v_x'
    v = 'v_y'
    pressure = 'pressure'
    rho = ${rho}
  []
[]

[Executioner]
  type = Transient
  start_time = 0.0
  end_time = 0.01
  dt = 0.001
  solve_type = 'Newton'
  petsc_options_iname = '-pc_type -ksp_gmres_reset'
  petsc_options_value = 'lu 50'
  line_search = 'none'
  nl_rel_tol = 1e-12
  nl_abs_tol = 1e-10
  nl_max_its = 15
  l_max_its = 30
[]

[Postprocessors]
  [max_v]
    type = ElementExtremeValue
    variable = v_x
    value_type = max
  []
[]
