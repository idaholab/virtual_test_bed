# Multi-Pass Pipe Welding and Cooldown Residual Stress Model (VTB: lwr/pipe_welding)
# Documentation: https://mooseframework.inl.gov/virtual_test_bed/lwr/pipe_welding/index.html
# Authors: Bipul Barua (original model), Cheng-Hau Yang (VTB integration and validation)
# Institution: Argonne National Laboratory
# Mesh of the welded vessel, generated with MOOSE framework mesh generators:
#   blackbear-opt (or grizzly-opt) -i mesh.i --mesh-only vessel_40mm.exo
#
# Geometry (mm), pipe axis = y, radius r in the x-z plane:
#   wall          r = 75 (ID) .. 115 (OD), bottom open at y = 450
#   flat head     inner face y = 685, top face y = 725 (40 mm thick)
#   fillets       inner R20 centred at (r, y) = (55, 665); outer R20 centred at (95, 705)
#   V groove      centred at y = 600, half width 5 + 0.2625 (r - 75): 10 mm at the ID, 31 mm at the OD
#   weld passes   pass 1: r 75-80, pass 2: 80-85, passes 3/4: 85-95, 5/6: 95-105, 7/8: 105-115
#                 (odd passes above y = 600, even passes below)
#
# Construction:
#   1. 2D r-y section in the x-y plane (x = r) from three structured patches, stitched:
#      wall (CartesianMeshGenerator + groove mapping), elbow (polar mapping around the inner fillet
#      centre, outer side = OD wall, outer fillet and top face), head plate r = 25 .. 55
#   2. revolution about the y axis: extrude in z by 2 pi (z = angle), map
#      (r, y, theta) -> (r cos(theta), y, r sin(theta)), stitch the seam
#   3. centre cylinder r < 25 (ConcentricCircleMeshGenerator, extruded) stitched to the head plate
#   4. blocks, sidesets and nodesets used by the welding and cooldown inputs

n_theta = 40 # circumferential elements
r_core = 25 # radius of the centre cylinder in the head

[Mesh]
  #---------------------------------------------------------------- 2D wall with V groove
  [wall_grid]
    type = CartesianMeshGenerator
    dim = 2
    # radial: 4 x 2.5 mm (passes 1, 2), then 9 x 3.333 mm
    dx = '10 30'
    ix = '4 9'
    # axial levels at the ID (y = 450 + sum): graded towards the groove, 4 x 2.5 mm across the groove
    dy = '4.5353 7.3264 11.7744 18.8391 30.0248 30.0248 18.8391 11.7744 7.3264 4.5353
          2.5 2.5 2.5 2.5
          5.5385 9.2307 15.2308 15.2308 9.2307 5.5385'
  []
  [wall_map]
    # logical y in [0, 215]: [0, 145] below the groove, [145, 155] groove, [155, 215] above.
    # The groove half width h(r) = 5 + 0.2625 (r - 75) widens linearly to the OD; the levels below
    # and above are scaled linearly between y = 450 / 665 and the groove walls.
    type = ParsedNodeTransformGenerator
    input = wall_grid
    constant_names = 'h0 s'
    constant_expressions = '5 0.2625'
    x_function = 'x + 75'
    y_function = 'if(y < 145, 450 + y * (150 - (h0 + s * x)) / 145,
                  if(y <= 155, 600 + (y - 150) * (h0 + s * x) / 5,
                     600 + (h0 + s * x) + (y - 155) * (65 - (h0 + s * x)) / 60))'
  []
  [wall_base]
    type = RenameBlockGenerator
    input = wall_map
    old_block = '0'
    new_block = '1'
  []
  [pass1]
    type = ParsedSubdomainMeshGenerator
    input = wall_base
    combinatorial_geometry = 'abs(y - 600) < 5 + 0.2625 * (x - 75) & x < 80'
    block_id = 2
    block_name = 'weldpass-1'
  []
  [pass2]
    type = ParsedSubdomainMeshGenerator
    input = pass1
    combinatorial_geometry = 'abs(y - 600) < 5 + 0.2625 * (x - 75) & x > 80 & x < 85'
    block_id = 3
    block_name = 'weldpass-2'
  []
  [pass3]
    type = ParsedSubdomainMeshGenerator
    input = pass2
    combinatorial_geometry = 'abs(y - 600) < 5 + 0.2625 * (x - 75) & x > 85 & x < 95 & y > 600'
    block_id = 4
    block_name = 'weldpass-3'
  []
  [pass4]
    type = ParsedSubdomainMeshGenerator
    input = pass3
    combinatorial_geometry = 'abs(y - 600) < 5 + 0.2625 * (x - 75) & x > 85 & x < 95 & y < 600'
    block_id = 5
    block_name = 'weldpass-4'
  []
  [pass5]
    type = ParsedSubdomainMeshGenerator
    input = pass4
    combinatorial_geometry = 'abs(y - 600) < 5 + 0.2625 * (x - 75) & x > 95 & x < 105 & y > 600'
    block_id = 7
    block_name = 'weldpass-5'
  []
  [pass6]
    type = ParsedSubdomainMeshGenerator
    input = pass5
    combinatorial_geometry = 'abs(y - 600) < 5 + 0.2625 * (x - 75) & x > 95 & x < 105 & y < 600'
    block_id = 6
    block_name = 'weldpass-6'
  []
  [pass7]
    type = ParsedSubdomainMeshGenerator
    input = pass6
    combinatorial_geometry = 'abs(y - 600) < 5 + 0.2625 * (x - 75) & x > 105 & y > 600'
    block_id = 8
    block_name = 'weldpass-7'
  []
  [pass8]
    type = ParsedSubdomainMeshGenerator
    input = pass7
    combinatorial_geometry = 'abs(y - 600) < 5 + 0.2625 * (x - 75) & x > 105 & y < 600'
    block_id = 9
    block_name = 'weldpass-8'
  []
  [wall_bnd]
    type = RenameBoundaryGenerator
    input = pass8
    old_boundary = 'bottom top right left'
    new_boundary = 'yfix_bot w_top w_od w_id'
  []
  [od_base_wall]
    type = ParsedGenerateSideset
    input = wall_bnd
    combinatorial_geometry = 'x > 114.999'
    included_subdomains = '1'
    include_only_external_sides = true
    new_sideset_name = 'od_base'
  []
  [od_weld]
    type = ParsedGenerateSideset
    input = od_base_wall
    combinatorial_geometry = 'x > 114.999'
    included_subdomains = '8 9'
    include_only_external_sides = true
    new_sideset_name = 'od_weld'
  []
  [id_base_wall]
    type = ParsedGenerateSideset
    input = od_weld
    combinatorial_geometry = 'x < 75.001'
    included_subdomains = '1'
    include_only_external_sides = true
    new_sideset_name = 'id_base'
  []
  [id_weld]
    type = ParsedGenerateSideset
    input = id_base_wall
    combinatorial_geometry = 'x < 75.001'
    included_subdomains = '2'
    include_only_external_sides = true
    new_sideset_name = 'id_weld'
  []
  # moving (groove walls): below y = 600 the sides belong to the base metal (facing passes
  # 1, 2, 4, 6, 8), above y = 600 to the weld passes 1, 2, 3, 5, 7 (facing the base metal)
  [moving_lower]
    type = ParsedGenerateSideset
    input = id_weld
    combinatorial_geometry = 'y < 600'
    included_subdomains = '1'
    included_neighbors = '2 3 5 6 9'
    new_sideset_name = 'moving'
  []
  [moving_upper]
    type = ParsedGenerateSideset
    input = moving_lower
    combinatorial_geometry = 'y > 600'
    included_subdomains = '2 3 4 7 8'
    included_neighbors = '1'
    new_sideset_name = 'moving'
  []
  [wall]
    type = BoundaryDeletionGenerator
    input = moving_upper
    boundary_names = 'w_od w_id'
  []

  #---------------------------------------------------------------- 2D elbow (wall -> head)
  [elbow_grid]
    # logical x = t in [0, 1] (same radial distribution as the wall, t = 0 at the inner fillet),
    # logical y = polar angle phi around the inner fillet centre; the outer fillet starts at
    # phi = atan(2/3) and ends at atan(3/2), so both fillet ends are nodes
    type = CartesianMeshGenerator
    dim = 2
    dx = '0.25 0.75'
    ix = '4 9'
    dy = '${fparse atan(2/3)} ${fparse atan(3/2) - atan(2/3)} ${fparse 2 * atan(1) - atan(3/2)}'
    iy = '2 3 2'
  []
  [elbow_map]
    # ray from O = (55, 665): from the inner fillet (radius 20) to the outer boundary at distance
    # rho(phi): OD wall r = 115 (60 / cos), outer R20 fillet centred at O + (40, 40), top face
    # y = 725 (60 / sin)
    type = ParsedNodeTransformGenerator
    input = elbow_grid
    constant_names = 'a1 a2'
    constant_expressions = 'atan(2/3) atan(3/2)'
    x_function = '55 + (20 + (if(y <= a1, 60 / cos(y), if(y >= a2, 60 / sin(y),
                  40 * (cos(y) + sin(y)) + sqrt((40 * (cos(y) + sin(y)))^2 - 2800))) - 20) * x) * cos(y)'
    y_function = '665 + (20 + (if(y <= a1, 60 / cos(y), if(y >= a2, 60 / sin(y),
                  40 * (cos(y) + sin(y)) + sqrt((40 * (cos(y) + sin(y)))^2 - 2800))) - 20) * x) * sin(y)'
  []
  [elbow_base]
    type = RenameBlockGenerator
    input = elbow_map
    old_block = '0'
    new_block = '1'
  []
  [elbow]
    type = RenameBoundaryGenerator
    input = elbow_base
    old_boundary = 'bottom top right left'
    new_boundary = 'e_start e_end od_base id_base'
  []

  #---------------------------------------------------------------- 2D head plate r = r_core .. 55
  [plate_grid]
    type = CartesianMeshGenerator
    dim = 2
    dx = '${fparse 55 - r_core}'
    ix = '3'
    dy = '10 30'
    iy = '4 9'
  []
  [plate_map]
    type = ParsedNodeTransformGenerator
    input = plate_grid
    x_function = 'x + ${r_core}'
    y_function = 'y + 685'
  []
  [plate_base]
    type = RenameBlockGenerator
    input = plate_map
    old_block = '0'
    new_block = '1'
  []
  [plate]
    type = RenameBoundaryGenerator
    input = plate_base
    old_boundary = 'bottom top right left'
    new_boundary = 'id_base od_base p_out p_axis'
  []

  #---------------------------------------------------------------- 2D section
  [section_a]
    type = StitchMeshGenerator
    inputs = 'wall elbow'
    stitch_boundaries_pairs = 'w_top e_start'
  []
  [section]
    type = StitchMeshGenerator
    inputs = 'section_a plate'
    stitch_boundaries_pairs = 'e_end p_out'
  []

  #---------------------------------------------------------------- revolve about the y axis
  [sweep]
    type = AdvancedExtruderGenerator
    input = section
    direction = '0 0 1'
    heights = '${fparse 8 * atan(1)}'
    num_layers = '${n_theta}'
    bottom_boundary = 'seam_0'
    top_boundary = 'seam_1'
  []
  [revolve]
    # (r, y, theta) -> (r cos(theta), y, r sin(theta)); Jacobian determinant r > 0
    type = ParsedNodeTransformGenerator
    input = sweep
    x_function = 'x * cos(z)'
    y_function = 'y'
    z_function = 'x * sin(z)'
  []
  [ring]
    type = StitchBoundaryMeshGenerator
    input = revolve
    stitch_boundaries_pair = 'seam_0 seam_1'
  []

  #---------------------------------------------------------------- centre cylinder r < r_core
  [core_2d]
    type = ConcentricCircleMeshGenerator
    num_sectors = '${fparse n_theta / 4}'
    radii = '${r_core}'
    rings = '1'
    has_outer_square = false
    preserve_volumes = false
  []
  [core_outer]
    # with rings = 1 ConcentricCircleMeshGenerator does not name the outer circle
    type = ParsedGenerateSideset
    input = core_2d
    combinatorial_geometry = 'x * x + y * y > ${fparse (r_core - 0.1)^2}'
    include_only_external_sides = true
    new_sideset_name = 'outer'
  []
  [core_3d]
    type = AdvancedExtruderGenerator
    input = core_outer
    direction = '0 0 1'
    heights = '10 30'
    num_layers = '4 9'
    bottom_boundary = 'id_base'
    top_boundary = 'od_base'
  []
  [core]
    # axis z -> y (proper rotation: (x, y, z) -> (x, 685 + z, -y))
    type = ParsedNodeTransformGenerator
    input = core_3d
    x_function = 'x'
    y_function = '685 + z'
    z_function = '-y'
  []
  [vessel]
    type = StitchMeshGenerator
    inputs = 'ring core'
    stitch_boundaries_pairs = 'p_axis outer'
  []

  #---------------------------------------------------------------- blocks, sidesets, nodesets
  [seed]
    # weld_to_base (id 11), the target block of the element activation, must exist in the mesh: it
    # holds one base-metal element at the centre of the head top face (centroid
    # (1.707, 723.333, -1.707))
    type = SubdomainBoundingBoxGenerator
    input = vessel
    block_id = 11
    block_name = 'weld_to_base'
    bottom_left = '1.2 722.8 -2.2'
    top_right = '2.2 723.8 -1.2'
  []
  [basemetal]
    type = RenameBlockGenerator
    input = seed
    old_block = '1'
    new_block = 'basemetal'
  []
  [zfix_weld]
    # weld-pass element sides in the plane z = 0 (one side per face)
    type = ParsedGenerateSideset
    input = basemetal
    combinatorial_geometry = 'abs(z) < 1e-6'
    normal = '0 0 1'
    included_subdomains = '2 3 4 5 6 7 8 9'
    new_sideset_name = 'zfix_weld'
  []
  [top_clamp]
    type = ParsedGenerateNodeset
    input = zfix_weld
    expression = 'abs(y - 705) < 1e-4 & x * x + z * z > 114.99 * 114.99'
    new_nodeset_name = 'xyzfix_top_clamp'
  []
  [bot_clamp]
    type = ParsedGenerateNodeset
    input = top_clamp
    expression = 'abs(y - 450) < 1e-4 & x * x + z * z > 114.99 * 114.99'
    new_nodeset_name = 'xzfix_bot_clamp'
  []
  [bot_xz]
    type = ParsedGenerateNodeset
    input = bot_clamp
    expression = 'abs(y - 450) < 1e-4 & abs(x + 75) < 1e-4 & abs(z) < 1e-4'
    new_nodeset_name = 'xzfix_bot'
  []
  [bot_z]
    type = ParsedGenerateNodeset
    input = bot_xz
    expression = 'abs(y - 450) < 1e-4 & abs(x - 75) < 1e-4 & abs(z) < 1e-4'
    new_nodeset_name = 'zfix_bot'
  []
  # fixed boundary ids (through temporary ids, to avoid merging with existing ones)
  [ids_tmp]
    type = RenameBoundaryGenerator
    input = bot_z
    old_boundary = 'od_base id_base yfix_bot od_weld id_weld moving zfix_weld
                    xyzfix_top_clamp xzfix_bot zfix_bot xzfix_bot_clamp'
    new_boundary = '1001 1002 1003 1005 1006 1007 1008 1101 1201 1202 1301'
  []
  [ids]
    type = RenameBoundaryGenerator
    input = ids_tmp
    old_boundary = '1001 1002 1003 1005 1006 1007 1008 1101 1201 1202 1301'
    new_boundary = '1 2 3 5 6 7 8 101 201 202 301'
  []
  [final]
    type = RenameBoundaryGenerator
    input = ids
    old_boundary = '1 2 3 5 6 7 8 101 201 202 301'
    new_boundary = 'od_base id_base yfix_bot od_weld id_weld moving zfix_weld
                    xyzfix_top_clamp xzfix_bot zfix_bot xzfix_bot_clamp'
  []
[]
