################################################################################
## Molten Salt Fast Reactor - Euratom EVOL + Rosatom MARS Design              ##
## Transient 3D thermal hydraulics model                                      ##
## Laminar flow, addition of turbulence is WIP                                ##
################################################################################
# If using or referring to this model, please cite as explained in
# https://mooseframework.inl.gov/virtual_test_bed/citing.html

# This simulation restarts from the steady state multiphysics coupled
# calculation Exodus output for the Pronghorn input. This can be re-generated
# in that folder by running run_neutronics.i with Griffin and Pronghorn
# coupled.

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
  [restart]
    type = FileMeshGenerator
    use_for_exodus_restart = true
    file = '../steady/restart_multisys/multiphysics_out_ns0_restart.e'
  []
  [add_pump_in]
    type = ParsedGenerateSideset
    input = 'restart'
    combinatorial_geometry = 'x>-1e6'
    included_subdomains = 'pump'
    included_neighbors = 'fuel'
    normal = '0 1 0'
    new_sideset_name = 'pump_in'
  []
[]

################################################################################
# EQUATIONS: VARIABLES, KERNELS, BOUNDARY CONDITIONS
################################################################################

scalar_systems = 'prec1 prec2 prec3 prec4 prec5 prec6'

[Problem]
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
      energy_advection_interpolation = 'upwind'
      initialize_variables_from_mesh_file = true

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
    []
    [ScalarTransport/salt]
      block = 'fuel pump hx'
      passive_scalar_advection_interpolation = 'upwind'
      initialize_variables_from_mesh_file = true
      system_names = '${scalar_systems}'

      # Precursor advection, diffusion and source term
      passive_scalar_names = 'c1 c2 c3 c4 c5 c6'
      passive_scalar_coupled_source = 'fission_source c1; fission_source c2; fission_source c3;
                                       fission_source c4; fission_source c5; fission_source c6;'
      passive_scalar_coupled_source_coeff = '${beta1} ${lambda1_m}; ${beta2} ${lambda2_m};
                                             ${beta3} ${lambda3_m}; ${beta4} ${lambda4_m};
                                             ${beta5} ${lambda5_m}; ${beta6} ${lambda6_m}'
    []
    [Turbulence/salt]
      block = 'fuel pump hx'

      fluid_heat_transfer_physics = salt
      scalar_transport_physics = salt

      # Turbulence parameters
      turbulence_handling = 'mixing-length'
      turbulent_prandtl = ${Pr_t}
      passive_scalar_schmidt_number = '${Sc_t} ${Sc_t} ${Sc_t} ${Sc_t} ${Sc_t} ${Sc_t}'
      von_karman_const = ${von_karman_const}
      mixing_length_delta = 0.1
      mixing_length_walls = 'shield_wall reflector_wall'
      mixing_length_aux_execute_on = 'initial'
    []
  []
[]

[AuxVariables]
  [power_density]
    type = MooseVariableFVReal
    block = 'fuel pump hx'
    initial_from_file_var = 'power_density'
  []
  [fission_source]
    type = MooseVariableFVReal
    initial_from_file_var = 'fission_source'
  []
[]

[FVKernels]
  [pump]
    type = INSFVBodyForce
    variable = vel_y
    functor = ${pump_force}
    block = 'pump'
    momentum_component = 'y'
    rhie_chow_user_object = 'ins_rhie_chow_interpolator'
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
# PUMP COASTDOWN PARAMETERS
################################################################################

[Functions]
  [pump_fun]
    type = PiecewiseConstant
    # Transient starts by pump percent reduction on second line
    xy_data = '0.0 1
               2.0 0.5'
    direction = 'left'
  []
[]

[Controls]
  [pump_control]
    type = RealFunctionControl
    parameter = 'FVKernels/pump/scaling_factor'
    function = 'pump_fun'
    execute_on = 'initial timestep_begin'
  []
[]

################################################################################
# EXECUTION / SOLVE
################################################################################

[Executioner]
  type = Transient

  # Time stepping parameters
  # The time step is imposed by the neutronics app
  start_time = 0.0
  end_time = 1e10
  dt = 10

  # Solver parameters
  solve_type = 'NEWTON'
  petsc_options_iname = '-pc_type -pc_factor_shift_type -ksp_gmres_restart -pc_factor_mat_solver_package'
  petsc_options_value = 'lu NONZERO 50 superlu_dist'
  line_search = 'none'

  # Time integration scheme
  scheme = 'implicit-euler'

  nl_rel_tol = 1e-9
  nl_abs_tol = 2e-8
  nl_max_its = 15
  l_max_its = 50

  automatic_scaling = true
  # resid_vs_jac_scaling_param = 1
[]

################################################################################
# SIMULATION OUTPUTS
################################################################################

[Outputs]
  exodus = true
  csv = true
  hide = 'flow_hx_bot flow_hx_top min_flow_T max_flow_T'
  # Reduce base output
  print_linear_converged_reason = false
  print_linear_residuals = false
  print_nonlinear_converged_reason = false
[]

[Postprocessors]
  [max_v]
    type = ElementExtremeValue
    variable = vel_x
    value_type = max
    block = 'fuel pump hx'
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [p_drop]
    type = PressureDrop
    pressure = pressure
    upstream_boundary = 'pump_in'
    downstream_boundary = 'hx_out'
    boundary = 'hx_out pump_in'
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [mdot]
    type = VolumetricFlowRate
    boundary = 'hx_top'
    vel_x = vel_x
    vel_y = vel_y
    advected_quantity = ${rho}
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
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [total_fission_source]
    type = ElementIntegralVariablePostprocessor
    variable = fission_source
    block = 'fuel pump hx'
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [pump]
    type = FunctionValuePostprocessor
    function = 'pump_fun'
    execute_on = 'INITIAL TIMESTEP_END'
  []
[]
