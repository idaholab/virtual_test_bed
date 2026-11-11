################################################################################
## NEAMS Micro-Reactor Application Driver                                     ##
## Gas Cooled Microreactor Full Core Steady State                             ##
## Griffin Main Application input file                                        ##
## DFEM-SN (1, 3) with CMFD acceleration                                      ##
## If using or referring to this model, please cite as explained in           ##
## https://mooseframework.inl.gov/virtual_test_bed/citing.html                ##
################################################################################

!include ../common/MP_Griffin_base.i

[Mesh]
  parallel_type = DISTRIBUTED
[]

[Executioner]
  type = SweepUpdate
  # Richardson iterations
  richardson_abs_tol = 1e-8
  richardson_rel_tol = 1e-9
  richardson_value = eigenvalue
  richardson_max_its = 1000
  max_inner_its = 20

  diffusion_eigen_solver_type = newton
  diffusion_prec_type = lu
[]

[AuxVariables]
  [Tf]
    initial_condition = 725.0
  []
  # We do not calculate hydrogen concentration evolution in this case
  # So nH is just used as a constant
  [nH]
    initial_condition = 1.94
  []
[]

[TransportSystems]
  equation_type = eigenvalue
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
    writing = true
    execute_on = final
  []
[]

[Outputs]
  checkpoint = false
  [exodus]
    type = Exodus
    execute_on = 'FINAL'
    enable = false
  []
[]

[MultiApps]
  [bison]
    type = FullSolveMultiApp
    input_files = MP_BISON_ss.i
    execute_on = 'timestep_end'
    keep_solution_during_restore = true
    # no need for steady state neutronics
    update_old_solution_when_keeping_solution_during_restore = false
  []
[]
