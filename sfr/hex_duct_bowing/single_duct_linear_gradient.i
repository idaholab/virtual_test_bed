# ==============================================================================
# Hexagonal Duct Bowing - Linear Thermal Gradient (IAEA VP1)
# Tensor Mechanics solve of IAEA Verification Problem 1
# 3D Hexagonal assembly single duct, thermal mechanical simultation
# ------------------------------------------------------------------------------
# Argonne National Laboratory, 10/2022
# Author(s): Nicholas Wozniak
# ==============================================================================

[GlobalParams]
  displacements = 'disp_x disp_y disp_z'
[]

[Mesh]
  [cladding_hex]
    type = PolygonConcentricCircleMeshGenerator
    num_sides = 6 # must be six to use hex pattern
    num_sectors_per_side = '8 8 8 8 8 8'
    background_intervals = 2
    background_block_ids = '10 10'
    polygon_size = 0.066451905
    polygon_size_style ='apothem'
    duct_sizes_style = 'apothem'
    duct_sizes = '0.063451905'
    duct_intervals = '1'
    duct_block_ids = '1500'
    preserve_volumes = on
    quad_center_elements = true
    external_boundary_id = 100
    interface_boundary_id_shift = 100
  []

  [cladding_center_removal]
    type = BlockDeletionGenerator
    block = '10'
    input = cladding_hex
  []

  [rename_cladding_1] # to avoid conflicts when generating load pad hex frame
    type = RenameBoundaryGenerator
    input = cladding_center_removal
    old_boundary = '10000 10001 15001 10002 15002 10003 15003 10004 15004 10005 15005 10006 15006'
    new_boundary = '1000 1001 1001 1002 1002 1003 1003 1004 1004 1005 1005 1006 1006'
  []

  [cladding_extrude]
    type = MeshExtruderGenerator
    extrusion_vector = '0 0 4.0'
    num_layers = 400
    bottom_sideset = '1201' # will be fixed boundary
    top_sideset = '1202'
    input = rename_cladding_1
  []

  ##################
  [load_pad_hex]
    type = PolygonConcentricCircleMeshGenerator
    num_sides = 6 # must be six to use hex pattern
    num_sectors_per_side = '8 8 8 8 8 8'
    background_intervals = 2
    background_block_ids = '10 10'
    polygon_size = 0.069201905
    polygon_size_style = 'apothem'
    duct_sizes_style = 'apothem'
    duct_sizes = '0.066451905'
    duct_intervals = '1'
    duct_block_ids = '1600'
    preserve_volumes = on
    quad_center_elements = true
    external_boundary_id = 200
    interface_boundary_id_shift = 200
  []

  [load_pad_center_removal]
    type = BlockDeletionGenerator
    block = '10'
    input = load_pad_hex
    new_boundary = '2200' # load pad inner surface to stitch
  []

  [load_pad_extrude]
    type = MeshExtruderGenerator
    extrusion_vector = '0 0 0.1'
    num_layers = 10
    input = load_pad_center_removal
  []

  [load_pad_translate]
    type = TransformGenerator
    input = load_pad_extrude
    transform = translate
    vector_value = '0 0 2.95'
  []

  [Cladding_load_pad_stitching]
    type = StitchedMeshGenerator
    inputs = 'cladding_extrude  load_pad_translate'
    clear_stitched_boundary_ids = true
    stitch_boundaries_pairs = '1000 2200'
  []

  [sidesets_rename_all]
    type = RenameBoundaryGenerator
    input = Cladding_load_pad_stitching
    old_boundary = '1201 1001 1002 1003 1004 1005 1006 10001 15001 10002 15002 10003 15003 10004 15004 10005 15005 10006 15006'
    new_boundary = 'fixed face3 face2 face1 face6 face5 face4 face3_aclp face3_aclp face2_aclp face2_aclp face1_aclp face1_aclp face6_aclp face6_aclp face5_aclp face5_aclp face4_aclp face4_aclp'
  []
  [block_rename]
    type = RenameBlockGenerator
    input = sidesets_rename_all
    old_block = '1500 1600'
    new_block ='1 1'
  []

  # Mesh parallel partitioning parameters
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
# The duct temperatures are defined at the corners and linearly vary in the axial direction
# and along the face of the duct.
  [temp_func]
    type = ParsedFunction
    #At center of wall, y=+-0.075m
    #T varies across the cross-section from 500C to 550C, ramps up to that from 400C at z=1.5m to 2.5m
    value = '400+if(z>2.5,t*(125-25/.075*y*t),if(z>1.5,t*(z-1.5)/1.0*(125-25/.075*y*t),0))'
  []
[]

[AuxVariables]
  [temp]
    initial_condition = 400
    order = FIRST
    family = LAGRANGE
  []
[]

[AuxKernels]
  [tfunc]
    type = FunctionAux
    variable = temp
    function = temp_func
    block = '1'
  []
[]

[BCs]
  [no_x]
    type = DirichletBC
    variable = disp_x
    boundary = fixed
    value = 0.0
  []
  [no_y]
    type = DirichletBC
    variable = disp_y
    boundary = fixed
    value = 0.0
  []
  [no_z]
    type = DirichletBC
    variable = disp_z
    boundary = fixed
    value = 0.0
  []
[]

[Modules]
  [TensorMechanics]
    [Master]
      [all]
        strain = FINITE
        volumetric_locking_correction = true
        add_variables = true
        eigenstrain_names = thermal_expansion
        decomposition_method = EigenSolution
        generate_output = 'vonmises_stress'
        temperature = temp
        use_finite_deform_jacobian = true
        extra_vector_tags = 'ref'
      []
    []
  []
[]

[Materials]
  [elasticity_tensor]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 1.7e11
    poissons_ratio = 0.3
    block = 1
  []
  [small_stress]
    type = ComputeFiniteStrainElasticStress
    block = 1
  []
  [thermal_expansion_strain]
    type = ComputeThermalExpansionEigenstrain
    stress_free_temperature = 400.0
    thermal_expansion_coeff = 18.0e-6
    temperature = temp
    eigenstrain_name = thermal_expansion
    block = '1'
  []
[]

[Preconditioning]
  active = 'smp1'
  [smp1]
    type = SMP
    full = true
  []
[]

[Executioner]
  automatic_scaling = true
  type = Transient
  solve_type = 'PJFNK'

  petsc_options = '-ksp_snes_ew'
  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
  petsc_options_value = 'lu       superlu_dist'
  line_search = none

  l_max_its = 100
  nl_max_its = 50
  nl_rel_tol = 1e-4
  nl_abs_tol = 1e-10

  start_time = 0
  n_startup_steps = 1
  end_time = 1
  dt = 0.5
  dtmin = 0.01
[]

[Postprocessors]
  [dispy_core_top]
    type = PointValue
    point = '0.0664 0.0 2.5'
    variable = disp_y
  []
  [dispx_core_top]
    type = PointValue
    point = '0.0664 0.0 2.5'
    variable = disp_x
  []
  [dispy_aclp]
    type = PointValue
    point = '0.0664 0.0 3.0'
    variable = disp_y
  []
  [dispx_aclp]
    type = PointValue
    point = '0.0664 0.0 3.0'
    variable = disp_x
  []
  [dispy_tlp]
    type = PointValue
    point = '0.0664 0.0 4.0'
    variable = disp_y
  []
  [dispx_tlp]
    type = PointValue
    point = '0.0664 0.0 4.0'
    variable = disp_x
  []
[]

[VectorPostprocessors]
  [face4]
    type = NodalValueSampler
    sort_by = z
    variable = 'disp_x disp_y'
    boundary = face4
  []
[]

[Outputs]
  exodus = true
  perf_graph = true
  [duct_displace]
    type = CSV
    file_base = face_disp
    execute_on = final
    show = 'face4'
  []
  [load_pad]
    type = CSV
    file_base = load_pad_displace
    execute_on = timestep_end
    show = 'dispx_core_top dispy_core_top dispx_aclp dispy_aclp dispx_tlp dispy_tlp'
  []
[]
