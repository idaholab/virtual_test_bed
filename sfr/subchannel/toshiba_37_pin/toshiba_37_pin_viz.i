################################################################################
## SFR 37 pin assembly benchmark                                              ##
## MultiApp for visualization of output                                       ##
## POC : Mauricio Tano, mauricio.tanoretamales at inl.gov                     ##
################################################################################
## If using or referring to this model, please cite as explained in
## https://mooseframework.inl.gov/virtual_test_bed/citing.html

[Mesh]
  [subchannel]
    type = DetailedTriSubChannelMeshGenerator
    nrings = 4
    n_cells = 100
    flat_to_flat = 0.085
    heated_length = 1.0
    rod_diameter = 0.01
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
  [rho]
    block = subchannel
  []
  [S]
    block = subchannel
  []
  [w_perim]
    block = subchannel
  []
  [mu]
    block = subchannel
  []
  [q_prime]
    block = subchannel
  []
  [displacement]
    block = subchannel
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
