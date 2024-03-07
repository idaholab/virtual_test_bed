!include mesh_baseparam.i
!include mesh_HCparam.i
!include common.i

cladconductance = 21.6          # W/m/K
gapconductance = 0.251          # W/m/K

powerdensity = ${fparse linearpower / (pi * (fuel_r_o * fuel_r_o - fuel_r_i * fuel_r_i))}

[Mesh]
  [fmg]
    type = FileMeshGenerator
    file = 'HCmesh_out.e'
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
  kernel_coverage_check = false
[]

[AuxVariables]
  [heat_source]
    initial_condition= ${powerdensity}
    family = MONOMIAL
    order = CONSTANT
  []
  [nek_bulk_temp]
    initial_condition= ${inlet_T}
    block = ${bid_cool}
  []
  [nek_surf_temp]
    initial_condition= ${inlet_T}
  []
  [heat_flux]
    family = MONOMIAL
    order = CONSTANT
  []
[]

[Variables]
  [solid_temp]
    initial_condition = ${inlet_T}
    block = '${bid_gapc} ${bid_gap} ${bid_fl} ${bid_clad} ${bid_duct} ${bid_lrfl} ${bid_urfl} ${bid_lrflc} ${bid_urflc}'
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
     block = '${bid_gapc} ${bid_gap} ${bid_fl} ${bid_clad} ${bid_duct} ${bid_lrfl} ${bid_urfl} ${bid_lrflc} ${bid_urflc}'
  []
  [sourceterm]
     type = CoupledForce
     variable = solid_temp
     v = heat_source
     block = '${bid_gapc} ${bid_gap} ${bid_fl} ${bid_clad} ${bid_duct} ${bid_lrfl} ${bid_urfl} ${bid_lrflc} ${bid_urflc}'
  []
[]

[Materials]
  [HeatConduct_Fuel]
    type = HeatConductionMaterial
    temp = solid_temp
    thermal_conductivity = ${fuelconductance}
    block = '${bid_fl}'
  []
  [HeatConduct_Gap]
    type = HeatConductionMaterial
    temp = solid_temp
    thermal_conductivity = ${gapconductance}
    block = '${bid_gapc} ${bid_gap}'
  []
  [HeatConduct_Clad]
    type = HeatConductionMaterial
    temp = solid_temp
    thermal_conductivity = ${cladconductance}
    block = '${bid_clad} ${bid_duct} ${bid_lrfl} ${bid_urfl} ${bid_lrflc} ${bid_urflc}'
  []
  [HeatConduct_dummy]
    type = HeatConductionMaterial
    temp = nek_bulk_temp
    thermal_conductivity = 1.0
    block = '${bid_cool}'
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
[]

[Postprocessors]
  [heat_source_rod_duct]
    type = ElementIntegralVariablePostprocessor
    variable = heat_source
    block = '${bid_gapc} ${bid_gap} ${bid_fl} ${bid_clad} ${bid_duct} ${bid_lrfl} ${bid_urfl} ${bid_lrflc} ${bid_urflc}'
    execute_on = 'initial timestep_begin transfer timestep_end'
  []
  [heat_source_rod]
    type = ElementIntegralVariablePostprocessor
    variable = heat_source
    block = '${bid_gapc} ${bid_gap} ${bid_fl} ${bid_clad} ${bid_lrfl} ${bid_urfl} ${bid_lrflc} ${bid_urflc}'
    execute_on = 'initial timestep_begin transfer timestep_end'
  []
  [heat_source_duct]
    type = ElementIntegralVariablePostprocessor
    variable = heat_source
    block = '${bid_duct}'
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
    block = ${bid_cool}
    execute_on = 'timestep_begin timestep_end'
  []
  [synchronization_to_nek]
    type = Receiver
    default = 1.0
  []
  [duct_temp_max]
    type = ElementExtremeValue
    variable = solid_temp
    block = '${bid_duct}'
    execute_on = 'initial timestep_begin timestep_end'
  []
  [duct_temp_min]
    type = ElementExtremeValue
    variable = solid_temp
    value_type = min
    block = '${bid_duct}'
    execute_on = 'initial timestep_begin timestep_end'
  []
  [duct_temp_avg]
    type = ElementIntegralVariablePostprocessor
    variable = solid_temp
    block = '${bid_duct}'
    execute_on = 'initial timestep_begin timestep_end'
  []
  [gap_temp_max]
    type = ElementExtremeValue
    variable = solid_temp
    block = '${bid_gapc} ${bid_gap}'
    execute_on = 'initial timestep_begin timestep_end'
  []
  [gap_temp_min]
    type = ElementExtremeValue
    variable = solid_temp
    value_type = min
    block = '${bid_gapc} ${bid_gap}'
    execute_on = 'initial timestep_begin timestep_end'
  []
  [fuel_temp_max]
    type = ElementExtremeValue
    variable = solid_temp
    block = ${bid_fl}
    execute_on = 'initial timestep_begin timestep_end'
  []
  [fuel_temp_min]
    type = ElementExtremeValue
    variable = solid_temp
    value_type = min
    block = ${bid_fl}
    execute_on = 'initial timestep_begin timestep_end'
  []
  [clad_temp_max]
    type = ElementExtremeValue
    variable = solid_temp
    block = ${bid_clad}
    execute_on = 'initial timestep_begin timestep_end'
  []
  [clad_temp_min]
    type = ElementExtremeValue
    variable = solid_temp
    value_type = min
    block = ${bid_clad}
    execute_on = 'initial timestep_begin timestep_end'
  []
  [reflB_temp_max]
    type = ElementExtremeValue
    variable = solid_temp
    block = '${bid_lrflc} ${bid_lrfl}'
    execute_on = 'initial timestep_begin timestep_end'
  []
  [reflB_temp_min]
    type = ElementExtremeValue
    variable = solid_temp
    value_type = min
    block = '${bid_lrflc} ${bid_lrfl}'
    execute_on = 'initial timestep_begin timestep_end'
  []
  [reflT_temp_max]
    type = ElementExtremeValue
    variable = solid_temp
    block = '${bid_urflc} ${bid_urfl}'
    execute_on = 'initial timestep_begin timestep_end'
  []
  [reflT_temp_min]
    type = ElementExtremeValue
    variable = solid_temp
    value_type = min
    block = '${bid_urflc} ${bid_urfl}'
    execute_on = 'initial timestep_begin timestep_end'
  []
[]

[UserObjects]
  [powercool_axial_uo]
    type = LayeredAverage
    variable = heat_source
    direction = z
    num_layers = ${fparse num_layers_fuel + 2 * num_layers_refl}
    block = '${bid_cool}'
  []
  [powerfuel_axial_uo]
    type = LayeredAverage
    variable = heat_source
    direction = z
    num_layers = ${fparse num_layers_fuel + 2 * num_layers_refl}
    block = '${bid_fl} ${bid_lrfl} ${bid_urfl}'
  []
  [powerduct_axial_uo]
    type = LayeredAverage
    variable = heat_source
    direction = z
    num_layers = ${fparse num_layers_fuel + 2 * num_layers_refl}
    block = '${bid_duct}'
  []
  [solidtemp_axial_uo]
    type = LayeredAverage
    variable = solid_temp
    direction = z
    num_layers = ${fparse num_layers_fuel + 2 * num_layers_refl}
    block = '${bid_fl} ${bid_lrfl} ${bid_urfl}'
  []
  [cooltemp_axial_uo]
    type = LayeredAverage
    variable = nek_bulk_temp
    direction = z
    num_layers = ${fparse num_layers_fuel + 2 * num_layers_refl}
    block = '${bid_cool}'
  []
  [ducttemp_axial_uo]
    type = LayeredAverage
    variable = solid_temp
    direction = z
    num_layers = ${fparse num_layers_fuel + 2 * num_layers_refl}
    block = '${bid_duct}'
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


[Outputs]
  [console]
    type = Console
    outlier_variable_norms = false
  []
  execute_on = 'timestep_end'
  interval = 10
  hide = 'synchronization_to_nek'
  exodus = true
  csv = true
  perf_graph = true
[]

