######################################################################################################
## Dynamic Multiphysics Modeling of a Flow Blockage accident in Gas-cooled Microreactor Assembly
## Griffin Dynamic Model
# If using or referring to this model, please cite as explained in
# https://mooseframework.inl.gov/virtual_test_bed/citing.html
#####################################################################################################
[Mesh]
  file = '../steady_state/Griffin_steady_state_out_cp/LATEST'
[]

[Executioner]
  type = TransientSweepUpdate

  richardson_abs_tol = 5e-6
  richardson_rel_tol = 1e-8
  richardson_max_its = 1000

  inner_solve_type = GMRes
  max_inner_its = 20

  # MultiApp fixed point iterations are handled by the
  # Richardson iteration
  fixed_point_max_its = 1
  fixed_point_min_its = 1

  cmfd_acceleration = true
  coarse_element_id = coarse_element_id
  prolongation_type = multiplicative
  max_diffusion_coefficient = 1

  end_time = 2e2
  dt = 1
[]

[Debug]
  check_boundary_coverage = false
  print_block_volume = false
  show_actions = false
[]

[AuxVariables]
  [Tf]
    # initial_condition = 873.15
    order = CONSTANT
    family = MONOMIAL
  []
[]

[Problem]
  # The restart is performed with a TransportSolutionVectorFile
  # which does not initialize Tf, so we may use an initial condition
  # when the Bison multiapp is not used
  # allow_initial_conditions_with_restart = true
[]

[TransportSystems]
  particle = neutron
  equation_type = transient

  G = 11
  VacuumBoundary = '2000 2001'
  ReflectingBoundary = '9000'

  [SN]
    scheme = DFEM-SN
    family = MONOMIAL
    order = FIRST

    AQtype = Gauss-Chebyshev
    NPolar = 2
    NAzmthl = 3
    NA = 2
    n_delay_groups = 6

    using_array_variable = true
    collapse_scattering = true
    hide_angular_flux = true
  []
[]

[PowerDensity]
  power = 225e3 # Assembly Power from NS
  power_density_variable = power_density
  integrated_power_postprocessor = integrated_power
  # Normalizes the initial condition
  power_scaling_postprocessor = power_scaling
[]

[Materials]
  [mod]
    type = CoupledFeedbackMatIDNeutronicsMaterial
    block = '10 100 102 103 200 201 300 400 401 500 600 8000 8001'
    library_file = '../ISOXML/XS_Griffin.xml'
    library_name = XS_Griffin
    isotopes = 'pseudo'
    densities = 1.0
    is_meter = true
    # power normalization
    plus = true
    dbgmat = false
    grid_names = 'Tmod'
    grid_variables = 'Tf'
  []
[]

[MultiApps]
  [bison]
    type = TransientMultiApp
    input_files = BISON_tr.i
    execute_on = 'initial timestep_end'
  []
[]

[Transfers]
  [to_sub_power_density]
    type = MultiAppGeneralFieldShapeEvaluationTransfer
    to_multi_app = bison
    variable = power_density
    source_variable = power_density
    execute_on = 'timestep_end'
    displaced_source_mesh = false
    displaced_target_mesh = false
    use_displaced_mesh = false
  []
  [from_sub_temp]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = bison
    variable = Tf
    source_variable = Tfuel
    execute_on = 'initial timestep_end'
    use_displaced_mesh = false
  []
[]

[Postprocessors]
  [scaled_power_avg]
    type = ElementAverageValue
    block = 'Fuel Fuel_tri'
    variable = power_density
    execute_on = 'initial timestep_end'
  []
  [fuel_temp_avg]
    type = ElementAverageValue
    variable = Tf
    block = 'Fuel Fuel_tri'
    execute_on = 'initial timestep_end'
  []
  [fuel_temp_max]
    type = ElementExtremeValue
    value_type = max
    variable = Tf
    block = 'Fuel Fuel_tri'
    execute_on = 'initial timestep_end'
  []
  [fuel_temp_min]
    type = ElementExtremeValue
    value_type = min
    variable = Tf
    block = 'Fuel Fuel_tri'
    execute_on = 'initial timestep_end'
  []
[]

[UserObjects]
  [ss]
    type = TransportSolutionVectorFile
    transport_system = SN
    writing = false
    execute_on = initial
    folder = '../steady_state/'
  []
[]

[Outputs]
  time_step_interval = 1
  #  [exodus]
  #    type = Exodus
  #  []
  [csv]
    type = CSV
  []
  #  [cp]
  #    type = Checkpoint
  #    time_step_interval = 25
  #  []
  checkpoint = true
  color = true
  perf_graph = true
[]
