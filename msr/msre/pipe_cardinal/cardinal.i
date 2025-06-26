[Mesh]
  type = FileMesh
  file = solid_hex8.exo
[]

[GlobalParams]
  displacements = 'disp_x disp_y disp_z'
[]

[Variables]
[]

[Physics]
  [SolidMechanics]
    [QuasiStatic]
      [all]
        strain = SMALL
        incremental = true
        add_variables = true
        eigenstrain_names = eigenstrain
        generate_output = 'strain_xx strain_yy strain_zz stress_xx stress_yy stress_zz'
      []
    []
  []
[]

[Kernels]
[]

[BCs]
  [no_x]
    type = DirichletBC
    variable = disp_x
    boundary = '3'
    value = 0.0
  []
  [no_y]
    type = DirichletBC
    variable = disp_y
    boundary = '3'
    value = 0.0
  []
  [no_z]
    type = DirichletBC
    variable = disp_z
    boundary = '3'
    value = 0.0
  []
[]

[Executioner]
  type = Transient
  num_steps = 20
  dt = 0.001
  nl_abs_tol = 1e-8
[]

[MultiApps]
  [nek]
    type = TransientMultiApp
    app_type = CardinalApp
    input_files = 'nek.i'
    sub_cycling = true
    execute_on = timestep_end
  []
[]

[Transfers]
  [nek_bulk_temp_to_moose]
    type = MultiAppGeneralFieldNearestLocationTransfer
    source_variable = temp
    variable = temperature
    from_multi_app = nek

    # Reduces transfers efficiency for now, can be removed once transferred fields are checked
    bbox_factor = 10
  []
[]

[AuxVariables]
  [temperature]
    initial_condition = 900.0
  []
[]

[AuxKernels]
[]

[Materials]
  [elasticity_tensor]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 1.71e11
    poissons_ratio = 0.31
  []
  [small_stress]
    type = ComputeFiniteStrainElasticStress
  []
  [thermal_expansion_strain]
    type = ComputeThermalExpansionEigenstrain
    stress_free_temperature = 900
    thermal_expansion_coeff = 1.38e-5
    temperature = temperature
    eigenstrain_name = eigenstrain
  []
[]

[Postprocessors]
  [strain_xx]
    type = ElementAverageValue
    variable = strain_xx
  []
  [strain_yy]
    type = ElementAverageValue
    variable = strain_yy
  []
  [strain_zz]
    type = ElementAverageValue
    variable = strain_zz
  []
  [stress_xx]
    type = ElementAverageValue
    variable = stress_xx
  []
  [stress_yy]
    type = ElementAverageValue
    variable = stress_yy
  []
  [stress_zz]
    type = ElementAverageValue
    variable = stress_zz
  []
  [temperature]
    type = AverageNodalVariableValue
    variable = temperature
  []
[]

[Outputs]
  exodus = true
  csv = true
  checkpoint = true
  print_linear_residuals = false
  execute_on = 'final'
[]
