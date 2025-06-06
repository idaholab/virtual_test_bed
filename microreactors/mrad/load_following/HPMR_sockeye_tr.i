################################################################################
## NEAMS Micro-Reactor Application Driver                                     ##
## Heat Pipe Microreactor Load Following Transient                            ##
## Sockeye Grandchild Application input file                                  ##
## Effective Heat Conduction Model with Operation Limits                      ##
################################################################################

# NOTE:
# This input is initialized using the MultiApps restart from its parent app
# If this is not done, a separate initialization must be provided

# Wick characteristics
R_pore = 15.0e-6
D_h_pore = ${fparse 2.0 * R_pore}
permeability = 2e-9
porosity =  0.70

# Envelope ("env")
# SS316. Incropera & DeWitt, 3rd ed, Table A.1 @ 900K (627C)
# Density (kg/m3)
rho_env = 8238.
# Thermal conductivity (W/m-K)
k_env = 23.05
# Specific heat capacity (J/kg-K)
cp_env = 589.

# Potassium vapor
# From Appendix C of text book "Heat Pipe Design and Technology"
# Sat. Vapor Potassium at T = 650C (923 K)
# Density (kg/m3)
rho_vapor = 0.193
# Effective "super" conductivity (W/m-K)
#k_vapor = 1.0e5 # Reaches 600 seconds
k_vapor = 1.0e6
# Specific heat capacity (J/kg-K)
cp_vapor = 5320.

# Potassium liquid
# From Appendix C of text book "Heat Pipe Design and Technology"
# Sat. Liquid Potassium at T = 650C (923 K)
# Density (kg/m3)
rho_liquid = 695.4
# Thermal conductivity (W/m-K)
k_liquid = 40.08
# Specific heat capacity (J/kg-K)
# From Table 1.1, no temperature data given
cp_liquid = 810.
# Melting point, Table 3.1, lists 62C, rounding up
# T_melting = 340.

# Wick, homogenize envelope and fluid
# Density (kg/m3)
rho_wick = ${fparse porosity * rho_liquid + (1.0 - porosity) * rho_env}
# Thermal conductivity (W/m-K)
k_wick = ${fparse porosity * k_liquid + (1.0 - porosity) * k_env}
# Specific heat capacity (J/kg-K)
# From Table 1.1, no temperature data given
cp_wick = ${fparse porosity * cp_liquid + (1.0 - porosity) * cp_env}

# Elevations and lengths
# Note: For blackbox model -- manually update "length" input
length_evap = 180.0e-2
length_adia =  30.0e-2
length_cond =  90.0e-2

# Mesh density
# The dimensions are nicely divisible by 3 cm mesh.
nelem_base_evap = 50
nelem_base_adia = 10
nelem_base_cond = 30
mesh_density = 3
nelem_evap = ${fparse mesh_density*nelem_base_evap}
nelem_adia = ${fparse mesh_density*nelem_base_adia}
nelem_cond = ${fparse mesh_density*nelem_base_cond}

# Envelope thickness
t_env = 0.08e-2
# Liquid annulus thickness
t_ann = 0.07e-2
# Wick thickness
t_wick = 0.1e-2

# Radial geometry
# Envelope outer
R_hp_o = 1.05e-2
D_hp_o = ${fparse 2.0 * R_hp_o}
# Inner Envelope/outer annulus
R_hp_i = ${fparse R_hp_o - t_env}
D_hp_i = ${fparse 2.0 * R_hp_i}
# Inner annulus/wick outer
R_wick_o = ${fparse R_hp_i - t_ann}
D_wick_o = ${fparse 2.0 * R_wick_o}
# Inner wick/vapor core outer
R_wick_i = ${fparse R_wick_o - t_wick}
D_wick_i = ${fparse 2.0 * R_wick_i}

# BCs for condenser
T_ext_cond = 800.
htc_ext_cond = 1.0e2

[GlobalParams]
  scaling_factor_temperature = 1e-2
  fp_2phase = fp_2phase
[]

[FluidProperties]
  [fp_2phase]
    type = PotassiumTwoPhaseFluidProperties
    emit_on_nan = none
  []
[]

[Components]
  [hp]
    type = HeatPipeConduction

    # Common to both HeatPipe2Phase and HeatPipeBlackbox
    position = '0 0 0'
    orientation = '0 0 1'
    length = '${length_evap} ${length_adia} ${length_cond}'
    n_elems = '${nelem_evap} ${nelem_adia} ${nelem_cond}'
    gravity_vector = '0 0 -9.8'
    D_wick_i = ${D_wick_i}
    D_wick_o = ${D_wick_o}
    R_pore = ${R_pore}
    porosity = ${porosity}
    permeability = ${permeability}

    # HeatPipeConduction only
    # Axial dimensions (for heat transfer & analytic limits)
    axial_region_names = 'evap adia cond'
    L_evap = ${length_evap}
    L_adia = ${length_adia}
    L_cond = ${length_cond}
    # Radial dimensions, mesh, and materials for heat transfer problem
    D_clad_o = ${D_hp_o}
    D_clad_i = ${D_hp_i}
    D_h_pore = ${D_h_pore}
    # Mesh
    n_elems_clad = 4
    n_elems_wick = 8
    n_elems_core = 10
    # Thermal properties
    sp_vapor = sp_vapor
    sp_liquid = sp_wick_ann
    sp_wick = sp_wick_ann
    sp_clad = sp_clad
    k_core = ${k_vapor}
    k_eff = ${k_wick}
    #
    fp_2phase = fp_2phase
    evaporator_at_start_end = true
    # Initial temperature of block
    # initial_T = ${T_ext_cond}
    T_ref = T_inner_avg
    # To evaluate the constant properties
    T_ref_density = 1000
    make_pressure_corrections = true
  []

  [condenser_boundary]
    type = HSBoundaryAmbientConvection
    boundary = 'hp:cond:outer'
    hs = hp
    T_ambient = ${T_ext_cond}
    htc_ambient = ${htc_ext_cond} #large value to approach an effective DirichletBC
    scale = bc_scale_pp
  []
  [evaporator_boundary]
    type = HSBoundaryExternalAppConvection
    boundary = 'hp:evap:outer'
    hs = hp
    T_ext = virtual_Text
    htc_ext = virtual_htc
  []
[]

[SolidProperties]
  [sp_vapor]
    type = ThermalFunctionSolidProperties
    rho = ${rho_vapor}
    cp = ${cp_vapor}
    k = ${k_vapor}
  []
  [sp_wick_ann]
    type = ThermalFunctionSolidProperties
    rho = ${rho_wick}
    cp = ${cp_wick}
    k = ${k_wick}
  []
  [sp_clad]
    type = ThermalFunctionSolidProperties
    rho = ${rho_env}
    cp = ${cp_env}
    k = ${k_env}
  []
[]

[UserObjects]
  [surf_T]
    type = LayeredSideAverage
    direction = z
    num_layers = 100
    variable = T_solid
    boundary = 'hp:evap:outer'
  []
[]

[AuxKernels]
  [hp_var]
    type = SpatialUserObjectAux
    variable = hp_temp_aux
    user_object = surf_T
  []
  [virtual_Text]
    type = ParsedAux
    variable = virtual_Text
    coupled_variables = 'T_solid master_flux virtual_htc'
    expression = 'master_flux/virtual_htc + T_solid'
  []
[]

[Functions]
  [scale_fcn]
    type = ParsedFunction
    symbol_names = 'catastrophic_pp recoverable_pp operational_pp'
    symbol_values = 'catastrophic_pp recoverable_pp operational_pp'
    expression = 'catastrophic_pp*recoverable_pp*operational_pp'
  []
[]

[AuxVariables]
  [T_wall_var]
    # initial_condition = ${T_ext_cond}
  []
  [operational_aux]
    # initial_condition = 1
  []
  [master_flux]
    # initial_condition = ${q_evap}
  []
  [hp_temp_aux]
    # initial_condition = ${T_ext_cond}
  []
  [virtual_Text]
    # initial_condition = ${T_ext_cond}
  []
  [virtual_htc]
    # initial_condition = 1.0
  []
[]

[Postprocessors]
  [Integral_BC_Total]
    type = SumPostprocessor
    values = 'condenser_boundary_integral evaporator_boundary_integral'
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [ZeroPP]
    type = EmptyPostprocessor
  []
  [Integral_BC_Cond]
    type = DifferencePostprocessor
    value1 = ZeroPP
    value2 = condenser_boundary_integral
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [Integral_BC_RelErr]
    type = RelativeDifferencePostprocessor
    value1 = evaporator_boundary_integral
    value2 = Integral_BC_Cond
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [bc_scale_pp]
    type = FunctionValuePostprocessor
    function = 1.0
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [operational_pp]
    type = ElementAverageValue
    variable = operational_aux
    execute_on = 'initial timestep_begin TIMESTEP_END'
  []

  [catastrophic_pp]
    type = HeatRemovalRateLimitScale
    heat_addition_pps = 'evaporator_boundary_integral'
    limit_condenser_side = false
    catastrophic_heat_removal_limit_pps = 'hp_boiling_limit hp_capillary_limit '
                                          'hp_entrainment_limit'
    recoverable_heat_removal_limit_pps = ''
    T = T_inner_avg
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [recoverable_pp]
    type = HeatRemovalRateLimitScale
    heat_addition_pps = 'evaporator_boundary_integral'
    limit_condenser_side = false
    catastrophic_heat_removal_limit_pps = ''
    recoverable_heat_removal_limit_pps = 'hp_sonic_limit hp_viscous_limit'
    T = T_inner_avg
    execute_on = 'INITIAL linear nonlinear TIMESTEP_END'
  []
  [T_evap_inner]
    type = SideAverageValue
    boundary = hp:evap:inner
    variable = T_solid
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [T_cond_inner]
    type = SideAverageValue
    boundary = hp:cond:inner
    variable = T_solid
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [T_evap_outer]
    type = SideAverageValue
    boundary = hp:evap:outer
    variable = T_solid
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [T_cond_outer]
    type = SideAverageValue
    boundary = hp:cond:outer
    variable = T_solid
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [T_wall_var_avg]
    type = ElementAverageValue
    variable = T_wall_var
    execute_on = 'Initial timestep_end'
  []
  [T_inner_avg]
    type = SideAverageValue
    variable = T_solid
    boundary = hp:inner
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [T_inner_max]
    type = NodalExtremeValue
    variable = T_solid
    boundary = hp:inner
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [T_inner_min]
    type = NodalExtremeValue
    variable = T_solid
    boundary = hp:inner
    execute_on = 'INITIAL TIMESTEP_END'
    value_type = min
  []
  [DT_outer]
    type = DifferencePostprocessor
    value1 = T_evap_outer
    value2 = T_cond_outer
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [DT_inner]
    type = DifferencePostprocessor
    value1 = T_evap_inner
    value2 = T_cond_inner
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [scale_pp]
    type = FunctionValuePostprocessor
    function = scale_fcn
  []
  [A_int_master_flux]
    type = SideIntegralVariablePostprocessor
    variable = master_flux
    boundary  = 'hp:evap:inner'
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [A_int_T_ext]
    type = SideIntegralVariablePostprocessor
    variable = virtual_Text
    boundary  = 'hp:evap:inner'
    execute_on = 'INITIAL LINEAR'
  []
  [A_avg_T_aux]
    type = AverageNodalVariableValue
    variable = hp_temp_aux
    boundary  = 'hp:evap:inner'
    execute_on = 'INITIAL TIMESTEP_END'
  []
[]

[VectorPostprocessors]
  [env_vpp]
    type = NodalValueSampler
    variable = T_solid
    block = 'hp:clad'
    sort_by = x
    execute_on = 'INITIAL TIMESTEP_END'
  []
[]

[Preconditioning]
  [pc]
    type = SMP
    full = true
  []
[]

[Executioner]
  type = Transient

  solve_type = NEWTON
  petsc_options_iname = '-pc_type'
  petsc_options_value = 'lu'
  scheme = bdf2
  line_search = none

  # ensure nl_abs_tol >> nl_rel_tol
  nl_abs_tol = 1e-6
  nl_rel_tol = 1e-8
  nl_max_its = 100

  l_tol = 1e-3
  l_max_its = 100

  start_time = 0
  end_time = 2000
  dt = 1
[]

[Outputs]
  [console]
    type = Console
    max_rows = 5
    execute_postprocessors_on = 'INITIAL TIMESTEP_END FINAL FAILED'
  []
  [csv]
    type = CSV
    execute_on = 'INITIAL TIMESTEP_END FINAL FAILED'
    execute_vector_postprocessors_on = 'FINAL FAILED'
 []
[]
