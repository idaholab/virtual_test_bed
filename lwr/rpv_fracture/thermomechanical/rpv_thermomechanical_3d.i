# ==============================================================================
# 3D Thermo-mechanical analysis of Light Water Reactor Pressure Vessel
# Application : Grizzly
# ------------------------------------------------------------------------------
# Idaho Falls, INL, 2024
# Author(s): Ben Spencer, Will Hoffman
# If using or referring to this model, please cite as explained on
# https://mooseframework.inl.gov/virtual_test_bed/citing.html
# ==============================================================================

[GlobalParams]
  order = FIRST
  family = LAGRANGE
  displacements = 'disp_x disp_y disp_z'
[]

[Mesh]
  file = rpv_fine.e
  use_displaced_mesh = false
[]

[Problem]
  type = ReferenceResidualProblem
  extra_tag_vectors = 'ref'
  reference_vector = 'ref'
  group_variables = 'disp_x disp_y disp_z'
[]

[Variables]
  [temp]
    initial_condition = 559.23333
  []
[]

[AuxVariables]
  [hoop_stress_clad]
    order = FIRST
    family = MONOMIAL
  []
  [axial_stress_clad]
    order = FIRST
    family = MONOMIAL
  []
  [hoop_stress_base]
    order = FIRST
    family = MONOMIAL
  []
  [axial_stress_base]
    order = FIRST
    family = MONOMIAL
  []
[]

[Physics/SolidMechanics/QuasiStatic]
  [all]
    strain = SMALL
    temperature = temp
    add_variables = true
    generate_output = 'stress_xx stress_yy stress_zz'
    eigenstrain_names = thermal_eigenstrain
    extra_vector_tags = 'ref'
  []
[]

[Kernels]
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
[]

[AuxKernels]
  [axial_stress_clad]
    type = MaterialRealAux
    block = 2
    property = axial_stress_clad
    variable = axial_stress_clad
  []
  [hoop_stress_clad]
    type = MaterialRealAux
    block = 2
    property = hoop_stress_clad
    variable = hoop_stress_clad
  []
  [axial_stress_base]
    type = MaterialRealAux
    block = 1
    property = axial_stress_base
    variable = axial_stress_base
  []
  [hoop_stress_base]
    type = MaterialRealAux
    block = 1
    property = hoop_stress_base
    variable = hoop_stress_base
  []
[]

[Functions]
  [time_steps]
    type = PiecewiseLinear
    xy_data = '0 1
               1 59
               60 60'
  []
  [coolant_pressure_history]
    type = PiecewiseLinear
    data_file = pressure_history.csv
    format = columns
  []
  [coolant_temperature_history]
    type = PiecewiseLinear
    data_file = temperature_history.csv
    format = columns
  []
  [heat_transfer_coefficient_history]
    type = PiecewiseLinear
    data_file = heat_transfer_coefficient_history.csv
    format = columns
  []
  [cte_func_clad]
    type = PiecewiseLinear
    x = '294.26 310.93 338.71 366.48 394.26 422.04 449.82 477.59 505.37 533.15 560.93 588.71 616.48 644.26 672.04 699.82'
    y = '8.50e-6 8.70e-6 9.00e-6 9.40e-6 9.60e-6 9.90e-6 1.01e-5 1.02e-5 1.04e-5 1.05e-5 1.06e-5 1.06e-5 1.07e-5 1.08e-5 1.08e-5 1.09e-5'
    scale_factor = 1.8
  []
  [cte_func_base]
    type = PiecewiseLinear
    x = '294.26 310.93 338.71 366.48 394.26 422.04 449.82 477.59 505.37 533.15 560.93 588.71 616.48 644.26'
    y = '6.40e-6 6.60e-6 6.80e-6 7.00e-6 7.20e-6 7.30e-6 7.50e-6 7.70e-6 7.80e-6 8.00e-6 8.20e-6 8.30e-6 8.50e-6 8.70e-6'
    scale_factor = 1.8
  []
  [k_func_clad]
    type = PiecewiseLinear
    x = '294.26 310.93 338.71 366.48 394.26 422.04 449.82 477.59 505.37 533.15 560.93 588.71 616.48 644.26 672.04 699.82'
    y = '8.6 8.7 9.0 9.3 9.6 9.8 10.1 10.4 10.6 10.9 11.1 11.3 11.6 11.8 12.0 12.3'
    scale_factor = 1.73
  []
  [k_func_base]
    type = PiecewiseLinear
    x = '294.26 310.93 338.71 366.48 394.26 422.04 449.82 477.59 505.37 533.15 560.93 588.71 616.48 644.26 672.04 699.82'
    y = '23.7 23.6 23.5 23.5 23.4 23.4 23.3 23.1 23.0 22.7 22.5 22.2 21.9 21.6 21.3 21.0'
    scale_factor = 1.73
  []
  [c_func_clad]
    type = PiecewiseLinear
    x = '294.26 310.93 338.71 366.48 394.26 422.04 449.82 477.59 505.37 533.15 560.93 588.71 616.48 644.26 672.04 699.82'
    y = '0.118 0.118 0.121 0.123 0.126 0.127 0.129 0.130 0.131 0.133 0.133 0.134 0.135 0.136 0.136 0.138'
    scale_factor = 4186.8
  []
  [c_func_base]
    type = PiecewiseLinear
    x = '294.26 310.93 338.71 366.48 394.26 422.04 449.82 477.59 505.37 533.15 560.93 588.71 616.48 644.26 672.04 699.82'
    y = '0.107 0.108 0.111 0.115 0.117 0.121 0.123 0.126 0.129 0.131 0.134 0.137 0.139 0.142 0.145 0.149'
    scale_factor = 4186.8
  []
[]

[BCs]
  [no_x_all]
    type = DirichletBC
    variable = disp_x
    boundary = '1'
    value = 0.0
  []

  [no_y_all]
    type = DirichletBC
    variable = disp_y
    boundary = '2'
    value = 0.0
  []
  [no_z]
    type = DirichletBC
    variable = disp_z
    boundary = '101'
    value = 0.0
  []

  [Pressure]
    [coolantPressure]
      boundary = 3
      factor = 1e6
      function = coolant_pressure_history
    []
  []
  [convective_flux_inner_surface]
    type = ConvectiveFluxFunction
    boundary = 3
    variable = temp
    coefficient = heat_transfer_coefficient_history
    T_infinity = coolant_temperature_history
  []
[]

[Materials]
  [thermal_base]
    type = HeatConductionMaterial
    block = '1'
    thermal_conductivity_temperature_function = k_func_base
    specific_heat_temperature_function = c_func_base
    temp = temp
  []

  [thermal_clad]
    type = HeatConductionMaterial
    block = '2'
    thermal_conductivity_temperature_function = k_func_clad
    specific_heat_temperature_function = c_func_clad
    temp = temp
  []

  [youngs_modulus_base]
    type = PiecewiseLinearInterpolationMaterial
    x = '294.26 366.48 422.04 477.59 533.15 588.71 644.26'
    y = '27.8e6 27.1e6 26.7e6 26.2e6 25.7e6 25.1e6 24.6e6'
    scale_factor = 6894.7573
    property = youngs_modulus_base
    variable = temp
    block = 1
  []
  [elastic_tensor_base]
    type = ComputeVariableIsotropicElasticityTensor
    args = temp
    youngs_modulus = youngs_modulus_base
    poissons_ratio = 0.3
    block = 1
  []
  [stress_base]
    type = ComputeLinearElasticStress
    block = 1
  []
  [thermal_strain_base]
    type = ComputeMeanThermalExpansionFunctionEigenstrain
    temperature = temp
    thermal_expansion_function = cte_func_base
    thermal_expansion_function_reference_temperature = 294.26111
    stress_free_temperature = 526.4833
    eigenstrain_name = thermal_eigenstrain
    block = 1
  []

  [youngs_modulus_clad]
    type = PiecewiseLinearInterpolationMaterial
    x = '294.26 366.48 422.04 477.59 533.15 588.71 644.26'
    y = '28.3e6 27.5e6 27.0e6 26.4e6 25.9e6 25.3e6 24.8e6'
    scale_factor = 6894.7573
    property = youngs_modulus_clad
    variable = temp
    block = 2
  []
  [elastic_tensor_clad]
    type = ComputeVariableIsotropicElasticityTensor
    args = temp
    youngs_modulus = youngs_modulus_clad
    poissons_ratio = 0.31
    block = 2
  []
  [stress_clad]
    type = ComputeLinearElasticStress
    block = 2
  []
  [thermal_strain_clad]
    type = ComputeMeanThermalExpansionFunctionEigenstrain
    temperature = temp
    thermal_expansion_function = cte_func_clad
    thermal_expansion_function_reference_temperature = 294.26111
    stress_free_temperature = 526.4833
    eigenstrain_name = thermal_eigenstrain
    block = 2
  []

  [density_base]
    type = Density
    block = '1'
    density = 7750.4
  []

  [density_clad]
    type = Density
    block = '2'
    density = 8027.2
  []

  [axial_stress_clad]
    type = RankTwoCylindricalComponent
    block = 2
    rank_two_tensor = stress
    property_name = axial_stress_clad
    cylindrical_component = AxialStress
    cylindrical_axis_point1 = '0. 0. 0.'
    cylindrical_axis_point2 = '0. 0. 1.'
  []
  [hoop_stress_clad]
    type = RankTwoCylindricalComponent
    block = 2
    rank_two_tensor = stress
    cylindrical_component = HoopStress
    property_name = hoop_stress_clad
    cylindrical_axis_point1 = '0. 0. 0.'
    cylindrical_axis_point2 = '0. 0. 1.'
  []
  [axial_stress_base]
    type = RankTwoCylindricalComponent
    block = 1
    rank_two_tensor = stress
    cylindrical_component = AxialStress
    property_name = axial_stress_base
    cylindrical_axis_point1 = '0. 0. 0.'
    cylindrical_axis_point2 = '0. 0. 1.'
  []
  [hoop_stress_base]
    type = RankTwoCylindricalComponent
    block = 1
    rank_two_tensor = stress
    cylindrical_component = HoopStress
    property_name = hoop_stress_base
    cylindrical_axis_point1 = '0. 0. 0.'
    cylindrical_axis_point2 = '0. 0. 1.'
  []
[]

[Preconditioning]
  [SMP]
    type = SMP
    full = true
  []
[]

[Dampers]
  [limit_temp]
    type = MaxIncrement
    max_increment = 50.0
    variable = temp
  []
[]

[Executioner]
  automatic_scaling = true
  solve_type = 'PJFNK'
  type = Transient
  petsc_options = '-snes_ksp_ew'
  petsc_options_iname = '-ksp_gmres_restart -pc_type -pc_hypre_type -pc_hypre_boomeramg_max_iter -pc_hypre_boomeramg_strong_threshold'
  petsc_options_value = ' 201                hypre    boomeramg      4                           0.6'

  l_max_its = 25
  nl_max_its = 50
  nl_rel_tol = 1e-8
  nl_abs_tol = 1e-11

  start_time = 0.0
  dt = 1
  end_time = 2000

  [Predictor]
    type = SimplePredictor
    scale = 1.0
    skip_times_old = '1'
  []

  dtmax = 60
  dtmin = 1

  [TimeStepper]
    type = FunctionDT
    function = time_steps
  []
[]

[LineSamplers]
  total_thickness = 0.219202
  clad_thickness = 0.004064
  inner_radius = 2.1971
  base_block = 1
  clad_block = 2
  coord_system = 3D_CARTESIAN
  axis_of_rotation = z
  line_sampler_type = LineValueSampler
  temperature = 'temp'
  axial_stress_base = axial_stress_base
  hoop_stress_base = hoop_stress_base
  axial_stress_clad = axial_stress_clad
  hoop_stress_clad = hoop_stress_clad
  base_order = 4
  axial_start = -0.2
  axial_end = 4.2
  axial_num_points = 16
  azimuthal_start = 0
  azimuthal_end = 90
  azimuthal_num_points = 12
  azimuth0 = '1 0 0'
  base_thickness_offset_fraction = 0.01
  clad_thickness_offset_fraction = 0.01
[]

[Outputs]
  wall_time_checkpoint = false
  exodus = true
  perf_graph = true
  csv = true
[]
