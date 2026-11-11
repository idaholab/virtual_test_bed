################################################################################
## NEAMS Micro-Reactor Application Driver                                     ##
## Gas Cooled Microreactor Full Core Steady State                             ##
## SAM/THM Grandchild Application input file                                  ##
## Helium coolant channel model                                               ##
## If using or referring to this model, please cite as explained in           ##
## https://mooseframework.inl.gov/virtual_test_bed/citing.html                ##
################################################################################

!include ../common/MP_SAM_base.i

Vin = 15 # Average flow velocity
Tin = 873.15 # 600 C

[GlobalParams]
  initial_p = ${Pout}
  initial_vel = ${Vin}
  initial_T = ${Tin}
[]

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
  start_time = -2.5e5 # negative start time so we can start running from t = 0
  end_time = 0
  dt = 1e4
[]

[Outputs]
  console = true
[]
