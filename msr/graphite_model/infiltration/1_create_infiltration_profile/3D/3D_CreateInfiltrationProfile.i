# ==============================================================================
# Generation of 3D Molten Salt Infiltration Profiles in Graphite
# Application : MOOSE
# ------------------------------------------------------------------------------
# Idaho Falls, INL, 2025
# Author(s): V Prithivirajan, Ben Spencer
# If using or referring to this model, please cite as explained on
# https://mooseframework.inl.gov/virtual_test_bed/citing.html
# ==============================================================================

# The diffusion field profile is smooth and continuous, but for this problem
# we need a binary field (infiltrated vs. no infiltration), mimicking the physical behavior.
# The threshold value converts the continuous field to a binary field.
threshold = 0.8

# vol_frac_threshold represents the infiltration volume fraction
vol_frac_threshold = 0.08

#Diffusivity constant
diffusivity = 2e-3 #m^/s

# 3D msre mesh file
[Mesh]
  file = 'msre3D_0PF_Fine.e'
[]

#diffusion field variable, representing the salt infiltration
[Variables]
  [diffused]
    order = FIRST
    family = LAGRANGE
  []
[]

#smooth is a binary variable, obtained by penalizing diffused variable
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

# Governing equation for diffusion
[Kernels]
  [diff]
    type = MatDiffusion
    variable = diffused
    diffusivity = ${diffusivity}
  []

  [timederivative]
    type = TimeDerivative
    variable = diffused
  []
[]

# terminate stops the simulation when the desired volume fraction is reached
[UserObjects]
  [terminate]
    type = Terminator
    expression = 'elemavg > ${vol_frac_threshold}'
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
    start_point = '0 0 1.6637'
    end_point = '0.0148 0.0139 0'
    num_points = 100
    sort_by = 'z'
    variable = 'diffused smooth'
    execute_on = FINAL
  []
[]

# Boundary condition
[BCs]
  [conc]
    type = DirichletBC
    variable = diffused
    boundary = 'coolantchannelboundary'
    value = 1
  []
[]

# Solver settings
[Executioner]
  type = Transient

  solve_type = 'NEWTON'
  petsc_options_iname = '-pc_type -pc_hypre_type -pc_hypre_boomeramg_strong_threshold'
  petsc_options_value = 'hypre    boomeramg      0.6'

  dt = 0.001   #s
  end_time = 1 #s
[]

# Outputs
[Outputs]
  [csv]
    type = CSV
    execute_vector_postprocessors_on = FINAL
  []
[]
