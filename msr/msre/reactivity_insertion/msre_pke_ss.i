# MSRE Model for reactivity insertion test
# SAM input file for steady state initialization
# Application: SAM
# POC: Jun Fang (fangj at anl.gov)
# If using or referring to this model, please cite as explained in
# https://mooseframework.inl.gov/virtual_test_bed/citing.html

[GlobalParams]
  global_init_P = 2.392e5
  global_init_V = 1.0
  global_init_T = 905.4
  scaling_factor_var='1 1e-3 1e-6'
  [PBModelParams]
    p_order = 1
    Courant_control = true
  []
[]

[EOS]
  [eos]
    type  = PTConstantEOS
    cp    = 2384.88
    h_0   = 2.146E+06
    T_0   = 900
    mu    = 7.5237E-03
    k     = 1.0
    rho_0 = 2253.43
    beta  = 2.2765E-04
  []
  [eos_coolant]
    type  = PTConstantEOS
    cp    = 2384.88
    h_0   = 2.146E+06
    T_0   = 900
    mu    = 7.5237E-03
    k     = 1.0
    rho_0 = 2253.43
    beta  = 2.2765E-04
  []
[]

[Functions]
  [time_stepper]
    type = PiecewiseLinear
    x = '-1000.0   0.0'
    y = '    1.0  10.0'
  []

  [ext_rho]
    type = PiecewiseConstant
    x = '-1000.0    0.0'
    y = '    0.0    0.0'
  []
[]

[MaterialProperties]
  [ss-mat]
    type = SolidMaterialProps
    k   = 18.7
    Cp  = 638
    rho = 6e3
  []
  [graphite]
    type = SolidMaterialProps
    k    =   90.0
    Cp   = 1642.9
    rho  = 1870.0
  []
[]

[Components]
  [reactor]
    type = ReactorPower
    initial_power = 5.0E6
    pke           = 'pke1'
  []
  [pke1]
    type                         = PointKinetics
    rho_fn_name                  = ext_rho
    lambda                       = '0.0126 0.0337 0.138 0.325 1.13 2.50'
    LAMBDA                       = 4.0E-4
    betai                        = '2.28E-04 7.88E-04 6.64E-04 7.36E-04 1.36E-04 8.8E-05'
    Moving_DNP_bypass_channels   = 'ch2 uplnm iplnm'
    feedback_components          = 'ch2 moderator'
    feedback_start_time          = 0
  []
  #
  # ====== downcomer ======
  #
  [downcomer]
    type           = PBOneDFluidComponent
    A              = 0.1589
    Dh             = 0.0508
    length         = 1.7272
    n_elems        = 40
    orientation    = '0 0 -1'
    position       = '0 0 0'
    eos            = eos
  []
  [j_dn_pl]
    type    = PBBranch
    Area    = 0.1155
    K       = '0.0 0.0'
    eos     = eos
    inputs  = 'downcomer(out)'
    outputs = 'iplnm(in)'
  []
  #
  # ====== inlet plenum ======
  #
  [iplnm]
    type           = PBMoltenSaltChannel
    A              = 0.3932
    Dh             = 0.6997
    length         = 0.7366
    n_elems        = 15
    orientation    = '1 0 0'
    position       = '0 0 -1.7272'
    eos            = eos
    power_fraction = '0.0859'
  []
  [j_pl_c]
    type    = PBBranch
    Area    = 0.01015
    K       = '0.0 0.0'
    eos     = eos
    inputs  = 'iplnm(out)'
    outputs = 'ch2(in)'
  []
  #
  # ====== core channel ======
  #
  # core channel excluding center
  [ch2]
    type               = PBMoltenSaltChannel
    A                  = 0.4149
    Dh                 = 0.01585
    length             = 1.7272
    n_elems            = 40
    orientation        = '0 0 1'
    position           = '0.7366 0.0 -1.7272'
    eos                = eos
    power_fraction     = '0.8752'
    coolant_density_reactivity_feedback = False
    n_layers_coolant                    = 20
    coolant_reactivity_coefficients     = -3.0014E-04
  []
  [moderator]
    type               = PBCoupledHeatStructure
    position           = '0 0 0'
    orientation        = '0.7366 0.0 -1.7272'
    hs_type            = plate
    length             = 1.7272
    depth_plate        = 44.54
    width_of_hs        = 0.0254
    elem_number_radial = 2
    elem_number_axial  = 40
    dim_hs             = 2
    material_hs        = 'graphite'
    Ts_init            = 905.4
    HS_BC_type         = 'Coupled  Adiabatic'
    name_comp_left     = ch2
    moderator_reactivity_feedback     = False
    n_layers_moderator                = 20
    moderator_reactivity_coefficients = -2.9070E-06
  []

  [j_c_up]
    type    = PBBranch
    Area    = 0.01015
    K       = '0.0 0.0'
    eos     = eos
    inputs  = 'ch2(out)'
    outputs = 'uplnm(in)'
  []
  #
  # ====== upper plenum ======
  #
  [uplnm]
    type           = PBMoltenSaltChannel
    A              = 0.3442
    Dh             = 0.6621
    length         = 0.8636
    n_elems        = 17
    orientation    = '0 0 1'
    position       = '0.7366 0 0.0'
    eos            = eos
    power_fraction = '0.0389'
  []
  [j_up_p0]
    type    = PBBranch
    Area    = 0.01292
    K       = '0.0 0.0'
    eos     = eos
    inputs  = 'uplnm(out)'
    outputs = 'p100_s1(in)'
  []
  #
  # ====== pipe 100 connecting core to pump ======
  #
  [p100_s1] # horizontal section
    type = PBOneDFluidComponent
    A           = 0.02309
    Dh          = 0.1283
    length      = 1.8288
    n_elems     = 40
    orientation = '1 0 0'
    position    = '0.7366 0.0 0.8636'
    eos         = eos
  []
  [j1]
    type    = PBBranch
    Area    = 0.01292
    K       = '0.0 0.0 0.0'
    eos     = eos
    inputs  = 'p100_s1(out) bc_in(out)'
    outputs = 'p100_s2(in)'
  []
  [p100_s2] # vertical section,
    type = PBOneDFluidComponent
    A           = 0.02309
    Dh          = 0.1283
    length      = 0.8128
    n_elems     = 16
    orientation = '0 0 1'
    position    = '2.5654 0.0 0.8636'
    eos         = eos
  []
  #
  # ====== pump ======
  #
  [pump]
    type      = PBPump
    Area      = 0.01292
    K         = '0.0 0.0'
    K_reverse = '100.0 100.0'
    eos       = eos
    inputs    = 'p100_s2(out)'
    outputs   = 'p101(in)'
    Head      = 285402.5
  []
  #
  # ====== pipe 101 connecting pump to heat exchanger ======
  #
  [p101]
    type = PBOneDFluidComponent
    A           = 0.02144
    Dh          = 0.1283
    length      = 1.0668
    n_elems     = 20
    orientation = '-1 0 0'
    position    = '2.5654 0.0 1.6764'
    eos         = eos
    f           = 0.0
  []
  [j4] # junction connect to heat exchanger
    type = PBBranch
    Area    = 0.01292
    K       = '0.0 0.0'
    eos     = eos
    inputs  = 'p101(out)'
    outputs = 'hx(primary_in)'
  []
  #
  # ====== heat exchanger ======
  #
  [hx]
    type                              = PBHeatExchanger
    HX_type                           = Concurrent
    orientation                       = '-1 0 0'
    position                          = '1.4986 0.0 1.6764'
    eos                               = eos
    eos_secondary                     = eos_coolant
    A                                 = 8.9434E-02
    Dh                                = 6.7778E-02
    length                            = 2.5298
    HT_surface_area_density           = 83.21
    Hw                                = 19874.0

    A_secondary                       = 0.01394
    Dh_secondary                      = 0.01057
    length_secondary                  = 2.5298
    HT_surface_area_density_secondary = 533.77
    Hw_secondary                      = 28000.0

    n_elems                           = 50
    end_elems_refinement              = 10
   initial_V_secondary               = 3.5

    Twall_init                        = 904.5
    wall_thickness                    = 1.0668E-03
    dim_wall                          = 2
    material_wall                     = ss-mat
    n_wall_elems                      = 2
  []
  [j5]
    type = PBBranch
    Area    = 0.01292
    K       = '0.0 0.0'
    eos     = eos
    inputs  = 'hx(primary_out)'
    outputs = 'p102_s1(in)'
  []
  #
  # ====== pipe 102 connecting heat exchanger to downcomer ======
  #
  [p102_s1]
    type = PBOneDFluidComponent
    A           = 0.02252
    Dh          = 0.1283
    length      = 1.6764
    n_elems     = 30
    orientation = '0 0 -1'
    position    = '-1.0312 0.0 1.6764'
    eos         = eos
  []
  [j6]
    type = PBBranch
    Area    = 0.01292
    K       = '0.0 0.0'
    eos     = eos
    inputs  = 'p102_s1(out)'
    outputs = 'p102_s2(in)'
  []
  [p102_s2]
    type = PBOneDFluidComponent
    A           = 0.02252
    Dh          = 0.1283
    length      = 1.0312
    n_elems     = 20
    orientation = '1 0 0'
    position    = '-1.0312 0.0 0.0'
    eos         = eos
  []
  [j7]
    type = PBBranch
    Area    = 0.01292
    K       = '21.7 0.0'
    eos     = eos
    inputs  = 'p102_s2(out)'
    outputs = 'downcomer(in))'
  []
  #
  # ====== boundary condiction ======
  #
  [bc_in]
    type        = PBOneDFluidComponent
    A           = 0.01292
    Dh          = 0.1283
    length      = 0.1
    n_elems     = 1
    orientation = '0 1 0'
    position    = '2.5654 -0.1 0.8636'
    eos         = eos
    f           = 0.0
  []
  [inlet]
    type  = PBTDV
    eos   = eos
    T_bc  = 905.4
    p_bc  = 2.392e5
    input = 'bc_in(in)'
  []
  [hx_in]
    type  = PBTDJ
    eos   = eos_coolant
    T_bc  = 819.3
    v_bc  = 3.5
    input = 'hx(secondary_in)'
  []
  [hx_out]
    type  = PBTDV
    eos   = eos_coolant
    p_bc  = 1.013E5
    input = 'hx(secondary_out)'
  []
[]

[Postprocessors]
  [dnp_den]
    type     = ElementAverageValue
    block    = 'ch2'
    variable = fml1
  []
  [mdot]
    type = ComponentBoundaryFlow
    input = ch2(in)
  []
[]

[Preconditioning]
  active = 'SMP_PJFNK'
  [SMP_PJFNK]
    type = SMP
    # type = FDP
    full = true
    solve_type = 'PJFNK'
    petsc_options_iname = '-pc_type -pc_factor_shift_type'
    petsc_options_value = 'lu       NONZERO'
  []
[]

[Executioner]
  type                = Transient
  scheme              = implicit-euler
  dtmin=1.0E-4
  [TimeStepper]
    type = FunctionDT
    function = time_stepper
    min_dt = 1e-3
  []
  start_time          = -2000
  end_time            = 0
  petsc_options_iname = '-ksp_gmres_restart'
  petsc_options_value = '100'
  nl_rel_tol = 1e-11
  nl_abs_tol = 3e-10
  nl_max_its = 30
  l_tol      = 1e-6
  l_max_its  = 100
  [Quadrature]
    # type  = TRAP
    # order = FIRST
    # type  = GAUSS
    # order = SECOND
  []
[]

[Outputs]
  print_linear_residuals = false
  [out_displaced]
    type = Exodus
    use_displaced = true
    execute_on = 'initial timestep_end'
    sequence = false
  []
  [ckpt]
    type      = Checkpoint
    num_files = 1
  []
  [console]
    type = Console
  []
  [csv]
    type = CSV
  []
  perf_graph = true
[]
