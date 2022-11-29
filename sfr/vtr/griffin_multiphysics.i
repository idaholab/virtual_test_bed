# ==============================================================================
# Model description
# Application : Griffin
# ------------------------------------------------------------------------------
# Idaho Falls, INL, June 23rd, 2022
# Author(s): Nicolas Martin
# ==============================================================================
# - VTR GRIFFIN neutronics input
# - MasterApp
# ==============================================================================
# - The Model has been built based on [1-2].
# ------------------------------------------------------------------------------
# [1] Heidet, F. and Roglans-Ribas, J. Core design activities of the
#       versatile test reactor -- conceptual phase. EPJ Web Conf. 247(2021)
#       01010. doi:10.1051/epjconf/202124701010.
#       URL https://doi.org/10.1051/epjconf/202124701010.
# ==============================================================================
# MODEL PARAMETERS
# ==============================================================================

# State ------------------------------------------------------------------------
# multi-physics
# Power ------------------------------------------------------------------------

# ==============================================================================
# GLOBAL PARAMETERS
# ==============================================================================
[GlobalParams]
  is_meter = true
  grid_names = 'tfuel tcool cr'
  grid_variables = 'tfuel tcool cr'
  library_file = 'xs/vtr_xs.xml'
  library_name = 'vtr_xs'
  isotopes = 'pseudo'
  densities = '1.0'
[]

# ==============================================================================
# GEOMETRY AND MESH
# ==============================================================================
[Mesh]
  [fmg]
    type = FileMeshGenerator
    file = mesh/vtr_core.e # Y-axis = vertical direction for consistency with BISON tensor mechanics RZ model
    exodus_extra_element_integers = 'equivalence_id material_id'
  []
  [eqvid]
    type = ExtraElementIDCopyGenerator
    input = fmg
    source_extra_element_id = equivalence_id
    target_extra_element_ids = 'equivalence_id'
  []
  parallel_type = replicated
  displacements = 'disp_x disp_y disp_z'
[]

[Equivalence]
  type = SPH
  transport_system = CFEM-Diffusion
  equivalence_library = 'sph/vtr_sph.xml'
  library_name = 'vtr_xs'
  compute_factors = false
  equivalence_grid_names  = 'tfuel tcool cr'
[]

# ==============================================================================
# VARIABLES AND KERNELS
# ==============================================================================
[Variables]
[]

[Kernels]
[]

# ==============================================================================
# AUXVARIABLES AND AUXKERNELS
# ==============================================================================
[AuxVariables]
  [tfuel]
    initial_condition = 900.
  []
  [tcool]
   initial_condition = 700.
  []
  [disp_x] # from grid plate expansion
    initial_condition = 0
  []
  [disp_z]  # from grid plate expansion
    initial_condition = 0
  []
  [disp_y] # from fuel expansion
    initial_condition = 0
  []
  [cr]
   family = MONOMIAL
   order = CONSTANT
   initial_condition = 0.
  []
[]

# ==============================================================================
# INITIAL CONDITIONS AND FUNCTIONS
# ==============================================================================
[ICs]
[]

[Functions]
  [cr_withdrawal]
    type  = ConstantFunction
    value = 1.9183 # 1.9183 = fully out, 0.876 = fully in
  []
[]

# ==============================================================================
# MATERIALS AND USER OBJECTS
# ==============================================================================
[Materials]
  [fuel]
    type = CoupledFeedbackMatIDNeutronicsMaterial
    block = 1
    plus = 1
    displacements = 'disp_x disp_y disp_z'
  []
  [refl_shield_sr] # reflector, shield, SR assemblies
    type = CoupledFeedbackMatIDNeutronicsMaterial
    block = 2
    plus = 0
    displacements = 'disp_x disp_y disp_z'
  []
  [control_rods] # control rods modeled via RoddedNeutronicsMaterial
    type = CoupledFeedbackRoddedNeutronicsMaterial
    block = 3
    segment_material_ids = '115 116 115' # 115 = non-abs, 116=abs
    rod_segment_length = 1.0424
    front_position_function = cr_withdrawal
    rod_withdrawn_direction = y # Y-axis is the one vertical
    isotopes = 'pseudo; pseudo; pseudo'
    densities='1.0 1.0 1.0'
    plus = 0
    displacements = 'disp_x disp_y disp_z'
  []
[]

[PowerDensity]
  power = 300e6
  power_density_variable = power_density  # name of AuxVariable to be created
  integrated_power_postprocessor = integrated_power
  power_scaling_postprocessor = power_scaling
  family = MONOMIAL
  order = CONSTANT
[]

[UserObjects]
  [power_density1_UO]
    type = NearestPointLayeredAverage
    block = 1
    variable = power_density
    direction = y
    num_layers = 40
    points_file = coordinates_orifice_1.txt
    execute_on = TIMESTEP_END
  []
  [power_density2_UO]
    type = NearestPointLayeredAverage
    block = 1
    variable = power_density
    direction = y
    num_layers = 40
    points_file = coordinates_orifice_2.txt
    execute_on = TIMESTEP_END
  []
  [power_density3_UO]
    type = NearestPointLayeredAverage
    block = 1
    variable = power_density
    direction = y
    num_layers = 40
    points_file = coordinates_orifice_3.txt
    execute_on = TIMESTEP_END
  []
[]

# ==============================================================================
# BOUNDARY CONDITIONS
# ==============================================================================
[BCs]
[]

# ==============================================================================
# TRANSPORT SYSTEMS
# ==============================================================================
[TransportSystems]
  particle = neutron
  equation_type = eigenvalue
  G = 6
  VacuumBoundary = '1 2 3'
  [CFEM-Diffusion]
    scheme = CFEM-Diffusion
    n_delay_groups = 6
    family = LAGRANGE
    order = FIRST
    use_displaced_mesh = true
    assemble_scattering_jacobian = true
    assemble_fission_jacobian = true
  []
[]

# ==============================================================================
# EXECUTION PARAMETERS
# ==============================================================================
[Executioner]
  automatic_scaling = True
  type = Eigenvalue
  solve_type = 'PJFNKMO'
  constant_matrices = true
  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart'
  petsc_options_value = 'hypre boomeramg 100'
  free_power_iterations = 4

  nl_abs_tol = 1e-8
  nl_rel_tol = 1e-7
  #fixed_point specific

  fixed_point_force_norms = true
  fixed_point_abs_tol = 1e-8
  fixed_point_rel_tol = 1e-7
  fixed_point_max_its = 20
  accept_on_max_fixed_point_iteration = true
[]

# ==============================================================================
# MULTIAPPS AND TRANSFER
# ==============================================================================

[MultiApps]
  #one BISON/SAM channel per orifice - currently 3 zones
  [bison_1]
    type = FullSolveMultiApp
    app_type = BlueCrabApp
    positions_file = 'coordinates_orifice_1.txt'
    input_files = bison_thermal_only.i
    execute_on = 'TIMESTEP_END'
    max_procs_per_app = 1
    output_in_position = true
    #no_backup_and_restore = true
    cli_args = "MultiApps/sam/cli_args='m_dot_in=29.8'"
  []
  [bison_2]
    type = FullSolveMultiApp
    app_type = BlueCrabApp
    positions_file = 'coordinates_orifice_2.txt'
    input_files = bison_thermal_only.i
    execute_on = 'TIMESTEP_END'
    max_procs_per_app = 1
    output_in_position = true
    #no_backup_and_restore = true
    cli_args = "MultiApps/sam/cli_args='m_dot_in=23.2'"
  []
  [bison_3]
    type = FullSolveMultiApp
    app_type = BlueCrabApp
    positions_file = 'coordinates_orifice_3.txt'
    input_files = bison_thermal_only.i
    execute_on = 'TIMESTEP_END'
    max_procs_per_app = 1
    output_in_position = true
    #no_backup_and_restore = true
    cli_args = "MultiApps/sam/cli_args='m_dot_in=15.9'"
  []
  [core_support_plate]
    type = FullSolveMultiApp
    app_type = BlueCrabApp
    positions = '0 0 0'
    input_files = core_support_plate_3d.i
    execute_on = 'INITIAL' # no need for other calls - since tinlet is fixed only one update of the XS required
    max_procs_per_app = 1
    output_in_position = true
    #no_backup_and_restore = true
  []
[]

[Transfers]
  # master -> sub-app
  #-----------------------
  # power_density to BISON
  #-----------------------
  [pdens_to_bison_1]
    type = MultiAppProjectionTransfer
    to_multi_app = bison_1
    source_variable = power_density
    variable = power_density
  []
  [pdens_to_bison_2]
    type = MultiAppProjectionTransfer
    to_multi_app = bison_2
    source_variable = power_density
    variable = power_density
  []
  [pdens_to_bison_3]
    type = MultiAppProjectionTransfer
    to_multi_app = bison_3
    source_variable = power_density
    variable = power_density
  []

  # sub-app -> master
  #------------------
  # tfuel from BISON
  #------------------
  [tfuel_from_bison_1]
    type = MultiAppGeometricInterpolationTransfer
    from_multi_app = bison_1
    source_variable = tfuel
    variable = tfuel
  []
  [tfuel_from_bison_2]
    type = MultiAppGeometricInterpolationTransfer
    from_multi_app = bison_2
    source_variable = tfuel
    variable = tfuel
  []
  [tfuel_from_bison_3]
    type = MultiAppGeometricInterpolationTransfer
    from_multi_app = bison_3
    source_variable = tfuel
    variable = tfuel
  []
  #------------------
  # tcool from BISON/SAM
  #------------------
  [tcool_from_bison_1]
    type = MultiAppGeometricInterpolationTransfer
    from_multi_app = bison_1
    source_variable = tcool
    variable = tcool
  []
  [tcool_from_bison_2]
    type = MultiAppGeometricInterpolationTransfer
    from_multi_app = bison_2
    source_variable = tcool
    variable = tcool
  []
  [tcool_from_bison_3]
    type = MultiAppGeometricInterpolationTransfer
    from_multi_app = bison_3
    source_variable = tcool
    variable = tcool
  []
  #------------------
  # axial expansion = vertical displacements disp_y
  #------------------
  [disp_y_from_bison_1]
    type = MultiAppGeometricInterpolationTransfer
    from_multi_app = bison_1
    source_variable = disp_y
    variable = disp_y
  []
  [disp_y_from_bison_2]
    type = MultiAppGeometricInterpolationTransfer
    from_multi_app = bison_2
    source_variable = disp_y
    variable = disp_y
  []
  [disp_y_from_bison_3]
    type = MultiAppGeometricInterpolationTransfer
    from_multi_app = bison_3
    source_variable = disp_y
    variable = disp_y
  []

  #------------------
  # Radial expansion = horizontal displacements disp_x, disp_z from core_support_plate
  #------------------
  [disp_x_from_core_support_plate]
    type = MultiAppNearestNodeTransfer
    from_multi_app = core_support_plate
    source_boundary = 'plateTop'
    source_variable = disp_x
    variable = disp_x
    fixed_meshes = true
  []
  [disp_z_from_core_support_plate]
    type = MultiAppNearestNodeTransfer
    from_multi_app = core_support_plate
    source_boundary = 'plateTop'
    source_variable = disp_z
    variable = disp_z
    fixed_meshes = true
  []
  [bison_reporter_1]
    type = MultiAppReporterTransfer
    to_reporters =   'max_tfuel_r/value max_tclad_r/value max_tcool_r/value max_thcond_r/value'
    from_reporters = 'max_tfuel/value max_tclad/value max_tcool/value max_thcond/value'
    from_multi_app = bison_1
    subapp_index = 0
  []
[]

# ==============================================================================
# RESTART
# ==============================================================================
[RestartVariables]
[]

# ==============================================================================
# POSTPROCESSORS DEBUG AND OUTPUTS
# ==============================================================================
[Postprocessors]
  [avg_tfuel]
    type = ElementAverageValue
    variable = tfuel
    block = 1
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [max_tfuel]
    type = ElementExtremeValue
    variable = tfuel
    block = 1
    value_type = max
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [min_tfuel]
    type = ElementExtremeValue
    variable = tfuel
    block = 1
    value_type = min
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [avg_tcool]
    type = ElementAverageValue
    variable = tcool
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [max_tcool]
    type = ElementExtremeValue
    variable = tcool
    value_type = max
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [min_tcool]
    type = ElementExtremeValue
    variable = tcool
    value_type = min
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [ptot]
    type = ElementIntegralVariablePostprocessor
    variable = power_density
    execute_on = ' INITIAL TIMESTEP_END'
  []
  [disp_x_max]
    type = ElementExtremeValue
    variable = disp_x
    value_type = max
    execute_on = ' INITIAL TIMESTEP_END'
    use_displaced_mesh = true
  []
  [disp_y_max]
    type = ElementExtremeValue
    variable = disp_y
    value_type = max
    execute_on = ' INITIAL TIMESTEP_END'
    use_displaced_mesh = true
  []
  [disp_z_max]
    type = ElementExtremeValue
    variable = disp_z
    value_type = max
    execute_on = ' INITIAL TIMESTEP_END'
    use_displaced_mesh = true
  []
  [max_tfuel_r]
    type = Receiver
  []
  [max_tclad_r]
    type = Receiver
  []
  [max_tcool_r]
    type = Receiver
  []
  [max_thcond_r]
    type = Receiver
  []
[]

[Debug]
[]

[Outputs]
  exodus = true
  csv = true
  perf_graph = true
[]
