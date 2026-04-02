################################################################################
## NEAMS Micro-Reactor Application Driver                                     ##
## Heat Pipe Microreactor with Na Working Fluid Null Transient (Na-HPMR) TrN  ##
## BISON Child Application input file                                         ##
## Thermal Only Physics                                                       ##
################################################################################

# The majority of the input file is the same as the K-HPMR model
!include 'HPMR_thermo_trN_base.i'

[Problem]
  restart_file_base := '../steady_Na/HPMR_dfem_griffin_ss_out_bison0_cp/LATEST'
[]

[Mesh]
  file := '../steady_Na/HPMR_dfem_griffin_ss_out_bison0_cp/LATEST'
  parallel_type = distributed
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
[]
