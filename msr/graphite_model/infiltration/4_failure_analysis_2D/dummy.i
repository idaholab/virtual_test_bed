# This is a minimal model that runs the MOOSE applicaition with
# no output
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
