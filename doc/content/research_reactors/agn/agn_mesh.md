# Aerojet General Nucleonics 201 (AGN-201) Research Reactor Model Mesh

!alert warning
This meshing script generates a mesh in a coarse form. Convergence studies for the physics of interest should be performed by the user.

The cylindrical core mesh is created in several steps:

1. The top half core mesh boundary is generated:

    - The Shutdown Rod 1 (SR1) mesh is created.

    - The Coarse Control Rod (CCR) mesh is formed, the background is deleted, and the mesh is translated.

    - The top half core Central Irradiation Facility (CIF) boundary is produced.

2. The parts of the top half of the core are then stitched together.

3. The top half core meshes for the inner graphite layer and CIF wall are formed.

4. The universal beam ports (UBP) are meshed in several steps:

    - The outer layers (gas, lead, air gap, reactor tank, and water layers) between the beam ports are meshed.

    - The UBP inner walls are meshed.

    - The UBP channels inside the layers (gas, lead, air gap, reactor tank, and water layers) are meshed.

    - The UBP outer walls are meshed.

5. The CIF wall sections and outer graphite, lead, air gap, reactor tank, and eater layers that are past the UBP channels are modeled.

6. The top half 2D core mesh is reflected and stitched to create a 2D mesh of the full core.

7. The Fine Control Rod (FCR), Shutdown Rod 2 (SR2), and CCR are explicitly defined and stitched to the 2D full core mesh.

8. The thermal fuse is modeled and stitched to the 2D full core mesh.

9. The mesh is extruded from 2D to 3D and the walls with channels are homogenized, resulting in the final AGN-201 mesh.


A more detailed explanation of each step follows below.

## Top Half of 2D Core

First, the top half core boundary mesh is generated from a curve describing a half circle.

!listing agn/3D_AGN-201_Final.i block=Mesh/top_half_core_boundary

Then, the SR1 hole base mesh is formed. The background is deleted and then translated.

!listing agn/3D_AGN-201_Final.i start=[sr1_base] end=[ccr_base]

!media media/agn/agn_meshes/sr1_transform.png
    style=width:60%;margin:auto;
    caption=Figure 1: Shutdown Rod 1 2D mesh.

The CCR hole base mesh is created, the background is deleted, and then the mesh is translated.

!listing agn/3D_AGN-201_Final.i start=[ccr_base] end=[xydg_mesh_top_half_core]

!media media/agn/agn_meshes/ccr_transform.png
    style=width:60%;margin:auto;
    caption=Figure 2: Coarse Control Rod 2D mesh.

Then the core region is meshed inside the core outer boundary and outside the holes for the CCR and SR1 rods.

!listing agn/3D_AGN-201_Final.i block=Mesh/xydg_mesh_top_half_core

!media media/agn/agn_meshes/xydg_mesh_top_half_core.png
    style=width:85%;margin:auto;
    caption=Figure 3: 2D top half core mesh featuring the CCR in blue and the SR1 in red.

The outer thickness of the core CIF hole is designed, the mesh is triangulated, and stitched to the top half core 2D mesh.

!listing agn/3D_AGN-201_Final.i start=[top_half_cif_core_outer_boundary] end=[top_half_ig_core_boundary]

!media media/agn/agn_meshes/stitch_core_and_cif_outer.png
    style=width:85%;margin:auto;
    caption=Figure 4: 2D top half core mesh featuring the CCR in yellow, SR1 in green, and CIF wall in red.

## Core Inner Graphite and CIF

The top inner graphite core boundary mesh is constructed from the equations for its curve, then the inside region is triangulated, and lastly stitched to the top half core 2D mesh.

!alert note
These two regions would be meshed easier, and could be meshed with QUAD elements, using a FillBetweenCurvesGenerator

!listing agn/3D_AGN-201_Final.i start=[top_half_ig_core_boundary] end=[top_half_right_ig_cif_wall]

!media media/agn/agn_meshes/stitch_ig_and_core.png
    style=width:85%;margin:auto;
    caption=Figure 5: 2D top half core mesh featuring the CCR in pink, SR1 in blue, CIF wall in red, and inner graphite layer in green.

The top right inner graphite CIF wall boundary mesh is again produced from the equations for its curve, then the inside region is triangulated. The boundaries are renamed and then stitched.

!listing agn/3D_AGN-201_Final.i start=[top_half_right_ig_cif_wall] end=[xydg_mesh_left_ig_cif_wall]

The mesh is then reflected about the Y-axis to model the top left inner graphite CIF wall boundary. The boundaries again are renamed and then stitched.

!listing agn/3D_AGN-201_Final.i start=[xydg_mesh_left_ig_cif_wall] end=[top_half_at_core_boundary]

!media media/agn/agn_meshes/stitch_left_ig_cif_wall.png
    style=width:85%;margin:auto;
    caption=Figure 6: 2D top half core mesh featuring the CCR in teal, SR1 in yellow, CIF wall in red, inner graphite layer in green, and side inner graphite blocks in blue.

The top half at core boundary mesh is formed and triangulated. The mesh is stitched to the top left inner graphite CIF wall boundary mesh and then the boundaries are renamed.

!listing agn/3D_AGN-201_Final.i start=[top_half_at_core_boundary] end=[top_half_right_at_cif_wall]

The top right CIF wall boundary mesh is generated from the equations for its curve, then the region inside the boundary is triangulated. The mesh is stitched to the previous mesh.

!alert note
These two regions would be meshed easier, and could be meshed with QUAD elements, using a FillBetweenCurvesGenerator

!listing agn/3D_AGN-201_Final.i start=[top_half_right_at_cif_wall] end=[xydg_mesh_left_at_cif_wall]

Then the mesh is reflected about the Y-axis to model the top left CIF wall boundary. The boundaries are then renamed and stitched to the right side.

!listing agn/3D_AGN-201_Final.i start=[xydg_mesh_left_at_cif_wall] end=[top_half_og_between_beam_ports]

## Layers Between UBP

The top outer graphite channel between the UBP mesh is produced and then triangulated. The mesh is then stitched to the left CIF wall mesh.

!listing agn/3D_AGN-201_Final.i start=[top_half_og_between_beam_ports] end=[top_half_lead_between_beam_ports]

!media media/agn/agn_meshes/stitch_top_half_og_between_beam_ports.png
    style=width:65%;margin:auto;
    caption=Figure 7: 2D top half core mesh featuring the CCR in pink, SR1 in purple, CIF wall in red, inner graphite layer in green, side inner graphite blocks in blue, and outer graphite layer in teal.

The top lead channel between the UBP mesh is modeled and then triangulated. The mesh is then stitched to the top outer gas channel mesh.

!listing agn/3D_AGN-201_Final.i start=[top_half_lead_between_beam_ports] end=[top_half_ag_between_beam_ports]

!media media/agn/agn_meshes/stitch_top_half_lead_between_beam_ports.png
    style=width:65%;margin:auto;
    caption=Figure 8: 2D top half core mesh featuring lead layer in purple.

The boundary between the top air gap channel between the UBP mesh of the channel is generated from the equations for its curve, then the inside region is triangulated. The mesh is then stitched to the top lead channel mesh.

!listing agn/3D_AGN-201_Final.i start=[top_half_ag_between_beam_ports] end=[top_half_rt_between_beam_ports]

!media media/agn/agn_meshes/stitch_top_half_ag_between_beam_ports.png
    style=width:65%;margin:auto;
    caption=Figure 9: 2D top half core mesh featuring air gap layer in brown.

The top reactor tank channel between the UBP mesh is also rendered from the equations for its curve, then the inside region is triangulated. The mesh is then stitched to the top air gap channel mesh.

!listing agn/3D_AGN-201_Final.i start=[top_half_rt_between_beam_ports] end=[top_half_water_between_beam_ports]

!media media/agn/agn_meshes/stitch_top_half_rt_between_beam_ports.png
    style=width:65%;margin:auto;
    caption=Figure 10: 2D top half core mesh featuring reactor tank layer in pink.

The top water channel between the UBP mesh is once again produced from the equations for its curve, then the inside region is triangulated. The mesh is then stitched to the top reactor tank channel mesh. Lastly the boundaries are renamed.

!listing agn/3D_AGN-201_Final.i start=[top_half_water_between_beam_ports] end=[top_half_right_og_before_ubp_cif_wall]

!media media/agn/agn_meshes/rename_boundaries_5.png
    style=width:55%;margin:auto;
    caption=Figure 11: 2D top half core mesh featuring water layer in dark purple.

## Outer Graphite before UBP/CIF

The mesh for the CIF wall under the outer graphite before the UBP starts is then constructed and triangulated. The mesh is stitched to the previous mesh and the boundaries are renamed.

!listing agn/3D_AGN-201_Final.i start=[top_half_right_og_before_ubp_cif_wall] end=[ydg_mesh_top_half_left_og_before_ubp_cif_wall]

The mesh is then reflected across the Y-axis and the boundaries are renamed. After the boundaries have been given new, unique names, the mesh is stitched to the top right side.

!listing agn/3D_AGN-201_Final.i start=[xydg_mesh_top_half_left_og_before_ubp_cif_wall] end=[top_half_right_ubp_cif_wall_1]

!media media/agn/agn_meshes/stitch_top_half_left_og_before_ubp_cif_wall.png
    style=width:55%;margin:auto;
    caption=Figure 12: 2D bottom half core mesh.

## CIF Wall Intersection with UBP

The right boundary where the CIF wall intersects with the UBP wall is then generated from the equations for its curve, then the inside region is triangulated. The boundaries are renamed and stitched to the previous mesh.

!listing agn/3D_AGN-201_Final.i start=[top_half_right_ubp_cif_wall_1] end=[xydg_mesh_top_half_left_ubp_cif_wall_1]

The mesh is then reflected about the Y-axis. The boundaries are renamed, the mesh is stitched to the right side, and the left mesh boundaries are renamed.

!listing agn/3D_AGN-201_Final.i start=[xydg_mesh_top_half_left_ubp_cif_wall_1] end=[top_half_right_ubp_inner_wall_in_og]

!media media/agn/agn_meshes/rename_boundaries_9.png
    style=width:55%;margin:auto;
    caption=Figure 13: 2D top half core mesh featuring boundary between CIF wall and UBP wall in brown.

## UBP Inner Walls

The UBP right inner wall bordering the outer graphite mesh is modeled and triangulated. The mesh is then stitched to the previous step's mesh.

!listing agn/3D_AGN-201_Final.i start=[top_half_right_ubp_inner_wall_in_og] end=[xydg_mesh_top_half_left_ubp_inner_wall_in_og]

The mesh is then reflected about the Y-axis. The boundaries are renamed, the mesh is stitched to the right side, and the left mesh boundaries are renamed.

!listing agn/3D_AGN-201_Final.i start=[xydg_mesh_top_half_left_ubp_inner_wall_in_og] end=[top_half_right_ubp_inner_wall_in_lead]

The previous steps are repeated for the UBP inner walls that border the lead layer, the air gap layer, the reactor tank layer, and the water layer.

!listing agn/3D_AGN-201_Final.i start=[top_half_right_ubp_inner_wall_in_lead] end=[top_half_right_cif_wall_in_ubp_channel]

!media media/agn/agn_meshes/rename_boundaries_19.png
    style=width:55%;margin:auto;
    caption=Figure 14: 2D top half core mesh featuring UBP inner walls (on the outer right and outer left) sections in brown, light brown, red, blue, and pink.

## CIF Outer Wall in UBP Channel

The right CIF outer wall that borders the UBP channel mesh is created and triangulated. The mesh is then stitched to the mesh from the previous step.

!listing agn/3D_AGN-201_Final.i start=[top_half_right_cif_wall_in_ubp_channel] end=[xydg_mesh_top_half_left_cif_wall_in_ubp_channel]

The mesh is then reflected about the Y-axis. The boundaries are renamed, the mesh is stitched to the right side, and the left mesh boundaries are renamed.

!listing agn/3D_AGN-201_Final.i start=[xydg_mesh_top_half_left_cif_wall_in_ubp_channel] end=[op_half_right_og_in_ubp_channel]

!media media/agn/agn_meshes/rename_boundaries_21.png
    style=width:55%;margin:auto;
    caption=Figure 15: 2D top half core mesh featuring CIF outer wall that borders the UBP channel in dark purple.

## UBP Channel

The right half of the UBP channel that borders the outer graphite layer is created and triangulated. The mesh is then stitched to the mesh from the previous step.

!listing agn/3D_AGN-201_Final.i start=[top_half_right_og_in_ubp_channel] end=[xydg_mesh_top_half_left_og_in_ubp_channel]

The mesh is then reflected about the Y-axis. The boundaries are renamed, the mesh is stitched to the right side, and the left mesh boundaries are renamed.

!listing agn/3D_AGN-201_Final.i start=[xydg_mesh_top_half_left_og_in_ubp_channel] end=[top_half_right_ubp_channel_in_lead]

The previous steps are repeated for the UBP channel sections that border the lead, air gap, the reactor tank, and the water layer.

!listing agn/3D_AGN-201_Final.i start=[top_half_right_ubp_channel_in_lead] end=[top_half_right_cif_wall_in_ubp_outer_wall]

!media media/agn/agn_meshes/rename_boundaries_31.png
    style=width:55%;margin:auto;
    caption=Figure 16: 2D top half core mesh featuring the UBP channel sections (on the right and left sides) in pink, green, dark pink, dark brown, and light brown.

## CIF Outer Wall and Outer Graphite,

The right half of the CIF outer wall that is inside the UBP outer wall is generated from the equations for its curve, then the inside region is triangulated. The mesh is then stitched to the mesh from the previous step.

!listing agn/3D_AGN-201_Final.i start=[top_half_right_cif_wall_in_ubp_outer_wall] end=[xydg_mesh_top_half_left_cif_wall_in_ubp_outer_wall]

The mesh is then reflected about the Y-axis. The boundaries are renamed, the mesh is stitched to the right side, and the left mesh boundaries are renamed.

!listing agn/3D_AGN-201_Final.i start=[xydg_mesh_top_half_left_cif_wall_in_ubp_outer_wall] end=[top_half_right_og_in_ubp_outer_wall]

!media media/agn/agn_meshes/rename_boundaries_33.png
    style=width:55%;margin:auto;
    caption=Figure 17: 2D top half core mesh featuring CIF outer wall that borders the UBP channel in dark purple.

## UBP Outer Walls

The right half UBP outer wall that borders the outer graphite layer is modeled as a mesh and triangulated. The mesh is then stitched to the mesh from the previous step.

!listing agn/3D_AGN-201_Final.i start=[top_half_right_og_in_ubp_outer_wall] end=[xydg_mesh_top_half_left_og_in_ubp_outer_wall]

The mesh is then reflected about the Y-axis. The boundaries are renamed, the mesh is stitched to the right side, and the left mesh boundaries are renamed.

!listing agn/3D_AGN-201_Final.i start=[xydg_mesh_top_half_left_og_in_ubp_outer_wall] end=[top_half_right_ubp_outer_wall_in_lead]

The previous two steps are repeated for the UBP outer walls that are inside the lead, air gap, the reactor tank, and in water.

!listing agn/3D_AGN-201_Final.i start=[top_half_right_ubp_outer_wall_in_lead] end=[top_half_right_cif_wall_in_og_after_ubp]

!media media/agn/agn_meshes/rename_boundaries_43.png
    style=width:55%;margin:auto;
    caption=Figure 18: 2D top half core mesh featuring UBP inner walls (on the outer right and outer left) sections in brown, red, white, light purple, and dark purple.

## CIF Outer Wall inside the Outer Graphite Layer that is past the UBP

The right half of the CIF outer wall that sits inside the outer graphite layer and beyond the UBP is rendered as a mesh and triangulated. The mesh is then stitched to the mesh of the UBP outer wall that sits in water.

!listing agn/3D_AGN-201_Final.i start=[top_half_right_cif_wall_in_og_after_ubp] end=[ydg_mesh_top_half_left_cif_wall_in_og_after_ubp]

The mesh is then reflected about the Y-axis. The boundaries are renamed, the mesh is stitched to the right side, and the left mesh boundaries are renamed.

!listing agn/3D_AGN-201_Final.i start=[xydg_mesh_top_half_left_cif_wall_in_og_after_ubp] end=[top_half_right_og_after_ubp]

The previous two steps are repeated for the remainder of CIF wall sections, outer graphite, lead, air gap, reactor tank, and water layers.

!listing agn/3D_AGN-201_Final.i start=[top_half_right_og_after_ubp] end=[bottom_half_reactor]

!media media/agn/agn_meshes/rename_boundaries_63.png
    style=width:85%;margin:auto;
    caption=Figure 19: 2D top half core mesh featuring CIF outer walls in red and dark purple (on the bottom), outer graphite layer in teal, lead layer in blue/purple, air gap and reactor tank layers in light brown, and water layer in blue/purple (outermost layer).

## Bottom Half of Core

The bottom half of the reactor mesh is modeled by reflecting the previous mesh about the X-axis and renaming the boundaries. Then blocks are deleted for meshing the FCR and the SR2. The deletion creates a void, so block ids are assigned to the deleted area and meshed to remove the void.

!listing agn/3D_AGN-201_Final.i start=[bottom_half_reactor] end=[sr2_base]

!media media/agn/agn_meshes/bottom_half_reactor.png
    style=width:85%;margin:auto;
    caption=Figure 20: 2D bottom half core mesh.

## Full Core 2D Mesh

Then the SR2 mesh is generated, the background is deleted, and the mesh is translated. The same steps are used to create the FCR mesh. The meshes are then triangulated and stitched to the bottom of the core. The boundaries are renamed and then the SR1, SR2, CCR, and FCR blocks are all renamed.

!listing agn/3D_AGN-201_Final.i start=[sr2_base] end=[delete_core_cif_wall]

!media media/agn/agn_meshes/stitch_core_halves.png
    style=width:85%;margin:auto;
    caption=Figure 21: 2D full core mesh.

## Thermal Fuse

The core CIF region is the deleted from the mesh to create space for the thermal fuse.

!listing agn/3D_AGN-201_Final.i start=[delete_core_cif_wall] end=[tf_square]

!media media/agn/agn_meshes/delete_core_cif_wall.png
    style=width:85%;margin:auto;
    caption=Figure 22: 2D full core mesh featuring deleted area for thermal fuse.

The thermal fuse mesh is assembled and rotated 45 degrees. The boundaries are renamed and then the mesh is triangulated and stitched to the core. The block names are mapped to the block ids.

!listing agn/3D_AGN-201_Final.i start=[tf_square] end=[extrude]

!media media/agn/agn_meshes/tf_pcc.png
    style=width:60%;margin:auto;
    caption=Figure 23: 2D thermal fuse mesh.

## Final AGN-201 Mesh

The entire stitched mesh is extruded from 2D to 3D  The walls with channels are then homogenized and a final mapping of block names to block ids takes place to create the final AGN-201 mesh.

!listing agn/3D_AGN-201_Final.i start=[extrude] end=final_generator

!media media/agn/agn_meshes/extrude.png
    style=width:85%;margin:auto;
    caption=Figure 24: 3D full core mesh featuring close up of axial layers.
