################################################################################
## NEAMS Micro-Reactor Application Driver                                     ##
## Gas Cooled Microreactor Full Core Transient                                ##
## Balance of Plant (BOP) Loop input file                                     ##
## Open-air recuperated Brayton cycle                                         ##
## If using or referring to this model, please cite as explained in           ##
## https://mooseframework.inl.gov/virtual_test_bed/citing.html                ##
################################################################################

!include ../bop_base/MP_THM_loop_bop_base.i

[Functions]
  [pri_torque_func]
    type = ParsedFunction
    expression = 'if(time_simulation<0,init_torque,if(time_simulation>delta_t,fin_torque,init_torque+(fin_torque-init_torque)/delta_t*time_simulation))'
    symbol_names = 'time_simulation init_torque fin_torque delta_t'
    symbol_values = 'time_simulation ${pri_motor_torque} 30 300'
  []
[]

[Components]
  [circ]
    [motor]
      torque = pri_torque_func # ${pri_motor_torque}
    []
  []
[]

[Executioner]
  start_time = 0
  end_time = 10000
[]
