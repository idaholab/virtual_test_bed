[Mesh]
  file = msre2D_1X.e
[]

#SolutionUserObjects below read the data corresponding 
#to the diffused variable from the external solution files
[UserObjects]

  [sol1]
    type = SolutionUserObject
    mesh = param_study_out_study_app01_exodus.e
    system_variables = diffused
    timestep = LATEST
  []
  [sol2]
    type = SolutionUserObject
    mesh = param_study_out_study_app02_exodus.e
    system_variables = diffused
    timestep = LATEST
  []
  [sol3]
    type = SolutionUserObject
    mesh = param_study_out_study_app03_exodus.e
    system_variables = diffused
    timestep = LATEST
  []
  [sol4]
    type = SolutionUserObject
    mesh = param_study_out_study_app04_exodus.e
    system_variables = diffused
    timestep = LATEST
  []
  [sol5]
    type = SolutionUserObject
    mesh = param_study_out_study_app05_exodus.e
    system_variables = diffused
    timestep = LATEST
  []
  [sol6]
    type = SolutionUserObject
    mesh = param_study_out_study_app06_exodus.e
    system_variables = diffused
    timestep = LATEST
  []
  [sol7]
    type = SolutionUserObject
    mesh = param_study_out_study_app07_exodus.e
    system_variables = diffused
    timestep = LATEST
  []
  [sol8]
    type = SolutionUserObject
    mesh = param_study_out_study_app08_exodus.e
    system_variables = diffused
    timestep = LATEST
  []
  [sol9]
    type = SolutionUserObject
    mesh = param_study_out_study_app09_exodus.e
    system_variables = diffused
    timestep = LATEST
  []
  [sol10]
    type = SolutionUserObject
    mesh = param_study_out_study_app10_exodus.e
    system_variables = diffused
    timestep = LATEST
  []

[]

#SolutionFunctions below obtatins the data from the SolutionUserObject and 
#makes it available as a function for the current simulation 

[Functions]
  [func1]
    type = SolutionFunction
    solution = sol1
    from_variable = diffused
  []
  [func2]
    type = SolutionFunction
    solution = sol2
    from_variable = diffused
  []
  [func3]
    type = SolutionFunction
    solution = sol3
    from_variable = diffused
  []
  [func4]
    type = SolutionFunction
    solution = sol4
    from_variable = diffused
  []
  [func5]
    type = SolutionFunction
    solution = sol5
    from_variable = diffused
  []
  [func6]
    type = SolutionFunction
    solution = sol6
    from_variable = diffused
  []
  [func7]
    type = SolutionFunction
    solution = sol7
    from_variable = diffused
  []
  [func8]
    type = SolutionFunction
    solution = sol8
    from_variable = diffused
  []
  [func9]
    type = SolutionFunction
    solution = sol9
    from_variable = diffused
  []
  [func10]
    type = SolutionFunction
    solution = sol10
    from_variable = diffused
  []

  [combine]
    type = ParsedFunction
    expression = '(t=0.1)*func1 + (t=0.2)*func2 + (t=0.3)*func3 + (t=0.4)*func4 + (t=0.5)*func5 + (t=0.6)*func6 + (t=0.7)*func7 + (t=0.8)*func8 + (t=0.9)*func9 + (t=1)*func10 '
    symbol_names = ' func1 func2 func3 func4 func5 func6 func7 func8 func9 func10 '
    symbol_values = ' func1 func2 func3 func4 func5 func6 func7 func8 func9 func10 '
  []

[]

[AuxVariables]
  [diffuse]
  []
[]

[Variables]
  [dummy]
  []
[]

[Problem]
  kernel_coverage_check = false
  solve = false #?
[]

[AuxKernels]
  [diffuse]
    type = FunctionAux
    function = combine
    variable = diffuse
  []
[]

[Executioner]
  type = Transient
  num_steps = 10
  dt = 0.1
[]

[Outputs]
    exodus = true
[]
  