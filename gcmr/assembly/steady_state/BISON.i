TsInit = 1150.0 # Solid initial temperature
Tcin = 1150.0 # Coolant initial temperature
radiusTransfer = 0.015 # r + 0.009. Extends past the first mesh cell surrounding the coolant channel.
coolant_full_points_filename = ../channel_positions/coolant_full_points.txt # File containing the inlet position of your coolant channels
coolant_half_points_filename = ../channel_positions/coolant_half_points.txt # File containing the inlet position of your coolant channels

[GlobalParams]
  flux_conversion_factor = 1
[]

[Problem]
  register_objects_from = 'BisonApp'
  #library_path = '/beegfs1/software/NEAMS_microreactor/projects_super_mar22/bison/lib'
[]

[Mesh]
  # so that the others are disregarded
  final_generator = fmg
  [fmg] # load mesh
    type = FileMeshGenerator
    file = '../MESH/BISON_mesh.e'
  []
  [full_coolant_surf_mesh] # create sideset around coolant_full channel
    type = SideSetsBetweenSubdomainsGenerator
    input = fmg
    paired_block = coolant_full
    primary_block = 'monolith reflector'
    new_boundary = full_coolant_surf
  []
  [half_coolant_surf_mesh] # create sideset around coolant_half channel
    type = SideSetsBetweenSubdomainsGenerator
    input = full_coolant_surf_mesh
    paired_block = coolant_half
    primary_block = 'monolith reflector'
    new_boundary = half_coolant_surf
  []
  [ed0]
    type = BlockDeletionGenerator
    input = half_coolant_surf_mesh
    block = 'coolant_half coolant_full'
  []
[]

[Variables]
  [temp]
    order = FIRST
    family = LAGRANGE
    initial_condition = ${TsInit}
    #scaling = 1.0e-2
  []
[]

[Kernels]
  [heat_conduction]
    type = HeatConduction
    variable = temp
  []
  [heat_ie]
    type = HeatConductionTimeDerivative
    variable = temp
  []
  [heat_source_fuel]
    type = CoupledForce
    variable = temp
    block = 'Fuel Fuel_tri'
    v = power_density
  []
[]

[AuxVariables]
  [power_density]
    block = 'Fuel Fuel_tri'
    family = L2_LAGRANGE
    order = FIRST
  []
  [Tfuel]
    block = 'Fuel Fuel_tri'
  []
  [hfluid] # Heat Transfer coefficient
    # Calculated by SAM and then transfered with the scaling factor.
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 2000.00
    block = 'monolith reflector reflector_tri' # Can set it on the monolith or coolant.
  []
  [Tfluid] # Coolant temperature.
    order = CONSTANT
    family = MONOMIAL
    initial_condition = ${Tcin}
    block = 'monolith reflector reflector_tri' # Can set it on the monolith or coolant.
  []
[]

[AuxKernels]
  [assign_tfuel]
    type = NormalizationAux
    variable = Tfuel
    source_variable = temp
    execute_on = 'timestep_end'
  []
[]

[BCs]
  [coolant_bc]
    type = CoupledConvectionBC
    T_external = Tfluid
    h_external = hfluid
    boundary = 'full_coolant_surf half_coolant_surf'
    variable = temp
  []

  [outside_bc]
    type = ConvectiveFluxFunction # (Robin BC)
    variable = temp
    boundary = 'top_boundary bottom_boundary'
    coefficient = 0.15 # W/K/m^2 (air)
    T_infinity = 873.5 # K air temperature at the top of the core
  []
[]

[Materials]
  [fuel_matrix_thermal]
    type = GraphiteMatrixThermal
    block = 'Fuel Fuel_tri'
    # unirradiated_type = 'A3_27_1800'
    packing_fraction = 0.4
    specific_heat_scale_factor = 1.0
    thermal_conductivity_scale_factor = 1.0
    fast_neutron_fluence = 0 #6.75E+24 # this value is nuetron fluence over 0.1MeV
    temperature = temp
  []
  [monolith_matrix_thermal]
    type = GraphiteMatrixThermal
    block = 'monolith '
    # unirradiated_type = 'A3_27_1800'
    packing_fraction = 0
    specific_heat_scale_factor = 1.0
    thermal_conductivity_scale_factor = 1.0
    fast_neutron_fluence = 0 #6.75E+24 # this value is nuetron fluence over 0.1MeV
    temperature = temp
  []
  [moderator_thermal]
    type = HeatConductionMaterial
    block = moderator
    temp = temp
    thermal_conductivity = 20 # W/m/K
    specific_heat = 500 # random value
  []
  [YH_liner_Cr_thermal]
    type = ChromiumThermal
    block = Cr
    temperature = temp
    outputs = all
  []
  [YH_Cladding_thermal]
    type = FeCrAlThermal
    block = FECRAL
    temperature = temp
    outputs = all
  []
  [Poison_blocks_thermal]
    type = HeatConductionMaterial
    block = B4C
    temp = temp
    thermal_conductivity = 92 # W/m/K
    specific_heat = 960 # random value
  []

  [control_rod_thermal]
    type = HeatConductionMaterial
    block = control #B4C
    temp = temp
    thermal_conductivity = 92 # W/m/K
    specific_heat = 960 # random value
  []

  [Reflector_thermal]
    type = BeOThermal
    block = 'reflector reflector_tri'
    fluence_conversion_factor = 1
    temperature = temp
    outputs = all
  []
  [airgap_thermal]
    type = HeatConductionMaterial
    block = 'Air' # Helium filled in the control rod hole
    temp = temp
    thermal_conductivity = 0.15 # W/m/K
    specific_heat = 5197 # random value
  []

  [fuel_density]
    type = Density
    block = 'Fuel Fuel_tri'
    density = 2276.5
  []
  [moderator_density]
    type = Density
    block = moderator
    density = 4.3e3
  []
  [monolith_density]
    type = Density
    block = monolith
    density = 1806
  []
  [YH_Liner_Cr_density]
    type = Density
    block = Cr
    density = 7190
  []
  [YH_Cladding_density]
    type = Density
    block = FECRAL
    density = 7250
  []
  [Poison_blocks_density]
    type = Density
    block = B4C
    density = 2510
  []
  [control_rod_density]
    type = Density
    block = control #B4C
    density = 2510
  []

  [airgap_density]
    type = Density
    block = 'Air' #helium
    density = 180
  []

  [reflector_density]
    type = GenericConstantMaterial
    block = 'reflector reflector_tri'
    prop_names = 'density fast_neutron_fluence porosity'
    prop_values = '3000 0 0'
  []
[]

[UserObjects]
  # UserObject to convert the temperature distribution on the inner coolant
  # surface to a 1D profile.
  [Tw_UO]
    type = NearestPointLayeredSideAverage
    variable = temp
    direction = z
    num_layers = 40
    boundary = 'full_coolant_surf '
    execute_on = 'TIMESTEP_END'
    points_file = ${coolant_full_points_filename}
  []
  [Tw_UO_half]
    type = NearestPointLayeredSideAverage
    variable = temp
    direction = z
    num_layers = 40
    boundary = 'half_coolant_surf '
    execute_on = 'TIMESTEP_END'
    points_file = ${coolant_half_points_filename}
  []
[]

[MultiApps]
  [coolant_full_MA]
    type = TransientMultiApp
    app_type = SamApp
    positions_file = ${coolant_full_points_filename}
    bounding_box_padding = '0.1 0.1 0.1'
    input_files = 'SAM_full.i'
    execute_on = 'TIMESTEP_END'
    max_procs_per_app = 1
    # keep_solution_during_restore = true
    output_in_position = true
    cli_args = AuxKernels/scale_htc/function='0.997090723*htc'
    # cli_args: this is a conversion to help with the energy balance.
  []
  [coolant_half_MA]
    type = TransientMultiApp
    app_type = SamApp
    positions_file = ${coolant_half_points_filename}
    bounding_box_padding = '0.1 0.1 0.1'
    input_files = 'SAM_half.i'
    execute_on = 'TIMESTEP_END'
    max_procs_per_app = 1
    # keep_solution_during_restore = true
    output_in_position = true
    cli_args = AuxKernels/scale_htc/function='0.997090723*htc'
    # cli_args: this is a conversion to help with the energy balance.
  []
[]

[Transfers]
  # coolant_full
  [Tw_to_coolant]
    # Wall temperature from user object is transferred to fluid domain.
    type = MultiAppUserObjectTransfer
    direction = to_multiapp # From solid to coolant. Variable to move UO into.
    multi_app = coolant_full_MA
    user_object = Tw_UO # Exists in solid.
    variable = Tw # Exists in coolant.
    execute_on = 'TIMESTEP_END'
    displaced_target_mesh = true
  []
  [Tfluid_from_coolant]
    # Fluid temperature from fluid domain is transferred to solid domain.
    type = MultiAppUserObjectGatherTransfer
    radius = ${radiusTransfer}
    direction = from_multiapp # From coolant to solid.
    multi_app = coolant_full_MA
    user_object = Tfluid_UO # Exists in coolant.
    variable = Tfluid # Exists in solid.
    execute_on = 'TIMESTEP_END'
    displaced_source_mesh = true
  []
  [hfluid_from_coolant]
    # Convective HTC from fluid domain is transferred to solid domain.
    type = MultiAppUserObjectGatherTransfer
    radius = ${radiusTransfer}
    direction = from_multiapp # From coolant to solid.
    multi_app = coolant_full_MA
    user_object = hfluid_UO # Exists in coolant.
    variable = hfluid # Exists in solid.
    execute_on = 'TIMESTEP_END'
    displaced_source_mesh = true
  []

  # coolant_half
  [Tw_to_coolant_half]
    # Wall temperature from user object is transferred to fluid domain.
    type = MultiAppUserObjectTransfer
    direction = to_multiapp # From solid to coolant. Variable to move UO into.
    multi_app = coolant_half_MA
    user_object = Tw_UO_half # Exists in solid.
    variable = Tw # Exists in coolant.
    execute_on = 'TIMESTEP_END'
    displaced_target_mesh = true
  []
  [Tfluid_from_coolant_half]
    # Fluid temperature from fluid domain is transferred to solid domain.
    type = MultiAppUserObjectGatherTransfer
    radius = ${radiusTransfer}
    direction = from_multiapp # From coolant to solid.
    multi_app = coolant_half_MA
    user_object = Tfluid_UO # Exists in coolant.
    variable = Tfluid # Exists in solid.
    execute_on = 'TIMESTEP_END'
    displaced_source_mesh = true
  []
  [hfluid_from_coolant_half]
    # Convective HTC from fluid domain is transferred to solid domain.
    type = MultiAppUserObjectGatherTransfer
    radius = ${radiusTransfer}
    direction = from_multiapp # From coolant to solid.
    multi_app = coolant_half_MA
    user_object = hfluid_UO # Exists in coolant.
    variable = hfluid # Exists in solid.
    execute_on = 'TIMESTEP_END'
    displaced_source_mesh = true
  []
[]

[Preconditioning]
  [SMP]
    type = SMP
    full = true
  []
[]

[Executioner]
  type = Transient

  # petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart '
  # petsc_options_value = 'hypre boomeramg 100'

  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package -ksp_gmres_restart'
  petsc_options_value = 'lu       superlu_dist                  51'
  line_search = 'none'

  nl_abs_tol = 5e-9
  nl_rel_tol = 1e-8

  start_time = -2.5e5 # negative start time so we can start running from t = 0
  end_time = 0
  dt = 1e4

  automatic_scaling = true
[]

[Postprocessors]
  [fuel_temp_avg]
    type = ElementAverageValue
    variable = temp
    block = 'Fuel Fuel_tri'
  []
  [fuel_temp_max]
    type = ElementExtremeValue
    variable = temp
    block = 'Fuel Fuel_tri'
  []
  [fuel_temp_min]
    type = ElementExtremeValue
    variable = temp
    block = 'Fuel Fuel_tri'
    value_type = min
  []
  [mod_temp_avg]
    type = ElementAverageValue
    variable = temp
    block = moderator
  []
  [mod_temp_max]
    type = ElementExtremeValue
    variable = temp
    block = moderator
  []
  [mod_temp_min]
    type = ElementExtremeValue
    variable = temp
    block = moderator
    value_type = min
  []
  [monolith_temp_avg]
    type = ElementAverageValue
    variable = temp
    block = monolith
  []
  [monolith_temp_max]
    type = ElementExtremeValue
    variable = temp
    block = monolith
  []
  [monolith_temp_min]
    type = ElementExtremeValue
    variable = temp
    block = monolith
    value_type = min
  []
  [heatpipe_surface_temp_avg]
    type = SideAverageValue
    variable = temp
    boundary = 'full_coolant_surf half_coolant_surf'
  []
  [power_density]
    type = ElementIntegralVariablePostprocessor
    block = 'Fuel Fuel_tri'
    variable = power_density
    execute_on = 'initial timestep_end'
  []
[]

[Outputs]
  interval = 1
  [exodus]
    type = Exodus
  []
  [csv]
    type = CSV
  []
  perf_graph = true
  color = true
  checkpoint = true
[]
