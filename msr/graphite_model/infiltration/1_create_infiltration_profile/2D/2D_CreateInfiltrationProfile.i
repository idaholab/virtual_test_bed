# ==============================================================================
# Generation of 2D Molten Salt Infiltration Profiles in Graphite
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
vol_frac_threshold = 0.30

#Diffusivity constant
diffusivity = 1e-3 # m^2/s

[Mesh]
  # 2D msre mesh file (saved as a gold file for convenience)
  file = 'gold/2D_CreateInfiltrationProfile_out.e'
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

[AuxKernels]
  [smoothAux]
    type = ParsedAux
    coupled_variables = 'diffused'
    variable = smooth
    expression = 'diffused>=${threshold}'
  []
[]

# terminate stops the simulation when the desired volume fraction is reached
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

# Boundary condition
[BCs]
  [conc]
    type = DirichletBC
    variable = diffused
    boundary = 'right_channelboundary'
    value = 1
  []
[]

# Solver settings
[Executioner]
  type = Transient

  solve_type = 'NEWTON'
  petsc_options_iname = '-pc_type -pc_hypre_type -pc_hypre_boomeramg_strong_threshold'
  petsc_options_value = 'hypre    boomeramg      0.6'

  dt = 0.005   #s
  end_time = 1 #s
[]

# Outputs
[Outputs]
  exodus = true
[]
