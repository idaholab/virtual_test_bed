################################################################################
## NEAMS Micro-Reactor Application Driver                                     ##
## Gas Cooled Microreactor Full Core Steady State                             ##
## Balance of Plant (BOP) Loop Coupling                                       ##
## Griffin Main Application input file                                        ##
## DFEM-SN (1, 3) with CMFD acceleration                                      ##
## If using or referring to this model, please cite as explained in           ##
## https://mooseframework.inl.gov/virtual_test_bed/citing.html                ##
################################################################################

!include ../bop_base/MP_Griffin_bop_base.i

[Executioner]
  type = SweepUpdate
  richardson_abs_tol = 1e-8
  richardson_value = eigenvalue
  richardson_max_its = 1000
  max_inner_its = 20
  fixed_point_max_its = 1
  custom_pp = eigenvalue
  custom_rel_tol = 1e-6
  force_fixed_point_solve = true
  cmfd_eigen_solver_type = newton
[]

[TransportSystems]
  equation_type = eigenvalue
[]

[UserObjects]
  [ss]
    writing = true
    execute_on = final
  []
[]

[Outputs]
  [exodus]
    type = Exodus
    execute_on = 'FINAL'
  []
[]

[MultiApps]
  [bison]
    type = FullSolveMultiApp
    input_files = MP_BISON_bop_ss.i
    execute_on = 'timestep_end'
  []
[]
