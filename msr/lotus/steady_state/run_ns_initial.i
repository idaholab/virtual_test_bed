################################################################################
## Molten Chloride Reactor - Lotus design                                     ##
## Pronghorn input file to initialize velocity fields                         ##
##                                                                            ##
## This input can be set to run a slow relaxation to steady state while       ##
## ramping down the fluid viscosity.                                          ##
################################################################################

# Notes:
# - These inputs are not using the shorthand syntaxes to be consistent with inputs
#   from another project.
#   Please consider using the shorthand syntaxes for setting up flow simulations for your own models
# - These inputs are deliberately not using later developments of the code.
#   Please contact the model owner if you require an updated version.

# Material properties fuel
rho = 3279. # density [kg / m^3]  (@1000K)
mu = 0.005926 # viscosity [Pa s]
k = 0.38 # [W / m / K]
cp = 640. # [J / kg / K]

# Material properties reflector
k_ref = 30. # [W / m / K]
cp_ref = 880. # [J / kg / K]
rho_ref = 3580. # [kg / m^3]

power = 25e3 # [W]

# alpha_b = '${fparse 1.0/rho}'

# Mass flow rate tuning
friction = 11.0 # [kg / m^4]
pump_force = '${fparse 0.25*4.0e6}' # [N / m^3]
porosity = 1.0
# T_hx = 592
Reactor_Area = '${fparse 3.14159*0.2575*0.2575}'
Pr = '${fparse mu*cp/k}'

# Numerical scheme parameters
advected_interp_method = 'upwind'
velocity_interp_method = 'rc'

# Calibration of the mixing length parameter
mixing_length_pipe_calibrated = '${fparse 0.07 * 0.1 * 0.06}'
mixing_length_reactor_calibrated = '${fparse 0.07 * 0.1 * 2}'

[GlobalParams]
  rhie_chow_user_object = 'pins_rhie_chow_interpolator'

  two_term_boundary_expansion = true
  advected_interp_method = ${advected_interp_method}
  velocity_interp_method = ${velocity_interp_method}
  u = superficial_vel_x
  v = superficial_vel_y
  w = superficial_vel_z
  pressure = pressure
  porosity = porosity

  rho = rho
  mu = mu

  mixing_length = 'mixing_length'
[]

################################################################################
# GEOMETRY
################################################################################
[Mesh]
  coord_type = 'XYZ'
  [fmg]
    type = FileMeshGenerator
    file = '../mesh/mcre_mesh.e'
  []
  [scaling]
    type = TransformGenerator
    input = 'fmg'
    transform = 'SCALE'
    vector_value = '0.001 0.001 0.001'
  []
  [new_sideset_wall_reactor]
    type = SideSetsBetweenSubdomainsGenerator
    input = 'scaling'
    primary_block = 'reactor'
    paired_block = 'reflector'
    new_boundary = 'wall-reactor-full'
  []
  [reactor_top]
    type = ParsedGenerateSideset
    input = 'new_sideset_wall_reactor'
    new_sideset_name = 'reactor_top'
    included_subdomains = 'reactor'
    included_neighbors = 'pipe'
    combinatorial_geometry = 'x > 0'
  []
  [reactor_bottom]
    type = ParsedGenerateSideset
    input = 'reactor_top'
    new_sideset_name = 'reactor_bot'
    included_subdomains = 'reactor'
    included_neighbors = 'pipe'
    combinatorial_geometry = 'x < 0'
  []
  [mixing_plate]
    type = ParsedSubdomainMeshGenerator
    input = 'reactor_bottom'
    excluded_subdomains = 'pipe pump reflector'
    combinatorial_geometry = 'x > -0.3 & x < -0.22'
    block_id = '5'
    block_name = 'mixing-plate'
  []
  [delete_old_sidesets]
    type = BoundaryDeletionGenerator
    input = mixing_plate
    boundary_names = 'wall-reactor-caps  wall-reactor-reflector'
  []
  [mix_plate_downstream]
    type = ParsedGenerateSideset
    input = 'delete_old_sidesets'
    new_sideset_name = 'mixing-plate-downstream'
    included_subdomains = ' mixing-plate'
    combinatorial_geometry = ' (x > -0.23 & x < -0.2) & (y*y + z*z<0.12*0.12) '
  []
  [add-cooled-wall-pipes-outshield]
    type = ParsedGenerateSideset
    input = mix_plate_downstream
    combinatorial_geometry = 'y>1.'
    included_boundaries = wall-pipe
    new_sideset_name = 'heat-loss-section-outshield'
  []
  [add-cooled-wall-pipes-inshield]
    type = ParsedGenerateSideset
    input = add-cooled-wall-pipes-outshield
    combinatorial_geometry = 'y<1.'
    included_boundaries = wall-pipe
    new_sideset_name = 'heat-loss-section-inshield'
  []
  [heated-reflector_walls]
    type = ParsedGenerateSideset
    input = 'add-cooled-wall-pipes-inshield'
    new_sideset_name = 'heated-reflector-walls'
    included_subdomains = 'reflector'
    combinatorial_geometry = ' (x < 1.151 & y < -0.7749) | (x < 1.151 & y > 0.7749) |
                               (x < 1.151 & z < -0.5749) | (x < 1.151 & z > 0.5749)'
  []
  [non-heated-reflector_walls]
    type = ParsedGenerateSideset
    input = 'heated-reflector_walls'
    new_sideset_name = 'non-heated-reflector-walls'
    included_subdomains = 'reflector'
    combinatorial_geometry = ' (x > 1.149) | (x < -0.24)'
  []
  [reactor_out_bdry]
    type = ParsedGenerateSideset
    input = 'non-heated-reflector_walls'
    new_sideset_name = 'reactor_out'
    combinatorial_geometry = '(y > 775) | ((y <= 775) & (x > 1150 | x < -250))'
    include_only_external_sides = true
  []
  [regenerate_reactor_wall_to_reflector]
    type = SideSetsBetweenSubdomainsGenerator
    input = 'reactor_out_bdry'
    primary_block = 'reactor'
    paired_block = 'reflector'
    new_boundary = 'wall-reactor-reflector'
  []

  [repair_mesh]
    type = MeshRepairGenerator
    input = regenerate_reactor_wall_to_reflector
    fix_node_overlap = true
  []
[]

################################################################################
# EQUATIONS: VARIABLES, KERNELS & BCS
################################################################################

[UserObjects]
  [pins_rhie_chow_interpolator]
    type = PINSFVRhieChowInterpolator
    block = 'reactor pipe pump mixing-plate'
  []
[]

[Variables]
  [pressure]
    type = INSFVPressureVariable
    initial_condition = 0.1
    block = 'reactor pipe pump mixing-plate'
  []
  [superficial_vel_x]
    type = PINSFVSuperficialVelocityVariable
    initial_condition = 1e-6
    block = 'reactor pipe pump mixing-plate'
  []
  [superficial_vel_y]
    type = PINSFVSuperficialVelocityVariable
    initial_condition = 1e-6
    block = 'reactor pipe pump mixing-plate'
  []
  [superficial_vel_z]
    type = PINSFVSuperficialVelocityVariable
    initial_condition = 1e-6
    block = 'reactor pipe pump mixing-plate'
  []
  [lambda]
    family = SCALAR
    order = FIRST
    initial_condition = 1e-6
    block = 'reactor pipe pump mixing-plate'
  []
  [T]
    type = INSFVEnergyVariable
    initial_condition = 900.0
    block = 'reactor pipe pump mixing-plate'
  []
  [T_ref]
    type = INSFVEnergyVariable
    initial_condition = 900.0
    block = 'reflector'
    scaling = 0.001
  []
[]

[FVKernels]
  # The inactive parameter can be used to solve for a steady state
  # inactive = 'u_time v_time w_time heat_time heat_time_ref'

  [mass]
    type = PINSFVMassAdvection
    variable = pressure
    advected_interp_method = 'skewness-corrected'
    velocity_interp_method = 'rc'
    rho = ${rho}
  []
  [mean_zero_pressure]
    type = FVIntegralValueConstraint
    variable = pressure
    lambda = lambda
  []

  [u_time]
    type = PINSFVMomentumTimeDerivative
    variable = superficial_vel_x
    rho = ${rho}
    momentum_component = 'x'
  []
  [u_advection]
    type = PINSFVMomentumAdvection
    variable = superficial_vel_x
    advected_interp_method = ${advected_interp_method}
    velocity_interp_method = ${velocity_interp_method}
    rho = ${rho}
    momentum_component = 'x'
  []
  [u_viscosity]
    type = PINSFVMomentumDiffusion
    variable = superficial_vel_x
    momentum_component = 'x'
  []
  [u_viscosity_rans_pipe]
    type = INSFVMixingLengthReynoldsStress
    variable = superficial_vel_x
    rho = ${rho}
    momentum_component = 'x'
  []
  [u_pressure]
    type = PINSFVMomentumPressure
    variable = superficial_vel_x
    momentum_component = 'x'
    pressure = pressure
  []
  [u_friction_pump]
    type = PINSFVMomentumFriction
    variable = superficial_vel_x
    momentum_component = 'x'
    Darcy_name = 'DFC'
    block = 'pump'
  []
  [u_friction_pump_correction]
    type = PINSFVMomentumFrictionCorrection
    variable = superficial_vel_x
    momentum_component = 'x'
    rho = ${rho}
    Darcy_name = 'DFC'
    block = 'mixing-plate'
    consistent_scaling = 100.
  []

  [u_friction_mixing_plate]
    type = PINSFVMomentumFriction
    variable = superficial_vel_x
    momentum_component = 'x'
    Darcy_name = 'DFC_plate'
    block = 'mixing-plate'
  []
  [u_friction_mixing_plate_correction]
    type = PINSFVMomentumFrictionCorrection
    variable = superficial_vel_x
    momentum_component = 'x'
    rho = ${rho}
    Darcy_name = 'DFC_plate'
    block = 'mixing-plate'
    consistent_scaling = 100.
  []

  [v_time]
    type = PINSFVMomentumTimeDerivative
    variable = superficial_vel_y
    rho = ${rho}
    momentum_component = 'y'
  []
  [v_advection]
    type = PINSFVMomentumAdvection
    variable = superficial_vel_y
    advected_interp_method = ${advected_interp_method}
    velocity_interp_method = ${velocity_interp_method}
    rho = ${rho}
    momentum_component = 'y'
  []
  [v_viscosity]
    type = PINSFVMomentumDiffusion
    variable = superficial_vel_y
    momentum_component = 'y'
  []
  [v_viscosity_rans_pipe]
    type = INSFVMixingLengthReynoldsStress
    variable = superficial_vel_y
    rho = ${rho}
    mixing_length = ${mixing_length_pipe_calibrated}
    momentum_component = 'y'
    block = 'pipe pump'
  []
  [v_viscosity_rans]
    type = INSFVMixingLengthReynoldsStress
    variable = superficial_vel_y
    rho = ${rho}
    momentum_component = 'y'
  []
  [v_pressure]
    type = PINSFVMomentumPressure
    variable = superficial_vel_y
    momentum_component = 'y'
    pressure = pressure
  []
  [v_friction_pump]
    type = PINSFVMomentumFriction
    variable = superficial_vel_y
    momentum_component = 'y'
    Darcy_name = 'DFC'
    block = 'pump'
  []
  [v_friction_pump_correction]
    type = PINSFVMomentumFrictionCorrection
    variable = superficial_vel_y
    momentum_component = 'y'
    rho = ${rho}
    Darcy_name = 'DFC'
    block = 'mixing-plate'
    consistent_scaling = 100.
  []
  [v_friction_mixing_plate]
    type = PINSFVMomentumFriction
    variable = superficial_vel_y
    momentum_component = 'y'
    Darcy_name = 'DFC_plate'
    block = 'mixing-plate'
  []
  [pump]
    type = INSFVBodyForce
    variable = superficial_vel_y
    functor = ${pump_force}
    block = 'pump'
    momentum_component = 'y'
  []

  [w_time]
    type = PINSFVMomentumTimeDerivative
    variable = superficial_vel_z
    rho = ${rho}
    momentum_component = 'z'
  []
  [w_advection]
    type = PINSFVMomentumAdvection
    variable = superficial_vel_z
    advected_interp_method = ${advected_interp_method}
    velocity_interp_method = ${velocity_interp_method}
    rho = ${rho}
    momentum_component = 'z'
  []
  [w_viscosity]
    type = PINSFVMomentumDiffusion
    variable = superficial_vel_z
    momentum_component = 'z'
  []
  [w_viscosity_rans]
    type = INSFVMixingLengthReynoldsStress
    variable = superficial_vel_z
    rho = ${rho}
    momentum_component = 'z'
  []
  [w_pressure]
    type = PINSFVMomentumPressure
    variable = superficial_vel_z
    momentum_component = 'z'
    pressure = pressure
  []
  [w_friction_pump]
    type = PINSFVMomentumFriction
    variable = superficial_vel_z
    momentum_component = 'z'
    Darcy_name = 'DFC'
    block = 'pump'
  []
  [w_friction_mixing_plate]
    type = PINSFVMomentumFriction
    variable = superficial_vel_z
    momentum_component = 'z'
    Darcy_name = 'DFC_plate'
    block = 'mixing-plate'
  []

  ####### FUEL ENERGY EQUATION #######

  [heat_time]
    type = PINSFVEnergyTimeDerivative
    variable = T
    is_solid = false
    cp = ${cp}
  []
  [heat_advection]
    type = PINSFVEnergyAdvection
    variable = T
  []
  [heat_diffusion]
    type = PINSFVEnergyDiffusion
    variable = T
    k = ${k}
  []
  [heat_turbulent_diffusion]
    type = WCNSFVMixingLengthEnergyDiffusion
    variable = T
    schmidt_number = 0.9
    cp = ${cp}
  []
  [heat_src]
    type = FVBodyForce
    variable = T
    function = cosine_guess
    value = '${fparse power/0.21757}' #Volume integral of cosine shape is 0.21757
    block = 'reactor'
  []

  ####### REFLECTOR ENERGY EQUATION #######

  [heat_time_ref]
    type = PINSFVEnergyTimeDerivative
    variable = T_ref
    cp = ${cp_ref}
    rho = ${rho_ref}
    is_solid = true
    porosity = 0
  []
  [heat_diffusion_ref]
    type = FVDiffusion
    variable = T_ref
    coeff = ${k_ref}
  []
[]

[FVInterfaceKernels]
  [convection]
    type = FVConvectionCorrelationInterface
    variable1 = T
    variable2 = T_ref
    boundary = 'wall-reactor-reflector'
    h = htc
    T_solid = T_ref
    T_fluid = T
    subdomain1 = reactor
    subdomain2 = reflector
    wall_cell_is_bulk = true
  []
[]

[FVBCs]
  [no-slip-u]
    type = INSFVNoSlipWallBC
    boundary = 'wall-reactor wall-pipe wall-pump wall-reactor-full'
    variable = superficial_vel_x
    function = 0
  []
  [no-slip-v]
    type = INSFVNoSlipWallBC
    boundary = 'wall-reactor wall-pipe wall-pump wall-reactor-full'
    variable = superficial_vel_y
    function = 0
  []
  [no-slip-w]
    type = INSFVNoSlipWallBC
    boundary = 'wall-reactor wall-pipe wall-pump wall-reactor-full'
    variable = superficial_vel_z
    function = 0
  []
  [heat-losses-outshield]
    type = FVFunctorConvectiveHeatFluxBC
    variable = T
    T_bulk = T
    T_solid = 300.
    is_solid = false
    heat_transfer_coefficient = 3. #50.
    boundary = 'heat-loss-section-outshield'
  []
  [heated-outshield-pipe]
    type = FVFunctorNeumannBC
    variable = T
    boundary = 'heat-loss-section-outshield'
    functor = heat-input-pipe
  []
  [heat-losses-reflector]
    type = FVFunctorConvectiveHeatFluxBC
    variable = T_ref
    T_bulk = 350.
    T_solid = T_ref
    is_solid = true
    heat_transfer_coefficient = htc_rad_ref
    boundary = 'wall-reflector'
  []
  [heated-reflector-walls]
    type = FVFunctorNeumannBC
    variable = T_ref
    boundary = 'heated-reflector-walls'
    functor = heat-input-ref
  []
  [heated-inshield-pipe]
    type = FVNeumannBC
    variable = T
    boundary = 'heat-loss-section-inshield'
    value = 0.0 #500.
  []
[]

[AuxVariables]
  [h_DeltaT]
    type = MooseVariableFVReal
    block = 'reactor pipe pump mixing-plate'
  []
  [DeltaT_rad_aux]
    type = MooseVariableFVReal
    block = 'reflector'
  []
  [h_DeltaT_rad]
    type = MooseVariableFVReal
    block = 'reflector'
  []
  [a_u_var]
    type = MooseVariableFVReal
    block = 'reactor pipe pump mixing-plate'
  []
  [a_v_var]
    type = MooseVariableFVReal
    block = 'reactor pipe pump mixing-plate'
  []
  [a_w_var]
    type = MooseVariableFVReal
    block = 'reactor pipe pump mixing-plate'
  []
  [power_density]
    type = MooseVariableFVReal
  []
  [fission_source]
    type = MooseVariableFVReal
  []
  [c1]
    type = MooseVariableFVReal
    initial_condition = 1e-6
    block = 'reactor pipe pump mixing-plate'
  []
  [c2]
    type = MooseVariableFVReal
    initial_condition = 1e-6
    block = 'reactor pipe pump mixing-plate'
  []
  [c3]
    type = MooseVariableFVReal
    initial_condition = 1e-6
    block = 'reactor pipe pump mixing-plate'
  []
  [c4]
    type = MooseVariableFVReal
    initial_condition = 1e-6
    block = 'reactor pipe pump mixing-plate'
  []
  [c5]
    type = MooseVariableFVReal
    initial_condition = 1e-6
    block = 'reactor pipe pump mixing-plate'
  []
  [c6]
    type = MooseVariableFVReal
    initial_condition = 1e-6
    block = 'reactor pipe pump mixing-plate'
  []
[]

[AuxKernels]
  [h_DeltaT_out]
    type = ParsedAux
    variable = h_DeltaT
    coupled_variables = 'T'
    expression = '3.*(T-300.)'
  []
  [DeltaT_rad_out]
    type = ParsedAux
    variable = DeltaT_rad_aux
    coupled_variables = 'T_ref'
    expression = 'T_ref-350.'
  []
  [h_DeltaT_rad_out]
    type = FunctorAux
    functor = 'DeltaT_rad_aux'
    variable = h_DeltaT_rad
    factor = 'htc_rad_ref'
  []
  [comp_a_u]
    type = FunctorAux
    functor = 'ax'
    variable = 'a_u_var'
    block = 'reactor pipe pump mixing-plate'
    execute_on = 'timestep_end'
  []
  [comp_a_v]
    type = FunctorAux
    functor = 'ay'
    variable = 'a_v_var'
    block = 'reactor pipe pump mixing-plate'
    execute_on = 'timestep_end'
  []
  [comp_a_w]
    type = FunctorAux
    functor = 'az'
    variable = 'a_w_var'
    block = 'reactor pipe pump mixing-plate'
    execute_on = 'timestep_end'
  []
[]

################################################################################
# MATERIALS
################################################################################

[Functions]
  [heat-input-ref]
    type = ParsedFunction
    expression = '0.'
  []
  [heat-input-pipe]
    type = ParsedFunction
    expression = '0.'
  []
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
  [htc_rad_ref]
    type = ParsedFunction
    # See https://web.mit.edu/16.unified/www/FALL/thermodynamics/notes/node136.html
    expression = '(T_ref_wall^2+350.^2)*(T_ref_wall+350.)*5.67e-8 / (1/0.18+1/0.35-1.)' #e_mgo=0.18 #e_steel=0.35
    symbol_names = 'T_ref_wall'
    symbol_values = 'T_ref_wall'
  []
  [power-density-func]
    type = ParsedFunction
    expression = '${power}/0.21757 * max(0, cos(x*pi/2/1.5))*max(0, cos(y*pi/2/1.5))*max(0, cos(z*pi/2/1.5))'
  []
  [ad_rampdown_mu_func]
    type = ParsedFunction
    # This expression can be set to impose a slowly decreasing profile in mu
    expression = 'mu' # *(0.1*exp(-3*t)+1)
    symbol_names = 'mu'
    symbol_values = ${mu}
  []
  [cosine_guess]
    type = ParsedFunction
    expression = 'max(0, cos(x*pi/2/1.5))*max(0, cos(y*pi/2/1.5))*max(0, cos(z*pi/2/1.5))'
  []
  [dts]
    type = PiecewiseLinear
    x = '0   1e7 ${fparse 1e7+0.05} ${fparse 1e7+0.2}'
    y = '0.1 0.1 1e7                1e7'
  []
[]

[FunctorMaterials]
  [generic]
    type = ADGenericFunctorMaterial
    prop_names = 'rho porosity'
    prop_values = '${rho} ${porosity}'
  []
  [interstitial_velocity_norm]
    type = PINSFVSpeedFunctorMaterial
    superficial_vel_x = superficial_vel_x
    superficial_vel_y = superficial_vel_y
    superficial_vel_z = superficial_vel_z
    porosity = porosity
  []
  [mu_spatial]
    type = ADPiecewiseByBlockFunctorMaterial
    prop_name = 'mu'
    subdomain_to_prop_value = 'pipe ad_rampdown_mu_func
                               pump ad_rampdown_mu_func
                               mixing-plate ad_rampdown_mu_func
                               reactor ad_rampdown_mu_func'
  []
  # TODO: remove this, fix ParsedFunctorMaterial
  [constant]
    type = GenericFunctorMaterial
    prop_names = 'constant_1'
    prop_values = '${fparse 2 * friction}'
  []
  [D_friction]
    type = ADParsedFunctorMaterial
    property_name = D_friction
    # This convoluted expression is because the model was developed back when
    # Pronghorn used a linear friction force as W * rho * v.
    # Now Pronghorn has explicit Darcy and Forchheimer coefficients
    expression = '2 * friction * rho / porosity / mu'
    functor_symbols = 'friction rho porosity mu'
    functor_names = 'constant_1 rho porosity mu'
  []
  [friction_material_pump]
    type = ADGenericVectorFunctorMaterial
    prop_names = 'DFC FFC'
    prop_values = 'D_friction D_friction D_friction
                   0 0 0'
  []
  [friction_material_mixing_plate]
    type = ADGenericVectorFunctorMaterial
    prop_names = 'DFC_plate FFC_plate'
    prop_values = 'D_friction D_friction D_friction
                   0 0 0'
  []
  [ins_fv]
    type = INSFVEnthalpyFunctorMaterial
    rho = ${rho}
    cp = ${cp}
    temperature = 'T'
  []
  [mixing_length_mat]
    type = ADPiecewiseByBlockFunctorMaterial
    prop_name = 'mixing_length'
    subdomain_to_prop_value = 'reactor      ${mixing_length_reactor_calibrated}
                               mixing-plate ${mixing_length_reactor_calibrated}
                               pipe         ${mixing_length_pipe_calibrated}
                               pump         ${mixing_length_pipe_calibrated}'
  []
[]

################################################################################
# EXECUTION / SOLVE
################################################################################

[Executioner]
  type = Transient

  # Time-stepping parameters
  start_time = 1e7
  end_time = 2e7
  # dt = 1e6

  [TimeStepper]
    type = IterationAdaptiveDT
    optimal_iterations = 10
    dt = 0.005
    timestep_limiting_postprocessor = 'dt_limit'
  []

  # Solver parameters
  solve_type = 'NEWTON'
  petsc_options_iname = '-pc_type -pc_factor_shift_type -ksp_gmres_restart'
  petsc_options_value = 'lu NONZERO 20'
  line_search = 'none'
  nl_rel_tol = 1e-6
  nl_abs_tol = 1e-4
  nl_max_its = 10 # fail early and try again with a shorter time step
  l_max_its = 80
  automatic_scaling = true

  # MultiApp iteration parameters
  relaxation_factor = 1.0
[]

[Debug]
  show_var_residual_norms = true
[]

################################################################################
# SIMULATION OUTPUTS
################################################################################

[Outputs]
  csv = true
  [restart]
    type = Exodus
    execute_on = 'timestep_end final'
  []
  # Reduce base output
  print_linear_converged_reason = false
  print_linear_residuals = false
  print_nonlinear_converged_reason = false
  hide = 'dt_limit'
[]

[Postprocessors]
  [max_v]
    type = ElementExtremeValue
    variable = superficial_vel_x
    value_type = max
    block = 'reactor pump pipe'
  []
  [flow]
    type = VolumetricFlowRate
    boundary = 'reactor_bot'
    vel_x = superficial_vel_x
    vel_y = superficial_vel_y
    vel_z = superficial_vel_z
    advected_quantity = ${rho}
  []
  [T_reac_bot]
    type = SideAverageValue
    boundary = 'reactor_bot'
    variable = T
  []
  [T_reac_top]
    type = SideAverageValue
    boundary = 'reactor_top'
    variable = T
  []
  [T_ref_wall]
    type = SideAverageValue
    boundary = 'wall-reflector'
    variable = T_ref
  []
  [pdrop]
    type = PressureDrop
    pressure = pressure
    upstream_boundary = 'reactor_bot'
    downstream_boundary = 'mixing-plate-downstream'
    boundary = 'mixing-plate-downstream reactor_bot'
  []
  [heat-loss-pipe]
    type = SideIntegralVariablePostprocessor
    boundary = 'heat-loss-section-outshield'
    variable = h_DeltaT
  []
  [heat-loss-reflector]
    type = SideIntegralVariablePostprocessor
    boundary = 'wall-reflector'
    variable = h_DeltaT_rad
  []
  [heat-input-ref-pp]
    type = FunctionSideIntegral
    boundary = 'heated-reflector-walls'
    function = heat-input-ref
  []
  [heat-input-pipe-pp]
    type = FunctionSideIntegral
    boundary = 'heat-loss-section-outshield'
    function = heat-input-pipe
  []
  [reactor-power]
    type = ElementIntegralFunctorPostprocessor
    block = 'reactor'
    functor = 'power-density-func'
  []
  [T_reac_ave]
    type = ElementAverageValue
    variable = T
    block = 'reactor'
  []
  [T_reac_max]
    type = ElementExtremeValue
    variable = T
    block = 'reactor'
  []
  [T_pipe_ave]
    type = ElementAverageValue
    variable = T
    block = 'pipe'
  []
  [T_ref_ave]
    type = ElementAverageValue
    variable = T_ref
    block = 'reflector'
  []
  [T_ref_max]
    type = ElementExtremeValue
    variable = T_ref
    block = 'reflector'
  []

  [c1_outlet]
    type = VolumetricFlowRate
    boundary = 'reactor_top'
    vel_x = superficial_vel_x
    vel_y = superficial_vel_y
    vel_z = superficial_vel_z
    advected_quantity = c1
  []
  [c2_outlet]
    type = VolumetricFlowRate
    boundary = 'reactor_top'
    vel_x = superficial_vel_x
    vel_y = superficial_vel_y
    vel_z = superficial_vel_z
    advected_quantity = c2
  []
  [c3_outlet]
    type = VolumetricFlowRate
    boundary = 'reactor_top'
    vel_x = superficial_vel_x
    vel_y = superficial_vel_y
    vel_z = superficial_vel_z
    advected_quantity = c3
  []
  [c4_outlet]
    type = VolumetricFlowRate
    boundary = 'reactor_top'
    vel_x = superficial_vel_x
    vel_y = superficial_vel_y
    vel_z = superficial_vel_z
    advected_quantity = c4
  []
  [c5_outlet]
    type = VolumetricFlowRate
    boundary = 'reactor_top'
    vel_x = superficial_vel_x
    vel_y = superficial_vel_y
    vel_z = superficial_vel_z
    advected_quantity = c5
  []
  [c6_outlet]
    type = VolumetricFlowRate
    boundary = 'reactor_top'
    vel_x = superficial_vel_x
    vel_y = superficial_vel_y
    vel_z = superficial_vel_z
    advected_quantity = c6
  []

  [c1_inlet]
    type = VolumetricFlowRate
    boundary = 'reactor_bot'
    vel_x = superficial_vel_x
    vel_y = superficial_vel_y
    vel_z = superficial_vel_z
    advected_quantity = c1
  []
  [c2_inlet]
    type = VolumetricFlowRate
    boundary = 'reactor_bot'
    vel_x = superficial_vel_x
    vel_y = superficial_vel_y
    vel_z = superficial_vel_z
    advected_quantity = c2
  []
  [c3_inlet]
    type = VolumetricFlowRate
    boundary = 'reactor_bot'
    vel_x = superficial_vel_x
    vel_y = superficial_vel_y
    vel_z = superficial_vel_z
    advected_quantity = c3
  []
  [c4_inlet]
    type = VolumetricFlowRate
    boundary = 'reactor_bot'
    vel_x = superficial_vel_x
    vel_y = superficial_vel_y
    vel_z = superficial_vel_z
    advected_quantity = c4
  []
  [c5_inlet]
    type = VolumetricFlowRate
    boundary = 'reactor_bot'
    vel_x = superficial_vel_x
    vel_y = superficial_vel_y
    vel_z = superficial_vel_z
    advected_quantity = c5
  []
  [c6_inlet]
    type = VolumetricFlowRate
    boundary = 'reactor_bot'
    vel_x = superficial_vel_x
    vel_y = superficial_vel_y
    vel_z = superficial_vel_z
    advected_quantity = c6
  []

  [dt_limit]
    type = Receiver
    default = 1e6
  []
[]

################################################################################
# MULTIAPPS and TRANSFERS for precursors transport
################################################################################

[MultiApps]
  [prec_transport]
    type = TransientMultiApp
    input_files = 'run_prec_transport.i'
    execute_on = 'timestep_end'
    # no_backup_and_restore = true
    # Allow smaller time steps by the child applications
    sub_cycling = true
  []
[]

[Transfers]
  [power_density]
    type = MultiAppGeneralFieldNearestLocationTransfer
    to_multi_app = prec_transport
    source_variable = power_density
    variable = power_density
  []
  [fission_source]
    type = MultiAppGeneralFieldNearestLocationTransfer
    to_multi_app = prec_transport
    source_variable = fission_source
    variable = fission_source
  []
  [u_x]
    type = MultiAppGeneralFieldNearestLocationTransfer
    to_multi_app = prec_transport
    source_variable = superficial_vel_x
    variable = superficial_vel_x
  []
  [u_y]
    type = MultiAppGeneralFieldNearestLocationTransfer
    to_multi_app = prec_transport
    source_variable = superficial_vel_y
    variable = superficial_vel_y
  []
  [u_z]
    type = MultiAppGeneralFieldNearestLocationTransfer
    to_multi_app = prec_transport
    source_variable = superficial_vel_z
    variable = superficial_vel_z
  []
  [a_u]
    type = MultiAppGeneralFieldNearestLocationTransfer
    to_multi_app = prec_transport
    source_variable = a_u_var
    variable = a_u_var
  []
  [a_v]
    type = MultiAppGeneralFieldNearestLocationTransfer
    to_multi_app = prec_transport
    source_variable = a_v_var
    variable = a_v_var
  []
  [a_w]
    type = MultiAppGeneralFieldNearestLocationTransfer
    to_multi_app = prec_transport
    source_variable = a_w_var
    variable = a_w_var
  []

  [c1]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = prec_transport
    source_variable = 'c1'
    variable = 'c1'
  []
  [c2]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = prec_transport
    source_variable = 'c2'
    variable = 'c2'
  []
  [c3]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = prec_transport
    source_variable = 'c3'
    variable = 'c3'
  []
  [c4]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = prec_transport
    source_variable = 'c4'
    variable = 'c4'
  []
  [c5]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = prec_transport
    source_variable = 'c5'
    variable = 'c5'
  []
  [c6]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = prec_transport
    source_variable = 'c6'
    variable = 'c6'
  []
[]
