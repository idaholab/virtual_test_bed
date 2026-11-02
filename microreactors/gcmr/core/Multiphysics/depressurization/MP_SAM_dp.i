################################################################################
## NEAMS Micro-Reactor Application Driver                                     ##
## Gas Cooled Microreactor Full Core Coolant Depressurization                 ##
## SAM/THM Grandchild Application input file                                  ##
## Helium coolant channel model                                               ##
## If using or referring to this model, please cite as explained in           ##
## https://mooseframework.inl.gov/virtual_test_bed/citing.html                ##
################################################################################

!include ../common/MP_SAM_base.i

Vin = 15 # Average flow velocity
Tin = 873.15 # 600 C

[Functions]
  [Pout_func]
    type = ParsedFunction
    expression = 'if(t<t0,P0+(Pt-P0)/t0*t,Pt)'
    symbol_names = 'P0 Pt t0'
    symbol_values = '7e6 0.1e6 13'
  []
  [Vin_func]
    type = ParsedFunction
    expression = 'if(t<t0,V0+(Vt-V0)/t0*t,Vt)'
    symbol_names = 'V0 Vt t0'
    symbol_values = '15 1.05 13'
  []
[]

[ChainControls]
  # Gets the value of the Vin_func function
  [inlet_v_fn]
    type = GetFunctionValueChainControl
    function = Vin_func
    execute_on = 'INITIAL TIMESTEP_BEGIN'
  []
  # Sets the inlet vel parameter
  [inlet_v_ctrl]
    type = SetRealValueChainControl
    parameter = component::inlet/vel
    value = inlet_v_fn:value
    execute_on = 'INITIAL TIMESTEP_BEGIN'
  []
  # Gets the value of the Pout_func function
  [outlet_P_fn]
    type = GetFunctionValueChainControl
    function = Pout_func
    execute_on = 'INITIAL TIMESTEP_BEGIN'
  []
  # Sets the outlet p parameter
  [outlet_P_ctrl]
    type = SetRealValueChainControl
    parameter = component::outlet/p
    value = outlet_P_fn:value
    execute_on = 'INITIAL TIMESTEP_BEGIN'
  []
[]

[Executioner]
  start_time = 0
  end_time = 3000
  dt = 100
[]

[Outputs]
  console = true
[]
