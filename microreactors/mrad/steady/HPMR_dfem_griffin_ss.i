################################################################################
## NEAMS Micro-Reactor Application Driver                                     ##
## Heat Pipe Microreactor Steady State                                        ##
## Griffin Main Application input file                                        ##
## DFEM-SN (1, 3) with CMFD acceleration                                      ##
################################################################################

[Mesh]
  [fmg]
    type = FileMeshGenerator
    file = '../mesh/gold/HPMR_OneSixth_Core_meshgenerator_tri_rotate_bdry.e'
  []
  [fmg_id]
    type = SubdomainExtraElementIDGenerator
    input = fmg
    subdomains = '200 203 100 103 301 303 10 503 600 601 201 101 400 401 250'
    extra_element_id_names = 'material_id equivalence_id'
    extra_element_ids = '815 815 802 802 801 801 803 811 820 820 817 816 805 805 820;
                         815 815 802 802 801 801 803 811 820 820 817 816 805 805 820'
  []
  [coarse_mesh]
    type = GeneratedMeshGenerator
    dim = 3
    nx = 10
    ny = 10
    nz = 10
    xmin = -0.1
    xmax = 1.1
    ymin = -0.1
    ymax = 1.2
    zmin = -0.0
    zmax = 2.1
  []
  [assign_coarse_id]
    type = CoarseMeshExtraElementIDGenerator
    input = fmg_id
    coarse_mesh = coarse_mesh
    extra_element_id_name = coarse_element_id
  []
  uniform_refine = 0
[]

[Executioner]
  type = SweepUpdate

  richardson_abs_tol = 1e-6 #-8
  richardson_rel_tol = 1e-8
  richardson_value = eigenvalue

  richardson_max_its = 1000
  inner_solve_type = GMRes
  max_inner_its = 20

  fixed_point_max_its = 1
  custom_pp = fission_source_integral
  custom_rel_tol = 1e-6
  force_fixed_point_solve = true

  cmfd_acceleration = true
  coarse_element_id = coarse_element_id
  prolongation_type = multiplicative
  max_diffusion_coefficient = 1
[]

[TransportSystems]
  particle = neutron
  equation_type = eigenvalue

  G = 11
  VacuumBoundary = '10000 2000 3000'
  ReflectingBoundary = '147'

  [sn]
    scheme = DFEM-SN
    family = MONOMIAL
    order = first
    AQtype = Gauss-Chebyshev
    NPolar = 1
    NAzmthl = 3
    NA = 2
    sweep_type = asynchronous_parallel_sweeper
    using_array_variable = true
    collapse_scattering = true
    n_delay_groups = 6
  []
[]

[AuxVariables]
  [Tf]
    initial_condition = 873.15
    order = CONSTANT
    family = MONOMIAL
  []
  [Tm]
    initial_condition = 873.15
    order = CONSTANT
    family = MONOMIAL
  []
[]

[GlobalParams]
  library_file = '../isoxml/fullcore_xml_G11_endfb8_ss_tr.xml'
  library_name = fullcore_xml_G11_endfb8_ss_tr
  isotopes = 'pseudo'
  densities = 1.0
  is_meter = true
  plus = true
  dbgmat = false
  grid_names = 'Tfuel Tmod'
  grid_variables = 'Tf Tm'
[]

[Materials]
  [mod]
    type = CoupledFeedbackMatIDNeutronicsMaterial
    block = '200 203 100 103 301 303 10 503 600 601 201 101 400 401 250'
  []
[]

[PowerDensity]
  power = 345.6e3
  power_density_variable = power_density
  integrated_power_postprocessor = integrated_power
[]

[MultiApps]
  [bison]
    type = FullSolveMultiApp
    positions = '0 0 0'
    input_files = HPMR_thermo_ss.i
    execute_on = 'timestep_end'
    keep_solution_during_restore = true
  []
[]

[Transfers]
  [to_sub_power_density]
    type = MultiAppShapeEvaluationTransfer
    to_multi_app = bison
    source_variable = power_density
    variable = power_density
    from_postprocessors_to_be_preserved = integrated_power
    to_postprocessors_to_be_preserved = power_density
  []
  [from_sub_temp_fuel]
    type = MultiAppInterpolationTransfer
    direction = from_multiapp
    multi_app = bison
    variable = Tf
    source_variable = Tfuel
    execute_on = 'initial timestep_end'
    displaced_source_mesh = false
    displaced_target_mesh = false
    use_displaced_mesh = false
    num_points = 1 # interpolate with one point (~closest point)
    power = 0 # interpolate with constant function
  []
  [from_sub_temp_mod]
    type = MultiAppInterpolationTransfer
    direction = from_multiapp
    multi_app = bison
    variable = Tm
    source_variable = Tmod
    execute_on = 'initial timestep_end'
    displaced_source_mesh = false
    displaced_target_mesh = false
    use_displaced_mesh = false
    num_points = 1 # interpolate with one point (~closest point)
    power = 0 # interpolate with constant function
  []
[]

[UserObjects]
  [ss]
    type = TransportSolutionVectorFile
    transport_system = sn
    writing = true
    execute_on = final
  []
[]

[Postprocessors]
  [scaled_power_avg]
    type = ElementAverageValue
    block = 'fuel_quad fuel_tri'
    variable = power_density
    execute_on = 'initial timestep_end'
  []
  [fuel_temp_avg]
    type = ElementAverageValue
    variable = Tf
    block = 'fuel_quad fuel_tri'
    execute_on = 'initial timestep_end'
  []
  [fuel_temp_max]
    type = ElementExtremeValue
    value_type = max
    variable = Tf
    block = 'fuel_quad fuel_tri'
    execute_on = 'initial timestep_end'
  []
  [fuel_temp_min]
    type = ElementExtremeValue
    value_type = min
    variable = Tf
    block = 'fuel_quad fuel_tri'
    execute_on = 'initial timestep_end'
  []
  [mod_temp_avg]
    type = ElementAverageValue
    variable = Tm
    block = 'moderator_quad moderator_tri'
    execute_on = 'initial timestep_end'
  []
  [mod_temp_max]
    type = ElementExtremeValue
    value_type = max
    variable = Tm
    block = 'moderator_quad moderator_tri'
    execute_on = 'initial timestep_end'
  []
  [mod_temp_min]
    type = ElementExtremeValue
    value_type = min
    variable = Tm
    block = 'moderator_quad moderator_tri'
    execute_on = 'initial timestep_end'
  []
[]

[Outputs]
  csv = true
  exodus = true
  perf_graph = true
[]
