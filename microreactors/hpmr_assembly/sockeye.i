# Heat pipe sub-app input file for heat-pipe cooled microreactor assembly
# Sockeye input
length_evap = 1.8
length_adia = 0.4
length_cond = 1.8

n_elems_evap = 36
n_elems_adia = 8
n_elems_cond = 36
n_elems_wick = 2
n_elems_ann  = 2
n_elems_clad = 2

D_clad_o = ${fparse 2 * 0.0105}
D_clad_i = ${fparse 2 * 0.0097}
D_wick_o = ${fparse 2 * 0.0090}
D_wick_i = ${fparse 2 * 0.0080}
porosity = 0.7
permeability = 2e-9
R_pore = 15e-6

T_initial = ${units 800 degC -> K}
T_ref_density = ${T_initial}

fill_ratio = 1.1
T_ref_fill_ratio = 500.0

T_hx = ${units 50 degC -> K}
htc_hx = 228.0

[FluidProperties]
  [fp_2phase]
    type = SodiumIdealGasTwoPhaseFluidProperties
  []
[]

[SolidProperties]
  [sp_ss316]
    type = ThermalSS316Properties
  []
[]

[Closures]
  [closures]
    type = HeatPipeVOClosures
  []
[]

[Components]
  [heat_pipe]
    type = HeatPipeVO

    position_evap_end = '0 0 0'
    direction_evap_to_cond = '0 0 1'
    gravity_vector = '0 0 0'

    L_evap = ${length_evap}
    L_adia = ${length_adia}
    L_cond = ${length_cond}

    D_clad_o = ${D_clad_o}
    D_clad_i = ${D_clad_i}
    D_wick_o = ${D_wick_o}
    D_wick_i = ${D_wick_i}

    porosity = ${porosity}
    permeability = ${permeability}
    R_pore = ${R_pore}

    n_elems_evap = ${n_elems_evap}
    n_elems_adia = ${n_elems_adia}
    n_elems_cond = ${n_elems_cond}

    n_elems_wick = ${n_elems_wick}
    n_elems_ann  = ${n_elems_ann}
    n_elems_clad = ${n_elems_clad}

    initial_T = ${T_initial}
    fill_ratio = ${fill_ratio}
    T_ref_fill_ratio = ${T_ref_fill_ratio}

    T_ref_rho_wick = ${T_ref_density}
    T_ref_rho_clad = ${T_ref_density}

    fp_2phase = fp_2phase
    sp_wick = sp_ss316
    sp_clad = sp_ss316
    closures = closures

    scaling_factor_T_solid = 1e-5

    slope_reconstruction = NONE
    stop_vapor_at_condenser_pool = false
  []
  [cond_bc]
    type = HSBoundaryAmbientConvection
    hs = heat_pipe:hs
    boundary = 'heat_pipe:hs:cond:outer'
    T_ambient = ${T_hx}
    htc_ambient = ${htc_hx}
  []
  [evap_bc]
    type = HSBoundaryExternalAppHeatFlux
    hs = heat_pipe:hs
    boundary = 'heat_pipe:hs:evap:outer'
    heat_flux_name = q_ext
    heat_flux_is_inward = false
    perimeter_ext = P_ext
  []
[]

[UserObjects]
  [T_hp_uo]
    type = LayeredSideAverage
    variable = T_solid
    boundary = 'heat_pipe:hs:evap:outer'
    num_layers = ${n_elems_evap}
    direction = z
    execute_on = 'INITIAL TIMESTEP_END'
  []
[]

[VectorPostprocessors]
  [core_vpp]
    type = ADSampler1DReal
    block = 'heat_pipe:core:evap heat_pipe:core:adia heat_pipe:core:cond'
    property = 'p T vel c'
    sort_by = z
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [wick_i_vpp]
    type = SideValueSampler
    variable = T_solid
    boundary = 'heat_pipe:hs:inner'
    sort_by = z
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [wick_o_vpp]
    type = SideValueSampler
    variable = T_solid
    boundary = 'heat_pipe:hs:wick:ann'
    sort_by = z
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [clad_i_vpp]
    type = SideValueSampler
    variable = T_solid
    boundary = 'heat_pipe:hs:ann:clad'
    sort_by = z
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [clad_o_vpp]
    type = SideValueSampler
    variable = T_solid
    boundary = 'heat_pipe:hs:outer'
    sort_by = z
    execute_on = 'INITIAL TIMESTEP_END'
  []
[]

[Preconditioning]
  [pc]
    type = SMP
    full = true
  []
[]

[Executioner]
  type = Transient

  scheme = bdf2
  end_time = 100000.0

  steady_state_detection = true
  steady_state_tolerance = 1e-7

  [TimeStepper]
    type = IterationAdaptiveDT
    growth_factor = 1.2
    cutback_factor = 0.8
    optimal_iterations = 10
    iteration_window = 0
    dt = 0.01
  []
  dtmin = 0.01

  solve_type = NEWTON
  petsc_options_iname = '-pc_type'
  petsc_options_value = 'lu'

  nl_rel_tol = 1e-7
  nl_abs_tol = 1e-7
  nl_max_its = 15
[]

[Outputs]
  print_linear_residuals = false
  print_linear_converged_reason = false
  print_nonlinear_converged_reason = false

  [xml]
    type = XMLOutput
    execute_on = 'FINAL'
  []
  [console]
    type = Console
    execute_postprocessors_on = 'NONE'
    outlier_variable_norms = false
  []
[]
