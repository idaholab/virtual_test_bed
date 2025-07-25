## HTGR assembly neutronics simulation
## Application: Cardinal
## POC: April Novak anovak at anl.gov
## If using or referring to this model, please cite as explained in
## https://mooseframework.inl.gov/virtual_test_bed/citing.html

num_layers_for_THM = 50 # number of elements in the THM model; for the converged
# case, we set this to 150

[GlobalParams]
  # Reduces transfers efficiency for now, can be removed once transferred fields are checked
  bbox_factor = 10
[]

[Mesh]
  # mesh mirror for the solid regions
  [solid]
    type = FileMeshGenerator
    file = meshes/solid_in.e
  []

  # create a mesh for a single coolant channel; because we will receive uniform
  # temperatures and densities from THM on each x-y plane, we can use a very coarse
  # mesh in the radial direction
  [coolant_face]
    type = AnnularMeshGenerator
    nr = 1
    nt = 8
    rmin = 0.0
    rmax = '${fparse channel_diameter / 2.0}'
  []
  [extrude]
    type = AdvancedExtruderGenerator
    input = coolant_face
    num_layers = ${num_layers_for_THM}
    direction = '0 0 1'
    heights = '${height}'
    top_boundary = '300' # inlet
    bottom_boundary = '400' # outlet
  []
  [rename]
    type = RenameBlockGenerator
    input = extrude
    old_block = '1'
    new_block = '101'
  []

  # repeat the coolant channels and then combine together to get a combined mesh mirror
  [repeat]
    type = CombinerGenerator
    inputs = rename
    positions_file = coolant_channel_positions.txt
  []
  [add]
    type = CombinerGenerator
    inputs = 'solid repeat'
  []
[]

[AuxVariables]
  [material_id]
    family = MONOMIAL
    order = CONSTANT
  []
  [cell_temperature]
    family = MONOMIAL
    order = CONSTANT
  []
  [cell_density]
    family = MONOMIAL
    order = CONSTANT
  []
  [thm_temp_wall]
    block = '101'
  []
  [flux]
  []

  # just for postprocessing purposes
  [thm_pressure]
    block = '101'
  []
  [thm_velocity]
    block = '101'
  []
  [z]
    family = MONOMIAL
    order = CONSTANT
    block = 'compacts'
  []
[]

[AuxKernels]
  [material_id]
    type = CellMaterialIDAux
    variable = material_id
  []
  [cell_temperature]
    type = CellTemperatureAux
    variable = cell_temperature
  []
  [cell_density]
    type = CellDensityAux
    variable = cell_density
  []
  [density]
    type = FluidDensityAux
    variable = density
    p = ${outlet_P}
    T = thm_temp
    fp = helium
    execute_on = 'timestep_begin linear'
  []
  [z]
    type = ParsedAux
    variable = z
    use_xyzt = true
    expression = 'z'
  []
[]

[ICs]
  [fluid_temp_wall]
    type = FunctionIC
    variable = thm_temp_wall
    function = temp_ic
  []
  [fluid_temp]
    type = FunctionIC
    variable = thm_temp
    function = temp_ic
  []
  [heat_source]
    type = ConstantIC
    variable = heat_source
    block = 'compacts'
    value = '${fparse power / (n_bundles * n_fuel_compacts_per_block) / (pi * compact_diameter * compact_diameter / 4.0 * height)}'
  []
[]

[Functions]
  [temp_ic]
    type = ParsedFunction
    expression = '${inlet_T} + (${height} - z) / ${height} * ${power} / ${mdot} / ${fluid_Cp}'
  []
[]

[FluidProperties]
  [helium]
    type = IdealGasFluidProperties
    molar_mass = 4e-3
    gamma = 1.668282 # should correspond to  Cp = 5189 J/kg/K
    k = 0.2556
    mu = 3.22639e-5
  []
[]

[Problem]
  type = OpenMCCellAverageProblem

  # optimizations to increase tracking rate by assuring that the tallies
  # are spatially independent
  check_tally_sum = false
  normalize_by_global_tally = false
  assume_separate_tallies = true

  power = '${fparse power / n_bundles}'
  scaling = 100.0

  relaxation = constant
  relaxation_factor = 0.5

  inactive_batches = 200
  batches = 1000

  # we will collate temperature from THM (for the fluid) and MOOSE (for the solid)
  # into variables we name as 'solid_temp' and 'thm_temp'. This syntax will automatically
  # create those variabes for us
  temperature_variables = 'solid_temp; solid_temp; solid_temp; thm_temp'
  temperature_blocks = 'graphite; compacts; poison; 101'
  cell_level = 0

  density_blocks = '101'

  [Tallies]
    [heat_source]
      type = CellTally
      block = '2'
      name = heat_source
      score = heating

      trigger = rel_err
      trigger_threshold = 2e-2

      check_equal_mapped_tally_volumes = true
      output = 'unrelaxed_tally_std_dev'
    []
  []
[]

[Postprocessors]
  [flux_integral]
    type = SideIntegralVariablePostprocessor
    variable = flux
    boundary = 'fluid_solid_interface'
    execute_on = 'transfer linear'
  []
  [heat_source]
    type = ElementIntegralVariablePostprocessor
    variable = heat_source
    execute_on = 'transfer initial timestep_end'
  []
  [max_tally_rel_err]
    type = TallyRelativeError
    value_type = max
    tally_score = 'heating'
  []
  [k]
    type = KEigenvalue
  []
  [k_std_dev]
    type = KEigenvalue
    output = 'std_dev'
  []
  [min_power]
    type = ElementExtremeValue
    variable = heat_source
    value_type = min
    block = 'compacts'
  []
  [max_power]
    type = ElementExtremeValue
    variable = heat_source
    value_type = max
    block = 'compacts'
  []
  [z_max_power]
    type = ElementExtremeValue
    proxy_variable = heat_source
    variable = z
    block = 'compacts'
  []
  [max_Tf]
    type = ElementExtremeValue
    variable = thm_temp
    block = '101'
  []
  [P_in]
    type = SideAverageValue
    variable = thm_pressure
    boundary = '300'
  []
  [pressure_drop]
    type = LinearCombinationPostprocessor
    pp_names = 'P_in'
    pp_coefs = '1.0'
    b = '${fparse -outlet_P}'
  []
[]

[MultiApps]
  [bison]
    type = TransientMultiApp
    app_type = CardinalApp
    input_files = 'solid.i'
    execute_on = timestep_begin
  []
  [thm]
    type = FullSolveMultiApp
    app_type = CardinalApp
    input_files = 'thm.i'
    execute_on = timestep_end
    max_procs_per_app = 1
    bounding_box_padding = '0.1 0.1 0'
    positions_file = coolant_channel_positions.txt
    output_in_position = true
  []
[]

[Transfers]
  [solid_temp_to_openmc]
    type = MultiAppGeometricInterpolationTransfer
    source_variable = T
    variable = solid_temp
    from_multi_app = bison
  []
  [heat_flux_to_openmc]
    type = MultiAppGeneralFieldNearestNodeTransfer
    source_variable = flux
    variable = flux
    from_multi_app = bison
    source_boundary = 'fluid_solid_interface'
    target_boundary = 'fluid_solid_interface'
    from_postprocessors_to_be_preserved = flux_integral
    to_postprocessors_to_be_preserved = flux_integral
  []
  [source_to_bison]
    type = MultiAppGeneralFieldShapeEvaluationTransfer
    source_variable = heat_source
    variable = power
    direction = to_multiapp
    multi_app = bison
    from_postprocessors_to_be_preserved = heat_source
    to_postprocessors_to_be_preserved = power
  []
  [thm_temp_to_bison]
    type = MultiAppGeometricInterpolationTransfer
    source_variable = thm_temp_wall
    variable = thm_temp
    direction = to_multiapp
    multi_app = bison
  []

  [q_wall_to_thm]
    type = MultiAppGeneralFieldUserObjectTransfer
    variable = q_wall
    direction = to_multiapp
    multi_app = thm
    source_user_object = q_wall_avg
  []
  [T_wall_from_thm]
    type = MultiAppGeneralFieldNearestNodeTransfer
    source_variable = T_wall
    direction = from_multiapp
    multi_app = thm
    variable = thm_temp_wall
    target_boundary = 'fluid_solid_interface'
  []
  [T_bulk_from_thm]
    type = MultiAppGeneralFieldNearestNodeTransfer
    source_variable = T
    direction = from_multiapp
    multi_app = thm
    variable = thm_temp
  []

  # just for postprocessing purposes
  [pressure_from_thm]
    type = MultiAppGeneralFieldNearestNodeTransfer
    source_variable = p
    direction = from_multiapp
    multi_app = thm
    variable = thm_pressure
  []
  [velocity_from_thm]
    type = MultiAppGeneralFieldNearestNodeTransfer
    source_variable = vel_z
    direction = from_multiapp
    multi_app = thm
    variable = thm_velocity
  []
[]

[UserObjects]
  [q_wall_avg]
    type = NearestPointLayeredSideAverage
    boundary = fluid_solid_interface
    variable = flux

    # Note: make this to match the num_elems in the channel
    direction = z
    num_layers = ${num_layers_for_THM}
    points_file = coolant_channel_positions.txt

    direction_min = 0.0
    direction_max = ${height}
  []
  [average_power_axial]
    type = LayeredAverage
    variable = heat_source
    direction = z
    num_layers = ${num_layers_for_plots}
    block = 'compacts'
  []
  [average_fluid_axial]
    type = LayeredAverage
    variable = thm_temp
    direction = z
    num_layers = ${num_layers_for_plots}
    block = '101'
  []
  [average_pressure]
    type = LayeredAverage
    variable = thm_pressure
    direction = z
    num_layers = ${num_layers_for_plots}
    block = '101'
  []
  [average_axial_velocity]
    type = LayeredAverage
    variable = thm_velocity
    direction = z
    num_layers = ${num_layers_for_plots}
    block = '101'
  []
[]

[VectorPostprocessors]
  [power_avg]
    type = SpatialUserObjectVectorPostprocessor
    userobject = average_power_axial
  []
  [fluid_avg]
    type = SpatialUserObjectVectorPostprocessor
    userobject = average_fluid_axial
  []
  [pressure_avg]
    type = SpatialUserObjectVectorPostprocessor
    userobject = average_pressure
  []
  [velocity_avg]
    type = SpatialUserObjectVectorPostprocessor
    userobject = average_axial_velocity
  []
[]

[Executioner]
  type = Transient
  num_steps = 10
[]

[Outputs]
  exodus = true
  csv = true
  hide = 'P_in flux_integral z'
[]
