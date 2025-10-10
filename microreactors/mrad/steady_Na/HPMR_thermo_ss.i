################################################################################
## NEAMS Micro-Reactor Application Driver                                     ##
## Heat Pipe Microreactor with Na Working Fluid Steady State (Na-HPMR) SS     ##
## BISON Child Application input file                                         ##
## Thermal Only Physics                                                       ##
################################################################################

# The majority of the input file is the same as the K-HPMR model
!include '../steady/HPMR_thermo_ss.i'

[Variables]
  [temp]
    initial_condition := 900
  []
[]

[BCs]
  [outside_bc]
    T_infinity := 900
  []
[]

[MultiApps]
  [sockeye]
    sub_cycling := false
    catch_up := true
    max_catch_up_steps := 1e4
  []
[]

[Preconditioning]
  [SMP]
    type = SMP
    full = true
  []
[]

[Executioner]
  petsc_options_iname := '-pc_type -pc_factor_mat_solver_package -ksp_gmres_restart'
  petsc_options_value := 'lu       superlu_dist                  51'
  line_search = 'none'

  dtmin := 1e-4
  dtmax = 5000
  num_steps := 4294967295

  automatic_scaling = true
  compute_scaling_once = false

  [TimeStepper]
    type = IterationAdaptiveDT
    dt = 0.1
  []
[]
