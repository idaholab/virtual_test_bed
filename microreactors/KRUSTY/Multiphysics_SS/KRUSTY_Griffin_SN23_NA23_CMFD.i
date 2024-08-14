################################################################################
## NEAMS Micro-Reactor Application Driver                                     ##
## KRUSTY Multiphysics Steady State                                           ##
## Griffin neutronics input file (Main App)                                   ##
## DFEM-SN (2, 3) NA = 3 with CMFD acceleration                               ##
################################################################################

!include ../Neutronics/Griffin/krusty_ANL22_endf70_hybrid_SN35_NA3_coarse_CMFD.i

[Mesh]
  [fmg]
    # If you do not have a presplit mesh already, you should generate it first:
    # 1. Uncomment all the mesh blocks in the !include file
    # 2. Use the exodus file in the fmg block
    # 3. Comment the "parallel_type = distributed" line
    # 4. Use moose executable to presplit the mesh
    # Once you have the presplit mesh
    # 1. Comment all the mesh blocks except the fmg block in the !include file
    # 2. Use the cpr file in the fmg block
    # 3. Uncomment the "parallel_type = distributed" line

    file := '../gold/MESH/Griffin_mesh.e'
    # file := 'griffin_mesh.cpr'
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
    NPolar := 2
    NAzmthl := 3
    use_displaced_mesh = true
  []
[]

[PowerDensity]
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
