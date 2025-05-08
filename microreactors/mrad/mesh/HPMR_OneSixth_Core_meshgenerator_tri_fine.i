#####################################################################
# This is the MOOSE input file to generate the mesh that can be
# used for the 1/6 core Heat-Pipe Microreactor Multiphysics
# simulations (BISON thermal simulation).
# Running this input requires MOOSE Reactor Module Objects
# Users should use
# --mesh-only HPMR_OneSixth_Core_meshgenerator_tri_rotate_bdry_fine.e
# command line argument to generate
# exodus file for further Multiphysics simulations.
#####################################################################
[GlobalParams]
  create_outward_interface_boundaries := false
[]

[Mesh]
  [HP_hex]
    # inner background boundary layer, only for BISON mesh
    background_inner_boundary_layer_bias = 1.5
    background_inner_boundary_layer_intervals = 3
    background_inner_boundary_layer_width = 0.03
  []
  [add_outer_shield]
    peripheral_layer_num := 2
    # Peripheral boundary layer, only for BISON mesh
    peripheral_outer_boundary_layer_bias = 0.625
    peripheral_outer_boundary_layer_intervals = 3
    peripheral_outer_boundary_layer_width = 2
  []
  [extrude]
    num_layers := '6 16 6'
    # biased upper and lower reflector mesh, only for BISON mesh
    biases = '1.6 1.0 0.625'
  []
  [split_hp_ss]
    type = SubdomainBoundingBoxGenerator
    input = rotate_end
    block_id = 1201
    block_name = 'hp_ss_up'
    restricted_subdomains = 'hp_ss'
    bottom_left = '-100 -100 1.8'
    top_right = '100 100 3.0'
  []
  [add_exterior_ht_low]
    type = SideSetsBetweenSubdomainsGenerator
    input = split_hp_ss
    paired_block = 'hp_ss'
    primary_block = 'monolith'
    new_boundary = 'heat_pipe_ht_surf_low'
  []
  [add_exterior_ht_up]
    type = SideSetsBetweenSubdomainsGenerator
    input = add_exterior_ht_low
    paired_block = 'hp_ss_up'
    primary_block = 'reflector_quad'
    new_boundary = 'heat_pipe_ht_surf_up'
  []
  [add_exterior_bot]
    type = SideSetsBetweenSubdomainsGenerator
    input = add_exterior_ht_up
    paired_block = 'heat_pipes_quad heat_pipes_tri hp_ss'
    primary_block = 'reflector_quad reflector_tri'
    new_boundary = 'heat_pipe_ht_surf_bot'
  []
  [merge_hp_surf]
    type = RenameBoundaryGenerator
    input = add_exterior_bot
    old_boundary = 'heat_pipe_ht_surf_low heat_pipe_ht_surf_up'
    new_boundary = 'heat_pipe_ht_surf heat_pipe_ht_surf'
  []
  [remove_hp]
    type = BlockDeletionGenerator
    input = merge_hp_surf
    block = 'hp_ss hp_ss_up heat_pipes_quad heat_pipes_tri'
  []

  # remove extra nodesets to limit the size of the mesh
  [clean_up]
    type = BoundaryDeletionGenerator
    input = remove_hp
    boundary_names = '1 3'
  []
[]

!include HPMR_OneSixth_Core_meshgenerator_tri_batch.i
