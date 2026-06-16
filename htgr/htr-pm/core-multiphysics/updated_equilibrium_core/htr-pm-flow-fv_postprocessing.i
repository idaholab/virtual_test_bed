# ==============================================================================
# Material property output
# ==============================================================================

[AuxVariables]
  [porosity_var]
    type = MooseVariableFVReal
    block = ${fluid_blocks}
  []

  [alpha_var]
    type = MooseVariableFVReal
    block = 'pebble_bed top_reflector
             bottom_reflector hot_plenum
             cold_plenum riser bypass'
  []

  [effective_thermal_conductivity_var0]
    type = MooseVariableFVReal
    block = ${solid_blocks}
  []

  [effective_thermal_conductivity_var1]
    type = MooseVariableFVReal
    block = ${solid_blocks}
  []

  [kappa_f_var0]
    type = MooseVariableFVReal
    block = ${fluid_blocks}
  []

  [kappa_f_var1]
    type = MooseVariableFVReal
    block = ${fluid_blocks}
  []
[]

[AuxKernels]
  [porosity_var_aux]
    type = FunctorAux
    variable = porosity_var
    functor = 'porosity'
    block = ${fluid_blocks}
  []

  [alpha_var_aux]
    type = FunctorAux
    variable = alpha_var
    functor = 'alpha'
    block = 'pebble_bed top_reflector
             bottom_reflector hot_plenum
             cold_plenum riser bypass'
  []

  [effective_thermal_conductivity_var0_aux]
    type = ADFunctorVectorElementalAux
    variable = effective_thermal_conductivity_var0
    functor = 'effective_thermal_conductivity'
    block = ${solid_blocks}
    component = 0
  []

  [effective_thermal_conductivity_var1_aux]
    type = ADFunctorVectorElementalAux
    variable = effective_thermal_conductivity_var1
    functor = 'effective_thermal_conductivity'
    block = ${solid_blocks}
    component = 1
  []

  [kappa_f_var0_aux]
    type = ADFunctorVectorElementalAux
    variable = kappa_f_var0
    functor = 'kappa'
    block = ${fluid_blocks}
    component = 0
  []

  [kappa_f_var1_aux]
    type = ADFunctorVectorElementalAux
    variable = kappa_f_var1
    functor = 'kappa'
    block = ${fluid_blocks}
    component = 1
  []
[]

# ==============================================================================
# Integral postprocessing
# ==============================================================================

[Postprocessors]

  # Flow rate postprocessing
  [outlet_mfr]
    type = VolumetricFlowRate
    vel_x = superficial_vel_x
    vel_y = superficial_vel_y
    advected_quantity = rho
    boundary = reactor_outlet
    execute_on = 'initial timestep_end'
  []
  [bypass_mfr]
    type = VolumetricFlowRate
    vel_x = superficial_vel_x
    vel_y = superficial_vel_y
    advected_quantity = rho
    boundary = bypass_hot_plenum_interface
  []

  # Pressure postprocessing
  [pressure_inlet]
    type = SideAverageValue
    boundary = 'reactor_inlet'
    variable = pressure
    execute_on = 'initial TIMESTEP_END'
    outputs = 'none'
  []
  [pressure_outlet]
    type = SideAverageValue
    boundary = 'reactor_outlet'
    variable = pressure
    execute_on = 'initial TIMESTEP_END'
    outputs = 'none'
  []
  [core_delta_p]
    type = ParsedPostprocessor
    expression ='pressure_inlet - pressure_outlet'
    pp_names = 'pressure_inlet pressure_outlet'
    execute_on = 'initial TIMESTEP_END'
  []

  [total_power]
    type = ElementIntegralVariablePostprocessor
    variable = power_density
    block = 'pebble_bed'
    execute_on = 'initial timestep_end'
  []
  [core_volume]
    type = VolumePostprocessor
    block = 'pebble_bed'
    execute_on = 'initial timestep_end'
    outputs = 'none'
  []

  # Temperature postprocessing
  [bed_solid_avg_temperature]
    type = ElementAverageValue
    variable = T_solid
    execute_on = 'initial timestep_end'
    block = 'pebble_bed'
  []
  [ref_max_temperature]
    type = ElementExtremeValue
    variable = T_solid
    execute_on = 'initial timestep_end'
    block = 'side_reflector'
  []
  [ref_avg_temperature]
    type = ElementAverageValue
    variable = T_solid
    execute_on = 'initial timestep_end'
    block = 'side_reflector'
  []
  [barrel_max_temperature]
    type = ElementExtremeValue
    variable = T_solid
    execute_on = 'initial timestep_end'
    block = 'core_barrel'
  []
  [barrel_avg_temperature]
    type = ElementAverageValue
    variable = T_solid
    execute_on = 'initial timestep_end'
    block = 'core_barrel'
  []
  [rpv_max_temperature]
    type = ElementExtremeValue
    variable = T_solid
    execute_on = 'initial timestep_end'
    block = 'rpv'
  []
  [rpv_avg_temperature]
    type = ElementAverageValue
    variable = T_solid
    execute_on = 'initial timestep_end'
    block = 'rpv'
  []
  [rpv_side_temp]
    type = SideAverageValue
    variable = 'T_solid'
    execute_on = 'initial timestep_end'
    boundary = 'right'
  []

  # Exterior heat flux postprocessing
  [rpv_convection_diffusion]
    type = SideFVFluxBCIntegral
    boundary = right
    fvbcs = 'convection'
  []
  [rpv_radiation]
    type = SideFVFluxBCIntegral
    boundary = right
    fvbcs = 'radiation'
  []
  [rpv_tot_out]
    type = ParsedPostprocessor
    expression ='rpv_radiation + rpv_convection_diffusion'
    pp_names = 'rpv_radiation rpv_convection_diffusion'
    execute_on = 'initial timestep_end'
  []

  # Advective heat flux postprocessing
  [h_flow_in]
    type = VolumetricFlowRate
    vel_x = superficial_vel_x
    vel_y = superficial_vel_y
    advected_quantity = 'rho_h'
    boundary = reactor_inlet
    execute_on = 'initial timestep_end'
    outputs = 'none'
  []
  [h_flow_out]
    type = VolumetricFlowRate
    vel_x = superficial_vel_x
    vel_y = superficial_vel_y
    advected_quantity = 'rho_h'
    boundary = reactor_outlet
    execute_on = 'initial timestep_end'
    outputs = 'none'
  []
  [advection_energy_balance]
    type = ParsedPostprocessor
    expression ='h_flow_in - h_flow_out'
    pp_names = 'h_flow_in h_flow_out'
    execute_on = 'initial timestep_end'
  []

  # should be 0 at steady-state, demonstrating conservation of energy
  # imbalance generally comes from:
  # - an inadequacy of the postprocessing of fluxes for the discretization chosen
  # - transient behavior, the heat needs time to reach rpv outer surface
  [total_balance_percent]
    type = ParsedPostprocessor
    expression = '(advection_energy_balance + rpv_tot_out + total_power) / ${reference_power} * 100'
    pp_names = 'advection_energy_balance rpv_tot_out total_power'
    execute_on = 'initial timestep_end'
  []
[]
