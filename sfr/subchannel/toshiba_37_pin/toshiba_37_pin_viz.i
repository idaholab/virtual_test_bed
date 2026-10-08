################################################################################
## SFR 37 pin assembly benchmark                                              ##
## MultiApp for visualization of output                                       ##
## POC : Mauricio Tano, mauricio.tanoretamales at inl.gov                     ##
################################################################################
## If using or referring to this model, please cite as explained in
## https://mooseframework.inl.gov/virtual_test_bed/citing.html

[Mesh]
  [subchannel]
    type = SCMDetailedTriAssemblyMeshGenerator
    nrings = 4
    n_cells = 20
    flat_to_flat = 0.085
    heated_length = 1.0
    pin_diameter = 0.01
    pitch = 0.012
  []
[]

[AuxVariables]
  [mdot]
    block = subchannel
  []
  [SumWij]
    block = subchannel
  []
  [P]
    block = subchannel
  []
  [DP]
    block = subchannel
  []
  [h]
    block = subchannel
  []
  [T]
    block = subchannel
  []
  [Tpin]
    block = fuel_pins
  []
  [Dpin]
    block = fuel_pins
  []
  [rho]
    block = subchannel
  []
  [mu]
    block = subchannel
  []
  [S]
    block = subchannel
  []
  [w_perim]
    block = subchannel
  []
  [q_prime]
    block = fuel_pins
  []
[]

[Problem]
  type = NoSolveProblem
[]

[Outputs]
  exodus = true
[]

[Executioner]
    type = Steady
[]
