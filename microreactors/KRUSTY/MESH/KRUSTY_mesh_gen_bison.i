################################################################################
## NEAMS Micro-Reactor Application Driver                                     ##
## KRUSTY Mesh Generation                                                     ##
## Input File Using MOOSE Framework/Reactor Module Mesh Generators            ##
## Mesh Modification Input File for BISON                                     ##
## Please contact the authors for mesh generation issues:                     ##
## - Dr. Kun Mo (kunmo@anl.gov)                                               ##
## - Dr. Soon Kyu Lee (soon.lee@anl.gov)                                      ##
################################################################################

fuel_all = '2081 2082 2091 2092 2101 2102 2111 2112 2121 2122 2131 2132 2141 2142 3081 3082 3091 3092 3101 3102 3111 3112 3121 3122 3131 3132 3141 3142 4081 4082 4091 4092 4101 4102 4111 4112 4121 4122 4131 4132 4141 4142'
fuel_names = 'fuel_01 fuel_02 fuel_03 fuel_04 fuel_05 fuel_06 fuel_07 fuel_08 fuel_09 fuel_10
              fuel_11 fuel_12 fuel_13 fuel_14 fuel_15 fuel_16 fuel_17 fuel_18 fuel_19 fuel_20
              fuel_21 fuel_22 fuel_23 fuel_24 fuel_25 fuel_26 fuel_27 fuel_28 fuel_29 fuel_30
              fuel_31 fuel_32 fuel_33 fuel_34 fuel_35 fuel_36 fuel_37 fuel_38 fuel_39 fuel_40
              fuel_41 fuel_42'

Be_all = '14'
Be_names = 'Be_01'

Al_all = '11 13 16' # currenly using Al 6061 properites
Al_names = 'Al_01 Al_02 Al_03'

hp_all = '10'
hp_names = 'hp_01'

beo_all = '12 1212 17 9'
beo_names = 'beo_01 beo_02 beo_03 beo_04'

ss_all = '2 3 4 6 71 72 73 8 15 18 19 20 22 23 24' # remove 14; it is Be
ss_names = 'ss_01 ss_02 ss_03 ss_04 ss_05 ss_06 ss_07 ss_08 ss_09 ss_10 ss_11 ss_12 ss_13 ss_14 ss_15'

b4c_all = '5 21'
b4c_names = 'b4c_01 b4c_02'

air_all = '1'
air_names = 'air_01'

hp_fuel_gap_all = '64'
hp_fuel_gap_names = 'hp_fuel_gap'

nonhpgap_all = '${Be_all} ${Al_all} ${hp_all} ${beo_all} ${ss_all} ${b4c_all} ${air_all} ${fuel_all}'
non_hp_all = '${Be_all} ${Al_all} ${beo_all} ${ss_all} ${b4c_all} ${air_all} ${hp_fuel_gap_all} 999'

ss_bot_pos = 0.07065

[Mesh]
  [gen]
    type = FileMeshGenerator
    file = '../gold/MESH/Griffin_mesh.e'
  []
  [rot]
    type = TransformGenerator
    input = gen
    transform = ROTATE
    vector_value = '-90 0 0'
  []
  # Easy to remember block names
  [ren]
    type = RenameBlockGenerator
    input = rot
    old_block = '${Be_all} ${Al_all} ${hp_all} ${beo_all} ${ss_all} ${b4c_all} ${air_all} ${fuel_all} ${hp_fuel_gap_all}'
    new_block = '${Be_names} ${Al_names} ${hp_names} ${beo_names} ${ss_names} ${b4c_names} ${air_names} ${fuel_names} ${hp_fuel_gap_names}'
  []
  # Assign SS bottom so that BCs can be applied
  [ss_down]
    type = SideSetsAroundSubdomainGenerator
    input = ren
    new_boundary = 'ss_down'
    block = 'ss_02'
    fixed_normal = true
    normal = '0 0 -1'
  []
  [ss_bot]
    type = SideSetsFromBoundingBoxGenerator
    input = ss_down
    bottom_left = '-0.001 -0.001 ${fparse ss_bot_pos - 0.0001}'
    top_right = '0.6 0.6 ${fparse ss_bot_pos + 0.02}'
    included_boundaries = 'ss_down'
    boundary_new = 'ss_bot'
  []
  # Adding insulation layer blocks
  [hp_mli]
    type = ParsedSubdomainMeshGenerator
    input = ss_bot
    block_id = 999
    block_name = 'hp_mli'
    combinatorial_geometry = 'z>=0.6 | z<=0.35'
    excluded_subdomains = ${nonhpgap_all}
  []
  [hp_mli_2]
    type = ParsedSubdomainMeshGenerator
    input = hp_mli
    block_id = 998
    block_name = 'hp_mli_2'
    combinatorial_geometry = 'z>=0.24205 & z<=0.2484'
    excluded_subdomains = ${non_hp_all}
  []
  parallel_type = replicated
[]
