# ==============================================================================
# MSRE DO (domain-overlap) coupled model - Mesh generation
# Core-only RZ mesh, generated from scratch instead of restarting from a
# hand-produced exodus file (ph_initial.e / ph_initial_noflow_out.e).
#
# Dimensions below were measured directly from the mesh baked into
# ph_initial.e (via a throwaway --mesh-only read), NOT copied from
# msr/msre/multiphysics_core_model/mesh/mesh.i -- the DO model's core is a
# different, independently-dimensioned MSRE geometry from the closed-loop
# model's, even though the two share the same block layout/topology. All
# dimensions are round numbers in inches (1 in = 0.0254 m), consistent with
# the original design.
#
# Unlike the closed-loop model, this mesh never creates 'pump'/'elbow'
# blocks at all: ph_initial.e itself has no such blocks (SAM already stands
# in for that piping via msre_sam_do.i), so a temporary subdomain is deleted
# above the down_comer/core_barrel instead, leaving only 'riser' at that
# height -- directly generating only the blocks this model needs, rather
# than generating a closed loop and trimming it after the fact.
#
# core / core1 (materially identical everywhere in ph_start.i/griffin_EV.i)
# are merged into a single 'core' block; 'core2' (the outer bypass gap,
# porosity=1, its own interface with core_barrel) is kept separate.
# ==============================================================================
core_inner_radius = 0.127      # innermost column; also the riser's radius above the core
core_lattice_width = 0.564433  # 0.691433 - core_inner_radius; merged with the inner column into 'core'
core2_width       = 0.013417   # 0.70485 - 0.691433
core_barrel_width = 0.00635    # 1/4 in
down_comer_width  = 0.0254     # 1 in

lower_plenum_height = 0.12954   # 5.1 in
core_height          = 1.6637   # 65.5 in
upper_plenum_height  = 0.2133   # 8.4 in
riser_height         = 0.432    # 17 in

[Mesh]
  coord_type = 'RZ'
  type = MeshGeneratorMesh
  block_id = '1 5 2 3 4 6 7'
  block_name = 'core  core2  lower_plenum  upper_plenum  down_comer  core_barrel riser'
  uniform_refine = 0

  [cartesian_mesh]
    type = CartesianMeshGenerator
    dim = 2
    dx = '${core_inner_radius}  ${core_lattice_width}  ${core2_width}  ${core_barrel_width}  ${down_comer_width}'
    ix = '4                     16                     2                1                     2'
    dy = '${lower_plenum_height}  ${core_height}  ${upper_plenum_height}  ${riser_height}'
    iy = '6                       40              6                       8'
    subdomain_id = '2  2  2  2  2
                     1  1  5  6  4
                     3  3  3  6  4
                     7  99 99 99 99'
  []
  [core_barrel_interface]
    type = SideSetsBetweenSubdomainsGenerator
    primary_block = '6'
    paired_block = '1 5 4 2 3'
    input = cartesian_mesh
    new_boundary = core_barrel
  []
  [loop_boundary]
    type = SideSetsBetweenSubdomainsGenerator
    primary_block = '7 3'
    paired_block = '99 99'
    input = core_barrel_interface
    new_boundary = loop_boundary
  []
  [downcomer_inlet]
    input = loop_boundary
    type = SideSetsBetweenSubdomainsGenerator
    primary_block = '4'
    paired_block = '99'
    new_boundary = 'downcomer_inlet'
  []
  [top_core_barrel]
    input = downcomer_inlet
    type = SideSetsBetweenSubdomainsGenerator
    primary_block = '6'
    paired_block = '99'
    new_boundary = 'top_core_barrel'
  []
  [reference_plane]
    type = SideSetsBetweenSubdomainsGenerator
    primary_block = '2 2'
    paired_block = '1 5'
    new_boundary = reference_plane
    input = top_core_barrel
  []
  [core_in]
    type = SideSetsBetweenSubdomainsGenerator
    primary_block = '2'
    paired_block = '1 5'
    new_boundary = core_in
    input = reference_plane
  []
  [core_out]
    type = SideSetsBetweenSubdomainsGenerator
    primary_block = '3'
    paired_block = '1 5'
    new_boundary = core_out
    input = core_in
  []
  [downcomer_outlet]
    type = SideSetsBetweenSubdomainsGenerator
    primary_block = '4'
    paired_block = '2'
    new_boundary = downcomer_outlet
    input = core_out
  []
  [ph_out_sam_in]
    type = SideSetsBetweenSubdomainsGenerator
    primary_block = '3'
    paired_block = '7'
    new_boundary = ph_out_sam_in
    input = downcomer_outlet
  []
  [ph_outlet]
    type = RenameBoundaryGenerator
    input = ph_out_sam_in
    old_boundary = 'top'
    new_boundary = 'ph_outlet'
  []
  [ph_inlet]
    type = SideSetsBetweenSubdomainsGenerator
    primary_block = '4'
    paired_block = '99'
    new_boundary = 'ph_inlet'
    input = ph_outlet
  []
  [delete_temp]
    type = BlockDeletionGenerator
    input = ph_inlet
    block = '99'
  []
[]

[Executioner]
  type = Steady
[]
