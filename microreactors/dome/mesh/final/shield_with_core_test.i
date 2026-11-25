
# This input file is used for testing shield_with_core.i. The following are tested:
# - Total volume of each block
# - Total area of each side set

[Mesh]
  [file_mg]
    type = FileMeshGenerator
    file = shield_with_core.e
  []
[]

[Postprocessors]
  [V_airgap_watertank]
    type = VolumePostprocessor
    block = airgap_watertank
  []
  [V_airgap_door1]
    type = VolumePostprocessor
    block = airgap_door1
  []
  [V_airgap_door2]
    type = VolumePostprocessor
    block = 'airgap_door2 airgap_door2_pyr airgap_door2_tet'
  []
  [V_cavity]
    type = VolumePostprocessor
    block = cavity
  []
  [V_ceiling_1]
    type = VolumePostprocessor
    block = 'ceiling_1 ceiling_1_pyr ceiling_1_tet'
  []
  [V_ceiling_2]
    type = VolumePostprocessor
    block = ceiling_2
  []
  [V_ceiling_3]
    type = VolumePostprocessor
    block = ceiling_3
  []
  [V_ceiling_4]
    type = VolumePostprocessor
    block = ceiling_4
  []
  [V_ceiling_5]
    type = VolumePostprocessor
    block = ceiling_5
  []
  [V_core_heated]
    type = VolumePostprocessor
    block = core_heated
  []
  [V_core_insulation]
    type = VolumePostprocessor
    block = 'core_insulation core_insulation_pyr core_insulation_tet'
  []
  [V_core_insulation_1]
    type = VolumePostprocessor
    block = core_insulation_1
  []
  [V_door_1]
    type = VolumePostprocessor
    block = door_1
  []
  [V_door_2]
    type = VolumePostprocessor
    block = 'door_2 door_2_pyr door_2_tet'
  []
  [V_floor_1]
    type = VolumePostprocessor
    block = floor_1
  []
  [V_floor_2]
    type = VolumePostprocessor
    block = floor_2
  []
  [V_floor_3]
    type = VolumePostprocessor
    block = 'floor_3 floor_3_pyr floor_3_tet'
  []
  [V_tankwall]
    type = VolumePostprocessor
    block = 'tankwall tankwall_pyr tankwall_tet'
  []
  [V_wall_1]
    type = VolumePostprocessor
    block = wall_1
  []
  [V_wall_2]
    type = VolumePostprocessor
    block = wall_2
  []
  [V_wall_3]
    type = VolumePostprocessor
    block = wall_3
  []
  [V_water_tank]
    type = VolumePostprocessor
    block = water_tank
  []
  [V_ground]
    type = VolumePostprocessor
    block = ground
  []

  [A_core_outer]
    type = AreaPostprocessor
    boundary = core_outer
  []
  [A_core_outer_bottom]
    type = AreaPostprocessor
    boundary = core_outer_bottom
  []
  [A_core_outer_side_left]
    type = AreaPostprocessor
    boundary = core_outer_side_left
  []
  [A_core_outer_side_right]
    type = AreaPostprocessor
    boundary = core_outer_side_right
  []
  [A_core_outer_top]
    type = AreaPostprocessor
    boundary = core_outer_top
  []
  [A_inner_surface]
    type = AreaPostprocessor
    boundary = inner_surface
  []
  [A_system_xmin]
    type = AreaPostprocessor
    boundary = system_xmin
  []
  [A_system_xmax]
    type = AreaPostprocessor
    boundary = system_xmax
  []
  [A_system_ymin]
    type = AreaPostprocessor
    boundary = system_ymin
  []
  [A_system_ymax]
    type = AreaPostprocessor
    boundary = system_ymax
  []
  [A_system_zmin]
    type = AreaPostprocessor
    boundary = system_zmin
  []
  [A_system_zmax]
    type = AreaPostprocessor
    boundary = system_zmax
  []
[]

[Problem]
  solve = false
[]

[Executioner]
  type = Steady
[]

[Outputs]
  csv = true
[]
