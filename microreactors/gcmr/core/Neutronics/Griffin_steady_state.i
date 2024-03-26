######################################################################################################
## Griffin steady state Model of whole-core Gas-cooled Microreactor
# If using or referring to this model, please cite as explained in
# https://mooseframework.inl.gov/virtual_test_bed/citing.html
#####################################################################################################

[Mesh]
  [fmg]
    type = FileMeshGenerator
    file = '../MESH/Griffin_mesh_in.e'
  []

  [fmg_id]
    type = SubdomainExtraElementIDGenerator
    input = fmg
    subdomains = '10 100 101 102 103 200 201 400 401 4000 4001 40000 40001 300 301 600 602 603 604 1000 1003 19000 29000 39000 49000 59000 19003 29003 39003 49003 59003 19900 29900 39900 49900 59900 19903 29903 39903 49903 59903 1777 1773 250'
    extra_element_id_names = 'material_id'
    extra_element_ids = '803 802 802 810 806 807 807 700 700 701 701 702 702 807 807 811 811 809 807 805 805 764 764 764 764 764 764 764 764 764 764 754 754 754 754 754 754 754 754 754 754 809 809 811'
  []

  [coarse_mesh]
    type = GeneratedMeshGenerator
    dim = 3
    nx = 20
    ny = 20
    nz = 20
    xmin = -1.21
    xmax = 1.21
    ymin = -1.21
    ymax = 1.21
    zmin = 0.0
    zmax = 2.4
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
  # custom_pp = fission_source_integral
  custom_rel_tol = 1e-6
  force_fixed_point_solve = true
  cmfd_acceleration = true  # false
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
    initial_condition = 725.0
    order = CONSTANT
    family = MONOMIAL
  []
[]

[TransportSystems]
  particle = neutron
  equation_type = eigenvalue
  G = 11
  VacuumBoundary = 'top_boundary bottom_boundary side'
  ReflectingBoundary = 'cut_surf'

  [SN]
    scheme = DFEM-SN
    family = MONOMIAL
    order = FIRST
    AQtype = Gauss-Chebyshev
    NPolar = 2
    NAzmthl = 3
    NA = 2
    n_delay_groups = 6
    sweep_type = asynchronous_parallel_sweeper
    using_array_variable = true
    collapse_scattering = true
    hide_angular_flux = true
  []
[]

[GlobalParams]
  library_file = '../ISOXML/XS_Griffin.xml'
  library_name = XS_Griffin
  isotopes = 'pseudo'
  densities = 1.0
  is_meter = true
  # power normalization
  plus = true
  dbgmat = false
  grid_names = 'Tfuel'
  grid_variables = 'Tf'
[]

[PowerDensity]
  power = 20000000
  power_density_variable = power_density
  # integrated_power_postprocessor = integrated_power
[]

[Materials]
  [mod]
    type = CoupledFeedbackMatIDNeutronicsMaterial
    block = '10 100 101 102 103 200 201 400 401 4000 4001 40000 40001 300 301 600 602 603 604 1000 1003 19000 29000 39000 49000 59000 19003 29003 39003 49003 59003 19900 29900 39900 49900 59900 19903 29903 39903 49903 59903 1777 1773 250'
  []
[]

[UserObjects]
  [axial_power_inner]
    type = LayeredIntegral
    variable = power_density
    direction = z
    num_layers = 24
    block = '400 401 4000 4001 40000 40001 1000 1003'
  []
[]

[AuxKernels]
  [axial_power_inner]
    type = SpatialUserObjectAux
    variable = axial_power_inner
    execute_on = timestep_end
    user_object = axial_power_inner
  []
[]

[AuxVariables]
  [axial_power_inner]
    order = CONSTANT
    family = MONOMIAL
  []
[]

[VectorPostprocessors]
  [./axial_power_inner_elm]
    type = ElementValueSampler
    variable = axial_power_inner
    sort_by = z
    execute_on = timestep_end
  [../]
[]

[Outputs]
  csv = true
  exodus = true
  perf_graph = true
[]
