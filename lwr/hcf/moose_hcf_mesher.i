# azimuthal refienment
n_seg_lobe = 4
n_seg_valley = 14
n_seg_l2v = 1
n_center = 24     # this should be equal to n_seg_lobe*2 + n_seg_valley + n_seg_l2v*2 && ALWAYS multiple of 8

# radial refinement
n_fuel_radial = 6
n_clad_radial = 2

# axial refinement
n_per_axial_pitch = 60  # should be a multiple of 4
height = 0.25
twist_pitch = 0.5

# Geometry specs: length unit in [m]
r_fuel = 0.00105
r_clad = 0.00130
R_fuel = 0.00345
R_clad = 0.00320
# rod_pitch = 0.0126
# l2v_fuel = 0.00025
# l2v_clad = 0.00050
c_lobe_clad = 0.0050  # rod_pitch/2 - r_clad
c_lobe_fuel = 0.00475 # c_lobe_clad - (l2v_clad-l2v_fuel)
c_valley = 0.0045     # rod_pitch/2 - r_clad - l2v_clad

L_disp = 4.25e-4  # half of the side length of the displacer (0.85mm)
square_region_radius = '${fparse 4 * L_disp}'

[Outputs]
  exodus = true
  csv = true
  file_base = 'mesh'
[]

[Mesh]
  [lobefuel_top]
    type = ParsedCurveGenerator
    x_formula = '${r_fuel}*cos(t)'
    y_formula = '${r_fuel}*sin(t) + ${c_lobe_fuel}'
    section_bounding_t_values = '${fparse 0.5*pi} 0'
    constant_names = 'pi'
    constant_expressions = '${fparse pi}'
    nums_segments = ${n_seg_lobe}
    edge_nodesets = 'lobefuelTL lobefuelTR'
  []
  [l2vfuel_top]
    type = ParsedCurveGenerator
    x_formula = '${r_fuel}'
    y_formula = 't'
    section_bounding_t_values = '${c_lobe_fuel} ${c_valley}'
    nums_segments = ${n_seg_l2v}
    edge_nodesets = 'l2vfuelT1 l2vfuelT2'
  []
  [valleyfuel_topright]
    type = ParsedCurveGenerator
    x_formula = '${R_fuel}*cos(t) + ${c_valley}'
    y_formula = '${R_fuel}*sin(t) + ${c_valley}'
    section_bounding_t_values = '${fparse pi} ${fparse 1.5*pi}'
    constant_names = 'pi'
    constant_expressions = '${fparse pi}'
    nums_segments = ${n_seg_valley}
    edge_nodesets = 'valleyfuelTRT valleyfuelTRB'
  []
  [l2vfuel_topright]
    type = ParsedCurveGenerator
    x_formula = 't'
    y_formula = '${r_fuel}'
    section_bounding_t_values = '${c_valley} ${c_lobe_fuel}'
    nums_segments = ${n_seg_l2v}
    edge_nodesets = 'l2vfuelTR1 l2vfuelTR2'
  []
  [lobefuel_right]
    type = ParsedCurveGenerator
    x_formula = '${r_fuel}*cos(t) + ${c_lobe_fuel}'
    y_formula = '${r_fuel}*sin(t)'
    section_bounding_t_values = '${fparse 0.5*pi} 0'
    constant_names = 'pi'
    constant_expressions = '${fparse pi}'
    nums_segments = ${n_seg_lobe}
    edge_nodesets = 'lobefuelRT lobefuelRB'
  []
  [lobeclad_top]
    type = ParsedCurveGenerator
    x_formula = '${r_clad}*cos(t)'
    y_formula = '${r_clad}*sin(t) + ${c_lobe_clad}'
    section_bounding_t_values = '${fparse 0.5*pi} 0'
    constant_names = 'pi'
    constant_expressions = '${fparse pi}'
    nums_segments = ${n_seg_lobe}
    edge_nodesets = 'lobecladTL lobecladTR'
  []
  [l2vclad_top]
    type = ParsedCurveGenerator
    x_formula = '${r_clad}'
    y_formula = 't'
    section_bounding_t_values = '${c_lobe_clad} ${c_valley}'
    nums_segments = ${n_seg_l2v}
    edge_nodesets = 'l2vcladT1 l2vcladT2'
  []
  [valleyclad_topright]
    type = ParsedCurveGenerator
    x_formula = '${R_clad}*cos(t) + ${c_valley}'
    y_formula = '${R_clad}*sin(t) + ${c_valley}'
    section_bounding_t_values = '${fparse pi} ${fparse 1.5*pi}'
    constant_names = 'pi'
    constant_expressions = '${fparse pi}'
    nums_segments = ${n_seg_valley}
    edge_nodesets = 'valleycladTRT valleycladTRB'
  []
  [l2vclad_topright]
    type = ParsedCurveGenerator
    x_formula = 't'
    y_formula = '${r_clad}'
    section_bounding_t_values = '${c_valley} ${c_lobe_clad}'
    nums_segments = ${n_seg_l2v}
    edge_nodesets = 'l2vcladTR1 l2vcladTR2'
  []
  [lobeclad_right]
    type = ParsedCurveGenerator
    x_formula = '${r_clad}*cos(t) + ${c_lobe_clad}'
    y_formula = '${r_clad}*sin(t)'
    section_bounding_t_values = '${fparse 0.5*pi} 0'
    constant_names = 'pi'
    constant_expressions = '${fparse pi}'
    nums_segments = ${n_seg_lobe}
    edge_nodesets = 'lobecladRT lobecladRB'
  []

  # center line (top right)
  [center_tr]
    type = ParsedCurveGenerator
    x_formula = 't'
    y_formula = '${fparse 2*square_region_radius/sqrt(2)} - t'
    section_bounding_t_values = '0 ${fparse 2*square_region_radius/sqrt(2)}'
    edge_nodesets = 'center_top center_right'
    nums_segments = ${n_center}
  []

  # Add nodesets for the nodes that will be moved to correct the volume
  # Do not include the end nodes
  [lobefuel_top_nodeset]
    type = BoundingBoxNodeSetGenerator
    input = lobefuel_top
    new_boundary = 'lbf_top'
    bottom_left = '-1e6 0.004750001 -1e6'
    top_right = '1e6 1e6 1e6'
  []
  [l2vfuel_top_nodeset]
    type = BoundingBoxNodeSetGenerator
    input = l2vfuel_top
    new_boundary = 'l2vf_top'
    bottom_left = '-1e6 0.004499999 -1e6'
    top_right = '1e6 0.004750001 1e6'
  []
  [valleyfuel_topright_nodeset]
    type = BoundingBoxNodeSetGenerator
    input = valleyfuel_topright
    new_boundary = 'vf_top'
    bottom_left = '-1e6 -1e6 -1e6'
    top_right = '0.0044999999 0.004499999 1e6'
  []
  [l2vfuel_topright_nodeset]
    type = BoundingBoxNodeSetGenerator
    input = l2vfuel_topright
    new_boundary = 'l2vf_topright'
    bottom_left = '0.004499999 -1e6 -1e6'
    top_right = '0.004750001 1e6 1e6'
  []
  [lobefuelRT_nodeset]
    type = BoundingBoxNodeSetGenerator
    input = lobefuel_right
    new_boundary = 'lbr_top'
    bottom_left = '0.004750001 -1e6 -1e6'
    top_right = '1e6 1e6 1e6'
  []

  # 1/4 stitch of the fuel
  [right_fuel]
    type = StitchMeshGenerator
    inputs = 'lobefuel_top_nodeset l2vfuel_top_nodeset valleyfuel_topright_nodeset
              l2vfuel_topright_nodeset lobefuelRT_nodeset'
    stitch_boundaries_pairs = 'lobefuelTR l2vfuelT1;
                               l2vfuelT2 valleyfuelTRT;
                               valleyfuelTRB l2vfuelTR1;
                               l2vfuelTR2 lobefuelRT'
  []

  # Add nodesets to the class
  [lobeclad_top_nodeset]
    type = BoundingBoxNodeSetGenerator
    input = lobeclad_top
    new_boundary = 'lbc_top'
    bottom_left = '-1e6 0.005000001 -1e6'
    top_right = '1e6 1e6 1e6'
  []
  [l2vclad_top_nodeset]
    type = BoundingBoxNodeSetGenerator
    input = l2vclad_top
    new_boundary = 'l2vc_top'
    bottom_left = '-1e6 0.004499999 -1e6'
    top_right = '1e6 0.005000001 1e6'
  []
  [valleyclad_topright_nodeset]
    type = BoundingBoxNodeSetGenerator
    input = valleyclad_topright
    new_boundary = 'vc_top'
    bottom_left = '-1e6 -1e6 -1e6'
    top_right = '0.0044999999 0.004499999 1e6'
  []
  [l2vclad_topright_nodeset]
    type = BoundingBoxNodeSetGenerator
    input = l2vclad_topright
    new_boundary = 'l2vc_topright'
    bottom_left = '0.004499999 -1e6 -1e6'
    top_right = '0.005000001 1e6 1e6'
  []
  [lobecladRT_nodeset]
    type = BoundingBoxNodeSetGenerator
    input = lobeclad_right
    new_boundary = 'lbcr_top'
    bottom_left = '0.00500000 -1e6 -1e6'
    top_right = '1e6 1e6 1e6'
  []

  # 1/4 stitch of the clad
  [right_clad]
    type = StitchMeshGenerator
    inputs = 'lobeclad_top_nodeset l2vclad_top_nodeset valleyclad_topright_nodeset
              l2vclad_topright_nodeset lobecladRT_nodeset'
    stitch_boundaries_pairs = 'lobecladTR l2vcladT1;
                               l2vcladT2 valleycladTRT;
                               valleycladTRB l2vcladTR1;
                               l2vcladTR2 lobecladRT'
  []

  # Mesh clad
  [right_clad_mesh]
    type = FillBetweenCurvesGenerator
    input_mesh_1 = right_fuel
    input_mesh_2 = right_clad
    num_layers = ${n_clad_radial}
    use_quad_elements = true
  []
  [rename_clad_id]
    type = RenameBlockGenerator
    input = 'right_clad_mesh'
    old_block = '1'
    new_block = '12'
  []
  [rename_clad]
    type = RenameBlockGenerator
    input = 'rename_clad_id'
    old_block = '12'
    new_block = 'cladding'
  []

  # Correct clad volume
  [make_sides_clad]
    type = SideSetsFromNodeSetsGenerator
    input = rename_clad
  []
  [fuel_meshed]
    type = FillBetweenCurvesGenerator
    input_mesh_1 = center_tr
    input_mesh_2 = right_fuel
    num_layers = ${n_fuel_radial}
    bias_parameter = 0.0
    use_quad_elements = true
  []
  [rename_fuel]
    type = RenameBlockGenerator
    input = 'fuel_meshed'
    old_block = '1'
    new_block = 'fuel'
  []

  # Correct fuel
  [make_sides_fuel]
    type = SideSetsFromNodeSetsGenerator
    input = rename_fuel
  []

  # Stitch the meshed volumes
  [clad_and_fuel_quarter]
    type = CombinerGenerator
    inputs = 'make_sides_fuel make_sides_clad'
  []

  # Mesh displacer
  [center]
    type = GeneratedMeshGenerator
    dim = 2
    nx = ${n_center}
    ny = ${n_center}
    xmin = '${fparse -square_region_radius}'
    ymin = '${fparse -square_region_radius}'
    xmax = '${fparse  square_region_radius}'
    ymax = '${fparse  square_region_radius}'
  []
  [create_displacer]
    type = ParsedSubdomainMeshGenerator
    input = 'center'
    combinatorial_geometry = 'x > -${L_disp} & x < ${L_disp} & y > -${L_disp} & y < ${L_disp}'
    block_id = 5
    block_name = 'displacer'
  []
  [rename_square_bit]
    type = RenameBlockGenerator
    input = 'create_displacer'
    old_block = '0'
    new_block= '1'
  []
  [center_rotated]
    type = TransformGenerator
    input = 'rename_square_bit'
    transform = 'ROTATE'
    vector_value = '0 0 45'
  []

  # full one-fourth mesh
  [repair_3_regions]
    type = MeshRepairGenerator
    input = 'clad_and_fuel_quarter'
    fix_elements_orientation = true
    fix_node_overlap = true
  []
  [mirror_top]
    type = SymmetryTransformGenerator
    input = repair_3_regions
    mirror_point = '0 1 0'
    mirror_normal_vector = '1 0 0'
  []
  [combined_top_half]
    type = CombinerGenerator
    inputs = 'repair_3_regions mirror_top'
  []
  [mirror_bottom]
    type = SymmetryTransformGenerator
    input = combined_top_half
    mirror_point = '1 0 0'
    mirror_normal_vector = '0 1 0'
  []
  [stitched_whole]
    type = CombinerGenerator
    inputs = 'combined_top_half mirror_bottom'
  []
  [full_fourth_mesh_new]
    type = CombinerGenerator
    inputs = 'center_rotated stitched_whole'
  []
  [separate_blocks]
    type = MeshRepairGenerator
    input = 'full_fourth_mesh_new'
    separate_blocks_by_element_types = true
    fix_node_overlap = true
  []
  [smooth]
    type = SmoothMeshGenerator
    input = separate_blocks
    iterations = 2
    algorithm = laplace
  []
  [check_for_issues]
    type = MeshDiagnosticsGenerator
    input = smooth
    examine_element_overlap = WARNING
    examine_non_conformality = WARNING
    check_local_jacobian = WARNING
  []
  [helical_twist]
    type = AdvancedExtruderGenerator
    input = check_for_issues
    direction = '0 0 1'
    twist_pitch = ${twist_pitch}
    heights = ${height}
    num_layers = '${fparse height / twist_pitch * n_per_axial_pitch}'
  []

  # Remove un-necessary node/sidesets
  [delete]
    type = BoundaryDeletionGenerator
    input = helical_twist
    boundary_names = 'bottom top left right l2vc_top l2vc_topright l2vf_top l2vf_topright
                      lbc_top lbcr_top lbr_top lobecladTL vc_top vf_top'
  []
  [delete2]
    type = BoundaryDeletionGenerator
    input = delete
    boundary_names = 'l2vcladT1 l2vcladT2 l2vcladTR1 l2vcladTR2 l2vf_top l2vf_topright l2vfuelT1 l2vfuelTR1 lobecladRB lobecladRT lobefuelRT valleycladTRB valleycladTRT valleyfuelTRT vf_top'
  []

  # Sideset & nodeset for boundary conditions
  [bottom_center]
    type = BoundingBoxNodeSetGenerator
    input = delete2
    bottom_left = '-1e-5 -1e-5 -1e-5'
    top_right = '1e-5 1e-5 1e-5'
    new_boundary = 'bcenter'
  []
  [bottom_center_neigh]
    type = BoundingBoxNodeSetGenerator
    input = bottom_center
    bottom_left = '0.00018 -1e-5 -1e-5'
    top_right = '0.00022 1e-5 1e-5'
    new_boundary = 'bcenter_nx'
  []
  [sideset_top_bottom]
    type = SideSetsFromNormalsGenerator
    input = bottom_center_neigh
    normals = '0 0 -1
               0 0 1'
    fixed_normal = true
    new_boundary = 'bottom top'
  []
  [sideset_side]
    type = ParsedGenerateSideset
    input = sideset_top_bottom
    new_sideset_name = 'side'
    combinatorial_geometry = 'z > 0.0 & z < 0.24999'
    include_only_external_sides = true
  []

  # Rotate the mesh to have y-axis as an axial direction
  [rotate]
    type = TransformGenerator
    input = sideset_side
    transform = ROTATE
    vector_value = '0 -90 0'
  []

  final_generator = rotate

[]

[Executioner]
  type = Steady
[]

[Problem]
  solve = false
[]

[AuxVariables]
  [placeholder]
  []
[]

[Postprocessors]
  [vol_fuel]
    type = VolumePostprocessor
    block = 'fuel'
  []
  [vol_clad]
    type = VolumePostprocessor
    block = 'cladding'
  []
  [vol_disp]
    type = VolumePostprocessor
    block = 'displacer'
  []
[]
