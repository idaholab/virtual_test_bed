## GCMR TH simulation with inter assembly bypass flow
## Inter assembly bypass flow input file
## Application: Pronghorn-SC
## POC: Lise Charlot lise.charlot at inl.gov
## If using or referring to this model, please cite as explained in
## https://mooseframework.inl.gov/virtual_test_bed/citing.html

T_in = 889.0 #K
P_out = 7.923e6 # Pa

lattice_pitch = 0.022 # m

k = 0.2556 # W/m
mu = 3.22639e-5 #Pa.s

n_rings = 5
assembly_radius = '${fparse n_rings * lattice_pitch}'
assembly_apothem = '${fparse sqrt(3) / 2 * assembly_radius}'

[TriInterWrapperMesh]
  [sub_channel]
    type = TriInterWrapperMeshGenerator
    nrings = ${n_rings}
    n_cells = 50
    flat_to_flat = '${fparse 2 * assembly_apothem - 0.001}'
    heated_length = 2.0
    assembly_pitch = '${fparse 2 * assembly_apothem}'
    side_bypass = 0.001
    tight_side_bypass = true
  []
[]

[AuxVariables]
  [mdot]
    initial_condition = 0.04
  []
  [SumWij]
  []
  [P]
    initial_condition = 0
  []
  [DP]
    initial_condition = 0
  []
  [h]
  []
  [T]
    initial_condition = ${T_in}
  []
  [rho]
  []
  [mu]
  []
  [S]
  []
  [w_perim]
  []
  [Re]
    initial_condition = 100
  []
  [htc]
    initial_condition = 100
  []
  [Nu]
  []
  [D_h]
  []
  [flux]
    initial_condition = 1000
  []
[]

[FluidProperties]
  [helium]
    type = IdealGasFluidProperties
    molar_mass = 4e-3
    gamma = 1.67
    k = ${k}
    mu = ${mu}
  []
[]

[ICs]
  [S_IC]
    type = TriInterWrapperFlowAreaIC
    variable = S
  []
  [w_perim_IC]
    type = TriInterWrapperWettedPerimIC
    variable = w_perim
  []
  [q_prime_IC]
    type = ConstantIC
    variable = q_prime
    value = 400
  []
  [Viscosity_ic]
    type = ViscosityIC
    variable = mu
    p = ${P_out}
    T = T
    fp = helium
  []
  [rho_ic]
    type = RhoFromPressureTemperatureIC
    variable = rho
    p = ${P_out}
    T = T
    fp = helium
  []
  [h_ic]
    type = SpecificEnthalpyFromPressureTemperatureIC
    variable = h
    p = ${P_out}
    T = T
    fp = helium
  []
[]

[AuxKernels]
  [q_prime_aux]
    type = ParsedAux
    coupled_variables = 'w_perim flux'
    variable = q_prime
    expression = 'min(max(-10000, w_perim*flux), 30000)'
    execute_on = 'INITIAL TIMESTEP_BEGIN'
  []
  [T_in_bc]
    type = ConstantAux
    variable = T
    boundary = inlet
    value = ${T_in}
    execute_on = 'INITIAL TIMESTEP_BEGIN'
  []
  [mdot_in_bc]
    type = MassFlowRateAux
    variable = mdot
    boundary = inlet
    area = S
    mass_flux = 50
    execute_on = 'INITIAL TIMESTEP_BEGIN'
  []
  [Re_aux]
    type = ParsedAux
    coupled_variables = 'mdot S'
    constant_names = 'mu'
    constant_expressions = '${mu}'
    expression = 'mdot * 0.001/ (mu * S)'
    variable = Re
    execute_on = 'INITIAL TIMESTEP_BEGIN'
  []

  [htc_aux]
    type = ParsedAux
    constant_names = 'k'
    constant_expressions = '${k}'
    expression = '4 * k / 0.001'
    variable = htc
    execute_on = 'INITIAL TIMESTEP_BEGIN'
  []
[]

[SubChannel]
  type = LiquidMetalInterWrapper1PhaseProblem
  fp = helium
  n_blocks = 1
  beta = 0.1
  P_out = ${P_out}
  CT = 1.0
  compute_density = true
  compute_viscosity = true
  compute_power = true
  P_tol = 1.0e-6
  T_tol = 1.0e-6
  implicit = false
  segregated = true
  staggered_pressure = true
  T_maxit = 20
  monolithic_thermal = false
[]

[Postprocessors]
  [m_dot_in]
    type = SideIntegralVariablePostprocessor
    variable = mdot
    boundary = inlet
  []
  [Re_in]
    type = SideAverageValue
    variable = Re
    boundary = inlet
  []
  [Re_out]
    type = SideAverageValue
    variable = Re
    boundary = outlet
  []
  [m_dot_out]
    type = SideIntegralVariablePostprocessor
    variable = mdot
    boundary = outlet
  []
  [htc_out]
    type = SideAverageValue
    variable = htc
    boundary = outlet
  []
  [htc_in]
    type = SideAverageValue
    variable = htc
    boundary = inlet
  []
  [D_out]
    type = SideAverageValue
    variable = D_h
    boundary = outlet
  []
  [energy_deposited]
    type = ElementIntegralVariablePostprocessor
    variable = q_prime
  []
[]

[Outputs]
  [out]
    type = Exodus
    show = 'P T SumWij mdot'
  []
[]

[Executioner]
  type = Steady
  nl_rel_tol = 0.9
  l_tol = 0.9
[]
