fuel_pipe_D = '${fparse 10*0.0254}'
fuel_pipe_R = '${fparse fuel_pipe_D/2.0}'
core_internal_R = '${fparse 0.496855718 + 2.5*0.0254 - fuel_pipe_R}'
core_outer_gap = 0.098795213
core_barrel_thickness = 0.005
downcomer_thickness = 0.045589414

external_pipe_length = '${fparse 6.71 * 2.0}'
external_piping_volume = '${fparse pi*((2.5*0.0254)^2)*external_pipe_length}'
height_pump = '${fparse fuel_pipe_R / 1.5}'
outer_R = '${fparse fuel_pipe_R +core_internal_R + core_outer_gap + core_barrel_thickness + downcomer_thickness}'
top_disc_volume = '${fparse pi*outer_R^2*height_pump}'
remaining_volume = '${fparse external_piping_volume-top_disc_volume}'
core_riser_flow_area = '${fparse pi*fuel_pipe_R^2}'
core_downcomer_flow_area = '${fparse pi*(outer_R^2 - (outer_R-downcomer_thickness)^2)}'
piping_height = '${fparse remaining_volume/(core_downcomer_flow_area + core_downcomer_flow_area)}'

[Mesh]
  coord_type = 'RZ'
  type = MeshGeneratorMesh
  block_id = '1 2 3 4 6 7 8 9'
  block_name = 'core  lower_plenum  upper_plenum  down_comer  core_barrel riser pump elbow'
  uniform_refine = 1

  [cartesian_mesh]
    type = CartesianMeshGenerator
    dim = 2
    dx = '${fuel_pipe_R}  ${core_internal_R}  ${core_outer_gap}  ${core_barrel_thickness} ${downcomer_thickness}'
    ix = '4               8                   2                  1                        1'
    dy = '0.1715   0.100   0.100   0.246   0.246   0.246
          0.246   0.246   0.100   0.100   0.1715 ${piping_height} ${height_pump}'
    iy = '6  4  4  10  10  10  10  10  4  4  6  4 4'
    subdomain_id = ' 2  2  2  2  2
                     1  1  1  6  4
                     1  1  1  6  4
                     1  1  1  6  4
                     1  1  1  6  4
                     1  1  1  6  4
                     1  1  1  6  4
                     1  1  1  6  4
                     1  1  1  6  4
                     1  1  1  6  4
                     3  3  3  6  4
                     7  10 10 10 9
                     8  9  9  9  9'
  []
  [core_downcomer_boundary]
    type = SideSetsBetweenSubdomainsGenerator
    primary_block = '6'
    paired_block = '1 4 2 3'
    input = cartesian_mesh
    new_boundary = core_downcomer_boundary
  []
  [loop_boundary]
    type = SideSetsBetweenSubdomainsGenerator
    primary_block = '9 7 3'
    paired_block = '10'
    input = core_downcomer_boundary
    new_boundary = loop_boundary
  []
  [internal_pump_sideset]
    input = loop_boundary
    type = SideSetsBetweenSubdomainsGenerator
    primary_block = '7'
    paired_block = '8'
    new_boundary = 'pump_outlet'
  []
  [internal_downcomer_sideset]
    input = internal_pump_sideset
    type = SideSetsBetweenSubdomainsGenerator
    primary_block = '4'
    paired_block = '9'
    new_boundary = 'downcomer_inlet'
  []
  [top_core_barrel]
    input = internal_downcomer_sideset
    type = SideSetsBetweenSubdomainsGenerator
    primary_block = '6'
    paired_block = '10'
    new_boundary = 'top_core_barrel'
  []
  [block_delete]
    type = BlockDeletionGenerator
    input = top_core_barrel
    block = '10'
  []
  #[block_delete]
  #  type = BlockDeletionGenerator
  #  input = top_core_barrel
  #  block = '10'
  #[]
[]

[Executioner]
  type = Steady
[]
