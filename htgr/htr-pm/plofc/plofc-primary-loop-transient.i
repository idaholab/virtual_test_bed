# ==============================================================================
# MODEL PARAMETERS
# ==============================================================================
# Properties -------------------------------------------------------------------
T_inlet           = 523.15 # Helium inlet temperature (K).
p_outlet          = 7.0e+6 # Reactor outlet pressure (Pa)


# Start model ------------------------------------------------------------------
[GlobalParams]
  gravity = '0 -9.807 0' # SAM default is 9.8 for Z-direction
  global_init_P = ${p_outlet}
  global_init_V = 1
  global_init_T = ${T_inlet}
  scaling_factor_var = '1 1e-3 1e-6'
  eos = helium
  Tsolid_sf = 1e-5
[]

[Problem]
  restart_file_base = 'plofc-main-ss_out_primary_loop0_checkpoint_cp/450'
  # restart_file_base = 'plofc-main-ss_out_primary_loop0_checkpoint_cp/LATEST'
[]

[Functions]
  [p_out_fn]
    type = PiecewiseLinear
    x = '       -1e6         1e6 '
    y = '${p_outlet} ${p_outlet} '
  []
  [rhoHe]  #Helium  density; x- Temperature [K], y- density [kg/m3] @ P=7 MPa, NIST database
    type = PiecewiseLinear
    x = '500  520 540 560 580 600 620 640 660 680 700 720 740 760 780 800 820 840 860 880 900 920 940 960 980 1000  1020  1040  1060  1080  1100  1120  1140  1160  1180  1200  1220  1240  1260  1280  1300  1320  1340  1360  1380  1400  1420  1440  1460  1480  1500'
    y = '6.6176 6.3682  6.137 5.9219  5.7214  5.534 5.3585  5.1937  5.0388  4.8929  4.7551  4.6249  4.5016  4.3848  4.2738  4.1683  4.0679  3.9722  3.8809  3.7937  3.7103  3.6305  3.5541  3.4808  3.4105  3.343 3.278 3.2156  3.1555  3.0976  3.0417  2.9879  2.9359  2.8857  2.8372  2.7903  2.7449  2.701 2.6584  2.6172  2.5772  2.5384  2.5008  2.4643  2.4288  2.3943  2.3608  2.3283  2.2966  2.2657  2.2357'
  []
  [muHe]  #Helium viscosity; x- Temperature [K], y-viscosity [Pa.s]
    type = PiecewiseLinear
    x = '500  520 540 560 580 600 620 640 660 680 700 720 740 760 780 800 820 840 860 880 900 920 940 960 980 1000  1020  1040  1060  1080  1100  1120  1140  1160  1180  1200  1220  1240  1260  1280  1300  1320  1340  1360  1380  1400  1420  1440  1460  1480  1500'
    y = '2.85E-05 2.93E-05  3.01E-05  3.08E-05  3.16E-05  3.23E-05  3.31E-05  3.38E-05  3.45E-05  3.53E-05  3.60E-05  3.67E-05  3.74E-05  3.81E-05  3.88E-05  3.95E-05  4.02E-05  4.09E-05  4.16E-05  4.23E-05  4.29E-05  4.36E-05  4.43E-05  4.49E-05  4.56E-05  4.62E-05  4.69E-05  4.75E-05  4.82E-05  4.88E-05  4.94E-05  5.01E-05  5.07E-05  5.13E-05  5.20E-05  5.26E-05  5.32E-05  5.38E-05  5.44E-05  5.50E-05  5.57E-05  5.63E-05  5.69E-05  5.75E-05  5.81E-05  5.87E-05  5.92E-05  5.98E-05  6.04E-05  6.10E-05  6.16E-05'
  []
  [kHe]  #Helium therm. cond; x- Temperature [K], y-Thermal condiuctivity [W/m-K]
    type = PiecewiseLinear
    x = '500  520 540 560 580 600 620 640 660 680 700 720 740 760 780 800 820 840 860 880 900 920 940 960 980 1000  1020  1040  1060  1080  1100  1120  1140  1160  1180  1200  1220  1240  1260  1280  1300  1320  1340  1360  1380  1400  1420  1440  1460  1480  1500'
    y = '0.22621  0.23233 0.23838 0.24437 0.2503  0.25616 0.26197 0.26773 0.27344 0.27909 0.2847  0.29026 0.29578 0.30126 0.30669 0.31208 0.31743 0.32275 0.32802 0.33327 0.33847 0.34365 0.34879 0.3539  0.35897 0.36402 0.36904 0.37403 0.37899 0.38392 0.38883 0.39371 0.39856 0.40339 0.4082  0.41298 0.41774 0.42248 0.42719 0.43188 0.43655 0.4412  0.44583 0.45043 0.45502 0.45959 0.46414 0.46867 0.47318 0.47767 0.48215'
  []
  [m_fn]
    type = PiecewiseLinear
    x = ' -2e5        0     13'
    y = '  1.0      1.0    0.00001'
    scale_factor = 96
  []
[]

[EOS]
  [helium]
    type    = PTFunctionsEOS
    rho     = rhoHe
    cp      = 5240
    mu      = muHe
    k       = kHe
    T_min   = 500
    T_max   = 1500
  []
  [water]  # 13.25 MPa and 478.15 K
    type  = PTConstantEOS
    p_0   = 13.25e6
    rho_0 = 867.54
    beta  = 0
    cp    = 4455.7
    h_0   = 879.44e3
    T_0   = 478.15
    mu    = 0.00013403
    k     = 0.66532
  []
[]

[MaterialProperties]
  [ss-mat]
    type = HeatConductionMaterialProps
    k = 17.0
    Cp = 540.0
    rho = 7800.0
  []
[]

# ==========================================================
# - Components for coupling 1D to 2D flow model
# ==========================================================
[Components]
  [cold_plenum]
    type = PBVolumeBranch
    eos = helium
    center = '1.065 15.85 0'
    inputs = 'riser(out)'
    outputs = 'bypass(in) cold_plenum_outlet_pipe(out)'
    K = '0.0 0.0 0.0'
    width = 0.8 # display purposes
    height = 1.69 # display purposes
    Area = 8.9727
    volume = 7.17816
  []
  [hot_plenum]
    type = PBVolumeBranch
    eos = helium
    center = '0.845 1.4 0'
    inputs = 'hot_plenum_inlet_pipe(in) bypass(out)'
    outputs = 'outlet_pipe(in)'
    K = '0.0 0.0 0.0'
    width = 0.8 # display purposes
    height = 1.69 # display purposes
    Area = 8.9727
    volume = 7.17816
  []

  # Small artificial to connect 'coupled_outlet_top'
  # to the cold plenum
  [cold_plenum_outlet_pipe]
    type           = PBOneDFluidComponent
    A              = 7.068583471 # Based on pbed flow area in mainapp
    length         = 0.1
    Dh             = 3
    n_elems        = 1
    orientation    = '0 1 0'
    position       = '1.065 15.7 0' #'0.845 1.5 0'
    eos            = helium
    initial_V      = -2
  []

  # # This is the 'exit' of the 1-D primary loop model.
  # It is located at the outlet of the cold plenum.
  [coupled_outlet_top]
    type = CoupledPPSTDV
    input = 'cold_plenum_outlet_pipe(in)'
    eos = helium
    postprocessor_pbc = p_core_pipe_outlet
    postprocessor_Tbc = 1Dreceiver_temperature_in
  []

  # This is the 'entrance' of the 1-D primary loop model.
  # It is located at the inlet of the hot plenum.
  [coupled_inlet]
    type = CoupledPPSTDJ
    input = 'hot_plenum_inlet_pipe(out)'
    eos  = helium
    postprocessor_vbc = core_velocity_scaled #core_velocity
    postprocessor_Tbc = 1Dreceiver_temperature_out # T from 2D domain T_out
    v_bc = -2
    T_bc = 523.15
  []

  # Small artificial to connect 'coupled_inlet'
  # to the hot plenum
  [hot_plenum_inlet_pipe]
    type           = PBOneDFluidComponent
    A              = 7.068583471 # Based on pbed flow area in mainapp
    length         = 0.5
    Dh             = 3
    n_elems        = 1
    orientation    = '0 1 0'
    position       = '0.845 1.3 0' #'1.065 15.85 0'
  []
  [bypass]
    type           = PBOneDFluidComponent
    A              = 0.42474
    length         = 13.9
    Dh             = 0.13
    n_elems        = 20
    orientation    = '0 -1 0'
    position       = '1.625 15.7 0'
    HT_surface_area_density = 23.077
    f = 2000
    Hw = 0
  []

  # Surrogate channel to represent the pebble bed
  # Outlet of the surrogate channel
  [coupled_inlet_top]
    type = CoupledPPSTDJ
    input = 'core_pipe(out)'
    eos  = helium
    postprocessor_vbc = core_top_velocity_scaled # core_velocity
    postprocessor_Tbc = T_cold_plenum_inlet_pipe_inlet # T from cold plenum
    v_bc = -2
    T_bc = 523.15
  []

  # Surrogate channel
  [core_pipe]
    type           = PBOneDFluidComponent
    eos            = helium
    A              = 7.068583471 # Based on pbed flow area in mainapp
    length         = 13.9 # 15.7-1.8
    Dh             = 3
    n_elems        = 1
    orientation    = '0 1 0'
    position       = '0.845 1.8 0' #'1.065 15.85 0'
    overlap_coupled = true
    overlap_pp = dpdz_core_receive
  []

  # Inlet of the surrogate channel
  [coupled_outlet]
    type = CoupledPPSTDV
    input = 'core_pipe(in)'
    eos = helium
    # p_bc = 7e6
    postprocessor_pbc = p_hot_plenum_inlet_pipe_outlet # p from hot_plenum_inlet_pipe outlet
    postprocessor_Tbc = T_hot_plenum_inlet_pipe_outlet # T from hot_plenum_inlet_pipe outlet
  []

  [riser]
    type           = PBOneDFluidComponent
    A              = 0.81631
    Dh             = 0.2
    length         = 13.65281 #
    n_elems        = 20
    orientation    = '0 1 0'
    position       = '2.03 2.04719 0'
    HT_surface_area_density =  14.85532
    Hw = 0
  []
  [joint_outlet_1]
    type = PBSingleJunction
    eos = helium
    inputs = 'inlet_pipe(out)'
    outputs = 'riser(in)'
  []
  [inlet_pipe]
    type           = PBOneDFluidComponent
    A              = 1.257280927
    Dh             = 0.61552
    length         = 5.134
    n_elems        = 20
    orientation    = '-1 0 0'
    position       = '7.164 2.04719 0'
  []
  [outlet_pipe]
    type           = PBOneDFluidComponent
    A              = 0.470026997
    Dh             = 0.7746
    length         = 5.134
    n_elems        = 20
    orientation    = '1 0 0'
    position       = '2.03 1.4 0'
  []
  [inlet]
    type  = PBTDJ
    m_fn  = m_fn
    T_bc  = ${T_inlet}
    eos   = helium
    input = 'inlet_pipe(in)'
  []
  [outlet]
    type  = PBTDV
    eos   = helium
    p_bc  = ${p_outlet}
    input = 'outlet_pipe(out)'
  []

  ####################################
  # Bypass and riser heat transfer
  [from_main_app_riser]
    type = HeatTransferWithExternalHeatStructure
    flow_component = riser
    initial_T_wall = ${T_inlet}
    T_wall_name = Twall_riser_inner_from_main
  []

  [from_main_app_bypass]
    type = HeatTransferWithExternalHeatStructure
    flow_component = bypass
    initial_T_wall = ${T_inlet}
    T_wall_name = Twall_bypass_inner_from_main
  []

[]


[Postprocessors]

 # inlet pressure hot_plenum_inlet_pipe
  [P_hot_plenum_inlet_pipe]
    type = ComponentBoundaryVariableValue
    variable = pressure
    input = hot_plenum_inlet_pipe(in)
  []
  [P_cold_plenum_outlet_pipe]
    type = ComponentBoundaryVariableValue
    variable = pressure
    input = cold_plenum_outlet_pipe(out)
  []

  [1Dsource_temperature_in]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = 'cold_plenum_outlet_pipe(out)'
  []

  [1Dsource_temperature_out]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = 'hot_plenum_inlet_pipe(in)'
  []

  [1Dsource_velocity_in]
    type = ComponentBoundaryVariableValue
    variable = velocity
    input = 'cold_plenum_outlet_pipe(out)'
  []

  [1Dreceiver_temperature_in]
    type = Receiver
  []

  [1Dreceiver_temperature_out]
    type = Receiver
  []

  # temperature
  [Tf_in_bypass]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = bypass(in)
  []
  [Tf_out_bypass]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = bypass(out)
  []
  [Tf_in_riser]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = riser(in)
  []
  [Tf_out_riser]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = riser(out)
  []
  [Tf_out_pipe]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = outlet_pipe(in)
  []
  [HeatInCore]
    type = ComponentBoundaryEnergyBalance
    input = 'riser(in) outlet_pipe(in)'
    eos = helium
  []

  # mflow
  [mflow_in]
    type     = ComponentBoundaryFlow
    input    = 'riser(in)'
  []
  [mflow_bypass]
    type     = ComponentBoundaryFlow
    input    = 'bypass(in)'
  []
  [mflow_pebble_in]
    type     = ComponentBoundaryFlow
    input    = 'cold_plenum_outlet_pipe(in)'
  []
  [mflow_pebble_out]
    type     = ComponentBoundaryFlow
    input    = 'hot_plenum_inlet_pipe(in)'
  []
  [mflow_out]
    type     = ComponentBoundaryFlow
    input    = 'outlet_pipe(in)'
  []

  # pressure
  [P_in_riser]
    type = ComponentBoundaryVariableValue
    variable = pressure
    input = riser(out)
  []
  [P_out_pipe]
    type = ComponentBoundaryVariableValue
    variable = pressure
    input = outlet_pipe(in)
  []

  [T_cold_plenum_inlet_pipe_inlet]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = cold_plenum_outlet_pipe(in)
  []
  [rho_cold_plenum_inlet_pipe_inlet]
    type = ComponentBoundaryVariableValue
    variable = rho
    input = cold_plenum_outlet_pipe(in)
  []
  [cold_plenum_outlet_pipe_flow]
    type = ComponentBoundaryFlow
    input = cold_plenum_outlet_pipe(in)
  []
  [core_top_velocity_scaled]
    type = ParsedPostprocessor
    function = 'cold_plenum_outlet_pipe_flow / rho_cold_plenum_inlet_pipe_inlet / 7.068583471'
    pp_names = 'cold_plenum_outlet_pipe_flow rho_cold_plenum_inlet_pipe_inlet'
  []

  [p_hot_plenum_inlet_pipe_outlet]
    type = ComponentBoundaryVariableValue
    variable = pressure
    input = hot_plenum_inlet_pipe(out)
  []
  [T_hot_plenum_inlet_pipe_outlet]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = hot_plenum_inlet_pipe(out)
  []
  [p_core_pipe_outlet]
    type = ComponentBoundaryVariableValue
    variable = pressure
    input = core_pipe(out)
  []
  [T_core_pipe_outlet]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = core_pipe(out)
  []

  [core_flow]
    type     = ComponentBoundaryFlow
    input    = 'core_pipe(in)'
  []
  [core_velocity]
    type     = ComponentBoundaryVariableValue
    variable = velocity
    input    = 'core_pipe(in)'
  []
  [core_rho]
    type     = ComponentBoundaryVariableValue
    variable = rho
    input    = 'core_pipe(in)'
  []
  [hot_plenum_inlet_pipe_rho]
    type     = ComponentBoundaryVariableValue
    variable = rho
    input    = 'hot_plenum_inlet_pipe(out)'
  []
  [core_velocity_scaled]
    type = ParsedPostprocessor
    function = 'core_flow / hot_plenum_inlet_pipe_rho / 7.068583471'
    pp_names = 'core_flow hot_plenum_inlet_pipe_rho'
  []

  #overlapping
  [dpdz_core_receive]
    type = Receiver
  []
[]

[Preconditioning]
  [SMP_PJFNK]
    type = SMP
    full = true
    solve_type = 'PJFNK'
    petsc_options_iname = '-pc_type -ksp_gmres_restart'
    petsc_options_value = 'lu 101'
  []
[]

[Executioner]
  type = Transient
  dtmin = 1e-6
  dtmax = 8

  [TimeStepper]
    type = IterationAdaptiveDT
    growth_factor = 1.25
    optimal_iterations = 10
    linear_iteration_ratio = 100
    dt = 0.005 #0.0064 #0.01
    cutback_factor = 0.8
    cutback_factor_at_failure = 0.8
  []

  nl_rel_tol = 1e-6 #1e-5
  nl_abs_tol = 1e-6 #1e-4
  nl_max_its = 15
  l_tol = 1e-4 #1e-6
  l_max_its = 100

  start_time = 0
  end_time = 500000

  [Quadrature]
    type = GAUSS
    order = SECOND
  []
[]

[Outputs]
  perf_graph = true
  print_linear_residuals = false
  [out]
    type = Exodus
    use_displaced = true
    sequence = false
  []
  [csv]
    type = CSV
  []
  [checkpoint]
    type = Checkpoint
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [console]
    type = Console
    fit_mode = AUTO
    execute_scalars_on = 'NONE'
  []
[]
