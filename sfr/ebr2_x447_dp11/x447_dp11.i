################################################################################
## NEAMS Fuel Performance Technical Area                                      ##
## Sodium-Cooled Fast Reactor (SFR) Fuel Performance M&S                      ##
## Metallic Fuel Model V&V Powered by BISON-FIPD Integration                  ##
## IFR Experimental Subassembly X447 Pin DP11 irradiated in EBR-II            ##
## BISON Main Input File                                                      ##
################################################################################

!include model_params.i

[GlobalParams]
  order = FIRST
  energy_per_fission = 3.2e-11 # J/fission
  displacements = 'disp_x disp_y'
  alpha_transition_end = ${alpha_end}
  alpha_transition_start = ${alpha_start}
[]

[Problem]
  type = ReferenceResidualProblem
  reference_vector = 'ref'
  extra_tag_vectors = 'ref'
  group_variables = 'disp_x disp_y'
  converge_on = 'disp_x disp_y temp'
[]

[Mesh]
  # Pin design parameters from FIPD database
  [gen]
    type = FIPDRodletMeshGenerator
    fipd_geom_file = ${raw 'fipd/ ${pin_id} _design.csv'}

    gap_bottom_length = ${gap_bottom_length}                 # arbitrary
    cladding_bottom_plug_length = ${top_bot_cladding_height} # arbitrary
    cladding_top_plug_length = ${top_bot_cladding_height}    # arbitrary

    cladding_sidewall_radial_elements = 10
    cladding_sidewall_axial_element_numbers = '2 150 150'
    cladding_top_plug_radial_elements = 10
    cladding_top_plug_axial_elements = 5
    cladding_bottom_plug_axial_elements = 5
    fuel_radial_elements = 6
    fuel_axial_element_intervals = '0 1'
    fuel_axial_element_numbers = '150'
    use_default_cladding_sidewall_axial_element_intervals = true
    elem_type = QUAD4
    make_stand = true
    make_cap = true
    cap_axial_elements = 15
    stand_axial_elements = 15
  []
  [sodium_height]
    type = SideSetsFromBoundingBoxGenerator
    input = gen
    bottom_left = '0 0 0'
    top_right = '${fparse cladding_ir + cladding_thickness} ${fparse fuel_y_start + fuel_height} 0'
    included_boundaries = 'cladding_inside_right'
    boundary_new = '1005'
  []
  [gas_height]
    type = SideSetsFromBoundingBoxGenerator
    input = sodium_height
    bottom_left = '0 ${fparse fuel_y_start + fuel_height} 0'
    top_right = '${fparse cladding_ir + cladding_thickness} ${fparse fuel_y_start + fuel_height + gas_plenum_height + top_bot_cladding_height} 0'
    included_boundaries = 'cladding_inside_right'
    boundary_new = '1006'
  []
  [sodium_plenum_rename]
    type = RenameBoundaryGenerator
    input = gas_height
    old_boundary = '1005 1006'
    new_boundary = 'sodium_height gas_height'
  []

  patch_size = 120
  patch_update_strategy = always
  partitioner = centroid
  centroid_partitioner_direction = y
  coord_type = RZ
[]

[Variables]
  [temp]
    initial_condition = 298
    block = 'fuel cladding cap stand'
  []
  [disp_x]
    block = 'fuel cladding cap stand'
  []
  [disp_y]
    block = 'fuel cladding cap stand'
  []
[]

[Functions]
  [fflux_axial_peaking_factors] # Fast flux peaking factor from FIPD database; used for fuel related simulations
    type = FIPDAxialProfileFunction
    data_file = ${raw 'fipd/peakingfactor_flux_relative_ ${pin_id} .csv'}
    use_metadata = true
    mesh_generator = gen
    zero_ends = true
    data_shift_type = peaking
    extrapolate_to_zero = true
  []
  [fflux_axial_peaking_factors_elongate] # Fast flux peaking factor from FIPD database; used for cladding related simulations
    type = FIPDAxialProfileFunction
    data_file = ${raw 'fipd/peakingfactor_flux_relative_ ${pin_id} .csv'}
    use_metadata = true
    mesh_generator = gen
    zero_ends = true
    data_shift_type = peaking
    extrapolate_to_zero = true
    fuel_elongation_pp = max_fuel_elongation # pp used to track fuel elongation
  []
  [flux_history] # Time-dependent pin average fast flux from FIPD database
    type = PiecewiseLinear
    data_file = ${raw 'fipd/flux_history_ ${pin_id} .csv'}
  []
  [clad_od_temp] # Time-dependent cladding OD temperature from FIPD database
    type =  FIPDAxialProfileFunction
    data_file = ${raw 'fipd/clad_od_temp_history_ ${pin_id} .csv'}
    use_metadata = true
    mesh_generator = gen
  []
  [ab_sodium_vol]
    type = MeshPropertyFunction
    mesh_generator = gen
    mesh_property_name = sodium_volume
    scale_factor = -1.0
  []
  [sodium_volume]
    # Need to account for the factor that hot pressing is also occupying the open pores
    type = ParsedFunction
    symbol_names = 'porosity_sodium_logging_avg volume_fuel raw_sodium_vol temp_sodium_avg'
    symbol_values = 'porosity_sodium_logging_avg volume_fuel ab_sodium_vol temp_sodium_avg'
    # Note the the symbol before volume_fuel should be negative as volume_fuel itself is negative
    expression = 'raw_sodium_vol * 954 / (1102 - 0.23 * temp_sodium_avg) - volume_fuel * porosity_sodium_logging_avg'
  []
  [power_history] # Time-dependent pin average power from FIPD database
    type = PiecewiseLinear
    data_file = ${raw 'fipd/power_history_ ${pin_id} .csv'}
  []

  [axial_peaking_factors]
    type = FIPDAxialProfileFunction
    data_file = ${raw 'fipd/peakingfactor_power_relative_ ${pin_id} .csv'}
    use_metadata = true
    mesh_generator = gen
    zero_ends = true
    data_shift_type = peaking
  []
  [axial_peaking_factors_extended]
    type = FIPDAxialProfileFunction
    data_file = ${raw 'fipd/peakingfactor_power_relative_ ${pin_id} .csv'}
    use_metadata = true
    mesh_generator = gen
    zero_ends = true
    data_shift_type = peaking
    fuel_elongation_pp = max_fuel_elongation # pp used to track fuel elongation
  []
  [anisotropic_swelling_factor]
    type = ParsedFunction
    symbol_names = 'disp_x_fuel_radial_surface_avg disp_y_fuel_top_surface_avg fuel_height fuel_radius'
    symbol_values = 'disp_x_fuel_radial_surface_avg disp_y_fuel_top_surface_avg ${fuel_height} '
                    '${fuel_radius}'
    expression = '(disp_x_fuel_radial_surface_avg / ${fuel_radius}) / '
                 '(disp_y_fuel_top_surface_avg / ${fuel_height})'
  []
  [gap_thermal_conductivity]
    type = ParsedFunction
    expression = '124.67 - 0.11381 * t + 5.5226e-5 * t^2 - 1.1842e-8 * t^3'
  []

  [id_vpp_func] # vpp_function used to track FCCI-related cladding degradation.
    type = MetallicFuelWastageDegradationFunction
    vectorpostprocessor_name = id_wastage
    argument_column = y
    wastage_type = ID
    value_column = wastage_thickness
    use_metadata = true
    degradation_factor = 0.001
    mesh_generator = 'gen'
    transition_width = 1E-4
  []
  [od_vpp_func] # vpp_function used to track CCCI-related cladding degradation.
    type = MetallicFuelWastageDegradationFunction
    vectorpostprocessor_name = od_wastage
    argument_column = y
    wastage_type = OD
    value_column = cc_wastage_thickness
    use_metadata = true
    degradation_factor = 0.001
    mesh_generator = 'gen'
    transition_width = 1E-4
  []
[]

[Physics/SolidMechanics/QuasiStatic]
  [fuel]
    block = fuel
    strain = FINITE
    generate_output = 'firstinv_strain stress_xx stress_yy stress_zz vonmises_stress '
                      'hydrostatic_stress creep_strain_xx creep_strain_yy creep_strain_zz '
                      'elastic_strain_xx elastic_strain_yy elastic_strain_zz strain_xx strain_yy '
                      'strain_zz'
    extra_vector_tags = 'ref'
    eigenstrain_names = 'fuel_thermal_strain solid_swelling_eigenstrain'
    use_automatic_differentiation = true
    volumetric_locking_correction = true
  []
  [cladding]
    strain = FINITE
    generate_output = 'stress_xx stress_yy stress_zz vonmises_stress hydrostatic_stress '
                      'creep_strain_xx creep_strain_yy creep_strain_zz elastic_strain_xx '
                      'elastic_strain_yy elastic_strain_zz strain_xx strain_yy strain_zz'
    extra_vector_tags = 'ref'
    block = 'cladding'
    eigenstrain_names = 'cladding_thermal_eigenstrain'
    use_automatic_differentiation = true
    volumetric_locking_correction = true
  []
[]

[Kernels]
  [gravity]
    type = ADGravity
    block = 'fuel cladding'
    variable = disp_y
    value = -9.81
    extra_vector_tags = 'ref'
  []
  [heat]
    type = ADHeatConduction
    block = 'fuel cladding cap stand'
    variable = temp
    extra_vector_tags = 'ref'
  []
  [heat_ie]
    type = ADHeatConductionTimeDerivative
    block = 'fuel cladding cap stand'
    variable = temp
    extra_vector_tags = 'ref'
  []
  [heat_source]
    type = ADFissionRateHeatSource
    variable = temp
    block = 'fuel'
    fission_rate = fission_rate
    extra_vector_tags = 'ref'
    energy_deposited_in_fuel = 0.95
  []

  # Diffusion kernels are used for displacement in non-solid regions
  [disp_x_dt]
    type = ADTimeDerivative
    variable = disp_x
    block = ' cap stand'
    extra_vector_tags = 'ref'
  []
  [disp_y_dt]
    type = ADTimeDerivative
    variable = disp_y
    block = 'cap stand'
    extra_vector_tags = 'ref'
  []
  [disp_x_diff]
    type = ADMatAnisoDiffusion
    variable = disp_x
    block = 'cap stand'
    diffusivity = d_x
    extra_vector_tags = 'ref'
  []
  [disp_y_diff]
    type = ADMatDiffusion
    variable = disp_y
    block = 'cap stand'
    diffusivity = 1e8
    extra_vector_tags = 'ref'
  []
[]

[UserObjects]
  [pin_geometry]
    type = FuelPinGeometry
    clad_bottom = cladding_outside_bottom
    clad_inner_wall = cladding_inside_right
    clad_outer_wall = cladding_outside_right
    clad_top = cladding_outside_top
    pellet_exteriors = fuel_outside_all
  []
  [clad_thm_exp]
    type = LayeredAverage
    variable = clad_thermal_eigenstrain_xx
    direction = y
    num_layers = 1000
    block = cladding
  []
[]

[Contact]
  [fuel_cladding_mechanical]
    primary = cladding_inside_right
    secondary = fuel_outer_radial_surface
    model = coulomb
    friction_coefficient = 0.1
    formulation = mortar
    c_normal = ${fparse 1e17 * magic_factor}
    c_tangential = ${fparse 1e19 * magic_factor}
    correct_edge_dropping = true
  []
[]

[MortarGapHeatTransfer]
  [inside2outside]
    temperature = temp
    boundary = 'cladding_inside_right'
    gap_conductivity_function = gap_thermal_conductivity
    gap_conductivity_function_variable = temp
    primary_boundary = cladding_inside_right
    secondary_boundary = fuel_contact_surfaces
    gap_flux_options = 'CONDUCTION'
    ghost_point_neighbors = true
  []
[]

[BCs]
  [no_x_all]
    type = ADDirichletBC
    variable = disp_x
    boundary = 'centerline cap_top'
    value = 0.0
    preset = false
  []
  [no_y_clad]
    type = ADDirichletBC
    variable = disp_y
    boundary = 'cladding_inside_bottom'
    value = 0.0
    preset = false
  []
  [Pressure]
    [coolantPressure]
      boundary = 'cladding_outside_right'
      factor = 0.151e6
      use_automatic_differentiation = true
    []
  []
  [PlenumPressure]
    [plenumPressure]
      boundary = 'inside_surfaces'
      initial_pressure = 84116 # in Pa, 12.2 psi
      startup_time = 0
      R = 8.3143
      temperature = temp_gas_avg
      volume = volume_plenum
      output = plenum_pressure
      material_input = fg_released
      use_automatic_differentiation = true
    []
  []

  [surf] # Setting temperature BC base on FIPD data
    type = FunctionDirichletBC
    variable = temp
    boundary = 'cladding_outside_bottom cladding_outside_right cladding_outside_top'
    function = clad_od_temp
  []
[]


[AuxVariables]
  [cumulative_damage_index]
    order = CONSTANT
    family = MONOMIAL
  []
  [clad_thm_exp]
    order = CONSTANT
    family = MONOMIAL
    block = cladding
  []
  [clad_thermal_eigenstrain_xx]
    order = CONSTANT
    family = MONOMIAL
    block = cladding
  []
[]

[AuxKernels]
  [cdf_amount]
    block = cladding
    type = MaterialRealAux
    property = cdf_failure
    variable = cumulative_damage_index
  []
  [clad_thm_exp]
    type = SpatialUserObjectAux
    variable = clad_thm_exp
    execute_on = 'initial timestep_end'
    user_object = clad_thm_exp
    block = cladding
  []
  [clad_thermal_eigenstrain_xx]
    type = ADRankTwoAux
    rank_two_tensor = cladding_thermal_eigenstrain
    variable = clad_thermal_eigenstrain_xx
    index_j = 0
    index_i = 0
    execute_on = 'initial timestep_end'
    block = cladding
  []
[]

[Materials]
  [longHT9_failure]
    type = HT9FailureClad
    block = cladding
    method = cdf_long
    temperature = temp
    outputs = all
    hoop_stress = stress_zz # Since 2D-RZ
  []
  [d_x]
    type = ADConstantAnisotropicMobility
    tensor = '1e3 0 0
              0   1e6 0
              0   0 0'
    M_name = d_x
  []
  [cap_thcond]
    type = ADGenericConstantMaterial
    prop_names = 'thermal_conductivity specific_heat density'
    prop_values = '65 1200 830'
    block = 'cap stand'
    outputs = all
  []
  [interconnected_porosity]
    type = ADParsedMaterial
    block = 'fuel'
    property_name = interconnected_porosity
    material_property_names = 'porosity interconnectivity'
    expression = 'porosity * interconnectivity'
    outputs = all
  []
  [fission_rate]
    type = ADUPuZrFissionRate
    rod_linear_power = power_history
    axial_power_profile = axial_peaking_factors
    pellet_radius = ${fuel_radius}
    initial_X_Zr=${initial_X_Zr}
    X_Zr = ${initial_X_Zr}
    X_Pu_function = 0
    block = 'fuel'
    outputs = all
  []
  [fission_rate_elongate]
    type = ADUPuZrFissionRate
    rod_linear_power = power_history
    axial_power_profile = axial_peaking_factors_extended
    pellet_radius = ${fuel_radius}
    # initial_X_Zr=${initial_X_Zr}
    X_Zr = ${initial_X_Zr}
    X_Pu_function = 0
    block = 'cladding'
    outputs = all
    fission_rate_name = fission_rate
  []
  [burnup]
    type = ADUPuZrBurnup
    initial_X_Zr = ${initial_X_Zr}
    initial_X_Pu = 0
    density = ${fuel_density}
    block = 'fuel'
    outputs = all
  []
  [burnup_elongate]
    type = ADUPuZrBurnup
    initial_X_Pu = 0
    initial_X_Zr = ${initial_X_Zr}
    outputs = all
    block = cladding
    density = ${fuel_density}
    burnup_name = burnup
  []
  [fuel_elastic_stress]
    type = ADComputeMultipleInelasticStress
    inelastic_models = 'hotpress fuel_upuzrcreep gas_swelling'
    block = 'fuel'
    outputs = all
  []
  [hotpress]
    type = ADUPuZrHotPressingStressUpdate
    block = 'fuel'
    outputs = all
    surface_energy = 1.6
    plenum_pressure = plenum_pressure
    porosity_name = porosity
    max_inelastic_increment = 1e-1
    interconnectivity = interconnectivity
    bubble_concentration = ${bubble_concentration}
    temperature = temp
    creep_model = MFH
    fission_rate = fission_rate
    atomic_volume = 2.15e-29
    porosity_start = 0.01
    porosity_end = 0
    grain_boundary_D0 = 4e-29
    grain_boundary_Q = 0
    absolute_tolerance = 1e-9
  []
  [porosity]
    type = ADPorosityFromStrain
    block = 'fuel'
    initial_porosity = 1e-10
    inelastic_strain = 'combined_inelastic_strain'
    outputs = all
  []
  [fuel_elasticity_tensor]
    type = ADUPuZrElasticityTensor
    X_Zr = ${initial_X_Zr}
    X_Pu = 0
    youngs_model = LANL
    block = 'fuel'
    temperature = temp
    use_old_porosity = true
    outputs = all
    output_properties = 'youngs_modulus poissons_ratio'
  []
  [fuel_upuzrcreep]
    type = ADUPuZrCreepUpdate
    block = 'fuel'
    temperature = temp
    porosity = porosity
    use_old_porosity = true
    max_inelastic_increment = 1e-1
    outputs = all
    automatic_differentiation_return_mapping = false
  []
  [fuel_thermal_expansion]
    type = ADUPuZrThermalExpansionEigenstrain
    block = 'fuel'
    temperature = temp
    stress_free_temperature = 298.0
    eigenstrain_name = fuel_thermal_strain
    outputs = all
    thermal_expansion_model = LANL
    X_Zr = ${initial_X_Zr}
    X_Pu = 0
  []
  [gas_swelling]
    type = ADSimpleFissionGasViscoplasticityStressUpdate
    temperature = temp
    outputs = all
    block = 'fuel'
    bubble_concentration = ${bubble_concentration}
    initial_bubble_concentration = ${bubble_concentration}
    compute_interconnectivity = true
    fission_gas_yield = 0.3017 #0.25
    fission_rate = fission_rate
    initial_atoms_per_bubble = 1e-05
    initial_bubble_radius = 1e-15
    initial_fgm_dissolved = 0
    interconnection_cutoff = 0.99
    interconnection_initiating_porosity = 0.23
    interconnection_terminating_porosity = 0.25
    max_inelastic_increment = 1e-2
    retained_gas_fraction = 0.25
    interconnection_dependent_retained_gas_fraction = 0.5
    surface_energy = 1.6
    anisotropic_factor = 0.26
    initial_porosity = 1e-10
  []
  [solid_swelling]
    type = ADBurnupDependentEigenstrain
    eigenstrain_name = solid_swelling_eigenstrain
    block = 'fuel'
    swelling_name = 'solid_swelling'
    outputs = all
  []
  [metal_fuel_thermal]
    type = ADUPuZrThermal
    block = 'fuel'
    X_Zr = ${initial_X_Zr}
    X_Pu = 0
    spheat_model = savage
    porosity = porosity
    temperature = temp
    outputs = all
    porosity_model = logged
    sodium_logged_porosity = sodium_logged_porosity
  []
  [sodium_logging]
    type = ADUPuZrSodiumLogging
    block = 'fuel'
    porosity = porosity
    interconnectivity = interconnectivity
    sodium_infiltration_fraction = 0.28
    outputs = all
  []
  [fuel_density]
    type = ADDensity
    block = 'fuel'
    density = ${fuel_density}
    outputs = all
  []
  [fast_neutron_flux]
    type = ADFastNeutronFlux
    calculate_fluence = true
    axial_power_profile = fflux_axial_peaking_factors
    rod_ave_lin_pow = flux_history
    block = fuel
    factor = 1.0
    outputs = all
  []
  [fast_neutron_flux_elongate]
    type = ADFastNeutronFlux
    calculate_fluence = true
    axial_power_profile = fflux_axial_peaking_factors_elongate
    rod_ave_lin_pow = flux_history
    block = cladding
    factor = 1.0
    outputs = all
  []
  [cladding_elasticity_tensor]
    type = ADHT9ElasticityTensor
    temperature = temp
    block = 'cladding'
    outputs = all
    id_wastage_degradation_function = id_vpp_func
    od_wastage_degradation_function = od_vpp_func
    output_properties = 'youngs_modulus poissons_ratio'
  []
  [cladding_stress]
    type = ADComputeMultipleInelasticStress
    inelastic_models = 'cladding_creep'
    block = 'cladding'
    outputs = all
  []
  [cladding_creep]
    type = ADHT9CreepUpdate
    block = 'cladding'
    temperature = temp
    outputs = all
    primary_creep_model = MFH
    secondary_creep_model = MFH
    tertiary_creep_model = MFH
    irradiation_creep_model = MFH
    use_effective_time_for_tertiary = true
    use_effective_time_for_primary = true
    fast_neutron_flux=fast_neutron_flux
  []
  [thermal_expansion]
    type = ADHT9ThermalExpansionEigenstrain
    block = 'cladding'
    temperature = temp
    stress_free_temperature = 298.0
    eigenstrain_name = cladding_thermal_eigenstrain
    outputs = all
  []
  [cladding_thermal]
    type = ADHT9Thermal
    block = 'cladding'
    temperature = temp
    outputs = all
  []
  [cladding_density]
    type = ADDensity
    block = 'cladding'
    density = ${cladding_density}
    outputs = all
  []
  [wastage_thickness]
    type = ADMetallicFuelWastage
    method = burnup_ht9_opt
    burnup = burnup
    temperature = temp
    scale_factor = 1
    block = 'cladding'
    outputs = all
  []
  [cc_wastage_thickness]
    type = ADMetallicFuelCoolantWastage
    clad_material = HT9
    use_effective_method = true
    temperature = temp
    scale_factor = 1
    block = 'cladding'
    outputs = all
  []
[]

[Dampers]
  [disp_x]
    type = MaxIncrement
    variable = disp_x
    max_increment = 1e-4
  []
  [disp_y]
    type = MaxIncrement
    variable = disp_y
    max_increment = 1e-3
  []
  [temp]
    type = MaxIncrement
    variable = temp
    max_increment = 50
  []
[]

[Preconditioning]
  [vcp]
    type = VCP
    full = true
    primary_variable = 'disp_x disp_y temp'
    preconditioner = 'LU'
    adaptive_condensation = true
    lm_variable = 'fuel_cladding_mechanical_normal_lm fuel_cladding_mechanical_tangential_lm inside2outside_thermal_lm'
    is_lm_coupling_diagonal = true
  []
[]

[Executioner]
  type = Transient
  solve_type = 'NEWTON'
  petsc_options = '-snes_ksp_ew -snes_converged_reason -ksp_converged_reason'
  petsc_options_iname = '-pc_type -pc_factor_mat_solver_type -mat_mffd_err -pc_factor_shift_type -pc_factor_shift_amount -snes_force_iteration'
  petsc_options_value = 'lu    superlu_dist   1e-5          NONZERO               1e-15 1'
  line_search = 'none'
  snesmf_reuse_base = false
  verbose = true

  l_max_its = 60
  nl_max_its = 15 #20
  nl_rel_tol = 5e-6
  nl_abs_tol = 5e-9

  end_time = ${run_time}
  dtmin = 1
  dtmax = ${max_time_step}

  automatic_scaling = true
  compute_scaling_once = false
  off_diagonals_in_auto_scaling = true
  ignore_variables_for_autoscaling = 'fuel_cladding_mechanical_normal_lm fuel_cladding_mechanical_tangential_lm inside2outside_thermal_lm'

  [TimeStepper]
    type = IterationAdaptiveDT
    timestep_limiting_postprocessor = time_step_limit
    force_step_every_function_point = true
    max_function_change = 300
    timestep_limiting_function = power_history
    dt = 1e2
    iteration_window = 4
    optimal_iterations = 10
  []
[]

[Postprocessors]
  # elemental temperatures
  [temp_fuel_avg]
    type = ElementAverageValue
    variable = temp
    block = 'fuel'
    execute_on = 'initial timestep_end'
  []
  [temp_fuel_max]
    type = ElementExtremeValue
    variable = temp
    block = 'fuel'
  []
  [temp_fuel_min]
    type = ElementExtremeValue
    variable = temp
    block = 'fuel'
    value_type = min
  []
  [temp_cladding_avg]
    type = ElementAverageValue
    variable = temp
    block = 'cladding'
  []
  [temp_cladding_max]
    type = ElementExtremeValue
    variable = temp
    block = 'cladding'
  []
  [temp_cladding_min]
    type = ElementExtremeValue
    variable = temp
    block = 'cladding'
    value_type = min
  []

  # boundary temperatures
  [temp_gas_avg]
    type = ElementAverageValue
    block = 'cap'
    variable = temp
    execute_on = 'initial timestep_end'
  []
  # Beyond gap closure, sodium temperarture is almost the same as the cap.
  [temp_sodium_avg]
    type = ElementAverageValue
    block = 'cap'
    variable = temp
    execute_on = 'initial timestep_end'
  []
  [temp_inside_surfaces_avg]
    type = SideAverageValue
    boundary = 'inside_surfaces'
    variable = temp
    execute_on = 'initial timestep_end'
  []
  [temp_fuel_centerline_avg]
    type = AxisymmetricCenterlineAverageValue
    boundary = 'centerline'
    variable = temp
  []
  [temp_fuel_centerline_max]
    type = NodalExtremeValue
    boundary = 'centerline'
    variable = temp
  []
  [temp_fuel_centerline_min]
    type = NodalExtremeValue
    boundary = 'centerline'
    variable = temp
    value_type = min
  []
  [temp_fuel_surface_avg]
    type = SideAverageValue
    boundary = 'fuel_outer_radial_surface'
    variable = temp
  []
  [temp_fuel_surface_max]
    type = NodalExtremeValue
    boundary = 'fuel_outer_radial_surface'
    variable = temp
  []
  [temp_fuel_surface_min]
    type = NodalExtremeValue
    boundary = 'fuel_outer_radial_surface'
    variable = temp
    value_type = min
  []
  [temp_cladding_inside_right_avg]
    type = SideAverageValue
    boundary = 'cladding_inside_right'
    variable = temp
  []
  [temp_cladding_inside_right_max]
    type = NodalExtremeValue
    boundary = 'cladding_inside_right'
    variable = temp
  []
  [temp_cladding_outside_right_avg]
    type = SideAverageValue
    boundary = 'cladding_outside_right'
    variable = temp
  []

  # stresses
  [stress_vonmises_fuel_avg]
    type = ElementAverageValue
    variable = vonmises_stress
    block = 'fuel'
  []
  [stress_vonmises_fuel_max]
    type = ElementExtremeValue
    variable = vonmises_stress
    block = 'fuel'
  []
  [stress_vonmises_fuel_min]
    type = ElementExtremeValue
    variable = vonmises_stress
    value_type = min
    block = 'fuel'
  []
  [stress_hydro_fuel_avg]
    type = ElementAverageValue
    variable = hydrostatic_stress
    block = 'fuel'
  []
  [stress_hydro_fuel_max]
    type = ElementExtremeValue
    variable = hydrostatic_stress
    block = 'fuel'
  []
  [stress_hydro_fuel_min]
    type = ElementExtremeValue
    variable = hydrostatic_stress
    value_type = min
    block = 'fuel'
  []
  [stress_vonmises_cladding_avg]
    type = ElementAverageValue
    variable = vonmises_stress
    block = 'cladding'
  []
  [stress_vonmises_cladding_max]
    type = ElementExtremeValue
    variable = vonmises_stress
    block = 'cladding'
  []
  [stress_vonmises_cladding_min]
    type = ElementExtremeValue
    variable = vonmises_stress
    value_type = min
    block = 'cladding'
  []
  [stress_hydro_cladding_avg]
    type = ElementAverageValue
    variable = hydrostatic_stress
    block = 'cladding'
  []
  [stress_hydro_cladding_max]
    type = ElementExtremeValue
    variable = hydrostatic_stress
    block = 'cladding'
  []
  [stress_hydro_cladding_min]
    type = ElementExtremeValue
    variable = hydrostatic_stress
    value_type = min
    block = 'cladding'
  []
  [contact_pressure_max]
    type = NodalExtremeValue
    variable = fuel_cladding_mechanical_normal_lm
    boundary = 'fuel_outer_radial_surface'
  []

  # strain information
  [strain_solid_swelling_fuel_avg]
    type = ElementAverageValue
    variable = solid_swelling
    block = 'fuel'
  []
  [strain_gas_swelling_fuel_avg]
    type = ElementAverageValue
    variable = effective_fission_gas_strain
    block = 'fuel'
  []
  [strain_hot_pressing_fuel_avg]
    type = ElementAverageValue
    variable = effective_hot_pressing_strain
    block = 'fuel'
  []
  [strain_volumetric_fuel_avg]
    type = ElementAverageValue
    variable = firstinv_strain
    block = 'fuel'
  []
  [strain_axial_fuel_avg]
    type = ParsedPostprocessor
    pp_names = 'disp_y_fuel_top_surface_avg disp_y_fuel_bottom_surface_avg'
    expression = '(disp_y_fuel_top_surface_avg - disp_y_fuel_bottom_surface_avg) / ${fuel_height}'
  []
  [disp_y_fuel_top_surface_avg]
    type = SideAverageValue
    variable = disp_y
    boundary = 'fuel_top'
  []
  [disp_y_fuel_top_surface_max]
    type = NodalExtremeValue
    variable = disp_y
    boundary = 'fuel_top'
  []
  [disp_y_fuel_bottom_surface_avg]
    type = SideAverageValue
    variable = disp_y
    boundary = 'fuel_bottom'
  []
  [disp_y_fuel_bottom_surface_max]
    type = NodalExtremeValue
    variable = disp_y
    boundary = 'fuel_bottom'
  []
  [disp_x_fuel_radial_surface_max]
    type = NodalExtremeValue
    variable = disp_x
    boundary = 'fuel_outer_radial_surface'
  []
  [disp_x_fuel_radial_surface_avg]
    type = SideAverageValue
    variable = disp_x
    boundary = 'fuel_outer_radial_surface'
  []
  [disp_x_cladding_interior_max]
    type = NodalExtremeValue
    variable = disp_x
    boundary = 'cladding_inside_right'
  []
  [disp_x_cladding_interior_min]
    type = NodalExtremeValue
    variable = disp_x
    boundary = 'cladding_inside_right'
    value_type = min
  []
  [disp_x_cladding_interior_avg]
    type = SideAverageValue
    variable = disp_x
    boundary = 'cladding_inside_right'
  []
  [disp_x_cladding_exterior_max]
    type = NodalExtremeValue
    variable = disp_x
    boundary = 'cladding_outside_right'
  []
  [disp_x_cladding_exterior_avg]
    type = SideAverageValue
    variable = disp_x
    boundary = 'cladding_outside_right'
  []
  [anisotropic_swelling_factor]
    type = FunctionValuePostprocessor
    function = anisotropic_swelling_factor
  []
  [max_fuel_elongation]
    type = NodalExtremeValue
    variable = disp_y
    boundary = fuel_outside_all
  []

  # geometric information
  [volume_cladding_interior]
    type = InternalVolume
    boundary = 'cladding_inside_all'
  []
  [volume_fuel]
    type = InternalVolume
    boundary = 'fuel_outside_all'
    execute_on = 'initial timestep_end'
  []
  [volume_plenum]
    type = InternalVolume
    boundary = 'inside_surfaces'
    execute_on = 'initial timestep_end'
    addition = sodium_volume
  []
  [plenum_ratio]
    type = ParsedPostprocessor
    pp_names = 'volume_plenum volume_fuel'
    expression = 'volume_plenum / volume_fuel'
    execute_on = 'initial timestep_end'
  []
  [volume_sodium]
    type = FunctionValuePostprocessor
    function = sodium_volume
    execute_on = 'initial timestep_end'
  []

  # energy information
  [flux_clad]
    type = ADSideDiffusiveFluxIntegral
    variable = temp
    boundary = 'cladding_inside_right'
    diffusivity = thermal_conductivity
  []
  [flux_fuel]
    type = ADSideDiffusiveFluxIntegral
    variable = temp
    boundary = 'fuel_contact_surfaces'
    diffusivity = thermal_conductivity
  []
  [power_integral]
    type = ADElementIntegralPower
    variable = temp
    use_material_fission_rate = true
    fission_rate_material = fission_rate
    block = fuel
  []
  [linear_heat_generation_rate]
    type = FunctionValuePostprocessor
    function = power_history
    scale_factor = 0.01
  []
  [burnup_avg]
    type = ElementAverageValue
    block = fuel
    variable = burnup
  []
  [burnup_max]
    type = ElementExtremeValue
    block = fuel
    variable = burnup
  []
  [fission_rate_avg]
    type = ElementAverageValue
    variable = fission_rate
    block = fuel
  []

  # fission gas information
  [fg_produced]
    type = ADElementIntegralMaterialProperty
    mat_prop = fgm_produced
    block = fuel
  []
  [fg_released]
    type = ADElementIntegralMaterialProperty
    mat_prop = fgm_released
    block = fuel
    execute_on = 'initial timestep_end'
  []
  [fg_percent]
    type = FGRPercent
    fission_gas_released = fg_released
    fission_gas_generated = fg_produced
  []
  [interconnected_porosity_fuel_avg]
    type = ElementAverageValue
    variable = interconnected_porosity
    block = fuel
    execute_on = 'initial timestep_end'
  []
  [porosity_fuel_avg]
    type = ElementAverageValue
    variable = porosity
    block = fuel
  []
  [porosity_fuel_max]
    type = ElementExtremeValue
    variable = porosity
    block = fuel
  []
  [porosity_fuel_min]
    type = ElementExtremeValue
    variable = porosity
    value_type = min
    block = fuel
  []
  [porosity_sodium_logging_avg]
    type = ElementAverageValue
    variable = sodium_logged_porosity
    block = fuel
  []

  # extras
  [actual_time_step_limit]
    type = MaterialTimeStepPostprocessor
    block = 'fuel cladding'
    outputs = none
  []
  [time_step_limit]
    type = ParsedPostprocessor
    expression = 'if(actual_time_step_limit > max_dt, max_dt, actual_time_step_limit)'
    pp_names = 'actual_time_step_limit'
    constant_names = 'max_dt'
    constant_expressions = '${max_time_step}'
  []
  [max_wastagethickness]
    type = ElementExtremeValue
    value_type = max
    variable = wastage_thickness
  []
  [max_wst_temp]
    type=ElementExtremeValue
    value_type=max
    variable=temp
    proxy_variable=wastage_thickness
    block='cladding'
  []
  [max_wst_burnup]
    type=ElementExtremeValue
    value_type=max
    variable=burnup
    proxy_variable=wastage_thickness
    block='cladding'
  []
  [max_cdf]
    type = ElementExtremeValue
    value_type = max
    variable = cumulative_damage_index
  []
[]

[VectorPostprocessors]
  [id_wastage]
    type = FuelRodLineValueSampler
    variable = wastage_thickness
    material = 'clad'
    fraction = 0.0
    num_points = 600
    orientation = 'vertical'
    fuel_pin_geometry = 'pin_geometry'
    execute_on = 'initial timestep_end'
    allow_duplicate_execution_on_initial = true
    outputs = csv_wst_a
  []
  [od_wastage]
    type = FuelRodLineValueSampler
    variable = cc_wastage_thickness
    material = 'clad'
    fraction = 1.0
    num_points = 600
    orientation = 'vertical'
    fuel_pin_geometry = 'pin_geometry'
    execute_on = 'initial timestep_end'
    allow_duplicate_execution_on_initial = true
    outputs = none
  []
  [nrad_comparison_a]
    type = FIPDAxialPIEComparison
    boundary = cladding_outside_right
    sort_by = y
    csv_file = ${raw 'fipd/X447A_ ${pin_id} _PR.csv'}
    variable = disp_x
    thermal_strain_variable = clad_thm_exp
    involved_component = cladding
    mesh_generator = gen
    series_type_to_read = 'Cladding O.D. (mils)'
    outputs = csv_vpp_a
    enable = ${enable_a}
  []
[]

[PerformanceMetricOutputs]
  outputs = 'console'
[]

[Outputs]
  print_linear_residuals = true
  color = true
  perf_graph = true
  sync_times=${time_spots}
  [checkpoint]
    type = Checkpoint
    sync_times = '19339200'
    file_base = 'midpoint_cp'
    enable = false
  []
  [exodus]
    type = Exodus
    time_step_interval =  500
    sync_times = ${time_spots}
    enable = false
    file_base = 'x447_${pin_id}_exodus'
  []
  [console]
    type = Console
    show = 'time_step_size max_fuel_elongation burnup_avg  max_wastagethickness'
  []
  [csv_vpp_a]
    type = CSV
    sync_only = true
    sync_times = ${time_spots_a}
    enable = ${enable_a}
    execute_postprocessors_on = none
    create_latest_symlink = true
    file_base = 'x447_${pin_id}_csv_vpp_a'
  []
  [csv_wst_a]
    type = CSV
    sync_only = true
    sync_times = ${time_spots_a}
    enable = ${enable_a}
    execute_postprocessors_on = none
    create_latest_symlink = true
    file_base = 'x447_${pin_id}_csv_wst_a'
  []
  [csv_general]
    type = CSV
    sync_only = true
    sync_times = ${time_spots}
    enable = true
    file_base = 'x447_${pin_id}_csv_general'
  []
[]

[Debug]
  show_var_residual = 'disp_x disp_y temp'
  show_var_residual_norms = true
[]
