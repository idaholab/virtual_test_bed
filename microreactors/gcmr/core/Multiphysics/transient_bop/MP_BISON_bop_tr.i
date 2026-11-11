################################################################################
## NEAMS Micro-Reactor Application Driver                                     ##
## Gas Cooled Microreactor Full Core Transient                                ##
## Balance of Plant (BOP) Loop Coupling                                       ##
## BISON Child Application input file                                         ##
## Heat Transfer in Solid Components                                          ##
## If using or referring to this model, please cite as explained in           ##
## https://mooseframework.inl.gov/virtual_test_bed/citing.html                ##
################################################################################

!include ../bop_base/MP_BISON_bop_base.i

[Problem]
  restart_file_base = '../steady_state_bop/MP_Griffin_bop_ss_out_bison0_cp_cp/LATEST'
[]

[Mesh]
  file = '../steady_state_bop/MP_Griffin_bop_ss_out_bison0_cp_cp/LATEST'
[]

[Kernels]
  # Not included in the steady state to reach the equilibrium faster
  [heat_ie]
    type = HeatConductionTimeDerivative
    variable = temp
  []
[]

[MultiApps]
  [htgr]
    input_files = 'MP_THM_loop_bop_tr.i'
  []
  [coolant_full_MA]
    input_files = 'MP_SAM_bop_tr.i'
  []
[]

[Executioner]
  start_time = 0 #${start_time}
  end_time = 10000
  dtmax = 2 # 5
[]

[Outputs]
  [cp]
    enable = false
  []
[]
