################################################################################
## NEAMS Micro-Reactor Application Driver                                     ##
## Heat Pipe Microreactor with Na Working Fluid Steady State (Na-HPMR) SS     ##
## Sockeye Grandchild Application input file                                  ##
## Liquid-Conductance Vapor-Flow (LCVF) Heat Pipe Model (Vapor-Only)          ##
################################################################################

t_start = -5e4
t_end = 0

length_evap = 1.8
length_adia = 0.3
length_cond = 0.9

n_elems_evap = 360
n_elems_adia = 60
n_elems_cond = 180

n_elems_wick = 8
n_elems_ann  = 4
n_elems_clad = 4

D_clad_o = 2.10e-2
D_clad_i = 1.94e-2
D_wick_o = 1.80e-2
D_wick_i = 1.60e-2

porosity = 0.70
permeability = 2e-9
R_pore = 15e-6

fill_ratio = 1.1
T_ref_fill_ratio = 600

T_ref_rho_wick = 1000.0
T_ref_rho_clad = 1000.0

T_ext_cond = 900
htc_ext_cond = 1.0e6

[FluidProperties]
  [fp_2phase]
    type = SodiumIdealGasTwoPhaseFluidProperties
    emit_on_nan = none
  []
[]

[Closures]
  [closures]
    type = HeatPipeVOClosures
  []
[]

[SolidProperties]
  [sp_ss316]
    type = ThermalSS316Properties
  []
[]

[Components]
  [heat_pipe]
    type = HeatPipeVO

    position_evap_end = '0 0 0'
    direction_evap_to_cond = '0 0 1' # to be compatible with the core mesh
    gravity_vector = '9.8 0 0' # assume the core is horizontal

    L_evap = ${length_evap}
    L_adia = ${length_adia}
    L_cond = ${length_cond}

    D_clad_o = ${D_clad_o}
    D_clad_i = ${D_clad_i}
    D_wick_o = ${D_wick_o}
    D_wick_i = ${D_wick_i}

    porosity = ${porosity}
    permeability = ${permeability}
    R_pore = ${R_pore}

    n_elems_evap = ${n_elems_evap}
    n_elems_adia = ${n_elems_adia}
    n_elems_cond = ${n_elems_cond}

    n_elems_wick = ${n_elems_wick}
    n_elems_ann  = ${n_elems_ann}
    n_elems_clad = ${n_elems_clad}

    initial_T = ${T_ext_cond}

    fill_ratio = ${fill_ratio}
    T_ref_fill_ratio = ${T_ref_fill_ratio}
    T_ref_rho_wick = ${T_ref_rho_wick}
    T_ref_rho_clad = ${T_ref_rho_clad}

    fp_2phase = fp_2phase
    sp_wick = sp_ss316
    sp_clad = sp_ss316
    closures = closures

    slope_reconstruction = NONE
    stop_vapor_at_condenser_pool = true
    startup_front_option = continuum_flow
    D_collision = 0.362e-9
    Kn_transition = 0.01
  []

  [evaporator_boundary]
    type = HSBoundaryExternalAppConvection
    boundary = 'heat_pipe:hs:evap:outer'
    hs = heat_pipe:hs
    T_ext = virtual_Text
    htc_ext = virtual_htc
  []

  # This works but is simplified
  # Improvement needed in the future
  [condenser_boundary]
    type = HSBoundaryAmbientConvection
    boundary = 'heat_pipe:hs:cond:outer'
    hs = heat_pipe:hs
    T_ambient = ${T_ext_cond}
    htc_ambient = ${htc_ext_cond}
  []
[]

[UserObjects]
  [surf_T]
    type = LayeredSideAverage
    direction = z
    num_layers = 180
    variable = T_solid
    boundary = 'heat_pipe:hs:evap:outer'
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
    block = '3 4 5'
  []
[]


[AuxVariables]
  [T_wall_var]
    initial_condition = ${T_ext_cond}
  []
  [operational_aux]
    initial_condition = 1
  []
  [master_flux]
    initial_condition = 0
  []
  [master_t_solid]
    initial_condition = ${T_ext_cond}
  []
  [hp_temp_aux]
    initial_condition = ${T_ext_cond}
  []
  [virtual_Text]
    initial_condition = ${T_ext_cond}
  []
  [virtual_htc]
    initial_condition = 1.0
  []
[]

[Postprocessors]
  [refill]
    type = FunctionValuePostprocessor
    function = '1'
    execute_on = 'INITIAL TIMESTEP_END'
  []
[]

[Preconditioning]
  [pc]
    type = SMP
    full = true
  []
[]

# Added dampers as some NAN behavior was observed
[Dampers]
  [max_T]
    type = MaxIncrement
    increment_type = fractional
    max_increment = 0.5
    variable = T_solid
  []
  [bd_rhoA]
    type = BoundingValueElementDamper
    variable = rhoA
    min_value = 0.0
    min_damping = 0.001
  []
  [bd_rhoEA]
    type = BoundingValueElementDamper
    variable = rhoEA
    min_value = 0.0
    min_damping = 0.001
  []
[]

[Executioner]
  type = Transient

  scheme = bdf2
  start_time = ${t_start}
  end_time = ${t_end}

  dtmin = 1e-4
  dtmax = 5000

  [TimeStepper]
    type = IterationAdaptiveDT
    dt = 0.1
    optimal_iterations = 15
    iteration_window = 2
    growth_factor = 2
    cutback_factor = 0.8
  []

  [Quadrature]
    type = GAUSS
    order = SECOND
  []

  ## PJFNK + superlu seems to make the problem converge faster
  solve_type = PJFNK
  petsc_options = '-snes_ksp_ew'
  petsc_options_iname = '-pc_type -pc_factor_mat_solver_package -ksp_gmres_restart'
  petsc_options_value = 'lu       superlu_dist                  101'

  nl_abs_tol = 1e-8
  nl_rel_tol = 1e-8
  nl_max_its = 25

  l_tol = 1e-3
  l_max_its = 10

  automatic_scaling = true
  compute_scaling_once = false
[]

[Outputs]
  csv = false
  exodus = false
  [console]
    type = Console
    execute_postprocessors_on = 'NONE'
  []
[]
