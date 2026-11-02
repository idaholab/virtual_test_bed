################################################################################
## NEAMS Micro-Reactor Application Driver                                     ##
## Gas Cooled Microreactor Full Core Coolant Depressurization                 ##
## Griffin Main Application input file                                        ##
## DFEM-SN (1, 3) with CMFD acceleration                                      ##
## If using or referring to this model, please cite as explained in           ##
## https://mooseframework.inl.gov/virtual_test_bed/citing.html                ##
################################################################################

!include ../common/MP_Griffin_base.i

[Executioner]
  type = TransientSweepUpdate

  richardson_abs_tol = 1e-8
  richardson_rel_tol = 1e-9

  richardson_max_its = 1000
  max_inner_its = 100

  end_time = 3000
  dtmax = 10
  dtmin = 1e-3

  [TimeStepper]
    type = IterationAdaptiveDT
    dt = 1
  []
[]

[TransportSystems]
  equation_type = transient
[]

[GlobalParams]
  library_file = '../../ISOXML/GCMR_XS_2grid_detailed.xml'
  library_name = GCMR_XS_2grid_detailed
  # power normalization
  plus = true
  grid_names = 'Tfuel Hdens'
  grid_variables = 'Tf nH'
[]

[Materials]
  [mod]
    type = CoupledFeedbackMatIDNeutronicsMaterial
    block = '10  100 101 102 103 200 201 400 401 4000 4001 40000 40001 300 301 600 602 603 604 1000 1003 19000 29000 39000 49000 59000 19003 29003 39003 49003 59003 19900 29900 39900 49900 59900 19903 29903 39903 49903 59903 1777 1773 250'
  []
[]

[UserObjects]
  [ss]
    writing = false
    execute_on = initial
    folder = '../steady_state'
  []
[]

[Outputs]
  exodus = false
  checkpoint = true
[]

[MultiApps]
  [bison]
    type = TransientMultiApp
    input_files = MP_BISON_dp.i
    execute_on = 'initial timestep_end'
    sub_cycling = false
  []
[]

[Transfers]
  [to_sub_power_density]
    execute_on = 'timestep_end'
  []
[]
