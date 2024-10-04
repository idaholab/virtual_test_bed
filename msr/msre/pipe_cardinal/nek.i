[Problem]
  type = NekRSProblem
  casename = 'tjunc'

  nondimensional = true
  U_ref = 0.2
  T_ref = 900
  dT_ref = 100
  rho_0 = 1682.32
  Cp_0 = 2390
[]

[Mesh]
  type = NekRSMesh
  volume = true
[]

[Executioner]
  type = Transient
  timestep_tolerance = 1e-10

  [TimeStepper]
    type = NekTimeStepper
  []
[]

[Postprocessors]
[]

[Outputs]
  exodus = true
  execute_on = 'final'
[]
