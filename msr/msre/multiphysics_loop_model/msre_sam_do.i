# Molten Salt Reactor Experiment Model
# Steady state simulation
# Application : SAM
# Authors: Jun Fang, Travis Mui
# Date: 04/2025

# Component Areas and Lengths
A_downcomer = 0.1155292077
length_downcomer = 2.00654
A_coreplenums = 0.5541878 # consider a porosity of 0.225
length_coreplenums = 2.43854
A_pipe1_s1 = 0.01267
length_pipe1_s1 = 1.8288
A_pipe1_s2 = 0.01267
length_pipe1_s2 = 0.53606
A_pipe2 = 0.01267
length_pipe2 = 1.0668
length_hx_shell = 2.5298
A_hx_shell = 1.0183E-01
A_pipe3_s1 = 0.01267
length_pipe3_s1 = 0.96806
A_pipe3_s2 = 0.01267
length_pipe3_s2 = 1.0439

# Delayed Neutron precursor data
lambda_1              = 0.013336
lambda_2              = 0.0327389985
lambda_3              = 0.120779999
lambda_4              = 0.302780002
lambda_5              = 0.849489987
lambda_6              = 2.85299993

[GlobalParams]
  global_init_P = 1e5 # Global initial fluid pressure
  global_init_V = 0.0001 # Global initial fluid velocity
  global_init_T = 908.15 # Global initial temperature for fluid and solid
  Tsolid_sf = 1e-3
  gravity = '0 -9.8 0'
  #scaling_factor_var = '1 1e-3 1e-6' # fluid model solver parameters
  p_order = 2
  [PBModelParams]
    pbm_scaling_factors = '1 1e-3 1e-6 '
    passive_scalar = 'c1 c2 c3 c4 c5 c6'
    passive_scalar_decay_constant = '${lambda_1} ${lambda_2} ${lambda_3} ${lambda_4} ${lambda_5} ${lambda_6}'
    passive_scalar_diffusivity = '0.000 0.000 0.000 0.000 0.000 0.000'
    global_init_PS = '0.000 0.000 0.000 0.000 0.000 0.000'
    p_order = 2
  []
[]

[Functions]
  [fuel_salt_rho_func] # Linear fitting used by He, 2016
    type = PiecewiseLinear
    x = '750       1200'
    y = '2285.31   2032.41'
  []
  [fuel_salt_enthalpy_func] # Approximated by Cp*T
    type = PiecewiseLinear
    x = '750        1200'
    y = '1.51E+06   2.41E+06'
  []
  [fuel_salt_mu_func]
    type = PiecewiseLinear
    x = '750  760  770  780  790  800  810  820
            830  840  850  860  870  880  890  900
            910  920  930  940  950  960  970  980
            990  1000 1010 1020 1030 1040 1050 1060
            1070 1080 1090 1100 1110 1120 1130 1140
            1150 1160 1170 1180 1190 1200'
    y = '2.7378E-02 2.5371E-02 2.3557E-02 2.1915E-02 2.0424E-02 1.9069E-02 1.7834E-02 1.6706E-02
            1.5674E-02 1.4728E-02 1.3859E-02 1.3060E-02 1.2324E-02 1.1645E-02 1.1017E-02 1.0436E-02
            9.8976E-03 9.3976E-03 8.9328E-03 8.5001E-03 8.0969E-03 7.7206E-03 7.3690E-03 7.0402E-03
            6.7322E-03 6.4434E-03 6.1724E-03 5.9178E-03 5.6783E-03 5.4529E-03 5.2404E-03 5.0400E-03
            4.8508E-03 4.6720E-03 4.5029E-03 4.3428E-03 4.1911E-03 4.0473E-03 3.9109E-03 3.7813E-03
            3.6582E-03 3.5411E-03 3.4297E-03 3.3235E-03 3.2224E-03 3.1259E-03'
  []
  [time_stepper]
    type         = PiecewiseConstant
    direction    = LEFT_INCLUSIVE
    x = '-2000.0  -1998.0  -1980.0  -1900.0  -1500.0'
    y = '    0.5      1.0      5.0     20.0    100.0'
  []
[]

[EOS]
  [fuel_salt_eos]
    type = PTFluidPropertiesEOS
    fp = salt
    p_0 = 101325.0
    eos_test = true
  []
  # [fuel_salt_eos] # Function-defined EOS for MSRE fuel salt, used in original SAM model
  #   type = PTFunctionsEOS
  #   rho = 2000 #fuel_salt_rho_func
  #   mu = 9e-3 #fuel_salt_mu_func
  #   enthalpy = fuel_salt_enthalpy_func
  #   cp = 2000
  #   k = 1.0
  # []
  [hx_salt_eos]
    type = SaltEquationOfState
    salt_type = Flibe
  []
[]

[MaterialProperties]
  [salt]
    type = SalineMoltenSaltFluidProperties
    comp_name = "LiF BeF2 ZrF4 UF4" # This should be the MSRE fuel salt, but I did not find an exact completed reference in MSTDB-TP, using FLiBe for now
    comp_val = "0.6479 0.2996 0.0499 0.0026"
    prop_def_file = "saline_data.csv"
  []
  # [salt]
  #   type = SalineMoltenSaltFluidProperties
  #   comp_name = "LiF BeF2" # This should be the MSRE fuel salt, but I did not find an exact completed reference in MSTDB-TP, using FLiBe for now
  #   comp_val = "0.66 0.34"
  #   prop_def_file = "Molten_Salt_Thermophysical_Properties.csv"
  # []
  [alloy-mat] # Based on Hastelloy N alloy
    type = SolidMaterialProps
    k = 23.6 # Thermal conductivity
    Cp = 578 # Specific heat
    rho = 8.86e3 # Density
  []
  [graphite]
    type = SolidMaterialProps
    k = 90.0
    Cp = 1642.9
    rho = 1870.0
  []
[]

[Components]
  #
  # ====== downcomer ======
  #
  [downcomer]
    type = PBOneDFluidComponent
    A = ${A_downcomer} #0.1155292077 #0.1589
    Dh = 0.0508
    length = ${length_downcomer} #2.00654
    n_elems = 18
    orientation = '0 -1 0'
    position = '0.7239 2.00654 0'
    eos = fuel_salt_eos
  []

  [j_ip_c]
    type = PBBranch
    Area = 0.5541878 #0.1155
    K = '0.0 0.0'
    eos = fuel_salt_eos
    inputs = 'downcomer(out)'
    outputs = 'core_plenums(in)'
  []

  #
  # ====== core channel ======
  #
  [core_plenums] # 1-D representation of the core
    type = PBOneDFluidComponent
    A = ${A_coreplenums} #0.5541878 # consider a porosity of 0.225
    Dh = 1.4097
    length = ${length_coreplenums} #2.43854 #2.00654
    n_elems = 20
    orientation = '0 1 0'
    position = '0 0 0'
    eos = fuel_salt_eos
    #heat_source = 1.65e7
    #scalar_source = 10.0
  []

  [j_up_ps1]
    type = PBBranch
    Area = 0.1155
    K = '0.0 0.0'
    eos = fuel_salt_eos
    inputs = 'core_plenums(out)'
    outputs = 'pipe1_s1(in)'
  []

  #
  # ====== pipe connecting core to pump ======
  #
  [pipe1_s1] # Connecting core to pump, horizontal section
    type = PBOneDFluidComponent
    A = ${A_pipe1_s1} #0.01267
    Dh = 0.127
    length = ${length_pipe1_s1} #1.8288
    n_elems = 19
    orientation = '-1 0 0'
    position = '0 2.43854 0'
    eos = fuel_salt_eos
  []

  [j1]
    type = PBBranch
    Area = 0.01292
    K = '0.0 0.0'
    eos = fuel_salt_eos
    inputs = 'pipe1_s1(out)'
    outputs = 'pipe1_s2(in)'
  []

  [pipe1_s2] # vertical section
    type = PBOneDFluidComponent
    A = ${A_pipe1_s2} #0.01267
    Dh = 0.127
    length = ${length_pipe1_s2} #.53606 #0.96806
    n_elems = 9
    orientation = '0 1 0'
    position = '-1.8288 2.43854 0'
    eos = fuel_salt_eos
  []
  #
  # ====== pump ======
  #
  [pump]
    type = PBPump
    Area = 0.01292
    K = '0.15 0.1'
    eos = fuel_salt_eos
    inputs = 'pipe1_s2(out)'
    outputs = 'pipe2(in)'
    initial_P = 1.1e5
    # Head_fn   = f_pump_head
    Head = 1.0564E+05 #43909.58 3.2564E+05
  []

  [pipe2] # Connecting the pump to HX
    type = PBOneDFluidComponent
    A = ${A_pipe2} #0.01267
    Dh = 0.127
    length = ${length_pipe2} #1.0668
    n_elems = 11
    orientation = '1 0 0'
    position = '-1.8288 2.9746 0'
    eos = fuel_salt_eos
    # scalar_source = ${fparse 1*8.30025781e-01/(0.484*0.0019635)} #
    # scalar_source = main_pipe2_trace_func
  []

  [j2] # junction connect to heat exchanger
    type = PBBranch
    Area = 0.01267
    K = '0.0 0.0'
    eos = fuel_salt_eos
    inputs = 'pipe2(out)'
    outputs = 'hx_shell(in)'
  []
  #
  # ====== Customized U-tube heat exchanger ======
  #
  [hx_shell]
    type = PBOneDFluidComponent
    position = '-0.762 2.9746 0'
    orientation = '1 0 0'
    length = ${length_hx_shell} #2.5298
    n_elems = 26
    eos = fuel_salt_eos
    heat_source = 0
    A = ${A_hx_shell} #1.0183E-01
    Dh = 2.0945E-02
  []

  [hx_tube1]
    type = PBOneDFluidComponent
    position = '1.7678 3.0762 0'
    orientation = '-1 0 0'
    length = 2.5298
    n_elems = 26
    eos = hx_salt_eos
    heat_source = 0
    A = 2.7885E-02
    Dh = 1.0566E-02
    initial_T = 824.8167
  []

  [hx_j1]
    type = PBBranch
    eos = hx_salt_eos
    inputs = 'hx_tube1(out)'
    outputs = 'hx_tube2(in)'
    K = '0 0'
    Area = 2.7885E-02
    initial_T = 824.8167
  []

  [hx_tube2]
    type = PBOneDFluidComponent
    position = '-0.762 3.0762 0'
    orientation = '0 -1 0'
    length = 0.2032
    n_elems = 2
    eos = hx_salt_eos
    heat_source = 0
    A = 2.7885E-02
    Dh = 1.0566E-02
    initial_T = 824.8167
  []

  [hx_j2]
    type = PBBranch
    eos = hx_salt_eos
    inputs = 'hx_tube2(out)'
    outputs = 'hx_tube3(in)'
    K = '0 0'
    Area = 2.7885E-02
    initial_T = 824.8167
  []

  [hx_tube3]
    type = PBOneDFluidComponent
    position = '-0.762 2.873 0'
    orientation = '1 0 0'
    length = 2.5298
    n_elems = 26
    eos = hx_salt_eos
    heat_source = 0
    A = 2.7885E-02
    Dh = 1.0566E-02
    initial_T = 824.8167
  []

  [hx_s_in]
    type = PBTDJ
    input = 'hx_tube1(in)'
    eos = hx_salt_eos
    v_bc = 1.25
    T_bc = 824.8167
  []

  [hx_s_out]
    type = PBTDV
    input = 'hx_tube3(out)'
    eos = hx_salt_eos
    p_bc = 1.0e5
    T_bc = 866.4833
  []

  [hx_wall1]
    type = PBCoupledHeatStructure
    position = '1.7678 3.0762 0'
    orientation = '-1 0 0'
    length = 2.5298
    hs_type = cylinder
    radius_i = 5.2832E-03
    width_of_hs = 1.0668E-03
    elem_number_radial = 2
    elem_number_axial = 26
    dim_hs = 2
    material_hs = 'alloy-mat'
    Ts_init = 922

    HS_BC_type = 'Coupled Coupled'
    name_comp_left = hx_tube1
    HT_surface_area_density_left = 8.6290E+02
    name_comp_right = hx_shell
    HT_surface_area_density_right = 2.3629E+02
  []

  [hx_wall2]
    type = PBCoupledHeatStructure
    position = '-0.762 2.873 0'
    orientation = '1 0 0'
    length = 2.5298
    hs_type = cylinder
    radius_i = 5.2832E-03
    width_of_hs = 1.0668E-03
    elem_number_radial = 2
    elem_number_axial = 26
    dim_hs = 2
    material_hs = 'alloy-mat'
    Ts_init = 922

    HS_BC_type = 'Coupled Coupled'
    name_comp_left = hx_tube3
    HT_surface_area_density_left = 8.6290E+02
    name_comp_right = hx_shell
    HT_surface_area_density_right = 2.3629E+02
  []

  [j3]
    type = PBBranch
    Area = 0.01267
    K = '0.0 1e3 0.0'
    eos = fuel_salt_eos
    inputs = 'hx_shell(out) pipe_ref(out)'
    outputs = 'pipe3_s1(in)'
  []

  [pipe_ref]
    type = PBOneDFluidComponent
    A = 0.01267
    Dh = 0.127
    length = 0.1
    n_elems = 2
    orientation = '-1 0 0'
    position = '1.8678 2.9746 0'
    eos = fuel_salt_eos
  []
  [ref_p]
    type = PBTDV
    eos = fuel_salt_eos
    T_bc = 908.15
    p_bc = 2.433351e+05
    input = 'pipe_ref(in)'
  []
  #
  # ====== pipe connecting heat exchanger to downcomer ======
  #
  [pipe3_s1] # Connecting hx to downcomer
    type = PBOneDFluidComponent
    A = ${A_pipe3_s1} #0.01267
    Dh = 0.127
    length = ${length_pipe3_s1} #0.96806
    n_elems = 12
    orientation = '0 -1 0'
    position = '1.7678 2.9746 0'
    eos = fuel_salt_eos
  []

  [j4]
    type = PBBranch
    Area = 0.01267
    K = '0.0 0.0'
    eos = fuel_salt_eos
    inputs = 'pipe3_s1(out)'
    outputs = 'pipe3_s2(in)'
  []

  [pipe3_s2]
    type = PBOneDFluidComponent
    A = ${A_pipe3_s2} #0.01267
    Dh = 0.127
    length = ${length_pipe3_s2} #1.0439
    n_elems = 11
    orientation = '-1 0 0'
    position = '1.7678 2.00654 0'
    eos = fuel_salt_eos
  []

  [j5]
    type = PBBranch
    Area = 0.01267
    K = '0.0 0.0'
    eos = fuel_salt_eos
    inputs = 'pipe3_s2(out)'
    outputs = 'downcomer(in)'
  []
[]

[Postprocessors]
  [num_nonlinear_iterations]
    type = NumNonlinearIterations
    execute_on = 'timestep_end'
  []
  [num_linear_iterations]
    type = NumLinearIterations
    execute_on = 'timestep_end'
  []
  [c1_inlet]
    type = ComponentBoundaryVariableValue
    variable = c1
    input = pipe3_s2(out)
  []
  [mdot]
    type = ComponentBoundaryFlow
    input = core_plenums(in)
  []
  [flow_rate]
    type = ComponentBoundaryVariableValue
    input = pipe2(in)
    variable = velocity
    scale_factor = 0.01267 #pipe area
  []
  [Core_P_out] # Pressure at Core outlet/Loop inlet
    type = ComponentBoundaryVariableValue
    variable = pressure
    input = core_plenums(out)
  []
  [Core_vel_in]
    type = ComponentBoundaryVariableValue
    variable = velocity
    input = core_plenums(in)
  []
  [Core_T_out]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = core_plenums(out)
  []
  [Core_T_in]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = core_plenums(in)
  []
  [Core_P_in]
    type = ComponentBoundaryVariableValue
    variable = pressure
    input = core_plenums(in)
  []
  [HX_Tin_p]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = hx_shell(in)
  []
  [HX_Tout_p]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = hx_shell(out)
  []
  [total_volume]
    type = ParsedPostprocessor
    expression = '${A_downcomer}*${length_downcomer}+${A_coreplenums}*${length_coreplenums}+
    ${A_pipe1_s1}*${length_pipe1_s1}+${A_pipe1_s2}*${length_pipe1_s2}+${A_pipe2}*${length_pipe2}+
    ${length_hx_shell}*${A_hx_shell}+${A_pipe3_s1}*${length_pipe3_s1}+${A_pipe3_s2}*${length_pipe3_s2}'
  []
  [total_circulation_time]
    type = ParsedPostprocessor
    expression = 'total_volume/flow_rate'
    pp_names = 'total_volume flow_rate'
  []
  # [bypass_vol]
  #   type                    = VolumePostprocessor
  #   block                   = 'core2'
  #   execute_on              = 'initial timestep_end'
  # []
  # [lower_plenum_vol]
  #   type                    = VolumePostprocessor
  #   block                   = 'lower_plenum'
  #   execute_on              = 'initial timestep_end'
  # []
  # [upper_plenum_vol]
  #   type                    = VolumePostprocessor
  #   block                   = 'upper_plenum'
  #   execute_on              = 'initial timestep_end'
  # []
  # [Aux_vol]
  #   type                    = VolumePostprocessor
  #   block                   = 'down_comer riser'
  #   execute_on              = 'initial timestep_end'
  # []
  # [Salt_vol_core_and_plena]
  #   type = ParsedPostprocessor
  #   expression = 'graphite_vol*${core_porosity} + bypass_vol + lower_plenum_vol + upper_plenum_vol'
  #   pp_names = 'graphite_vol bypass_vol lower_plenum_vol upper_plenum_vol '
  # []
  # [Salt_vol_total]
  #   type = ParsedPostprocessor
  #   expression = 'Aux_vol + Salt_vol_core_and_plena'
  #   pp_names = 'Aux_vol Salt_vol_core_and_plena'
  # []
[]

[Preconditioning]
  # pc_factor_shift are added automatically by SAM, they are added here for BlueCRAB
  [SMP_PJFNK]
    type = SMP
    full = true
    solve_type = 'PJFNK'
    petsc_options_iname = '-pc_type -ksp_gmres_restart -pc_factor_shift_type -pc_factor_shift_amount'
    petsc_options_value = 'lu 101 NONZERO 1e-9'
  []
[]

[Executioner]
  type = Transient
  # dt = 0.2
  # dtmin = 1.e-3
  # dtmax = 10.0
  # start_time = -2000
  # end_time = 0
  start_time = -2000
  end_time  = -1000
  # scheme = implicit-euler

  [TimeStepper]
    type = FunctionDT
    function = time_stepper
    min_dt = 1e-3
  []

  nl_rel_tol = 1e-8
  nl_abs_tol = 1e-7
  nl_max_its = 30
  l_tol = 1e-4
  l_max_its = 100

  [Quadrature]
    type = SIMPSON
    order = SECOND
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
  [csv]
    type = CSV
    execute_scalars_on = 'none'
  []
  [checkpoint]
    type = Checkpoint
    num_files = 1
  []
  [console]
    type = Console
    execute_scalars_on = 'none'
  []
[]
