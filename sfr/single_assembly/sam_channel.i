################################################################################
## SFR assembly model                                                         ##
## SAM Sub-Application                                                        ##
## Steady state 1D thermal hydraulics                                         ##
################################################################################
# If using or referring to this model, please cite as explained on
# https://mooseframework.inl.gov/virtual_test_bed/citing.html

m_dot_in = 29.8 #kg/s


Nrods  = 217 #number of rods
P_init = 1.0e5 # Pa
T_init = 623.15 # K (=350 degrees C)
rod_od = ${fparse 6.282e-3} # rod outside diameter, m
duct_f2f = 0.11154 # duct inside flat-to-flat, m
ww_pitch = 0.20419 # wire wrap pitch m
ww_od    = 1.1e-3  # wire wrap outer diameter m

A_channel  = ${fparse duct_f2f*duct_f2f*sqrt(3.)/2-Nrods*pi*rod_od*rod_od/4-Nrods*pi*ww_od*ww_od/4} #0.004048 channel flow area, m2
Ph_channel = ${fparse Nrods*pi*rod_od} # heated perimeter, m
Pw_channel = ${fparse Nrods*pi*rod_od+2*pi*sqrt(3)*duct_f2f} # wetted perimeter, m
D_channel  = ${fparse 4* A_channel / Pw_channel} # hydraulic diameter, m
#fuel height
fuel_h         = 1.0 # m
plenum_full_h  = 0.3 # m
plenum_empty_h = 0.7 # m
fuel_height = ${fparse fuel_h+plenum_empty_h+plenum_full_h}

P_out = 1.0e5    # 0.1 MPa
rho_in = 868.137 # kg/m^3
V_init = ${fparse m_dot_in/rho_in/A_channel}

[GlobalParams]
    eos = eos  # The equation-of-state name
    scaling_factor_var = '1 1e-3 1e-6'          # Scaling factors for fluid variables (p, v, T)
    global_init_P = ${P_init}
    global_init_T = ${T_init}
    global_init_V = ${V_init}
[]


[EOS]
  [eos]                                         # EOS name
    type = PBSodiumEquationOfState              # Using the sodium equation-of-state
  []
[]


[Components]
  [fuel_channel]
    type = PBOneDFluidComponent
    position =    '0 0 0'              # The origin position of this component
    orientation = '0 1 0'              # The orientation of the component
    htc_ext = htc_external             # name of HTC external function
    Dh = ${D_channel}                  # Equivalent hydraulic diameter
    length = ${fuel_height}            # Length of the component
    n_elems = 40                       # Number of elements used in discretization
    A =${A_channel}                    # Area of the One-D fluid component
    Ph = ${Ph_channel}                 # heated channel perimeter
    PoD = 1.183                        # rod pitch/diameter ratio
    HoD = ${fparse ww_pitch/rod_od}    # wire wrap pitch / rod outside diameter
    WF_geometry_type = WireWrap        # Wall friction geometry type
    WF_user_option = ChengTodreas      # wall friction correlation
    HTC_geometry_type = Bundle         # HTC geometry type (rod bunde or pipe)
  []

  [inlet]
    type = PBTDJ
    input = 'fuel_channel(in)'         # Name of the connected components and the end type
    v_bc = ${V_init}                   # Velocity boundary condition
    T_bc = ${T_init}                   # Temperature boundary condition
  []

  [outlet]
    type = PBTDV
    input = 'fuel_channel(out) '       # Name of the connected components and the end type
    p_bc = ${P_out}                    # Pressure boundary condition
  []

  [heat_transfer_from_fuel]
    type = HeatTransferWithExternalHeatStructure
    flow_component = fuel_channel
    initial_T_wall = 800
    htc_name = htc_external
    T_wall_name = T_wall_external
  []
[]


[Preconditioning]
  [SMP_PJFNK]
    type = SMP                         # Single-Matrix Preconditioner
    full = true                        # Using the full set of couplings among all variables
    solve_type = 'PJFNK'               # Using Preconditioned JFNK solution method
    petsc_options_iname = '-pc_type'   # PETSc option, using preconditiong
    petsc_options_value = 'lu'         # PETSc option, using ‘LU’ precondition type in Krylov solve
  []
[] # End preconditioning block


[Executioner]
  type = Steady                       # This is a transient simulation

  nl_rel_tol = 1e-8                   # Relative nonlinear tolerance for each Newton solve
  nl_abs_tol = 1e-9                   # Relative nonlinear tolerance for each Newton solve
  nl_max_its = 20                     # Number of nonlinear iterations for each Newton solve
  l_tol = 1e-4                        # Relative linear tolerance for each Krylov solve
  l_max_its = 100                     # Number of linear iterations for each Krylov solve

  petsc_options_iname = '-ksp_gmres_restart'  # Additional PETSc settings, name list
  petsc_options_value = '100'                 # Additional PETSc settings, value list


  [Quadrature]
    type = TRAP                       # Using trapezoid integration rule
    order = FIRST                     # Order of the quadrature
  []
[] # close Executioner section


[Postprocessors]
  [Tin]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = fuel_channel(in)
    execute_on = 'TIMESTEP_END'
  []
  [Tout]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = fuel_channel(out)
    execute_on = 'TIMESTEP_END'
  []
  [Tavg]
    type = ElementAverageValue
    variable = temperature
    execute_on = 'TIMESTEP_END'
  []
  [max_tcool]
    type = ElementExtremeValue
    value_type = max
    variable = temperature
    execute_on = 'TIMESTEP_END'
  []
  [Pin]
    type = ComponentBoundaryVariableValue
    variable = pressure
    input = fuel_channel(in)
    execute_on = 'TIMESTEP_END'
  []
  [Pout]
    type = ComponentBoundaryVariableValue
    variable = pressure
    input = fuel_channel(out)
    execute_on = 'TIMESTEP_END'
  []
  [delta_t_core]
    type = DifferencePostprocessor
    value1 = Tout
    value2 = Tin
    execute_on = 'TIMESTEP_END'
  []
  [delta_p_core]
    type = DifferencePostprocessor
    value1 = Pin
    value2 = Pout
    execute_on = 'TIMESTEP_END'
  []
  [Twall_avg]
    type = ElementAverageValue
    variable = T_wall_external
    execute_on = 'TIMESTEP_END'
  []
  [Twall_max]
    type = ElementExtremeValue
    value_type = max
    variable = T_wall_external
    execute_on = 'TIMESTEP_END'
  []
  [Twall_min]
    type = ElementExtremeValue
    value_type = min
    variable = T_wall_external
    execute_on = 'TIMESTEP_END'
  []
  [htc_avg]
    type = ElementAverageValue
    variable = htc_external
    execute_on = 'TIMESTEP_END'
  []
  [htc_min]
    type = ElementExtremeValue
    value_type = min
    variable = htc_external
    execute_on = 'TIMESTEP_END'
  []
  [htc_max]
    type = ElementExtremeValue
    value_type = max
    variable = htc_external
    execute_on = 'TIMESTEP_END'
  []
[]


[Outputs]
  # csv = true
  # print_nonlinear_converged_reason = false
  # print_linear_converged_reason = false
  # [out]
  #   type = Exodus
  #   use_displaced = true
  #   sequence = false
  # []
[]
