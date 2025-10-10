# a MOOSE mesh for 7 ABR assemblies
# sqrt(3) / 2 is by how much flat to flat is smaller than corner to corner
f = '${fparse sqrt(3) / 2}'

# units are cm - do not forget to convert to meter
outer_duct_out = 15.8123 # outer size of the hexagonal duct (side to side)
outer_duct_in = 15.0191 # flat to flat
inter_wrapper_width = 0.4348
height = 480.2

# discretization
n_ax = 50
ns = 10
duct_intervals_perishperic = '4 4'

[Mesh]
  [XX00]
    type = PolygonConcentricCircleMeshGenerator
    num_sides = 6
    num_sectors_per_side = '${ns} ${ns} ${ns} ${ns} ${ns} ${ns}'
    background_intervals = 1
    background_block_ids = '12'
    polygon_size = '${fparse outer_duct_out / 2 + inter_wrapper_width / 2}'
    duct_sizes = '${fparse outer_duct_in / f /2} ${fparse outer_duct_out / f / 2}'
    duct_intervals = ${duct_intervals_perishperic}
    duct_block_names = 'duct_wall inter_wrapper'
    outward_interface_boundary_names = 'wall_in_00 wall_out_00'
    interface_boundary_id_shift = 100
  []

  [XX01]
    type = PolygonConcentricCircleMeshGenerator
    num_sides = 6
    num_sectors_per_side = '${ns} ${ns} ${ns} ${ns} ${ns} ${ns}'
    background_intervals = 1
    background_block_ids = '13'
    polygon_size = '${fparse outer_duct_out / 2 + inter_wrapper_width / 2}'
    duct_sizes = '${fparse outer_duct_in / f /2} ${fparse outer_duct_out / f / 2}'
    duct_intervals = ${duct_intervals_perishperic}
    duct_block_names = 'duct_wall  inter_wrapper'
    outward_interface_boundary_names = 'wall_in_01 wall_out_01'
    interface_boundary_id_shift = 200
  []

  [XX02]
    type = PolygonConcentricCircleMeshGenerator
    num_sides = 6
    num_sectors_per_side = '${ns} ${ns} ${ns} ${ns} ${ns} ${ns}'
    background_intervals = 1
    background_block_ids = '14'
    polygon_size = '${fparse outer_duct_out / 2 + inter_wrapper_width / 2}'
    duct_sizes = '${fparse outer_duct_in / f /2} ${fparse outer_duct_out / f / 2}'
    duct_intervals = ${duct_intervals_perishperic}
    duct_block_names = 'duct_wall  inter_wrapper'
    outward_interface_boundary_names = 'wall_in_02 wall_out_02'
    interface_boundary_id_shift = 300
  []

  [XX03]
    type = PolygonConcentricCircleMeshGenerator
    num_sides = 6
    num_sectors_per_side = '${ns} ${ns} ${ns} ${ns} ${ns} ${ns}'
    background_intervals = 1
    background_block_ids = '15'
    polygon_size = '${fparse outer_duct_out / 2 + inter_wrapper_width / 2}'
    duct_sizes = '${fparse outer_duct_in / f /2} ${fparse outer_duct_out / f / 2}'
    duct_intervals = ${duct_intervals_perishperic}
    duct_block_names = 'duct_wall  inter_wrapper'
    outward_interface_boundary_names = 'wall_in_03 wall_out_03'
    interface_boundary_id_shift = 400
  []

  [XX04]
    type = PolygonConcentricCircleMeshGenerator
    num_sides = 6
    num_sectors_per_side = '${ns} ${ns} ${ns} ${ns} ${ns} ${ns}'
    background_intervals = 1
    background_block_ids = '16'
    polygon_size = '${fparse outer_duct_out / 2 + inter_wrapper_width / 2}'
    duct_sizes = '${fparse outer_duct_in / f /2} ${fparse outer_duct_out / f / 2}'
    duct_intervals = ${duct_intervals_perishperic}
    duct_block_names = 'duct_wall  inter_wrapper'
    outward_interface_boundary_names = 'wall_in_04 wall_out_04'
    interface_boundary_id_shift = 500
  []

  [XX05]
    type = PolygonConcentricCircleMeshGenerator
    num_sides = 6
    num_sectors_per_side = '${ns} ${ns} ${ns} ${ns} ${ns} ${ns}'
    background_intervals = 1
    background_block_ids = '17'
    polygon_size = '${fparse outer_duct_out / 2 + inter_wrapper_width / 2}'
    duct_sizes = '${fparse outer_duct_in / f /2} ${fparse outer_duct_out / f / 2}'
    duct_intervals = ${duct_intervals_perishperic}
    duct_block_names = 'duct_wall  inter_wrapper'
    outward_interface_boundary_names = 'wall_in_05 wall_out_05'
    interface_boundary_id_shift = 600
  []

  [XX06]
    type = PolygonConcentricCircleMeshGenerator
    num_sides = 6
    num_sectors_per_side = '${ns} ${ns} ${ns} ${ns} ${ns} ${ns}'
    background_intervals = 1
    background_block_ids = '18'
    polygon_size = '${fparse outer_duct_out / 2 + inter_wrapper_width / 2}'
    duct_sizes = '${fparse outer_duct_in / f /2} ${fparse outer_duct_out / f / 2}'
    duct_intervals = ${duct_intervals_perishperic}
    duct_block_names = 'duct_wall  inter_wrapper'
    outward_interface_boundary_names = 'wall_in_06 wall_out_06'
    interface_boundary_id_shift = 700
  []

  [pattern]
    type = PatternedHexMeshGenerator
    inputs = 'XX00 XX01 XX02 XX03 XX04 XX05 XX06'
    pattern = '5 4 ;
              6 0 3 ;
               1 2'
    pattern_boundary = none
  []

  [extrude]
    type = AdvancedExtruderGenerator
    direction = '0 0 1'
    input = pattern
    heights = '${height}'
    num_layers = '${n_ax}'
  []

  [rename]
    type = RenameBlockGenerator
    input = extrude
    old_block = '12             13             14             15             16             17             18'
    new_block = 'porous_flow_00 porous_flow_01 porous_flow_02 porous_flow_03 porous_flow_04 porous_flow_05 porous_flow_06'
  []

  [inlet_interwrapper]
    type = ParsedGenerateSideset
    input = rename
    combinatorial_geometry = 'abs(z) < 1e-6'
    included_subdomains = 'inter_wrapper duct_wall'
    normal = '0 0 -1'
    new_sideset_name = inlet_interwrapper
  []

  [inlet_porous_flow_hfd]
    type = ParsedGenerateSideset
    input = inlet_interwrapper
    combinatorial_geometry = 'abs(z) < 1e-6'
    included_subdomains = porous_flow_01
    normal = '0 0 -1'
    new_sideset_name = inlet_porous_flow_01
  []

  [inlet_porous_flow_p]
    type = ParsedGenerateSideset
    input = inlet_porous_flow_hfd
    combinatorial_geometry = 'abs(z) < 1e-6'
    included_subdomains = porous_flow_02
    normal = '0 0 -1'
    new_sideset_name = inlet_porous_flow_02
  []

  [inlet_porous_flow_d1]
    type = ParsedGenerateSideset
    input = inlet_porous_flow_p
    combinatorial_geometry = 'abs(z) < 1e-6'
    included_subdomains = porous_flow_03
    normal = '0 0 -1'
    new_sideset_name = inlet_porous_flow_03
  []

  [inlet_porous_flow_d2]
    type = ParsedGenerateSideset
    input = inlet_porous_flow_d1
    combinatorial_geometry = 'abs(z) < 1e-6'
    included_subdomains = porous_flow_04
    normal = '0 0 -1'
    new_sideset_name = inlet_porous_flow_04
  []

  [inlet_porous_flow_k011]
    type = ParsedGenerateSideset
    input = inlet_porous_flow_d2
    combinatorial_geometry = 'abs(z) < 1e-6'
    included_subdomains = porous_flow_05
    normal = '0 0 -1'
    new_sideset_name = inlet_porous_flow_05
  []

  [inlet_porous_flow_x402]
    type = ParsedGenerateSideset
    input = inlet_porous_flow_k011
    combinatorial_geometry = 'abs(z) < 1e-6'
    included_subdomains = porous_flow_06
    normal = '0 0 -1'
    new_sideset_name = inlet_porous_flow_06
  []

  [inlet_central_assembly]
    type = ParsedGenerateSideset
    input = inlet_porous_flow_x402
    combinatorial_geometry = 'abs(z) < 1e-6'
    included_subdomains = 'porous_flow_00'
    normal = '0 0 -1'
    new_sideset_name = inlet_porous_flow_00
  []

  [outlet_interwrapper]
    type = ParsedGenerateSideset
    input = inlet_central_assembly
    included_subdomains = 'inter_wrapper duct_wall'
    combinatorial_geometry = 'abs(z - ${fparse height}) < 1e-6'
    normal = '0 0 1'
    new_sideset_name = outlet_interwrapper
  []

  [outlet_porous_flow]
    type = ParsedGenerateSideset
    input = outlet_interwrapper
    included_subdomains = 'porous_flow_01 porous_flow_02 porous_flow_03 porous_flow_04 porous_flow_05 porous_flow_06'
    combinatorial_geometry = 'abs(z - ${fparse height}) < 1e-6'
    normal = '0 0 1'
    new_sideset_name = outlet_porous_flow
  []

  [outlet_central_assembly]
    type = ParsedGenerateSideset
    input = outlet_porous_flow
    included_subdomains = 'porous_flow_00'
    combinatorial_geometry = 'abs(z - ${fparse height}) < 1e-6'
    normal = '0 0 1'
    new_sideset_name = outlet_porous_flow_00
  []

  [rotate]
    type = TransformGenerator
    input = outlet_central_assembly
    transform = ROTATE
    vector_value = '0 0 0'
  []

  # turn into meters
  [scale]
    type = TransformGenerator
    vector_value = '0.01 0.01 0.01'
    transform = SCALE
    input = rotate
  []

  [new_wall_boundary_00]
    type = SideSetsBetweenSubdomainsGenerator
    input = scale
    new_boundary = 'prsb_interface_00'
    primary_block = 'duct_wall'
    paired_block = 'porous_flow_00'
  []

  [new_wall_boundary_01]
    type = SideSetsBetweenSubdomainsGenerator
    input = new_wall_boundary_00
    new_boundary = 'prsb_interface_01'
    primary_block = 'duct_wall'
    paired_block = 'porous_flow_01'
  []

  [new_wall_boundary_02]
    type = SideSetsBetweenSubdomainsGenerator
    input = new_wall_boundary_01
    new_boundary = 'prsb_interface_02'
    primary_block = 'duct_wall'
    paired_block = 'porous_flow_02'
  []

  [new_wall_boundary_03]
    type = SideSetsBetweenSubdomainsGenerator
    input = new_wall_boundary_02
    new_boundary = 'prsb_interface_03'
    primary_block = 'duct_wall'
    paired_block = 'porous_flow_03'
  []

  [new_wall_boundary_04]
    type = SideSetsBetweenSubdomainsGenerator
    input = new_wall_boundary_03
    new_boundary = 'prsb_interface_04'
    primary_block = 'duct_wall'
    paired_block = 'porous_flow_04'
  []

  [new_wall_boundary_05]
    type = SideSetsBetweenSubdomainsGenerator
    input = new_wall_boundary_04
    new_boundary = 'prsb_interface_05'
    primary_block = 'duct_wall'
    paired_block = 'porous_flow_05'
  []

  [new_wall_boundary_06]
    type = SideSetsBetweenSubdomainsGenerator
    input = new_wall_boundary_05
    new_boundary = 'prsb_interface_06'
    primary_block = 'duct_wall'
    paired_block = 'porous_flow_06'
  []

  [delete_assemblies]
    type = BlockDeletionGenerator
    block = 'porous_flow_00 porous_flow_01 porous_flow_02 porous_flow_03 porous_flow_04 porous_flow_05 porous_flow_06'
    input = 'new_wall_boundary_06'
  []
[]
