################################################################################
## NEAMS Micro-Reactor Application Driver                                     ##
## Sockeye Sub Application input file                                         ##
## Heat Pipe Effective Heat Conduction Model                                  ##
################################################################################

# Average heat removed/added to heat pipe (W)
Q_hp = 1800.

# Wick characteristics
R_pore = 15.0e-6 # m
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

# Wick, homogenize envelope and fluid
# Density (kg/m3)
rho_wick = ${fparse porosity * rho_liquid + (1.0 - porosity) * rho_env}
# Thermal conductivity (W/m-K)
k_wick = ${fparse porosity * k_liquid + (1.0 - porosity) * k_env}
# Specific heat capacity (J/kg-K)
# From Table 1.1, no temperature data given
cp_wick = ${fparse porosity * cp_liquid + (1.0 - porosity) * cp_env}

# Elevations and lengths (m)
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

# Envelope thickness (m)
t_env = 0.08e-2
# Liquid annulus thickness (m)
t_ann = 0.07e-2
# Wick thickness (m)
t_wick = 0.1e-2

# Radial geometry
# Envelope outer (m)
R_hp_o = 1.05e-2
#R_clad_o = ${R_hp_o}
D_hp_o = ${fparse 2.0 * R_hp_o}
# Inner Envelope/outer annulus (m)
R_hp_i = ${fparse R_hp_o - t_env}
D_hp_i = ${fparse 2.0 * R_hp_i}
# Inner annulus/wick outer (m)
R_wick_o = ${fparse R_hp_i - t_ann}
D_wick_o = ${fparse 2.0 * R_wick_o}
# Inner wick/vapor core outer (m)
R_wick_i = ${fparse R_wick_o - t_wick}
D_wick_i = ${fparse 2.0 * R_wick_i}

# BCs for condenser
T_ext_cond = 800. # K
# JWT: coupled problem uses 1.0e6
#htc_ext_cond = 326. # (W/m2/K)
htc_ext_cond = 1.0e6 # (W/m2/K)

# Evaporator parameters
htc_wall_initial = 750 #air gap k=0.15 W/mK, th=0.0002 m
S_evap = ${fparse pi * D_hp_o * length_evap}
q_evap = ${fparse Q_hp / S_evap}

# Flux correction
R_clad_o = 0.0105 # heat pipe outer radius (m)
R_hp_hole = 0.0107 # heat pipe + gap (m)
num_sides = 28 # full_core level 9
alpha = ${fparse 2 * pi / num_sides}
# perimeter_correction = ${fparse 0.5 * alpha / sin(0.5 * alpha)} # polygonization correction factor for perimeter (unused)
area_correction = ${fparse sqrt(alpha / sin(alpha))} # polygonization correction factor for area
corr_factor = ${fparse 2 * R_clad_o / R_hp_hole / R_hp_hole / area_correction / area_correction} #full-core

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
    # Thermal conductivity
    k_clad = ${k_env}
    k_wick = ${k_wick}
    k_core = ${k_vapor}
    k_eff = ${k_wick}
    # Density
    rho_clad = ${rho_env}
    rho_wick = ${rho_wick}
    rho_core = ${rho_vapor}
    # Specific heat
    cp_clad = ${cp_env}
    cp_wick = ${cp_wick}
    cp_core = ${cp_vapor}
    #
    fp_2phase = fp_2phase
    evaporator_at_start_end = true
    # Initial temperature of block
    initial_T = ${T_ext_cond}
    # Temperature to evaluate heat pipe limit approximations
    T_ref = T_evap_inner
  []

  [condenser_boundary]
    type = HSBoundaryAmbientConvection
    boundary = 'hp:cond:outer'
    hs = hp
    T_ambient = ${T_ext_cond}
    htc_ambient = ${htc_ext_cond} # large value to approach an effective DirichletBC
    scale_pp = bc_scale_pp        # A trivial scale_pp == 1
  []
  [evaporator_boundary]
    type = HSBoundaryExternalAppConvection
    boundary = 'hp:evap:outer'
    hs = hp
    T_ext = T_wall_var
    htc_ext = htc_wall_var
    scale_pp = bc_scale_pp        # A trivial scale_pp == 1
  []
[]

[AuxKernels]
  [flux_uo]
    type = SpatialUserObjectAux
    variable = flux_uo
    user_object = flux_uo
  []
[]

[UserObjects]
  [flux_uo]
    type = LayeredSideDiffusiveFluxAverage
    direction = z
    num_layers = 100
    variable = T_solid
    execute_on = linear
    boundary = 'hp:evap:outer'
    diffusivity = ${fparse 22.6 * corr_factor}
  []
[]

[Functions]
  [hp_ax1_vf]
    type = VectorPostprocessorFunction
    argument_column = z
    component  = z
    value_column = T_solid
    vectorpostprocessor_name = hp_ax1
  []
  [flux_vf]
    type = VectorPostprocessorFunction
    argument_column = z
    component  = z
    value_column = main_flux
    vectorpostprocessor_name = flux_vpp
  []
  [scale_fcn]
    type = ParsedFunction
    vars = 'catastrophic_pp recoverable_pp operational_pp'
    vals = 'catastrophic_pp recoverable_pp operational_pp'
    value = 'catastrophic_pp*recoverable_pp*operational_pp'
  []
[]

[AuxVariables]
  [T_wall_var]
    initial_condition = ${T_ext_cond}
  []
  [htc_wall_var]
    initial_condition = ${htc_wall_initial}
  []
  [operational_aux]
    initial_condition = 1
  []
  [main_flux]
    initial_condition = ${q_evap}
  []
  [hp_temp_aux]
    initial_condition = ${T_ext_cond}
  []
  [flux_uo]
    initial_condition = 0.0
  []
[]

[Postprocessors]
  [total_evap_heat]
    type = SideIntegralVariablePostprocessor
    variable = flux_uo
    boundary = 'hp:evap:outer'
    execute_on = 'initial timestep_begin TIMESTEP_END'
  []
  [total_evap_heat_exam]
    type = LinearCombinationPostprocessor
    pp_names = 'total_evap_heat'
    pp_coefs = '${fparse 2 * pi * R_hp_hole}'
    execute_on = 'initial timestep_begin TIMESTEP_END'
  []
  [avg_flux_uo]
    type = ElementAverageValue
    variable = flux_uo
    execute_on = 'initial timestep_begin TIMESTEP_END'
  []
  [Integral_BC_Total]
    type = LinearCombinationPostprocessor
    pp_names = 'condenser_boundary_integral evaporator_boundary_integral'
    pp_coefs = '1 1'
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
    fp_2phase = fp_2phase
    T = T_inner_avg
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [recoverable_pp]
    type = HeatRemovalRateLimitScale
    heat_addition_pps = 'evaporator_boundary_integral'
    limit_condenser_side = false
    catastrophic_heat_removal_limit_pps = ''
    recoverable_heat_removal_limit_pps = 'hp_sonic_limit hp_viscous_limit'
    fp_2phase = fp_2phase
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
[]

[VectorPostprocessors]
  [hp_ax1]
    type = SideValueSampler
    variable = T_solid
    boundary = 'hp:evap:outer'
    sort_by = z
    execute_on = 'timestep_begin TIMESTEP_END'
  []
  [env_vpp]
    type = NodalValueSampler
    variable = T_solid
    block = 'hp:clad'
    sort_by = x
    execute_on = 'INITIAL TIMESTEP_END'
  []
  [flux_vpp]
    type = SideValueSampler
    variable = main_flux
    boundary = 'hp:evap:inner'
    sort_by = z
    execute_on = 'timestep_begin TIMESTEP_END'
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

  nl_abs_tol = 1e-8
  nl_rel_tol = 1e-9
  nl_max_its = 15

  l_tol = 1e-3
  l_max_its = 10

  automatic_scaling = true
  compute_scaling_once = false

  start_time = -3e4 # Usually, this needs to be compatible with the Main App
  end_time = 0
  dtmin = 1
  dt = 1000
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
    execute_vector_postprocessors_on = 'INITIAL FINAL FAILED'
  []
[]
