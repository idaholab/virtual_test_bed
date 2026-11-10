[Kernels]
  [time_derivative]
    type = ADHeatConductionTimeDerivative
    variable = T
  []
[]

[Executioner]
  type = Transient
  scheme = bdf2
  end_time = ${units 5000 h -> s}
  [TimeStepper]
    type = IterationAdaptiveDT
    optimal_iterations = 5
    iteration_window = 0
    growth_factor = 1.2
    cutback_factor = 0.8
    dt = 10
  []
  dtmax = ${units 100 h -> s}
  steady_state_detection = true
  steady_state_tolerance = 1e-9

  solve_type = NEWTON
  automatic_scaling = true#
  nl_abs_tol = 1e-10
  l_max_its = 20
  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart -pc_hypre_boomeramg_strong_threshold'
  petsc_options_value = 'hypre boomeramg 100 0.8'
  line_search = basic
[]