[Mesh]
  [drum]
    type = ConcentricCircleMeshGenerator
    num_sectors = 450
    radii = '13.8 14.8'
    rings = '1 3'
    preserve_volumes = true
    has_outer_square = false
    portion = top_half
  []
  [rename_drum]
    type = RenameBlockGenerator
    input = drum
    old_block = 2
    new_block = 13
  []
  [remove_inner]
    type = BlockDeletionGenerator
    input = rename_drum
    block = 1
    new_boundary = 'boundary_to_fill'
  []
  [inner]
    type = ConcentricCircleMeshGenerator
    num_sectors = 50
    radii = '11 14.8'
    rings = '1 3'
    preserve_volumes = false
    has_outer_square = false
    portion = top_half
  []
  [rename_inner]
    type = RenameBlockGenerator
    input = inner
    old_block = 1
    new_block = 11
  []
  [remove_outer]
    type = BlockDeletionGenerator
    input = rename_inner
    block = 2
    new_boundary = 'boundary_to_fill'
  []
  [fill]
    type = FillBetweenSidesetsGenerator
    input_mesh_1 = remove_inner
    input_mesh_2 = remove_outer
    boundary_1 = boundary_to_fill
    boundary_2 = boundary_to_fill
    num_layers = 5
  []
  [remove_boundaries]
    type = BoundaryDeletionGenerator
    input = fill
    boundary_names = 'outer bottom'
  []
  [add_bottom_boundary]
    type = SideSetsFromNormalsGenerator
    input = remove_boundaries
    normals = '0 -1 0'
    new_boundary = sym
  []
  [mirror]
    type = SymmetryTransformGenerator
    input = add_bottom_boundary
    mirror_normal_vector = '0 -1 0'
    mirror_point = '0 0 0'
  []
  [stitch]
    type = StitchedMeshGenerator
    inputs = 'add_bottom_boundary mirror'
    stitch_boundaries_pairs = 'sym sym'
    clear_stitched_boundary_ids = true
  []
  [rename_block]
    type = RenameBlockGenerator
    input = stitch
    old_block = 1
    new_block = 10
  []
[]
