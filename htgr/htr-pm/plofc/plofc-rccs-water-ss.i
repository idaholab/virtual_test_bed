# ==============================================================================
# MODEL PARAMETERS
# ==============================================================================
T_inlet_rccs      = 303.15 # RCCS inlet flow temperature
p_outlet          = 1.0e+5 # Reactor outlet pressure (Pa)
Dh_pipe           = 2 #1

# Start model ------------------------------------------------------------------
[GlobalParams]
  # params used in both 2D and 1D model
  gravity = '0 -9.807 0' # SAM default is 9.8 for Z-direction
  eos = eos

  # params used in 1D model only
  global_init_P = ${p_outlet}
  global_init_V = 1.0E-02
  global_init_T = ${T_inlet_rccs}
  Tsolid_sf = 1e-5
  scaling_factor_var = '1 1e-3 1e-6'

  [PBModelParams]
    pbm_scaling_factors = '1 1e-3 1e-6'
    p_order = 1
  []
[]

[Functions]
[]

[EOS]
  [eos]
    type = PTConstantEOS
    p_0   = 1e5       # Pa
    rho_0 = 998.2     # kg/m^3 at 293.15 K
    beta  = 0.000214  # K^{-1}
    cp    = 4184      # at   at 293.15 K
    h_0   = 500000    # J/kg at 273.15 K
    T_0   = 273.15    # K
    mu    = 1.0014e-3 # Pa-s  at 293.15 K
    k     = 0.598     # W/m-K at 293.15 K
  []
[]


[MaterialProperties]
  [ss-mat]
    type = HeatConductionMaterialProps
    k = 38.0
    Cp = 540.0
    rho = 7800.0
  []
[]

[ComponentInputParameters]
  [CoolantChannel]
    type = PBOneDFluidComponentParameters
    eos = water_eos
    HTC_geometry_type = Pipe
  []
[]

[AuxKernels]
  [QRad_multiplied]
    type = ParsedAux
    block = 'rccs-panel:hs0'
    variable = QRad_multiplied
    args = 'QRad'
    function = 'QRad * 18.84955592 / 26.452210 ' #  Multiplier = (2 * PI * r_rpv_outer) / (2 * PI * r_rccs_panel_inner) --> Qrad_rpv * area_rpv = Qrad_rccs * area_rccs_inner
    execute_on = 'timestep_end'
  []
[]

[AuxVariables]
  [QRad]
    block = 'rccs-panel:hs0'
  []
  [QRad_multiplied]
    block = 'rccs-panel:hs0'
  []
[]
# ==========================================================
# - Components for coupling 1D to 2D flow model
# ==========================================================
[Components]
  [rccs-panel]
    type = PBCoupledHeatStructure
    position    = '0 0 0.0'
    orientation = '0 1 0'
    hs_type = cylinder

    length = 16.8
    width_of_hs = '0.1'
    radius_i = 4.21
    elem_number_radial = 5
    elem_number_axial = 50
    dim_hs = 2
    material_hs = 'ss-mat'
    Ts_init = ${T_inlet_rccs}

    HS_BC_type = 'Convective Coupled'
    qs_external_left = QRad_multiplied
    name_comp_right = rccs-heated-riser
    HT_surface_area_density_right = 158.748 #1.525027801   # PI * D / A(pipe1)
  []

  [rccs-heated-riser]
    type           = PBOneDFluidComponent
    A              = 0.170588 #17.7574
    Dh             = ${Dh_pipe} #0.031655 # From Roberto et al (2020)'s paper using total flow area and pipe number
    length         = 16.8
    n_elems        = 50
    orientation    = '0 1 0'
    position       = '4.31 0 0'
  []
  [rccs-chimney]
    type           = PBOneDFluidComponent
    A              = 0.170588 #17.7574
    Dh             = ${Dh_pipe}
    length         = 10
    n_elems        = 50
    orientation    = '0 1 0'
    position       = '4.31 16.8 0'
  []
  [rccs-downcomer]
    type           = PBOneDFluidComponent
    A              = 0.170588 #17.7574
    Dh             = ${Dh_pipe}
    length         = 26.8
    n_elems        = 50
    orientation    = '0 1 0'
    position       = '5.31 0 0'
  []
  [rccs-downcomer-horizontal]
    type           = PBOneDFluidComponent
    A              = 0.170588 #17.7574
    Dh             = ${Dh_pipe}
    length         = 1
    n_elems        = 5
    orientation    = '1 0 0'
    position       = '4.31 0 0'
  []
  [junc-riser-chimney]
    type = PBVolumeBranch
    eos = eos
    inputs = 'rccs-heated-riser(out)'
    outputs = 'rccs-chimney(in)'
    K = '0 0'
    Area = 0.170588 #17.7574
    center = '4.31 16.8 0'
    volume = 0.01
  []
  [junc-horizontal-riser]
    type = PBVolumeBranch
    eos = eos
    inputs = 'rccs-downcomer-horizontal(out)'
    outputs = 'rccs-heated-riser(in)'
    K = '0 0'
    Area = 0.170588 #17.7574
    center = '4.31 0 0'
    volume = 0.01
  []
  [junc-downcomer-horizontal]
    type = PBVolumeBranch
    eos = eos
    inputs = 'rccs-downcomer(in)'
    outputs = 'rccs-downcomer-horizontal(in)'
    K = '0 0'
    Area = 0.170588 #17.7574
    center = '5.31 0 0'
    volume = 0.01
  []


  # RCCS pool and HX
  [pool]
    type = PBLiquidVolume
    center = '4.81 29.3 0'
    outputs = 'rccs-chimney(out) rccs-downcomer(out) IHX-inlet-pipe(in) IHX-outlet-pipe(out)'
    K = '0 0 0 0'
    orientation = '0 1 0'
    Area = 30
    volume = 300

    initial_T = 303 #${T_inlet}
    initial_level = 10 # 5
    ambient_pressure = 1.01325e5
    eos = eos
    width = 1
    height = 5
  []

  # The actual RCCS has a cooling tower. Here we are
  # using a heat exchanger to remove heat from the RCCS.
  [IHX]
    type                              = PBHeatExchanger
    HX_type                           = Countercurrent
    eos_secondary                     = eos
    position                          = '4.81 31.8 0'
    orientation                       = '0 -1 0'
    A                                 = 0.36571
    Dh                                = 0.0108906
    PoD                               = 1.17
    HTC_geometry_type                 = Bundle
    length                            = 5
    n_elems                           = 10
    HT_surface_area_density           = 734.582
    A_secondary                       = 0.603437
    Dh_secondary                      = 0.0196
    length_secondary                  = 5
    HT_surface_area_density_secondary = 408.166
    hs_type                           = cylinder
    radius_i                          = 0.0098
    wall_thickness                    = 0.000889
    n_wall_elems                      = 3
    material_wall                     = ss-mat
    Twall_init                        = 303
    initial_T_secondary               = 303
    initial_P_secondary               = 1e5
    initial_V_secondary               = -100
    SC_HTC                            = 2.5
    SC_HTC_secondary                  = 2.5
    disp_mode                         = -1
    eos = eos
  []
  [IHX-inlet-pipe]
    type = PBOneDFluidComponent
    input_parameters = CoolantChannel
    position = '4.81 29.3 -1'
    orientation = '0 0 1'
    length = 1
    A = 0.170588481  # Assume 1 cm wide from r = 2.71 to 2.72
    Dh = 2
    HTC_geometry_type = Pipe
    n_elems = 10
    eos = eos
    initial_T = 303
  []

  [IHX-outlet-pipe]
    type = PBOneDFluidComponent
    input_parameters = CoolantChannel
    position = '4.81 26.8 0'
    orientation = '0 0 -1'
    length = 1
    A = 0.170588481  # Assume 1 cm wide from r = 2.71 to 2.72
    Dh = 2
    HTC_geometry_type = Pipe
    n_elems = 10
    eos = eos
    initial_T = 303
  []
  [IHX-junc-out]
    type = PBSingleJunction
    eos = eos
    inputs = 'IHX(primary_out)'
    outputs = 'IHX-outlet-pipe(in)'
    initial_T = 303
  []
  [IHX-junc-in]
    type = PBVolumeBranch
    center = '2.72 27.8 6'
    inputs = 'IHX-inlet-pipe(out)'
    outputs = 'IHX(primary_in)'
    K = '0 0'
    Area = 0.170588481
    volume = 0.01
    width = 0.02049
    height = 0.3
    eos = eos
  []
  [IHX2-in]
    type  = PBTDJ
    v_bc  = -100
    T_bc  = 303
    eos   = eos
    input = 'IHX(secondary_in)'
  []
  [IHX2-out]
    type  = PBTDV
    eos   = eos
    p_bc  = 1e5
    input = 'IHX(secondary_out)'
  []
[]

[UserObjects]
  [TRad_UO]
    type = LayeredSideAverage
    variable = T_solid
    direction = y
    num_layers = 45
    boundary = 'rccs-panel:inner_wall'
    execute_on = 'timestep_end'
    use_displaced_mesh = true
  []
[]


[Postprocessors]
  [mflow_HX_primary]
    type     = ComponentBoundaryFlow
    input    = 'IHX(primary_in)'
  []
  [Tf_HX_in]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = 'IHX(primary_in)'
  []
  [Tf_HX_out]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = 'IHX(primary_out)'
  []
  [mflow_rccs]
    type     = ComponentBoundaryFlow
    input    = 'rccs-heated-riser(in)'
  []
  # temperature
  [Tf_riser_in]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = rccs-heated-riser(in)
  []
  [Tf_riser_out]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = rccs-heated-riser(out)
  []
  [HeatInCore]
    type = ComponentBoundaryEnergyBalance
    input = 'rccs-heated-riser(in) rccs-heated-riser(out)'
    eos = eos
  []

  [Tf_chimney_in]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = rccs-chimney(in)
  []
  [Tf_chimney_out]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = rccs-chimney(out)
  []


  [Tf_downcomer_in]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = rccs-downcomer(in)
  []
  [Tf_downcomer_out]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = rccs-downcomer(out)
  []

[]

[Preconditioning]
  [SMP_PJFNK]
    type = SMP
    full = true
    solve_type = 'PJFNK'
    petsc_options_iname = '-pc_type -ksp_gmres_restart'
    petsc_options_value = 'lu 100'
  []
[]

[Executioner]
  type = Transient
  dtmin = 1e-6
  dtmax = 500

  [TimeStepper]
    type = IterationAdaptiveDT
    growth_factor = 1.25
    optimal_iterations = 10
    linear_iteration_ratio = 100
    dt = 0.1
    cutback_factor = 0.8
    cutback_factor_at_failure = 0.8
  []

  nl_rel_tol = 1e-6
  nl_abs_tol = 1e-6
  nl_max_its = 15
  l_tol = 1e-6
  l_max_its = 100

  start_time = -200000
  end_time = 0

  [Quadrature]
    type = TRAP
    order = FIRST
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
  # Commented out for git purpose
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
