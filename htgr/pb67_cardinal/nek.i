[Mesh]
  type = NekRSMesh
  boundary = 4
[]

[Problem]
  type = NekRSProblem
  casename = 'pb67'
  n_usrwrk_slots = 1

  [FieldTransfers]
    [avg_flux]
      type = NekBoundaryFlux
      direction = to_nek
      usrwrk_slot = 0
      postprocessor_to_conserve = flux_integral
    []
    [temp]
      type = NekFieldVariable
      direction = from_nek
      field = temperature
    []
  []
[]

[Executioner]
  type = Transient
  [TimeStepper]
    type = NekTimeStepper
  []
[]

[Outputs]
  exodus = true
  interval=1000
[]

[Postprocessors]
  # This is the heat flux in the nekRS solution, i.e. it is not an integral
  # of nrs->usrwrk, instead this is directly an integral of k*grad(T)*hat(n).
  # So this should closely match 'flux_integral'
  [flux_in_nek]
    type = NekHeatFluxIntegral
    boundary = '4'
  []

  [max_nek_T]
    type = NekVolumeExtremeValue
    field = temperature
    value_type = max
  []
  [min_nek_T]
    type = NekVolumeExtremeValue
    field = temperature
    value_type = min
  []
  [average_nek_pebble_T]
    type = NekSideAverage
    boundary = '4'
    field = temperature
  []
[]
