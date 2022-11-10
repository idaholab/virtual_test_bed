# ==================================================================================
# Model Description
# Application: Griffin
# Idaho National Lab (INL), Idaho Falls, October 17, 2022
# Author: Adam Zabriskie, INL
# ==================================================================================
# TREAT Griffin Main Input File
# Main App
# ==================================================================================
# This model has been built based on [1]
# ----------------------------------------------------------------------------------
# [1] Zabriskie, A. X. (2019). Multi-Scale, Multi-Physics Reactor Pulse Simulation
#       Method with Macroscopic and Microscopic Feedback Effects (Unpublished
#       doctoral dissertation). Oregon State University, Corvallis, Oregon.
# ==================================================================================

# ==================================================================================
# Optional Debugging block
# ==================================================================================

[Debug]
  #  show_actions = true          #True prints out actions
  #  show_material_props = true   #True prints material properties
  #  show_parser = true
  #  show_top_residuals = 3        #Number to print
  #  check_boundary_coverage = true
  #  print_block_volume = true
  #  show_neutronics_material_coverage = true
  #  show_petsc_options = true
  #  show_var_residual_norms = true
[]

# ==================================================================================
# Geometry and Mesh
# ==================================================================================

[Mesh]
  [ref_mesh]
    # Simple Reflected Cube Reactor
    # Start at zero, half core length reflector thickness; 1/8th symmetric
    # Element size: reflector 5.08 cm and core 4.827616834 cm
    # 14 in half-core, 12 in reflector
    type = CartesianMeshGenerator
    dim = 3
    dx = '67.58663568 60.96'
    dy = '67.58663568 60.96'
    dz = '67.58663568 60.96'
    ix = '14 12'
    iy = '14 12'
    iz = '14 12'
  []
  [set_core_id]
    type = SubdomainBoundingBoxGenerator
    block_id =  10
    input = ref_mesh
    bottom_left = '0.0 0.0 0.0'
    top_right = '67.58663568 67.58663568 67.58663568'
  []
[]

# ==================================================================================
# MultiApps and Transfers
# ==================================================================================

[MultiApps]
  [initial_solve]
    type = FullSolveMultiApp
    execute_on = initial
    input_files = 'init_refcube.i'
    positions = '0 0 0'
  []
  [init_adj]
    type = FullSolveMultiApp
    execute_on = initial
    input_files = 'adj_refcube.i'
    positions = '0 0 0'
  []
  [micro]
    type = TransientMultiApp
    execute_on = timestep_end
    input_files = 'ht_20r_leu_fl.i'
    max_procs_per_app = 1
    positions_file = 'refcube_sub_micro.txt'
  []
[]
[Transfers]
  #Below are communication for adjoint IQS for PKE
  #Below are communication for Multiscale with micro-subs
  [copy_flux]
    type = TransportSystemVariableTransfer
    execute_on = initial
    from_transport_system = diffing
    from_multi_app = initial_solve
    to_transport_system = diffing
  []
  [copy_pp]
    # Scales everything to the initial power.
    type = MultiAppPostprocessorTransfer
    execute_on = initial
    from_postprocessor = UnscaledTotalPower
    from_multi_app = initial_solve
    reduction_type = maximum
    to_postprocessor = UnscaledTotalPower
  []
  [copy_sf]
    # Scales factor
    type = MultiAppPostprocessorTransfer
    execute_on = initial
    from_postprocessor = PowerScaling
    from_multi_app = initial_solve
    reduction_type = maximum
    to_postprocessor = PowerScaling
  []
  [copy_adjoint_vars]
    type = MultiAppCopyTransfer
    execute_on = initial
    from_multi_app = init_adj
    source_variable = 'sflux_g0 sflux_g1 sflux_g2 sflux_g3 sflux_g4 sflux_g5'
    variable = 'adjoint_flux_g0 adjoint_flux_g1 adjoint_flux_g2 adjoint_flux_g3 adjoint_flux_g4 adjoint_flux_g5'
  []
  [powden_down]
    type = MultiAppVariableValueSamplePostprocessorTransfer
    to_multi_app = micro
    postprocessor = local_power_density
    source_variable = PowerDensity
  []
  [modtemp_up]
    type = MultiAppPostprocessorInterpolationTransfer
    from_multi_app = micro
    num_points = 6
    postprocessor = avg_graphtemp
    power = 2
    variable = temp_ms
  []
  [graintemp_up]
    type = MultiAppPostprocessorInterpolationTransfer
    from_multi_app = micro
    num_points = 6
    postprocessor = avg_graintemp
    power = 2
    variable = temp_fg
  []
[]

# ==================================================================================
# Transport Systems
# ==================================================================================

[TransportSystems]
  # In 3D, back = 0, bottom = 1, right = 2, top = 3, left = 4, front = 5
  # back is -z, bottom is -y, right is +x
  #Boundary Conditions#
  G =  6
  ReflectingBoundary = '0 1 4'
  VacuumBoundary = '2 3 5'
  equation_type = transient
  for_adjoint = false
  particle = neutron
  [diffing]
    family = LAGRANGE
    n_delay_groups =  6
    order = FIRST
    scheme = CFEM-Diffusion
  []
[]

# ==================================================================================
# Variables and Kernels
# ==================================================================================

[Variables]
  [temperature]
    family = LAGRANGE
    initial_condition =  300.0
    order = FIRST
    scaling = 1e-8
  []
[]
[Kernels]
  [HeatConduction]
    type = HeatConduction
    variable = temperature
  []
  [HeatStorage]
    type = HeatCapacityConductionTimeDerivative
    variable = temperature
  []
  [HeatSource]
    block = 10
    type = CoupledForce
    v = PowerDensity
    variable = temperature
  []
[]

# ==================================================================================
# Functions
# ==================================================================================

[Functions]
  [boron_state]
    type = PiecewiseLinear
    x = '0.0 0.005 30'
    y = '1.89489259748 2.0 2.0'
  []
[]

# ==================================================================================
# Auxilliary Variables and Auxilliary Kernels
# ==================================================================================

[AuxVariables]
  [Boron_Conc]
    family = MONOMIAL
    initial_condition = 1.89489259748
    order = CONSTANT
  []
  [PowerDensity]
    block = '10'
    family = MONOMIAL
    order = CONSTANT
  []
  [IntegralPower]
    block = 10
    family = MONOMIAL
    initial_condition = 0.0
    order = CONSTANT
  []
  [avg_coretemp]
    block = 0
    family = LAGRANGE
    initial_condition =  300.0
    order = FIRST
  []
  [temp_fg]
    #Fuel Grain
    block = 10
    family = LAGRANGE
    initial_condition =  300.0
    order = FIRST
  []
  [temp_ms]
    #Moderator Shell
    block = 10
    family = LAGRANGE
    initial_condition =  300.0
    order = FIRST
  []
[]
[AuxKernels]
  [pulse_boron]
    type = FunctionAux
    execute_on = timestep_end
    function = boron_state
    variable = Boron_Conc
  []
  [PowerDensityCalc]
    type = VectorReactionRate
    block = '10'
    cross_section = kappa_sigma_fission
    dummies = UnscaledTotalPower
    execute_on = 'initial linear'
    scalar_flux =  'sflux_g0 sflux_g1 sflux_g2 sflux_g3 sflux_g4 sflux_g5'
    scale_factor = PowerScaling
    variable = PowerDensity
  []
  [Powerintegrator]
    type = VariableTimeIntegrationAux
    block = 10
    execute_on = timestep_end
    variable =  IntegralPower
    variable_to_integrate = PowerDensity
  []
  [Set_coreT]
    type = SetAuxByPostprocessor
    block = 0
    execute_on = 'linear timestep_end'
    postproc_value = avg_coretemp
    variable = avg_coretemp
  []
[]

# ==================================================================================
# Postprocessor Values
# ==================================================================================

[Postprocessors]
  [UnscaledTotalPower]
    type = Receiver
    outputs = none
  []
  [PowerScaling]
    type = Receiver
    outputs = none
  []
  [avg_coretemp]
    type = ElementAverageValue
    block = 10
    execute_on = linear
    outputs = all
    variable = temp_ms
  []
  [avg_refltemp]
    type = ElementAverageValue
    block = 0
    execute_on = linear
    outputs = all
    variable = temperature
  []
  [max_tempms]
    type = ElementExtremeValue
    block = '10'
    outputs = all
    value_type = max
    variable = temp_ms
  []
  [max_tempfg]
    type = ElementExtremeValue
    block = '10'
    outputs = all
    value_type = max
    variable = temp_fg
  []
  [avg_ms_temp]
    type = ElementAverageValue
    block = 10
    outputs = all
    variable = temp_ms
  []
  [avg_fg_temp]
    type = ElementAverageValue
    block = 10
    outputs = all
    variable = temp_fg
  []
  [avg_powerden]
    type = ElementAverageValue
    block = 10
    execute_on = timestep_end
    outputs = all
    variable = PowerDensity
  []
  [peak_avgPD]
    type = TimeExtremeValue
    execute_on = timestep_end
    postprocessor = avg_powerden
    value_type = max
  []
  [powden_ratio]
    type = PostprocessorRatio
    denominator = peak_avgPD
    execute_on = timestep_end
    numerator = avg_powerden
  []
  [der1_avgPD]
    type = ElementAverageTimeDerivative
    block = 10
    execute_on = timestep_end
    variable = PowerDensity
  []
  [peak_der1avgPD]
    type = TimeExtremeValue
    execute_on = timestep_end
    postprocessor = der1_avgPD
    value_type = max
  []
  [der1PD_ratio]
    type = PostprocessorRatio
    denominator = peak_der1avgPD
    execute_on = timestep_end
    numerator = der1_avgPD
  []
  [ScaledTotalPower]
    type = ElementIntegralVariablePostprocessor
    block = 10
    execute_on = linear
    variable = PowerDensity
  []
  [IntegratedPower]
    type = ElementIntegralVariablePostprocessor
    block = 10
    execute_on = timestep_end
    variable = IntegralPower
  []
  [delta_time]
    type = TimestepSize
  []
  [nl_steps]
    type = NumNonlinearIterations
  []
  [lin_steps]
    type = NumLinearIterations
  []
  [Eq_TREAT_Power]
    type = ScalePostprocessor
    scaling_factor =  2469860.77609
    value = avg_powerden
  []
[]

# ==================================================================================
# User Object
# ==================================================================================

[UserObjects]
  [der_pulse_end]
    type = Terminator
    execute_on = timestep_end
    expression = '(powden_ratio < 0.25) & (abs(der1PD_ratio) < 0.04)'
  []
[]

# ==================================================================================
# Materials
# ==================================================================================

[Materials]
  [neut_mix]
    type = CoupledFeedbackNeutronicsMaterial
    block = 10
    densities =  '0.998448391539 0.00155160846058'
    grid_names = 'Tfuel Tmod Rod'
    grid_variables = 'temp_fg temp_ms Boron_Conc'
    isotopes =  'pseudo1 pseudo2'
    library_file = 'cross_sections/leu_20r_is_6g_d.xml'
    library_name = leu_20r_is_6g_d
    material_id = 1
    plus = true
  []
  [kth]
    # Volume weighted harmonic mean
    # Divided fg_kth by 100 to get it into cm
    type = ParsedMaterial
    args =  'temp_fg'
    block = 10
    constant_expressions =  '3.35103216383e-08 1.31125888571e-07 2.14325144175e-05 0.3014 0.01046 1.0 0.05 1.5 1.0'
    constant_names = 'vol_fg vol_fl vol_gr gr_kth fl_kth beta p_vol sigma kap3x'
    f_name =  'thermal_conductivity'
    function =  'lt := temp_fg / 1000.0; fresh := (100.0 / (6.548 + 23.533 * lt) + 6400.0 * exp(-16.35 / lt) / pow(lt, 5.0/2.0)) / 100.0; kap1d := (1.09 / pow(beta, 3.265) + 0.0643 * sqrt(temp_fg) / sqrt(beta)) * atan(1.0 / (1.09 / pow(beta, 3.265) + sqrt(temp_fg) * 0.0643 / sqrt(beta))); kap1p := 1.0 + 0.019 * beta / ((3.0 - 0.019 * beta) * (1.0 + exp(-(temp_fg - 1200.0) / 100.0))); kap2p := (1.0 - p_vol) / (1.0 + (sigma - 1.0) * p_vol); kap4r := 1.0 - 0.2 / (1.0 + exp((temp_fg - 900.0) / 80.0)); fg_kth := fresh * kap1d * kap1p * kap2p * kap3x * kap4r; (vol_fg + vol_fl + vol_gr) / (vol_fg / fg_kth + vol_fl / fl_kth + vol_gr / gr_kth)'
  []
  [rho_cp]
    # Volume weighted arithmetic mean (Irradiation has no effect)
    type = ParsedMaterial
    args =  'temp_fg temp_ms'
    block = 10
    constant_expressions =  '3.35103216383e-08 2.1563640306e-05 0.0018 0.010963'
    constant_names =  'vol_fg vol_gr rho_gr rho_fg'
    f_name =  'heat_capacity'
    function = 'lt := temp_fg / 1000.0; gr_rhocp := rho_gr / (11.07 * pow(temp_ms, -1.644) + 0.0003688 * pow(temp_ms, 0.02191)); fink_cp := 52.1743 + 87.951 * lt - 84.2411 * pow(lt, 2) + 31.542 * pow(lt, 3) - 2.6334 * pow(lt, 4) - 0.71391 * pow(lt, -2); fg_rhocp := rho_fg * fink_cp / 267.2 * 1000.0; (vol_fg * fg_rhocp + vol_gr * gr_rhocp) / (vol_fg + vol_gr)'
  []
  [neut_refl]
    type = CoupledFeedbackNeutronicsMaterial
    block = 0
    densities = '1'
    grid_names = 'Trefl Tcore Rod'
    grid_variables = 'temperature avg_coretemp Boron_Conc'
    isotopes = 'pseudo'
    library_file = 'cross_sections/leu_macro_6g.xml'
    library_name = leu_macro_6g
    material_id = 2
    plus = true
  []
  [ref_kth]
    type = GenericConstantMaterial
    block = 0
    prop_names = 'thermal_conductivity'
    prop_values =  '0.3014'
  []
  [ref_rho_cp]
    type = ParsedMaterial
    args =  'temperature'
    block = '0'
    constant_expressions =  '0.0018'
    constant_names = 'rho_gr'
    f_name =  'heat_capacity'
    function =  'rho_gr / (11.07 * pow(temperature, -1.644) + 0.0003688 * pow(temperature, 0.02191))'
  []
[]

# ==================================================================================
# Preconditioners
# ==================================================================================

[Preconditioning]
  [SMP_full]
    #petsc_options = '-snes_ksp_ew -snes_converged_reason -ksp_monitor_true_residual'
    type = SMP
    full = true
    petsc_options = '-snes_ksp_ew -snes_converged_reason'
    petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart -pc_hypre_boomeramg_max_iter -pc_hypre_boomeramg_tol'
    petsc_options_value = 'hypre boomeramg 101 20 1.0e-6'
    solve_type = 'PJFNK'
  []
[]

# ==================================================================================
# Executioner and Outputs
# ==================================================================================

[Executioner]
  type = IQS
  do_iqs_transient = false
  pke_param_csv = true

  # Time evolution parameters
  dtmin = 1e-7
  start_time = 0.0
  end_time =  10.0
  [TimeStepper]
    type = ConstantDT
    dt = 0.005
    growth_factor = 1.5
  []

  # Solver parameters
  l_max_its = 100
  l_tol = 1e-3
  nl_abs_tol = 1e-7
  nl_max_its = 200
  nl_rel_tol = 1e-7

  # Multiphysics iteration parameters
  fixed_point_abs_tol = 1e-7
  fixed_point_max_its = 10
  fixed_point_rel_tol = 1e-7
[]
[Outputs]
  file_base = out~refcube
  interval = 1
  [console]
    type = Console
    output_linear = true
    output_nonlinear = true
  []
  [exodus]
    type = Exodus
  []
  [csv]
    type = CSV
    hide = 'lin_steps nl_steps'
  []
[]
