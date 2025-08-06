threshold = 0.8
vol_frac_threshold=0.33
diffusivity = 1e-3

[Mesh]
  file = msre2D_1X.e
[]

[Variables]
  [diffused]
    order = FIRST
    family = LAGRANGE
  []
[]

[AuxVariables]
    [smooth]
        order = FIRST
        family = LAGRANGE        
    []
[]

[AuxKernels]
    [smoothAux]
        type=ParsedAux
        coupled_variables = 'diffused'
        variable = smooth
        expression = 'diffused>=${threshold}'
    []
[]

[Kernels]
  [diff]
    type = MatDiffusion
    variable = diffused
    diffusivity=${diffusivity}
  []

  # Include our time derivative here
  [timederivative]
    type = TimeDerivative
    variable = diffused

  []
[]

[UserObjects]
    [terminate]
      type = Terminator
      expression = 'elemavg >= ${vol_frac_threshold}'
      fail_mode = HARD
    []
  []



[Postprocessors]
    [elemavg]
        type=ElementAverageValue
        variable=smooth
        execute_on='initial timestep_end'
    [] 
[]


[BCs]
  [conc]
    type = DirichletBC
    variable = diffused
    boundary = 'right_channelboundary'
    value = 1
  []

[]

# Transient (time-dependent) details for simulations go here:
[Executioner]
    type = Transient
  
    solve_type = 'NEWTON'  
    petsc_options_iname = '-pc_type -pc_hypre_type -pc_hypre_boomeramg_strong_threshold'
    petsc_options_value = 'hypre    boomeramg      0.6'

    dt = 0.0005
    end_time = 1
  []
  

# Outputs
[Outputs]
  [exodus]
    type = Exodus

  []

  [csv]
    type = CSV

  []
[]