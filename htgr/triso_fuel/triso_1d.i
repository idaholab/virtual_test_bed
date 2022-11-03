temperature = 973.15 # K

kernel_radius = 213.35e-6 # micron
buffer_thickness = 98.9e-6 # micron
IPyC_thickness = 40.4e-6 # micron
SiC_thickness = 35.2e-6 # micron
OPyC_thickness = 43.4e-6 # micron

coordinates1 = '${fparse kernel_radius}'
coordinates2 = '${fparse coordinates1+buffer_thickness}'
coordinates3 = '${fparse coordinates2+IPyC_thickness}'
coordinates4 = '${fparse coordinates3+SiC_thickness}'
coordinates5 = '${fparse coordinates4+OPyC_thickness}'

[GlobalParams]
  order = FIRST
  family = LAGRANGE
  displacements = 'disp_x'
  initial_enrichment = 0.155 # [wt-]
  flux_conversion_factor = 1.0 # convert E>0.10 to E>0.18 MeV
  stress_free_temperature = ${temperature} # used for thermal expansion
  energy_per_fission = 3.204e-11 # [J/fission]
  O_U = 1.5 # Initial Oxygen to Uranium atom ratio
  C_U = 0.4 # Initial Carbon to Uranium atom ratio
[]

[Mesh]
  coord_type = RSPHERICAL
  [gen]
    type = TRISO1DMeshGenerator
    elem_type = EDGE3
    coordinates = '0 ${coordinates1} ${coordinates2} ${coordinates2} ${coordinates3} ${coordinates4} '
                  '${coordinates5}'
    mesh_density = '5 3 0 5 3 4'
    block_names = 'fuel buffer IPyC SiC OPyC'
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
    outer_OPyC = OPyC_right_boundary
    outer_SiC = SiC_right_boundary
    outer_IPyC = IPyC_right_boundary
    inner_IPyC = IPyC_left_boundary
    outer_buffer = buffer_right_boundary
    outer_kernel = fuel_right_boundary
    include_particle = true
    include_pebble = false
    IPyC_thickness_mean = 40.4e-6
    SiC_thickness_mean = 35.2e-6
    OPyC_thickness_mean = 43.4e-6
  []
[]

[Variables]
  [temperature]
    initial_condition = ${temperature}
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
  [fission_rate]
    type = ConstantFunction
    value = 7.78e19
  []
[]

[Modules/TensorMechanics/Master]
  generate_output = 'stress_xx stress_yy stress_zz strain_xx strain_yy strain_zz '
                    'max_principal_stress'
  add_variables = true
  strain = FINITE
  temperature = temperature
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
    type = GapHeatTransferLWR
    variable = temperature
    primary = IPyC_left_boundary
    secondary = buffer_right_boundary
    initial_moles = initial_moles
    gas_released = 'fis_gas_released'
    gas_released_fractions = '0 0 0 0.185 0.815 0 0 0 0 0 0'
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
    function = ${temperature}
    boundary = exterior
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
  [normal_vectors_triso]
    type = NormalVectorsTRISO
    block = 'buffer IPyC OPyC'
  []
  [tangential_stress]
    type = RankTwoCylindricalComponent
    rank_two_tensor = stress
    cylindrical_axis_point1 = '0 0 0'
    cylindrical_axis_point2 = '0 0 1'
    cylindrical_component = HoopStress
    property_name = tangential_stress
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
    function = 1.16e18
  []
  [UCO_burnup]
    type = TRISOBurnup
    initial_density = 11000
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
    density = 11000.0
  []
  [fission_gas_release]
    type = UCOFGR
    block = fuel
    average_grain_radius = 10e-6
    temperature = temperature
    triso_geometry = particle_geometry
  []
  [BAF]
    type = BaconAnisotropyFactor
    initial_BAF = 1.05
    block = 'buffer IPyC OPyC'
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
    prop_values = 1900
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
    density = 3200.0
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
    prop_values = 1900
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
  end_time = 4.4047e+07

  dtmin = 1e-4

  dt = 86400
[]

[Postprocessors]
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
    value_type = max
    mat_prop = tangential_stress
  []
  [strength_SiC]
    type = WeibullEffectiveMeanStrength
    block = SiC
    weibull_modulus = 6
    use_displaced_mesh = false
  []
  [strength_IPyC]
    type = WeibullEffectiveMeanStrength
    block = IPyC
    weibull_modulus = 9.5
    use_displaced_mesh = false
  []
[]

[Outputs]
  csv = true
  exodus = true
[]
