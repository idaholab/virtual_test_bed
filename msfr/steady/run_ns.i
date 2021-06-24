################################################################################
## Molten Salt Fast Reactor - Euratom EVOL + Rosatom MARS Design              ##
## Pronghorn Sub-Application input file                                       ##
## Steady state 3D thermal hydraulics model                                   ##
## Relaxation transient for laminar flow, addition of turbulence is WIP       ##
################################################################################

advected_interp_method='upwind'
velocity_interp_method='rc'

# Material properties
rho = 4125  # density [kg / m^3]
cp = 1594  # specific heat capacity [J / kg / K]
drho_dT = 0.882  # derivative of density w.r.t. temperature [kg / m^3 / K]

# Derived material properties
alpha = ${fparse drho_dT / rho}  # thermal expansion coefficient

# Turbulent properties
nu_t = 1e-1  # kinematic eddy viscosity / eddy diffusivity for momentum
Pr_t = 1  # turbulent Prandtl number
Sc_t = 1  # turbulent Schmidt number

# Derived turbulent properties
mu_t = ${fparse nu_t * rho}  # dynamic eddy viscosity
epsilon_q = ${fparse nu_t / Pr_t}  # eddy diffusivity for heat
epsilon_c = ${fparse nu_t / Sc_t}  # eddy diffusivity for precursors

# Mass flow rate tuning
friction = 5.e3  # [kg / m^4]
pump_force = -71401.4  # [N / m^3]

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
  uniform_refine = 1
  [fmg]
    type = FileMeshGenerator
    file = '../mesh/msfr_rz_mesh.e'
  []
  [inactive]
    type = BlockDeletionGenerator
    input = fmg
    block = 'shield reflector'
  []
[]

[Outputs]
  exodus = true
  csv = true
[]

[Problem]
  coord_type = 'RZ'
[]

[GlobalParams]
  two_term_boundary_expansion = true
[]

[Variables]
  [v_x]
    type = INSFVVelocityVariable
    initial_condition = 1e-6
    block = 'fuel pump hx'
  []
  [v_y]
    type = INSFVVelocityVariable
    initial_condition = 1e-6
    block = 'fuel pump hx'
  []
  [pressure]
    type = INSFVPressureVariable
    block = 'fuel pump hx'
    scaling = 100
  []
  [lambda]
    family = SCALAR
    order = FIRST
    initial_condition = 1e-6
    block = 'fuel pump hx'
  []
  [T]
    order = CONSTANT
    family = MONOMIAL
    fv = true
    initial_condition = 650
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
    mu = 'mu_t'
    rho = ${rho}
    block = 'fuel pump hx'
  []
  [mean_zero_pressure]
    type = FVScalarLagrangeMultiplier
    variable = pressure
    lambda = lambda
    block = 'fuel pump hx'
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
    mu = 'mu_t'
    rho = ${rho}
    block = 'fuel pump hx'
  []
  [u_turb_viscosity]
    type = FVDiffusion
    variable = v_x
    coeff = 'mu_t'
    block = 'fuel pump hx'
  []
  [u_pressure]
    type = INSFVMomentumPressure
    variable = v_x
    momentum_component = 'x'
    p = pressure
    block = 'fuel pump hx'
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
    mu = 'mu_t'
    rho = ${rho}
    block = 'fuel pump hx'
  []
  [v_turb_viscosity]
    type = FVDiffusion
    variable = v_y
    coeff = 'mu_t'
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
    ref_temperature = 700
    momentum_component = 'y'
    block = 'fuel pump hx'
  []
  [v_gravity]
    type = FVBodyForce
    variable = v_y
    value = ${fparse -9.81 * rho}
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

  [heat_advection]
    type = INSFVScalarFieldAdvection
    variable = T
    vel = 'velocity'
    velocity_interp_method = ${velocity_interp_method}
    advected_interp_method = ${advected_interp_method}
    pressure = pressure
    u = v_x
    v = v_y
    mu = 'mu_t'
    rho = ${rho}
    block = 'fuel pump hx'
  []
  [heat_turb_diffusion]
    type = FVDiffusion
    coeff = ${epsilon_q}
    variable = T
    block = 'fuel pump hx'
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
    mu = 'mu_t'
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
    mu = 'mu_t'
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
    mu = 'mu_t'
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
    mu = 'mu_t'
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
    mu = 'mu_t'
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
    mu = 'mu_t'
    rho = ${rho}
    block = 'fuel pump hx'
  []
  [c1_turb_diffusion]
    type = FVDiffusion
    coeff = ${epsilon_c}
    variable = c1
    block = 'fuel pump hx'
  []
  [c2_turb_diffusion]
    type = FVDiffusion
    coeff = ${epsilon_c}
    variable = c2
    block = 'fuel pump hx'
  []
  [c3_turb_diffusion]
    type = FVDiffusion
    coeff = ${epsilon_c}
    variable = c3
    block = 'fuel pump hx'
  []
  [c4_turb_diffusion]
    type = FVDiffusion
    coeff = ${epsilon_c}
    variable = c4
    block = 'fuel pump hx'
  []
  [c5_turb_diffusion]
    type = FVDiffusion
    coeff = ${epsilon_c}
    variable = c5
    block = 'fuel pump hx'
  []
  [c6_turb_diffusion]
    type = FVDiffusion
    coeff = ${epsilon_c}
    variable = c6
    block = 'fuel pump hx'
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
[]

[FVBCs]
  [walls_u]
    type = INSFVNaturalFreeSlipBC
    boundary = 'shield_wall reflector_wall'
    variable = v_x
  []
  [walls_v]
    type = INSFVNaturalFreeSlipBC
    boundary = 'shield_wall reflector_wall'
    variable = v_y
  []
  [symmetry_u]
    type = INSFVSymmetryVelocityBC
    boundary = 'fluid_symmetry'
    variable = v_x
    u = v_x
    v = v_y
    momentum_component = 'x'
    mu = 'mu_t'
  []
  [symmetry_v]
    type = INSFVSymmetryVelocityBC
    boundary = 'fluid_symmetry'
    variable = v_y
    u = v_x
    v = v_y
    momentum_component = 'y'
    mu = 'mu_t'
  []
  [symmetry_pressure]
    type = INSFVSymmetryPressureBC
    boundary = 'fluid_symmetry'
    variable = pressure
  []
[]

[Functions]
  [mu_func]
    type = PiecewiseLinear
    x = '1 2 3'
    y = '${fparse 1e5*mu_t} ${fparse 1e2*mu_t} ${mu_t}'
  []
[]

[Materials]
  [mu]
    type = ADGenericFunctionMaterial
    prop_names = 'mu_t'
    prop_values = 'mu_func'
    block = 'fuel pump hx'
  []
  [alpha]
    type = ADGenericConstantMaterial
    prop_names = 'alpha'
    prop_values = '${alpha}'
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
  [friction]
    type = ADGenericConstantMaterial
    prop_names = 'friction_coef'
    prop_values = ${friction}
    block = 'hx'
  []
[]

[Executioner]
  type = Transient
  start_time = 0.0
  end_time = 4
  dt = 1.0
  solve_type = 'PJFNK'
  petsc_options_iname = '-pc_type -ksp_gmres_reset'
  petsc_options_value = 'lu 50'
  line_search = 'none'
  nl_rel_tol = 1e-12
  nl_abs_tol = 1e-08
  nl_max_its = 20
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
    boundary = 'hx_in'
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
