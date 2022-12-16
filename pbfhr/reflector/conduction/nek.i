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

  nondimensional = true
  U_ref = 0.0575
  T_ref = 923.15
  dT_ref = 10.0
  L_ref = 0.006
  rho_0 = 1962.13
  Cp_0 = 2416.0
[]

[Executioner]
  type = Transient
  timestep_tolerance = 1e-9

  [TimeStepper]
    type = NekTimeStepper
  []
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
[]
