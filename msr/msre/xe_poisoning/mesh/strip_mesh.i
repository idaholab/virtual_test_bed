fuel_pipe_D = '${fparse 10*0.0254}'
fuel_pipe_R = '${fparse fuel_pipe_D/2.0}'
core_internal_R = '${fparse 0.496855718 + 2.5*0.0254 - fuel_pipe_R}'
core_outer_gap = 0.098795213
core_barrel_thickness = 0.005
downcomer_thickness = 0.045589414
height_retrun_elbow = 0.05

external_pipe_length = '${fparse 6.71 * 2.0}'
external_piping_volume = '${fparse pi*((2.5*0.0254)^2)*external_pipe_length}'
height_pump = '${fparse fuel_pipe_R / 1.5}'
outer_R = '${fparse fuel_pipe_R +core_internal_R + core_outer_gap + core_barrel_thickness + downcomer_thickness}'
top_disc_volume = '${fparse pi*outer_R^2*height_pump}'
remaining_volume = '${fparse external_piping_volume-top_disc_volume}'
#core_riser_flow_area = '${fparse pi*fuel_pipe_R^2}'
core_downcomer_flow_area = '${fparse pi*(outer_R^2 - (outer_R-downcomer_thickness)^2)}'
piping_height = '${fparse remaining_volume/(core_downcomer_flow_area + core_downcomer_flow_area)}'

[Mesh]
  coord_type = 'RZ'
  type = MeshGeneratorMesh
  block_id = '1 2 3 4 6 7 8 9 10 11 14 15'
  block_name = 'core lower_plenum  upper_plenum  down_comer  core_barrel riser pump elbow void bypass_line strip return_line'
  uniform_refine = 1

  [cartesian_mesh]
    type = CartesianMeshGenerator
    dim = 2
    dx = '${height_retrun_elbow}
          ${fparse fuel_pipe_R - height_retrun_elbow}
          ${height_retrun_elbow}
          ${fparse core_internal_R - height_retrun_elbow}
          ${core_outer_gap}
          ${core_barrel_thickness}
          ${downcomer_thickness}'
    ix = '2
          4
          2
          8
          2
          1
          1'
    dy = '0.1715   0.100   0.100   0.246   0.246   0.246
          0.246   0.246   0.100   0.100   0.1715 ${piping_height} ${height_pump}
          ${height_retrun_elbow} ${height_retrun_elbow}'
    iy = '6  4  4  10  10  10  10  10  4  4  6  4 4 4 4'
    subdomain_id = ' 2  2  2  2  2  2  2
                     1  1  1  1  1  6  4
                     1  1  1  1  1  6  4
                     1  1  1  1  1  6  4
                     1  1  1  1  1  6  4
                     1  1  1  1  1  6  4
                     1  1  1  1  1  6  4
                     1  1  1  1  1  6  4
                     1  1  1  1  1  6  4
                     1  1  1  1  1  6  4
                     3  3  3  3  3  6  4
                     7  7  10 10 10 10 9
                     8  8  9  9  9  9  9
                     15 13 11 12 12 12 12
                     15 14 11 12 12 12 12'
  []
  [core_downcomer_boundary]
    input = cartesian_mesh
    type = SideSetsBetweenSubdomainsGenerator
    primary_block = '6'
    paired_block = '1 4 2 3'
    new_boundary = core_downcomer_boundary
  []
  [loop_boundary]
    input = core_downcomer_boundary
    type = SideSetsBetweenSubdomainsGenerator
    primary_block = '9 7 3'
    paired_block = '10'
    new_boundary = 'loop_boundary'
  []
  [bypass_line_boundary]
    input = loop_boundary
    type = SideSetsBetweenSubdomainsGenerator
    primary_block = '11'
    paired_block = '12'
    new_boundary = 'bypass_line_boundary'
  []
  [adding_top_to_return_line]
    input = bypass_line_boundary
    type = RenameBoundaryGenerator
    old_boundary = 'top'
    new_boundary = 'extraction'
  []
  [strip_line_boundary]
    input = adding_top_to_return_line
    type = SideSetsBetweenSubdomainsGenerator
    primary_block = '14'
    paired_block = '15 11'
    new_boundary = 'strip_line_boundary'
  []
  [return_line_boundary]
    input = strip_line_boundary
    type = SideSetsBetweenSubdomainsGenerator
    primary_block = '11 14 15 8'
    paired_block = '13'
    new_boundary = 'return_line_boundary'
  []
  [internal_pump_sideset]
    input = return_line_boundary
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
  [top_boundary_return_line]
    input = top_core_barrel
    type = SideSetsBetweenSubdomainsGenerator
    primary_block = '9'
    paired_block = '12'
    new_boundary = 'top'
  []
  [return_line_internal_sideset]
    input = top_boundary_return_line
    type = SideSetsBetweenSubdomainsGenerator
    primary_block = '15'
    paired_block = '8'
    new_boundary = 'return_line_sideset'
  []
  # [missing_boundary]
  #   input = return_line_internal_sideset
  #   type = SideSetsBetweenSubdomainsGenerator
  #   primary_block = '13'
  #   paired_block = '8'
  #   new_boundary = 'top_of_pump'
  # []
  [block_delete]
    input = return_line_internal_sideset
    type = BlockDeletionGenerator
    block = '10 12 13'
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
