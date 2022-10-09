################################################################################
## Molten Salt Fast Reactor - Euratom EVOL + Rosatom MARS Design              ##
## SAM Sub-Sub-Application input file                                         ##
## Partial pump trip transient                                                ##
################################################################################

core_power_val = 3e9

[GlobalParams]
  global_init_P = 1e5
  global_init_V = 0.01
  global_init_T = 950.0
  Tsolid_sf     = 1e-3
  [./PBModelParams]
    pbm_scaling_factors = '1 1e-3 1e-6'
#    p_order             = 2
  [../]
[]

[Functions]
  [./fuel_salt_rho_func] # Linear fitting used by Rouch et al. 2014
    type = PiecewiseLinear
    x = '800 1200'
    y = '4277.96 3925.16'
  [../]
  [./fuel_salt_cp_func]
    type = PiecewiseLinear
    x = '800 1200'
    y = '1113.00 2225.00'
  [../]
  [./fuel_salt_k_func]
    type = PiecewiseLinear
    x = '800 1200'
    y = '0.995200 1.028800'
  [../]
  [./fuel_salt_mu_func] # Nonlinear fitting used by Rouch et al. 2014
    type = PiecewiseLinear
    x = '       800         820         840         860         880         900
                920         940         960         980         1000        1020
               1040        1060        1080        1100        1120        1140
               1160        1180        1200'
    y = '2.3887E-02  2.1258E-02  1.9020E-02  1.7102E-02  1.5449E-02  1.4015E-02
         1.2767E-02  1.1673E-02  1.0711E-02  9.8609E-03  9.1066E-03  8.4347E-03
         7.8340E-03  7.2951E-03  6.8099E-03  6.3719E-03  5.9751E-03  5.6147E-03
         5.2865E-03  4.9868E-03  4.7124E-03'
  [../]
  [./fuel_salt_enthalpy_func] # approximated by cp*T
    type = PiecewiseLinear
    x = '   800     820     840     860     880     900
            920     940     960     980    1000    1020
           1040    1060    1080    1100    1120    1140
           1160    1180    1200'
    y = '890400  913216  937144  962184  988336 1015600
        1043976 1073464 1104064 1135776 1168600 1202536
        1237584 1273744 1311016 1349400 1388896 1429504
        1471224 1514056 1558000'
  [../]
  [./TimeStepperFunc]
    type = PiecewiseLinear
    x = '-200    -180   -160   -140   -100    -60     -50  -20  -10.  0.0  1000'
    y = ' 0.05    0.1    0.2    0.5    1.0    10.0     50.  10.  1.0   0.1 0.1'
  [../]
  [core_specific_power]
    type = ParsedFunction
    value = 'core_power / 9.27'
    vars = 'core_power'
    vals = 'core_power'
  []
[]

[EOS]
  [./fuel_salt_eos]
    type = PTFunctionsEOS
    rho  = fuel_salt_rho_func
    beta = 2.1051E-04 # approximated by -(drho/dT)/rho
    cp   = fuel_salt_cp_func
    mu   = fuel_salt_mu_func
    k    = fuel_salt_k_func
    enthalpy = fuel_salt_enthalpy_func
  [../]
  [./hx_salt_eos]
    type      = SaltEquationOfState
    salt_type = Flibe
  [../]
  [./Helium]
    type = HeEquationOfState
  [../]
[]

[MaterialProperties]
  [./alloy-mat] # Based on Hastelloy N alloy
    type = SolidMaterialProps
    k    = 23.6
    Cp   = 578
    rho  = 8.86e3
  [../]
[]

[Components]
  [./MSFR_core]
    type           = PBOneDFluidComponent
    eos            = fuel_salt_eos
    orientation    = '0 0 1'
    position       = '0 0 0'
    A              = 3.4636
    Dh             = 2.1
    length         = 2.65
    n_elems        = 25
    heat_source    = 'core_specific_power'
  [../]

  [./Core_Out_Branch]
    type    = PBBranch
    inputs  = 'MSFR_core(out)'
    outputs = 'pipe1(in) loop_pbc(in)'
    eos     = fuel_salt_eos
    K       = '4.25 4.25 500.'
    Area    = 2.24
  [../]

  [./pipe1] # Horizontal hot channel
    type        = PBOneDFluidComponent
    eos         = fuel_salt_eos
    position    = '0 0 2.65'
    orientation = '0 1 0'

    A           = 2.24
    Dh          = 1.6888
    length      = 2.0
    n_elems     = 12
  [../]

  [./loop_pbc]
    type        = PBOneDFluidComponent
    eos         = fuel_salt_eos
    position    = '0 0 2.65'
    orientation = '0 0 1'

    A           = 2.24
    Dh          = 1.6888
    length      = 0.025
    n_elems     = 1
  [../]

  [./TDV1]
    type        = PBTDV
    input       = 'loop_pbc(out)'
    eos         = fuel_salt_eos
    p_bc        = 1.0e5
  [../]

  #
  # ====== pump ======
  #

  [./pump]
    type      = PBPump
    Area      = 2.24
    K         = '0.15 0.1'
    eos       = fuel_salt_eos
    inputs    = 'pipe1(out)'
    outputs   = 'pipe2(in)'
    initial_P = 1.0e5
    Head      = 156010.45
  []

  [./pipe2] # Vertical hot channel from pump to HX
    type        = PBOneDFluidComponent
    eos         = fuel_salt_eos
    position    = '0 2.0 2.65'
    orientation = '0 0 -1'

    A           = 2.24
    Dh          = 1.6888
    length      = 0.25
    n_elems     = 3
  [../]

  [./J_P2_IHX1]
    type    = PBBranch
    inputs  = 'pipe2(out)'
    outputs = 'IHX1(primary_in) '
    eos     = fuel_salt_eos
    K       = '1. 1.'
    Area    = 2.24
  [../]

  #
  # ====== Heat Exchanger ======
  #

  [./IHX1]
    type                              = PBHeatExchanger
    eos                               = fuel_salt_eos
    eos_secondary                     = hx_salt_eos

    position                          = '0 2.0 2.4'
    orientation                       = '0 0 -1'
    A                                 = 2.24
    A_secondary                       = 3.60
    Dh                                = 0.02
    Dh_secondary                      = 0.0125
    length                            = 2.4
    n_elems                           = 24

    SC_HTC                            = 4
    HTC_geometry_type                 = Pipe
    HTC_geometry_type_secondary       = Pipe
    HT_surface_area_density           = 800.0
    HT_surface_area_density_secondary = 497.78

    initial_V_secondary               = -2.67
    Twall_init                        = 950.0
    wall_thickness                    = 0.001

    dim_wall                          = 1
    material_wall                     = alloy-mat
    n_wall_elems                      = 2
  [../]

  #
  # ====== Heat Exchanger Secondary Side ======
  #

 # [./IHX1_S_In]
 #   type  = PBTDJ
 #   input = 'IHX1(secondary_in)'
 #   eos   = hx_salt_eos
 #   v_bc  = -2.3482
 #   T_bc  = 888.15
 # [../]

 # [./IHX1_S_Out]
 #   type  = PBTDV
 #   input = 'IHX1(secondary_out)'
 #   eos   = hx_salt_eos
 #   p_bc  = 1.0e5
 # [../]

  [./IHX1_P3]
    type    = PBBranch
    inputs  = 'IHX1(primary_out)'
    outputs = 'pipe3(in) '
    eos     = fuel_salt_eos
    K       = '1. 1.'
    Area    = 2.24
  [../]

  [./pipe3] # Horizontal cold channel
    type        = PBOneDFluidComponent
    eos         = fuel_salt_eos
    position    = '0 2.0 0.'
    orientation = '0 -1 0'

    A           = 2.24
    Dh          = 1.6888
    length      = 2.0
    n_elems     = 12
  [../]

  [./Core_In_Branch]
    type    = PBBranch
    inputs  = 'pipe3(out)'
    outputs = 'MSFR_core(in)'
    eos     = fuel_salt_eos
    K       = '4.25 4.25'
    Area    = 2.24
  [../]

  #
  # ====== Intermediate circuit connected to HX1 ======
  #

  [./IHX1_P4]
    type    = PBBranch
    inputs  = 'IHX1(secondary_out)'
    outputs = 'pipe4(in), loop2_pbc(in)'
    eos     = hx_salt_eos
    K       = '4.25 4.25 500.'
    Area    = 3.6
  [../]

  [./loop2_pbc]
    type        = PBOneDFluidComponent
    eos         = hx_salt_eos
    position    = '0 2.0 2.4'
    orientation = '1 0 0'

    A           = 3.6
    Dh          = 2.14
    length      = 0.025
    n_elems     = 1
  [../]

  [./loop2_TDV1]
    type        = PBTDV
    input       = 'loop2_pbc(out)'
    eos         = hx_salt_eos
    p_bc        = 1.0e5
  [../]

  [./pipe4] # Horizontal intermediate hot leg
    type        = PBOneDFluidComponent
    eos         = hx_salt_eos
    position    = '0 2.0 2.4'
    orientation = '0 1 0'

    A           = 3.6
    Dh          = 2.14
    length      = 2.0
    n_elems     = 10
  [../]

  [./J_P4_P5]
    type    = PBBranch
    inputs  = 'pipe4(out)'
    outputs = 'pipe5(in)'
    eos     = hx_salt_eos
    K       = '1. 1.'
    Area    = 3.6
  [../]

  [./pipe5] # Vertical intermediate hot leg
    type        = PBOneDFluidComponent
    eos         = hx_salt_eos
    position    = '0 4.0 2.4'
    orientation = '0 0 -1'

    A           = 3.6
    Dh          = 2.14
    length      = 0.2
    n_elems     = 2
  [../]

  [./J_P5_IHX2]
    type    = PBBranch
    inputs  = 'pipe5(out)'
    outputs = 'IHX2(primary_in)'
    eos     = hx_salt_eos
    K       = '1. 1.'
    Area    = 3.6
  [../]

  [./IHX2]
    type                              = PBHeatExchanger
    eos                               = hx_salt_eos
    eos_secondary                     = Helium

    position                          = '0 4.0 2.2'
    orientation                       = '0 0 -1'
    A                                 = 2.4
    A_secondary                       = 7.2
    Dh                                = 0.04
    Dh_secondary                      = 0.01
    length                            = 3.2
    n_elems                           = 24

    SC_HTC                            = 4
    HTC_geometry_type                 = Pipe
    HTC_geometry_type_secondary       = Pipe
    HT_surface_area_density           = 510.0
    HT_surface_area_density_secondary = 170.0

    initial_V_secondary               = -50
    Twall_init                        = 900
    wall_thickness                    = 0.002

    dim_wall                          = 1
    material_wall                     = alloy-mat
    n_wall_elems                      = 2
  [../]

  [./IHX2_S_In]
    type  = PBTDJ
    input = 'IHX2(secondary_in)'
    eos   = Helium
    v_bc  = -66.65
    T_bc  = 673.15
  [../]

  [./IHX2_S_Out]
    type  = PBTDV
    input = 'IHX2(secondary_out)'
    eos   = Helium
    p_bc  = 7.5e6
  [../]

  [./J_IHX2_P6]
    type    = PBBranch
    inputs  = 'IHX2(primary_out)'
    outputs = 'pipe6(in)'
    eos     = hx_salt_eos
    K       = '1. 1.'
    Area    = 3.6
  [../]

  [./pipe6] # Intermediate cold leg
    type        = PBOneDFluidComponent
    eos         = hx_salt_eos
    position    = '0 4.0 -1.0'
    orientation = '0 -1 0'

    A           = 3.6
    Dh          = 2.14
    length      = 1.0
    n_elems     = 5
  [../]

  [./J_P6_P7]
    type    = PBBranch
    inputs  = 'pipe6(out)'
    outputs = 'pipe7(in)'
    eos     = hx_salt_eos
    K       = '1. 1.'
    Area    = 3.6
  [../]

  [./pipe7] # Intermediate cold leg
    type        = PBOneDFluidComponent
    eos         = hx_salt_eos
    position    = '0 3.0 -1.0'
    orientation = '0 0 1'

    A           = 3.6
    Dh          = 2.14
    length      = 1.0
    n_elems     = 5
  [../]

  [./pump2]
    type      = PBPump
    Area      = 3.6
    K         = '0.15 0.1'
    eos       = hx_salt_eos
    inputs    = 'pipe7(out)'
    outputs   = 'pipe8(in)'
    initial_P = 1.0e5
    Head      = 1.76e5
  []

  [./pipe8] # Intermediate cold leg
    type        = PBOneDFluidComponent
    eos         = hx_salt_eos
    position    = '0 3.0 0.0'
    orientation = '0 -1 0'

    A           = 3.6
    Dh          = 2.14
    length      = 1.0
    n_elems     = 5
  [../]

  [./P8_IHX1]
    type    = PBBranch
    inputs  = 'pipe8(out)'
    outputs = 'IHX1(secondary_in)'
    eos     = hx_salt_eos
    K       = '1. 1.'
    Area    = 3.6
  [../]
[]

#[AuxScalarKernels]
#  [heat_source_variable_cons]
#    type = ConstantScalarAux
#    variable = heat_source_variable
#    value = ${fparse core_power_val / 9.27}
#    execute_on = 'timestep_begin timestep_end'
#  []
#[]

[Postprocessors]
  [./Core_P_out]
    type     = ComponentBoundaryVariableValue
    variable = pressure
    input    = MSFR_core(out)
  [../]
  [./Core_T_out]
    type     = ComponentBoundaryVariableValue
    variable = temperature
    input    = MSFR_core(out)
  [../]
  [./Fuel_mass_flow] # Output mass flow rate at inlet of CH1
    type = ComponentBoundaryFlow
    input = MSFR_core(in)
  [../]
  [./Core_T_in]
    type     = ComponentBoundaryVariableValue
    variable = temperature
    input    = MSFR_core(in)
  [../]
  [./Core_P_in]
    type     = ComponentBoundaryVariableValue
    variable = pressure
    input    = MSFR_core(in)
  [../]

  [./HX_Tin_p]
    type     = ComponentBoundaryVariableValue
    variable = temperature
    input    = IHX1(primary_in)
  [../]
  [./HX_Tout_p]
    type     = ComponentBoundaryVariableValue
    variable = temperature
    input    = IHX1(primary_out)
  [../]
  [./HX_Tout_s]
    type     = ComponentBoundaryVariableValue
    variable = temperature
    input    = IHX1(secondary_out)
  [../]
  [./HX_Uout_s]
    type     = ComponentBoundaryVariableValue
    variable = velocity
    input    = IHX1(secondary_out)
  [../]
  [./FliBe_mass_flow]
    type = ComponentBoundaryFlow
    input = IHX1(secondary_in)
  [../]
  [./HX_Pin_s]
    type     = ComponentBoundaryVariableValue
    variable = pressure
    input    = IHX1(secondary_in)
  [../]

  [./FliBe_mass_flow2]
    type = ComponentBoundaryFlow
    input = IHX2(primary_in)
  [../]
  [./Gas_mass_flow]
    type = ComponentBoundaryFlow
    input = IHX2(secondary_in)
  [../]
  [./HX2_Tin_p]
    type     = ComponentBoundaryVariableValue
    variable = temperature
    input    = IHX2(primary_in)
  [../]
  [./HX2_Tout_p]
    type     = ComponentBoundaryVariableValue
    variable = temperature
    input    = IHX2(primary_out)
  [../]
  [./HX2_Tout_s]
    type     = ComponentBoundaryVariableValue
    variable = temperature
    input    = IHX2(secondary_out)
  [../]

  [HX_cold_temp]
    type = ElementAverageValue
    variable = temperature
    block = 'pipe3'
    execute_on = 'INITIAL TIMESTEP_BEGIN TIMESTEP_END TRANSFER'
  []
  [core_power_balance]
    type = ComponentBoundaryEnergyBalance
    eos = fuel_salt_eos
    input = 'MSFR_core(in) MSFR_core(out)'
  []
  [core_power]
    type = Receiver
    default = ${core_power_val}
    execute_on = 'INITIAL TIMESTEP_BEGIN TIMESTEP_END TRANSFER'
  []
[]

[Preconditioning]
  [./SMP_PJFNK]
    type                = SMP
    full                = true
    solve_type          = 'PJFNK'
    petsc_options_iname = '-pc_type -ksp_gmres_restart'
    petsc_options_value = 'lu 101'
  [../]
[]

#[Problem]
#  restart_file_base = msfr_system_1d_checkpoint_cp/1179
#[]

[Executioner]
  type       = Transient
  [./TimeStepper]
    type     = FunctionDT
    function = TimeStepperFunc
    min_dt   = 1e-3
  [../]
  #[./TimeStepper]
  #  type = AB2PredictorCorrector
  #  dt = .01
  #  e_max = 10
  #  e_tol = 1
  #[../]
  nl_rel_tol = 1e-8
  nl_abs_tol = 1e-6
  nl_max_its = 10
  l_tol      = 1e-6
  l_max_its  = 200
  start_time = 0.0
  end_time   = 1e10
  num_steps  = 20000
  [./Quadrature]
    type  = TRAP
    order = FIRST
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
