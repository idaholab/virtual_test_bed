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
  type = SweepUpdate

  richardson_abs_tol = 1e-8
  richardson_rel_tol = 1e-8
  richardson_value = eigenvalue

  richardson_max_its = 1000
  inner_solve_type = GMRes
  max_inner_its = 20

  fixed_point_max_its = 1
  custom_pp = fission_source_integral
  custom_rel_tol = 1e-6
  force_fixed_point_solve = true

  cmfd_acceleration = true #false
  coarse_element_id = coarse_element_id
  cmfd_eigen_solver_type = newton
  prolongation_type = multiplicative
  max_diffusion_coefficient = 1
[]

[Debug]
  check_boundary_coverage = false
  print_block_volume = false
  show_actions = false
[]

[AuxVariables]
  [Tf]
    initial_condition = 873.15
    order = CONSTANT
    family = MONOMIAL
  []
[]

[TransportSystems]
  particle = neutron
  equation_type = eigenvalue

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
    type = FullSolveMultiApp
    input_files = BISON.i
    execute_on = 'timestep_end'
    keep_solution_during_restore = true
  []
[]

[Transfers]
  [to_sub_power_density]
    type = MultiAppProjectionTransfer
    direction = to_multiapp
    multi_app = bison
    variable = power_density
    source_variable = power_density
    execute_on = 'timestep_end'
    displaced_source_mesh = false
    displaced_target_mesh = false
    use_displaced_mesh = false
  []
  [from_sub_temp]
    type = MultiAppInterpolationTransfer
    direction = from_multiapp
    multi_app = bison
    variable = Tf
    source_variable = Tfuel
    execute_on = 'timestep_end'
    use_displaced_mesh = false
    num_points = 1 # interpolate with one point (~closest point)
    power = 0 # interpolate with constant function
  []
[]

[UserObjects]
  [ss]
    type = TransportSolutionVectorFile
    transport_system = SN
    writing = true
    execute_on = final
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

[Outputs]
  interval = 1
  [exodus]
    type = Exodus
  []
  [csv]
    type = CSV
  []
  color = true
  perf_graph = true
[]
