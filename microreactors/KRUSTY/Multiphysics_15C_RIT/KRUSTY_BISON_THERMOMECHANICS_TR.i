################################################################################
## NEAMS Micro-Reactor Application Driver                                     ##
## KRUSTY Multiphysics 15-Cent Reactivity Insertion                           ##
## BISON thermomechanics main input file (Child App)                          ##
## Heat Conduction, Thermal Expansion, Thermal Stress                         ##
################################################################################

!include ../Multiphysics_SS/KRUSTY_BISON_PARAMS.i

restart_cp_file = '../Multiphysics_SS/KRUSTY_Griffin_SN23_NA23_CMFD_out_bison0_checkpoint_cp/LATEST'
reflector_disp = 1.48e-3 # Corresponding to 15 cents reactivity insertion

[GlobalParams]
  temperature = temp
  displacements = 'disp_x disp_y disp_z'
  stress_free_temperature = 298
[]

[Problem]
  type = ReferenceResidualProblem
  reference_vector = 'ref'
  extra_tag_vectors = 'ref'
  group_variables = 'disp_x disp_y disp_z'

  restart_file_base = ${restart_cp_file}
[]

[Mesh]
  file = ${restart_cp_file}
  parallel_type = distributed
[]

# No initial value needed as this is restarting
# For both Variables and AuxVariables
[Variables]
  # We have two temperature variables, one for the fuel and one for the non-fuel
  # This is to allow discontinuity on the fuel surface so that the insulation
  # can be better simulated using `InterfaceKernels`
  [temp]
    block = ${nonfuel_all}
  []
  [temp_f]
    block = ${fuel_all}
  []
[]

[AuxVariables]
  [power_density]
    block = ${fuel_all}
    family = L2_LAGRANGE
    order = FIRST
  []
  [Tfuel]
    order = CONSTANT
    family = MONOMIAL
  []
  [Tsteel]
    order = CONSTANT
    family = MONOMIAL
  []
  [external_power]
  []
  [hp_temp_aux]
  []
[]

[UserObjects]
  [temp_f_avg]
    type = LayeredAverage
    variable = temp_f
    direction = z
    num_layers = 100
    block = ${fuel_all}
  []
  [temp_s_avg]
    type = LayeredAverage
    variable = temp
    direction = z
    num_layers = 100
    block = '${ss_all} 998'
  []
[]

[AuxKernels]
  [assign_tfuel_f]
    type = NormalizationAux
    variable = Tfuel
    source_variable = temp_f
    execute_on = 'timestep_end'
    block = ${fuel_all}
  []
  [assign_tfuel_nf]
    type = SpatialUserObjectAux
    variable = Tfuel
    user_object = temp_f_avg
    execute_on = 'timestep_end'
    block = ${nonfuel_all}
  []
  [assign_tsteel_s]
    type = NormalizationAux
    variable = Tsteel
    source_variable = temp
    execute_on = 'timestep_end'
    block = '${ss_all} 998'
  []
  [assign_tsteel_ns]
    type = SpatialUserObjectAux
    variable = Tsteel
    user_object = temp_s_avg
    execute_on = 'timestep_end'
    block = ${non_ss_998_all}
  []
[]

# A small materials block for thin layers
[Materials]
  [thermal_cond_mli]
    type = GenericConstantMaterial
    prop_names = 'thermal_conductivity_mli'
    prop_values = '${hp_mli_cond}'
    boundary = 'fuel_top fuel_bottom fuel_side_1'
  []
  [thermal_cond_center]
    type = GenericConstantMaterial
    prop_names = 'thermal_conductivity_center'
    prop_values = '0.20'
    boundary = 'fuel_inside'
  []
  [thermal_cond_other]
    type = GenericConstantMaterial
    prop_names = 'thermal_conductivity_other'
    prop_values = '15.0'
    boundary = 'fuel_side_2'
  []
[]

[InterfaceKernels]
  [fuel_ref]
    type = ThinLayerHeatTransfer
    thermal_conductivity = thermal_conductivity_mli
    thickness = 0.005
    variable = temp_f
    neighbor_var = temp
    boundary = 'fuel_top fuel_bottom fuel_side_1'
  []
  [fuel_center]
    type = ThinLayerHeatTransfer
    thermal_conductivity = thermal_conductivity_center
    thickness = 0.001
    variable = temp_f
    neighbor_var = temp
    boundary = 'fuel_inside'
  []
  [fuel_other]
    type = ThinLayerHeatTransfer
    thermal_conductivity = thermal_conductivity_other
    thickness = 0.0001
    variable = temp_f
    neighbor_var = temp
    boundary = 'fuel_side_2'
  []
[]

[Kernels]
  [heat]
    type = HeatConduction
    variable = temp
    extra_vector_tags = 'ref'
    block = ${nonfuel_all}
  []
  [heat_f]
    type = HeatConduction
    variable = temp_f
    extra_vector_tags = 'ref'
    block = ${fuel_all}
  []
  [heat_ie]
    type = HeatConductionTimeDerivative
    variable = temp
    extra_vector_tags = 'ref'
    block = ${nonfuel_all}
  []
  [heat_ie_f]
    type = HeatConductionTimeDerivative
    variable = temp_f
    extra_vector_tags = 'ref'
    block = ${fuel_all}
  []
  [heatsource]
    type = CoupledForce
    variable = temp_f
    block = ${fuel_all}
    v = power_density
    extra_vector_tags = 'ref'
  []

  # These diffusion kernels evenly disperse the displacement across the void
  [diff_x]
    type = MatDiffusion
    block = '${air_all} ${hp_fuel_gap_all} ${hp_mli_all}'
    variable = disp_x
    diffusivity = 1e5
    extra_vector_tags = 'ref'
  []
  [diff_y]
    type = MatDiffusion
    block = '${air_all} ${hp_fuel_gap_all} ${hp_mli_all}'
    variable = disp_y
    diffusivity = 1e5
    extra_vector_tags = 'ref'
  []
  [diff_z]
    type = MatDiffusion
    block = '${air_all} ${hp_fuel_gap_all} ${hp_mli_all}'
    variable = disp_z
    diffusivity = 1e5
    extra_vector_tags = 'ref'
  []
[]

[Physics/SolidMechanics/QuasiStatic]
  [mech_parts_fuel]
    block = '${fuel_all}'
    temperature = temp_f
    strain = SMALL # Small strain should work, but finite may have better performance
    add_variables = true
    eigenstrain_names = 'thermal_strain'
    generate_output = 'vonmises_stress strain_xx strain_yy strain_zz stress_xx stress_yy stress_zz hydrostatic_stress'
    extra_vector_tags = 'ref'
    use_automatic_differentiation = false
  []
  [mech_parts_non_fuel]
    block = '${nonfuel_mech}'
    strain = SMALL # Small strain should work, but finite may have better performance
    add_variables = true
    eigenstrain_names = 'thermal_strain'
    generate_output = 'vonmises_stress strain_xx strain_yy strain_zz stress_xx stress_yy stress_zz hydrostatic_stress'
    extra_vector_tags = 'ref'
    use_automatic_differentiation = false
  []
[]

[Materials]
  [stress]
    type = ComputeLinearElasticStress
    block = '${no_void} ${hp_all}'
  []

  [UMoDens]
    type = Density
    block = ${fuel_all}
    density = ${umo_dens}
  []
  [UMoMech]
    type = ComputeIsotropicElasticityTensor
    block = ${fuel_all}
    youngs_modulus = ${umo_ym}
    poissons_ratio = ${umo_pr}
  []
  [UMoExp]
    type = U10MoThermalExpansionEigenstrain
    block = ${fuel_all}
    temperature = temp_f
    eigenstrain_name = thermal_strain
    stress_free_temperature = 298
    model_option = Rest
  []
  [fission_density]
    type = GenericConstantMaterial
    prop_names = 'fission_density'
    prop_values = 0.0
    block = ${fuel_all}
  []
  [UMo_thermal]
    type = HeatConductionMaterial
    block = ${fuel_all}
    temp = temp_f
    specific_heat_temperature_function = umo_heat_cap
    thermal_conductivity_temperature_function = umo_tc
  []
  [BeODens]
    type = Density
    block = ${beo_all}
    density = ${beo_dens}
  []
  [BeOMech]
    type = BeOElasticityTensor
    temperature = temp
    block = ${beo_all}
    porosity = 0.01
  []

  [BeOExp]
    type = BeOThermalExpansionEigenstrain
    eigenstrain_name = thermal_strain
    stress_free_temperature = 298
    temperature = temp
    block = ${beo_all}
  []
  [BeO_thermal]
    type = BeOThermal
    block = ${beo_all}
    fluence_conversion_factor = 1
    temperature = temp
    outputs = all
    porosity = 0
    fast_neutron_fluence = 0
  []
  [AirDens]
    type = Density
    block = ${air_all}
    density = ${air_dens}
  []
  [AirTherm]
    type = HeatConductionMaterial
    block = ${air_all}
    thermal_conductivity = ${air_cond}
    specific_heat = ${air_sph}
  []

  # HP Fuel Coupling Material
  # Note HP was replaced with steel rods
  [HPFDens]
    type = Density
    block = ${hp_fuel_gap_names}
    density = ${hp_fuel_couple_dens}
  []
  [HPFTherm]
    type = HeatConductionMaterial
    block = ${hp_fuel_gap_names}
    thermal_conductivity = ${hp_fuel_couple_cond}
    specific_heat = ${hp_fuel_couple_sph}
  []

  [HPMLIDens]
    type = Density
    block = ${hp_mli_names}
    density = ${hp_mli_dens}
  []
  [HPMLIherm]
    type = HeatConductionMaterial
    block = ${hp_mli_names}
    thermal_conductivity = ${hp_mli_cond}
    specific_heat = ${hp_mli_sph}
  []

  #Stainless Steel; Assuming all the stuctures are SS316
  [SS316Dens]
    type = Density
    block = '${ss_all} ${hp_all}'
    density = ${ss_dens}
  []
  [SS316Mech]
    type = SS316ElasticityTensor
    block = '${ss_all} ${hp_all}'
    temperature = temp
  []
  [SS316Exp]
    type = SS316ThermalExpansionEigenstrain
    block = '${ss_all} ${hp_all}'
    temperature = temp
    eigenstrain_name = thermal_strain
    stress_free_temperature = 298
  []

  [SS316Therm]
    type = SS316Thermal
    block = '${ss_all} ${hp_all}'
    temperature = temp
  []

  #Aluminium
  [Al6061Dens]
    type = Density
    block = ${Al_all}
    density = ${al_dens}
  []
  [Al6061Mech]
    type = Al6061ElasticityTensor
    block = ${Al_all}
    temperature = temp
    youngs_modulus_model = Kaufman
  []
  [Al6061Exp]
    type = Al6061ThermalExpansionEigenstrain
    block = ${Al_all}
    temperature = temp
    eigenstrain_name = thermal_strain
    stress_free_temperature = 298
  []

  [Al6061Therm]
    type = SS316Thermal
    block = ${Al_all}
    temperature = temp
  []

  #Natural Boron Carbide (Not enriched boron)
  [B4CDens]
    type = Density
    block = ${b4c_all}
    density = ${b4c_dens}
  []
  [B4CMech]
    type = ComputeIsotropicElasticityTensor
    block = ${b4c_all}
    youngs_modulus = ${b4c_ym}
    poissons_ratio = ${b4c_pr}
  []
  [B4CExp]
    type = ComputeThermalExpansionEigenstrain
    block = ${b4c_all}
    thermal_expansion_coeff = ${b4c_exp}
    eigenstrain_name = thermal_strain
  []
  [B4CTherm]
    type = HeatConductionMaterial
    block = ${b4c_all}
    thermal_conductivity = ${b4c_cond}
    specific_heat = ${b4c_sph}
  []

  #Pure Beryllium
  [BeDens]
    type = Density
    block = ${Be_all}
    density = ${Be_dens}
  []
  [BeMech]
    type = ComputeIsotropicElasticityTensor
    block = ${Be_all}
    youngs_modulus = ${Be_ym}
    poissons_ratio = ${Be_pr}
  []
  [BeExp]
    type = ComputeThermalExpansionEigenstrain
    block = ${Be_all}
    thermal_expansion_coeff = ${Be_exp}
    eigenstrain_name = thermal_strain
  []
  [BeTherm]
    type = HeatConductionMaterial
    block = ${Be_all}
    thermal_conductivity = ${Be_cond}
    specific_heat = ${Be_sph}
  []

[]

[Functions]
  [umo_heat_cap]
    # https://doi.org/10.1016/S0022-3697(00)00219-5.
    type = ParsedFunction
    expression = 'M:=210.4243/1000;
                  dHdT:=20.8+1.174e-2*t+0.4715e5/t/t;
                  dHdT/M'
  []
  [umo_tc]
    type = ParsedFunction
    expression = '0.606+0.0351*t'
  []
  # The function that controls the displacement of the reflector
  # Used to control the reactivity insertion
  [ref_mov]
    type = ParsedFunction
    symbol_names = 't0 d0'
    symbol_values = '0.5 ${reflector_disp}'
    # Linear insertion within the first 0.5 seconds
    expression = 'if(t<0,0.0,if(t<t0,d0/t0*t,d0))'
  []
[]

[BCs]
  [OuterWall]
    type = ConvectiveHeatFluxBC
    variable = temp
    boundary = '9531 Core_bottom Core_outer_boundary' #outer wall sideset
    heat_transfer_coefficient = 5 # free convection in dry air W/m2/K
    T_infinity = 300 # room temperature
  []
  [BottomFixZ]
    type = DirichletBC
    variable = disp_z
    boundary = 'Core_bottom'
    value = 0.0
  []
  # The BC that controls the displacement of the reflector
  [BottomSSFixZ]
    type = FunctionDirichletBC
    variable = disp_z
    boundary = 'ss_bot'
    function = ref_mov
  []
  [TopFixZ]
    type = DirichletBC
    variable = disp_z
    boundary = 'Core_top'
    value = 0.0
  []

  [MirrorOneFixX]
    type = DirichletBC
    variable = disp_y
    boundary = 'Mirror_Y_surf'
    value = 0.0
  []
  [MirrorOneFixY]
    type = DirichletBC
    variable = disp_x
    boundary = 'Mirror_X_surf'
    value = 0.0
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

  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package -ksp_gmres_restart'
  petsc_options_value = 'lu       superlu_dist                  51'
  line_search = 'none'

  nl_abs_tol = 1e-7
  nl_rel_tol = 1e-7
  l_tol = 1e-4
  l_max_its = 25
  automatic_scaling = true
  compute_scaling_once = false

  start_time = 0
  end_time = 7200
  # Let main app to control the time step
  dt = 10
[]

[Postprocessors]
  [_dt]
    type = TimestepSize
  []
  [total_power]
    type = ElementIntegralVariablePostprocessor
    block = ${fuel_all}
    variable = power_density
    execute_on = 'initial TIMESTEP_END transfer'
  []
  [avg_fuel_temp]
    type = ElementAverageValue
    block = ${fuel_all}
    variable = temp_f
    execute_on = 'initial TIMESTEP_END'
  []
  [max_fuel_temp]
    type = ElementExtremeValue
    block = ${fuel_all}
    variable = temp_f
    value_type = max
    execute_on = 'initial TIMESTEP_END'
  []
  [min_fuel_temp]
    type = ElementExtremeValue
    block = ${fuel_all}
    variable = temp_f
    value_type = min
    execute_on = 'initial TIMESTEP_END'
  []
  [avg_nonfuel_temp]
    type = ElementAverageValue
    block = ${nonfuel_all}
    variable = temp
    execute_on = 'initial TIMESTEP_END'
  []
  [max_nonfuel_temp]
    type = ElementExtremeValue
    block = ${nonfuel_all}
    variable = temp
    value_type = max
    execute_on = 'initial TIMESTEP_END'
  []
  [min_nonfuel_temp]
    type = ElementExtremeValue
    block = ${nonfuel_all}
    variable = temp
    value_type = min
    execute_on = 'initial TIMESTEP_END'
  []
  [avg_fuel_cond]
    type = ElementAverageValue
    block = ${fuel_all}
    variable = thermal_conductivity
    execute_on = 'initial TIMESTEP_END'
  []
  [fuel_volume]
    type = VolumePostprocessor
    block = ${fuel_all}
    use_displaced_mesh = true
    execute_on = 'initial TIMESTEP_END'
  []
  [power_density_avg_everywhere]
    type = ElementAverageValue
    variable = power_density
    block = ${fuel_all}
  []
  [power_density_avg]
    type = ElementAverageValue
    variable = power_density
    block = ${fuel_all}
  []
  [power_density_max]
    type = ElementExtremeValue
    variable = power_density
    block = ${fuel_all}
  []
  [power_density_min]
    type = ElementExtremeValue
    variable = power_density
    block = ${fuel_all}
    value_type = min
  []
[]

[Outputs]
  csv = true
  [exodus]
    type = Exodus
    enable = false
  []
  [checkpoint]
    type = Checkpoint
    enable = false
  []
  perf_graph = true
  color = true
[]
