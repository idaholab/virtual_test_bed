[Executioner]
  type = Steady
  solve_type = NEWTON
  automatic_scaling = true
  nl_max_its = 50
  nl_abs_tol = 1e-8
  l_tol = 1e-6
  l_max_its = 1000

  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart'
  petsc_options_value = 'hypre boomeramg 100'
[]
