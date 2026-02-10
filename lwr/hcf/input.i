[GlobalParams]
  displacements = 'disp_x disp_y disp_z'
  temperature = temp
  X_Zr = 0.7229  # U-50Zr
  X_Pu = 0.0
  order = FIRST
  family = LAGRANGE
  volumetric_locking_correction = true
[]

###################################################################################################

[Problem]
  type = ReferenceResidualProblem
  reference_vector = 'ref'
  extra_tag_vectors = 'ref'
  converge_on = 'disp_x disp_y disp_z temp'
[]

###################################################################################################

[Mesh]
  # Import mesh file
  [mesh]
    type = FileMeshGenerator
    file = 'mesh.e'
  []
  centroid_partitioner_direction = y
[]

###################################################################################################

[Variables]
  [temp]
    initial_condition = 522.0
  []
[]

###################################################################################################

[AuxVariables]
  [fast_neutron_flux]
    block = 'cladding'
  []
  [fast_neutron_fluence]
    block = 'cladding'
  []
  [solid_swell]
    block = 'fuel'
    order = CONSTANT
    family = MONOMIAL
  []
  [gas_swell]
    block = 'fuel'
    order = CONSTANT
    family = MONOMIAL
  []
  [total_hoop_strain]
    block = 'cladding'
    order = CONSTANT
    family = MONOMIAL
  []
  [creeprate]
    order = CONSTANT
    family = MONOMIAL
  []
  [primary_creep]
    order = CONSTANT
    family = MONOMIAL
  []
  [thermal_secondary_creep]
    block = 'cladding displacer'
    order = CONSTANT
    family = MONOMIAL
  []
  [thermal_creep]
    block = 'fuel'
    order = CONSTANT
    family = MONOMIAL
  []
  [irradiation_creep]
    order = CONSTANT
    family = MONOMIAL
  []
  [oxide_thickness] # ZrO2 scale thickness (m)
    block = 'cladding'
    order = CONSTANT
    family = MONOMIAL
  []
[]

###################################################################################################

[Functions]
  [power_history]
    type = PiecewiseLinear
    data_file = lhgr_peak.csv   # time vs. linear power
    format = columns
  []
  [axial_peaking_factors]
    type = ConstantFunction
    value = 1.0
  []
  [fission_rate_scale_factor]
    type = ParsedFunction
    expression = 6.019803e14 # 1/cross_sectional_area_of_fuel/energy_per_fission
  []
  [fission_history]
    type = CompositeFunction
    functions = 'power_history fission_rate_scale_factor'
  []
  [u50zr_thermal_conductivity]
    type = PiecewiseLinear
    data_file = U50Zr_thermal_conductivity.csv ## Temperature [K] vs. thermal conductivity (W/m-K)from INL report
    format = columns
  []
  [u50zr_heat_capacity]
    type = PiecewiseLinear
    data_file = U50Zr_heat_capacity.csv        ## Temperature [K] vs. heat capacity (J/kg-K) from INL report
    format = columns
  []
  [u50zr_therm_expan]
    type = PiecewiseLinear
    data_file = U50Zr_thermal_expansion.csv    ## Temperature [K] vs. thermal expansionfrom INL report
    format = columns
  []
[]

###################################################################################################

[Physics/SolidMechanics/QuasiStatic]
  strain = FINITE
  add_variables = true
  generate_output = 'vonmises_stress hydrostatic_stress hoop_stress stress_xx stress_yy stress_zz strain_xx strain_yy strain_zz elastic_strain_xx elastic_strain_yy elastic_strain_zz
                     creep_strain_xx creep_strain_yy creep_strain_zz hoop_strain hoop_creep_strain hoop_elastic_strain'
  [fuel]
    block = fuel
    eigenstrain_names = 'fuel_thermalexp_strain fuel_swelling_strain'
    additional_generate_output = 'volumetric_strain'
    decomposition_method = EigenSolution
  []
  [cladding]
    block = cladding
    eigenstrain_names = 'clad_thermalexp_strain clad_irrad_strain'
    extra_vector_tags = 'ref'
    additional_generate_output = 'plastic_strain_xx plastic_strain_yy plastic_strain_zz hoop_plastic_strain'
    decomposition_method = EigenSolution
  []
  [displacer]
    block = displacer
    eigenstrain_names = 'disp_thermalexp_strain'
    extra_vector_tags = 'ref'
    decomposition_method = EigenSolution
  []
[]

###################################################################################################

[Kernels]
  [gravity]
    type = Gravity
    variable = disp_y
    value = -9.81
    extra_vector_tags = 'ref'
  []
  [heat]
    type = HeatConduction
    variable = temp
    extra_vector_tags = 'ref'
  []
  [heat_ie]
    type = HeatConductionTimeDerivative
    variable = temp
    extra_vector_tags = 'ref'
  []
  [heat_source]
    type = FissionRateHeatSource
    block = fuel
    variable = temp
    fission_rate = 'fission_rate'
    extra_vector_tags = 'ref'
  []
[]

###################################################################################################

[AuxKernels]
  [fast_neutron_flux]
    type = FastNeutronFluxAux
    variable = fast_neutron_flux
    block = cladding
    factor = 3e13
    rod_ave_lin_pow = power_history
    axial_power_profile = axial_peaking_factors
    execute_on = timestep_begin
  []
  [fast_neutron_fluence]
    type = FastNeutronFluenceAux
    variable = fast_neutron_fluence
    block = cladding
    fast_neutron_flux = fast_neutron_flux
    execute_on = timestep_begin
  []
  [gas_swell]
    type = MaterialRealAux
    variable = gas_swell
    block = fuel
    property = gas_swelling
    execute_on = timestep_end
  []
  [solid_swell]
    type = MaterialRealAux
    variable = solid_swell
    block = fuel
    property = solid_swelling
    execute_on = timestep_end
  []
  [total_hoop_strain]
    type = RankTwoAux
    rank_two_tensor = total_strain
    variable = total_hoop_strain
    index_j = 2
    index_i = 2
    execute_on = timestep_end
  []
  [creeprate]
    type = MaterialRealAux
    property = creep_rate
    execute_on = timestep_end
    variable = creeprate
  []
  [primary_creep]
    type = MaterialRealAux
    block = cladding
    property = primary_creep_strain
    execute_on = timestep_end
    variable = primary_creep
  []
  [thermal_secondary_creep]
    type = MaterialRealAux
    block = cladding
    property = thermal_secondary_creep_strain
    execute_on = timestep_end
    variable = thermal_secondary_creep
  []
  [thermal_creep]
    type = MaterialRealAux
    block = fuel
    property = thermal_creep_strain
    execute_on = timestep_end
    variable = thermal_creep
  []
  [irradiation_creep]
    type = MaterialRealAux
    block = 'fuel cladding'
    property = irradiation_creep_strain
    execute_on = timestep_end
    variable = irradiation_creep
  []
  [oxide_thickness]
    type = MaterialRealAux
    boundary = 'side'
    variable = oxide_thickness
    property = oxide_scale_thickness
    execute_on = 'linear'
  []
[]

[BCs]
  [no_x_bottom_node]
    type = DirichletBC
    variable = disp_x
    boundary = 'bcenter'
    value = 0.0
  []
  [no_z_bottom_node]
    type = DirichletBC
    variable = disp_z
    boundary = 'bcenter bcenter_nx'
    value = 0.0
  []
  [no_y_bottom_node]
    type = DirichletBC
    variable = disp_y
    boundary = 'bcenter'
    value = 0.0
  []
  [no_y_bottom]
    type = DirichletBC
    variable = disp_y
    boundary = 'bottom'
    value = 0.0
  []
  [Pressure]
    [coolantPressure]
      boundary = side
      factor = 13.8e6
    []
  []
[]

###################################################################################################

[CoolantChannel]
  [convective_clad_surface] # apply convective boundary to clad outer surface
    boundary = side
    variable = temp
    inlet_temperature = 522.0        # K
    inlet_pressure    = 13.8e6       # Pa
    inlet_massflux    = 771          # kg/m^2-sec
    flow_area = 9.4111e-05           # m2
    heated_diameter = 9.0727e-3      # m
    heated_perimeter = 4.0443e-2     # m
    hydraulic_diameter = 9.3082e-3   # m
    linear_heat_rate  = power_history
    axial_power_profile = axial_peaking_factors
    oxide_thickness = oxide_thickness
  []
[]

###################################################################################################

[Materials]
  ## fuel: U-50Zr
  [fission_rate]
    type = GenericFunctionMaterial
    block = 'fuel'
    prop_names = 'fission_rate'
    prop_values = fission_history
    outputs = all
  []
  [burnup]
    type = UPuZrBurnup
    block = 'fuel'
    density = 9640.0
    initial_X_Zr = 0.7229
    initial_X_Pu = 0.0
    fission_rate = fission_rate
  []
 [fuel_thermal]
   type = HeatConductionMaterial
   block = 'fuel'
   thermal_conductivity_temperature_function = u50zr_thermal_conductivity
   specific_heat_temperature_function = u50zr_heat_capacity
   temp = temp
 []
  [fuel_density]
    type = StrainAdjustedDensity
    block = fuel
    strain_free_density = 9640
  []
  [fuel_elasticity_tensor]
    type = UPuZrElasticityTensor
    temperature = temp
    block = 'fuel'
    youngs_model = LANL
  []
  [fuel_stress]
    type = ComputeMultipleInelasticStress
    block = 'fuel'
    inelastic_models = 'fuel_creep'
    tangent_operator = elastic
  []
  [fuel_creep]
    type = UPuZrCreepUpdate
    block = 'fuel'
  []
  [fuel_swelling]
    type = UPuZrVolumetricSwellingEigenstrain
    eigenstrain_name = 'fuel_swelling_strain'
    block = 'fuel'
    burnup = burnup
    hydrostatic_stress = hydrostatic_stress
    fission_rate = fission_rate
    initial_porosity = 0.1
    bubble_radius = 10e-9 # new input paramter for fission gas bubble radius
  []
  [fuel_thermal_expansion]
    type = ComputeDilatationThermalExpansionFunctionEigenstrain
    block = 'fuel'
    dilatation_function = u50zr_therm_expan
    eigenstrain_name = 'fuel_thermalexp_strain'
    stress_free_temperature = 300
  []
  [fission_gas_release]
    type = UPuZrFissionGasRelease
    block = 'fuel'
    fission_rate = fission_rate
  []
  [fuel_phase]
    type = UPuZrPhase
    block = 'fuel'
    temperature = temp
  []

  ## cladding: Zr-1%Nb (M5)
  [clad_thermal]
    type = ZryThermal
    block = 'cladding'
  []
  [clad_density]
    type = StrainAdjustedDensity  
    block = 'cladding'
    strain_free_density = 6551.0
  []
  [clad_thermal_expansion]
    block = 'cladding'
    type = ZryThermalExpansionMATPROEigenstrain
    eigenstrain_name = clad_thermalexp_strain
    stress_free_temperature = 300
    axial_direction = y
  []
  [clad_elasticity_tensor]
    type = ZryElasticityTensor
    block = 'cladding'
    fast_neutron_fluence = fast_neutron_fluence
    matpro_poissons_ratio = true
    matpro_youngs_modulus = true
  []
  [clad_stress]
    type = ComputeMultipleInelasticStress
    block = 'cladding'
    inelastic_models = 'clad_plas clad_creep'
    tangent_operator = elastic
  []
  [clad_plas]
    type = ZryPlasticityUpdate
    block = 'cladding'
    fast_neutron_fluence = fast_neutron_fluence
    fast_neutron_flux = fast_neutron_flux
    plasticity_model_type = MATPRO
  []
  [clad_creep]
    type = ZryCreepLimbackHoppeUpdate
    block = 'cladding'
    temperature = temp
    fast_neutron_fluence = fast_neutron_fluence
    fast_neutron_flux = fast_neutron_flux
    zircaloy_material_type = M5
  []
  [clad_irrad_growth]
    type = ZryIrradiationGrowthEigenstrain
    block = 'cladding'
    eigenstrain_name = clad_irrad_strain
    fast_neutron_fluence = fast_neutron_fluence
    zircaloy_material_type = M5
    axial_direction = 1
  []
  [oxidation_zry]
    type = ZryOxidation
    boundary = side
    clad_inner_radius = 0.004093 # hcf --> cylinder equivalent radius
    clad_outer_radius = 0.004536
    normal_operating_temperature_model = epri_kwu_ce
    high_temperature_model = leistikow
    fast_neutron_flux = fast_neutron_flux
    oxygen_weight_fraction_initial = 0.0
    use_coolant_channel = true
  []

  ## displacer: pure Zirconium
  [disp_thermal]
    type = ZrThermal
    block = 'displacer'
  []
  [disp_density]
    type = StrainAdjustedDensity
    block = 'displacer'
    strain_free_density = 6530.0
  []
  [disp_thermal_expansion]
    type = ZrThermalExpansionEigenstrain
    block = 'displacer'
    stress_free_temperature = 300
    eigenstrain_name = disp_thermalexp_strain
  []
  [disp_elasticity_tensor]
    type = ComputeIsotropicElasticityTensor
    block = 'displacer'
    youngs_modulus = 94.5e9
    poissons_ratio = 0.34
  []
  [disp_stress]
    type = ComputeMultipleInelasticStress
    block = 'displacer'
    tangent_operator = elastic
    inelastic_models = 'disp_zrcreep'
  []
  [disp_zrcreep]
    type = ZrCreepUpdate
    block = 'displacer'
  []
[]

###################################################################################################

[Executioner]
  type = Transient
  solve_type = 'PJFNK'

  petsc_options = '-snes_converged_reason -ksp_converged_reason -snes_ksp_ew'
  petsc_options_iname = '-pc_type -mat_mffd_err -pc_factor_shift_type -pc_factor_shift_amount -pc_factor_mat_solver_package'
  petsc_options_value = 'lu       1e-6          NONZERO               1e-15                   superlu_dist'

  l_max_its = 50
  l_tol = 1e-4
  nl_max_its = 40
  nl_rel_tol = 1e-4
  nl_abs_tol = 1e-8
  
  start_time = 0
  end_time = 136235520

  dtmax = 2e6
  dtmin = 1

  [TimeStepper]
    type = IterationAdaptiveDT
    dt = 100
    optimal_iterations = 15
    iteration_window = 3
    growth_factor = 2
    cutback_factor = .5
    force_step_every_function_point = true
    timestep_limiting_function = power_history
  []
[]

###################################################################################################

[Postprocessors]
  [_dt]
    type = TimestepSize
  []
  [_nl_its]
    type = NumNonlinearIterations
  []
  [rod_total_power]
    type = ElementIntegralPower
    block = fuel
    fission_rate = fission_rate
    variable = temp
    outputs = all
    execute_on = timestep_end
  []
  [rod_input_power]
    type = FunctionValuePostprocessor
    function = power_history
    scale_factor = 0.25 # rod height [m]
  []
  [average_burnup]
    type = ElementAverageMaterialProperty
    mat_prop = burnup
    block = 'fuel'
  []
  [fuel_temp_max]
    type = ElementExtremeValue
    variable = temp
    value_type = max
    block = fuel
  []
  [clad_temp_max]
    type = ElementExtremeValue
    variable = temp
    value_type = max
    block = cladding
  []
  [fis_gas_produced]
    type = ElementIntegralMaterialProperty
    block = fuel
    mat_prop = fis_gas_prod
  []
  [fis_gas_released]
    type = ElementIntegralMaterialProperty
    block = fuel
    mat_prop = fis_gas_rel
  []
  [fgr_percent]
    type = FGRPercent
    fission_gas_released = fis_gas_released
    fission_gas_generated = fis_gas_produced
    execute_on = 'initial timestep_end'
  []
  [fuel_solid_swell]
    type = ElementAverageValue
    variable = solid_swell
    block = fuel
  []
  [fuel_gas_swell]
    type = ElementAverageValue
    variable = gas_swell
    block = fuel
  []
  [fuel_porosity]
    type = ElementAverageMaterialProperty
    mat_prop = porosity
    block = fuel
  []
  [clad_creep_rate]
    type = ElementAverageValue
    block = cladding
    variable = creeprate
  []
  [fuel_vonmises_max]
    type = ElementExtremeValue
    value_type = max
    variable = vonmises_stress
    block = fuel
  []
  [clad_vonmises_max]
    type = ElementExtremeValue
    value_type = max
    variable = vonmises_stress
    block = cladding
  []
  [fuel_volumetric_strain]
    type = ElementAverageValue
    variable = volumetric_strain
    block = fuel
  []
  [clad_total_hoop_strain]
    type = ElementAverageValue
    block = cladding
    variable = total_hoop_strain
  []
  [clad_hoop_strain]
    type = ElementAverageValue
    block = cladding
    variable = hoop_strain
  []
  [clad_hoop_plastic_strain]
    type = ElementAverageValue
    block = cladding
    variable = hoop_plastic_strain
  []
  [clad_oxide_thickness_max]
    type = ElementExtremeValue
    block = cladding
    variable = oxide_thickness
    value_type = max
    execute_on = 'timestep_end'
  []
[]

###################################################################################################

[Outputs]
  # Define output file(s)
  csv = true
  color = true
  progress = true
  [exodus]
    type = Exodus
    time_step_interval = 2
  []
  [console]
    type = Console
    output_file = true
    max_rows = 25
  []
  [checkpoint]
    type = Checkpoint
    time_step_interval = 3
    num_files = 2
    wall_time_checkpoint = false
  []
  [pgraph]
    type = PerfGraphOutput
  []
[]
