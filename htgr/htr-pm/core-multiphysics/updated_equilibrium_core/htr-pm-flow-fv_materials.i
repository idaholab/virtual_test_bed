# ==============================================================================
# Materials and closure models
# ==============================================================================

[FluidProperties]
  [fluid_properties_obj]
    type = HeliumFluidProperties
    allow_imperfect_jacobians = true
  []
[]

[Materials]
   ## natural htc for BC
  [natural_htc_mat]
    type = ADGenericConstantMaterial
    prop_names = 'natural_htc'
    prop_values = '5'
  []
[]

[FunctorMaterials]
  ## Solid thermal properties
  [graphite_rho_and_cp]
    type = ADGenericFunctorMaterial
    prop_names =  'rho_s  cp_s'
    prop_values = '1780.0 1697'
    block = 'pebble_bed side_reflector carbon_brick
             bottom_reflector hot_plenum cold_plenum bypass riser
             top_reflector'
  []
  [He_rho_and_cp]
    type = ADGenericFunctorMaterial
    prop_names =  'rho_s  cp_s'
    prop_values = '6      5000'
    block = 'refl_barrel_gap barrel_rpv_gap'
  []
  [pebble_bed_ks]
    type = ADGenericFunctorMaterial
    prop_names =  'k_s'
    prop_values = '26.0'
    block = 'pebble_bed'
  []

  [reflector_ks]
    type = ADGenericFunctorMaterial
    prop_names =  'k_s'
    prop_values = '26.0'
    block = 'side_reflector carbon_brick'
  []

  [core_barrel_steel]
    type = ADGenericFunctorMaterial
    prop_names = 'rho_s   cp_s k_s'
    prop_values = '7800.0 540  17.0'
    block = 'core_barrel'
  []

  [rpv_steel]
    type = ADGenericFunctorMaterial
    prop_names =  'rho_s  cp_s  k_s'
    prop_values = '7800.0 525.0 38.0'
    block = 'rpv'
  []

  [channels_ks]
    type = ADGenericFunctorMaterial
    prop_names =  'k_s'
    prop_values = '20.8'
    block = 'hot_plenum cold_plenum'
  []

  [bypass_ks]
    type = ADGenericFunctorMaterial
    prop_names =  'k_s'
    prop_values = '${fparse 26.0 * (1 - bypass_channel_porosity)}'
    block = 'bypass'
  []

  [riser_ks]
    type = ADGenericFunctorMaterial
    prop_names =  'k_s'
    prop_values = '${fparse 26.0 * (1 - riser_porosity)}'
    block = 'riser'
  []

  [top_reflector_ks]
    type = ADGenericFunctorMaterial
    prop_names =  'k_s'
    prop_values = '${fparse 26.0 * (1 - top_reflector_porosity)}'
    block = 'top_reflector'
  []

  [bottom_reflector_ks]
    type = ADGenericFunctorMaterial
    prop_names =  'k_s'
    prop_values = '${fparse 26.0 * (1 - bottom_reflector_porosity)}'
    block = 'bottom_reflector'
  []

  # Effective solid thermal conductivity in the bed
  [pebble_effective_thermal_conductivity]
    type = FunctorPebbleBedKappaSolid
    radiation = BreitbachBarthels
    emissivity = ${global_emissivity}
    Youngs_modulus = 11.5e9
    Poisson_ratio = 0.31
    wall_distance = wall_distance_uo
    block = 'pebble_bed'
  []

  # we use effective_thermal_conductivity everywhere as thermal conductivity
  # in most regions effective_thermal_conductivity = k_s
  [effective_solid_thermal_conductivity_pb]
    type = ADGenericVectorFunctorMaterial
    prop_names = 'effective_thermal_conductivity'
    prop_values = 'kappa_s kappa_s kappa_s'
    block = 'pebble_bed'
  []

  [effective_solid_thermal_conductivity]
    type = ADGenericVectorFunctorMaterial
    prop_names = 'effective_thermal_conductivity'
    prop_values = 'k_s k_s k_s'
    block = 'top_reflector
             bottom_reflector
             hot_plenum
             cold_plenum
             side_reflector
             carbon_brick
             core_barrel
             rpv
             riser
             bypass'
  []
  [non_pebble_bed_eff_solid_conductivity]
    type = ADGenericVectorFunctorMaterial
    prop_names = 'effective_thermal_conductivity'
    # cannot set to 0, and should be isotropic
    prop_values = '4 4 4'
    block = 'refl_barrel_gap barrel_rpv_gap'
  []

  ## hydraulic diameter and porosity - fixed number per block
  [porosity]
    type = ADPiecewiseByBlockFunctorMaterial
    prop_name = 'porosity'
    subdomain_to_prop_value = 'pebble_bed       ${pebble_bed_porosity}
                               top_reflector    ${top_reflector_porosity}
                               bottom_reflector ${bottom_reflector_porosity}
                               top_cavity       1
                               hot_plenum       ${fluid_channels_porosity}
                               cold_plenum      ${fluid_channels_porosity}
                               side_reflector   0
                               carbon_brick     0
                               core_barrel      0
                               rpv              0
                               riser            ${riser_porosity}
                               bypass           ${bypass_channel_porosity}
                               refl_barrel_gap  0
                               barrel_rpv_gap   0
                              '
  []

  [hydraulic_diameter]
    type = PiecewiseByBlockFunctorMaterial
    prop_name = 'characteristic_length'
    subdomain_to_prop_value = 'pebble_bed       ${pebble_diameter}
                               top_reflector    ${D_H_top_reflector}
                               bottom_reflector ${D_H_bottom_reflector}
                               top_cavity       ${D_H_top_cavity}
                               hot_plenum       1
                               cold_plenum      1
                               riser            ${D_H_riser}
                               bypass           ${D_H_bypass}
                              '
    block = ${fluid_blocks}
  []

  ## Fluid properties and non-dimensional numbers
  [fluid_props_to_mat_props]
    type = GeneralFunctorFluidProps
    pressure = 'pressure'
    T_fluid = 'T_fluid'
    speed = 'speed'
    # To initialize with a high viscosity
    mu_rampdown = 'mu_ramp_fn'
    # For porous flow
    characteristic_length = characteristic_length
    block = ${fluid_blocks}
  []

  ## Volumetric heat transfer coefficient correlations
  [pebble_volumetric_heat_transfer]
    type = FunctorWakaoPebbleBedHTC
    block = 'pebble_bed'
  []

  [bypass_volumetric_heat_transfer]
    type = FunctorDittusBoelterWallHTC
    C = ${fparse C_DB * ApV_bypass}
    block = 'bypass'
  []

  [riser_volumetric_heat_transfer]
    type = FunctorDittusBoelterWallHTC
    C = ${fparse C_DB * ApV_riser}
    block = 'riser'
  []

  [top_reflector_volumetric_heat_transfer]
    type = FunctorDittusBoelterWallHTC
    C = ${fparse C_DB * ApV_top_reflector}
    block = 'top_reflector'
  []

  [bottom_reflector_volumetric_heat_transfer]
    type = FunctorDittusBoelterWallHTC
    C = ${fparse C_DB * ApV_bottom_reflector}
    block = 'bottom_reflector'
  []

  [rename_wall_htc_to_alpha]
    type = ADGenericFunctorMaterial
    prop_names =  'alpha'
    prop_values = 'wall_htc'
    block = 'bypass riser top_reflector bottom_reflector'
  []

  [other_fluid_solid_volumetric_heat_transfer]
    type = ADGenericFunctorMaterial
    prop_names =  'alpha'
    prop_values = '${alpha_fluid_solid}'
    block = 'hot_plenum cold_plenum'
  []

  ## Effective fluid thermal conductivities
  [pebble_bed_effective_fluid_thermal_conductivity]
    type = FunctorLinearPecletKappaFluid
    block = 'pebble_bed'
  []

  #inactive = 'effective_thermal_conductivity_top_cavity'
  [non_pebble_bed_eff_solid_conductivity_2]
    type = ADGenericVectorFunctorMaterial
    prop_names = 'kappa'
    prop_values = '15 15 15'
    block = 'top_cavity'
  []

  [effective_fluid_thermal_conductivity]
    type = ADGenericVectorFunctorMaterial
    prop_names = 'kappa'
    prop_values = 'k k k'
    block = 'top_reflector bottom_reflector
             hot_plenum cold_plenum riser bypass'
  []

  ## Drag correlations
  [drag_pebble_bed]
    type = FunctorKTADragCoefficients
    block = 'pebble_bed'
  []

  [isotropic_drag_hot_plenum]
    type = FunctorIsotropicFunctorDragCoefficients
    Darcy_coefficient_sub = 0
    Forchheimer_coefficient_sub = ${fparse 1.25*scaling}
    block = 'hot_plenum'
  []
  [isotropic_drag_cold_plenum_cavity]
    type = FunctorIsotropicFunctorDragCoefficients
    Darcy_coefficient_sub = 0
    Forchheimer_coefficient_sub = ${fparse 1.25*scaling}
    block = 'cold_plenum top_cavity'
  []

  [drag_Churchill]
    type = FunctorChurchillDragCoefficients
    block = 'riser top_reflector bottom_reflector'
    multipliers = ' 1.0e+05  1.0  1.0e+05 '
  []

  [drag_bypass]
    type = FunctorIsotropicFunctorDragCoefficients
    Darcy_coefficient_sub = 0
    Forchheimer_coefficient_sub = 2000
    block = 'bypass'
  []
[]

[UserObjects]
  [wall_distance_uo]
    type = WallDistanceCylindricalBed
    outer_radius = ${pbed_r}
    axis = 1
    bottom = ${pbed_bottom}
    top = ${pbed_top}
  []
[]
