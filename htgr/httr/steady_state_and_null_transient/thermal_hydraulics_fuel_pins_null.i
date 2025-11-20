# ==============================================================================
# Fuel Assembly thermal-hydraulics model (null)
# Application: RELAP-7 (Sabertooth with child applications)
# ------------------------------------------------------------------------------
# Idaho Falls, INL, April 2023
# Author(s): Vincent Laboure
# If using or referring to this model, please cite as explained in
# https://mooseframework.inl.gov/virtual_test_bed/citing.html
# ==============================================================================

# - the number of pins should be 33 for fuel blocks of type 1 and 2, 31 for type 3 and 4.
#   For the control rods, the component below should be adjusted and the number of pins is set to 2
#
# - mdot should be computed from the total mass flow rate Mdot with:
#        Mdot = 12.4 kg/s for the 30 MW with Tout = 850C and for the 9 MW
#        Mdot = 10.2 kg/s for the 30 MW with Tout = 950C
#   Then, an assumption must be made to know how much of the helium cools the CR, which is chosen to be
#   5.5% < (1 - alpha) < 8.8% of Mdot [see Maruyama 1994, Shi 2015]. For now choose alpha = 92%
#   For the fuel regions, the mass flow rate is then:
#       mdot = alpha * Mdot / 954, 954 being the total number of fuel channels (33*12+31*18)
#   For the CR regions, the mass flow rate is then:
#       mdot = (1 - alpha) * Mdot / 32, 32 being the total number of CR cooling channels (2*16)

pressure = 2.8e6 # pressure in Pa

Mdot = 12.4 # total mass flow rate of coolant in kg/s
Npins = 954 # total number of fuel channels
npins = 33 # number of fuel channels in the current assembly
alpha = 0.92 # (1-alpha) is the by-pass flow proportion

mdot = '${fparse Mdot * alpha / Npins }' # kg/s
mdot_npins_over_Mdot = '${fparse alpha * npins / Npins }'

D_ext = 4.1e-2 # external diameter in m
D_int = 3.4e-2 # internal diameter in m

p = 0.36 # hexagonal pitch in m
Sblock = '${fparse 0.5 * sqrt(3) * p * p}' # Cross-section area of the hexagonal block in m^2
htc_homo_scaling = '${fparse pi * D_ext * npins / Sblock}'

Tinlet = 453.15 # fluid inlet temperature

[GlobalParams]
  # HTTR system at 2.8 MPa
  # Tinlet 180C for 9MW
  scaling_factor_1phase = '1 1e-2 1e-5' # scaling mass, mommentum, and energy
  closures = closure_high_temp_gas
[]

[Closures]
  [closure_high_temp_gas]
    type = Closures1PhaseHighTempGas
  []
[]

[AuxVariables]
  [Hw_inner] # heat transfer coefficient for the inner radius of fuel cooling channels [W/K/m^2]
    block = 'pipe1'
    family = MONOMIAL
    order = CONSTANT
  []
  [Hw_outer] # heat transfer coefficient for the outer radius of cooling channels [W/K/m^2]
    family = MONOMIAL
    order = CONSTANT
  []
  [Hw_outer_homo] # homogenized heat transfer coefficient for the outer radius of cooling channels [W/K/m^3]
    family = MONOMIAL
    order = CONSTANT
  []
[]

[AuxKernels]
  [Hw_inner_aux]
    type = ADMaterialRealAux
    block = 'pipe1'
    variable = Hw_inner
    property = Hw:1
  []
  [Hw_outer_aux]
    type = ADMaterialRealAux
    block = 'pipe1'
    variable = Hw_outer
    property = Hw:2
  []
  [Hw_outer_aux_topbottom]
    type = ADMaterialRealAux
    block = 'pipe_top pipe_bottom'
    variable = Hw_outer
    property = Hw
  []
  [Hw_outer_homo_aux]
    type = ParsedAux
    variable = Hw_outer_homo
    expression = 'Hw_outer * ${htc_homo_scaling}'
    coupled_variables = 'Hw_outer'
  []
[]

[UserObjects]
  [avg_Tfluid_UO]
    type = LayeredAverage
    variable = T
    direction = x
    bounds = '0 0.58 1.16 1.74 2.32 2.90 3.48 4.06 4.64 5.22' # axial boundaries of each block
    execute_on = 'timestep_end'
  []
  [avg_Hw_inner_UO]
    type = LayeredAverage
    variable = Hw_inner
    direction = x
    block = 'pipe1'
    bounds = '0 0.58 1.16 1.74 2.32 2.90 3.48 4.06 4.64 5.22' # axial boundaries of each block
    execute_on = 'timestep_end'
  []
  [avg_Hw_outer_UO]
    type = LayeredAverage
    variable = Hw_outer
    direction = x
    bounds = '0 0.58 1.16 1.74 2.32 2.90 3.48 4.06 4.64 5.22' # axial boundaries of each block
    execute_on = 'timestep_end'
  []
  [avg_Hw_outer_homo_UO]
    type = LayeredAverage
    variable = Hw_outer_homo
    direction = x
    bounds = '0 0.58 1.16 1.74 2.32 2.90 3.48 4.06 4.64 5.22' # axial boundaries of each block
    execute_on = 'timestep_end'
  []
[]

[FluidProperties]
  [helium]
    type = HeliumSBTLFluidProperties
  []
[]

[Components]
  [pipe_top]
    type = FlowChannel1Phase
    fp = helium
    # Geometry
    position = '5.22 0 0'
    orientation = '-1.0 0 0'
    A = '${fparse 0.25 * pi * D_ext * D_ext}' # Area of the pipe m^2
    D_h = ${D_ext} # Hydraulic diameter A = Dout
    f = 0 # Wall friction

    length = 1.16 # m
    n_elems = 60
  []
  [pipe1]
    type = FlowChannel1Phase
    fp = helium
    # Geometry
    position = '4.06 0 0'
    orientation = '-1.0 0 0'
    A = '${fparse 0.25 * pi * (D_ext * D_ext - D_int * D_int)}' # Area of the pipe m^2
    D_h = '${fparse D_ext - D_int}' # Hydraulic diameter A = Dout-Din
    f = 0 # Wall friction

    length = 2.9 # m
    n_elems = 180
  []
  [pipe_bottom]
    type = FlowChannel1Phase
    fp = helium
    # Geometry
    position = '1.16 0 0'
    orientation = '-1.0 0 0'
    A = '${fparse 0.25 * pi * D_ext * D_ext}' # Area of the pipe m^2
    D_h = ${D_ext} # Hydraulic diameter A = Dout
    f = 0 # Wall friction

    length = 1.16
    n_elems = 60
  []

  [inlet]
    type = InletMassFlowRateTemperature1Phase
    input = 'pipe_top:in'
    m_dot = ${mdot}
    T = ${Tinlet} # K
  []

  [junction1]
    type = JunctionOneToOne1Phase
    connections = 'pipe_top:out pipe1:in'
  []
  [junction2]
    type = JunctionOneToOne1Phase
    connections = 'pipe1:out pipe_bottom:in'
  []

  [outlet]
    type = Outlet1Phase
    input = 'pipe_bottom:out'
    p = ${pressure}
  []

  [ht_int]
    type = HeatTransferFromExternalAppTemperature1Phase
    flow_channel = pipe1
    P_hf = '${fparse pi * D_int}' # Heat flux perimeter m
  []

  [ht_ext_top]
    type = HeatTransferFromExternalAppTemperature1Phase
    flow_channel = pipe_top
    P_hf = '${fparse pi * D_ext}' # Heat flux perimeter m
  []
  [ht_ext]
    type = HeatTransferFromExternalAppTemperature1Phase
    flow_channel = pipe1
    P_hf = '${fparse pi * D_ext}' # Heat flux perimeter m
  []
  [ht_ext_bottom]
    type = HeatTransferFromExternalAppTemperature1Phase
    flow_channel = pipe_bottom
    P_hf = '${fparse pi * D_ext}' # Heat flux perimeter m
  []
[]

[Preconditioning]
  [SMP_PJFNK]
    type = SMP
    full = true
    petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
    petsc_options_value = 'lu       mumps'
  []
[]

[Executioner]
  type = Transient
  scheme = 'bdf2'
  solve_type = 'NEWTON'
  line_search = 'basic'

  dtmin = 1.e-8

  [TimeStepper]
    type = IterationAdaptiveDT
    dt = 1e-2
  []

  nl_rel_tol = 1e-6
  nl_abs_tol = 5e-8 # original: 1e-8 (but can result in solve failure in rare cases)
  nl_max_its = 20 # original: 5 (but can result in solve failure in rare cases)

  l_tol = 1e-3
  l_max_its = 100

  start_time = 0
  end_time = 50

  [Quadrature]
    type = GAUSS
    order = SECOND
  []
[]

[Postprocessors]
  [avg_T]
    type = ElementAverageValue
    variable = T
    execute_on = 'initial timestep_end'
  []
  [max_T]
    type = ElementExtremeValue
    variable = T
    value_type = max
    execute_on = 'initial timestep_end'
  []
  [avg_Twall]
    type = ElementAverageValue
    variable = T_wall
    block = 'pipe_top pipe_bottom'
    execute_on = 'initial timestep_end'
  []
  [avg_Twall1]
    type = ElementAverageValue
    variable = T_wall:1
    block = 'pipe1'
    execute_on = 'initial timestep_end'
  []
  [max_Twall1]
    type = ElementExtremeValue
    variable = T_wall:1
    value_type = max
    block = 'pipe1'
    execute_on = 'initial timestep_end'
  []
  [min_Twall1]
    type = ElementExtremeValue
    variable = T_wall:1
    value_type = min
    block = 'pipe1'
    execute_on = 'initial timestep_end'
  []
  [avg_Twall2]
    type = ElementAverageValue
    variable = T_wall:2
    block = 'pipe1'
    execute_on = 'initial timestep_end'
  []
  [max_Twall2]
    type = ElementExtremeValue
    variable = T_wall:2
    value_type = max
    block = 'pipe1'
    execute_on = 'initial timestep_end'
  []
  [min_Twall2]
    type = ElementExtremeValue
    variable = T_wall:2
    value_type = min
    block = 'pipe1'
    execute_on = 'initial timestep_end'
  []
  [avg_Hw_inner]
    type = ElementAverageValue
    variable = Hw_inner
    block = 'pipe1'
    execute_on = 'initial timestep_end'
  []
  [avg_Hw_outer]
    type = ElementAverageValue
    variable = Hw_outer
    execute_on = 'initial timestep_end'
  []
  [mdot_in]
    type = PointValue
    variable = rhouA
    point = '5.22 0 0'
    execute_on = 'initial timestep_end'
  []
  [mdot_out]
    type = PointValue
    variable = rhouA
    point = '0 0 0'
    execute_on = 'initial timestep_end'
  []
  [H_in]
    type = PointValue
    variable = H
    point = '5.22 0 0'
    execute_on = 'initial timestep_end'
  []
  [H_out]
    type = PointValue
    variable = H
    point = '0 0 0'
    execute_on = 'initial timestep_end'
  []
  [delta_H]
    type = ParsedPostprocessor
    expression = '${npins} * ${mdot} * (H_out - H_in)'
    pp_names = 'H_in H_out'
    execute_on = 'initial timestep_end'
  []
  [Tout]
    type = SideAverageValue
    boundary = 'pipe_bottom:out'
    variable = T
    execute_on = 'initial timestep_end'
  []
  [Tout_weighted]
    type = ScalePostprocessor
    value = Tout
    scaling_factor = ${mdot_npins_over_Mdot}
    execute_on = 'initial timestep_end'
  []
[]

[Outputs]
  [console]
    type = Console
    max_rows = 1
  []
[]
