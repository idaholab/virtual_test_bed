# Modeling the MSRE
# Steady state simulation
# Application : SAM

[GlobalParams]
  global_init_P = 1e5                        # Global initial fluid pressure
  global_init_V = 0.001                      # Global initial fluid velocity
  global_init_T = 908.15                     # Global initial temperature for fluid and solid
  Tsolid_sf     = 1e-3
  gravity       = '0 -9.8 0'
  [./PBModelParams]
    pbm_scaling_factors = '1 1e-3 1e-6'
    p_order             = 2
  [../]
[]

[Functions]
  [./fuel_salt_rho_func] # Linear fitting used by He, 2016
    type = PiecewiseLinear
    x    = '750       1200'
    y    = '2285.31   2032.41'
  [../]
  [./fuel_salt_enthalpy_func] # Approximated by Cp*T
    type = PiecewiseLinear
    x    = '750        1200'
    y    = '1.51E+06   2.41E+06'
  [../]
  [./fuel_salt_mu_func]
    type = PiecewiseLinear
    x    = '750  760  770  780  790  800  810  820
            830  840  850  860  870  880  890  900
            910  920  930  940  950  960  970  980
            990  1000 1010 1020 1030 1040 1050 1060
            1070 1080 1090 1100 1110 1120 1130 1140
            1150 1160 1170 1180 1190 1200'
    y    = '2.7378E-02 2.5371E-02 2.3557E-02 2.1915E-02 2.0424E-02 1.9069E-02 1.7834E-02 1.6706E-02
            1.5674E-02 1.4728E-02 1.3859E-02 1.3060E-02 1.2324E-02 1.1645E-02 1.1017E-02 1.0436E-02
            9.8976E-03 9.3976E-03 8.9328E-03 8.5001E-03 8.0969E-03 7.7206E-03 7.3690E-03 7.0402E-03
            6.7322E-03 6.4434E-03 6.1724E-03 5.9178E-03 5.6783E-03 5.4529E-03 5.2404E-03 5.0400E-03
            4.8508E-03 4.6720E-03 4.5029E-03 4.3428E-03 4.1911E-03 4.0473E-03 3.9109E-03 3.7813E-03
            3.6582E-03 3.5411E-03 3.4297E-03 3.3235E-03 3.2224E-03 3.1259E-03'
  [../]
[]

[EOS]
  [./fuel_salt_eos]
    type     = PTFunctionsEOS
    rho      = fuel_salt_rho_func
    mu       = fuel_salt_mu_func
    enthalpy = fuel_salt_enthalpy_func
    cp       = 2009.66
    k        = 1.0
  [../]
  [./hx_salt_eos]
    type      = SaltEquationOfState
    salt_type = Flibe
  [../]
[]

[MaterialProperties]
  [./alloy-mat]                              # Based on Hastelloy N alloy
    type = SolidMaterialProps
    k    = 23.6                              # Thermal conductivity
    Cp   = 578                               # Specific heat
    rho  = 8.86e3                            # Density
  [../]
[]

[Components]
  [./downcomer]
    type           = PBOneDFluidComponent
    A              = 0.1589
    Dh             = 0.0508
    length         = 1.7272
    n_elems        = 18
    orientation    = '0 -1 0'
    position       = '-0.7366 1.7272 0'
    eos            = fuel_salt_eos
  [../]
  [./j_dn_pl]
    type    = PBBranch
    Area    = 0.1155
    K       = '0.0 0.0'
    eos     = fuel_salt_eos
    inputs  = 'downcomer(out)'
    outputs = 'iplnm(in)'
  [../]
  [./iplnm]        # inlet plenum is connected to core bottom
    type           = PBOneDFluidComponent
    A              = 0.3932
    Dh             = 0.6997
    length         = 0.7366
    n_elems        = 8
    orientation    = '1 0 0'
    position       = '-0.7366 0 0'
    eos            = fuel_salt_eos
  [../]

  [./j_ip_c]
    type    = PBBranch
    Area    = 0.1155
    K       = '0.0 0.0'
    eos     = fuel_salt_eos
    inputs  = 'iplnm(out)'
    outputs = 'core(in)'
  [../]

  [./core]         # 1-D representation of the core
    type           = PBOneDFluidComponent
    A              = 0.3512 # consider a porosity of 0.225
    Dh             = 0.6687
    length         = 1.7272
    n_elems        = 20
    orientation    = '0 1 0'
    position       = '0 0 0'
    eos            = fuel_salt_eos
    heat_source    = 1.65e7
  [../]

  [./j_c_up]
    type    = PBBranch
    Area    = 0.1155
    K       = '0.0 0.0'
    eos     = fuel_salt_eos
    inputs  = 'core(out)'
    outputs = 'uplnm(in)'
  [../]

  [./uplnm]        # upper plenum is connected to core exit
    type           = PBOneDFluidComponent
    A              = 0.3932
    Dh             = 0.6997
    length         = 0.4346
    n_elems        = 6
    orientation    = '0 1 0'
    position       = '0 1.7272 0'
    eos            = fuel_salt_eos
  [../]

  [./j_up_ps1]
    type    = PBBranch
    Area    = 0.1155
    K       = '0.0 0.0'
    eos     = fuel_salt_eos
    inputs  = 'uplnm(out)'
    outputs = 'pipe1_s1(in)'
  [../]

  [./pipe1_s1]  # Connecting core to pump, horizontal section
    type        = PBOneDFluidComponent
    A           = 0.01267
    Dh          = 0.127
    length      = 1.8288
    n_elems     = 19
    orientation = '1 0 0'
    position    = '0 2.1618 0'
    eos         = fuel_salt_eos
  [../]

  [./j1]
    type    = PBBranch
    Area    = 0.01292
    K       = '0.0 0.0'
    eos     = fuel_salt_eos
    inputs  = 'pipe1_s1(out)'
    outputs = 'pipe1_s2(in)'
  [../]

  [./pipe1_s2]  # vertical section
    type        = PBOneDFluidComponent
    A           = 0.01267
    Dh          = 0.127
    length      = 0.8128
    n_elems     = 9
    orientation = '0 1 0'
    position    = '1.8288 2.1618 0'
    eos         = fuel_salt_eos
  [../]

  #
  # ====== pump ======
  #

  [./pump]
    type      = PBPump
    Area      = 0.01292
    K         = '0.15 0.1'
    eos       = fuel_salt_eos
    inputs    = 'pipe1_s2(out)'
    outputs   = 'pipe2(in)'
    initial_P = 1.1e5
  # Head_fn   = f_pump_head
    Head      = 43909.58
  []

  [./pipe2]     # Connecting the pump to HX
    type        = PBOneDFluidComponent
    A           = 0.01267
    Dh          = 0.127
    length      = 1.0668
    n_elems     = 11
    orientation = '-1 0 0'
    position    = '1.8288 2.9746 0'
    eos         = fuel_salt_eos
  [../]
  [./j2]    # junction connect to heat exchanger
    type    = PBBranch
    Area    = 0.01267
    K       = '0.0 0.0'
    eos     = fuel_salt_eos
    inputs  = 'pipe2(out)'
    outputs = 'hx_shell(in)'
  [../]

  #
  # ====== Customized U-tube heat exchanger ======
  #
  [./hx_shell]
    type        = PBOneDFluidComponent
    position    = '0.762 2.9746 0'
    orientation = '-1 0 0'
    length      = 2.5298
    n_elems     = 26
    eos         = fuel_salt_eos
    heat_source = 0
    A           = 1.0183E-01
    Dh          = 2.0945E-02
  [../]

  [./hx_tube1]
    type        = PBOneDFluidComponent
    position    = '-1.7678 3.0762 0'
    orientation = '1 0 0'
    length      = 2.5298
    n_elems     = 26
    eos         = hx_salt_eos
    heat_source = 0
    A           = 2.7885E-02
    Dh          = 1.0566E-02
    initial_T   = 824.8167
  [../]
  [./hx_j1]
    type      = PBBranch
    eos       = hx_salt_eos
    inputs    = 'hx_tube1(out)'
    outputs   = 'hx_tube2(in)'
    K         = '0 0'
    Area      = 2.7885E-02
    initial_T = 824.8167
  [../]
  [./hx_tube2]
    type        = PBOneDFluidComponent
    position    = '0.762 3.0762 0'
    orientation = '0 -1 0'
    length      = 0.2032
    n_elems     = 2
    eos         = hx_salt_eos
    heat_source = 0
    A           = 2.7885E-02
    Dh          = 1.0566E-02
    initial_T   = 824.8167
  [../]
  [./hx_j2]
    type      = PBBranch
    eos       = hx_salt_eos
    inputs    = 'hx_tube2(out)'
    outputs   = 'hx_tube3(in)'
    K         = '0 0'
    Area      = 2.7885E-02
    initial_T = 824.8167
  [../]
  [./hx_tube3]
    type        = PBOneDFluidComponent
    position    = '0.762 2.873 0'
    orientation = '-1 0 0'
    length      = 2.5298
    n_elems     = 26
    eos         = hx_salt_eos
    heat_source = 0
    A           = 2.7885E-02
    Dh          = 1.0566E-02
    initial_T   = 824.8167
  [../]

  [./hx_s_in]
    type  = PBTDJ
    input = 'hx_tube1(in)'
    eos   = hx_salt_eos
    v_bc  = 1.6
    T_bc  = 824.8167
  [../]
  [./hx_s_out]
    type  = PBTDV
    input = 'hx_tube3(out)'
    eos   = hx_salt_eos
    p_bc  = 1.0e5
    T_bc  = 866.4833
  [../]

  [./hx_wall1]
    type               = PBCoupledHeatStructure
    position           = '-1.7678 3.0762 0'
    orientation        = '1 0 0'
    length             = 2.5298
    hs_type            = cylinder
    radius_i           = 5.2832E-03
    width_of_hs        = 1.0668E-03
    elem_number_radial = 2
    elem_number_axial  = 26
    dim_hs             = 2
    material_hs        = 'alloy-mat'
    Ts_init            = 824.8167

    HS_BC_type                    = 'Coupled Coupled'
    name_comp_left                = hx_tube1
    HT_surface_area_density_left  = 8.6290E+02
    name_comp_right               = hx_shell
    HT_surface_area_density_right = 2.3629E+02
  [../]

  [./hx_wall2]
    type               = PBCoupledHeatStructure
    position           = '0.762 2.873 0'
    orientation        = '-1 0 0'
    length             = 2.5298
    hs_type            = cylinder
    radius_i           = 5.2832E-03
    width_of_hs        = 1.0668E-03
    elem_number_radial = 2
    elem_number_axial  = 26
    dim_hs             = 2
    material_hs        = 'alloy-mat'
    Ts_init            = 824.8167

    HS_BC_type                    = 'Coupled Coupled'
    name_comp_left                = hx_tube3
    HT_surface_area_density_left  = 8.6290E+02
    name_comp_right               = hx_shell
    HT_surface_area_density_right = 2.3629E+02
  [../]

  [./j3]
    type    = PBBranch
    Area    = 0.01267
    K       = '0.0 1e3 0.0'
    eos     = fuel_salt_eos
    inputs  = 'hx_shell(out) pipe_ref(out)'
    outputs = 'pipe3_s1(in)'
  [../]

  [./pipe_ref]
    type        = PBOneDFluidComponent
    A           = 0.01267
    Dh          = 0.127
    length      = 0.1
    n_elems     = 2
    orientation = '1 0 0'
    position    = '-1.8678 2.9746 0'
    eos         = fuel_salt_eos
  [../]
  [./ref_p]
    type  = PBTDV
    eos   = fuel_salt_eos
    T_bc  = 908.15
    p_bc  = 1.233351e+05
    input = 'pipe_ref(in)'
  [../]

  [./pipe3_s1]  # Connecting hx to downcomer
    type        = PBOneDFluidComponent
    A           = 0.01267
    Dh          = 0.127
    length      = 1.2474
    n_elems     = 13
    orientation = '0 -1 0'
    position    = '-1.7678 2.9746 0'
    eos         = fuel_salt_eos
  [../]

  [./j4]
    type    = PBBranch
    Area    = 0.01267
    K       = '0.0 0.0'
    eos     = fuel_salt_eos
    inputs  = 'pipe3_s1(out)'
    outputs = 'pipe3_s2(in)'
  [../]

  [./pipe3_s2]
    type        = PBOneDFluidComponent
    A           = 0.01267
    Dh          = 0.127
    length      = 1.0312
    n_elems     = 11
    orientation = '1 0 0'
    position    = '-1.7678 1.7272 0'
    eos         = fuel_salt_eos
  [../]

  [./j5]
    type    = PBBranch
    Area    = 0.01267
    K       = '0.0 0.0'
    eos     = fuel_salt_eos
    inputs  = 'pipe3_s2(out)'
    outputs = 'downcomer(in)'
  [../]
[]

[Postprocessors]
  [./Core_P_out]                               # Pressure at Core outlet/Loop inlet
    type     = ComponentBoundaryVariableValue
    variable = pressure
    input    = core(out)
  [../]
  [./Core_vel_in]
    type     = ComponentBoundaryVariableValue
    variable = velocity
    input    = core(in)
  [../]
  [./Core_T_out]
    type     = ComponentBoundaryVariableValue
    variable = temperature
    input    = core(out)
  [../]
  [./Core_T_in]
    type     = ComponentBoundaryVariableValue
    variable = temperature
    input    = core(in)
  [../]
  [./Core_P_in]
    type     = ComponentBoundaryVariableValue
    variable = pressure
    input    = core(in)
  [../]
  [./HX_Tin_p]
    type     = ComponentBoundaryVariableValue
    variable = temperature
    input    = hx_shell(in)
  [../]
  [./HX_Tout_p]
    type     = ComponentBoundaryVariableValue
    variable = temperature
    input    = hx_shell(out)
  [../]
[]

[Preconditioning]
  [./SMP_PJFNK]
    type                = SMP
    full                = true
    solve_type          = 'PJFNK'
    # pc_factor_shift are added automatically by SAM, they are added here for BlueCRAB
    petsc_options_iname = '-pc_type -ksp_gmres_restart -pc_factor_shift_type -pc_factor_shift_amount'
    petsc_options_value = 'lu 101 NONZERO 1e-9'
  [../]
[]

#[Problem]
#  restart_file_base = loop_1d_checkpoint_cp/0254
#[]

[Executioner]
  type       = Transient
  dt         = 0.2
  dtmin      = 1.e-3
  dtmax      = 10.0
  nl_rel_tol = 1e-8
  nl_abs_tol = 1e-6
  nl_max_its = 10
  l_tol      = 1e-6
  l_max_its  = 200
  start_time = 0
  end_time   = 300
  num_steps  = 100000
  [./Quadrature]
    type  = SIMPSON
    order = SECOND
  [../]
[]

[Outputs]
  print_linear_residuals = false
  perf_graph             = true
  [./out_displaced]
    type          = Exodus
    use_displaced = true
    execute_on    = 'initial timestep_end'
    sequence      = false
  [../]
  [./csv]
    type = CSV
  [../]
  [./checkpoint]
    type      = Checkpoint
    num_files = 1
  [../]
  [./console]
    type               = Console
    execute_scalars_on = 'none'
  [../]
[]
