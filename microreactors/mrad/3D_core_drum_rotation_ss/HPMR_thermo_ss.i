################################################################################
## NEAMS Micro-Reactor Application Driver                                     ##
## Heat Pipe Microreactor Control Drum Rotation Steady State                  ##
## BISON Child Application input file                                         ##
## Thermal Only Physics                                                       ##
################################################################################

R_clad_o = 0.0105 # heat pipe outer radius
R_hp_hole = 0.0107 # heat pipe + gap
num_sides = 12 # number of sides of heat pipe as a result of mesh polygonization
alpha = '${fparse 2 * pi / num_sides}'
perimeter_correction = '${fparse 0.5 * alpha / sin(0.5 * alpha)}' # polygonization correction factor for perimeter
area_correction = '${fparse sqrt(alpha / sin(alpha))}' # polygonization correction factor for area
corr_factor = '${fparse R_hp_hole / R_clad_o * area_correction / perimeter_correction}'

fuel_blocks = 'fuel_tri fuel_quad'
air_blocks = 'air_gap_quad air_gap_tri outer_shield'
b4c_blocks = 'B4C'
mono_blocks = 'monolith'
mod_clad_blocks = 'mod_ss'
yh_blocks = 'moderator_quad moderator_tri'
mod_blocks = '${yh_blocks} ${mod_clad_blocks}'
ref_blocks = 'reflector_quad reflector_tri'

non_fuel_blocks = '${air_blocks} ${b4c_blocks} ${mono_blocks} ${mod_blocks} ${ref_blocks}'
non_yh_blocks = '${fuel_blocks} ${air_blocks} ${b4c_blocks} ${mono_blocks} ${mod_clad_blocks} ${ref_blocks}'

mesh_file = '../mesh/gold/HPMR_OneSixth_Core_meshgenerator_tri_rotate_bdry_fine.e'

[GlobalParams]
  flux_conversion_factor = 1
[]

[Mesh]
  [fmg]
    type = FileMeshGenerator
    file = ${mesh_file}
  []
  parallel_type = distributed
[]

[Variables]
  [temp]
    initial_condition = 800
  []
[]

[Kernels]
  # The time derivative kernel has been removed
  # We are obtaining a steady-state solution and it's preferrable not to march in time
  # to steady state as marching is expensive.
  [heat_conduction]
    type = HeatConduction
    variable = temp
  []
  [heat_source_fuel]
    type = CoupledForce
    variable = temp
    block = ${fuel_blocks}
    v = power_density
  []
[]

[AuxVariables]
  [power_density]
    block = ${fuel_blocks}
    family = L2_LAGRANGE
    order = FIRST
    initial_condition = 3.4e6
  []
  [Tfuel]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 800
  []
  [Tmod]
    order = CONSTANT
    family = MONOMIAL
    initial_condition = 800
  []
  [fuel_thermal_conductivity]
    block = ${fuel_blocks}
    order = CONSTANT
    family = MONOMIAL
  []
  [fuel_specific_heat]
    block = ${fuel_blocks}
    order = CONSTANT
    family = MONOMIAL
  []
  [monolith_thermal_conductivity]
    block = ${mono_blocks}
    order = CONSTANT
    family = MONOMIAL
  []
  [monolith_specific_heat]
    block = ${mono_blocks}
    order = CONSTANT
    family = MONOMIAL
  []
  [flux_uo] #auxvariable to hold heat pipe surface flux from UserObject
    block = 'reflector_quad monolith'
  []
  [flux_uo_corr] #auxvariable to hold corrected flux_uo
    block = 'reflector_quad monolith'
  []
  [hp_temp_aux]
    block = 'reflector_quad monolith'
    # initial_condition = 800
  []
[]

[AuxKernels]
  [assign_tfuel_f]
    type = NormalizationAux
    variable = Tfuel
    source_variable = temp
    execute_on = 'timestep_end'
    block = ${fuel_blocks}
  []
  [assign_tfuel_nf]
    type = SpatialUserObjectAux
    variable = Tfuel
    user_object = Tf_avg
    execute_on = 'timestep_end'
    block = ${non_fuel_blocks}
  []
  [assign_tmod_m]
    type = NormalizationAux
    variable = Tmod
    source_variable = temp
    execute_on = 'timestep_end'
    block = ${yh_blocks}
  []
  [assign_tmod_nm]
    type = SpatialUserObjectAux
    variable = Tmod
    user_object = Tm_avg
    execute_on = 'timestep_end'
    block = ${non_yh_blocks}
  []

  [fuel_thermal_conductivity]
    type = MaterialRealAux
    variable = fuel_thermal_conductivity
    property = thermal_conductivity
    execute_on = timestep_end
  []
  [fuel_specific_heat]
    type = MaterialRealAux
    variable = fuel_specific_heat
    property = specific_heat
    execute_on = timestep_end
  []
  [monolith_thermal_conductivity]
    type = MaterialRealAux
    variable = monolith_thermal_conductivity
    property = thermal_conductivity
    execute_on = timestep_end
  []
  [monolith_specific_heat]
    type = MaterialRealAux
    variable = monolith_specific_heat
    property = specific_heat
    execute_on = timestep_end
  []
  [flux_uo]
    type = SpatialUserObjectAux
    variable = flux_uo
    user_object = flux_uo
  []
  [flux_uo_corr]
    type = NormalizationAux
    variable = flux_uo_corr
    source_variable = flux_uo
    normal_factor = '${fparse corr_factor}'
  []
[]

[BCs]
  [outside_bc]
    type = ConvectiveFluxFunction # (Robin BC)
    variable = temp
    boundary = 'bottom top side'
    coefficient = 1e3 # W/K/m^2
    T_infinity = 800 # K air temperature at the top of the core
  []
  [hp_temp]
    type = CoupledConvectiveHeatFluxBC
    boundary = 'heat_pipe_ht_surf'
    variable = temp
    T_infinity = hp_temp_aux
    htc = 750
  []
[]

[Materials]
  [fuel_matrix_thermal]
    type = GraphiteMatrixThermal
    block = ${fuel_blocks}
    # unirradiated_type = 'A3_27_1800'
    packing_fraction = 0.4
    specific_heat_scale_factor = 1.0
    thermal_conductivity_scale_factor = 1.0
    fast_neutron_fluence = 0 #6.75E+24 # this value is nuetron fluence over 0.1MeV
    temperature = temp
  []
  [monolith_matrix_thermal]
    type = GraphiteMatrixThermal
    block = ${mono_blocks}
    # unirradiated_type = 'A3_27_1800'
    packing_fraction = 0
    specific_heat_scale_factor = 1.0
    thermal_conductivity_scale_factor = 1.0
    fast_neutron_fluence = 0 #6.75E+24 # this value is nuetron fluence over 0.1MeV
    temperature = temp
  []
  [moderator_thermal]
    type = HeatConductionMaterial
    block = ${yh_blocks}
    temp = temp
    thermal_conductivity = 20 # W/m/K
    specific_heat = 500 # random value
  []
  [airgap_thermal]
    type = HeatConductionMaterial
    block = ${air_blocks} # Helium gap
    temp = temp
    thermal_conductivity = 0.15 # W/m/K
    specific_heat = 5197 # random value
  []
  [axial_reflector_thermal]
    type = HeatConductionMaterial
    block = ${ref_blocks}
    temp = temp
    thermal_conductivity = 199 # W/m/K
    specific_heat = 1867 # random value
  []
  [B4C_thermal]
    type = HeatConductionMaterial
    block = ${b4c_blocks}
    temp = temp
    thermal_conductivity = 92 # W/m/K
    specific_heat = 960 # random value
  []
  [SS_thermal]
    type = SS316Thermal
    temperature = temp
    block = mod_ss
  []
  [fuel_density]
    type = Density
    block = ${fuel_blocks}
    density = 2276.5
  []
  [moderator_density]
    type = Density
    block = ${yh_blocks}
    density = 4.3e3
  []
  [monolith_density]
    type = Density
    block = ${mono_blocks}
    density = 1806
  []
  [airgap_density]
    type = Density
    block = ${air_blocks} #helium
    density = 180
  []
  [axial_reflector_density]
    type = Density
    block = ${ref_blocks}
    density = 1848
  []
  [B4C_density]
    type = Density
    block = B4C
    density = 2510
  []
  [SS_density]
    type = Density
    density = 7990
    block = mod_ss
  []
[]

[MultiApps]
  [sockeye]
    type = TransientMultiApp
    app_type = SockeyeApp
    positions_file = 'hp_centers.txt'
    input_files = 'HPMR_sockeye_ss.i'
    execute_on = 'timestep_begin' # execute on timestep begin because hard to have a good initial guess on heat flux
    max_procs_per_app = 1
    output_in_position = true
    sub_cycling = true
  []
[]

[Transfers]
  # HP Transfers
  [from_sockeye_temp]
    type = MultiAppNearestNodeTransfer
    from_multi_app = sockeye
    source_variable = hp_temp_aux
    variable = hp_temp_aux
    execute_on = 'timestep_begin'
    fixed_meshes = true
  []
  [to_sockeye_flux]
    type = MultiAppNearestNodeTransfer
    variable = master_flux
    source_variable = flux_uo_corr
    to_multi_app = sockeye
    execute_on = 'timestep_begin'
    fixed_meshes = true
  []
[]

[UserObjects]
  [flux_uo]
    type = NearestPointLayeredSideDiffusiveFluxAverage
    direction = z
    num_layers = 100
    points_file = 'hp_centers.txt'
    variable = temp
    diffusivity = thermal_conductivity
    execute_on = linear
    boundary = 'heat_pipe_ht_surf'
  []
  [Tf_avg]
    type = LayeredAverage
    variable = temp
    direction = z
    num_layers = 100
    block = ${fuel_blocks}
  []
  [Tm_avg]
    type = LayeredAverage
    variable = temp
    direction = z
    num_layers = 100
    block = ${yh_blocks}
  []
[]

[Executioner]
  type = Transient

  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart '
  petsc_options_value = 'hypre boomeramg 100'

  nl_rel_tol = 1e-6
  nl_abs_tol = 1e-8

  start_time = -5e4 # negative start time so we can start running from t = 0
  end_time = 0
  dtmin = 1
  # Multiple steps are needed to allow iteration between the thermo and heat pipe applications
  num_steps = 5
[]

[Postprocessors]
  [hp_heat_integral]
    type = SideDiffusiveFluxIntegral
    variable = temp
    boundary = 'heat_pipe_ht_surf'
    diffusivity = thermal_conductivity
    execute_on = 'initial timestep_end'
  []
  [hp_end_heat_integral]
    type = SideDiffusiveFluxIntegral
    variable = temp
    boundary = 'heat_pipe_ht_surf_bot'
    diffusivity = thermal_conductivity
    execute_on = 'initial timestep_end'
  []
  [ext_side_integral]
    type = SideDiffusiveFluxIntegral
    variable = temp
    boundary = 'side'
    diffusivity = thermal_conductivity
    execute_on = 'initial timestep_end'
  []
  [mirror_side_integral]
    type = SideDiffusiveFluxIntegral
    variable = temp
    boundary = 'side_mirror'
    diffusivity = thermal_conductivity
    execute_on = 'initial timestep_end'
  []
  [tb_integral]
    type = SideDiffusiveFluxIntegral
    variable = temp
    boundary = 'top bottom'
    diffusivity = thermal_conductivity
    execute_on = 'initial timestep_end'
  []
  [total_sink]
    type = SumPostprocessor
    values = 'hp_heat_integral hp_end_heat_integral ext_side_integral mirror_side_integral tb_integral'
    execute_on = 'initial timestep_end'
  []
  [fuel_temp_avg]
    type = ElementAverageValue
    variable = temp
    block = ${fuel_blocks}
  []
  [fuel_temp_max]
    type = ElementExtremeValue
    variable = temp
    block = ${fuel_blocks}
  []
  [fuel_temp_min]
    type = ElementExtremeValue
    variable = temp
    block = ${fuel_blocks}
    value_type = min
  []
  [mod_temp_avg]
    type = ElementAverageValue
    variable = temp
    block = ${yh_blocks}
  []
  [mod_temp_max]
    type = ElementExtremeValue
    variable = temp
    block = ${yh_blocks}
  []
  [mod_temp_min]
    type = ElementExtremeValue
    variable = temp
    block = ${yh_blocks}
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
    boundary = heat_pipe_ht_surf
  []
  [power]
    type = ElementIntegralVariablePostprocessor
    block = ${fuel_blocks}
    variable = power_density
    execute_on = 'initial timestep_end transfer'
  []
  [fuel_cP]
    type = ElementExtremeValue
    value_type = 'max'
    variable = fuel_specific_heat
    block = ${fuel_blocks}
    execute_on = 'initial timestep_end'
  []
  [fuel_k]
    type = ElementExtremeValue
    value_type = 'max'
    variable = fuel_thermal_conductivity
    block = ${fuel_blocks}
    execute_on = 'initial timestep_end'
  []
  [monolith_cP]
    type = ElementExtremeValue
    value_type = 'max'
    variable = monolith_specific_heat
    block = ${mono_blocks}
    execute_on = 'initial timestep_end'
  []
  [monolith_k]
    type = ElementExtremeValue
    value_type = 'max'
    variable = monolith_thermal_conductivity
    block = ${mono_blocks}
    execute_on = 'initial timestep_end'
  []
  [flux_uo_avg]
    type = ElementAverageValue
    variable = flux_uo_corr
    block = 'reflector_quad monolith'
  []
[]

[Outputs]
  perf_graph = true
  color = true
  csv = false
  [exodus]
    type = Exodus
    execute_on = 'FINAL'
    enable = false
  []
  [cp]
    type = Checkpoint
    additional_execute_on = 'FINAL'
  []
[]
