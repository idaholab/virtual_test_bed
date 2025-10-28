# ==============================================================================
# This is a minimal model that runs the MOOSE application with no output
# Application : MOOSE
# ------------------------------------------------------------------------------
# Idaho Falls, INL, 2025
# Author(s): V Prithivirajan, Ben Spencer
# If using or referring to this model, please cite as explained on
# https://mooseframework.inl.gov/virtual_test_bed/citing.html
# ==============================================================================

[Mesh]
  type = GeneratedMesh
  dim = 1
  nx = 1
[]

[Problem]
  solve = false
[]

[Executioner]
  type = Transient
  dt = 1.0
  end_time = 1.0
[]
