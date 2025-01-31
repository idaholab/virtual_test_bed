######################################################################################################
## Dynamic Multiphysics Modeling of Reactivity insertion accident in Gas-cooled Microreactor Assembly
## Griffin transient Model
# If using or referring to this model, please cite as explained in
# https://mooseframework.inl.gov/virtual_test_bed/citing.html
######################################################################################################
[Mesh]
  [fmg]
    type = FileMeshGenerator
    file = '../MESH/Griffin_mesh.e'
  []
  [fmg_id]
    type = SubdomainExtraElementIDGenerator
    input = fmg
    subdomains = '10 100 102 103 200 201 300 400 401 500 600 8000 8001'
    extra_element_id_names = 'material_id equivalence_id'
    extra_element_ids = '803 802 810 806 807 807 804 801 801 808 809 805 805;
                         803 802 810 806 807 807 804 801 801 808 809 805 805'
  []
  [coarse_mesh]
    type = GeneratedMeshGenerator
    dim = 3
    nx = 10
    ny = 10
    nz = 20
    xmin = -0.1
    xmax = 0.1
    ymin = -0.1
    ymax = 0.1
    zmin = 0.
    zmax = 2.
  []
  [assign_coarse_id]
    type = CoarseMeshExtraElementIDGenerator
    input = fmg_id
    coarse_mesh = coarse_mesh
    extra_element_id_name = coarse_element_id
  []
[]

[Executioner]
  type = TransientSweepUpdate

  richardson_abs_tol = 5e-6
  richardson_rel_tol = 1e-8
  richardson_max_its = 1000

  inner_solve_type = GMRes
  max_inner_its = 20

  fixed_point_max_its = 1
  fixed_point_min_its = 1

  cmfd_acceleration = true
  coarse_element_id = coarse_element_id
  prolongation_type = multiplicative
  max_diffusion_coefficient = 1

  end_time = 18.5
  dt = 0.05
[]

[Debug]
  check_boundary_coverage = false
  print_block_volume = false
  show_actions = false
[]

[AuxVariables]
  [Tf]
    initial_condition = 1186.87
    order = CONSTANT
    family = MONOMIAL
  []
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
[]

[Materials]
  [mod]
    type = CoupledFeedbackMatIDNeutronicsMaterial
    block = '10 100 102 103 200 201 400 401 500 600 8000 8001'
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
  [Air]
    type = CoupledFeedbackRoddedNeutronicsMaterial
    block = '300'
    library_file = '../ISOXML/XS_Griffin.xml'
    library_name = XS_Griffin
    rod_segment_length = '1.2 0.4'
    rod_withdrawn_direction = z
    isotopes = 'pseudo; pseudo; pseudo; pseudo'
    densities = '1.0 1.0 1.0 1.0'
    segment_material_ids = '804 809 809 805'
    front_position_function = control_rod_position
    diffusion_coefficient_scheme = user_supplied
    is_meter = true
    plus = true
    dbgmat = false
    grid_names = 'Tmod'
    grid_variables = 'Tf'
  []
[]

[Functions]
  [control_rod_position]
    type = ParsedFunction
    expression = 'if(t < 0.51, 0.2*t +1.4, 1.5)'
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
    execute_on = 'timestep_end'
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
    folder = '../RIA_steady_state/'
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
