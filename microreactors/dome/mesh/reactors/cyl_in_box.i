### Core mesh for DOME shield mesh
# all dimensions & material properties are from 'DOME Shield Conceptual Design'
# all dimensions are in feet

### April 2024 - Lise Charlot lise.charlot@inl.gov

r_core = 2.5
insulation_thickness =${fparse 1/12}

[Mesh]

  #### CORE ####
  [Core]
    type = PolygonConcentricCircleMeshGenerator
    polygon_size = 4
    polygon_size_style = apothem
    ring_intervals = 5
    ring_radii = ${r_core}
    num_sectors_per_side = '16 16 16 16'
    num_sides = 4
    duct_sizes_style = apothem
    duct_sizes = '3.8'
    duct_intervals = 8
    background_intervals = 8
  []
  [rename_core_blocks]
    type = RenameBlockGenerator
    old_block = '4'
    new_block = '3'
    input = Core
  []
  [extrude_core]
    type = AdvancedExtruderGenerator
    input = rename_core_blocks
    direction = '0 0 1'
    num_layers = '16 26 16'
    heights = '1 13 1'
    subdomain_swaps = '2 3;
                       2 2;
                       2 3'
  []

  [add_insulation_name]
    type = RenameBlockGenerator
    input = extrude_core
    old_block = '1 3'
    new_block = 'core_insulation_1 core_insulation'
  []
  [add_core_name]
    type = RenameBlockGenerator
    input = add_insulation_name
    old_block = 2
    new_block = core_heated
  []
  [rotate_core]
    type = TransformGenerator
    transform = ROTATE
    input = add_core_name
    vector_value = '0 0 45'
  []
  [rotate_core_again]
    type = TransformGenerator
    transform = ROTATE
    input = rotate_core
    vector_value = '0 90 0'
  []

  [translate_core]
    type = TransformGenerator
    input = rotate_core_again
    transform = TRANSLATE
    vector_value = '13.5 27 ${fparse 6. + insulation_thickness}'
  []
  [renumber_boundaries_core]
    type = RenameBoundaryGenerator
    input = translate_core
    old_boundary = '10000 10001 10002'
    new_boundary = 'core_outer core_back core_door '
  []
  [core_outer_bottom]
    type = ParsedGenerateSideset
    input = renumber_boundaries_core
    new_sideset_name = core_outer_bottom
    combinatorial_geometry = 'abs(z-(2.+${insulation_thickness}))<1e-10'
  []
  [core_outer_top]
    type = ParsedGenerateSideset
    input = core_outer_bottom
    new_sideset_name = core_outer_top
    combinatorial_geometry = 'abs(z-(10+${insulation_thickness}))<1e-10'
  []
  [core_outer_side_left]
    type = ParsedGenerateSideset
    input = core_outer_top
    new_sideset_name = core_outer_side_left
    combinatorial_geometry = 'abs(x-(9.5))<1e-10'
  []
  [core_outer_side_right]
    type = ParsedGenerateSideset
    input = core_outer_side_left
    new_sideset_name = core_outer_side_right
    combinatorial_geometry = 'abs(x-(17.5))<1e-10'
  []
[]
