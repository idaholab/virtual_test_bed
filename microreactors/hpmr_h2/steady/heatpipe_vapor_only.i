# ##################################################################################################################
# AUTHORS:            Stefano Terlizzi and Vincent Labouré
# DATE:               June 2023
# ORGANIZATION:       Idaho National Laboratory (INL), C-110
# CITATION:           S. Terlizzi and V. Labouré. (2023).
#                     "Asymptotic hydrogen redistribution analysis in yttrium-hydride-moderated heat-pipe-cooled
#                     microreactors using DireWolf", Annals of Nuclear Energy, Vol. 186, 109735.
# DESCRIPTION:        Input for single heat pipe.
# FUNDS:              This work was supported by INL Laboratory Directed Research&
#                     Development (LDRD) Program under U.S. Department of Energy (DOE) Idaho Operations Office,
#                     United States of America contract DE-AC07-05ID14517.
# ##################################################################################################################
length_evap = 1.8
length_adia = 0.3
length_cond = 0.9

n_elems_evap = 60
n_elems_adia = 10
n_elems_cond = 30
n_elems_wick = 3
n_elems_ann = 3
n_elems_clad = 3

R_clad_o = 0.01
t_clad = 1.15e-03
t_ann = 8.35e-04
t_wick = 1.00e-03
R_pore = 1.5e-05
porosity = 7.06e-01
permeability = 1.80e-10

D_clad_o = '${fparse 2 * R_clad_o}'
D_clad_i = '${fparse D_clad_o - 2 * t_clad}'
D_wick_o = '${fparse D_clad_i - 2 * t_ann}'
D_wick_i = '${fparse D_wick_o - 2 * t_wick}'

magnitude_of_gravity = 9.805

S_evap = '${fparse pi * D_clad_o * length_evap}'
num_sides = 12 # number of sides of heat pipe as a result of mesh polygonization
alpha = '${fparse 2 * pi / num_sides}'
perimeter_correction = '${fparse 0.5 * alpha / sin(0.5 * alpha)}' # polygonization correction factor for perimeter
area_correction = '${fparse sqrt(alpha / sin(alpha))}' # polygonization correction factor for area
surface_correction = '${fparse area_correction / perimeter_correction}' # because mesh is volume preserving

T_sink = 900
htc_sink = 1e3

T_init = 950
T_ext = ${T_init}
htc_evap = 1e6 # chosen very large in lieu of a DirichletBC to obtain conservation

weight = 1 # set to 0.5 for half-HP (i.e. cut by the mesh)

fill_ratio = 1.01
T_ref_fill_ratio = '${fparse T_sink - 50}'

[GlobalParams]
  initial_T = ${T_init}
[]

[Closures]
  [sockeye]
    type = HeatPipeVOClosures
  []
[]

[FluidProperties]
  [fp_2phase]
    type = SodiumIdealGasTwoPhaseFluidProperties
  []
[]

[SolidProperties]
  [clad_mat]
    type = ThermalSS316Properties
  []
[]

[Components]
  [heat_pipe]
    type = HeatPipeVO

    position_evap_end = '0 0 0'
    direction_evap_to_cond = '0 0 1'

    n_elems_evap = ${n_elems_evap}
    n_elems_adia = ${n_elems_adia}
    n_elems_cond = ${n_elems_cond}

    n_elems_wick = ${n_elems_wick}
    n_elems_ann = ${n_elems_ann}
    n_elems_clad = ${n_elems_clad}

    fill_ratio = ${fill_ratio}
    T_ref_fill_ratio = ${T_ref_fill_ratio}

    T_ref_rho_wick = ${T_sink}
    T_ref_rho_clad = ${T_sink}

    gravity_vector = '0 -${magnitude_of_gravity} 0' # horizontal HP

    fp_2phase = fp_2phase
    sp_wick = clad_mat
    sp_clad = clad_mat
    closures = sockeye

    D_clad_o = ${D_clad_o}
    D_clad_i = ${D_clad_i}
    D_wick_i = ${D_wick_i}
    D_wick_o = ${D_wick_o}
    R_pore = ${R_pore}
    porosity = ${porosity}
    permeability = ${permeability}

    L_evap = ${length_evap}
    L_adia = ${length_adia}
    L_cond = ${length_cond}
    slope_reconstruction = NONE
    stop_vapor_at_condenser_pool = false
  []

  [evaporator_boundary]
    type = HSBoundaryExternalAppConvection
    boundary = 'heat_pipe:hs:evap:outer'
    hs = heat_pipe:hs
    T_ext = T_ext_var
    htc_ext = htc_evap_var
  []
  [adiabatic_boundary]
    type = HSBoundaryHeatFlux
    boundary = 'heat_pipe:hs:adia:outer'
    hs = heat_pipe:hs
    q = 0.0
  []
  [condenser_boundary]
    type = HSBoundaryExternalAppConvection
    boundary = 'heat_pipe:hs:cond:outer'
    hs = heat_pipe:hs
    T_ext = T_cond_var
    htc_ext = htc_cond_var
  []
[]

[AuxVariables]
  [T_ext_var]
    initial_condition = ${T_ext}
  []
  [htc_evap_var]
    initial_condition = ${htc_evap}
  []
  [htc_cond_var]
    initial_condition = ${htc_sink}
  []
  [T_cond_var]
    initial_condition = ${T_sink}
  []
[]

[Postprocessors]
  [Text_avg]
    type = SideAverageValue
    variable = T_ext_var
    boundary = 'heat_pipe:hs:evap:outer'
    execute_on = 'INITIAL TIMESTEP_END'
  []

  [htc_equiv_cond]
    type = ParsedPostprocessor
    expression = 'evaporator_boundary_integral / (Text_avg - T_secondary) / ${S_evap} / ${surface_correction}'
    pp_names = 'evaporator_boundary_integral Text_avg T_secondary' # evaporator_boundary_integral is the true numerical flux through the heat_pipe:hs:evap:outer
  []
  [T_secondary]
    type = Receiver
    default = ${T_sink}
  []
  [total_condenser_power]
    type = ParsedPostprocessor
    expression = '-${weight} * condenser_boundary_integral'
    pp_names = 'condenser_boundary_integral'
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
  scheme = bdf2

  end_time = 3e4
  dtmin = 1e-8
  timestep_tolerance = 1e-6

  [TimeStepper]
    type = IterationAdaptiveDT
    growth_factor = 1.5
    dt = 1e-3
  []

  steady_state_detection = true
  steady_state_tolerance = 1e-8

  solve_type = NEWTON
  petsc_options_iname = '-pc_type'
  petsc_options_value = 'lu'

  nl_abs_tol = 1e-8
  nl_rel_tol = 1e-8
  nl_max_its = 15

  l_tol = 1e-3
  l_max_its = 10
[]

[Outputs]
  csv = true
  print_linear_converged_reason = false
  print_nonlinear_converged_reason = false
  print_linear_residuals = false

  [console]
    type = Console
    max_rows = 2
  []
[]
