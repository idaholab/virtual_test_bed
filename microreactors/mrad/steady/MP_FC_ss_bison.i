################################################################################
## NEAMS Micro-Reactor Application Driver                                     ##
## BISON Main Application input file                                          ##
## Thermal (Heat Conduction) model only                                       ##
## Constant and uniform power profile in fuel region                          ##
################################################################################

[GlobalParams]
  flux_conversion_factor = 1
[]

# Note: the mesh is stored using git large file system (LFS)
[Mesh]
  file = ../mesh/mrad_mesh.e
[]

[Variables]
  [temp]
    initial_condition = 800
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
    block = fuel
    v = power_density
  []
  [heat_sink_center_comp]
    type = CoupledForce
    variable = temp
    block = heat_pipes
    v = hp_flux_aux
  []
[]

[AuxVariables]
  [power_density]
    block = fuel
    family = L2_LAGRANGE
    order = FIRST
    initial_condition = 3.4e6
  []
  [Tfuel]
    block = fuel
  []
  [fuel_thermal_conductivity]
    block = fuel
    order = CONSTANT
    family = MONOMIAL
  []
  [fuel_specific_heat]
    block = fuel
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
  [temp_uo] #auxvariable to hold heat pipe surface temperature from UserObject
    initial_condition = 800
    block = 'heat_pipes'
  []
  [hp_flux_aux]
    block = 'heat_pipes'
  []
[]

[AuxKernels]
  [assign_tfuel]
    type = NormalizationAux
    variable = Tfuel
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
  [temp_uo]
    type = SpatialUserObjectAux
    variable = temp_uo
    user_object = temp_uo
  []
[]

[BCs]
  [outside_bc] # An "inefficient" cooling mechanism through outer surfaces
    type = ConvectiveFluxFunction # (Robin BC)
    variable = temp
    boundary = 'reflector_surface_all B4C_surface_all air_surface_all'
    coefficient = 1e3 # W/K/m^2
    T_infinity = 800 # K air temperature at the top of the core
  []
[]


[Materials]
  [fuel_matrix_thermal]
    type = GraphiteMatrixThermal
    block = fuel
    packing_fraction = 0.4
    specific_heat_scale_factor = 1.0
    thermal_conductivity_scale_factor = 1.0
    fast_neutron_fluence = 0 # Fresh matrix (near BoC)
    temperature = temp
  []
  [monolith_matrix_thermal]
    type = GraphiteMatrixThermal
    block = 'monolith '
    packing_fraction = 0
    specific_heat_scale_factor = 1.0
    thermal_conductivity_scale_factor = 1.0
    fast_neutron_fluence = 0 # Fresh matrix (near BoC)
    temperature = temp
  []
  [moderator_thermal]
    type = HeatConductionMaterial
    block = moderator
    temp = temp
    thermal_conductivity = 20 # W/m/K
    specific_heat = 500 # arbitrary value
  []
  [heat_pipes_thermal]
    type = HeatConductionMaterial
    block = 'heat_pipes'# Vapor with high thermal conductivity
    temp = temp
    thermal_conductivity = 1e4 # W/m/K
    specific_heat = 5 # arbitrary value
  []
  [airgap_thermal]
    type = HeatConductionMaterial
    block = 'air_gap'# Helium gap
    temp = temp
    thermal_conductivity = 0.15 # W/m/K
    specific_heat = 5197 # arbitrary value
  []
  [axial_reflector_thermal]
    type = HeatConductionMaterial
    block = 'reflector'
    temp = temp
    thermal_conductivity = 199 # W/m/K
    specific_heat = 1867 # arbitrary value
  []
  [B4C_thermal]
    type = HeatConductionMaterial
    block = 'B4C'
    temp = temp
    thermal_conductivity = 92 # W/m/K
    specific_heat = 960 # arbitrary value
  []
  [fuel_density]
    type = Density
    block = fuel
    density = 2276.5
  []
  [moderator_density]
    type = Density
    block = moderator
    density = 4.3e3
  []
  [monolith_density]
    type = Density
    block = 'monolith'
    density = 1806
  []
  [heat_pipes_density]
    type = Density
    block = 'heat_pipes'
    density = 180 #random number for vapor
  []
  [airgap_density]
    type = Density
    block = air_gap #helium
    density = 180
  []
  [axial_reflector_density]
    type = Density
    block = reflector
    density = 1848
  []
  [B4C_density]
    type = Density
    block = B4C
    density =2510
  []
[]

[MultiApps]
  [sockeye]
    type = TransientMultiApp
    positions_file = 'hp_centers.txt'
    input_files = 'MP_FC_ss_sockeye.i'
    execute_on = 'timestep_begin' # execute on timestep begin because hard to have a good initial guess on heat flux
    max_procs_per_app = 1
    output_in_position = true
  []
[]

[Transfers]
  [from_sockeye_flux] # Transfer heat pipe heat flux from Sockeye subapps
    type = MultiAppNearestNodeTransfer
    from_multi_app = sockeye
    source_variable = flux_uo
    variable = hp_flux_aux
    execute_on = 'timestep_begin'
    fixed_meshes = true
  []
  [to_sockeye_temp] # Transfer heat pipe surface temperature to Sockeye subapps
    type = MultiAppNearestNodeTransfer
    to_multi_app = sockeye
    source_variable = temp_uo
    variable = T_wall_var
    execute_on = 'timestep_begin'
    fixed_meshes = true
  []
[]

[UserObjects]
  [temp_uo]
    type = NearestPointLayeredSideAverage
    direction = z
    num_layers = 100
    points_file = 'hp_centers.txt'
    variable = temp
    execute_on = linear
    boundary = 'heat_pipe_boundary_up_side heat_pipe_boundary_core_side'
  []
[]

[Executioner]
  type = Transient

  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package -ksp_gmres_restart'
  petsc_options_value = 'lu       superlu_dist                  51'
  line_search = 'none'

  nl_rel_tol = 1e-7
  nl_abs_tol = 1e-8

  start_time = -2e4 # negative start time so we can start running from t = 0
  end_time = 0
  dtmin = 1
  dt = 50
[]

[Postprocessors]
  [total_evap_heat_exam]
    type = ElementIntegralVariablePostprocessor
    variable = hp_flux_aux
    block = 'heat_pipes'
    execute_on = 'initial timestep_end'
  []
  [hp_heat_integral]
    type = SideDiffusiveFluxIntegral
    variable = temp
    boundary = 'heat_pipe_boundary_up_side heat_pipe_boundary_core_side'
    diffusivity = thermal_conductivity
    execute_on = 'initial timestep_end'
  []
  [fuel_temp_avg]
    type = ElementAverageValue
    variable = temp
    block = fuel
  []
  [fuel_temp_max]
    type = ElementExtremeValue
    variable = temp
    block = fuel
  []
  [fuel_temp_min]
    type = ElementExtremeValue
    variable = temp
    block = fuel
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
    boundary = heat_pipe_boundary_all
  []
  [power_density]
    type = ElementIntegralVariablePostprocessor
    block = fuel
    variable = power_density
    execute_on = 'initial timestep_end'
  []
  [fuel_cP]
    type = ElementExtremeValue
    value_type = 'max'
    variable = fuel_specific_heat
    block = fuel
    execute_on = 'initial timestep_end'
  []
  [fuel_k]
    type = ElementExtremeValue
    value_type = 'max'
    variable = fuel_thermal_conductivity
    block = fuel
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
  csv = false
  #checkpoint = true
[]
