################################################################################
## NEAMS Micro-Reactor Application Driver                                     ##
## Heat Pipe Microreactor Steady State                                        ##
## Griffin Main Application input file                                        ##
## DFEM-SN (1, 3) NA=2 with CMFD acceleration                                 ##
## FY26 Summer Update for Solid Mechanics Implementation                      ##
################################################################################

fuel_blocks = 'fuel_tri fuel_quad'
air_blocks = 'air_gap_quad air_gap_tri outer_shield'
b4c_blocks = 'B4C'
mono_blocks = 'monolith'
mod_clad_blocks = 'mod_ss'
yh_blocks = 'moderator_quad moderator_tri'
mod_blocks = '${yh_blocks} ${mod_clad_blocks}'
ref_blocks = 'reflector_quad reflector_tri'
hp_blocks = 'heat_pipes_quad heat_pipes_tri hp_ss'

non_hp_blocks = '${fuel_blocks} ${air_blocks} ${b4c_blocks} ${mono_blocks} ${mod_blocks} ${ref_blocks}'
non_hp_fuel_blocks = '${air_blocks} ${b4c_blocks} ${mono_blocks} ${mod_blocks} ${ref_blocks}'
non_hp_yh_blocks = '${fuel_blocks} ${air_blocks} ${b4c_blocks} ${mono_blocks} ${mod_clad_blocks} ${ref_blocks}'

[Mesh]
  [fmg]
    type = FileMeshGenerator
    file = '../mesh/gold/HPMR_OneSixth_Core_meshgenerator_tri.e'
  []
  [ps1]
    type = ParsedGenerateSideset
    input = fmg
    combinatorial_geometry = '1'
    new_sideset_name = 'side_y'
    included_boundaries = '147'
    normal = '-1 0 0'
  []
  [ps2]
    type = ParsedGenerateSideset
    input = ps1
    combinatorial_geometry = '1'
    new_sideset_name = 'side_xy'
    included_boundaries = '147'
    normal = '1 ${fparse -sqrt(3)} 0'
  []
  [fmg_id]
    type = SubdomainExtraElementIDGenerator
    input = ps2
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
    nz = 20
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
  parallel_type = distributed
  displacements = 'disp_x disp_y disp_z'
[]

[Executioner]
  type = SweepUpdate

  richardson_abs_tol = 1e-4 #-8
  richardson_rel_tol = 1e-4 #-9
  richardson_value = eigenvalue

  richardson_max_its = 1000
  inner_solve_type = GMRes
  max_inner_its = 20

  fixed_point_max_its = 1
  custom_pp = eigenvalue
  custom_rel_tol = 1e-4
  force_fixed_point_solve = true

  cmfd_acceleration = true
  diffusion_eigen_solver_type = krylovshur
  coarse_element_id = coarse_element_id
  prolongation_type = multiplicative
  max_diffusion_coefficient = 0.05
  verbose = true
  debug_richardson = true
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
    use_displaced_mesh = true
    attempt_using_sweeper_for_dg_kernels = false
  []
[]

[AuxVariables]
  [Tf]
    initial_condition = 873.15
    order = CONSTANT
    family = MONOMIAL
  []
  [nH]
    initial_condition = 1.94
    order = CONSTANT
    family = MONOMIAL
  []
  [disp_x]
  []
  [disp_y]
  []
  [disp_z]
  []
[]

[AuxKernels]
  [hp_Tf]
    type = SpatialUserObjectAux
    variable = Tf
    block = ${hp_blocks}
    user_object = Tf_avg
  []
  [hp_nH]
    type = SpatialUserObjectAux
    variable = nH
    block = ${hp_blocks}
    user_object = nH_avg
  []
[]

[UserObjects]
  [Tf_avg]
    type = LayeredAverage
    variable = Tf
    direction = z
    num_layers = 100
    block = ${non_hp_fuel_blocks}
    execute_on = 'LINEAR TIMESTEP_END'
  []
  [nH_avg]
    type = LayeredAverage
    variable = nH
    direction = z
    num_layers = 100
    block = ${non_hp_yh_blocks}
    # execute_on = 'LINEAR TIMESTEP_END'
    # We probably do not need to do it at every linear iteration
    execute_on = 'TIMESTEP_BEGIN'
  []
[]

[GlobalParams]
  library_file = 'fullcore_xml_G11_endfb8_ss_tr.xml'
  library_name = fullcore_xml_G11_endfb8_ss_tr
  isotopes = 'pseudo'
  densities = 1.0
  is_meter = true
  plus = true
  dbgmat = false
  grid_names = 'Tfuel' # Hdens - SWIFT
  grid_variables = 'Tf' # nH - SWIFT
[]

[Materials]
  [mod]
    type = CoupledFeedbackMatIDNeutronicsMaterial
    block = '200 203 100 103 301 303 10 503 600 601 201 101 400 401 250'
    displacements = 'disp_x disp_y disp_z'
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
    app_type = BisonApp
    positions = '0 0 0'
    input_files = K-HPMR_BISON.i
    execute_on = 'timestep_end'
  []
[]

[Transfers]
  [to_sub_power_density]
    type = MultiAppGeneralFieldShapeEvaluationTransfer
    to_multi_app = bison
    source_variable = power_density
    variable = power_density
    from_postprocessors_to_be_preserved = integrated_power
    to_postprocessors_to_be_preserved = power
  []
  [from_sub_temp_fuel]
    type = MultiAppGeneralFieldShapeEvaluationTransfer
    from_multi_app = bison
    variable = Tf
    source_variable = Tfuel
    execute_on = 'initial timestep_end'
    to_blocks = ${non_hp_blocks}
  []
  [from_bison_dispx]
    type = MultiAppGeneralFieldShapeEvaluationTransfer
    from_multi_app = bison
    variable = disp_x
    source_variable = disp_x_trans
    execute_on = 'initial timestep_end'
  []   
  [from_bison_dispy]
    type = MultiAppGeneralFieldShapeEvaluationTransfer
    from_multi_app = bison
    variable = disp_y
    source_variable = disp_y_trans
    execute_on = 'initial timestep_end'
  []    
  [from_bison_dispz]
    type = MultiAppGeneralFieldShapeEvaluationTransfer
    from_multi_app = bison
    variable = disp_z
    source_variable = disp_z
    execute_on = 'initial timestep_end'
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
  [pp_nH_avg]
    type = ElementAverageValue
    variable = nH
    block = 'moderator_quad moderator_tri'
    execute_on = 'initial timestep_end'
  []
  [pp_nH_max]
    type = ElementExtremeValue
    value_type = max
    variable = nH
    block = 'moderator_quad moderator_tri'
    execute_on = 'initial timestep_end'
  []
  [pp_nH_min]
    type = ElementExtremeValue
    value_type = min
    variable = nH
    block = 'moderator_quad moderator_tri'
    execute_on = 'initial timestep_end'
  []
[]

[Outputs]
  csv = true
  checkpoint = true
  [Exo]
    type = Exodus
    execute_on = 'FINAL'
  []
  perf_graph = true
[]
