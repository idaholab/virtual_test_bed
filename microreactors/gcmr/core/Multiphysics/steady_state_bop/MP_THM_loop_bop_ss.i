################################################################################
## NEAMS Micro-Reactor Application Driver                                     ##
## Gas Cooled Microreactor Full Core Steady State                             ##
## Balance of Plant (BOP) Loop input file                                     ##
## Open-air recuperated Brayton cycle                                         ##
## If using or referring to this model, please cite as explained in           ##
## https://mooseframework.inl.gov/virtual_test_bed/citing.html                ##
################################################################################

!include ../bop_base/MP_THM_loop_bop_base.i

[Components]
  [circ]
    [motor]
      torque = ${pri_motor_torque}
    []
  []
[]

[AuxVariables]
  [PID_trip_status]
    initial_condition = 0
  []
  [heating_density]
    initial_condition = 0
  []
[]

[Executioner]
  start_time = ${start_time}
  end_time = 0
[]
