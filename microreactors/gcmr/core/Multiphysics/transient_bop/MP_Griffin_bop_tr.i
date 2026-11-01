################################################################################
## NEAMS Micro-Reactor Application Driver                                     ##
## Gas Cooled Microreactor Full Core Transient                                ##
## Balance of Plant (BOP) Loop Coupling                                       ##
## Griffin Main Application input file                                        ##
## DFEM-SN (1, 3) with CMFD acceleration                                      ##
## If using or referring to this model, please cite as explained in           ##
## https://mooseframework.inl.gov/virtual_test_bed/citing.html                ##
################################################################################

!include ../bop_base/MP_Griffin_bop_base.i

[Executioner]
  type = TransientSweepUpdate
  richardson_abs_tol = 1e-5 #8
  richardson_max_its = 50
  max_inner_its = 50
  end_time = 10000
  dtmax = 2 # 5
  dtmin = 1e-3
  [TimeStepper]
    type = IterationAdaptiveDT
    dt = 1
  []
[]

[TransportSystems]
  equation_type = transient
[]

[UserObjects]
  [ss]
    writing = false
    execute_on = initial
    folder = '../steady_state_bop'
  []
[]

[Outputs]
  checkpoint = true
[]

[MultiApps]
  [bison]
    type = TransientMultiApp
    input_files = MP_BISON_bop_tr.i
    execute_on = 'initial timestep_end'
    sub_cycling = true
  []
[]

[Transfers]
  [to_sub_power_density]
    execute_on = 'timestep_end'
  []
[]
