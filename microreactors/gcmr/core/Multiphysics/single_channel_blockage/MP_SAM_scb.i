################################################################################
## NEAMS Micro-Reactor Application Driver                                     ##
## Gas Cooled Microreactor Full Core Single Coolant Channel Blockage          ##
## SAM/THM Grandchild Application input file                                  ##
## Helium coolant channel model                                               ##
## If using or referring to this model, please cite as explained in           ##
## https://mooseframework.inl.gov/virtual_test_bed/citing.html                ##
################################################################################

!include ../common/MP_SAM_base.i

Vin = 15 # Average flow velocity
Tin = 873.15 # 600 C

[Executioner]
  start_time = 0
  end_time = 3000
  dt = 100
[]

[Outputs]
  console = true
[]
