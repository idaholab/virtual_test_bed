# ==============================================================================
# Probabilistic fracture model for LWR Reactor Pressure Vessel
# Application : Grizzly
# ------------------------------------------------------------------------------
# Idaho Falls, INL, 2024
# Author(s): Ben Spencer, Will Hoffman
# If using or referring to this model, please cite as explained on
# https://mooseframework.inl.gov/virtual_test_bed/citing.html
# ==============================================================================

[Mesh]
  type = GeneratedMesh
  dim = 1
  nx = 1
[]

[Samplers]
  [sample]
    type = RPVFractureSampler
    num_rpvs = 50000
    subregions_file = plates_and_welds.csv
    surface_vflaw_file = surface_open_access.dat
    plate_vflaw_file = plate_open_access.dat
    weld_vflaw_file = weld_open_access.dat
    vessel_geometry = vessel_geom
    length_unit = M
    plate_sigma_cu = 0.0073
    plate_sigma_ni = 0.0244
    plate_sigma_p = 0.0013
    weld_sigma_cu = 0.167
    weld_sigma_ni = 0.0165
    weld_sigma_p = 0.0013
    ni_addition_weld = false
    global_fluence_coefficient_of_variation = 0.118
    local_fluence_coefficient_of_variation = 0.056
    execute_on = initial
  []
[]

[UserObjects]
  [vessel_geom]
    type = VesselGeometry
    total_thickness = 0.219202
    clad_thickness = 0.004064
    inner_radius = 2.1971
  []
  [flaw_data]
    type = FlawDataFromSampler
    sampler = sample
    vessel_geometry = vessel_geom
    execute_on = initial
  []
  [clad_axial_coefs]
    type = PolynomialCoefficientsFromFile
    polynomial_coefficient_file = ../thermomechanical/rpv_thermomechanical_3d_out_coefs_axial_clad.csv
    coord_system = 3D_CARTESIAN
    symmetry = QUARTER
    flaw_data = flaw_data
    axial_start = -0.2
    axial_end = 4.2
    axial_num_points = 16
    azimuthal_start = 0.0
    azimuthal_end = 90.0
    azimuthal_num_points = 12
  []
  [clad_hoop_coefs]
    type = PolynomialCoefficientsFromFile
    polynomial_coefficient_file = ../thermomechanical/rpv_thermomechanical_3d_out_coefs_hoop_clad.csv
    coord_system = 3D_CARTESIAN
    symmetry = QUARTER
    flaw_data = flaw_data
    axial_start = -0.2
    axial_end = 4.2
    axial_num_points = 16
    azimuthal_start = 0.0
    azimuthal_end = 90.0
    azimuthal_num_points = 12
  []
  [base_axial_coefs]
    type = PolynomialCoefficientsFromFile
    polynomial_coefficient_file = ../thermomechanical/rpv_thermomechanical_3d_out_coefs_axial_base.csv
    coord_system = 3D_CARTESIAN
    symmetry = QUARTER
    flaw_data = flaw_data
    axial_start = -0.2
    axial_end = 4.2
    axial_num_points = 16
    azimuthal_start = 0.0
    azimuthal_end = 90.0
    azimuthal_num_points = 12
  []
  [base_hoop_coefs]
    type = PolynomialCoefficientsFromFile
    polynomial_coefficient_file = ../thermomechanical/rpv_thermomechanical_3d_out_coefs_hoop_base.csv
    coord_system = 3D_CARTESIAN
    symmetry = QUARTER
    flaw_data = flaw_data
    axial_start = -0.2
    axial_end = 4.2
    axial_num_points = 16
    azimuthal_start = 0.0
    azimuthal_end = 90.0
    azimuthal_num_points = 12
  []
  [base_temp_coefs]
    type = PolynomialCoefficientsFromFile
    polynomial_coefficient_file = ../thermomechanical/rpv_thermomechanical_3d_out_coefs_temp_base.csv
    coord_system = 3D_CARTESIAN
    symmetry = QUARTER
    flaw_data = flaw_data
    axial_start = -0.2
    axial_end = 4.2
    axial_num_points = 16
    azimuthal_start = 0.0
    azimuthal_end = 90.0
    azimuthal_num_points = 12
  []
  [temperature]
    type = FieldValueFromCoefficients
    base_coefficient_calculator = base_temp_coefs
    vessel_geometry = vessel_geom
  []
  [fluence]
    type = FluenceAttenuatedFromSurface
    length_unit = M
    flaw_data = flaw_data
  []
  [embrittlement]
    type = EmbrittlementEONY
    irradiation_time = 1.2614e+9
    irradiation_temperature = 547.0
    fluence_calculator = fluence
    plate_type = CE
    weld_type = OTHER
    flaw_data = flaw_data
    version = FAVOR16_EASON_2006
  []
  [ki_calculator]
    type = KIAxisAlignedROM
    base_axial_coefficient_calculator = base_axial_coefs
    base_hoop_coefficient_calculator = base_hoop_coefs
    clad_axial_coefficient_calculator = clad_axial_coefs
    clad_hoop_coefficient_calculator = clad_hoop_coefs
    flaw_data = flaw_data
    vessel_geometry = vessel_geom
    length_unit = M
    axial_surface_sific_method = FAVOR16
    circumferential_surface_sific_method = FAVOR16
    embedded_sific_method = FAVOR16
  []
  [cpi_calculator]
    type = FractureProbability
    ki_calculator = ki_calculator
    temperature_calculator = temperature
    embrittlement_calculator = embrittlement
    ki_unit = PA_SQRT_M
    temperature_unit = K
    flaw_data = flaw_data
  []
[]

[Executioner]
  type = Transient
  start_time = 0.0
  dt = 60.0
  end_time = 2000.0
[]

[Problem]
  solve = false
[]

[VectorPostprocessors]
  active = 'rpv_failprob cpi_running_statistics flaw_failure_data'
  [rpv_failprob]
    type = RPVFailureProbability
    cpi_calculator = cpi_calculator
    flaw_data = flaw_data
    execute_on = timestep_end
    outputs = none
  []
  [cpi_running_statistics]
    type = VectorPostprocessorRunningStatistics
    vector_postprocessor = rpv_failprob
    vector_name = failure_probabilities
    execute_on = timestep_end
    outputs = final
  []
  [flaw_failure_data]
    type = RPVFlawFailureData
    cpi_calculator = cpi_calculator
    vessel_geometry = vessel_geom
    execute_on = timestep_end
    outputs = final
  []
  [samples]
    type = RPVSamplerData
    sampler = sample
    execute_on = initial
    outputs = final
  []
[]

[Postprocessors]
  [rpv_failprob_mean]
    type = VectorPostprocessorStatistics
    vector_postprocessor = rpv_failprob
    vector_name = failure_probabilities
    quantity = Mean
    execute_on = timestep_end
    outputs = 'console out'
  []
  [rpv_failprob_std_dev]
    type = VectorPostprocessorStatistics
    vector_postprocessor = rpv_failprob
    vector_name = failure_probabilities
    quantity = StandardDeviation
    execute_on = timestep_end
    outputs = 'console out'
  []
[]

[Outputs]
  [out]
    type = CSV
    execute_on = 'timestep_end'
  []
  [final]
    type = CSV
    execute_on = 'final'
  []
  [initial]
    type = CSV
    execute_on = 'initial'
  []
[]
