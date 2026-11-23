fuel_inner_diameter = 0.005
fuel_thickness = 0.008
fuel_sleeve_gap_rad = 0.00025
sleeve_thickness = 0.00375
sleeve_block_gap = 0.0035
block_thickness = 0.0035

sleeve_cap_height = 0.014
fuel_pin_height = 0.546
fuel_sleeve_gap_axial = 0.003

total_height = ${fparse sleeve_cap_height+fuel_pin_height+fuel_sleeve_gap_axial+sleeve_cap_height}

[Mesh]
    [cartesian_mesh]
        type = CartesianMeshGenerator
        dim = 2

        dx = '${fuel_inner_diameter} ${fuel_thickness} ${fuel_sleeve_gap_rad} ${sleeve_thickness} ${sleeve_block_gap} ${block_thickness}'

        ix = '2 4 1 2 1 1'

        dy = '${sleeve_cap_height} ${fuel_pin_height} ${fuel_sleeve_gap_axial} ${sleeve_cap_height}'

        iy = '2 60 1 2'

        subdomain_id = '2 2 2 2 3 4
                        3 1 3 2 3 4
                        3 3 3 2 3 4
                        2 2 2 2 3 4 '
  []
  [neumann]
    type = ParsedGenerateSideset
    input = cartesian_mesh
    included_subdomains = 2
    new_sideset_name = neumann
    combinatorial_geometry = 'x = 0.0'
  []
  [fuel_side]
    type = SideSetsAroundSubdomainGenerator
    input = neumann
    block = 1
    new_boundary = fuel_side
    normal = '1 0 0'
  []
  [fuel_top]
    type = SideSetsAroundSubdomainGenerator
    input = fuel_side
    block = 1
    new_boundary = fuel_top
    normal = '0 1 0'
  []
  [sleeve_outer]
    type = SideSetsAroundSubdomainGenerator
    input = fuel_top
    block = 2
    new_boundary = sleeve_outer
    normal = '1 0 0'
  []
  [sleeve_inner]
    type = SideSetsBetweenSubdomainsGenerator
    input = sleeve_outer
    primary_block = 2
    paired_block = 3
    new_boundary = sleeve_inner
    normal = '-1 0 0'
  []
  [sleeve_bot]
    type = SideSetsBetweenSubdomainsGenerator
    input = sleeve_inner
    primary_block = 2
    paired_block = 3
    new_boundary = sleeve_bot
    normal = '0 1 0'
  []
  [sleeve_top]
    type = SideSetsBetweenSubdomainsGenerator
    input = sleeve_bot
    primary_block = 2
    paired_block = 3
    new_boundary = sleeve_top
    normal = '0 -1 0'
  []
  [block_inner]
    type = SideSetsAroundSubdomainGenerator
    input = sleeve_top
    block = 4
    new_boundary = block_inner
    normal = '-1 0 0'
  []
  [block_outer]
    type = SideSetsAroundSubdomainGenerator
    input = block_inner
    block = 4
    new_boundary = block_outer
    normal = '1 0 0'
  []
  [delete_gaps]
    type = BlockDeletionGenerator
    block = 3
    input = block_outer
  []
  [transform]
    type = TransformGenerator
    input = delete_gaps
    transform = TRANSLATE
    vector_value = '0 ${fparse -total_height/2} 0'
  []

[]
