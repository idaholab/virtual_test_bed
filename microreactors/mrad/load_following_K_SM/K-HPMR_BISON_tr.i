################################################################################
## NEAMS Micro-Reactor Application Driver                                     ##
## Heat Pipe Microreactor Steady State                                        ##
## BISON Child Application input file                                         ##
## Thermomechanical model                                                     ##
## FY26 Summer Update for Solid Mechanics Implementation                      ##
################################################################################

R_clad_o = 0.0105 # heat pipe outer radius
R_hp_hole = 0.0107 # heat pipe + gap
num_sides = 12 # number of sides of heat pipe as a result of mesh polygonization
alpha = '${fparse 2 * pi / num_sides}'
perimeter_correction = '${fparse 0.5 * alpha / sin(0.5 * alpha)}' # polygonization correction factor for perimeter
area_correction = '${fparse sqrt(alpha / sin(alpha))}' # polygonization correction factor for area
corr_factor = '${fparse R_hp_hole / R_clad_o * area_correction / perimeter_correction}'

fuel_blocks = 'fuel_tri fuel_quad'
mono_blocks = 'monolith'
ref_blocks = 'reflector_quad reflector_tri'
mod_clad_blocks = 'mod_ss'
yh_blocks = 'moderator_quad moderator_tri'

inner_blocks = '${fuel_blocks} ${mono_blocks} ${yh_blocks} ${mod_clad_blocks} ${ref_blocks}'

mod_blocks = '${yh_blocks} ${mod_clad_blocks}'
air_blocks = 'air_gap_quad air_gap_tri outer_shield'
b4c_blocks = 'B4C'
outer_ref_blocks = 'outer_reflector_quad outer_reflector_tri'
outer_blocks = '${air_blocks} ${outer_ref_blocks} ${b4c_blocks}'

hp_blocks = 'heat_pipes_quad heat_pipes_tri hp_ss hp_ss_up'
non_hp_blocks = '${fuel_blocks} ${air_blocks} ${b4c_blocks} ${mono_blocks} ${mod_blocks} ${ref_blocks} ${outer_ref_blocks}'

restart_cp_file = '../steady_K_SM/K-HPMR_GRIFFIN_out_bison0_cp/LATEST'


[GlobalParams]
  flux_conversion_factor = 1
  fast_neutron_fluence = 0.0
  porosity = 0.01
  displacements = 'disp_x disp_y disp_z'
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

[Variables]
  [temp]
    block = ${non_hp_blocks}
  []
  [disp_x]
  []
  [disp_y]
  []
  [disp_z]
  [] 
[]

[Kernels]
  [heat_conduction]
    type = HeatConduction
    variable = temp
    extra_vector_tags = 'ref'
    block = ${non_hp_blocks}
  []
  [heat_source_fuel]
    type = CoupledForce
    variable = temp
    block = ${fuel_blocks}
    v = power_density
    extra_vector_tags = 'ref'
  []
  # These diffusion kernels evenly disperse the displacement across the void/outer blocks
  [diff_x]
    type = MatDiffusion
    block = '${outer_blocks} ${hp_blocks}'
    variable = disp_x
    diffusivity = 1e5
    extra_vector_tags = 'ref'
  []
  [diff_y]
    type = MatDiffusion
    block = '${outer_blocks} ${hp_blocks}'
    variable = disp_y
    diffusivity = 1e5
    extra_vector_tags = 'ref'
  []
  [diff_z]
    type = MatDiffusion
    block = '${outer_blocks} ${hp_blocks}'
    variable = disp_z
    diffusivity = 1e5
    extra_vector_tags = 'ref'
  []
[]

[Physics/SolidMechanics/QuasiStatic]
  generate_output = 'vonmises_stress stress_xx stress_yy stress_zz hydrostatic_stress strain_xx strain_yy strain_zz'
  add_variables = true
  use_finite_deform_jacobian = true
  [fuel]
    block = '${fuel_blocks}'
    strain = FINITE
    eigenstrain_names = 'fuel_thermal_eigenstrain'
    temperature = temp
  []
  [mod_clad]
    block = '${mod_clad_blocks}'
    strain = FINITE
    eigenstrain_names = 'ss_thermal_eigenstrain'
    temperature = temp
  []
  [mod]
    block = '${yh_blocks}'
    strain = FINITE
    eigenstrain_names = 'mod_thermal_eigenstrain'
    temperature = temp
  []
  [mono]
    block = '${mono_blocks}'
    strain = FINITE
    eigenstrain_names = 'mono_thermal_eigenstrain'
    temperature = temp
  []
  [ref]
    block = '${ref_blocks}'
    strain = FINITE
    eigenstrain_names = 'ref_thermal_eigenstrain'
    temperature = temp
  []
[]

[AuxVariables]
  [power_density]
    block = ${fuel_blocks}
    family = L2_LAGRANGE
    order = FIRST
  []
  [Tfuel]
    order = CONSTANT
    family = MONOMIAL
  []
  [stoich_griffin]
    order = CONSTANT
    family = MONOMIAL
  []
  [Tmod]
    block = ${yh_blocks}
    order = CONSTANT
    family = MONOMIAL
  []
  [fuel_thermal_conductivity]
    block = ${fuel_blocks}
    order = CONSTANT
    family = MONOMIAL
  []
  [fuel_specific_heat]
    block = ${fuel_blocks}
    order = CONSTANT
    family = MONOMIAL
  []
  [monolith_thermal_conductivity]
    block = ${mono_blocks}
    order = CONSTANT
    family = MONOMIAL
  []
  [monolith_specific_heat]
    block = ${mono_blocks}
    order = CONSTANT
    family = MONOMIAL
  []
  [flux_uo] #auxvariable to hold heat pipe surface flux from UserObject
    block = 'reflector_quad monolith'
  []
  [flux_uo_corr] #auxvariable to hold corrected flux_uo
    block = 'reflector_quad monolith'
  []
  [hp_temp_aux]
    order = CONSTANT
    family = MONOMIAL
    block = 'reflector_quad monolith'
  []
  [Tm_trans]
    order = CONSTANT
    family = MONOMIAL
    # initial_condition = 800
    block = ${mod_blocks}
  []
  [disp_x_trans]
  []
  [disp_y_trans]
  []
[]

[AuxKernels]
  [assign_disp_x_trans]
    type = NormalizationAux
    variable = disp_x_trans
    source_variable = disp_x
    execute_on = 'NONLINEAR'
  []
  [assign_disp_y_trans]
    type = NormalizationAux
    variable = disp_y_trans
    source_variable = disp_y
    execute_on = 'NONLINEAR'
  []
  [disp_x_trans_corr]
    type = NormalizationAux
    variable = disp_x_trans
    source_variable = disp_y_trans
    normal_factor = ${fparse sqrt(3)}
    execute_on = 'timestep_end'
    boundary = side_xy
  []
  [assign_tfuel_f]
    type = NormalizationAux
    variable = Tfuel
    source_variable = temp
    execute_on = 'timestep_end'
    block = ${fuel_blocks}
  []
  [assign_tmod]
    type = NormalizationAux
    variable = Tmod
    source_variable = temp
    execute_on = 'timestep_end'
  []
  [Tm_trans]
    type = SpatialUserObjectAux
    variable = Tm_trans
    user_object = Tm_UO
    block = ${mod_blocks}
  []
  [fuel_thermal_conductivity]
    type = MaterialRealAux
    variable = fuel_thermal_conductivity
    property = thermal_conductivity
    execute_on = timestep_end
  []
  [fuel_specific_heat]
    type = MaterialRealAux
    variable = fuel_specific_heat
    property = specific_heat
    execute_on = timestep_end
  []
  [monolith_thermal_conductivity]
    type = MaterialRealAux
    variable = monolith_thermal_conductivity
    property = thermal_conductivity
    execute_on = timestep_end
  []
  [monolith_specific_heat]
    type = MaterialRealAux
    variable = monolith_specific_heat
    property = specific_heat
    execute_on = timestep_end
  []
  [flux_uo]
    type = SpatialUserObjectAux
    variable = flux_uo
    user_object = flux_uo
  []
  [flux_uo_corr]
    type = NormalizationAux
    variable = flux_uo_corr
    source_variable = flux_uo
    normal_factor = '${fparse corr_factor}'
  []
[]

[BCs]
  [outside_bc]
    type = ConvectiveFluxFunction # (Robin BC)
    variable = temp
    boundary = 'bottom top side'
    coefficient = 1e3 # W/K/m^2
    T_infinity = 800 # K air temperature at the top of the core
  []
  [hp_temp]
    type = CoupledConvectiveHeatFluxBC
    boundary = 'heat_pipe_ht_surf'
    variable = temp
    T_infinity = hp_temp_aux
    htc = 750
  []
  [no_x]
    type = DirichletBC
    variable = disp_x
    boundary = 'side_y centerline'
    value = 0.0
  []
  [no_y]
    type = DirichletBC
    variable = disp_y
    boundary = 'centerline'
    value = 0.0
  []
  [no_z]
    type = DirichletBC
    variable = disp_z
    boundary = 'bottom'
    value = 0.0
  []
  [InclinedNoDisplacementBC]
    [flatxy]
      boundary = side_xy
      penalty = 1.0e10
      displacements = 'disp_x disp_y disp_z'
    []
  []
[]

[Materials]
  # Core materials thermal
  [fuel_matrix_thermal]
    type = GraphiteMatrixThermal
    block = ${fuel_blocks}
    packing_fraction = 0.4
    specific_heat_scale_factor = 1.0
    thermal_conductivity_scale_factor = 1.0
    fast_neutron_fluence = 0
    temperature = temp
  []
  [monolith_matrix_thermal]
    type = GraphiteMatrixThermal
    block = ${mono_blocks}
    packing_fraction = 0
    specific_heat_scale_factor = 1.0
    thermal_conductivity_scale_factor = 1.0
    fast_neutron_fluence = 0
    temperature = temp
  []
  [moderator_thermal]
    type = HeatConductionMaterial
    block = '${yh_blocks}'
    temperature = temp
    thermal_conductivity = 20 # W/m/K
    specific_heat = 500
  []
  [outer_ref_thermal]
    type = BeOThermal
    temperature = temp
    block = '${outer_ref_blocks}'
    fluence_conversion_factor = 1.0
  []
  [airgap_thermal]
    type = HeatConductionMaterial
    block = ${air_blocks} # Helium gap
    temperature = temp
    thermal_conductivity = 0.15 # W/m/K
    specific_heat = 5197
  []
  [axial_reflector_thermal]
    type = BeOThermal
    temperature = temp
    block = '${ref_blocks}'
    fluence_conversion_factor = 1.0
  []
  [B4C_thermal]
    type = B4CThermal
    block = ${b4c_blocks}
    temperature = temp
    capture_burnup = 0
  []
  [SS_thermal]
    type = SS316Thermal
    temperature = temp
    block = mod_ss
  []
  [fuel_density]
    type = Density
    block = ${fuel_blocks}
    density = 2276.5
  []
  [moderator_density]
    type = Density
    block = '${yh_blocks}'
    density = 4.3e3
  []
  [outer_ref_density]
   type = Density
   block = '${outer_ref_blocks}'
   density = 1848
  []
  [monolith_density]
    type = Density
    block = ${mono_blocks}
    density = 1806
  []
  [airgap_density]
    type = Density
    block = ${air_blocks} #helium
    density = 180
  []
  [axial_reflector_density]
   type = Density
   block = ${ref_blocks}
   density = 1848
  []
  [B4C_density]
    type = Density
    block = B4C
    density = 2510
  []
  [SS_density]
    type = Density
    density = 7990
    block = mod_ss
  []
  [hp_dummy]
    type = Density
    density = 1000
    block = ${hp_blocks}
  []
  # Core materials solid mechanics:
  #Thermal Expansion
  [thermal_exp_fuel]
    type = GraphiteMatrixThermalExpansionEigenstrain
    block = '${fuel_blocks}'
    eigenstrain_name = fuel_thermal_eigenstrain
    stress_free_temperature = 800
    temperature = temp
  []
  [thermal_exp_mod]
    type = ComputeThermalExpansionEigenstrain
    block = ${yh_blocks}
    temperature = temp
    thermal_expansion_coeff = 8.5e-6 # 1/K
    stress_free_temperature = 800 # K
    eigenstrain_name = mod_thermal_eigenstrain
  []
  [thermal_exp_mono]
    type = GraphiteGradeThermalExpansionEigenstrain
    block = '${mono_blocks}'
    graphite_grade = G_348
    eigenstrain_name = mono_thermal_eigenstrain
    stress_free_temperature = 800
    temperature = temp
  []
  [thermal_exp_ss]
    type = SS316ThermalExpansionEigenstrain
    stress_free_temperature = 800 # K
    temperature = temp
    eigenstrain_name = ss_thermal_eigenstrain
    block = ${mod_clad_blocks}
    outputs = all
  []  
  [thermal_exp_ref]
    type = BeOThermalExpansionEigenstrain
    block = ${ref_blocks}
    eigenstrain_name = ref_thermal_eigenstrain
    stress_free_temperature = 800.0
    temperature = temp
  []
  #Elasticity
  [elasticity_fuel]
    type = ComputeIsotropicElasticityTensor
    block = ${fuel_blocks}
    youngs_modulus = 10.0e9
    poissons_ratio = 0.25
  []
  [elasticity_ss]
    type = SS316ElasticityTensor
    temperature = temp
    elastic_constants_model = ornl
    block = ${mod_clad_blocks}
  []  
  [elasticity_mod]
    type = ComputeIsotropicElasticityTensor
    block = ${yh_blocks}
    youngs_modulus = 2e10
    poissons_ratio = 0.3
  []
  [elasticity_mono]
    type = ComputeIsotropicElasticityTensor
    block = ${mono_blocks}
    # Recommended values of the youngs_modulus (Verfondern2013) and
    # poissons_ratio (Burchell2014) for graphite matrix
    youngs_modulus = 10.0e9
    poissons_ratio = 0.25
  []
  [elasticity_ref]
    type = BeOElasticityTensor
    block = ${ref_blocks}
    temperature = temp
  []
  #Stress
  [stress]
    type = ComputeFiniteStrainElasticStress
    block = '${inner_blocks}'
  []
[]

[MultiApps]
 [sockeye]
   type = TransientMultiApp
   app_type = SockeyeApp
   positions_file = 'hp_centers.txt'
   input_files = 'K-HPMR_SOCKEYE_tr.i'
   execute_on = 'timestep_begin'
   max_procs_per_app = 1
   output_in_position = true
   catch_up = true
   max_catch_up_steps = 1e4
 []
[]

[Transfers]
 # HP Transfers
  [from_sockeye_temp]
   type = MultiAppGeneralFieldNearestLocationTransfer
   from_multi_app = sockeye
   source_variable = hp_temp_aux
   variable = hp_temp_aux
   execute_on = 'timestep_begin'
 []
 [to_sockeye_flux]
   type = MultiAppGeneralFieldNearestLocationTransfer
   variable = total_flux
   source_variable = flux_uo_corr
   to_multi_app = sockeye
   execute_on = 'timestep_begin'
   from_blocks = 'reflector_quad monolith'
 []
[]

[UserObjects]
 [flux_uo]
   type = NearestPointLayeredSideDiffusiveFluxAverage
   direction = z
   num_layers = 100
   points_file = 'hp_centers.txt'
   variable = temp
   diffusivity = thermal_conductivity
   boundary = 'heat_pipe_ht_surf'
 []
  [Tf_avg]
    type = LayeredAverage
    variable = temp
    direction = z
    num_layers = 100
    block = ${fuel_blocks}
  []
  [Tm_UO]
    type = NearestPointLayeredAverage
    variable = temp
    direction = z
    num_layers = 100
    block = ${yh_blocks}
    execute_on = 'INITIAL TIMESTEP_END'
    points_file = 'mod_centers.txt'
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
  petsc_options = '-snes_ksp_ew'


  nl_abs_tol = 1e-5
  nl_rel_tol = 1e-5
  l_tol = 1e-4
  l_max_its = 25
  nl_max_its = 100

  # start_time = 0 # negative start time so we can start running from t = 0
  end_time = 2000
  dtmin = 1
  dtmax = 20
  automatic_scaling = false
  compute_scaling_once = false

  [TimeStepper]
    type = IterationAdaptiveDT
    dt = 5
    optimal_iterations = 100
    iteration_window = 3
    linear_iteration_ratio = 100
  []
[]

[Postprocessors]
  [hp_heat_integral]
    type = SideDiffusiveFluxIntegral
    variable = temp
    boundary = 'heat_pipe_ht_surf'
    diffusivity = thermal_conductivity
    execute_on = 'initial timestep_end'
  []
  [hp_end_heat_integral]
    type = SideDiffusiveFluxIntegral
    variable = temp
    boundary = 'heat_pipe_ht_surf_bot'
    diffusivity = thermal_conductivity
    execute_on = 'initial timestep_end'
  []
  [ext_side_integral]
    type = SideDiffusiveFluxIntegral
    variable = temp
    boundary = 'side'
    diffusivity = thermal_conductivity
    execute_on = 'initial timestep_end'
  []
  [mirror_side_integral]
    type = SideDiffusiveFluxIntegral
    variable = temp
    boundary = '147'
    diffusivity = thermal_conductivity
    execute_on = 'initial timestep_end'
  []
  [tb_integral]
    type = SideDiffusiveFluxIntegral
    variable = temp
    boundary = 'top bottom'
    diffusivity = thermal_conductivity
    execute_on = 'initial timestep_end'
  []
  [total_sink]
    type = SumPostprocessor
    values = 'hp_heat_integral hp_end_heat_integral ext_side_integral mirror_side_integral tb_integral'
    execute_on = 'initial timestep_end'
  []
  [fuel_temp_avg]
    type = ElementAverageValue
    variable = temp
    block = ${fuel_blocks}
  []
  [fuel_temp_max]
    type = ElementExtremeValue
    variable = temp
    block = ${fuel_blocks}
  []
  [fuel_temp_min]
    type = ElementExtremeValue
    variable = temp
    block = ${fuel_blocks}
    value_type = min
  []
  [mod_temp_avg]
    type = ElementAverageValue
    variable = temp
    block = ${yh_blocks}
  []
  [mod_temp_max]
    type = ElementExtremeValue
    variable = temp
    block = ${yh_blocks}
  []
  [mod_temp_min]
    type = ElementExtremeValue
    variable = temp
    block = ${yh_blocks}
    value_type = min
  []
  [monolith_temp_avg]
    type = ElementAverageValue
    variable = temp
    block = monolith
  []
  [monolith_temp_max]
    type = ElementExtremeValue
    variable = temp
    block = monolith
  []
  [monolith_temp_min]
    type = ElementExtremeValue
    variable = temp
    block = monolith
    value_type = min
  []
  [heatpipe_surface_temp_avg]
    type = SideAverageValue
    variable = temp
    boundary = heat_pipe_ht_surf
  []
  [power]
    type = ElementIntegralVariablePostprocessor
    block = ${fuel_blocks}
    variable = power_density
    execute_on = 'initial timestep_end transfer'
  []
  [flux_uo_avg]
    type = ElementAverageValue
    variable = flux_uo_corr
    block = 'reflector_quad monolith'
  []
[]

[Outputs]
  perf_graph = true
  color = true
  csv = true
  [cp]
    type = Checkpoint
    num_files = 2
    time_step_interval = 3
  []
[]
