################################################################################
## NEAMS Micro-Reactor Application Driver                                     ##
## Gas Cooled Microreactor Full Core Steady State                             ##
## Balance of Plant (BOP) Loop Coupling                                       ##
## BISON Child Application input file                                         ##
## Heat Transfer in Solid Components                                          ##
## If using or referring to this model, please cite as explained in           ##
## https://mooseframework.inl.gov/virtual_test_bed/citing.html                ##
################################################################################

!include ../bop_base/MP_BISON_bop_base.i

he_channel_blocks = '200 201'

[Mesh]
  [fmg]
    type = FileMeshGenerator
    file = '../mesh/BISON_mesh_in.e'
    # file = 'bison-mesh.cpr'
  []
  [bdg_full]
    type = BlockDeletionGenerator
    input = fmg
    block = ${he_channel_blocks}
    new_boundary = ${coolant_channel_bdries}
  []
  [mod_surf]
    type = SideSetsBetweenSubdomainsGenerator
    input = bdg_full
    primary_block = 103
    paired_block = 10
    new_boundary = 'mod_surf'
  []
[]

[Variables]
  [temp]
    initial_condition = ${TsInit}
  []
[]

[AuxVariables]
  [power_density]
    initial_condition = 3e6 #W/m3
  []
  [Tfuel]
    initial_condition = ${Tcin}
  []
  [stoich_griffin]
    initial_condition = 1.94
  []
  [hfluid]
    initial_condition = 1000.00
  []
  [Tfluid]
    initial_condition = ${Tcin}
  []
  [power_density_scalar]
    initial_condition = 1.0
  []
  [Tw_trans]
    initial_condition = ${Tcin}
  []
  [Tm_trans]
    initial_condition = ${Tcin}
  []
  [stoich]
    initial_condition = 1.94
  []
  [cc_flux_aux]
    initial_condition = 0
  []
  [heating_density]
    initial_condition = 0
  []
[]

[MultiApps]
  [htgr]
    input_files = 'MP_THM_loop_bop_ss.i'
  []
  [coolant_full_MA]
    input_files = 'MP_SAM_bop_ss.i'
  []
[]

[Executioner]
  start_time = ${start_time}
  end_time = 0
  dtmax = 1e4
[]
