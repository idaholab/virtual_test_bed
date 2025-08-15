# ==============================================================================
# Model description
# ------------------------------------------------------------------------------
# CNRS Benchmark model Created & modifed by Dr. Mustafa Jaradat and Dr. Namjae Choi
# November 22, 2022
# Step 1.2: Power coupling
# ==============================================================================
#   Tiberga, et al., 2020. Results from a multi-physics numerical benchmark for codes
#   dedicated to molten salt fast reactors. Ann. Nucl. Energy 142(2020)107428. 
#   URL:http://www.sciencedirect.com/science/article/pii/S0306454920301262
# ==============================================================================

rho   = 2.0e+3
cp    = 3.075e+3
k     = 1.0e-3
mu    = 5.0e+1
geometric_tolerance = 1e-3
cavity_l = 2.0
lid_velocity = 0.5

velocity_interp_method = 'rc'
advected_interp_method = 'average'

[GlobalParams]
  rhie_chow_user_object = 'rc'
[]

[UserObjects]
  [rc]
    type = INSFVRhieChowInterpolator
    u = vel_x
    v = vel_y
    pressure = pressure
  []
[]

[Mesh]
  type = MeshGeneratorMesh
  block_id = '1'
  block_name = 'cavity'
  [cartesian_mesh]
    type = CartesianMeshGenerator
    dim = 2
    dx = '1.0 1.0'
    ix = '100 100'
    dy = '1.0 1.0'
    iy = '100 100'
    subdomain_id = ' 1 1
                     1 1'
  []
[]

[Variables]
  [vel_x]
    type = INSFVVelocityVariable
  []
  [vel_y]
    type = INSFVVelocityVariable
  []
  [pressure]
    type = INSFVPressureVariable
  []
  [T_fluid]
    type = INSFVEnergyVariable
    initial_condition = 900.0
  []
  [lambda]
    family = SCALAR
    order = FIRST
  []
[]

[AuxVariables]
  [U]
    order = CONSTANT
    family = MONOMIAL
    fv = true
  []
  [power_density]
    type = MooseVariableFVReal
  []
[]

[AuxKernels]
  [mag]
    type = VectorMagnitudeAux
    variable = U
    x = vel_x
    y = vel_y
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
  [mean_zero_pressure]
    type = FVIntegralValueConstraint
    variable = pressure
    lambda = lambda
  []

  [u_advection]
    type = INSFVMomentumAdvection
    variable = vel_x
    velocity_interp_method = ${velocity_interp_method}
    advected_interp_method = ${advected_interp_method}
    rho = ${rho}
    momentum_component = 'x'
  []

  [u_viscosity]
    type = INSFVMomentumDiffusion
    variable = vel_x
    mu = ${mu}
    momentum_component = 'x'
  []

  [u_pressure]
    type = INSFVMomentumPressure
    variable = vel_x
    momentum_component = 'x'
    pressure = pressure
  []

  [v_advection]
    type = INSFVMomentumAdvection
    variable = vel_y
    velocity_interp_method = ${velocity_interp_method}
    advected_interp_method = ${advected_interp_method}
    rho = ${rho}
    momentum_component = 'y'
  []

  [v_viscosity]
    type = INSFVMomentumDiffusion
    variable = vel_y
    mu = ${mu}
    momentum_component = 'y'
  []

  [v_pressure]
    type = INSFVMomentumPressure
    variable = vel_y
    momentum_component = 'y'
    pressure = pressure
  []

  [temp_conduction]
    type = FVDiffusion
    coeff = 'k'
    variable = T_fluid
  []

  [temp_advection]
    type = INSFVEnergyAdvection
    variable = T_fluid
    velocity_interp_method = ${velocity_interp_method}
    advected_interp_method = ${advected_interp_method}
  []
  [temp_sinksource]
    type = NSFVEnergyAmbientConvection
    variable = T_fluid
    T_ambient = 900.
    alpha = '1e6'
  []
  
  [temp_fissionpower]
    type = FVCoupledForce
    variable = T_fluid
    v = power_density
  []
[]

[FVBCs]
  [top_x]
    type = INSFVNoSlipWallBC
    variable = vel_x
    boundary = 'top'
    function = 'lid_function'
  []

  [no_slip_x]
    type = INSFVNoSlipWallBC
    variable = vel_x
    boundary = 'left right bottom'
    function = 0
  []

  [no_slip_y]
    type = INSFVNoSlipWallBC
    variable = vel_y
    boundary = 'left right top bottom'
    function = 0
  []

  [T_hot]
    type = FVDirichletBC
    variable = T_fluid
    boundary = 'bottom'
    value = 1
  []

  [T_cold]
    type = FVDirichletBC
    variable = T_fluid
    boundary = 'top'
    value = 0
  []
[]

[Materials]
  [functor_constants]
    type = ADGenericFunctorMaterial
    prop_names = 'cp k'
    prop_values = '${cp} ${k}'
  []
  [ins_fv]
    type = INSFVEnthalpyMaterial
    temperature = 'T_fluid'
    rho = ${rho}
  []
[]

[Functions]
  [lid_function]
    type = ParsedFunction
    expression = 'if (x > ${geometric_tolerance}, if (x < ${fparse cavity_l - geometric_tolerance}, ${lid_velocity}, 0.0), 0.0)'
  []
[]

[Executioner]
# Solving the steady-state versions of these equations
  type = Steady
  solve_type = 'NEWTON'
  #line_search = 'none'
  petsc_options_iname = '-pc_type -pc_factor_shift_type'
  petsc_options_value = 'lu NONZERO'
  nl_rel_tol = 1e-12
[]
  
[Outputs]
  exodus = true
[]

