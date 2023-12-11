################################################################################
## NEAMS Micro-Reactor Application Driver                                     ##
## Heat Pipe Microreactor TRISO Failure Model                                 ##
## Assembly Model for Calculating TRISO Operating Conditions                  ##
## BISON Grandchild Application for Tensor Mechanics                          ##
################################################################################

fuel_blocks = 'fuel_01 fuel_02 fuel_03 fuel_04 fuel_05 fuel_06 fuel_07 fuel_08
               fuel_09 fuel_10 fuel_11 fuel_12 fuel_13 fuel_14 fuel_15 fuel_16
               fuel_17 fuel_18 fuel_19 fuel_20 fuel_21 fuel_22 fuel_23 fuel_24
               fuel_25 fuel_26 fuel_27 fuel_28 fuel_29 fuel_30 fuel_31 fuel_32'

mono_blocks = 'monolith_01 monolith_02 monolith_03 monolith_04 monolith_05 monolith_06 monolith_07 monolith_08
               monolith_09 monolith_10 monolith_11 monolith_12 monolith_13 monolith_14 monolith_15 monolith_16
               monolith_17 monolith_18 monolith_19 monolith_20 monolith_21 monolith_22 monolith_23 monolith_24
               monolith_25 monolith_26 monolith_27 monolith_28 monolith_29 monolith_30 monolith_31 monolith_32'
moderator_blocks = 'mod_01 mod_02 mod_03 mod_04 mod_05 mod_06 mod_07 mod_08
                    mod_09 mod_10 mod_11 mod_12 mod_13 mod_14 mod_15 mod_16
                    mod_17 mod_18 mod_19 mod_20 mod_21 mod_22 mod_23 mod_24
                    mod_25 mod_26 mod_27 mod_28 mod_29 mod_30 mod_31 mod_32'
mod_env_blocks = 'mod_envelope_01 mod_envelope_02 mod_envelope_03 mod_envelope_04 mod_envelope_05 mod_envelope_06 mod_envelope_07 mod_envelope_08
                  mod_envelope_09 mod_envelope_10 mod_envelope_11 mod_envelope_12 mod_envelope_13 mod_envelope_14 mod_envelope_15 mod_envelope_16
                  mod_envelope_17 mod_envelope_18 mod_envelope_19 mod_envelope_20 mod_envelope_21 mod_envelope_22 mod_envelope_23 mod_envelope_24
                  mod_envelope_25 mod_envelope_26 mod_envelope_27 mod_envelope_28 mod_envelope_29 mod_envelope_30 mod_envelope_31 mod_envelope_32'

[GlobalParams]
  displacements = 'disp_x disp_y disp_z'
[]

[Mesh]
  file = ../mesh/3D_unit_cell_FY21_simple_YAN_40sections_5cm_axial_dist_bison.e
[]

[Modules/TensorMechanics/Master]
  [fuel]
    block = ${fuel_blocks}
    add_variables = true
    strain = FINITE
    eigenstrain_names = 'fuel_thermal_eigenstrain'
    generate_output = 'vonmises_stress stress_xx stress_yy stress_zz hydrostatic_stress strain_xx strain_yy strain_zz'
    save_in = 'saved_x saved_y saved_z'
    use_finite_deform_jacobian = true
  []
  [moderator]
    block = ${moderator_blocks}
    add_variables = true
    strain = FINITE
    eigenstrain_names = 'mod_thermal_eigenstrain'
    generate_output = 'vonmises_stress stress_xx stress_yy stress_zz hydrostatic_stress strain_xx strain_yy strain_zz'
    save_in = 'saved_x saved_y saved_z'
    use_finite_deform_jacobian = true
  []
  [monolith]
    block = ${mono_blocks}
    add_variables = true
    strain = FINITE
    eigenstrain_names = 'monolith_thermal_eigenstrain'
    generate_output = 'vonmises_stress stress_xx stress_yy stress_zz hydrostatic_stress strain_xx strain_yy strain_zz'
    save_in = 'saved_x saved_y saved_z'
    use_finite_deform_jacobian = true
  []
  [SS_envelop]
    block = ${mod_env_blocks}
    add_variables = true
    strain = FINITE
    eigenstrain_names = 'SS_envelop_thermal_eigenstrain'
    generate_output = 'vonmises_stress stress_xx stress_yy stress_zz hydrostatic_stress strain_xx strain_yy strain_zz'
    save_in = 'saved_x saved_y saved_z'
    use_finite_deform_jacobian = true
  []
  [axial_reflector]
    block = 'bottom_reflector_1 bottom_reflector_2 bottom_reflector_3 bottom_reflector_4 top_reflector_1 top_reflector_2 top_reflector_3 top_reflector_4'
    add_variables = true
    strain = FINITE
    eigenstrain_names = 'axial_reflector_thermal_eigenstrain'
    generate_output = 'vonmises_stress stress_xx stress_yy stress_zz hydrostatic_stress strain_xx strain_yy strain_zz'
    save_in = 'saved_x saved_y saved_z'
    use_finite_deform_jacobian = true
  []
[]

[AuxVariables]
  [temp]
    # initial_condition=800
  []
  [saved_x]
  []
  [saved_y]
  []
  [saved_z]
  []
  [saved_temp]
  []
[]

[BCs]
  [no_x]
    type = DirichletBC
    variable = disp_x
    boundary = bottom
    value = 0.0
  []
  [no_y]
    type = DirichletBC
    variable = disp_y
    boundary = bottom
    value = 0.0
  []
  [no_z]
    type = DirichletBC
    variable = disp_z
    boundary = 'bottom'
    value = 0.0
  []
[]

[Materials]
  [thermal_strains_fuel]
    type = ComputeThermalExpansionEigenstrain
    block = ${fuel_blocks}
    temperature = temp
    thermal_expansion_coeff = 4e-6 # 1/K # typical value for graphite
    stress_free_temperature = 800 # K
    eigenstrain_name = fuel_thermal_eigenstrain
  []
  [thermal_strains_mod]
    type = ComputeThermalExpansionEigenstrain
    block = ${moderator_blocks}
    temperature = temp
    thermal_expansion_coeff = 8.5e-6 # 1/K
    stress_free_temperature = 800 # K
    eigenstrain_name = mod_thermal_eigenstrain
  []
  [thermal_strains_monolith]
    type = ComputeThermalExpansionEigenstrain
    block = ${mono_blocks}
    temperature = temp
    thermal_expansion_coeff = 4e-6 # 1/K
    stress_free_temperature = 800 # K
    eigenstrain_name = monolith_thermal_eigenstrain
  []
  [thermal_strains_axial_reflector]
    type = ComputeThermalExpansionEigenstrain
    block = 'top_reflector_1 top_reflector_2 top_reflector_3 top_reflector_4
             bottom_reflector_1 bottom_reflector_2 bottom_reflector_3 bottom_reflector_4'
    temperature = temp
    thermal_expansion_coeff = 11.6e-6 # 1/K
    stress_free_temperature = 800 # K
    eigenstrain_name = axial_reflector_thermal_eigenstrain
  []
  [thermal_strains_SS_envelop]
    type = SS316ThermalExpansionEigenstrain
    stress_free_temperature = 800 # K
    temperature = temp
    eigenstrain_name = SS_envelop_thermal_eigenstrain
    block = ${mod_env_blocks}
    outputs = all
  []
  [elasticity_tensor_fuel]
    type = ComputeIsotropicElasticityTensor
    block = ${fuel_blocks}
    # Recommended values of the youngs_modulus (Verfondern2013) and
    # poissons_ratio (Burchell2014) for graphite matrix
    youngs_modulus = 10.0e9
    poissons_ratio = 0.25
  []
  [elasticity_tensor_mod]
    type = ComputeIsotropicElasticityTensor
    block = ${moderator_blocks}
    youngs_modulus = 2e10 # in Pa (BISON in SI units!)
    poissons_ratio = 0.3 # unitless
  []
  [elasticity_tensor_monolith]
    type = ComputeIsotropicElasticityTensor
    block = ${mono_blocks}
    # Recommended values of the youngs_modulus (Verfondern2013) and
    # poissons_ratio (Burchell2014) for graphite matrix
    youngs_modulus = 10.0e9
    poissons_ratio = 0.25
  []
  [elasticity_tensor_axial_reflector]
    type = ComputeIsotropicElasticityTensor
    block = 'top_reflector_1 top_reflector_2 top_reflector_3 top_reflector_4
             bottom_reflector_1 bottom_reflector_2 bottom_reflector_3 bottom_reflector_4'
    youngs_modulus = 280e9
    poissons_ratio = 0.07
  []
  [elasticity_tensor_SS_envelop]
    type = SS316ElasticityTensor
    temperature = temp
    block = ${mod_env_blocks}
  []
  [stress]
    type = ComputeFiniteStrainElasticStress
    block = 'monolith_01 monolith_02 monolith_03 monolith_04 monolith_05 monolith_06 monolith_07 monolith_08
                  monolith_09 monolith_10 monolith_11 monolith_12 monolith_13 monolith_14 monolith_15 monolith_16
                  monolith_17 monolith_18 monolith_19 monolith_20 monolith_21 monolith_22 monolith_23 monolith_24
                  monolith_25 monolith_26 monolith_27 monolith_28 monolith_29 monolith_30 monolith_31 monolith_32
                  fuel_01 fuel_02 fuel_03 fuel_04 fuel_05 fuel_06 fuel_07 fuel_08
                  fuel_09 fuel_10 fuel_11 fuel_12 fuel_13 fuel_14 fuel_15 fuel_16
                  fuel_17 fuel_18 fuel_19 fuel_20 fuel_21 fuel_22 fuel_23 fuel_24
                  fuel_25 fuel_26 fuel_27 fuel_28 fuel_29 fuel_30 fuel_31 fuel_32
                  mod_envelope_01 mod_envelope_02 mod_envelope_03 mod_envelope_04 mod_envelope_05 mod_envelope_06 mod_envelope_07 mod_envelope_08
                  mod_envelope_09 mod_envelope_10 mod_envelope_11 mod_envelope_12 mod_envelope_13 mod_envelope_14 mod_envelope_15 mod_envelope_16
                  mod_envelope_17 mod_envelope_18 mod_envelope_19 mod_envelope_20 mod_envelope_21 mod_envelope_22 mod_envelope_23 mod_envelope_24
                  mod_envelope_25 mod_envelope_26 mod_envelope_27 mod_envelope_28 mod_envelope_29 mod_envelope_30 mod_envelope_31 mod_envelope_32
                  top_reflector_1 top_reflector_2 top_reflector_3 top_reflector_4
                  bottom_reflector_1 bottom_reflector_2 bottom_reflector_3 bottom_reflector_4 mod_01 mod_02 mod_03 mod_04 mod_05 mod_06 mod_07 mod_08
                    mod_09 mod_10 mod_11 mod_12 mod_13 mod_14 mod_15 mod_16
                    mod_17 mod_18 mod_19 mod_20 mod_21 mod_22 mod_23 mod_24
                    mod_25 mod_26 mod_27 mod_28 mod_29 mod_30 mod_31 mod_32'
  []
[]

[Preconditioning]
  [SMP]
    type = SMP
    full = true
  []
[]

[Executioner]
  type = Transient

  petsc_options = '-snes_ksp_ew'
  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package -ksp_gmres_restart'
  petsc_options_value = 'lu       superlu_dist                  51'
  line_search = 'none'

  nl_abs_tol = 1e-5
  nl_rel_tol = 1e-5

  nl_max_its = 20
  start_time = 0
  end_time = '${fparse 10 * 365.25 * 24 * 3600}'
  dtmin = 1e-6
  dt = 1e7
[]

[Postprocessors]
  [axial_pressure_1]
    type = ElementAverageValue
    variable = 'hydrostatic_stress'
    block = fuel_01
    execute_on = 'initial timestep_end'
  []
  [axial_pressure_2]
    type = ElementAverageValue
    variable = 'hydrostatic_stress'
    block = fuel_02
    execute_on = 'initial timestep_end'
  []
  [axial_pressure_3]
    type = ElementAverageValue
    variable = 'hydrostatic_stress'
    block = fuel_03
    execute_on = 'initial timestep_end'
  []
  [axial_pressure_4]
    type = ElementAverageValue
    variable = 'hydrostatic_stress'
    block = fuel_04
    execute_on = 'initial timestep_end'
  []
  [axial_pressure_5]
    type = ElementAverageValue
    variable = 'hydrostatic_stress'
    block = fuel_05
    execute_on = 'initial timestep_end'
  []
  [axial_pressure_6]
    type = ElementAverageValue
    variable = 'hydrostatic_stress'
    block = fuel_06
    execute_on = 'initial timestep_end'
  []
  [axial_pressure_7]
    type = ElementAverageValue
    variable = 'hydrostatic_stress'
    block = fuel_07
    execute_on = 'initial timestep_end'
  []
  [axial_pressure_8]
    type = ElementAverageValue
    variable = 'hydrostatic_stress'
    block = fuel_08
    execute_on = 'initial timestep_end'
  []
  [axial_pressure_9]
    type = ElementAverageValue
    variable = 'hydrostatic_stress'
    block = fuel_09
    execute_on = 'initial timestep_end'
  []
  [axial_pressure_10]
    type = ElementAverageValue
    variable = 'hydrostatic_stress'
    block = fuel_10
    execute_on = 'initial timestep_end'
  []
  [axial_pressure_11]
    type = ElementAverageValue
    variable = 'hydrostatic_stress'
    block = fuel_11
    execute_on = 'initial timestep_end'
  []
  [axial_pressure_12]
    type = ElementAverageValue
    variable = 'hydrostatic_stress'
    block = fuel_12
    execute_on = 'initial timestep_end'
  []
  [axial_pressure_13]
    type = ElementAverageValue
    variable = 'hydrostatic_stress'
    block = fuel_13
    execute_on = 'initial timestep_end'
  []
  [axial_pressure_14]
    type = ElementAverageValue
    variable = 'hydrostatic_stress'
    block = fuel_14
    execute_on = 'initial timestep_end'
  []
  [axial_pressure_15]
    type = ElementAverageValue
    variable = 'hydrostatic_stress'
    block = fuel_15
    execute_on = 'initial timestep_end'
  []
  [axial_pressure_16]
    type = ElementAverageValue
    variable = 'hydrostatic_stress'
    block = fuel_16
    execute_on = 'initial timestep_end'
  []
  [axial_pressure_17]
    type = ElementAverageValue
    variable = 'hydrostatic_stress'
    block = fuel_17
    execute_on = 'initial timestep_end'
  []
  [axial_pressure_18]
    type = ElementAverageValue
    variable = 'hydrostatic_stress'
    block = fuel_18
    execute_on = 'initial timestep_end'
  []
  [axial_pressure_19]
    type = ElementAverageValue
    variable = 'hydrostatic_stress'
    block = fuel_19
    execute_on = 'initial timestep_end'
  []
  [axial_pressure_20]
    type = ElementAverageValue
    variable = 'hydrostatic_stress'
    block = fuel_20
    execute_on = 'initial timestep_end'
  []
  [axial_pressure_21]
    type = ElementAverageValue
    variable = 'hydrostatic_stress'
    block = fuel_21
    execute_on = 'initial timestep_end'
  []
  [axial_pressure_22]
    type = ElementAverageValue
    variable = 'hydrostatic_stress'
    block = fuel_22
    execute_on = 'initial timestep_end'
  []
  [axial_pressure_23]
    type = ElementAverageValue
    variable = 'hydrostatic_stress'
    block = fuel_23
    execute_on = 'initial timestep_end'
  []
  [axial_pressure_24]
    type = ElementAverageValue
    variable = 'hydrostatic_stress'
    block = fuel_24
    execute_on = 'initial timestep_end'
  []
  [axial_pressure_25]
    type = ElementAverageValue
    variable = 'hydrostatic_stress'
    block = fuel_25
    execute_on = 'initial timestep_end'
  []
  [axial_pressure_26]
    type = ElementAverageValue
    variable = 'hydrostatic_stress'
    block = fuel_26
    execute_on = 'initial timestep_end'
  []
  [axial_pressure_27]
    type = ElementAverageValue
    variable = 'hydrostatic_stress'
    block = fuel_27
    execute_on = 'initial timestep_end'
  []
  [axial_pressure_28]
    type = ElementAverageValue
    variable = 'hydrostatic_stress'
    block = fuel_28
    execute_on = 'initial timestep_end'
  []
  [axial_pressure_29]
    type = ElementAverageValue
    variable = 'hydrostatic_stress'
    block = fuel_29
    execute_on = 'initial timestep_end'
  []
  [axial_pressure_30]
    type = ElementAverageValue
    variable = 'hydrostatic_stress'
    block = fuel_30
    execute_on = 'initial timestep_end'
  []
  [axial_pressure_31]
    type = ElementAverageValue
    variable = 'hydrostatic_stress'
    block = fuel_31
    execute_on = 'initial timestep_end'
  []
  [axial_pressure_32]
    type = ElementAverageValue
    variable = 'hydrostatic_stress'
    block = fuel_32
    execute_on = 'initial timestep_end'
  []
[]

[Outputs]
  perf_graph = true
  color = true
  csv = false
[]
