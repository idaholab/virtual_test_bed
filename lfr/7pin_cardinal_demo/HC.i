################################################################################
## Lead Fast Reactor 7-pin assembly
## Solid heat transfer simulation
## Documentation: https://mooseframework.inl.gov/virtual_test_bed/lfr/cardinal_7pincell/Cardinal_7pin_LFR_demo.html
## Contact: hansol.park@anl.gov
################################################################################

fuel_r_o = 0.004318648          # m
fuel_r_i = 0.00202042           # m
num_layers_fuel = 40
num_layers_refl = 8

linearpower = 27466.11572112955 # W/m
inlet_T = 693.15                # K
fuelconductance = 1.882         # W/m/K
cladconductance = 21.6          # W/m/K
gapconductance = 0.251          # W/m/K

#half_asmpitch = '${fparse flat_to_flat / 2 + duct_thickness}'
powerdensity = ${fparse linearpower / (pi * (fuel_r_o * fuel_r_o - fuel_r_i * fuel_r_i))}

[Mesh]
  [fmg]
    type = FileMeshGenerator
    file = 'HCmesh_in.e'
    exodus_extra_element_integers = 'pin_id'
  []
[]

[Executioner]
  type = Transient
  solve_type = 'PJFNK'

  l_max_its = 50
  l_tol = 1e-9
  nl_max_its = 50
  nl_rel_tol = 1e-6
  nl_abs_tol = 1e-8


  dt = 0.0455311973018550    # 0.9106239460371001 ms (deltaT_NekRS) * 50
  end_time = 4.5531197301855 # 0.0455311973018550 s * 100

[]

[Problem]
  type = FEProblem
  # Fluid regions in mesh are only for transferring fields from NekRS to Griffin
  kernel_coverage_check = false
[]

[AuxVariables]
  [heat_source]
    family = MONOMIAL
    order = CONSTANT
  []
  [nek_bulk_temp]
    initial_condition= ${inlet_T}
    block = 'Lead'
  []
  [nek_surf_temp]
    initial_condition= ${inlet_T}
  []
  [heat_flux]
    family = MONOMIAL
    order = CONSTANT
    block = 'HeliumHolePrism HeliumHole Fuel Clad Duct LowerReflector UpperReflector LowerReflectorPrism UpperReflectorPrism'
  []
  [heat_flux_nodal]
    block = 'HeliumHolePrism HeliumHole Fuel Clad Duct LowerReflector UpperReflector LowerReflectorPrism UpperReflectorPrism'
  []
[]

[Variables]
  [solid_temp]
    initial_condition = ${inlet_T}
    block = 'HeliumHolePrism HeliumHole Fuel Clad Duct LowerReflector UpperReflector LowerReflectorPrism UpperReflectorPrism'
  []
[]

[ICs]
  [heat_fuel]
    type = ConstantIC
    variable = heat_source
    value = ${powerdensity}
    block = 'Fuel'
  []
  [heat_duct]
    type = ConstantIC
    variable = heat_source
    value = ${fparse powerdensity*0.01}
    block = 'Duct'
  []
[]

[BCs]
  [rod_outer]
    type = MatchedValueBC
    variable = solid_temp
    v = nek_surf_temp
    boundary = 'ROD_SIDE'
  []
  [duct_inner]
    type = MatchedValueBC
    variable = solid_temp
    v = nek_surf_temp
    boundary = 'DUCT_INNERSIDE'
  []
[]

[Kernels]
  [diff]
     type = HeatConduction
     variable = solid_temp
     block = 'HeliumHolePrism HeliumHole Fuel Clad Duct LowerReflector UpperReflector LowerReflectorPrism UpperReflectorPrism'
  []
  [sourceterm]
     type = CoupledForce
     variable = solid_temp
     v = heat_source
     block = 'HeliumHolePrism HeliumHole Fuel Clad Duct LowerReflector UpperReflector LowerReflectorPrism UpperReflectorPrism'
  []
[]

[Materials]
  [HeatConduct_Fuel]
    type = HeatConductionMaterial
    temp = solid_temp
    thermal_conductivity = ${fuelconductance}
    block = 'Fuel'
  []
  [HeatConduct_Gap]
    type = HeatConductionMaterial
    temp = solid_temp
    thermal_conductivity = ${gapconductance}
    block = 'HeliumHolePrism HeliumHole'
  []
  [HeatConduct_Clad]
    type = HeatConductionMaterial
    temp = solid_temp
    thermal_conductivity = ${cladconductance}
    block = 'Clad Duct LowerReflector UpperReflector LowerReflectorPrism UpperReflectorPrism'
  []
  [HeatConduct_dummy]
    type = HeatConductionMaterial
    temp = nek_bulk_temp
    thermal_conductivity = 1.0
    block = 'Lead'
  []
[]

[AuxKernels]
  [heat_flux]
    type = DiffusionFluxAux
    diffusion_variable = solid_temp
    component = normal
    diffusivity = thermal_conductivity
    variable = heat_flux
    boundary = 'ROD_SIDE DUCT_INNERSIDE'
  []
  [heat_flux_nodal]
    type = ProjectionAux
    variable = heat_flux_nodal
    v = heat_flux
  []
[]

[Postprocessors]
  [heat_flux_l2_difference]
    type = ElementL2Difference
    variable = heat_flux
    other_variable = heat_flux_nodal
    block = 'HeliumHolePrism HeliumHole Fuel Clad Duct LowerReflector UpperReflector LowerReflectorPrism UpperReflectorPrism'
  []
  [heat_source_rod_duct]
    type = ElementIntegralVariablePostprocessor
    variable = heat_source
    block = 'HeliumHolePrism HeliumHole Fuel Clad Duct LowerReflector UpperReflector LowerReflectorPrism UpperReflectorPrism'
    execute_on = 'initial timestep_begin transfer timestep_end'
  []
  [heat_source_rod]
    type = ElementIntegralVariablePostprocessor
    variable = heat_source
    block = 'HeliumHolePrism HeliumHole Fuel Clad LowerReflector UpperReflector LowerReflectorPrism UpperReflectorPrism'
    execute_on = 'initial timestep_begin transfer timestep_end'
  []
  [heat_source_duct]
    type = ElementIntegralVariablePostprocessor
    variable = heat_source
    block = 'Duct'
    execute_on = 'initial timestep_begin transfer timestep_end'
  []
  [flux_integral_rod]
    type = SideDiffusiveFluxIntegral
    diffusivity = thermal_conductivity
    variable = solid_temp
    boundary = 'ROD_SIDE'
  []
  [flux_integral_duct]
    type = SideDiffusiveFluxIntegral
    diffusivity = thermal_conductivity
    variable = solid_temp
    boundary = 'DUCT_INNERSIDE'
  []
  [nek_bulk_temp_pp]
    type = NodalL2Norm
    variable = nek_bulk_temp
    block = 'Lead'
    execute_on = 'timestep_begin timestep_end'
  []
  [synchronization_to_nek]
    type = Receiver
    default = 1.0
  []
  [duct_temp_max]
    type = ElementExtremeValue
    variable = solid_temp
    block = 'Duct'
    execute_on = 'initial timestep_begin timestep_end'
  []
  [duct_temp_min]
    type = ElementExtremeValue
    variable = solid_temp
    value_type = min
    block = 'Duct'
    execute_on = 'initial timestep_begin timestep_end'
  []
  [duct_temp_avg]
    type = ElementIntegralVariablePostprocessor
    variable = solid_temp
    block = 'Duct'
    execute_on = 'initial timestep_begin timestep_end'
  []
  [gap_temp_max]
    type = ElementExtremeValue
    variable = solid_temp
    block = 'HeliumHolePrism HeliumHole'
    execute_on = 'initial timestep_begin timestep_end'
  []
  [gap_temp_min]
    type = ElementExtremeValue
    variable = solid_temp
    value_type = min
    block = 'HeliumHolePrism HeliumHole'
    execute_on = 'initial timestep_begin timestep_end'
  []
  [fuel_temp_max]
    type = ElementExtremeValue
    variable = solid_temp
    block = 'Fuel'
    execute_on = 'initial timestep_begin timestep_end'
  []
  [fuel_temp_min]
    type = ElementExtremeValue
    variable = solid_temp
    value_type = min
    block = 'Fuel'
    execute_on = 'initial timestep_begin timestep_end'
  []
  [clad_temp_max]
    type = ElementExtremeValue
    variable = solid_temp
    block = 'Clad'
    execute_on = 'initial timestep_begin timestep_end'
  []
  [clad_temp_min]
    type = ElementExtremeValue
    variable = solid_temp
    value_type = min
    block = 'Clad'
    execute_on = 'initial timestep_begin timestep_end'
  []
  [reflB_temp_max]
    type = ElementExtremeValue
    variable = solid_temp
    block = 'LowerReflectorPrism LowerReflector'
    execute_on = 'initial timestep_begin timestep_end'
  []
  [reflB_temp_min]
    type = ElementExtremeValue
    variable = solid_temp
    value_type = min
    block = 'LowerReflectorPrism LowerReflector'
    execute_on = 'initial timestep_begin timestep_end'
  []
  [reflT_temp_max]
    type = ElementExtremeValue
    variable = solid_temp
    block = 'UpperReflectorPrism UpperReflector'
    execute_on = 'initial timestep_begin timestep_end'
  []
  [reflT_temp_min]
    type = ElementExtremeValue
    variable = solid_temp
    value_type = min
    block = 'UpperReflectorPrism UpperReflector'
    execute_on = 'initial timestep_begin timestep_end'
  []
[]

[UserObjects]
  [powercool_axial_uo]
    type = LayeredAverage
    variable = heat_source
    direction = z
    num_layers = ${fparse num_layers_fuel + 2 * num_layers_refl}
    block = 'Lead'
  []
  [powerfuel_axial_uo]
    type = LayeredAverage
    variable = heat_source
    direction = z
    num_layers = ${fparse num_layers_fuel + 2 * num_layers_refl}
    block = 'Fuel LowerReflector UpperReflector'
  []
  [powerduct_axial_uo]
    type = LayeredAverage
    variable = heat_source
    direction = z
    num_layers = ${fparse num_layers_fuel + 2 * num_layers_refl}
    block = 'Duct'
  []
  [solidtemp_axial_uo]
    type = LayeredAverage
    variable = solid_temp
    direction = z
    num_layers = ${fparse num_layers_fuel + 2 * num_layers_refl}
    block = 'Fuel LowerReflector UpperReflector'
  []
  [cooltemp_axial_uo]
    type = LayeredAverage
    variable = nek_bulk_temp
    direction = z
    num_layers = ${fparse num_layers_fuel + 2 * num_layers_refl}
    block = 'Lead'
  []
  [ducttemp_axial_uo]
    type = LayeredAverage
    variable = solid_temp
    direction = z
    num_layers = ${fparse num_layers_fuel + 2 * num_layers_refl}
    block = 'Duct'
  []
  [heatfluxrod_axial_uo]
    type = LayeredSideDiffusiveFluxAverage
    direction = z
    diffusivity = thermal_conductivity
    num_layers = ${fparse num_layers_fuel + 2 * num_layers_refl}
    variable = solid_temp
    boundary = 'ROD_SIDE'
  []
  [heatfluxduct_axial_uo]
    type = LayeredSideDiffusiveFluxAverage
    direction = z
    diffusivity = thermal_conductivity
    num_layers = ${fparse num_layers_fuel + 2 * num_layers_refl}
    variable = solid_temp
    boundary = 'DUCT_INNERSIDE'
  []
[]

[VectorPostprocessors]
  [flux]
    type = VectorOfPostprocessors
    postprocessors = 'heat_source_rod heat_source_duct'
  []
  [powercool_axial_vpp]
    type = SpatialUserObjectVectorPostprocessor
    userobject = powercool_axial_uo
    execute_on = 'timestep_begin timestep_end'
  []
  [powerfue1_axial_vpp]
    type = SpatialUserObjectVectorPostprocessor
    userobject = powerfuel_axial_uo
    execute_on = 'timestep_begin timestep_end'
  []
  [powerduct_axial_vpp]
    type = SpatialUserObjectVectorPostprocessor
    userobject = powerduct_axial_uo
    execute_on = 'timestep_begin timestep_end'
  []
  [solidtemp_axial_vpp]
    type = SpatialUserObjectVectorPostprocessor
    userobject = solidtemp_axial_uo
    execute_on = 'timestep_begin timestep_end'
  []
  [cooltemp_axial_vpp]
    type = SpatialUserObjectVectorPostprocessor
    userobject = cooltemp_axial_uo
    execute_on = 'timestep_begin timestep_end'
  []
  [ducttemp_axial_vpp]
    type = SpatialUserObjectVectorPostprocessor
    userobject = ducttemp_axial_uo
    execute_on = 'timestep_begin timestep_end'
  []
  [heatfluxrod_axial_vpp]
    type = SpatialUserObjectVectorPostprocessor
    userobject = heatfluxrod_axial_uo
    execute_on = 'timestep_begin timestep_end'
  []
  [heatfluxduct_axial_vpp]
    type = SpatialUserObjectVectorPostprocessor
    userobject = heatfluxduct_axial_uo
    execute_on = 'timestep_begin timestep_end'
  []
[]

[MultiApps]
  [nek]
    type = TransientMultiApp
    input_files = 'nek.i'
    sub_cycling = true
    execute_on = timestep_end
  []
[]

[Transfers]
  [heat_flux_rod_to_nek]
    type = MultiAppGeneralFieldNearestLocationTransfer
    source_variable = heat_flux_nodal
    variable = avg_flux
    from_boundaries = 'ROD_SIDE'
    to_boundaries = '3'
    to_multi_app = nek
    greedy_search = true
    search_value_conflicts = false
  []
  [heat_flux_duct_to_nek]
    type = MultiAppGeneralFieldNearestLocationTransfer
    source_variable = heat_flux_nodal
    variable = avg_flux
    from_boundaries = 'DUCT_INNERSIDE'
    to_boundaries = '4'
    to_multi_app = nek
    greedy_search = true
    search_value_conflicts = false
  []
  [flux_integral_to_nek]
    type = MultiAppReporterTransfer
    to_reporters = 'flux_integral/value'
    from_reporters = 'flux/flux'
    to_multi_app = nek
  []
  [nek_surf_temp_rod_to_heatconduction]
    type = MultiAppGeneralFieldNearestLocationTransfer
    source_variable = temp
    variable = nek_surf_temp
    from_boundary = '3'
    to_boundary = 'ROD_SIDE'
    from_multi_app = nek
    search_value_conflicts = false
  []
  [nek_surf_temp_duct_to_heatconduction]
    type = MultiAppGeneralFieldNearestLocationTransfer
    source_variable = temp
    variable = nek_surf_temp
    from_boundary = '4'
    to_boundary = 'DUCT_INNERSIDE'
    from_multi_app = nek
    search_value_conflicts = false
  []
  [nek_bulk_temp_to_heatconduction]
    type = MultiAppGeneralFieldNearestLocationTransfer
    source_variable = temp
    variable = nek_bulk_temp
    from_multi_app = nek
    search_value_conflicts = false
  []
  [synchronization_to_nek]
    type = MultiAppPostprocessorTransfer
    to_postprocessor = transfer_in
    from_postprocessor = synchronization_to_nek
    to_multi_app = nek
  []
[]

[Outputs]
  [console]
    type = Console
    outlier_variable_norms = false
  []
  execute_on = 'timestep_end'
  time_step_interval = 10
  hide = 'synchronization_to_nek'
  exodus = true
  csv = true
  perf_graph = true
[]
