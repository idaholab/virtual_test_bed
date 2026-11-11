################################################################################
## NEAMS Micro-Reactor Application Driver                                     ##
## Gas Cooled Microreactor Full Core Transient                                ##
## Balance of Plant (BOP) Loop Coupling                                       ##
## SAM/THM Grandchild Application input file                                  ##
## Helium coolant channel model                                               ##
## If using or referring to this model, please cite as explained in           ##
## https://mooseframework.inl.gov/virtual_test_bed/citing.html                ##
################################################################################

!include ../bop_base/MP_SAM_bop_base.i

[Executioner]
  start_time = 0
  end_time = 10000
[]
