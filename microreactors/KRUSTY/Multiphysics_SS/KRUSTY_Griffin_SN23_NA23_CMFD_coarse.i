################################################################################
## NEAMS Micro-Reactor Application Driver                                     ##
## KRUSTY Multiphysics Steady State                                           ##
## Griffin neutronics input file (Main App)                                   ##
## Simplified input file using a coarse mesh to facilitate testing            ##
## DFEM-SN (1, 3) NA = 1 with CMFD acceleration                               ##
################################################################################

!include ../Neutronics/Griffin/krusty_ANL22_endf70_hybrid_SN35_NA3_coarse_CMFD.i

[Mesh]
  [fmg]
    file := '../MESH/Griffin_mesh_coarse.e'
  []
  parallel_type = distributed
  displacements = 'disp_x disp_y disp_z'
[]

[AuxVariables]
  [disp_x]
  []
  [disp_y]
  []
  [disp_z]
  []
[]

[TransportSystems]
  [sn]
    NPolar := 1
    NAzmthl := 3
    NA := 1
    order := CONSTANT
    use_displaced_mesh = true
    attempt_using_sweeper_for_dg_kernels = false
  []
[]

[PowerDensity]
  power := 0.01
  integrated_power_postprocessor = integrated_power
[]

[Executioner]
  verbose = true

  richardson_abs_tol := 1e-10
  richardson_rel_tol := 1e-15
  richardson_value = eigenvalue

  richardson_max_its := 100
  max_inner_its = 100
[]

[Materials]
  [all]
    library_file := '../Neutronics/Serp_hbrid_reflector_updated.xml'
    displacements = 'disp_x disp_y disp_z'
  []
[]

[MultiApps]
  [bison]
    type = FullSolveMultiApp
    input_files = KRUSTY_BISON_THERMOMECHANICS.i
    execute_on = 'timestep_end'
    keep_solution_during_restore = true
    # no need for steady state neutronics
    update_old_solution_when_keeping_solution_during_restore = false
    cli_args = "bison_mesh_file='../MESH/BISON_mesh_coarse.e'"
  []
[]

[Transfers]
  [to_sub_power_density]
    type = MultiAppGeneralFieldShapeEvaluationTransfer
    to_multi_app = bison
    source_variable = power_density
    variable = power_density
    from_postprocessors_to_be_preserved = integrated_power
    to_postprocessors_to_be_preserved = total_power
  []
  [from_sub_tempf]
    type = MultiAppGeneralFieldShapeEvaluationTransfer
    from_multi_app = bison
    variable = Tf
    source_variable = Tfuel
  []
  [from_sub_tempm]
    type = MultiAppGeneralFieldShapeEvaluationTransfer
    from_multi_app = bison
    variable = Ts
    source_variable = Tsteel
  []
  [from_sub_disp_x]
    type = MultiAppGeneralFieldShapeEvaluationTransfer
    from_multi_app = bison
    variable = disp_x
    source_variable = disp_x
  []
  [from_sub_disp_y]
    type = MultiAppGeneralFieldShapeEvaluationTransfer
    from_multi_app = bison
    variable = disp_y
    source_variable = disp_y
  []
  [from_sub_disp_z]
    type = MultiAppGeneralFieldShapeEvaluationTransfer
    from_multi_app = bison
    variable = disp_z
    source_variable = disp_z
  []
[]

[UserObjects]
  [ss]
    type = TransportSolutionVectorFile
    transport_system = sn
    writing = true
    execute_on = final
  []
[]
