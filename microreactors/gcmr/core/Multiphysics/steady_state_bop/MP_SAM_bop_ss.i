################################################################################
## NEAMS Micro-Reactor Application Driver                                     ##
## Gas Cooled Microreactor Full Core Steady State                             ##
## Balance of Plant (BOP) Loop Coupling                                       ##
## SAM/THM Grandchild Application input file                                  ##
## Helium coolant channel model                                               ##
## If using or referring to this model, please cite as explained in           ##
## https://mooseframework.inl.gov/virtual_test_bed/citing.html                ##
################################################################################

!include ../bop_base/MP_SAM_bop_base.i

[AuxVariables]
  [h_scaled]
    initial_condition = 2500.00
  []
  [htc]
    initial_condition = 2500.00
  []
  [Tfluid_trans]
    initial_condition = ${Tin}
  []
  [hfluid_trans]
    initial_condition = 2500.0
  []
[]

[Executioner]
  start_time = -2.0e5
  end_time = 0
[]
