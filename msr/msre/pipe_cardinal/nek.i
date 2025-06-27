[Problem]
  type = NekRSProblem
  casename = 'tjunc'

  [Dimensionalize]
    U= 0.2
    T= 900
    dT= 100
    rho = 1682.32
    Cp = 2390
  []

  [FieldTransfers]
    [temp]
      type = NekFieldVariable
      direction = from_nek
      field = temperature
    []
  []
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
