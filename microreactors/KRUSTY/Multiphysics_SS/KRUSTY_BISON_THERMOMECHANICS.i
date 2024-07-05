# References
# poston: "Krusty Reactor Design"
# iaea: "Material Properties of Unirradiated Uranium\u2013 Molybdenum (U\u2013Mo) Fuel for Research Reactors"
# iaea2: "Thermophysical Properties of Materials For Nuclear Engineering: A Tutorial and Collection of Data"
# rest: "U-Mo Fuels Handbook"

reflector_disp = 0.0

# blocks_all = '1 2	3	4	5	6	8	9	11	12	13	14	15	16	17	18	19	20	21	22	23	24	64 71	72	73	1212	2081	2082	2091	2092	2101	2102	2111	2112	2121	2122	2131	2132	2141	2142	3081	3082	3091	3092	3101	3102	3111	3112	3121	3122	3131	3132	3141	3142	4081	4082	4091	4092	4101	4102	4111	4112	4121	4122	4131	4132	4141	4142'
no_void = '2	3	4	5	6	8	9	11	12	13	14	15	16	17	18	19	20	21	22	23	24 71	72	73	1212	2081	2082	2091	2092	2101	2102	2111	2112	2121	2122	2131	2132	2141	2142	3081	3082	3091	3092	3101	3102	3111	3112	3121	3122	3131	3132	3141	3142	4081	4082	4091	4092	4101	4102	4111	4112	4121	4122	4131	4132	4141	4142'
fuel_all = '2081	2082	2091	2092	2101	2102	2111	2112	2121	2122	2131	2132	2141	2142	3081	3082	3091	3092	3101	3102	3111	3112	3121	3122	3131	3132	3141	3142	4081	4082	4091	4092	4101	4102	4111	4112	4121	4122	4131	4132	4141	4142'
## fuel_names = 'fuel_01 fuel_02 fuel_03 fuel_04 fuel_05 fuel_06 fuel_07 fuel_08 fuel_09 fuel_10 
##               fuel_11 fuel_12 fuel_13 fuel_14 fuel_15 fuel_16 fuel_17 fuel_18 fuel_19 fuel_20 
##               fuel_21 fuel_22 fuel_23 fuel_24 fuel_25 fuel_26 fuel_27 fuel_28 fuel_29 fuel_30 
##               fuel_31 fuel_32 fuel_33 fuel_34 fuel_35 fuel_36 fuel_37 fuel_38 fuel_39 fuel_40 
##               fuel_41 fuel_42'

Be_all = '14'
## Be_names = 'Be_01'
Al_all = '11 13 16' # currenly using Al 6061 properites
## Al_names = 'Al_01 Al_02 Al_03'
hp_all = '10'
## hp_names = 'hp_01'
beo_all = '12 1212 17 9'
## beo_names = 'beo_01 beo_02 beo_03 beo_04'
# ss_all includes the ss304 ss316 and cast iron
ss_all = '2 3 4 6 71 72 73 8 15 18 19 20 22 23 24' # remove 14; it is Be
## ss_names = 'ss_01 ss_02 ss_03 ss_04 ss_05 ss_06 ss_07 ss_08 ss_09 ss_10 ss_11 ss_12 ss_13 ss_14 ss_15'
b4c_all = '5 21'
## b4c_names = 'b4c_01 b4c_02'
air_all = '1'
## air_names = 'air_01'
hp_fuel_gap_all = '64'
hp_fuel_gap_names = 'hp_fuel_gap'
hp_mli_all = '999 998'
hp_mli_names = 'hp_mli hp_mli_2'

# nonhpgap_all = '${Be_all} ${Al_all} ${hp_all} ${beo_all} ${ss_all} ${b4c_all} ${air_all} ${fuel_all}'
# non_hp_all = '${Be_all} ${Al_all} ${beo_all} ${ss_all} ${b4c_all} ${air_all} ${hp_fuel_gap_all} 999'
nonfuel_all = '${Be_all} ${Al_all} ${hp_all} ${beo_all} ${ss_all} ${b4c_all} ${air_all} ${hp_fuel_gap_all} ${hp_mli_all}'
nonfuel_mech = '${Be_all} ${Al_all} ${hp_all} ${beo_all} ${ss_all} ${b4c_all}'
non_ss_998_all = '${fuel_all} ${Be_all} ${Al_all} ${hp_all} ${beo_all} ${b4c_all} ${air_all} ${hp_fuel_gap_all} 999'

# hp_dens = 2600.0 # dummy
# hp_ym = 0.1e10 # dummy
# hp_pr = 0.3 # dummy
# hp_exp = 1e-6 # dummy
# hp_cond = 275000.0 # dummy
# hp_htc = 1e8 # dummy
# hp_sph = 2300.0 # dummy
umo_dens = 17340 # from poston
# umo_x_mo     = 0.0765 # from poston : The KRUSTY fuel is highly enriched uranium (HEU) U-8Mo; note that the actual weight fraction of Mo was 7.65%,
# e_u          = 0.931 # from poston
# A_umo        = ${fparse (1 - umo_x_mo) * (0.235 * e_u + 0.238 * (1.0 - e_u)) + umo_x_mo * 0.09595}
umo_ym = 54.3e9 # from iaea
umo_pr = 0.35 # INL/CON-11-22390
beo_dens = 2870.0 # from iaea2
# beo_ym = 3.45e11 # (331.7 - 400 GPa) Azo
# beo_pr = 0.26

ss_dens = 7950 #7670 # 316 : 7.95@300K/7.67@900K
al_dens = 2700 # RT
# ss_ym = 1.95e11 # ASM Matweb
# ss_pr = 0.29 # ASM Matweb
# ss_exp = 1.45e-5 # (14 - 15)e-6 /K
# ss_cond = 15.0 # (12 - 16) W/m-K - 0 - 200C.
# ss_sph = 500.0 # (490 - 530) Azo J/kg-K

# void_cond = 0.0015 # Void Conductivity, Not Ideal But Used
# void_sph = 20.0 # Void Spec Heat,
# void_dens = 0.01 # Void Density kg/m3
air_cond = 0.001 # ~1 Pa vacuum https://doi.org/10.1016/j.egypro.2016.06.196
air_sph = 1000.6 # engineering toolbox 0 C, J/kg/K
air_dens = 1.276e-5 # kg/m3 engineering toolbox scaled to 1e-5 atm (1Pa)

hp_fuel_couple_cond = 12 # number used by Topher
hp_fuel_couple_sph = 1000.6 # same as air
hp_fuel_couple_dens = 1.276 # same as air

hp_mli_cond = 0.001 # 0.001
hp_mli_sph = 1000.6 # same as air
hp_mli_dens = 1.276 # same as air

b4c_dens = 2510
b4c_ym = 4.48e11
b4c_pr = 0.21
b4c_exp = 4.5e-6
b4c_cond = 92
b4c_sph = 960.0

Be_dens = 1824
Be_ym = 2.53e11
Be_pr = 0.07
Be_exp = 17.3e-6
Be_cond = 91
Be_sph = 3103.0

# R_clad_o = 0.006477 # heat pipe outer radius
# R_hp_hole = 0.006477 # We are meshing the gap here so it is the same as R_clad_o
# num_sides = 20 # number of sides of heat pipe as a result of mesh polygonization
# alpha = '${fparse 2 * pi / num_sides}'
# perimeter_correction = '${fparse 0.5 * alpha / sin(0.5 * alpha)}' # polygonization correction factor for perimeter
# area_correction = '${fparse sqrt(alpha / sin(alpha))}' # polygonization correction factor for area
# corr_factor = '${fparse R_hp_hole / R_clad_o * area_correction / perimeter_correction}'

## ss_bot_pos = 0.07065

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
[]

[Mesh]
  [fmg]
    # If you do not have a presplit mesh already, you should:
    # 1. Uncomment the other blocks
    # 2. Use the exodus file in FMG
    # 3. Comment the distributed mesh line
    # 4. Use moose to presplit the mesh
    # 5. Recover the changes and use the presplit mesh
    type = FileMeshGenerator
    # file = '../MESH/BISON_mesh.e'
    file = 'bison_mesh.cpr'
  []
  # [hp_mli]
  #   type = ParsedSubdomainMeshGenerator
  #   input = fmg
  #   block_id = 999
  #   block_name = 'hp_mli'
  #   combinatorial_geometry = 'z>=0.6 | z<=0.35'
  #   excluded_subdomains = ${nonhpgap_all}
  # []
  # [hp_mli_2]
  #   type = ParsedSubdomainMeshGenerator
  #   input = hp_mli
  #   block_id = 998
  #   block_name = 'hp_mli_2'
  #   combinatorial_geometry = 'z>=0.24205 & z<=0.2484'
  #   excluded_subdomains = ${non_hp_all}
  # []
  parallel_type = distributed
[]

[Variables]
  [temp]
    initial_condition = 300
    block = ${nonfuel_all}
  []
  [temp_f]
    initial_condition = 300
    block = ${fuel_all}
  []
[]

[AuxVariables]
  [power_density]
    block = ${fuel_all}
    family = L2_LAGRANGE
    order = FIRST
    initial_condition = 1.0e6
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
    initial_condition = 975.0
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
  # [ext_heatsource]
  #   type = CoupledForce
  #   variable = temp
  #   v = external_power
  #   extra_vector_tags = 'ref'
  #   block = ${nonfuel_all}
  # []
  # [ext_heatsource_f]
  #   type = CoupledForce
  #   variable = temp_f
  #   v = external_power
  #   extra_vector_tags = 'ref'
  #   block = ${fuel_all}
  # []

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

[Modules/TensorMechanics/Master]
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
    model_option = Saller
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
  #VOIDS, Tricky Assumptions made throughout, malleable poor conductor, etc
  #Some of approach is assuming no radiative heat loss yet so compensating in
  #this manner
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

  #Aluminium; Assuming all the stuctures are SS316
  [Al6061Dens]
    type = Density
    block = ${Al_all}
    # density = ${ss_dens} # will change later
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
  [BottomSSFixZ]
    type = DirichletBC
    variable = disp_z
    boundary = 'ss_bot'
    value = ${reflector_disp}
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

  start_time = -1.0e6 #-1e-5 negative start time so we can start running from t = 0
  end_time = 0
  dt = 1e5
  dtmin = 1
  # dtmax = 1e5

  # [TimeStepper]
  #   type = IterationAdaptiveDT
  #   dt = 100
  # []
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
    # execute_on = 'final'
  []
  [checkpoint]
    type = Checkpoint
    additional_execute_on = 'FINAL' # seems to be necessary to avoid a Checkpoint bug
    # enable = false
  []
  # [console]
  #   type = Console
  #   show = '_dt total_power avg_fuel_temp max_fuel_temp min_fuel_temp fuel_volume'
  # []
  perf_graph = true
  color = true
[]