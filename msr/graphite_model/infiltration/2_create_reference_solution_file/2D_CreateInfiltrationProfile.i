# ==============================================================================
# Baseline input file to generate 2D infiltration profiles
# Application : MOOSE
# ------------------------------------------------------------------------------
# Idaho Falls, INL, 2025
# Author(s): V Prithivirajan, Ben Spencer
# If using or referring to this model, please cite as explained on
# https://mooseframework.inl.gov/virtual_test_bed/citing.html
# ==============================================================================
threshold = 0.8
vol_frac_threshold = 0.33
diffusivity = 2e-3

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
    type = ParsedAux
    coupled_variables = 'diffused'
    variable = smooth
    expression = 'diffused>=${threshold}'
  []
[]

[Kernels]
  [diff]
    type = MatDiffusion
    variable = diffused
    diffusivity = ${diffusivity}
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
    type = ElementAverageValue
    variable = smooth
    execute_on = 'initial timestep_end'
  []
[]

[VectorPostprocessors]
  [line]
    type = LineValueSampler
    start_point = '0 0 0'
    end_point = '0.0148 0.0139 0'
    num_points = 100
    sort_by = 'x'
    variable = 'diffused smooth'
    execute_on = FINAL
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

  dt = 0.001
  end_time = 1
[]

# Outputs
[Outputs]
  [csv]
    type = CSV
    execute_vector_postprocessors_on = FINAL
  []
  exodus = true
[]
