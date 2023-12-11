################################################################################
## NEAMS Micro-Reactor Application Driver                                     ##
## Heat Pipe Microreactor TRISO Failure Model                                 ##
## Statistical Model for Evaluating TRISO Failure in the Assembly             ##
## BISON Model for single particle simulation                                 ##
################################################################################

folder_name = fuelsample
end_time = 315576000

[GlobalParams]
  flux_conversion_factor = 1.0
  order = FIRST
  family = LAGRANGE
  displacements = 'disp_x'
  volumetric_locking_correction = false
  O_U = 1.5 # Initial Oxygen to Uranium atom ratio
  C_U = 0.4 # Initial Carbon to Uranium atom ratio
  initial_enrichment = 0.1955 # [wt-]
  stress_free_temperature = 298
[]

[Mesh]
  coord_type = RSPHERICAL
  [gen]
    type = TRISO1DFiveLayerMeshGenerator
    elem_type = EDGE3
    kernel_radius = 2.125e-4
    buffer_thickness = 1e-4
    IPyC_thickness = 0.4e-4
    SiC_thickness = 0.35e-4
    OPyC_thickness = 0.4e-4
    kernel_mesh_density = 5
    buffer_mesh_density = 3
    IPyC_mesh_density = 5
    SiC_mesh_density = 3
    OPyC_mesh_density = 4
  []
[]

[Problem]
  type = ReferenceResidualProblem
  reference_vector = 'ref'
  extra_tag_vectors = 'ref'
[]

[UserObjects]
  [particle_geometry]
    type = TRISOGeometry
    outer_OPyC = OPyC_outer_boundary
    outer_SiC = SiC_outer_boundary
    outer_IPyC = IPyC_outer_boundary
    inner_IPyC = IPyC_inner_boundary
    outer_buffer = buffer_outer_boundary
    outer_kernel = fuel_outer_boundary
    include_particle = true
    include_pebble = false
    IPyC_thickness_mean = 0.4e-4
    SiC_thickness_mean = 0.35e-4
    OPyC_thickness_mean = 0.4e-4
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [sic_failure_terminator]
    type = Terminator
    expression = 'sic_failure_overall > 0'
  []
[]

[Variables]
  [temperature]
    initial_condition = 298
  []
[]

[AuxVariables]
  [fission_rate]
    order = CONSTANT
    family = MONOMIAL
  []
  [burnup]
    order = CONSTANT
    family = MONOMIAL
  []
  [fast_neutron_flux]
    order = CONSTANT
    family = MONOMIAL
  []
  [fast_neutron_fluence]
    order = CONSTANT
    family = MONOMIAL
  []
[]

[Functions]
  [pressure_function]
    type = PiecewiseLinear
    format = columns
    data_file = ${raw '../UnitCell_with_TM/ ${folder_name} /pressuredata ${particle_number} .csv'}
  []
  [pdens_function]
    type = PiecewiseLinear
    format = columns
    data_file = ${raw '../UnitCell_with_TM/ ${folder_name} /powdata ${particle_number} .csv'}
  []
  [temperature_function]
    type = PiecewiseLinear
    format = columns
    data_file = ${raw '../UnitCell_with_TM/ ${folder_name} /tempdata ${particle_number} .csv'}
  []
  [fission_rate]
    type = ParsedFunction
    expression = 'Pdens * PackingFraction * Vol / Jfiss'
    symbol_names = 'Pdens PackingFraction Vol Jfiss'
    symbol_values = 'pdens_function 0.4 kernel_volume 3.2e-11'
  []
  [high_fidelity_strength_crackedIPyC]
    type = ConstantFunction
    value = 1401355124.9454
  []
  [stress_correlation_crackedIPyC]
    type = TRISOStressCorrelationFunction
    triso_geometry = particle_geometry
    polynomial_coefficients_IPyC = '1.03175391e+00 7.99148430e+03 1.80963575e+08'
    polynomial_coefficients_SiC = '9.99192631e-01 9.93773505e+03 3.92874322e+08'
    polynomial_coefficients_OPyC = '9.98066533e-01 -1.15052810e+04  5.69788318e+08'
    correlation_factor = -1.3019855058864431
  []
  [high_fidelity_strength_asphericity]
    type = ConstantFunction
    value = '999450568.8571'
  []
  [stress_correlation_asphericity]
    type = TRISOStressCorrelationFunction
    triso_geometry = particle_geometry
    polynomial_coefficients_IPyC = '9.99988455e-01  1.26137766e+04 -1.78620084e+08'
    polynomial_coefficients_SiC = '9.99985858e-01 -1.72538218e+02  1.08972415e+08'
    polynomial_coefficients_OPyC = '9.99991038e-01  2.04084033e+04 -3.16201526e+08'
    correlation_factor = 0.7597631290037449
  []
  [stress_change_correlation_asphericity]
    type = TRISOStressCorrelationFunction
    triso_geometry = particle_geometry
    polynomial_coefficients_IPyC = '1.00001211e+00 -2.94486846e+02  1.69122180e+07'
    polynomial_coefficients_SiC = '1.00001206e+00  5.03963650e+03 -7.26176937e+07'
    polynomial_coefficients_OPyC = '1.00000685e+00 3.28720653e+02 2.64270044e+07'
    correlation_factor = 1.2157139173624862
  []
[]

[Modules/TensorMechanics/Master]
  generate_output = 'stress_xx stress_yy stress_zz strain_xx strain_yy strain_zz max_principal_stress hydrostatic_stress'
  add_variables = true
  strain = FINITE
  incremental = true
  [fuel]
    block = fuel
    eigenstrain_names = 'UCO_swelling_eigenstrain UCO_TE_strain'
    extra_vector_tags = 'ref'
  []
  [buffer]
    block = buffer
    eigenstrain_names = 'Buffer_IIDC_strain Buffer_TE_strain'
    extra_vector_tags = 'ref'
  []
  [IPyC]
    block = IPyC
    eigenstrain_names = 'IPyC_IIDC_strain IPyC_TE_strain'
    extra_vector_tags = 'ref'
  []
  [SiC]
    block = SiC
    eigenstrain_names = 'SiC_thermal_eigenstrain'
    extra_vector_tags = 'ref'
  []
  [OPyC]
    block = OPyC
    eigenstrain_names = 'OPyC_IIDC_strain OPyC_TE_strain'
    extra_vector_tags = 'ref'
  []
[]

[Kernels]
  [heat_ie]
    type = HeatConductionTimeDerivative
    variable = temperature
    extra_vector_tags = 'ref'
  []
  [heat]
    type = HeatConduction
    variable = temperature
    extra_vector_tags = 'ref'
  []
  [heat_source]
    type = NeutronHeatSource
    variable = temperature
    block = fuel
    fission_rate = fission_rate
    extra_vector_tags = 'ref'
  []
[]

[AuxKernels]
  [fissionrate]
    type = MaterialRealAux
    variable = fission_rate
    property = fission_rate
    block = fuel
    execute_on = timestep_begin
  []
  [burnup]
    type = MaterialRealAux
    variable = burnup
    property = burnup
    block = fuel
    execute_on = timestep_begin
  []
  [fast_neutron_flux]
    type = MaterialRealAux
    variable = fast_neutron_flux
    property = fast_neutron_flux
    execute_on = timestep_begin
  []
  [fast_neutron_fluence]
    type = MaterialRealAux
    variable = fast_neutron_fluence
    property = fast_neutron_fluence
    execute_on = timestep_begin
  []
[]

[ThermalContact]
  [thermal_contact]
    type = GasGapHeatTransfer
    variable = temperature
    primary = IPyC_inner_boundary
    secondary = buffer_outer_boundary
    initial_moles = initial_moles
    gas_released = 'fis_gas_released'
    released_gas_types = 'Kr Xe'
    released_fractions = '0.185 0.815'
    tangential_tolerance = 1e-6
    quadrature = false
    min_gap = 1e-7
    max_gap = 50e-6
    gap_geometry_type = sphere
  []
[]

[BCs]
  [no_disp_x]
    type = DirichletBC
    variable = disp_x
    boundary = xzero
    value = 0.0
  []
  [freesurf_temp]
    type = FunctionDirichletBC
    variable = temperature
    function = temperature_function
    boundary = exterior
  []
  [exterior_pressure_x]
    type = Pressure
    variable = disp_x
    boundary = exterior
    function = pressure_function
  []
  [PlenumPressure]
    [plenumPressure]
      boundary = buffer_IPyC_boundary
      startup_time = 1e4
      initial_pressure = 0
      R = 8.3145
      output_initial_moles = initial_moles
      temperature = ave_gas_temp
      volume = 'gap_volume buffer_void_volume kernel_void_volume'
      material_input = 'fis_gas_released'
      output = gas_pressure
    []
  []
[]

[Materials]
  [kernel_radius]
    type = GenericConstantMaterial
    prop_names = 'radius'
    prop_values = '1.0'
    block = fuel
  []
  [radial_stress]
    type = RankTwoCylindricalComponent
    rank_two_tensor = stress
    cylindrical_axis_point1 = '0 0 0'
    cylindrical_axis_point2 = '0 0 1'
    cylindrical_component = RadialStress
    property_name = radial_stress
    outputs = all
  []
  [fission_rate]
    type = GenericFunctionMaterial
    prop_names = fission_rate
    prop_values = fission_rate
    block = fuel
  []
  [fast_neutron_flux]
    type = FastNeutronFlux
    calculate_fluence = true
    factor = 7.664e15
  []
  [UCO_burnup]
    type = TRISOBurnup
    initial_density = 10744.0
    block = fuel
  []
  [UCO_thermal]
    type = UCOThermal
    block = fuel
    temperature = temperature
  []
  [UCO_elasticity_tensor]
    type = UCOElasticityTensor
    block = fuel
    temperature = temperature
  []
  [UCO_stress]
    type = ComputeFiniteStrainElasticStress
    block = fuel
  []
  [UCO_VolumetricSwellingEigenstrain]
    type = UCOVolumetricSwellingEigenstrain
    block = fuel
    eigenstrain_name = UCO_swelling_eigenstrain
  []
  [fuel_thermal_expansion]
    type = ComputeThermalExpansionEigenstrain
    block = fuel
    thermal_expansion_coeff = 10.0e-6
    temperature = temperature
    eigenstrain_name = UCO_TE_strain
  []
  [UCO_density]
    type = Density
    block = fuel
    density = 10966
  []
  [fission_gas_release]
    type = UCOFGR
    block = fuel
    average_grain_radius = 10e-6
    temperature = temperature
    triso_geometry = particle_geometry
    cutoff_neutron_flux = 0.0
  []
  [BAF_IPyC]
    type = BaconAnisotropyFactor
    initial_BAF = 1.0465
    block = IPyC
  []
  [BAF_OPyC]
    type = BaconAnisotropyFactor
    initial_BAF = 1.0429
    block = OPyC
  []
  [buffer_elasticity_tensor]
    type = BufferElasticityTensor
    block = buffer
    temperature = temperature
  []
  [buffer_stress]
    type = BufferCEGACreep
    block = buffer
    temperature = temperature
  []
  [buffer_thermal]
    type = BufferThermal
    block = buffer
    initial_density = 1050.0
  []
  [buffer_density]
    type = Density
    block = buffer
    density = 1050.0
  []
  [buffer_TE]
    type = BufferThermalExpansionEigenstrain
    block = buffer
    eigenstrain_name = Buffer_TE_strain
    temperature = temperature
  []
  [buffer_IIDC]
    type = BufferCEGAIrradiationEigenstrain
    block = buffer
    eigenstrain_name = Buffer_IIDC_strain
    temperature = temperature
  []
  [IPyC_elasticity_tensor]
    type = PyCElasticityTensor
    block = IPyC
    temperature = temperature
  []
  [IPyC_stress]
    type = PyCCEGACreep
    block = IPyC
    creep_rate_scale_factor = 1
    temperature = temperature
  []

  [IPyC_thermal]
    type = HeatConductionMaterial
    block = IPyC
    thermal_conductivity = 4.0
    specific_heat = 720.0
  []
  [IPyC_density]
    type = GenericConstantMaterial
    block = IPyC
    prop_names = 'density'
    prop_values = 1882
  []
  [normal_vectors_triso]
    type = NormalVectorsTRISO
    block = 'buffer IPyC OPyC'
  []
  [IPyC_IIDC]
    type = PyCCEGAIrradiationEigenstrain
    block = IPyC
    eigenstrain_name = IPyC_IIDC_strain
    temperature = temperature
    irradiation_eigenstrain_scale_factor = 1
  []
  [IPyC_TE]
    type = PyCThermalExpansionEigenstrain
    block = IPyC
    eigenstrain_name = IPyC_TE_strain
    temperature = temperature
  []
  [SiC_elasticity_tensor]
    type = MonolithicSiCElasticityTensor
    block = SiC
    temperature = temperature
    elastic_modulus_model = miller
  []
  [SiC_stress]
    type = ComputeFiniteStrainElasticStress
    block = SiC
  []
  [SiC_thermal]
    type = MonolithicSiCThermal
    block = SiC
    temperature = temperature
    thermal_conductivity_model = miller
  []
  [SiC_density]
    type = Density
    block = SiC
    density = 3171.0
  []
  [SiC_thermal_expansion]
    type = ComputeThermalExpansionEigenstrain
    block = SiC
    thermal_expansion_coeff = 4.9e-6
    temperature = temperature
    eigenstrain_name = SiC_thermal_eigenstrain
  []
  [OPyC_elasticity_tensor]
    type = PyCElasticityTensor
    block = OPyC
    temperature = temperature
    initial_BAF = 1.0
  []
  [OPyC_stress]
    type = PyCCEGACreep
    block = OPyC
    creep_rate_scale_factor = 1
    temperature = temperature
  []
  [OPyC_thermal_conductivity]
    type = HeatConductionMaterial
    block = OPyC
    thermal_conductivity = 4.0
    specific_heat = 720.0
  []
  [OPyC_density]
    type = GenericConstantMaterial
    block = OPyC
    prop_names = 'density'
    prop_values = 1882
  []
  [OPyC_IIDC]
    type = PyCCEGAIrradiationEigenstrain
    block = OPyC
    eigenstrain_name = OPyC_IIDC_strain
    temperature = temperature
    irradiation_eigenstrain_scale_factor = 1
  []
  [OPyC_TE]
    type = PyCThermalExpansionEigenstrain
    block = OPyC
    eigenstrain_name = OPyC_TE_strain
    temperature = temperature
  []
  [characteristic_strength_SiC]
    type = GenericConstantMaterial
    prop_values = '9640000'
    block = SiC
    prop_names = 'characteristic_strength'
  []
  [characteristic_strength_PyC]
    type = PyCCharacteristicStrength
    temperature = temperature
    X = 1.02
    block = 'IPyC OPyC'
  []
[]

[Dampers]
  [temp]
    type = MaxIncrement
    variable = temperature
    max_increment = 100
  []
[]

[Preconditioning]
  [smp]
    type = SMP
    full = true
  []
[]

[Executioner]
  type = Transient
  solve_type = 'PJFNK'

  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
  petsc_options_value = 'lu superlu_dist'

  line_search = 'none'

  nl_rel_tol = 5e-6
  nl_abs_tol = 1e-8
  nl_max_its = 20

  l_tol = 1e-4
  l_max_its = 50

  start_time = 0.0
  end_time = '${end_time}'
  dt = 1e7
[]

[Postprocessors]
  [kernel_volume]
    type = InternalVolume
    boundary = fuel_outer_boundary
    execute_on = 'initial timestep_begin'
  []
  [frate_value]
    type = FunctionValuePostprocessor
    function = fission_rate
    execute_on = 'initial'
    indirect_dependencies = 'pdens_value'
  []
  [strain_opyc]
    type = ElementAverageValue
    variable = 'strain_xx'
    block = 'OPyC'
  []
  [strain_ipyc]
    type = ElementAverageValue
    variable = 'strain_xx'
    block = 'IPyC'
  []
  [strain_sic]
    type = ElementAverageValue
    variable = 'strain_xx'
    block = 'SiC'
  []
  [pres_sic_avg]
    type = ElementAverageValue
    variable = hydrostatic_stress
    block = 'SiC'
  []
  [pres_sic_max]
    type = ElementExtremeValue
    variable = hydrostatic_stress
    block = 'SiC'
  []
  [pres_sic_min]
    type = ElementExtremeValue
    variable = hydrostatic_stress
    value_type = min
    block = 'SiC'
  []
  [pres_ipyc_avg]
    type = ElementAverageValue
    variable = hydrostatic_stress
    block = 'IPyC'
  []
  [pres_ipyc_max]
    type = ElementExtremeValue
    variable = hydrostatic_stress
    block = 'IPyC'
  []
  [pres_ipyc_min]
    type = ElementExtremeValue
    variable = hydrostatic_stress
    value_type = min
    block = 'IPyC'
  []
  [pres_opyc_avg]
    type = ElementAverageValue
    variable = hydrostatic_stress
    block = 'OPyC'
  []
  [pres_opyc_max]
    type = ElementExtremeValue
    variable = hydrostatic_stress
    block = 'OPyC'
  []
  [pres_opyc_min]
    type = ElementExtremeValue
    variable = hydrostatic_stress
    value_type = min
    block = 'OPyC'
  []
  [stress_SiC_crackedIPyC]
    type = WeibullFailureOutputUsingCorrelation
    block = SiC
    weibull_modulus = 6
    stress_name = stress_yy
    high_fidelity_analysis_strength = 'high_fidelity_strength_crackedIPyC'
    stress_correlation_function = 'stress_correlation_crackedIPyC'
    output_type = 'stress'
  []
  [actual_strength_SiC_crackedIPyC]
    type = WeibullFailureOutputUsingCorrelation
    block = SiC
    weibull_modulus = 6
    stress_name = stress_yy
    high_fidelity_analysis_strength = 'high_fidelity_strength_crackedIPyC'
    stress_correlation_function = 'stress_correlation_crackedIPyC'
    output_type = 'strength'
  []
  [ave_gas_temp]
    type = ElementAverageValue
    block = buffer
    variable = temperature
    execute_on = 'initial timestep_end'
  []
  [fis_gas_released]
    type = ElementIntegralMaterialProperty
    mat_prop = fis_gas_released
    block = fuel
    use_displaced_mesh = false
    execute_on = 'initial timestep_end'
  []
  [gap_volume]
    type = InternalVolume
    boundary = buffer_IPyC_boundary
    execute_on = 'initial linear'
    use_displaced_mesh = true
  []
  [buffer_void_volume]
    type = VoidVolume
    block = buffer
    theoretical_density = 2250
    execute_on = 'initial timestep_end'
    use_displaced_mesh = true
  []
  [kernel_th_density]
    type = UCOTheoreticalDensity
    execute_on = initial
  []
  [kernel_void_volume]
    type = VoidVolume
    block = fuel
    theoretical_density = kernel_th_density
    execute_on = 'initial timestep_end'
    use_displaced_mesh = true
  []
  [particle_power]
    type = ElementIntegralPower
    variable = temperature
    use_material_fission_rate = true
    fission_rate_material = fission_rate
    block = fuel
    execute_on = 'initial timestep_end'
  []
  [max_fluence]
    type = ElementExtremeValue
    variable = fast_neutron_fluence
    value_type = 'max'
    execute_on = 'initial timestep_end'
  []
  [max_burnup]
    type = ElementExtremeValue
    variable = burnup
    block = fuel
    value_type = 'max'
    execute_on = 'initial timestep_end'
  []
  [SiC_stress]
    type = ElementExtremeMaterialProperty
    block = SiC
    value_type = min
    mat_prop = stress_yy
  []
  [IPyC_stress]
    type = ElementExtremeMaterialProperty
    block = IPyC
    value_type = min
    mat_prop = stress_yy
  []
  [OPyC_stress]
    type = ElementExtremeMaterialProperty
    block = OPyC
    value_type = min
    mat_prop = stress_yy
  []
  [strength_SiC]
    type = WeibullEffectiveMeanStrength
    block = SiC
    weibull_modulus = 6
  []
  [failure_indicator_SiC]
    type = WeibullFailureOutputUsingCorrelation
    block = SiC
    weibull_modulus = 6
    stress_name = stress_yy
    high_fidelity_analysis_strength = 'high_fidelity_strength_asphericity'
    stress_correlation_function = 'stress_correlation_asphericity'
    stress_change_correlation_function = 'stress_change_correlation_asphericity'
  []
  [strength_IPyC]
    type = WeibullEffectiveMeanStrength
    block = IPyC
    weibull_modulus = 9.5
  []
  [strength_OPyC]
    type = WeibullEffectiveMeanStrength
    block = OPyC
    weibull_modulus = 9.5
  []
  [failure_indicator_IPyC]
    type = WeibullFailureOutputUsingCorrelation
    block = IPyC
    weibull_modulus = 9.5
    stress_name = max_principal_stress
    effective_mean_strength = strength_IPyC
  []
  [failure_indicator_SiC_crackedIPyC]
    type = WeibullFailureOutputUsingCorrelation
    block = SiC
    weibull_modulus = 6
    stress_name = stress_yy
    high_fidelity_analysis_strength = 'high_fidelity_strength_crackedIPyC'
    stress_correlation_function = 'stress_correlation_crackedIPyC'
  []
  [sic_failure_overall]
    type = TRISOFailureEvaluation
    IPyC_failure = failure_indicator_IPyC
    SiC_failure_crackedIPyC = failure_indicator_SiC_crackedIPyC
    SiC_failure = failure_indicator_SiC
    SiC_failure_pd_penetration = failure_indicator_pd_penetration
    SiC_failure_kernel_migration = failure_indicator_kernel_migration
    failure_type = SIC_FAILURE_OVERALL
  []
  [ipyc_cracking]
    type = TRISOFailureEvaluation
    IPyC_failure = failure_indicator_IPyC
    SiC_failure_crackedIPyC = failure_indicator_SiC_crackedIPyC
    SiC_failure = failure_indicator_SiC
    failure_type = IPYC_CRACKING
  []
  [sic_failure_due_to_pressure]
    type = TRISOFailureEvaluation
    IPyC_failure = failure_indicator_IPyC
    SiC_failure_crackedIPyC = failure_indicator_SiC_crackedIPyC
    SiC_failure = failure_indicator_SiC
    failure_type = SIC_FAILURE_DUE_TO_PRESSURE
  []
  [sic_failure_due_to_ipyc_cracking]
    type = TRISOFailureEvaluation
    IPyC_failure = failure_indicator_IPyC
    SiC_failure_crackedIPyC = failure_indicator_SiC_crackedIPyC
    SiC_failure = failure_indicator_SiC
    failure_type = SIC_FAILURE_DUE_TO_IPYC_CRACKING
  []
  [fluence_at_failure]
    type = TRISOFailureOccurrenceStatus
    failure_evaluation = ipyc_cracking
    failure_information = max_fluence
  []
  [weibull_failure_probability_IPyC]
    type = WeibullFailureProbability
    block = IPyC
    weibull_modulus = 9.5
    characteristic_strength = characteristic_strength
  []
  [weibull_failure_probability_SiC]
    type = WeibullFailureProbability
    block = SiC
    weibull_modulus = 6
    characteristic_strength = characteristic_strength
  []
  [pd_penetration]
    type = PdPenetration
    boundary = SiC_inner_boundary
    variable = temperature
    execute_on = 'initial timestep_end'
  []
  [failure_indicator_pd_penetration]
    type = PdPenetrationFailureIndicator
    triso_geometry = particle_geometry
    pd_penetration = pd_penetration
  []
  [kernel_migration_distance]
    type = KernelMigrationDistance
    block = 'fuel buffer IPyC SiC OPyC'
    variable = temperature
    temperature_gradient = 15000
    kernel_type = UCO
  []
  [failure_indicator_kernel_migration]
    type = KernelMigrationFailureIndicator
    kernel_migration_distance = kernel_migration_distance
    triso_geometry = particle_geometry
  []
[]

[Outputs]
  print_linear_residuals = false
  csv = false
  exodus = false
  perf_graph = false
  print_linear_converged_reason = false
  print_nonlinear_converged_reason = false
[]
