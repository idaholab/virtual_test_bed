advected_interp_method='upwind'
velocity_interp_method='rc'

# Material properties
rho = 4284  # density [kg / m^3]  (@1000K)
mu = 0.0166 #https://www.researchgate.net/publication/337161399_Development_of_a_control-oriented_power_plant_simulator_for_the_molten_salt_fast_reactor/fulltext/5dc95c9da6fdcc57503eec39/Development-of-a-control-oriented-power-plant-simulator-for-the-molten-salt-fast-reactor.pdf
# Derived turbulent properties
von_karman_const = 0.41

# Mass flow rate tuning
friction = 4.0e3  # [kg / m^4]
pump_force = -20000. # [N / m^3]

[Mesh]
  uniform_refine = 1
  [fmg]
    type = FileMeshGenerator
    file = 'msfr_rz_mesh_finer.e'
  []
  #[restart]
  #  type = FileMeshGenerator
  #  #file = msfr_SS_wallfunctions.e
  #  file = msfr_ns_other.e
  #  use_for_exodus_restart = true
  #[]
  [min_radius]
    type = ParsedGenerateSideset
    combinatorial_geometry = 'abs(y-0.) < 1e-10 & x < 1.8'
    input = fmg
    new_sideset_name = min_core_radius
    normal = '0 1 0'
  []
[]

[Outputs]
  exodus = true
  csv = true
[]

[Problem]
  kernel_coverage_check = false
  coord_type = 'RZ'
  rz_coord_axis = Y
[]

[GlobalParams]
  two_term_boundary_expansion = true
[]

[Variables]
  [v_x]
    type = INSFVVelocityVariable
    initial_condition = 1e-6
    block = 'fuel pump hx'
    #initial_from_file_var = v_x
  []
  [v_y]
    type = INSFVVelocityVariable
    initial_condition = 1e-6
    block = 'fuel pump hx'
    #initial_from_file_var = v_y
  []
  [pressure]
    type = INSFVPressureVariable
    block = 'fuel pump hx'
    scaling = 100
    #initial_from_file_var = pressure
  []
  [lambda]
    family = SCALAR
    order = FIRST
    initial_condition = 1e-6
    block = 'fuel pump hx'
    #initial_from_file_var = lambda
  []
[]
[AuxVariables]
  [mixing_len]
    order = CONSTANT
    family = MONOMIAL
    fv = true
    #initial_from_file_var = mixing_len
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
  [power_density]
    order = CONSTANT
    family = MONOMIAL
    fv = true
  []
  [fission_source]
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
    mu = 'mu'
    rho = ${rho}
    block = 'fuel pump hx'
  []
  [mean_zero_pressure]
    type = FVScalarLagrangeMultiplier
    variable = pressure
    lambda = lambda
    block = 'fuel pump hx'
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
    mu = 'mu'
    rho = ${rho}
    block = 'fuel pump hx'
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
    coeff = 'mu'
    block = 'fuel pump hx'
  []
  [u_pressure]
    type = INSFVMomentumPressure
    variable = v_x
    momentum_component = 'x'
    p = pressure
    block = 'fuel pump hx'
  []

  [v_time]
    type = INSFVMomentumTimeDerivative
    variable = v_y
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
    mu = 'mu'
    rho = ${rho}
    block = 'fuel pump hx'
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
    coeff = 'mu'
    block = 'fuel pump hx'
  []
  [v_pressure]
    type = INSFVMomentumPressure
    variable = v_y
    momentum_component = 'y'
    p = pressure
    block = 'fuel pump hx'
  []

  [pump]
    type = FVBodyForce
    variable = v_y
    value = ${pump_force}
    block = 'pump'
  []

  [friction_hx_x]
    type = NSFVMomentumFriction
    variable = v_x
    quadratic_coef_name = 'friction_coef'
    block = 'hx'
  []
  [friction_hx_y]
    type = NSFVMomentumFriction
    variable = v_y
    quadratic_coef_name = 'friction_coef'
    block = 'hx'
  []
[]

[AuxKernels]
  [mixing_len]
    type = WallDistanceMixingLengthAux
    walls = 'shield_wall reflector_wall'
    variable = mixing_len
    execute_on = 'initial'
    block = 'fuel'
    von_karman_const = ${von_karman_const}
    delta = 0.1
  []
  [wall_shear_stress]
    type = WallFunctionWallShearStressAux
    variable = wall_shear_stress
    walls = 'shield_wall reflector_wall'
    block = 'fuel'
    u = v_x
    v = v_y
    mu = 'mu'
    rho = ${rho}
  []
  [wall_yplus]
    type = WallFunctionYPlusAux
    variable = wall_yplus
    walls = 'shield_wall reflector_wall'
    block = 'fuel'
    u = v_x
    v = v_y
    mu = 'mu'
    rho = ${rho}
  []
  [turbulent_viscosity]
    type = INSFVMixingLengthTurbulentViscosityAux
    variable = eddy_viscosity
    mixing_length = mixing_len
    u = v_x
    v = v_y
    block = 'fuel pump hx'
  []
[]

[FVBCs]
  [walls_u]
    type = INSFVWallFunctionBC    #rethink if we should put noslip just for the hx and pump.For this I need
    variable = v_x                #an intersection between shield_walls, reflector_walls and hx and pump.
    boundary = 'shield_wall reflector_wall'
    u = v_x
    v = v_y
    mu = ${mu}
    rho = ${rho}
    momentum_component = x
  []
  [walls_v]
    type = INSFVWallFunctionBC
    variable = v_y
    boundary = 'shield_wall reflector_wall'
    u = v_x
    v = v_y
    mu = ${mu}
    rho = ${rho}
    momentum_component = y
  []

  [symmetry_u]
    type = INSFVSymmetryVelocityBC
    boundary = 'fluid_symmetry'
    variable = v_x
    u = v_x
    v = v_y
    momentum_component = 'x'
    mu = total_viscosity
  []
  [symmetry_v]
    type = INSFVSymmetryVelocityBC
    boundary = 'fluid_symmetry'
    variable = v_y
    u = v_x
    v = v_y
    momentum_component = 'y'
    mu = total_viscosity
  []
  [symmetry_pressure]
    type = INSFVSymmetryPressureBC
    boundary = 'fluid_symmetry'
    variable = pressure
  []
[]

[Functions]
  [artificial_mu_func]
    type = ParsedFunction
    value = mu*(100*exp(-3*t)+1)
    #value = mu*(1)
    vars = 'mu'
    vals = ${mu}
  []
[]

[Materials]
  [mu]
    type = ADGenericFunctionMaterial      #defines mu artificially for numerical convergence
    prop_names = 'mu'                     #it converges to the real mu eventually.
    prop_values = 'artificial_mu_func'
  []
  [total_viscosity]
    type = INSADMixingLengthTurbulentViscosityMaterial
    u = 'v_x'                             #computes total viscosity = mu_t + mu
    v = 'v_y'                             #property is called total_viscosity
    mixing_length = mixing_len
    mu = 'mu'
    rho = ${rho}
    block = 'fuel pump hx'
  []
  [ins_fv]
    type = INSFVMaterial
    u = 'v_x'
    v = 'v_y'
    pressure = 'pressure'
    rho = ${rho}
    block = 'fuel pump hx'
  []
  [not_used]
    type = ADGenericConstantMaterial
    prop_names = 'not_used'
    prop_values = 0
    block = 'shield reflector'
  []
  [friction]
    type = ADGenericConstantMaterial
    prop_names = 'friction_coef'
    prop_values = ${friction}
    block = 'hx'
  []
[]

[Preconditioning]
  [./SMP]
    type = SMP
    full = true
    solve_type = 'NEWTON'
  [../]
[]

[Executioner]
  type = Transient
  start_time = 0.0
  end_time = 20.
  dt = 0.1
  #automatic_scaling = true
  #solve_type = 'PJFNK'
  petsc_options_iname = '-pc_type -ksp_gmres_reset'
  petsc_options_value = 'lu 50'
  line_search = 'none'
  nl_rel_tol = 1e-12
  nl_abs_tol = 2e-8
  nl_max_its = 22
  l_max_its = 50
[]

[Postprocessors]
  [max_v]
    type = ElementExtremeValue
    variable = v_x
    value_type = max
    block = 'fuel pump hx'
  []
  [mu_value]
    type = FunctionValuePostprocessor
    function = artificial_mu_func
  []
  [mdot]
    type = InternalVolumetricFlowRate
    boundary = 'min_core_radius'
    vel_x = v_x
    vel_y = v_y
    advected_interp_method = ${advected_interp_method}
    advected_mat_prop = ${rho}
  []
[]
