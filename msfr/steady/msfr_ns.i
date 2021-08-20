################################################################################
## Molten Salt Fast Reactor - Euratom EVOL + Rosatom MARS Design              ##
## Pronghorn Sub-Application input file                                       ##
## Relaxation towards Steady state 3D thermal hydraulics model                ##
################################################################################

advected_interp_method='upwind'
velocity_interp_method='rc'

# Material properties
rho = 4284  # density [kg / m^3]  (@1000K)
cp = 1594  # specific heat capacity [J / kg / K]
drho_dT = 0.882  # derivative of density w.r.t. temperature [kg / m^3 / K]
mu = 0.0166 #https://www.researchgate.net/publication/337161399_Development_of_a_control-oriented_power_plant_simulator_for_the_molten_salt_fast_reactor/fulltext/5dc95c9da6fdcc57503eec39/Development-of-a-control-oriented-power-plant-simulator-for-the-molten-salt-fast-reactor.pdf
k = 1.7

# Derived turbulent properties
#von_karman_const = 0.41
Pr_t = 1  # turbulent Prandtl number
Sc_t = 1  # turbulent Schmidt number

# Derived material properties
alpha = ${fparse drho_dT / rho}  # thermal expansion coefficient

# Mass flow rate tuning
friction = 4.0e3  # [kg / m^4]
pump_force = -20000. # [N / m^3]

# Delayed neutron precursor parameters. Lambda values are decay constants in
# [1 / s]. Beta values are production fractions.
lambda1 = 0.0133104
lambda2 = 0.0305427
lambda3 = 0.115179
lambda4 = 0.301152
lambda5 = 0.879376
lambda6 = 2.91303
beta1 = 8.42817e-05
beta2 = 0.000684616
beta3 = 0.000479796
beta4 = 0.00103883
beta5 = 0.000549185
beta6 = 0.000184087

[Mesh]
  [restart]
    type = FileMeshGenerator
    file = msfr_ns_initial_out.e
    use_for_exodus_restart = true
  []
  [min_radius]
    type = ParsedGenerateSideset
    combinatorial_geometry = 'abs(y-0.) < 1e-10 & x < 1.8'
    input = restart
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
    block = 'fuel pump hx'
    initial_from_file_var = v_x
  []
  [v_y]
    type = INSFVVelocityVariable
    block = 'fuel pump hx'
    initial_from_file_var = v_y
  []
  [pressure]
    type = INSFVPressureVariable
    block = 'fuel pump hx'
    scaling = 100
    initial_from_file_var = pressure
  []
  [lambda]
    family = SCALAR
    order = FIRST
    block = 'fuel pump hx'
    initial_from_file_var = lambda
  []
  [T]
    order = CONSTANT
    family = MONOMIAL
    fv = true
    block = 'fuel pump hx'
    scaling = 100
  []
  [c1]
    order = CONSTANT
    family = MONOMIAL
    fv = true
    block = 'fuel pump hx'
    scaling = 1e4
  []
  [c2]
    order = CONSTANT
    family = MONOMIAL
    fv = true
    block = 'fuel pump hx'
    scaling = 1e4
  []
  [c3]
    order = CONSTANT
    family = MONOMIAL
    fv = true
    block = 'fuel pump hx'
    scaling = 1e4
  []
  [c4]
    order = CONSTANT
    family = MONOMIAL
    fv = true
    block = 'fuel pump hx'
    scaling = 1e5
  []
  [c5]
    order = CONSTANT
    family = MONOMIAL
    fv = true
    block = 'fuel pump hx'
    scaling = 1e5
  []
  [c6]
    order = CONSTANT
    family = MONOMIAL
    fv = true
    scaling = 1e6
    block = 'fuel pump hx'
  []
[]

[AuxVariables]
  [mixing_len]
    order = CONSTANT
    family = MONOMIAL
    fv = true
    initial_from_file_var = mixing_len
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
  [u_molecular_diffusion]
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
  [v_molecular_diffusion]
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
  [v_buoyancy]
    type = INSFVMomentumBoussinesq
    variable = v_y
    temperature = T
    gravity = '0 -9.81 0'
    rho = ${rho}
    ref_temperature = 1000
    momentum_component = 'y'
    block = 'fuel'
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

  [heat_time]
    type = INSFVEnergyTimeDerivative
    variable = T
    rho = '1'
    cp_name = 'cp_unitary'
  []
  [heat_advection]
    type = INSFVScalarFieldAdvection
    variable = T
    vel = 'velocity'
    velocity_interp_method = ${velocity_interp_method}
    advected_interp_method = ${advected_interp_method}
    pressure = pressure
    u = v_x
    v = v_y
    mu = 'mu'
    rho = ${rho}
    block = 'fuel pump hx'
  []
  [heat_diffusion]
    type = FVDiffusion
    coeff = ${fparse k / rho / cp}
    variable = T
    block = 'fuel pump hx'
  []
  [heat_turb_diffusion]
    type = INSFVMixingLengthScalarDiffusion
    schmidt_number = ${Pr_t}
    variable = T
    block = 'fuel pump hx'
    u = v_x
    v = v_y
    mixing_length = mixing_len
  []
  [heat_src]
    type = FVCoupledForce
    variable = T
    v = power_density
    coef = ${fparse 1 / rho / cp}
    block = 'fuel pump hx'
  []
  [heat_sink]
    type = NSFVEnergyAmbientConvection
    variable = T
    # Compute the coefficient as 600 m^2 / m^3 surface area density times a heat
    # transfer coefficient of 20 kW / m^2 / K
    alpha = ${fparse 600 * 20e3 / rho / cp}
    block = 'hx'
    T_ambient = 873.15
  []

  [c1_advection]
    type = INSFVScalarFieldAdvection
    variable = c1
    vel = 'velocity'
    velocity_interp_method = ${velocity_interp_method}
    advected_interp_method = ${advected_interp_method}
    pressure = pressure
    u = v_x
    v = v_y
    mu = 'mu'
    rho = ${rho}
    block = 'fuel pump hx'
  []
  [c2_advection]
    type = INSFVScalarFieldAdvection
    variable = c2
    vel = 'velocity'
    velocity_interp_method = ${velocity_interp_method}
    advected_interp_method = ${advected_interp_method}
    pressure = pressure
    u = v_x
    v = v_y
    mu = 'mu'
    rho = ${rho}
    block = 'fuel pump hx'
  []
  [c3_advection]
    type = INSFVScalarFieldAdvection
    variable = c3
    vel = 'velocity'
    velocity_interp_method = ${velocity_interp_method}
    advected_interp_method = ${advected_interp_method}
    pressure = pressure
    u = v_x
    v = v_y
    mu = 'mu'
    rho = ${rho}
    block = 'fuel pump hx'
  []
  [c4_advection]
    type = INSFVScalarFieldAdvection
    variable = c4
    vel = 'velocity'
    velocity_interp_method = ${velocity_interp_method}
    advected_interp_method = ${advected_interp_method}
    pressure = pressure
    u = v_x
    v = v_y
    mu = 'mu'
    rho = ${rho}
    block = 'fuel pump hx'
  []
  [c5_advection]
    type = INSFVScalarFieldAdvection
    variable = c5
    vel = 'velocity'
    velocity_interp_method = ${velocity_interp_method}
    advected_interp_method = ${advected_interp_method}
    pressure = pressure
    u = v_x
    v = v_y
    mu = 'mu'
    rho = ${rho}
    block = 'fuel pump hx'
  []
  [c6_advection]
    type = INSFVScalarFieldAdvection
    variable = c6
    vel = 'velocity'
    velocity_interp_method = ${velocity_interp_method}
    advected_interp_method = ${advected_interp_method}
    pressure = pressure
    u = v_x
    v = v_y
    mu = 'mu'
    rho = ${rho}
    block = 'fuel pump hx'
  []
  [c1_turb_diffusion]
    type = INSFVMixingLengthScalarDiffusion
    schmidt_number = ${Sc_t}
    variable = c1
    block = 'fuel pump hx'
    u = v_x
    v = v_y
    mixing_length = mixing_len
  []
  [c2_turb_diffusion]
    type = INSFVMixingLengthScalarDiffusion
    schmidt_number = ${Sc_t}
    variable = c2
    block = 'fuel pump hx'
    u = v_x
    v = v_y
    mixing_length = mixing_len
  []
  [c3_turb_diffusion]
    type = INSFVMixingLengthScalarDiffusion
    schmidt_number = ${Sc_t}
    variable = c3
    block = 'fuel pump hx'
    u = v_x
    v = v_y
    mixing_length = mixing_len
  []
  [c4_turb_diffusion]
    type = INSFVMixingLengthScalarDiffusion
    schmidt_number = ${Sc_t}
    variable = c4
    block = 'fuel pump hx'
    u = v_x
    v = v_y
    mixing_length = mixing_len
  []
  [c5_turb_diffusion]
    type = INSFVMixingLengthScalarDiffusion
    schmidt_number = ${Sc_t}
    variable = c5
    block = 'fuel pump hx'
    u = v_x
    v = v_y
    mixing_length = mixing_len
  []
  [c6_turb_diffusion]
    type = INSFVMixingLengthScalarDiffusion
    schmidt_number = ${Sc_t}
    variable = c6
    block = 'fuel pump hx'
    u = v_x
    v = v_y
    mixing_length = mixing_len
  []
  [c1_src]
    type = FVCoupledForce
    variable = c1
    v = fission_source
    coef = ${beta1}
    block = 'fuel pump hx'
  []
  [c2_src]
    type = FVCoupledForce
    variable = c2
    v = fission_source
    coef = ${beta2}
    block = 'fuel pump hx'
  []
  [c3_src]
    type = FVCoupledForce
    variable = c3
    v = fission_source
    coef = ${beta3}
    block = 'fuel pump hx'
  []
  [c4_src]
    type = FVCoupledForce
    variable = c4
    v = fission_source
    coef = ${beta4}
    block = 'fuel pump hx'
  []
  [c5_src]
    type = FVCoupledForce
    variable = c5
    v = fission_source
    coef = ${beta5}
    block = 'fuel pump hx'
  []
  [c6_src]
    type = FVCoupledForce
    variable = c6
    v = fission_source
    coef = ${beta6}
    block = 'fuel pump hx'
  []
  [c1_decay]
    type = FVReaction
    variable = c1
    rate = ${lambda1}
    block = 'fuel pump hx'
  []
  [c2_decay]
    type = FVReaction
    variable = c2
    rate = ${lambda2}
    block = 'fuel pump hx'
  []
  [c3_decay]
    type = FVReaction
    variable = c3
    rate = ${lambda3}
    block = 'fuel pump hx'
  []
  [c4_decay]
    type = FVReaction
    variable = c4
    rate = ${lambda4}
    block = 'fuel pump hx'
  []
  [c5_decay]
    type = FVReaction
    variable = c5
    rate = ${lambda5}
    block = 'fuel pump hx'
  []
  [c6_decay]
    type = FVReaction
    variable = c6
    rate = ${lambda6}
    block = 'fuel pump hx'
  []
[]

[AuxKernels]
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
    type = INSFVWallFunctionBC
    variable = v_x
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
    type = PiecewiseLinear
    x = '1 2 3'
    y = '${mu} ${mu} ${mu}'
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
  [alpha]
    type = ADGenericConstantMaterial
    prop_names = 'alpha k cp  cp_unitary'  #cp_unitary defined for time kernel, to set rho_cp = 1
    prop_values = '${alpha} ${k} ${cp} 1'
    block = 'fuel pump hx'
  []
  [ins_fv]
    type = INSFVMaterial
    u = 'v_x'
    v = 'v_y'
    pressure = 'pressure'
    temperature = 'T'
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
  dt = 1.0
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
  [mdot]
    type = InternalVolumetricFlowRate
    boundary = 'min_core_radius'
    vel_x = v_x
    vel_y = v_y
    advected_interp_method = ${advected_interp_method}
    advected_mat_prop = ${rho}
  []
  [max_hx_T]
    type = ElementExtremeValue
    variable = T
    value_type = max
    block = 'hx'
    outputs = none
  []
  [min_hx_T]
    type = ElementExtremeValue
    variable = T
    value_type = min
    block = 'hx'
    outputs = none
  []
  [max_pump_T]
    type = ElementExtremeValue
    variable = T
    value_type = max
    block = 'pump'
    outputs = none
  []
  [dT]
    type = DifferencePostprocessor
    value1 = max_pump_T
    value2 = min_hx_T
  []
[]
