################################################################################
## Generic Chloride Molten Salt Reactor                                       ##
## MOOSE Navier-Stokes module input file for fluid velocity, pressure         ##
## and temperature. Uses an artificially large viscosity.                     ##
## Solved using the SIMPLE algorithm                                          ##
## For more information see:
##
##
##
################################################################################

# Material properties fuel
rho = 3279. # density [kg / m^3]  (@1000K)
mu = 5 # viscosity [Pa s]
k = 0.38 # thermal conductivity [W/m/K]
cp = 640. # specific heat [J/kg/K]

power = 10e3 # [W] wil lbe divided by the volume later

# Mass flow rate tuning
friction = 11.0 # [kg / m4]
pump_force = '${fparse 0.25*4.0e6}' # [N / m^3]
porosity = 1.0
Reactor_Area = '${fparse 3.14159*0.2575*0.2575}'
Pr = '${fparse mu*cp/k}'

# Numerical scheme parameters
advected_interp_method = 'upwind'
velocity_interp_method = 'rc'

# Vector tag for enabling splitting the pressure gradient term from the rest of the
# momentum equation
pressure_tag = "pressure_grad"

[GlobalParams]
  rhie_chow_user_object = 'pins_rhie_chow_interpolator'
[]

# For a segregated solver, we need multiple nonlinear systems in the problem
[Problem]
  nl_sys_names = 'u_system v_system w_system pressure_system energy_system'

  # For variable relaxation, we need this
  previous_nl_solution_required = true
  kernel_coverage_check = false
[]

################################################################################
# GEOMETRY
################################################################################
[Mesh]
  [fmg]
    type = FileMeshGenerator
    file = 'cmsr_mesh.e'
  []
[]

################################################################################
# EQUATIONS: VARIABLES, KERNELS & BCS
################################################################################

[UserObjects]
  [pins_rhie_chow_interpolator]
    type = PINSFVRhieChowInterpolatorSegregated
    u = superficial_vel_x
    v = superficial_vel_y
    w = superficial_vel_z
    pressure = pressure
    porosity = porosity
    block = 'reactor pipe pump mixing-plate'
  []
[]

# We make sure every variable is assigned to a different system
[Variables]
  [superficial_vel_x]
    type = PINSFVSuperficialVelocityVariable
    block = 'reactor pipe pump mixing-plate'
    two_term_boundary_expansion = false
    nl_sys = u_system
  []
  [superficial_vel_y]
    type = PINSFVSuperficialVelocityVariable
    block = 'reactor pipe pump mixing-plate'
    two_term_boundary_expansion = false
    nl_sys = v_system
  []
  [superficial_vel_z]
    type = PINSFVSuperficialVelocityVariable
    block = 'reactor pipe pump mixing-plate'
    two_term_boundary_expansion = false
    nl_sys = w_system
  []
  [pressure]
    type = INSFVPressureVariable
    block = 'reactor pipe pump mixing-plate'
    two_term_boundary_expansion = false
    initial_condition = 0
    nl_sys = pressure_system
  []
  [T]
    type = INSFVEnergyVariable
    block = 'reactor pipe pump mixing-plate'
    two_term_boundary_expansion = false
    nl_sys = energy_system
    initial_condition = 350
  []
[]

[FVKernels]

  ####### MOMENTUM EQUATION #######

  [u_advection]
    type = PINSFVMomentumAdvection
    variable = superficial_vel_x
    advected_interp_method = ${advected_interp_method}
    velocity_interp_method = ${velocity_interp_method}
    rho = ${rho}
    momentum_component = 'x'
    porosity = 'porosity'
  []
  [u_viscosity]
    type = PINSFVMomentumDiffusion
    variable = superficial_vel_x
    momentum_component = 'x'
    mu = 'mu'
    porosity = 'porosity'
  []
  [u_pressure]
    type = PINSFVMomentumPressure
    variable = superficial_vel_x
    momentum_component = 'x'
    pressure = pressure
    extra_vector_tags = ${pressure_tag}
    porosity = 'porosity'
  []
  [u_friction_pump]
    type = PINSFVMomentumFriction
    variable = superficial_vel_x
    momentum_component = 'x'
    Darcy_name = 'DFC'
    Forchheimer_name = 'FFC'
    block = 'pump'
    rho = ${rho}
  []
  [u_friction_mixing_plate]
    type = PINSFVMomentumFriction
    variable = superficial_vel_x
    momentum_component = 'x'
    Darcy_name = 'DFC_plate'
    Forchheimer_name = 'FFC_plate'
    block = 'mixing-plate'
    rho = ${rho}
  []

  [v_advection]
    type = PINSFVMomentumAdvection
    variable = superficial_vel_y
    advected_interp_method = ${advected_interp_method}
    velocity_interp_method = ${velocity_interp_method}
    rho = ${rho}
    momentum_component = 'y'
    porosity = 'porosity'
  []
  [v_viscosity]
    type = PINSFVMomentumDiffusion
    variable = superficial_vel_y
    momentum_component = 'y'
    mu = 'mu'
    porosity = 'porosity'
  []
  [v_pressure]
    type = PINSFVMomentumPressure
    variable = superficial_vel_y
    momentum_component = 'y'
    pressure = pressure
    extra_vector_tags = ${pressure_tag}
    porosity = 'porosity'
  []
  [v_friction_pump]
    type = PINSFVMomentumFriction
    variable = superficial_vel_y
    momentum_component = 'y'
    Darcy_name = 'DFC'
    Forchheimer_name = 'FFC'
    block = 'pump'
    rho = ${rho}
  []
  [v_friction_mixing_plate]
    type = PINSFVMomentumFriction
    variable = superficial_vel_y
    momentum_component = 'y'
    Darcy_name = 'DFC_plate'
    Forchheimer_name = 'FFC_plate'
    block = 'mixing-plate'
    rho = ${rho}
  []

  [pump]
    type = INSFVBodyForce
    variable = superficial_vel_y
    functor = ${pump_force}
    block = 'pump'
    momentum_component = 'y'
  []

  [w_advection]
    type = PINSFVMomentumAdvection
    variable = superficial_vel_z
    advected_interp_method = ${advected_interp_method}
    velocity_interp_method = ${velocity_interp_method}
    rho = ${rho}
    momentum_component = 'z'
    porosity = 'porosity'
  []
  [w_viscosity]
    type = PINSFVMomentumDiffusion
    variable = superficial_vel_z
    momentum_component = 'z'
    mu = 'mu'
    porosity = 'porosity'
  []
  [w_pressure]
    type = PINSFVMomentumPressure
    variable = superficial_vel_z
    momentum_component = 'z'
    pressure = pressure
    extra_vector_tags = ${pressure_tag}
    porosity = 'porosity'
  []
  [w_friction_pump]
    type = PINSFVMomentumFriction
    variable = superficial_vel_z
    momentum_component = 'z'
    Darcy_name = 'DFC'
    Forchheimer_name = 'FFC'
    block = 'pump'
    rho = ${rho}
  []
  [w_friction_mixing_plate]
    type = PINSFVMomentumFriction
    variable = superficial_vel_z
    momentum_component = 'z'
    Darcy_name = 'DFC_plate'
    Forchheimer_name = 'FFC_plate'
    block = 'mixing-plate'
    rho = ${rho}
  []

  ####### PRESSURE EQUATION #######

  [p_diffusion]
    type = FVAnisotropicDiffusion
    variable = pressure
    coeff = "Ainv"
    coeff_interp_method = 'average'
  []
  [p_source]
    type = FVDivergence
    variable = pressure
    vector_field = "HbyA"
    force_boundary_execution = true
  []

  ####### FUEL ENERGY EQUATION #######

  [heat_advection]
    type = PINSFVEnergyAdvection
    variable = T
    advected_interp_method = ${advected_interp_method}
    velocity_interp_method = ${velocity_interp_method}
  []
  [heat_diffusion]
    type = PINSFVEnergyDiffusion
    variable = T
    k = '${fparse k+mu*cp/0.9}'
    porosity = 'porosity'
  []
  [heat_src]
    type = FVBodyForce
    variable = T
    function = cosine_guess
    value = '${fparse power/0.21757}'
    block = 'reactor'
  []
[]

[FVBCs]
  [no-slip-u]
    type = INSFVNoSlipWallBC
    boundary = 'wall-reactor heat-loss-section-outshield heat-loss-section-inshield wall-pump'
    variable = superficial_vel_x
    function = 0
  []
  [no-slip-v]
    type = INSFVNoSlipWallBC
    boundary = 'wall-reactor heat-loss-section-outshield heat-loss-section-inshield wall-pump'
    variable = superficial_vel_y
    function = 0
  []
  [no-slip-w]
    type = INSFVNoSlipWallBC
    boundary = 'wall-reactor heat-loss-section-outshield heat-loss-section-inshield wall-pump'
    variable = superficial_vel_z
    function = 0
  []
  [heat-losses-outshield]
    type = FVFunctorConvectiveHeatFluxBC
    variable = T
    T_bulk = T
    T_solid = 300.
    is_solid = false
    heat_transfer_coefficient = 10. #50.
    boundary = 'heat-loss-section-outshield'
  []
  [heat-losses-reflector]
    type = FVFunctorConvectiveHeatFluxBC
    variable = T
    T_bulk = T
    T_solid = 300
    is_solid = false
    heat_transfer_coefficient = htc_rad_reac
    boundary = 'wall-reactor'
  []
[]

################################################################################
# MATERIALS
################################################################################

[Functions]
  [Re_reactor]
    type = ParsedFunction
    expression = 'flow_hx_bot/Reactor_Area * (2*0.2575) / mu '
    symbol_names = 'flow_hx_bot mu Reactor_Area'
    #symbol_values = 'flow_hx_bot ${mu} ${Reactor_Area}'
    symbol_values = '25.2 ${mu} ${Reactor_Area}'
  []
  [htc]
    type = ParsedFunction
    expression = 'k/0.2575* 0.023 * Re_reactor^0.8 * Pr^0.3'
    symbol_names = 'k Re_reactor Pr'
    symbol_values = '${k} Re_reactor ${Pr}'
  []
  [htc_rad_reac]
    type = ParsedFunction
    expression = '1/(1/htc + 1/((T_ref_external_wall^2+T_ambient^2)*(T_ref_external_wall+T_ambient)*5.67e-8 / (1/0.18+1/0.35-1.)))' #https://web.mit.edu/16.unified/www/FALL/thermodynamics/notes/node136.html #e_mgo=0.18 #e_steel=0.35
    symbol_names = 'T_ref_external_wall T_ambient htc'
    symbol_values = '600 300 htc'
  []
  [cosine_guess]
    type = ParsedFunction
    value = 'max(0, cos((x-0.5)*pi/2/1.5))*max(0, cos(y*pi/2/1.5))*max(0, cos(z*pi/2/1.5))'
  []
[]

[Materials]
  [generic]
    type = ADGenericFunctorMaterial
    prop_names = 'rho porosity mu'
    prop_values = '${rho} ${porosity} ${mu}'
  []
  [friction_material_pump]
    type = ADGenericVectorFunctorMaterial
    prop_names = 'DFC FFC'
    prop_values = '${fparse 2.2*friction} ${fparse 2.2*friction} ${fparse 2.2*friction}
                   ${fparse 2.2*friction} ${fparse 2.2*friction} ${fparse 2.2*friction}'
  []
  [friction_material_mixing_plate]
    type = ADGenericVectorFunctorMaterial
    prop_names = 'DFC_plate FFC_plate'
    prop_values = '${fparse 1*friction} ${fparse 3*friction} ${fparse 3*friction}
                   ${fparse 1*friction} ${fparse 3*friction} ${fparse 3*friction}'
  []
  [ins_fv]
    type = INSFVEnthalpyMaterial
    rho = ${rho}
    cp = ${cp}
    temperature = 'T'
  []
[]

################################################################################
# EXECUTION / SOLVE
################################################################################

[Executioner]
  type = SIMPLE

  # Absolute linear solver tolerances for the different equations
  momentum_l_abs_tol = 1e-9
  pressure_l_abs_tol = 1e-9
  energy_l_abs_tol = 1e-9

  # Relative linear tolerances for the different equations
  momentum_l_tol = 0
  pressure_l_tol = 0
  energy_l_tol = 0

  # The segregated Rhie-Chow interpolator object
  rhie_chow_user_object = 'pins_rhie_chow_interpolator'
  momentum_systems = 'u_system v_system w_system'
  pressure_system = 'pressure_system'
  energy_system = 'energy_system'

  # The tag which is used to split the momentum equation
  pressure_gradient_tag = ${pressure_tag}

  # Relaxation parameters
  momentum_equation_relaxation = 0.85
  pressure_variable_relaxation = 0.3
  energy_equation_relaxation = 1.0

  # Maximum number of SIMPLE iterations
  num_iterations = 100

  # Iterative tolerances with SIMPLE
  pressure_absolute_tolerance = 1e-4
  momentum_absolute_tolerance = 1e-4
  energy_absolute_tolerance = 1e-4

  # Pressure pin for the close loop problem
  pin_pressure = true
  pressure_pin_value = 0.0
  pressure_pin_point = '0.5 0.0 0.0'

  # Separate PETSc options for the different equations
  momentum_petsc_options_iname = '-pc_type -pc_hypre_type'
  momentum_petsc_options_value = 'hypre boomeramg'

  pressure_petsc_options_iname = '-pc_type -pc_hypre_type'
  pressure_petsc_options_value = 'hypre boomeramg'

  energy_petsc_options_iname = '-pc_type -pc_hypre_type'
  energy_petsc_options_value = 'hypre boomeramg'
[]

################################################################################
# SIMULATION OUTPUTS
################################################################################

[Outputs]
  exodus = true
[]
