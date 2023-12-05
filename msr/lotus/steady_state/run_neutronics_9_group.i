################################################################################
## Griffin Main Application input file                                        ##
## Steady state neutronics model                                              ##
## Neutron diffusion with delayed precursor source, no equivalence            ##
################################################################################

[Mesh]
  coord_type = 'XYZ'
  [fmg]
    type = FileMeshGenerator
    file = '../mesh/mcre_mesh.e'
  []
  [reactor_out_bdry]
    type = ParsedGenerateSideset
    input = 'fmg'
    new_sideset_name = 'reactor_out'
    combinatorial_geometry = '(y > 775) | ((y <= 775) & (x > 1150 | x < -250))'
    include_only_external_sides = true
  []
  [scaling]
    type = TransformGenerator
    input = reactor_out_bdry
    transform = 'SCALE'
    vector_value = '0.001 0.001 0.001'
  []
  [delete_bad_sideset]
    type = BoundaryDeletionGenerator
    input = 'scaling'
    boundary_names = 'reactor_out'
  []

  [repair_mesh]
    type = MeshRepairGenerator
    input = delete_bad_sideset
    fix_node_overlap = true
  []
  [recreate_outer]
    type = SideSetsFromNormalsGenerator
    input = repair_mesh
    new_boundary = 'reactor_out'
    # Dummy parameter
    normals = '1 0 0'
    tolerance = '1'
    variance = '1'
  []
  [recreate_outer_part2]
    type = ParsedGenerateSideset
    input = 'recreate_outer'
    combinatorial_geometry = 'x<=-0.24999999'
    included_subdomains = 'reactor'
    new_sideset_name = 'reactor_out'
    include_only_external_sides = true
  []
[]

[TransportSystems]
  particle = neutron
  equation_type = eigenvalue

  G = 9

  VacuumBoundary = 'wall-reflector reactor_out'

  [diff]
    scheme = CFEM-Diffusion
    n_delay_groups = 6
    external_dnp_variable = 'dnp'
    family = LAGRANGE
    order = FIRST
    fission_source_aux = true

    # For PJFNKMO
    assemble_scattering_jacobian = true
    assemble_fission_jacobian = true

    initialize_scalar_flux = true
  []
[]

[PowerDensity]
  power = 25e3
  power_density_variable = power_density
  power_scaling_postprocessor = power_scaling
  family = MONOMIAL
  order = CONSTANT
[]

[GlobalParams]
  # No displacement modeled
  # fixed_meshes = true
[]

################################################################################
# AUXILIARY SYSTEM
################################################################################

[AuxVariables]
  [tfuel]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 900.0 # in degree K
    block = 'reactor pump pipe'
  []
  [trefl]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 760.0 # in degree K
    block = 'reflector'
  []
  [c1]
    order = CONSTANT
    family = MONOMIAL
    block = 'reactor pump pipe'
  []
  [c2]
    order = CONSTANT
    family = MONOMIAL
    block = 'reactor pump pipe'
  []
  [c3]
    order = CONSTANT
    family = MONOMIAL
    block = 'reactor pump pipe'
  []
  [c4]
    order = CONSTANT
    family = MONOMIAL
    block = 'reactor pump pipe'
  []
  [c5]
    order = CONSTANT
    family = MONOMIAL
    block = 'reactor pump pipe'
  []
  [c6]
    order = CONSTANT
    family = MONOMIAL
    block = 'reactor pump pipe'
  []
  [dnp]
    order = CONSTANT
    family = MONOMIAL
    components = 6
    block = 'reactor pump pipe'
  []
[]

[AuxKernels]
  [build_dnp]
    type = BuildArrayVariableAux
    variable = dnp
    component_variables = 'c1 c2 c3 c4 c5 c6'
    execute_on = 'timestep_begin final'
  []
[]

################################################################################
# CROSS SECTIONS
################################################################################

[Materials]
  [reactor_material]
    type = CoupledFeedbackNeutronicsMaterial
    library_name = 'serpent_MCRE_xs'
    library_file = '../mgxs/serpent_MCRE_xs_new.xml'
    grid_names = 'tfuel'
    grid_variables = 'tfuel'
    plus = true
    isotopes = 'pseudo'
    densities = '1.0'
    is_meter = true
    material_id = 1
    block = 'reactor pump pipe'
  []
  [reflector_material]
    type = CoupledFeedbackNeutronicsMaterial
    library_name = 'serpent_MCRE_xs'
    library_file = '../mgxs/serpent_MCRE_xs_new.xml'
    grid_names = 'trefl'
    grid_variables = 'trefl'
    plus = true
    isotopes = 'pseudo'
    densities = '1.0'
    is_meter = true
    material_id = 2
    block = 'reflector'
  []
[]

################################################################################
# EXECUTION / SOLVE
################################################################################

[Executioner]
  type = Eigenvalue
  solve_type = PJFNKMO

  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart '
  petsc_options_value = 'hypre boomeramg 50'
  nl_abs_tol = 1e-9
  #l_max_its = 100

  free_power_iterations = 5 # important to obtain fundamental mode eigenvalue
  normalization = fission_source_integral

  # Parameters for fixed point iteration with MultiApps
  fixed_point_algorithm = picard
  fixed_point_min_its = 4
  fixed_point_max_its = 30
  fixed_point_abs_tol = 1e-3
  relaxation_factor = 0.7
[]

[Debug]
  show_var_residual_norms = true
[]

################################################################################
# POST-PROCESSORS
################################################################################
[Postprocessors]
  [power]
    type = ElementIntegralVariablePostprocessor
    variable = power_density
    execute_on = 'initial timestep_begin timestep_end transfer'
    block = 'reactor pump pipe'
  []
  [dt_limit]
    type = Receiver
    default = 0.1
  []
[]

# [MeshDivisions]
#   [blocks]
#     type = SubdomainsDivision
#   []
# []

# [VectorPostprocessors]
#   [average_fluxes]
#     type = MeshDivisionFunctorReductionVectorPostprocessor
#     # Outputs all flux-averages on a per-block and per-variable basis
#     reduction = 'average'
#     functors = 'sflux_g0 sflux_g1 sflux_g2 sflux_g3 sflux_g4 sflux_g5 sflux_g6 sflux_g7'
#     mesh_division = blocks
#   []
#   [max_fluxes]
#     type = MeshDivisionFunctorReductionVectorPostprocessor
#     # Outputs all flux-maxima on a per-block and per-variable basis
#     reduction = 'max'
#     functors = 'sflux_g0 sflux_g1 sflux_g2 sflux_g3 sflux_g4 sflux_g5 sflux_g6 sflux_g7'
#     mesh_division = blocks
#   []
# []

# Note: If you are using a modern version of BlueCrab, you can delete the next 200 lines
# and use the comment out ten or so lines above

[Postprocessors]
  [flux_0_average_reac]
    type = ElementAverageValue
    variable = sflux_g0
    block = 'reactor'
  []
  [flux_1_average_reac]
    type = ElementAverageValue
    variable = sflux_g1
    block = 'reactor'
  []
  [flux_2_average_reac]
    type = ElementAverageValue
    variable = sflux_g2
    block = 'reactor'
  []
  [flux_3_average_reac]
    type = ElementAverageValue
    variable = sflux_g3
    block = 'reactor'
  []
  [flux_4_average_reac]
    type = ElementAverageValue
    variable = sflux_g4
    block = 'reactor'
  []
  [flux_5_average_reac]
    type = ElementAverageValue
    variable = sflux_g5
    block = 'reactor'
  []
  [flux_6_average_reac]
    type = ElementAverageValue
    variable = sflux_g6
    block = 'reactor'
  []
  [flux_7_average_reac]
    type = ElementAverageValue
    variable = sflux_g7
    block = 'reactor'
  []
  [flux_0_average_ref]
    type = ElementAverageValue
    variable = sflux_g0
    block = 'reactor'
  []
  [flux_1_average_ref]
    type = ElementAverageValue
    variable = sflux_g1
    block = 'reflector'
  []
  [flux_2_average_ref]
    type = ElementAverageValue
    variable = sflux_g2
    block = 'reflector'
  []
  [flux_3_average_ref]
    type = ElementAverageValue
    variable = sflux_g3
    block = 'reflector'
  []
  [flux_4_average_ref]
    type = ElementAverageValue
    variable = sflux_g4
    block = 'reflector'
  []
  [flux_5_average_ref]
    type = ElementAverageValue
    variable = sflux_g5
    block = 'reflector'
  []
  [flux_6_average_ref]
    type = ElementAverageValue
    variable = sflux_g6
    block = 'reflector'
  []
  [flux_7_average_ref]
    type = ElementAverageValue
    variable = sflux_g7
    block = 'reflector'
  []
  [flux_0_average_reac_max]
    type = ElementExtremeValue
    variable = sflux_g0
    block = 'reactor'
  []
  [flux_1_average_reac_max]
    type = ElementExtremeValue
    variable = sflux_g1
    block = 'reactor'
  []
  [flux_2_average_reac_max]
    type = ElementExtremeValue
    variable = sflux_g2
    block = 'reactor'
  []
  [flux_3_average_reac_max]
    type = ElementExtremeValue
    variable = sflux_g3
    block = 'reactor'
  []
  [flux_4_average_reac_max]
    type = ElementExtremeValue
    variable = sflux_g4
    block = 'reactor'
  []
  [flux_5_average_reac_max]
    type = ElementExtremeValue
    variable = sflux_g5
    block = 'reactor'
  []
  [flux_6_average_reac_max]
    type = ElementExtremeValue
    variable = sflux_g6
    block = 'reactor'
  []
  [flux_7_average_reac_max]
    type = ElementExtremeValue
    variable = sflux_g7
    block = 'reactor'
  []
  [flux_0_average_ref_max]
    type = ElementExtremeValue
    variable = sflux_g0
    block = 'reactor'
  []
  [flux_1_average_ref_max]
    type = ElementExtremeValue
    variable = sflux_g1
    block = 'reflector'
  []
  [flux_2_average_ref_max]
    type = ElementExtremeValue
    variable = sflux_g2
    block = 'reflector'
  []
  [flux_3_average_ref_max]
    type = ElementExtremeValue
    variable = sflux_g3
    block = 'reflector'
  []
  [flux_4_average_ref_max]
    type = ElementExtremeValue
    variable = sflux_g4
    block = 'reflector'
  []
  [flux_5_average_ref_max]
    type = ElementExtremeValue
    variable = sflux_g5
    block = 'reflector'
  []
  [flux_6_average_ref_max]
    type = ElementExtremeValue
    variable = sflux_g6
    block = 'reflector'
  []
  [flux_7_average_ref_max]
    type = ElementExtremeValue
    variable = sflux_g7
    block = 'reflector'
  []
  [c1_average_reac]
    type = ElementAverageValue
    variable = c1
    block = 'reactor'
  []
  [c2_average_reac]
    type = ElementAverageValue
    variable = c2
    block = 'reactor'
  []
  [c3_average_reac]
    type = ElementAverageValue
    variable = c3
    block = 'reactor'
  []
  [c4_average_reac]
    type = ElementAverageValue
    variable = c4
    block = 'reactor'
  []
  [c5_average_reac]
    type = ElementAverageValue
    variable = c5
    block = 'reactor'
  []
  [c6_average_reac]
    type = ElementAverageValue
    variable = c6
    block = 'reactor'
  []
  [c1_average_pipe]
    type = ElementAverageValue
    variable = c1
    block = 'pipe pump'
  []
  [c2_average_pipe]
    type = ElementAverageValue
    variable = c2
    block = 'pipe pump'
  []
  [c3_average_pipe]
    type = ElementAverageValue
    variable = c3
    block = 'pipe pump'
  []
  [c4_average_pipe]
    type = ElementAverageValue
    variable = c4
    block = 'pipe pump'
  []
  [c5_average_pipe]
    type = ElementAverageValue
    variable = c5
    block = 'pipe pump'
  []
  [c6_average_pipe]
    type = ElementAverageValue
    variable = c6
    block = 'pipe pump'
  []
[]

################################################################################
# SIMULATION OUTPUTS
################################################################################

[Outputs]
  exodus = true
  csv = true
  checkpoint = true
  [console]
    type = Console
    show = 'power dt_limit eigenvalue power_scaling'
  []
  [restart]
    type = Exodus
    execute_on = 'final'
    file_base = 'run_neutronics_restart'
  []
  print_linear_converged_reason = false
  print_linear_residuals = false
  print_nonlinear_converged_reason = false
[]

################################################################################
# MULTIPHYSICS
################################################################################

[MultiApps]
  [ns]
    type = FullSolveMultiApp
    input_files = 'run_ns_initial.i'
    execute_on = 'timestep_end'
    no_backup_and_restore = true
    keep_solution_during_restore = true
  []
[]

[Transfers]
  [power_density]
    type = MultiAppGeneralFieldNearestLocationTransfer
    to_multi_app = ns
    source_variable = power_density
    variable = power_density
  []
  [fission_source]
    type = MultiAppGeneralFieldNearestLocationTransfer
    to_multi_app = ns
    source_variable = fission_source
    variable = fission_source
  []

  [c1]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = ns
    source_variable = 'c1'
    variable = 'c1'
  []
  [c2]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = ns
    source_variable = 'c2'
    variable = 'c2'
  []
  [c3]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = ns
    source_variable = 'c3'
    variable = 'c3'
  []
  [c4]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = ns
    source_variable = 'c4'
    variable = 'c4'
  []
  [c5]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = ns
    source_variable = 'c5'
    variable = 'c5'
  []
  [c6]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = ns
    source_variable = 'c6'
    variable = 'c6'
  []
  [T]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = ns
    source_variable = 'T'
    variable = 'tfuel'
  []
  [T_ref]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = ns
    source_variable = 'T_ref'
    variable = 'trefl'
  []
[]
