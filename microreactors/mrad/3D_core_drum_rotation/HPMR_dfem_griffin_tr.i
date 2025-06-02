################################################################################
## NEAMS Micro-Reactor Application Driver                                     ##
## Griffin Model Heat Pipe Microreactor                                       ##
################################################################################

fuel_blocks = '301 303'
air_blocks = '504 600 601 250'
ring_blocks = '5010 5011 5012'
mono_blocks = '10 10000'
mod_clad_blocks = '101'
yh_blocks = '100 103'
mod_blocks = '${yh_blocks} ${mod_clad_blocks}'
ref_blocks = '1000 1008 1009 400 401 500 501'
hp_blocks = '200 201 203'

non_hp_blocks = '${fuel_blocks} ${air_blocks} ${ring_blocks} ${mono_blocks} ${mod_blocks} ${ref_blocks}'
non_hp_fuel_blocks = '${air_blocks} ${ring_blocks} ${mono_blocks} ${mod_blocks} ${ref_blocks}'
non_hp_yh_blocks = '${fuel_blocks} ${air_blocks} ${ring_blocks} ${mono_blocks} ${mod_clad_blocks} ${ref_blocks}'

angle_step = ${fparse 360 / 720} # Angular distance between elements in drum
dstep = 1                        # Number of elements to pass each timestep
pos_start = 35                   # Starting position
t_out = 1                        # Time moving outward
speed = 5                        # Degrees per second

[Mesh]
  [fmg]
  # If you do not have a presplit mesh already, you should generate it first:
  # 1. Uncomment all the mesh blocks in the !include file
  # 2. Use the exodus file in the fmg block
  # 3. Comment the "parallel_type = distributed" line
  # 4. Use moose executable to presplit the mesh
  # Once you have the presplit mesh
  # 1. Comment all the mesh blocks except the fmg block in the !include file
  # 2. Use the cpr file in the fmg block
  # 3. Uncomment the "parallel_type = distributed" line

    type = FileMeshGenerator
    # file = '../mesh/HPMR_OneSixth_finercdrum_in.e'
    file = 'griffin_mesh.cpr'
  []
  # [fmg_id]
  #   type = SubdomainExtraElementIDGenerator
  #   input = fmg
  #   subdomains ='         200 203 100 103 301 303 10  504 600 601 201 101 400 401 250 500 1003 501 1000 10000 1008 1009'
  #   extra_element_id_names = 'material_id equivalence_id'
  #   extra_element_ids = ' 815 815 802 802 801 801 803 820 820 820 817 816 805 805 820 805  805 805  805 803    805  805;
  #                         815 815 802 802 801 801 803 820 820 820 817 816 805 805 820 805  805 805  805 803    805  805'
  # []
  # [coarse_mesh]
  #   type = GeneratedMeshGenerator
  #   dim = 3
  #   nx = 10
  #   ny = 10
  #   nz = 10
  #   xmin = -0.1
  #   xmax = 1.1
  #   ymin = -0.1
  #   ymax = 1.2
  #   zmin = -0.0
  #   zmax = 2.1
  # []
  # [assign_coarse_id]
  #   type = CoarseMeshExtraElementIDGenerator
  #   input = fmg_id
  #   coarse_mesh = coarse_mesh
  #   extra_element_id_name = coarse_element_id
  # []
  uniform_refine = 0
  parallel_type = distributed
[]

[Executioner]
  type = TransientSweepUpdate

  richardson_abs_tol = 1e-4
  richardson_rel_tol = 5e-5
  richardson_max_its = 1000

  inner_solve_type = GMRes
  max_inner_its = 100

  cmfd_acceleration = true
  # diffusion_eigen_solver_type = krylovshur
  # diffusion_eigen_solver_type = newton
  # diffusion_prec_type = lu
  coarse_element_id = coarse_element_id
  prolongation_type = multiplicative
  max_diffusion_coefficient = 1

  end_time = 5000
  dt = ${fparse angle_step / speed * dstep}
  dtmin = 0.001
[]

[TransportSystems]
  particle = neutron
  equation_type = transient

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
  [Rotation] # drum angle (0 = fully in, 180 = fully out)
  []
  [Tf]
    initial_condition = 873.15
    order = CONSTANT
    family = MONOMIAL
  []
  [Ts]
    initial_condition = 873.15
    order = CONSTANT
    family = MONOMIAL
  []
[]


[GlobalParams]
  library_file = '../isoxml/HP-MR_XS.xml'
  library_name = HP-MR_XS
  isotopes = 'pseudo'
  densities = 1.0
  is_meter = true
  plus = true
  dbgmat = false
  grid_names = 'Rotation Ts Tfuel'
  grid_variables = 'Rotation Ts Tf'
[]

[Functions]
  [drum10_offset]
    type = ConstantFunction
    value = 15
  []
  [drum10_position]
    type = ConstantFunction
    value = 90
  []
  [drum10_fun]
    type = ParsedFunction
    expression =    'drum10_position + drum10_offset'
    symbol_names =  'drum10_position   drum10_offset'
    symbol_values = 'drum10_position   drum10_offset'
  []

  [drum11_offset]
    type = ConstantFunction
    value = 0
  []
  [drum_linear]
    type = ParsedFunction
    expression = 'if(t <= t_out, pos_start + speed * t, (pos_start + speed * t_out) - speed * (t - t_out))'
    symbol_names = 't_out pos_start speed'
    symbol_values = '${t_out} ${pos_start} ${speed}'
  []
  [drum11_position]
    type = ParsedFunction
    expression = 'if(drum_linear < 0, 0, if(drum_linear > 180, 180, drum_linear))'
    symbol_names = 'drum_linear'
    symbol_values = 'drum_linear'
  []
  [drum11_fun]
    type = ParsedFunction
    expression = 'drum11_position + drum11_offset'
    symbol_names = 'drum11_position  drum11_offset'
    symbol_values = 'drum11_position drum11_offset'
  []

  [drum12_offset]
    type = ConstantFunction
    value = 45
  []
  [drum12_position]
    type = ConstantFunction
    value = 0
  []
  [drum12_fun]
    type = ParsedFunction
    expression =    'drum12_position + drum12_offset'
    symbol_names =  'drum12_position   drum12_offset'
    symbol_values = 'drum12_position   drum12_offset'
  []
[]


[AuxKernels]
  [drum10_Rotation_aux]
    type = FunctionAux
    variable = Rotation
    function = drum10_position
    execute_on = 'initial timestep_end'
  []

  [drum11_Rotation_aux]
    type = FunctionAux
    variable = Rotation
    function = drum11_position
    execute_on = 'initial timestep_end'
  []

  [drum12_Rotation_aux]
    type = FunctionAux
    variable = Rotation
    function = drum12_position
    execute_on = 'initial timestep_end'
  []

  [hp_Tf]
    type = SpatialUserObjectAux
    variable = Tf
    block = ${hp_blocks}
    user_object = Tf_avg
  []
  [hp_Ts]
    type = SpatialUserObjectAux
    variable = Ts
    block = ${hp_blocks}
    user_object = Ts_avg
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
  [Ts_avg]
    type = LayeredAverage
    variable = Ts
    direction = z
    num_layers = 100
    block = ${non_hp_yh_blocks}
    execute_on = 'LINEAR TIMESTEP_END'
  []
[]

[Materials]
  [mod]
    type = CoupledFeedbackMatIDNeutronicsMaterial
    block = '200 203 100 103 301 303 10  504 600 601 201 101 400 401 250 500 1003 501 1000 10000 1008 1009'
  []
  [drum_10]
    type = CoupledFeedbackRoddedNeutronicsMaterial
    block = '5010'
    front_position_function = drum10_fun
    rotation_center = '0 0.926716 0'
    rod_segment_length = '270 90'
    segment_material_ids = '805 811'
    isotopes = 'pseudo; pseudo'
    densities = '1.0 1.0'
  mesh_alignment_tolerance=1E-4
  []
   [drum_11]
    type = CoupledFeedbackRoddedNeutronicsMaterial
    block = '5011'
    front_position_function = drum11_fun
    rotation_center = '0.40128 0.695037 0'
    rod_segment_length = '270 90'
    segment_material_ids = '805 811'
    isotopes = 'pseudo; pseudo'
    densities = '1.0 1.0'
  mesh_alignment_tolerance=1E-4
  []
    [drum_12]
    type = CoupledFeedbackRoddedNeutronicsMaterial
    block = '5012'
    front_position_function = drum12_fun
    rotation_center = '0.80256 0.463358 0'
    rod_segment_length = '270 90'
    segment_material_ids = '805 811'
    isotopes = 'pseudo; pseudo'
    densities = '1.0 1.0'
  mesh_alignment_tolerance=1E-4
  []
[]

[PowerDensity]
  power = 345.6e3
  power_density_variable = power_density
  integrated_power_postprocessor = integrated_power
[]

[MultiApps]
  [bison]
    type = TransientMultiApp
    app_type = BisonApp
    input_files = HPMR_thermo_tr.i
    execute_on = 'initial timestep_end'
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
    execute_on = 'timestep_end'
  []
  [from_sub_temp_fuel]
    type = MultiAppGeneralFieldShapeEvaluationTransfer
    from_multi_app = bison
    variable = Tf
    source_variable = Tfuel
    execute_on = 'initial timestep_end'
    to_blocks = ${non_hp_blocks}
  []
  [from_sub_temp_mod]
    type = MultiAppGeneralFieldShapeEvaluationTransfer
    from_multi_app = bison
    variable = Ts
    source_variable = Tmod
    execute_on = 'initial timestep_end'
    to_blocks = ${non_hp_blocks}
  []
[]

[UserObjects]
  [ss]
    type = TransportSolutionVectorFile
    transport_system = sn
    writing = false
    execute_on = initial
  []
[]

[Postprocessors]
  [scaled_power_avg]
    type = ElementAverageValue
    block = ${fuel_blocks}
    variable = power_density
    execute_on = 'initial timestep_end'
  []
  [fuel_temp_avg]
    type = ElementAverageValue
    variable = Tf
    block = ${fuel_blocks}
    execute_on = 'initial timestep_end'
  []
  [fuel_temp_max]
    type = ElementExtremeValue
    value_type = max
    variable = Tf
    block = ${fuel_blocks}
    execute_on = 'initial timestep_end'
  []
  [fuel_temp_min]
    type = ElementExtremeValue
    value_type = min
    variable = Tf
    block = ${fuel_blocks}
    execute_on = 'initial timestep_end'
  []
  [mod_temp_avg]
    type = ElementAverageValue
    variable = Ts
    block = ${yh_blocks}
    execute_on = 'initial timestep_end'
  []
  [mod_temp_max]
    type = ElementExtremeValue
    value_type = max
    variable = Ts
    block = ${yh_blocks}
    execute_on = 'initial timestep_end'
  []
  [mod_temp_min]
    type = ElementExtremeValue
    value_type = min
    variable = Ts
    block = ${yh_blocks}
    execute_on = 'initial timestep_end'
  []
[]

[Outputs]
  csv = true
  exodus = false
  perf_graph = true
  checkpoint = true
[]
