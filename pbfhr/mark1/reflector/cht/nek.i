################################################################################
## FHR bypass flow in outer reflector                                         ##
## Cardinal Sub Application to run NekRS                                      ##
## 3D RANS model                                                              ##
## POC : anovak at anl.gov                                                    ##
################################################################################
# If using or referring to this model, please cite as explained in
# https://mooseframework.inl.gov/virtual_test_bed/citing.html

fluid_solid_interface = '1 2 7'

# Note: the mesh is stored using git large file system (LFS)
[Mesh]
  type = NekRSMesh
  boundary = ${fluid_solid_interface}
  scaling = 0.006
[]

[Problem]
  type = NekRSProblem
  casename = 'fluid'
  n_usrwrk_slots = 1

  [Dimensionalize]
    L = 0.006
    U = 0.0575
    T = 923.15
    dT = 10.0
    rho = 1962.13
    Cp = 2416.0
  []

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
  timestep_tolerance = 1e-9

  [./TimeStepper]
    type = NekTimeStepper
  [../]
[]

[Outputs]
  exodus = true
[]

[Postprocessors]
  [boundary_flux]
    type = NekHeatFluxIntegral
    boundary = ${fluid_solid_interface}
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
  [pressure_in]
    type = NekSideAverage
    field = pressure
    boundary = '5'
  []
  [mdot_in]
    type = NekMassFluxWeightedSideIntegral
    field = unity
    boundary = '5'
  []
  [mdot_out]
    type = NekMassFluxWeightedSideIntegral
    field = unity
    boundary = '6'
  []
[]
