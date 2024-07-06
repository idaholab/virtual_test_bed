################################################################################
## NEAMS Micro-Reactor Application Driver                                     ##
## KRUSTY Multiphysics Steady State                                           ##
## Griffin neutronics input file (Main App)                                   ##
## DFEM-SN (2, 3) NA = 3 with CMFD acceleration                               ##
################################################################################

[Mesh]
  [fmg]
    # If you do not have a presplit mesh already, you should:
    # 1. Uncomment the other blocks
    # 2. Use the exodus file in FMG
    # 3. Comment the distributed mesh line
    # 4. Use moose to presplit the mesh
    # 5. Recover the changes and use the presplit mesh
    type = FileMeshGenerator
    type = FileMeshGenerator
    # file = '../MESH/Griffin_mesh.e'
    file = 'griffin_mesh.cpr'
  []
  # [rot]
  #   type = TransformGenerator
  #   input = fmg
  #   transform = ROTATE
  #   vector_value = '-90 0 0'
  # []
  # [id]
  #   type = SubdomainExtraElementIDGenerator
  #   input = rot
  #   subdomains = '1 2 3 4 5 6
  #                64 71 72 73
  #                8 9 10 11
  #                12 1212
  #                13 14 15 16 17 18 19
  #                20 21 22 23 24
  #                2081 2091 2101 2111 2121 2131 2141
  #                2082 2092 2102 2112 2122 2132 2142
  #                3081 3091 3101 3111 3121 3131 3141
  #                3082 3092 3102 3112 3122 3132 3142
  #                4081 4091 4101 4111 4121 4131 4141
  #                4082 4092 4102 4112 4122 4132 4142'
  #   extra_element_id_names = 'material_id'
  #   extra_element_ids ='99 17 11 15 70 18
  #                       99 6 6 60
  #                       8 5 10 40
  #                       51 52
  #                       4 20 18 40 50 14 13
  #                       6 7 12 11 9
  #                       300  310  320  330  340  350  360
  #                       301  311  321  331  341  351  361
  #                       202  212  222  232  242  252  262
  #                       203  213  223  233  243  253  263
  #                       104  114  124  134  144  154  164
  #                       105  115  125  135  145  155  165'
  # []
  # [coarse_mesh]
  #   type = GeneratedMeshGenerator
  #   dim = 3
  #   nx = 15
  #   ny = 15
  #   nz = 15
  #   xmin = -0.02
  #   xmax = 0.52
  #   ymin = -0.02
  #   ymax = 0.52
  #   zmin = -0.01
  #   zmax = 1.35
  # []
  # [assign_coarse_id]
  #   type = CoarseMeshExtraElementIDGenerator
  #   input = id
  #   coarse_mesh = coarse_mesh
  #   extra_element_id_name = coarse_element_id
  # []
  parallel_type = distributed
  displacements = 'disp_x disp_y disp_z'
[]

[AuxVariables]
  [Tf]
    initial_condition = 300
    order = CONSTANT
    family = MONOMIAL
  []
  [Ts]
    initial_condition = 300
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

[TransportSystems]
  particle = neutron
  equation_type = eigenvalue
  G = 22
  VacuumBoundary = '9527 9528 9529'
  ReflectingBoundary = '1982 1983'

  [sn]
    scheme = DFEM-SN
    family = MONOMIAL
    order = FIRST
    AQtype = Gauss-Chebyshev
    NPolar = 2
    NAzmthl = 3

    NA = 3
    sweep_type = asynchronous_parallel_sweeper
    using_array_variable = true
    collapse_scattering = true
    n_delay_groups = 6

    use_displaced_mesh = true
  []

[]

[PowerDensity]
  power = 0.01 #0.1 #1e-10 use a lower value for updated thermal model
  power_density_variable = power_density
  integrated_power_postprocessor = integrated_power
[]

[Executioner]
  type = SweepUpdate
  verbose = true

  richardson_abs_tol = 1e-10
  richardson_rel_tol = 1e-15 #1e-8
  richardson_value = eigenvalue

  richardson_max_its = 100 #1000
  inner_solve_type = GMRes # SI #GMRes
  max_inner_its = 100

  cmfd_acceleration = true
  coarse_element_id = coarse_element_id
  max_diffusion_coefficient = 10.0 # might need to be smaller  0.05 or 10
  # diffusion_eigen_solver_type = krylovshur
  diffusion_eigen_solver_type = newton
  diffusion_prec_type = lu
  prolongation_type = multiplicative

  # fixed_point_max_its = 1
  # force_fixed_point_solve = true
[]

[Materials]
  [all]
    type = CoupledFeedbackMatIDNeutronicsMaterial
    block = '1 2 3 4 5 6
         64 71 72 73
         8 9 10 11
         12 1212
         13 14 15 16 17 18 19
         20 21 22 23 24
         2081 2091 2101 2111 2121 2131 2141
         2082 2092 2102 2112 2122 2132 2142
         3081 3091 3101 3111 3121 3131 3141
         3082 3092 3102 3112 3122 3132 3142
         4081 4091 4101 4111 4121 4131 4141
         4082 4092 4102 4112 4122 4132 4142'
    library_file ='Serp_hbrid_reflector_updated.xml'
    library_name ='krusty_serpent_ANL_endf70_g22'
    isotopes = 'pseudo'
    densities = '1.0'
    grid_names = 'Tfuel Tsteel'
    grid_variables = 'Tf Ts'
    plus = 1
    is_meter = true
    dbgmat = false

    displacements = 'disp_x disp_y disp_z'
  []
[]

[Outputs]
  csv = true
  exodus = true
  [pgraph]
    type = PerfGraphOutput
    level = 2
  []
[]

[MultiApps]
  [bison]
    type = FullSolveMultiApp
    input_files = KRUSTY_BISON_THERMOMECHANICS.i
    execute_on = 'timestep_end'
    keep_solution_during_restore = true
  []
[]

[Transfers]
  [to_sub_power_density]
    type = MultiAppGeneralFieldShapeEvaluationTransfer
    to_multi_app = bison
    source_variable = power_density
    variable = power_density
    from_postprocessors_to_be_preserved = integrated_power
    to_postprocessors_to_be_preserved = total_power
  []
  [from_sub_tempf]
    type = MultiAppGeneralFieldShapeEvaluationTransfer
    from_multi_app = bison
    variable = Tf
    source_variable = Tfuel
  []
  [from_sub_tempm]
    type = MultiAppGeneralFieldShapeEvaluationTransfer
    from_multi_app = bison
    variable = Ts
    source_variable = Tsteel
  []
  [from_sub_disp_x]
    type = MultiAppGeneralFieldShapeEvaluationTransfer
    from_multi_app = bison
    variable = disp_x
    source_variable = disp_x
  []
  [from_sub_disp_y]
    type = MultiAppGeneralFieldShapeEvaluationTransfer
    from_multi_app = bison
    variable = disp_y
    source_variable = disp_y
  []
  [from_sub_disp_z]
    type = MultiAppGeneralFieldShapeEvaluationTransfer
    from_multi_app = bison
    variable = disp_z
    source_variable = disp_z
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
