################################################################################
## Molten Salt Fast Reactor - Euratom EVOL + Rosatom MARS Design              ##
## Pronghorn Sub-Application input file                                       ##
## Relaxation towards Steady state 3D thermal hydraulics model                ##
################################################################################
# If using or referring to this model, please cite as explained in
# https://mooseframework.inl.gov/virtual_test_bed/citing.html

# The flow in this simulation should be initialized with a previous flow
# solution (isothermal, heated or multiphysics) OR using a viscosity rampdown
# An isothermal solution can be generated using 'run_ns_initial.i', and is
# saved in 'restart/run_ns_initial_restart.e'
# A heated solution, with a flat power distribution, can be generated with
# this script 'run_ns.i', and is saved in 'restart/run_ns_restart.e'
# A coupled neutronics-coarse TH solution can be generated with
# 'run_neutronics.i', saved in 'restart/run_neutronics_ns_restart.e'

# Material properties
rho = 4284 # density [kg / m^3]  (@1000K)
cp = 1594 # specific heat capacity [J / kg / K]
drho_dT = 0.882 # derivative of density w.r.t. temperature [kg / m^3 / K]
mu = 0.0166 # viscosity [Pa s]
k = 1.7 # thermal conductivity [W / m / K]
# https://www.researchgate.net/publication/337161399_Development_of_a_control-\
# oriented_power_plant_simulator_for_the_molten_salt_fast_reactor/fulltext/5dc9\
# 5c9da6fdcc57503eec39/Development-of-a-control-oriented-power-plant-simulator-\
# for-the-molten-salt-fast-reactor.pdf
von_karman_const = 0.41

# Turbulent properties
Pr_t = 0.9 # turbulent Prandtl number
Sc_t = 1 # turbulent Schmidt number

# Derived material properties
alpha = '${fparse drho_dT / rho}' # thermal expansion coefficient

# Operating parameters
T_HX = 873.15 # heat exchanger temperature [K]

# Mass flow rate tuning, for heat exchanger pressure and temperature drop
friction = 4e3 # [kg / m^4]
pump_force = -20000. # [N / m^3]

# Delayed neutron precursor parameters. Lambda values are decay constants in
# [1 / s]. Beta values are production fractions.
lambda1_m = -0.0133104
lambda2_m = -0.0305427
lambda3_m = -0.115179
lambda4_m = -0.301152
lambda5_m = -0.879376
lambda6_m = -2.91303
beta1 = 8.42817e-05
beta2 = 0.000684616
beta3 = 0.000479796
beta4 = 0.00103883
beta5 = 0.000549185
beta6 = 0.000184087

[GlobalParams]
  rhie_chow_user_object = 'ins_rhie_chow_interpolator'
[]

################################################################################
# GEOMETRY
################################################################################

[Mesh]
  coord_type = 'RZ'
  rz_coord_axis = Y
  allow_renumbering = false

  [restart]
    type = FileMeshGenerator
    use_for_exodus_restart = true
    # Depending on the file chosen, the initialization of variables should be
    # adjusted. The following variables can be initalized:
    # - vel_x, vel_y, p from isothermal simulation
    # file = 'restart/run_ns_initial_restart.e'
    # Below are initialization points created from this input file
    # The variable IC should be set from_file_var for temperature and precursors
    # - vel_x, vel_y, p, T_fluid, c_i from cosine heated simulation
    # file = 'restart/run_ns_restart.e'
    # - vel_x, vel_y, p, T_fluid, c_i from coupled multiphysics simulation
    file = 'restart/run_ns_coupled_restart.e'
  []
  [hx_top]
    type = ParsedGenerateSideset
    combinatorial_geometry = 'y > 0'
    included_subdomains = '3'
    included_neighbors = '1'
    fixed_normal = true
    normal = '0 1 0'
    new_sideset_name = 'hx_top'
    input = 'restart'
  []
  [hx_bot]
    type = ParsedGenerateSideset
    combinatorial_geometry = 'y <-0.6'
    included_subdomains = '3'
    included_neighbors = '1'
    fixed_normal = true
    normal = '0 -1 0'
    new_sideset_name = 'hx_bot'
    input = 'hx_top'
  []
[]

################################################################################
# EQUATIONS: VARIABLES, KERNELS, BOUNDARY CONDITIONS
################################################################################

scalar_systems = 'prec1 prec2 prec3 prec4 prec5 prec6'

[Problem]
  # velocity, pressure restarted, precursors are not
  allow_initial_conditions_with_restart = true
  nl_sys_names = 'nl0 ${scalar_systems}'
[]

[Physics]
  [NavierStokes]
    [Flow/salt]
      # General parameters
      compressibility = 'incompressible'
      block = 'fuel pump hx'
      initialize_variables_from_mesh_file = true

      # Variables, defined below for the Exodus restart
      velocity_variable = 'vel_x vel_y'
      pressure_variable = 'pressure'
      solve_for_dynamic_pressure = true

      # Material properties
      density = ${rho}
      dynamic_viscosity = ${mu}
      thermal_expansion = ${alpha}

      # Boussinesq parameters
      boussinesq_approximation = true
      gravity = '0 -9.81 0'
      ref_temperature = ${T_HX}

      # Boundary conditions
      wall_boundaries = 'shield_wall reflector_wall fluid_symmetry'
      momentum_wall_types = 'wallfunction wallfunction symmetry'

      # Pressure pin for incompressible flow
      pin_pressure = true
      pinned_pressure_type = average
      # pressure pin for dynamic pressure: 0
      # pressure pin for total pressure: 1e5
      pinned_pressure_value = 0

      # Numerical scheme
      # time_derivative_contributes_to_RC_coefficients = false
      momentum_advection_interpolation = 'upwind'
      mass_advection_interpolation = 'upwind'

      # Heat exchanger friction
      standard_friction_formulation = false
      friction_blocks = 'hx'
      friction_types = 'FORCHHEIMER'
      friction_coeffs = 'friction_coeff_vector'
    []
    [FluidHeatTransfer/salt]
      block = 'fuel pump hx'
      fluid_temperature_variable = 'T_fluid'
      initial_temperature = ${T_HX}
      energy_advection_interpolation = 'upwind'

      # Material properties
      thermal_conductivity = ${k}
      specific_heat = 'cp'

      # See Flow for wall boundaries
      energy_wall_types = 'heatflux heatflux heatflux'
      energy_wall_functors = '0 0 0'

      # Heat source
      external_heat_source = power_density

      ambient_convection_blocks = 'hx'
      ambient_convection_alpha = '${fparse 600 * 20e3}' # HX specifications
      ambient_temperature = ${T_HX}

      # Numerical parameters
      energy_scaling = 100
    []
    [ScalarTransport/salt]
      block = 'fuel pump hx'

      # Precursor advection, diffusion and source term
      passive_scalar_names = 'c1 c2 c3 c4 c5 c6'
      passive_scalar_coupled_source = 'fission_source c1; fission_source c2; fission_source c3;
                                       fission_source c4; fission_source c5; fission_source c6;'
      passive_scalar_coupled_source_coeff = '${beta1} ${lambda1_m}; ${beta2} ${lambda2_m};
                                             ${beta3} ${lambda3_m}; ${beta4} ${lambda4_m};
                                             ${beta5} ${lambda5_m}; ${beta6} ${lambda6_m}'

      # Numerical parameters
      passive_scalar_advection_interpolation = 'upwind'
      system_names = '${scalar_systems}'
    []
    [Turbulence/salt]
      block = 'fuel pump hx'

      fluid_heat_transfer_physics = salt
      scalar_transport_physics = salt

      # Turbulence parameters
      turbulence_handling = 'mixing-length'
      turbulent_prandtl = ${Pr_t}
      Sc_t = '${Sc_t} ${Sc_t} ${Sc_t} ${Sc_t} ${Sc_t} ${Sc_t}'
      von_karman_const = ${von_karman_const}
      mixing_length_delta = 0.1
      mixing_length_walls = 'shield_wall reflector_wall'
      mixing_length_aux_execute_on = 'initial'
    []
  []
[]

[FVICs]
  [c1]
    type = FVFunctionIC
    variable = c1
    function = 'cosine_guess'
    scaling_factor = 0.02
  []
  [c2]
    type = FVFunctionIC
    variable = c2
    function = 'cosine_guess'
    scaling_factor = 0.1
  []
  [c3]
    type = FVFunctionIC
    variable = c3
    function = 'cosine_guess'
    scaling_factor = 0.03
  []
  [c4]
    type = FVFunctionIC
    variable = c4
    function = 'cosine_guess'
    scaling_factor = 0.04
  []
  [c5]
    type = FVFunctionIC
    variable = c5
    function = 'cosine_guess'
    scaling_factor = 0.01
  []
  [c6]
    type = FVFunctionIC
    variable = c6
    function = 'cosine_guess'
    scaling_factor = 0.001
  []
  # Power density is re-initalized by a transfer from neutronics
  [power]
    type = FVFunctionIC
    variable = power_density
    function = 'cosine_guess'
    scaling_factor = '${fparse 3e9/2.81543}'
  []
  # Fission source is re-initalized by a transfer from neutronics
  [fission_source]
    type = FVFunctionIC
    variable = fission_source
    function = 'cosine_guess'
    scaling_factor = '${fparse 6.303329e+01/2.81543}'
  []
[]

[AuxVariables]
  [power_density]
    type = MooseVariableFVReal
    block = 'fuel pump hx'
  []
  [fission_source]
    type = MooseVariableFVReal
    block = 'fuel pump hx'
  []
[]

[Functions]
  # Guess to have a 3D power distribution
  [cosine_guess]
    type = ParsedFunction
    expression = 'max(0, cos(x*pi/2/1.2))*max(0, cos(y*pi/2/1.1))'
  []
[]

[FVKernels]
  [pump]
    type = INSFVBodyForce
    variable = vel_y
    functor = ${pump_force}
    block = 'pump'
    momentum_component = 'y'
  []
[]

################################################################################
# MATERIALS
################################################################################

[FunctorMaterials]
  # Most of these constants could be specified directly to the action
  [mu]
    type = ADGenericFunctorMaterial
    prop_names = 'mu'
    prop_values = '${mu}'
    block = 'fuel pump hx'
  []
  # [not_used]
  #   type = ADGenericFunctorMaterial
  #   prop_names = 'not_used'
  #   prop_values = 0
  #   block = 'shield reflector'
  # []
  [cp]
    type = ADGenericFunctorMaterial
    prop_names = 'cp'
    prop_values = '${cp}'
    block = 'fuel pump hx'
  []
  [friction_coeff_mat]
    type = ADGenericVectorFunctorMaterial
    prop_names = 'friction_coeff_vector'
    prop_values = '${friction} ${friction} ${friction}'
  []
[]

################################################################################
# EXECUTION / SOLVE
################################################################################

[Functions]
  [dts]
    type = PiecewiseConstant
    x = '0 10  100'
    y = '2 4 5'
  []
[]

[Executioner]
  type = Transient

  # Time stepping parameters
  start_time = 0.0
  end_time = 50
  # end_time will depend on the restart file chosen
  # though steady state detection can also be used
  # from _initial/no heating : 150 - 200s enough
  # from _ns/_ns_coupled/heated: 10s enough

  # [TimeStepper]
  #   # This time stepper makes the time step grow exponentially
  #   # It can only be used with proper initialization
  #   type = IterationAdaptiveDT
  #   dt = 1 # chosen to obtain convergence with first coupled iteration
  #   growth_factor = 2
  # []
  [TimeStepper]
    type = FunctionDT
    function = dts
  []
  steady_state_detection = true
  steady_state_tolerance = 1e-8
  steady_state_start_time = 10

  # Time integration scheme
  scheme = 'implicit-euler'

  # Solver parameters
  solve_type = 'NEWTON'
  line_search = 'none'

  # nonlinear solver parameters
  nl_rel_tol = 2e-8
  nl_abs_tol = 2e-8
  nl_abs_div_tol = 1e11
  nl_max_its = 15

  # linear solver parameters
  l_max_its = 50

  automatic_scaling = true
[]

# Try a direct solve. The precursor advection problem should be linear
petsc_options_iname_prec = '-pc_type -pc_factor_shift_type'
petsc_options_value_prec = 'lu NONZERO'
# petsc_options_iname_prec = '-pc_type -ksp_type'
# petsc_options_value_prec = 'lu preonly'

[Preconditioning]
  [flow]
    type = SMP
    #  solve_type = NEWTON
    trust_my_coupling = true
    full = true
    nl_sys = "nl0"
    petsc_options_iname = '-pc_type -pc_factor_shift_type -pc_factor_mat_solver_package'
    petsc_options_value = 'lu NONZERO superlu_dist'
  []
  [scalar1]
    type = SMP
    # solve_type = LINEAR
    nl_sys = "prec1"
    petsc_options_iname = ${petsc_options_iname_prec}
    petsc_options_value = ${petsc_options_value_prec}
  []
  [scalar2]
    type = SMP
    # solve_type = LINEAR
    nl_sys = "prec2"
    petsc_options_iname = ${petsc_options_iname_prec}
    petsc_options_value = ${petsc_options_value_prec}
  []
  [scalar3]
    type = SMP
    nl_sys = "prec3"
    petsc_options_iname = ${petsc_options_iname_prec}
    petsc_options_value = ${petsc_options_value_prec}
  []
  [scalar4]
    type = SMP
    # solve_type = LINEAR
    nl_sys = "prec4"
    petsc_options_iname = ${petsc_options_iname_prec}
    petsc_options_value = ${petsc_options_value_prec}
  []
  [scalar5]
    type = SMP
    # solve_type = LINEAR
    nl_sys = "prec5"
    petsc_options_iname = ${petsc_options_iname_prec}
    petsc_options_value = ${petsc_options_value_prec}
  []
  [scalar6]
    type = SMP
    # solve_type = LINEAR
    nl_sys = "prec6"
    petsc_options_iname = ${petsc_options_iname_prec}
    petsc_options_value = ${petsc_options_value_prec}
  []
[]

################################################################################
# SIMULATION OUTPUTS
################################################################################

[Outputs]
  csv = true
  hide = 'flow_hx_bot flow_hx_top min_flow_T max_flow_T'
  [restart]
    type = Exodus
    overwrite = true
  []
  # Reduce base output
  print_linear_converged_reason = true
  print_linear_residuals = true
  print_nonlinear_converged_reason = false
[]

[Postprocessors]
  [max_v]
    type = ElementExtremeValue
    variable = vel_x
    value_type = max
    block = 'fuel pump hx'
  []
  # TODO: weakly compressible, switch to mass flow rate
  [flow_hx_bot]
    type = VolumetricFlowRate
    boundary = 'hx_bot'
    vel_x = vel_x
    vel_y = vel_y
    advected_quantity = 1
  []
  [flow_hx_top]
    type = VolumetricFlowRate
    boundary = 'hx_top'
    vel_x = vel_x
    vel_y = vel_y
    advected_quantity = 1
  []
  [max_flow_T]
    type = VolumetricFlowRate
    boundary = 'hx_top'
    vel_x = vel_x
    vel_y = vel_y
    advected_quantity = 'T_fluid'
  []
  [min_flow_T]
    type = VolumetricFlowRate
    boundary = 'hx_bot'
    vel_x = vel_x
    vel_y = vel_y
    advected_quantity = 'T_fluid'
  []
  [dT]
    type = ParsedPostprocessor
    expression = '-max_flow_T / flow_hx_bot + min_flow_T / flow_hx_top'
    pp_names = 'max_flow_T min_flow_T flow_hx_bot flow_hx_top'
  []
  [total_power]
    type = ElementIntegralVariablePostprocessor
    variable = power_density
    block = 'fuel pump hx'
  []
  [total_fission_source]
    type = ElementIntegralVariablePostprocessor
    variable = fission_source
    block = 'fuel pump hx'
  []
[]
