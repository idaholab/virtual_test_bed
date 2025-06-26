################################################################################
## Lead Fast Reactor 7-pin assembly
## Cardinal input file to launch and coupled with NekRS CFD simulation
## Documentation: https://mooseframework.inl.gov/virtual_test_bed/lfr/cardinal_7pincell/Cardinal_7pin_LFR_demo.html
## Contact: hansol.park@anl.gov
################################################################################

[Problem]
  type = NekRSProblem
  synchronization_interval = parent_app

  # This input is run in nondimensional form to verify that all the postprocessors
  # and data transfers in/out of nekRS are properly dimensionalized.
  [Dimensionalize]
    U= 0.1186 #U0
    T= 693.15 #t0 K
    dT= 100 #deltaT
    L= 0.0108
    rho = 10401.75
    Cp = 144.19
  []

# t* = L_ref/U_ref = 0.091062394603710
# t_nondim = 1.0e-02
# t_nekrs = 0.9106239460371001 ms

  [FieldTransfers]
    [avg_flux]
      type = NekBoundaryFlux
      conserve_flux_by_sideset = true
      direction = to_nek
      postprocessor_to_conserve = flux_integral
      usrwrk_slot = 0
    []
    [temp]
      type = NekFieldVariable
      direction = from_nek
      field = temperature
    []
  []

  casename = 7pin
[]

[Mesh]
  type = NekRSMesh
  boundary = '3 4'
  volume = true

  # nekRS runs in non-dimensional form, which means that we shrunk the mesh
  # from physical units of meters to our characteristic scale of 1
  # That means that we must multiply
  # the nekRS mesh by 0.008638 to get back in units of meters that MOOSE is
  # running in.
  scaling = 0.0108
[]

[Executioner]
  type = Transient
  timestep_tolerance = 1e-10

  [TimeStepper]
    type = NekTimeStepper
  []
[]

[Postprocessors]
  [synchronization_in]
    type = Receiver
  []

  # side area integral
  [RodSurface]
    type = NekSideIntegral
    field = unity
    boundary = '3'
  []
  [DuctInnerSurface]
    type = NekSideIntegral
    field = unity
    boundary = '4'
  []

  # volume integral
  [volume]
    type = NekVolumeIntegral
    field = unity
  []

  # Temperature
  [side_T_avg_rod]
    type = NekSideAverage
    field = temperature
    boundary = '3'
  []
  [side_T_avg_duct]
    type = NekSideAverage
    field = temperature
    boundary = '4'
  []
  [inlet_T_avg]
    type = NekSideAverage
    field = temperature
    boundary = '1'
  []
  [outlet_T_avg]
    type = NekSideAverage
    field = temperature
    boundary = '2'
  []

  [side_T_max_rod]
    type = NekSideExtremeValue
    field = temperature
    boundary = '3'
  []
  [side_T_max_duct]
    type = NekSideExtremeValue
    field = temperature
    boundary = '4'
  []
  [inlet_T_max]
    type = NekSideExtremeValue
    field = temperature
    boundary = '1'
  []
  [outlet_T_max]
    type = NekSideExtremeValue
    field = temperature
    boundary = '2'
  []

  [vol_T_avg]
    type = NekVolumeAverage
    field = temperature
  []
  [inlet_T_mdotavg]
    type = NekMassFluxWeightedSideAverage
    field = temperature
    boundary = '1'
  []
  [outlet_T_mdotavg]
    type = NekMassFluxWeightedSideAverage
    field = temperature
    boundary = '2'
  []
  [max_T]
    type = NekVolumeExtremeValue
    field = temperature
    value_type = max
  []
  [min_T]
    type = NekVolumeExtremeValue
    field = temperature
    value_type = min
  []

  # heat flux integral
  [nek_flux_rod]
    type = NekHeatFluxIntegral
    boundary = '3'
  []
  [nek_flux_duct]
    type = NekHeatFluxIntegral
    boundary = '4'
  []

  # mass flux weighted integral
  [inlet_mdot]
    type = NekMassFluxWeightedSideIntegral
    field = unity
    boundary = '1'
  []
  [outlet_mdot]
    type = NekMassFluxWeightedSideIntegral
    field = unity
    boundary = '2'
  []
[]

[Outputs]
  exodus = true
  interval = 500
  [screen]
    type = Console
  []
[]
