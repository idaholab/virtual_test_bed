################################################################################
## NEAMS Micro-Reactor Application Driver                                     ##
## Gas Cooled Microreactor Full Core Steady State and Transient               ##
## Balance of Plant (BOP) Loop Coupling                                       ##
## SAM/THM Grandchild Application input file                                  ##
## Helium coolant channel model                                               ##
## If using or referring to this model, please cite as explained in           ##
## https://mooseframework.inl.gov/virtual_test_bed/citing.html                ##
## Common base for the steady state and transient inputs                      ##
################################################################################

!include ../common/MP_SAM_base.i

Vin = 0
Tin = 400

[GlobalParams]
  initial_p = ${Pout}
  initial_vel = ${Vin}
  initial_T = ${Tin}
[]

[ControlLogic]
  [core_in_T_fn]
    type = GetFunctionValueControl
    function = core_in_T_func
  []
  [set_inlet_T]
    type = SetComponentRealValueControl
    component = inlet
    parameter = T
    value = core_in_T_fn:value
  []

  [core_out_P_fn]
      type = GetFunctionValueControl
      function = core_out_P_func
  []
  [set_outlet_P]
      type = SetComponentRealValueControl
      component = outlet
      parameter = p
      value = core_out_P_fn:value
  []
  [core_in_vel_fn]
      type = GetFunctionValueControl
      function = core_in_vel_func
  []
  [set_inlet_vel]
      type = SetComponentRealValueControl
      component = inlet
      parameter = vel
      value = core_in_vel_fn:value
  []
[]

[Executioner]
  dtmax = 1e4
  dtmin = 1e-6

  [TimeStepper]
    type = IterationAdaptiveDT
    dt = 0.1
    growth_factor = 2.0
    cutback_factor = 0.8
    cutback_factor_at_failure = 0.8
    optimal_iterations = 15
  []
[]

[Outputs]
  console = false
[]

[Postprocessors]
  # from loop
  [core_in_vel]
    type = Receiver
    default = 0
  []
  [core_in_T]
    type = Receiver
    default = 400
  []
  [core_out_P]
    type = Receiver
    default = 7e6
  []
[]

[Functions]
  [core_in_T_func]
    type = ParsedFunction
    symbol_names = 'core_in_T'
    symbol_values = 'core_in_T'
    expression = 'core_in_T'
  []
  [core_out_P_func]
    type = ParsedFunction
    symbol_names = 'core_out_P'
    symbol_values = 'core_out_P'
    expression = 'core_out_P'
  []
  [core_in_vel_func]
    type = ParsedFunction
    symbol_names = 'core_in_vel'
    symbol_values = 'core_in_vel'
    expression = 'core_in_vel'
  []
[]
