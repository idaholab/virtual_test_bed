## GCMR TH simulation with inter-assembly bypass flow
## Core cooling channels input file
## Application: MOOSE thermal hydrualics module
## POC: Lise Charlot lise.charlot at inl.gov
## If using or referring to this model, please cite as explained in
## https://mooseframework.inl.gov/virtual_test_bed/citing.html

radius_coolant = 0.00635 # m
length_channel = 2 # m
channel_n_elems = 50

A_channel = '${fparse pi * radius_coolant^2}'
P_hf_channel = '${fparse  2 * pi * radius_coolant}'

T_in = 889 # K
p_out = 7.923e6 # Pa

[GlobalParams]
  initial_vel = 15 #m/s
  initial_T = T_init
  initial_p = ${p_out}

  rdg_slope_reconstruction = full
  fp = helium
  closures = thm
  scaling_factor_1phase = '1 1e-2 1e-4'
[]

[FluidProperties]
  [helium]
    type = IdealGasFluidProperties
    molar_mass = 4e-3
    gamma = 1.67
    k = 0.2556
    mu = 3.22639e-5
  []
[]
[Functions]
  [T_init]
    type = PiecewiseLinear
    x = '0 ${length_channel}'
    y = '${T_in} 1100'
  []
[]
[Closures]
  [thm]
    type = Closures1PhaseTHM
  []
[]

[AuxVariables]
  [htc]
    initial_condition = 1000
    family = MONOMIAL
    order = CONSTANT
  []
[]

[AuxKernels]
  [Hw_aux]
    type = ADMaterialRealAux
    property = Hw
    variable = htc
  []
[]

[Components]
  [inlet]
    type = InletVelocityTemperature1Phase
    vel = 15
    T = ${T_in}
    input = channel:in
  []
  [channel]
    type = FlowChannel1Phase
    position = '0 0 0'
    orientation = '0 0 1'
    length = ${length_channel}
    A = ${A_channel}
    n_elems = ${channel_n_elems}
    D_h = '${fparse 2 * radius_coolant}'
  []
  [outlet]
    type = Outlet1Phase
    p = ${p_out}
    input = channel:out
  []
  [ht]
    type = HeatTransferFromExternalAppTemperature1Phase
    flow_channel = channel
    P_hf = ${P_hf_channel}
    initial_T_wall = 1200
  []
[]

[Postprocessors]
  [m_dot_in]
    type = ADFlowBoundaryFlux1Phase
    boundary = inlet
    equation = mass
  []
  [heat_to_channel]
    type = ADHeatRateConvection1Phase
    P_hf = ${P_hf_channel}
  []
  [p_in]
    type = SideAverageValue
    variable = p
    boundary = channel:in
  []
  [p_out]
    type = SideAverageValue
    variable = p
    boundary = channel:out
  []
  [delta_p]
    type = ParsedPostprocessor
    pp_names = 'p_in p_out'
    function = 'p_in - p_out'
  []
  [T_out]
    type = SideAverageValue
    variable = T
    boundary = channel:out
  []
  [htc_avg]
    type = ADElementAverageMaterialProperty
    mat_prop = Hw
  []
[]

[Preconditioning]
  [SMP]
    type = SMP
    full = true
  []
[]

[Executioner]
  type = Steady
  solve_type = NEWTON
  petsc_options_iname = '-pc_type'
  petsc_options_value = 'lu'
  line_search = basic

  nl_abs_tol = 1e-08
  nl_rel_tol = 1e-08
  nl_max_its = 20
[]

