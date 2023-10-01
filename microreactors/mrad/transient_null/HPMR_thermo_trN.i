################################################################################
## NEAMS Micro-Reactor Application Driver                                     ##
## Heat Pipe Microreactor Null Transient                                      ##
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

[Problem]
  restart_file_base = '../steady/HPMR_dfem_griffin_ss_out_bison0_cp/LATEST'
  force_restart = true
[]

[GlobalParams]
  flux_conversion_factor = 1
[]

[Mesh]
  file = '../steady/HPMR_dfem_griffin_ss_out_bison0_cp/LATEST'
[]

[Variables]
  [temp]
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
    block = 'fuel_quad fuel_tri'
    v = power_density
  []
[]

[AuxVariables]
  [power_density]
    block = 'fuel_quad fuel_tri'
    family = L2_LAGRANGE
    order = FIRST
  []
  [Tfuel]
    block = 'fuel_quad fuel_tri'
  []
  [Tmod]
    block = 'moderator_quad moderator_tri'
  []
  [fuel_thermal_conductivity]
    block = 'fuel_quad fuel_tri'
    order = CONSTANT
    family = MONOMIAL
  []
  [fuel_specific_heat]
    block = 'fuel_quad fuel_tri'
    order = CONSTANT
    family = MONOMIAL
  []
  [monolith_thermal_conductivity]
    block = 'monolith '
    order = CONSTANT
    family = MONOMIAL
  []
  [monolith_specific_heat]
    block = 'monolith '
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
  []
[]

[AuxKernels]
  [assign_tfuel]
    type = NormalizationAux
    variable = Tfuel
    source_variable = temp
    execute_on = 'timestep_end'
  []
  [assign_tmod]
    type = NormalizationAux
    variable = Tmod
    source_variable = temp
    execute_on = 'timestep_end'
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
    block = 'fuel_quad fuel_tri'
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
    block = 'moderator_quad moderator_tri'
    temp = temp
    thermal_conductivity = 20 # W/m/K
    specific_heat = 500 # random value
  []
  [airgap_thermal]
    type = HeatConductionMaterial
    block = 'air_gap_tri air_gap_quad outer_shield' # Helium gap
    temp = temp
    thermal_conductivity = 0.15 # W/m/K
    specific_heat = 5197 # random value
  []
  [axial_reflector_thermal]
    type = HeatConductionMaterial
    block = 'reflector_tri reflector_quad'
    temp = temp
    thermal_conductivity = 199 # W/m/K
    specific_heat = 1867 # random value
  []
  [B4C_thermal]
    type = HeatConductionMaterial
    block = 'B4C'
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
    block = 'fuel_quad fuel_tri'
    density = 2276.5
  []
  [moderator_density]
    type = Density
    block = 'moderator_quad moderator_tri'
    density = 4.3e3
  []
  [monolith_density]
    type = Density
    block = 'monolith'
    density = 1806
  []
  [airgap_density]
    type = Density
    block = 'air_gap_tri air_gap_quad outer_shield' #helium
    density = 180
  []
  [axial_reflector_density]
    type = Density
    block = 'reflector_tri reflector_quad'
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
    positions_file = 'hp_centers.txt'
    input_files = 'HPMR_sockeye_trN.i'
    execute_on = 'initial timestep_begin' # execute on timestep begin because hard to have a good initial guess on heat flux
    max_procs_per_app = 1
    output_in_position = true
  []
[]

[Transfers]
  [from_sockeye_temp]
    type = MultiAppGeneralFieldNearestLocationTransfer
    from_multi_app = sockeye
    source_variable = hp_temp_aux
    variable = hp_temp_aux
    execute_on = 'initial timestep_begin'
  []
  [to_sockeye_flux]
    type = MultiAppGeneralFieldNearestLocationTransfer
    to_multi_app = sockeye
    source_variable = flux_uo_corr
    variable = master_flux
    execute_on = 'initial timestep_begin'
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
[]

[Executioner]
  type = Transient

  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart '
  petsc_options_value = 'hypre boomeramg 100'

  nl_rel_tol = 1e-6
  nl_abs_tol = 1e-8

  start_time = 0
  end_time = 200
  dt = 1
[]

[Postprocessors]
  [hp_heat_integral]
    type = SideDiffusiveFluxIntegral
    variable = temp
    boundary = 'heat_pipe_ht_surf'
    diffusivity = thermal_conductivity
    execute_on = 'initial timestep_end'
  []
  [fuel_temp_avg]
    type = ElementAverageValue
    variable = temp
    block = 'fuel_quad fuel_tri'
  []
  [fuel_temp_max]
    type = ElementExtremeValue
    variable = temp
    block = 'fuel_quad fuel_tri'
  []
  [fuel_temp_min]
    type = ElementExtremeValue
    variable = temp
    block = 'fuel_quad fuel_tri'
    value_type = min
  []
  [mod_temp_avg]
    type = ElementAverageValue
    variable = temp
    block = 'moderator_quad moderator_tri'
  []
  [mod_temp_max]
    type = ElementExtremeValue
    variable = temp
    block = 'moderator_quad moderator_tri'
  []
  [mod_temp_min]
    type = ElementExtremeValue
    variable = temp
    block = 'moderator_quad moderator_tri'
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
    block = 'fuel_quad fuel_tri'
    variable = power_density
    execute_on = 'initial timestep_end transfer'
  []
  [fuel_cP]
    type = ElementExtremeValue
    value_type = 'max'
    variable = fuel_specific_heat
    block = 'fuel_quad fuel_tri'
    execute_on = 'initial timestep_end'
  []
  [fuel_k]
    type = ElementExtremeValue
    value_type = 'max'
    variable = fuel_thermal_conductivity
    block = 'fuel_quad fuel_tri'
    execute_on = 'initial timestep_end'
  []
  [monolith_cP]
    type = ElementExtremeValue
    value_type = 'max'
    variable = monolith_specific_heat
    block = 'monolith '
    execute_on = 'initial timestep_end'
  []
  [monolith_k]
    type = ElementExtremeValue
    value_type = 'max'
    variable = monolith_thermal_conductivity
    block = 'monolith '
    execute_on = 'initial timestep_end'
  []
[]
[Outputs]
  perf_graph = true
  exodus = true
  color = true
  csv = true
[]
