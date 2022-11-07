# ==============================================================================
# Symmetric Sector Bowing - Linear Thermal Gradient (IAEA VP3A)
# Tensor Mechanics and Contact solve of IAEA Verification Problem 3A
# 3D Hexagonal assembly single duct mechanical simultation
# ------------------------------------------------------------------------------
# Argonne National Laboratory, 10/2022
# Author(s): Nicholas Wozniak
# ==============================================================================

[GlobalParams]
  order = FIRST
  family = LAGRANGE
  displacements = 'disp_x disp_y disp_z'
[]

[Mesh]
  file = iaea_vp3a_symmetric_mesh.e
  patch_update_strategy = auto
  patch_size = 20
  partitioner = centroid
  centroid_partitioner_direction = z
[]

[Problem]
  type = ReferenceResidualProblem
  extra_tag_vectors = 'ref'
  reference_vector = 'ref'
  group_variables = 'disp_x disp_y disp_z'
  acceptable_multiplier = 10
  acceptable_iterations = 10
[]

[Variables]
  [disp_x]
  []
  [disp_y]
  []
  [disp_z]
  []
[]

[Functions]
  [temp_func]
    type = ParsedFunction
    #At center of wall, y=+-0.075
    #T varies across the cross-section from 500 to 550, ramps up to that from z=1.5 to 2.5
    value = '400+if(z>2.5,t*(125-25/.075*y*t),if(z>1.5,t*(z-1.5)/1.0*(125-25/.075*y*t),0))'
  []
[]

[AuxVariables]
  [temp]
    initial_condition = 400
  []
[]

[AuxKernels]
  [tfunc]
    type = FunctionAux
    function = temp_func
    block = 1
    variable = temp
  []
[]

[BCs]
  [no_x_bot]
    type = DirichletBC
  variable = disp_x
    boundary = 1001
    value = 0.0
  []
  [no_y_bot]
    type = DirichletBC
  variable = disp_y
    boundary = 1001
    value = 0.0
  []
  [no_z_bot]
    type = DirichletBC
    variable = disp_z
    boundary = 1001
    value = 0.0
  []
  [no_x_sym]
    type = DirichletBC
    variable = disp_x
    boundary = 1000
    value = 0.0
  []
[]

[Modules]
  [TensorMechanics]
    [Master]
      [all]
        strain = FINITE
        volumetric_locking_correction = true
        eigenstrain_names = thermal_expansion
        decomposition_method = EigenSolution
        add_variables = true
        generate_output = 'vonmises_stress'
        temperature = temp
        use_finite_deform_jacobian = true
        extra_vector_tags = 'ref'
      []
    []
  []
[]

[Materials]
  [elastic_tensor]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 1.7e11
    poissons_ratio = 0.3
    block = '1 3 10 11'
  []
  [stress]
    type = ComputeFiniteStrainElasticStress
    block = '1 3 10 11'
  []
  [thermal_strain]
    type = ComputeThermalExpansionEigenstrain
    thermal_expansion_coeff = 18e-6
    temperature = temp
    stress_free_temperature = 400
    eigenstrain_name = thermal_expansion
    block = '1 3 10 11'
  []
[]

[Contact]
  [aclp_1_3]
    primary = 'ACLP1_3'
    secondary = 'ACLP3_1'
    model = frictionless
    formulation = penalty
    normalize_penalty = true
    penalty = 1e10
    tangential_tolerance = 1.0e-3
    normal_smoothing_distance = 0.1
  []
  [aclp_3_10]
    primary = 'ACLP3_10'
    secondary = 'ACLP10_3'
    model = frictionless
    formulation = penalty
    normalize_penalty = true
    penalty = 1e10
    tangential_tolerance = 1.0e-3
    normal_smoothing_distance = 0.1
  []
  [aclp_3_11]
    primary = 'ACLP3_11'
    secondary = 'ACLP11_3'
    model = frictionless
    formulation = penalty
    normalize_penalty = true
    penalty = 1e10
    tangential_tolerance = 1.0e-3
    normal_smoothing_distance = 0.1
  []
  [tlp_1_3]
    primary = 'TLP1_3'
    secondary = 'TLP3_1'
    model = frictionless
    formulation = penalty
    normalize_penalty = true
    penalty = 1e10
    tangential_tolerance = 1.0e-3
    normal_smoothing_distance = 0.1
  []
  [tlp_3_10]
    primary = 'TLP3_10'
    secondary = 'TLP10_3'
    model = frictionless
    formulation = penalty
    normalize_penalty = true
    penalty = 1e10
    tangential_tolerance = 1.0e-3
    normal_smoothing_distance = 0.1
  []
  [tlp_3_11]
    primary = 'TLP3_11'
    secondary = 'TLP11_3'
    model = frictionless
    formulation = penalty
    normalize_penalty = true
    penalty = 1e10
    tangential_tolerance = 1.0e-3
    normal_smoothing_distance = 0.1
  []
[]

[Preconditioning]
  [SMP]
    type = SMP
    full = true
  []
[]

[Executioner]
  automatic_scaling = true
  solve_type = 'PJFNK'

  type = Transient
  petsc_options = '-ksp_snes_ew'
  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
  petsc_options_value = 'lu       superlu_dist'
  line_search = none

  l_max_its = 25
  nl_max_its = 50
  nl_rel_tol = 1e-8
  nl_abs_tol = 1e-10

  start_time = 0.0
  end_time = 1
  dt = 0.1

  dtmax = 1
  dtmin = 0.01
[]

[Postprocessors]
  [disp_x_1]
    type = SideAverageValue
    variable = disp_x
    boundary = 2001
  []
  [disp_y_1]
    type = SideAverageValue
    variable = disp_y
    boundary = 2001
  []
  [disp_x_3]
    type = SideAverageValue
    variable = disp_x
    boundary = 2003
  []
  [disp_y_3]
    type = SideAverageValue
    variable = disp_y
    boundary = 2003
  []
  [disp_x_10]
    type = SideAverageValue
    variable = disp_x
    boundary = 2010
  []
  [disp_y_10]
    type = SideAverageValue
    variable = disp_y
    boundary = 2010
  []
  [disp_x_11]
    type = SideAverageValue
    variable = disp_x
    boundary = 2011
  []
  [disp_y_11]
    type = SideAverageValue
    variable = disp_y
    boundary = 2011
  []
[]

[VectorPostprocessors]
  [duct_1]
    type = LineValueSampler
    sort_by = z
    variable = 'disp_y'
    start_point = '0.0669059 0.0 0.0'
    end_point = '0.0669059 0.0 4.0'
    num_points = 101
    execute_on = FINAL
  []
  [duct_3]
    type = NodalValueSampler
    sort_by = z
    variable = 'disp_x disp_y'
    boundary = CornersDuct3
  []
  [duct_10]
    type = NodalValueSampler
    sort_by = z
    variable = 'disp_x disp_y'
    boundary = CornersDuct10
  []
[]

[Outputs]
  exodus = true
  perf_graph = true
  [tlp_displace]
    type = CSV
    file_base = tlp_disp_dt_steps
    execute_on = timestep_end
    show = 'disp_x_1 disp_y_1 disp_x_3 disp_y_3 disp_x_10 disp_y_10 disp_x_11 disp_y_11'
  []
  [duct1_displace]
    type = CSV
    file_base = duct_1_centerline
    execute_on = final
    show = duct_1
  []
  [duct3_displace]
    type = CSV
    file_base = duct_3_corners
    execute_on = final
    show = duct_3
  []
  [duct10_displace]
    type = CSV
    file_base = duct_10_corners
    execute_on = final
    show = duct_10
  []
[]
