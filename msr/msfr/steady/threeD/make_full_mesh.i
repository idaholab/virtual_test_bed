[Mesh]
  # uniform_refine = 1
  # coord_type = 'RZ'
  # rz_coord_axis = Y
  [fmg]
    type = FileMeshGenerator
    # file = '1_16_MSFR_Fine.e'
    file = '1_16_MSFR_Coarse.e'
  []

  # Rebuild symmetrization
  [hx_top]
    type = ParsedGenerateSideset
    combinatorial_geometry = 'y > 0'
    included_subdomains = '3'
    included_neighbors = '1'
    fixed_normal = true
    normal = '0 1 0'
    new_sideset_name = 'hx_top'
    input = 'fmg'
    output = true
  []
  [transform]
    type = TransformGenerator
    input = 'hx_top'
    transform = 'SCALE'
    vector_value = '0.001 0.001 0.001'
  []
  [symmetry_2]
    type = SymmetryTransformGenerator
    input = transform
    mirror_point = '0 0 0'
    # mirror_normal_vector = '${fparse -sin(pi/64)} 0 ${fparse cos(pi/64)}'
    mirror_normal_vector = '0 0 1'
  []
  [stitch_2]
    type = StitchedMeshGenerator
    inputs = 'symmetry_2 transform'
    stitch_boundaries_pairs = 'Symmetry Symmetry'
  []
  [symmetry_4]
    type = SymmetryTransformGenerator
    input = stitch_2
    mirror_point = '0 0 0'
    mirror_normal_vector = '${fparse -sin(4 * pi/32)} 0 ${fparse cos(4 * pi/32)}'
  []
  [stitch_4]
    type = StitchedMeshGenerator
    inputs = 'symmetry_4 stitch_2'
    stitch_boundaries_pairs = 'Symmetry Symmetry'
  []
  [symmetry_8]
    type = SymmetryTransformGenerator
    input = stitch_4
    mirror_point = '0 0 0'
    mirror_normal_vector = '${fparse -sin(12 * pi/32)} 0 ${fparse cos(12 * pi/32)}'
  []
  [stitch_8]
    type = StitchedMeshGenerator
    inputs = 'symmetry_8 stitch_4'
    stitch_boundaries_pairs = 'Symmetry Symmetry'
  []
  [symmetry_16]
    type = SymmetryTransformGenerator
    input = stitch_8
    mirror_point = '0 0 0'
    mirror_normal_vector = '${fparse -sin(28 * pi/32)} 0 ${fparse cos(28 * pi/32)}'
  []
  [stitch_16]
    type = StitchedMeshGenerator
    inputs = 'symmetry_16 stitch_8'
    stitch_boundaries_pairs = 'Symmetry Symmetry'
  []
  [repair]
    type = MeshRepairGenerator
    input = 'stitch_16'
    fix_node_overlap = true
  []
  [diag]
    type = MeshDiagnosticsGenerator
    input = repair
    examine_element_overlap = WARNING
    examine_element_types = WARNING
    examine_element_volumes = WARNING
    examine_non_conformality = WARNING
    examine_nonplanar_sides = INFO
    examine_sidesets_orientation = WARNING
  []

  construct_side_list_from_node_list = true
[]
