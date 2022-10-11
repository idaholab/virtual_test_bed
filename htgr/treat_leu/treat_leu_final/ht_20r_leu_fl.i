# /*
# This version of ht_20r_leu_fl.i has had all of its editing
# comments and originally commented lines removed. They are
# preserved in the treat_leu_edited folder
# */
# 20r HEU with fragment damage layer

[Problem]
  coord_type = RSPHERICAL
  #kernel_coverage_check = false
[]

[Mesh]
  [leu_mesh]
    type = CartesianMeshGenerator # Remember in cm
    dim = 1
    dx = '0.0020 0.0014 0.0020 0.011875711758' # cm
    # radius particle, damage layer, transition graphite, b_r - dam_lay - 2a_r
    ix = '10 7 10 40' # number of elements
    #uniform_refine = 0 # no refine
  []
  [set_damlay_id]
    type = SubdomainBoundingBoxGenerator
    input = leu_mesh
    block_id = 11 # Damage Layer id
    bottom_left = '-0.0001 -0.0001 -0.0001'
    top_right = '0.0034 0.0001 0.0001' # x should be a_r
  []
  [set_grain_id]
    type = SubdomainBoundingBoxGenerator
    input = set_damlay_id
    block_id = 10 # Fuel grain id is now 10
    bottom_left = '-0.0001 -0.0001 -0.0001'
    top_right = '0.0020 0.0001 0.0001' # x should be a_r
  []
[]

[Variables]
  [./temperature]
    order = FIRST
    family = LAGRANGE
    initial_condition = 300.0 # K
  [../]
[]

[Kernels]
  [./HeatConduction]
    type = HeatConduction
    variable = temperature
  [../]
  [./HeatStorage]
    type = HeatCapacityConductionTimeDerivative
    variable = temperature
  [../]
  [./HeatSource_fg]
    type = CoupledForce
    v = PowerDensity
    variable = temperature
    block = 10
    coef = 508.59714978 # Scales to energy in grain
  [../]
  [./HeatSource_dl]
    type = CoupledForce
    v = PowerDensity
    variable = temperature
    block = 11
    coef = 34.7291950039 # Scales to energy in damage layer
  [../]
[]

# Boundary conditions are all adiabatic or symmetric which are the same.

[AuxVariables]
  [./PowerDensity]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./IntegralPower]
    order = CONSTANT
    family = MONOMIAL
    [./InitialCondition]
      type = ConstantIC
      value = 0.0
    [../]
  [../]
[]

[AuxKernels]
  [./PowerIntegrator]
    type = VariableTimeIntegrationAux
    variable = IntegralPower #J/cm^3
    variable_to_integrate = PowerDensity
    execute_on = timestep_end
    order = 2
  [../]
  [./SetPowerDensity]
    type = SetAuxByPostprocessor
    execute_on = 'timestep_begin timestep_end'
    postproc_value = local_power_density # Not scaled
    variable = PowerDensity
  [../]
[]

[Postprocessors]
  [./local_power_density]
    type = Receiver
  [../]
  [./TotalPower]
    type = ElementIntegralVariablePostprocessor
    variable = PowerDensity
  [../]
  [./IntegratedPower]
    type = ElementIntegralVariablePostprocessor
    variable = IntegralPower
  [../]
  [./avg_graphtemp]
    type = ElementAverageValue
    block = '0 11'
    variable = temperature
  [../]
  [./avg_graintemp]
    type = ElementAverageValue
    block = 10
    variable = temperature
  [../]
  [./avg_gr_rhocp]
    type = ElementAverageMaterialProperty
    block = '0 11'
    mat_prop = 'heat_capacity'
  [../]
  [./avg_gr_kth]
    type = ElementAverageMaterialProperty
    block = '0 11'
    mat_prop = 'thermal_conductivity'
  [../]
  [./avg_fg_rhocp]
    type = ElementAverageMaterialProperty
    block = 10
    mat_prop = 'heat_capacity'
  [../]
  [./avg_fg_kth]
    type = ElementAverageMaterialProperty
    block = 10
    mat_prop = 'thermal_conductivity'
  [../]
  [./delta_time]
    type = TimestepSize
  [../]
  [./nl_steps]
    type = NumNonlinearIterations
  [../]
  [./lin_steps]
    type = NumLinearIterations
  [../]
[]

[Materials]
  # Pure Graphite
  [./graph_kth]
    type = GenericConstantMaterial
    block = 0 # I think zero is the graphite
    prop_names = 'thermal_conductivity'
    prop_values = '0.3014' # W/cm K
  [../]
  [./graph_rho_cp]
    type = ParsedMaterial
    block = '0 11' # Irradiation does not affect rho * cp
    constant_names = 'rho_gr'
    constant_expressions = '0.0018' # kg/cm3
    args = 'temperature' # Variable
    f_name = 'heat_capacity' # Property name
    function = 'rho_gr / (11.07 * pow(temperature, -1.644) + 0.0003688 * pow(temperature, 0.02191))' # J/cm3 K
  [../]
  # Fission Damaged Graphite
  [./damlay_kth]
    type = GenericConstantMaterial
    block = 11 # Damage layer of graphite
    prop_names = 'thermal_conductivity'
    prop_values = '0.01046' # W/cm K
  [../]

  # Fuel Grain UO2
  [./grain_kth] # Do DerivativeParsedMaterial for temp dependent or a function
    type = ParsedMaterial
    block = 10
    constant_names = 'beta p_vol sigma kap3x'
    constant_expressions = '1.0 0.05 1.5 1.0'
    args = 'temperature' # Variable
    f_name = 'thermal_conductivity' # Property name
    function = 'lt := temperature / 1000.0; fresh := (100.0 / (6.548 + 23.533 * lt) + 6400.0 * exp(-16.35 / lt) / pow(lt, 5.0/2.0)) / 100.0; kap1d := (1.09 / pow(beta, 3.265) + 0.0643 * sqrt(temperature) / sqrt(beta)) * atan(1.0 / (1.09 / pow(beta, 3.265) + sqrt(temperature) * 0.0643 / sqrt(beta))); kap1p := 1.0 + 0.019 * beta / ((3.0 - 0.019 * beta) * (1.0 + exp(-(temperature - 1200.0) / 100.0))); kap2p := (1.0 - p_vol) / (1.0 + (sigma - 1.0) * p_vol); kap4r := 1.0 - 0.2 / (1.0 + exp((temperature - 900.0) / 80.0)); fresh * kap1d * kap1p * kap2p * kap3x * kap4r'
      # Divided fresh by 100 to get it into cm
  [../]
  [./grain_rho_cp]
    type = ParsedMaterial
    block = 10
    constant_names = 'rho_fg'
    constant_expressions = '0.010963' # kg/cm3
    args = 'temperature' # Variable
    f_name = 'heat_capacity' # Property name
    function = 'lt := temperature / 1000.0; fink_cp := 52.1743 + 87.951 * lt - 84.2411 * pow(lt, 2) + 31.542 * pow(lt, 3) - 2.6334 * pow(lt, 4) - 0.71391 * pow(lt, -2); rho_fg * fink_cp / 267.2 * 1000.0' # J/cm3 K
  [../]
[]

[Preconditioning]
  [./SMP_full]
    type = SMP
    full = true
    solve_type = 'PJFNK'
    petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart -pc_hypre_boomeramg_max_iter -pc_hypre_boomeramg_tol'
    petsc_options_value = 'hypre boomeramg 101 20 1.0e-6'
    petsc_options = '-snes_ksp_ew -snes_converged_reason'
    #petsc_options = '-snes_ksp_ew -snes_converged_reason -ksp_monitor_true_residual'
  [../]
[]

[Executioner]
  type = Transient
  start_time = 0.0
  end_time = 10.0

  l_tol = 1e-3
  l_max_its = 100
  nl_max_its = 200
  nl_abs_tol = 1e-8
  nl_rel_tol = 1e-8

  [./TimeStepper]
    type = ConstantDT
    dt = 0.005
    growth_factor = 1.5
  [../]
[]

[Outputs]
  interval = 1
  csv = true
  exodus = true
  [./console]
    type = Console
    output_linear = true
    output_nonlinear = true
  [../]
[]
