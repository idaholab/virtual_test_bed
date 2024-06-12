[Mesh]
  [mesh_gen]
    type = FileMeshGenerator
    file = full_structure_with_isolators_new.e
  []
[]

[Variables]
  [disp_x]
  []
  [disp_y]
  []
  [disp_z]
  []
  [rot_x]
    block = 'isolator_elems upper_rigid_elems'
  []
  [rot_y]
    block = 'isolator_elems upper_rigid_elems'
  []
  [rot_z]
    block = 'isolator_elems upper_rigid_elems'
  []
[]

[AuxVariables]
  [vel_x]
  []
  [accel_x]
  []
  [vel_y]
  []
  [accel_y]
  []
  [vel_z]
  []
  [accel_z]
  []
  [rot_vel_x]
    block = 'isolator_elems upper_rigid_elems'
  []
  [rot_vel_y]
    block = 'isolator_elems upper_rigid_elems'
  []
  [rot_vel_z]
    block = 'isolator_elems upper_rigid_elems'
  []
  [rot_accel_x]
    block = 'isolator_elems upper_rigid_elems'
  []
  [rot_accel_y]
    block = 'isolator_elems upper_rigid_elems'
  []
  [rot_accel_z]
    block = 'isolator_elems upper_rigid_elems'
  []
  [Fb_x]
    block = 'isolator_elems'
    order = CONSTANT
    family = MONOMIAL
  []
  [Fb_y]
    block = 'isolator_elems'
    order = CONSTANT
    family = MONOMIAL
  []
  [Fb_z]
    block = 'isolator_elems'
    order = CONSTANT
    family = MONOMIAL
  []
  [Defb_x]
    block = 'isolator_elems'
    order = CONSTANT
    family = MONOMIAL
  []
  [Velb_x]
    block = 'isolator_elems'
    order = CONSTANT
    family = MONOMIAL
  []
  [Defb_y]
    block = 'isolator_elems'
    order = CONSTANT
    family = MONOMIAL
  []
  [Defb_z]
    block = 'isolator_elems'
    order = CONSTANT
    family = MONOMIAL
  []
[]

[Physics/SolidMechanics/LineElement/QuasiStatic]
  displacements = 'disp_x disp_y disp_z'
  rotations = 'rot_x rot_y rot_z'

  velocities = 'vel_x vel_y vel_z'
  accelerations = 'accel_x accel_y accel_z'
  rotational_velocities = 'rot_vel_x rot_vel_y rot_vel_z'
  rotational_accelerations = 'rot_accel_x rot_accel_y rot_accel_z'

  beta = 0.275625
  gamma = 0.55
  alpha = -0.05

  [rigid_beams]
    block = 'upper_rigid_elems'
    area = 130.06
    Iy = 24166.729
    Iz = 24166.729
    y_orientation = '0.0 0.0 1.0'
  []
[]

[Kernels]
  [DynamicTensorMechanics]
    displacements = 'disp_x disp_y disp_z'
    block = 'roof ext_buttresses ext_walls int_buttresses SG_bases SGs int_wall int_slab RV_housing RV small_walls upper_basemat fluid_material RV_slab'
    alpha = -0.05
    static_initialization = true
    zeta = 0.0019
  []
  [inertia_x]
    type = InertialForce
    block = 'roof ext_buttresses ext_walls int_buttresses SG_bases SGs int_wall int_slab RV_housing RV small_walls upper_basemat fluid_material RV_slab'
    variable = disp_x
    eta = 0.038
    alpha = -0.05
  []
  [inertia_y]
    type = InertialForce
    block = 'roof ext_buttresses ext_walls int_buttresses SG_bases SGs int_wall int_slab RV_housing RV small_walls upper_basemat fluid_material RV_slab'
    variable = disp_y
    eta = 0.038
    alpha = -0.05
  []
  [inertia_z]
    type = InertialForce
    block = 'roof ext_buttresses ext_walls int_buttresses SG_bases SGs int_wall int_slab RV_housing RV small_walls upper_basemat fluid_material RV_slab'
    variable = disp_z
    eta = 0.038
    alpha = -0.05
  []
  [lr_disp_x]
    type = StressDivergenceIsolator
    block = 'isolator_elems'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    component = 0
    variable = disp_x
    static_initialization = true
    zeta = 0.0019
    alpha = -0.05
  []
  [lr_disp_y]
    type = StressDivergenceIsolator
    block = 'isolator_elems'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    component = 1
    variable = disp_y
    static_initialization = true
    zeta = 0.0019
    alpha = -0.05
  []
  [lr_disp_z]
    type = StressDivergenceIsolator
    block = 'isolator_elems'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    component = 2
    variable = disp_z
    static_initialization = true
    zeta = 0.0019
    alpha = -0.05
  []
  [lr_rot_x]
    type = StressDivergenceIsolator
    block = 'isolator_elems'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    component = 3
    variable = rot_x
    static_initialization = true
    zeta = 0.0019
    alpha = -0.05
  []
  [lr_rot_y]
    type = StressDivergenceIsolator
    block = 'isolator_elems'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    component = 4
    variable = rot_y
    static_initialization = true
    zeta = 0.0019
    alpha = -0.05
  []
  [lr_rot_z]
    type = StressDivergenceIsolator
    block = 'isolator_elems'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    component = 5
    variable = rot_z
    static_initialization = true
    zeta = 0.0019
    alpha = -0.05
  []
  [gravity]
    type = Gravity
    variable = disp_z
    value = -9.81
    block = 'roof ext_buttresses ext_walls int_buttresses SG_bases SGs int_wall int_slab RV_housing RV small_walls upper_basemat fluid_material RV_slab'
    alpha = -0.05
  []
[]

[AuxKernels]
  [Fb_x]
    type = MaterialRealCMMAux
    property = basic_forces
    row = 0
    column = 0
    variable = Fb_x
    block = 'isolator_elems'
  []
  [Fb_y]
    type = MaterialRealCMMAux
    property = basic_forces
    row = 1
    column = 0
    variable = Fb_y
    block = 'isolator_elems'
  []
  [Fb_z]
    type = MaterialRealCMMAux
    property = basic_forces
    row = 2
    column = 0
    variable = Fb_z
    block = 'isolator_elems'
  []
  [Defb_x]
    type = MaterialRealCMMAux
    property = deformations
    row = 0
    column = 0
    variable = Defb_x
    block = 'isolator_elems'
  []
  [Velb_x]
    type = MaterialRealCMMAux
    property = deformation_rates
    row = 0
    column = 0
    variable = Velb_x
    block = 'isolator_elems'
  []
  [Defb_y]
    type = MaterialRealCMMAux
    property = deformations
    row = 1
    column = 0
    variable = Defb_y
    block = 'isolator_elems'
  []
  [Defb_z]
    type = MaterialRealCMMAux
    property = deformations
    row = 2
    column = 0
    variable = Defb_z
    block = 'isolator_elems'
  []
  [accel_x]
    type = TestNewmarkTI
    displacement = disp_x
    variable = accel_x
    first = false
  []
  [vel_x]
    type = TestNewmarkTI
    displacement = disp_x
    variable = vel_x
  []
  [accel_y]
    type = TestNewmarkTI
    displacement = disp_y
    variable = accel_y
    first = false
  []
  [vel_y]
    type = TestNewmarkTI
    displacement = disp_y
    variable = vel_y
  []
  [accel_z]
    type = TestNewmarkTI
    displacement = disp_z
    variable = accel_z
    first = false
  []
  [vel_z]
    type = TestNewmarkTI
    displacement = disp_z
    variable = vel_z
  []
  [rot_accel_x]
    block = 'isolator_elems upper_rigid_elems'
    type = TestNewmarkTI
    displacement = rot_x
    variable = rot_accel_x
    first = false
  []
  [rot_vel_x]
    block = 'isolator_elems upper_rigid_elems'
    type = TestNewmarkTI
    displacement = rot_x
    variable = rot_vel_x
  []
  [rot_accel_y]
    block = 'isolator_elems upper_rigid_elems'
    type = TestNewmarkTI
    displacement = rot_y
    variable = rot_accel_y
    first = false
  []
  [rot_vel_y]
    block = 'isolator_elems upper_rigid_elems'
    type = TestNewmarkTI
    displacement = rot_y
    variable = rot_vel_y
  []
  [rot_accel_z]
    block = 'isolator_elems upper_rigid_elems'
    type = TestNewmarkTI
    displacement = rot_z
    variable = rot_accel_z
    first = false
  []
  [rot_vel_z]
    block = 'isolator_elems upper_rigid_elems'
    type = TestNewmarkTI
    displacement = rot_z
    variable = rot_vel_z
  []
[]

[Materials]
  [elasticity_concrete]
    type = ComputeIsotropicElasticityTensor
    block = 'roof ext_buttresses ext_walls int_buttresses SG_bases int_wall int_slab RV_housing small_walls RV_slab'
    youngs_modulus = 24.8 #GPa
    poissons_ratio = 0.2
  []
  [elasticity_rigid_concrete]
    type = ComputeIsotropicElasticityTensor
    block = 'upper_basemat'
    youngs_modulus = 99.2 #GPa # 4 x concrete for rigid basemat
    poissons_ratio = 0.2
  []
  [elasticity_steel_316]
    type = ComputeIsotropicElasticityTensor
    block = 'SGs RV'
    youngs_modulus = 170 #GPa
    poissons_ratio = 0.3
  []
  [elasticity_fluid]
    type = ComputeIsotropicElasticityTensor
    block = 'fluid_material'
    bulk_modulus = 2 #GPa #water
    poissons_ratio = 0.45 #water
  []
  [strain_1]
    type = ComputeFiniteStrain
    displacements = 'disp_x disp_y disp_z'
    block = 'roof ext_buttresses ext_walls int_buttresses SG_bases SGs int_wall int_slab RV_housing RV small_walls upper_basemat fluid_material RV_slab'
  []
  [stress_1]
    type = ComputeFiniteStrainElasticStress
    block = 'roof ext_buttresses ext_walls int_buttresses SG_bases SGs int_wall int_slab RV_housing RV small_walls upper_basemat fluid_material RV_slab'
  []
  [concrete_density]
    type = GenericConstantMaterial
    block = 'roof ext_buttresses ext_walls int_buttresses SG_bases int_wall int_slab RV_housing small_walls upper_basemat RV_slab'
    prop_names = density
    prop_values = 2.4e-6 #e9kg/m3
  []
  [steel_density]
    type = GenericConstantMaterial
    block = 'SGs RV'
    prop_names = density
    prop_values = 7.85e-6 #e9kg/m3
  []
  [fluid_density]
    type = GenericConstantMaterial
    block = 'fluid_material'
    prop_names = density
    prop_values = 1.0e-6 #e9kg/m3 #water
  []

  [isolator_deformation]
    type = ComputeIsolatorDeformation
    sd_ratio = 0.5
    y_orientation = '1.0 0.0 0.0'
    displacements = 'disp_x disp_y disp_z'
    rotations = 'rot_x rot_y rot_z'
    velocities = 'vel_x vel_y vel_z'
    block = 'isolator_elems'
  []
  [elasticity]
    type = ComputeFPIsolatorElasticity
    mu_ref = 0.06
    p_ref = 0.006 # GPa
    block = 'isolator_elems'
    diffusivity = 4.4e-6
    conductivity = 18
    a = 100
    r_eff = 1.0 # meters. 2sec sliding period
    r_contact = 0.2
    uy = 0.001
    unit = 4
    beta = 0.275625
    gamma = 0.55
    pressure_dependent = false
    temperature_dependent = false
    velocity_dependent = false
    k_x = 78.53 # 7.853e10 N
    k_xx = 0.62282 # 622820743.6 N
    k_yy = 0.3114 # 311410371.8 N
    k_zz = 0.3114 # 311410371.8 N
  []

  [elasticity_beam_rigid]
    type = ComputeElasticityBeam
    youngs_modulus = 2e4
    poissons_ratio = 0.27
    shear_coefficient = 0.85
    block = 'upper_rigid_elems'
  []
  [stress_beam_rigid]
    type = ComputeBeamResultants
    block = 'upper_rigid_elems'
  []
[]

[Functions]
  [input_motion_x]
    type = PiecewiseLinear
    data_file = 'case2_scaled.csv'
    format = columns
    scale_factor = 9.81
    y_index_in_file = 1
    xy_in_file_only = false
  []
  [input_motion_y]
    type = PiecewiseLinear
    data_file = 'case2_scaled.csv'
    format = columns
    scale_factor = 9.81
    y_index_in_file = 2
    xy_in_file_only = false
  []
  [input_motion_z]
    type = PiecewiseLinear
    data_file = 'case2_scaled.csv'
    format = columns
    scale_factor = 9.81
    y_index_in_file = 3
    xy_in_file_only = false
  []
[]

[BCs]
  [x_motion]
    type = PresetAcceleration
    acceleration = accel_x
    velocity = vel_x
    variable = disp_x
    beta = 0.2725625
    boundary = 'bottom_isolators'
    function = 'input_motion_x'
  []
  [y_motion]
    type = PresetAcceleration
    acceleration = accel_y
    velocity = vel_y
    variable = disp_y
    beta = 0.2725625
    boundary = 'bottom_isolators'
    function = 'input_motion_y'
  []
  [z_motion]
    type = PresetAcceleration
    acceleration = accel_z
    velocity = vel_z
    variable = disp_z
    beta = 0.2725625
    boundary = 'bottom_isolators'
    function = 'input_motion_z'
  []
  [fixrxbot]
    type = DirichletBC
    variable = rot_x
    boundary = 'bottom_isolators'
    value = 0.0
  []
  [fixrybot]
    type = DirichletBC
    variable = rot_y
    boundary = 'bottom_isolators'
    value = 0.0
  []
  [fixrzbot]
    type = DirichletBC
    variable = rot_z
    boundary = 'bottom_isolators'
    value = 0.0
  []
  [fixrxcon]
    type = DirichletBC
    variable = rot_x
    boundary = 'connections'
    value = 0.0
  []
  [fixrycon]
    type = DirichletBC
    variable = rot_y
    boundary = 'connections'
    value = 0.0
  []
  [fixrzcon]
    type = DirichletBC
    variable = rot_z
    boundary = 'connections'
    value = 0.0
  []
[]

[Preconditioning]
  [smp]
    type = SMP
    full = true
  []
[]

[Executioner]
  type = Transient
  petsc_options = '-ksp_snes_ew'
  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
  petsc_options_value = 'lu       superlu_dist'
  solve_type = 'NEWTON'
  nl_rel_tol = 1e-7
  nl_abs_tol = 1e-15
  dt = 0.01
  end_time = 28
  timestep_tolerance = 1e-6
  automatic_scaling = true
  [TimeIntegrator]
    type = NewmarkBeta
    beta = 0.275625
    gamma = 0.55
    inactive_tsteps = 2
  []
[]

[Controls]
  [inertia_switch]
    type = TimePeriod
    start_time = 0.0
    end_time = 0.03
    disable_objects = '*/inertia_x */inertia_y */inertia_z
                       */vel_x */vel_y */vel_z
                       */accel_x */accel_y */accel_z
                       */rot_vel_x */rot_vel_y */rot_vel_z
                       */rot_accel_x */rot_accel_y */rot_accel_z'
    set_sync_times = true
    execute_on = 'timestep_begin timestep_end'
  []
[]

[Postprocessors]
  [inp_accel_x]
    type = PointValue
    point = '5.0 0.0 -1.3'
    variable = accel_x
  []
  [inp_accel_y]
    type = PointValue
    point = '5.0 0.0 -1.3'
    variable = accel_y
  []
  [inp_accel_z]
    type = PointValue
    point = '5.0 0.0 -1.3'
    variable = accel_z
  []
  [basemat_accel_x]
    type = PointValue
    point = '0.0 0.0 0.0'
    variable = accel_x
  []
  [basemat_accel_y]
    type = PointValue
    point = '0.0 0.0 0.0'
    variable = accel_y
  []
  [basemat_accel_z]
    type = PointValue
    point = '0.0 0.0 0.0'
    variable = accel_z
  []
  [iso1_fb_axial]
    type = PointValue
    point = '5.0 0.0 -1.3'
    variable = Fb_x
  []
  [iso1_defb_axial]
    type = PointValue
    point = '5.0 0.0 -1.3'
    variable = Defb_x
  []
  [iso1_fb_shear1]
    type = PointValue
    point = '5.0 0.0 -1.3'
    variable = Fb_y
  []
  [iso1_defb_shear1]
    type = PointValue
    point = '5.0 0.0 -1.3'
    variable = Defb_y
  []
  [iso1_fb_shear2]
    type = PointValue
    point = '5.0 0.0 -1.3'
    variable = Fb_z
  []
  [iso1_defb_shear2]
    type = PointValue
    point = '5.0 0.0 -1.3'
    variable = Defb_z
  []
[]

[VectorPostprocessors]
  [accel_hist_x]
    type = ResponseHistoryBuilder
    variables = 'accel_x'
    nodes = '5252 2767 59044 24207 44503 41781 59152 38767 59100'
    # locations:
    # 5252-roof_edge
    # 2767-roof_center
    # 59044-RV_slab_center
    # 24207-SG_base
    # 44503-basemat_center-(0.35,-0.75,-1)(approx)
    # 41781-center_isolator_top-(5,0,-1)
    # 59152-center_isolator_bottom-(5,0,-1.3)
    # 38767-edge_isolator_top-(-45,30,-1)
    # 59100-edge_isolator_bottom(-45,30,-1.3)
    outputs = out1
  []
  [accel_spec_x]
    type = ResponseSpectraCalculator
    vectorpostprocessor = accel_hist_x
    regularize_dt = 0.01
    damping_ratio = 0.05
    start_frequency = 0.1
    end_frequency = 50
    outputs = out1
  []

  [accel_hist_y]
    type = ResponseHistoryBuilder
    variables = 'accel_y'
    nodes = '5252 2767 59044 24207 44503 41781 59152 38767 59100'
    # locations:
    # 5252-roof_edge
    # 2767-roof_center
    # 59044-RV_slab_center
    # 24207-SG_base
    # 44503-basemat_center-(0.35,-0.75,-1)(approx)
    # 41781-center_isolator_top-(5,0,-1)
    # 59152-center_isolator_bottom-(5,0,-1.3)
    # 38767-edge_isolator_top-(-45,30,-1)
    # 59100-edge_isolator_bottom(-45,30,-1.3)
    outputs = out1
  []
  [accel_spec_y]
    type = ResponseSpectraCalculator
    vectorpostprocessor = accel_hist_y
    regularize_dt = 0.01
    damping_ratio = 0.05
    start_frequency = 0.1
    end_frequency = 50
    outputs = out1
  []

  [accel_hist_z]
    type = ResponseHistoryBuilder
    variables = 'accel_z'
    nodes = '5252 2767 59044 24207 44503 41781 59152 38767 59100'
    # locations:
    # 5252-roof_edge
    # 2767-roof_center
    # 59044-RV_slab_center
    # 24207-SG_base
    # 44503-basemat_center-(0.35,-0.75,-1)(approx)
    # 41781-center_isolator_top-(5,0,-1)
    # 59152-center_isolator_bottom-(5,0,-1.3)
    # 38767-edge_isolator_top-(-45,30,-1)
    # 59100-edge_isolator_bottom(-45,30,-1.3)
    outputs = out1
  []
  [accel_spec_z]
    type = ResponseSpectraCalculator
    vectorpostprocessor = accel_hist_z
    regularize_dt = 0.01
    damping_ratio = 0.05
    start_frequency = 0.1
    end_frequency = 50
    outputs = out1
  []
[]

[Outputs]
  exodus = true
  perf_graph = true
  csv = true
  [out1]
    type = CSV
    execute_on = 'final'
  []
[]
