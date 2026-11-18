#
#
# Additional blocks:
# - core_heated: (cylindrical reactor)
# - core_insulation: box insulation around reactor
# - core_insulation_1: cylinder insulation going through center of reactor and box insulation
#
# Additional boundaries:
# - core_outer: outer surface of core
# - core_outer_bottom: bottom surface of core
# - core_outer_side_left: left surface of core
# - core_outer_side_right: right surface of core
# - core_outer_top: top surface of core
# - inner_surface: inner surface of shield

!include params_base.i

# For now, we use a large cavity element volume, since heat conduction through the
# cavity is very small. Depending on the radiation heat transfer treatment, the cavity
# mesh may even be deleted.
cavity_element_volume = 1

nx_cavity = 30

dy_cavity_minus_tankwall = ${fparse dy_cavity - t_tankwall}
ny_cavity_minus_tankwall = 60

dz_cavity_minus_tankwall = ${fparse dz_cavity-2*t_tankwall}
nz_cavity_minus_tankwall = 12

feet_to_m = 0.3048

!include shield_with_core_base.i

[Mesh]
  [cartesian_mg]
    type = CartesianMeshGenerator
    dim = 3
    dx = '${dx_entries_begin} ${dx_cavity} ${dx_entries_end}'
    ix = '${ix_entries_begin} ${nx_cavity} ${ix_entries_end}'
    dy = '${dy_entries_begin} ${dy_cavity_minus_tankwall} ${dy_entries_end}'
    iy = '${iy_entries_begin} ${ny_cavity_minus_tankwall} ${iy_entries_end}'
    dz = '${dz_entries_begin} ${dz_cavity_minus_tankwall} ${dz_entries_end}'
    iz = '${iz_entries_begin} ${nz_cavity_minus_tankwall} ${iz_entries_end}'
  []

  # remove the cavity mesh
  [remove_cavity_mg]
    type = BlockDeletionGenerator
    input = cavity_mg
    block = cavity
    new_boundary = inner_surface
  []
  [shield_transition_mg]
    type = BoundaryElementConversionGenerator
    input = remove_cavity_mg
    boundary_names = 'inner_surface'
    converted_pyramid_element_subdomain_name_suffix = pyr
    converted_tet_element_subdomain_name_suffix = tet
  []

  # import/scale/translate core
  [import_core_mg]
    type = FileMeshGenerator
    file = ../reactors/cyl_in_box.e
  []
  # Loaded mesh has units of ft and starts at (9.5', 12', 2' 1")
  [core_mesh_mg]
    type = TransformGenerator
    input = import_core_mg
    transform = SCALE
    vector_value = '${feet_to_m} ${feet_to_m} ${feet_to_m}'
  []
  [translate_core_mg]
    type = TransformGenerator
    input = core_mesh_mg
    transform = TRANSLATE
    # Note that with this x shift, the reactor is not quite centered in the cavity
    # in the x direction
    # Note 2' 1" = 0.635 m
    vector_value = '0.457 1.5 ${fparse dz_floor2 - 0.635 + dz_core_floor_gap}'
  []

  # merge core_door and core_back into existing core_outer
  [core_door_mg]
    type = RenameBoundaryGenerator
    input = translate_core_mg
    old_boundary = core_door
    new_boundary = core_outer
  []
  [core_back_mg]
    type = RenameBoundaryGenerator
    input = core_door_mg
    old_boundary = core_back
    new_boundary = core_outer
  []

  # generate cavity mesh; 3 steps:
  #   1. create lower-D block of the shield inner surface
  #   2. extract that into its own mesh
  #   3. provide that and the core mesh to XYZDelaunayGenerator to generate cavity mesh
  [add_inner_surface_block_mg]
    type = LowerDBlockFromSidesetGenerator
    input = shield_transition_mg
    sidesets = 'inner_surface'
    new_block_id = 500
    new_block_name = inner_surface_block
  []
  [extract_inner_surface_block_mg]
    type = BlockToMeshConverterGenerator
    input = add_inner_surface_block_mg
    target_blocks = 'inner_surface_block'
  []
  [cavity_xyx_mg]
    type = XYZDelaunayGenerator
    boundary = 'extract_inner_surface_block_mg'
    holes = 'core_back_mg'
    output_subdomain_name = 'cavity'
    output_boundary = 'cavity_outer'
    desired_volume = ${cavity_element_volume}
    stitch_holes = true
    # On the outer surface of 'core_insulation', creates these layers:
    # - PYRAMID5 (inner)
    # - TET4 (outer)
    convert_holes_for_stitching = true
    conversion_method = SURFACE
  []
  [rename_core_surface_blocks_mg]
    type = RenameBlockGenerator
    input = cavity_xyx_mg
    old_block = '11 7'
    new_block = 'core_insulation_pyr core_insulation_tet'
  []
  # combine with shield, cavity, and core meshes
  [stitch_mg]
    type = StitchMeshGenerator
    inputs = 'shield_transition_mg rename_core_surface_blocks_mg'
    stitch_boundaries_pairs = 'inner_surface cavity_outer'
    clear_stitched_boundary_ids = false # to keep 'inner_surface'
  []
  # perform shift to make consistent with OpenMC geometry
  [openmc_shift_mg]
    type = TransformGenerator
    input = stitch_mg
    transform = TRANSLATE
    vector_value = '${openmc_shift_x} ${openmc_shift_y} ${openmc_shift_z}'
  []
[]