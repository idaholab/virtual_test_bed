# Modular High-Temperature Gas-Cooled Reactor (3D-MHTGR) Mesh

!alert warning
This meshing script is provided as is in a coarse form. Convergence studies for the physics of interest should be performed by the user.

The hexagonal core mesh is created in several steps:

1. Meshes are generated for burnable poison pins and fuel pin geometry.

2. The large coolant and small coolant channel geometries are modeled.

3. Empty pins are modeled to represent the reflector only hexagonal unit cell, which will be deleted from the overall mesh to create the reserve shut-down control (RSC) channel.

4. The mesh is assembled by combining all of the individual meshes previously generated.

A more detailed explanation of each step follows below.

Throughout the steps, the metadata from the fine hexagonal core mesh is reapplied to the individual meshes. When the hexagonal meshes are modified, for example when adding the RSC channel to the model or modeling all the positional variations of the fuel and reflector blocks, they lose the metadata originally attached to the mesh. Thus, reapplying the metadata from before the modifications is necessary to generate the assembly of pin meshes and the whole core.

!alert note
Metadata propagation is now mostly automatically handled. 

## Fuel Pin

The `[fuel_pin_mesh]` models the fuel pins; each pin has six sides, with two sectors per side. Each fuel pin has a radius of 0.6225cm. The pins form a hollow circle which has an interior gap radius of 0.635cm.

!media media/htgr/mhtgr/3D_mesh/fuel_pin.png
    style=width:45%
    caption=Figure 1: Fuel Pin Mesh

!listing htgr/mhtgr/3D_mesh/3D_mhtgr_final.i block=Mesh/fuel_pin_mesh

## Burnable Poison Pin

A mesh is generated that describes the burnable poison pin geometry. Each pin has six sides, with two sectors per side. Each pin has a radius of 0.5715cm. The pins form a hollow circle which has an interior gap radius of 0.635cm.

!listing htgr/mhtgr/3D_mesh/3D_mhtgr_final.i block=Mesh/burnable_poison_pin_mesh

## Fuel Assembly

Second, two hexagonal fuel assembly meshes are then generated, one without the RSC channel and one with the RSC channel.

The assembly mesh without the RSC is composed of 4 burnable poison pin meshes, 143 fuel pin meshes, 121 large coolant channel meshes, 3 empty pin meshes, and 6 small coolant channel meshes.

!media media/htgr/mhtgr/3D_mesh/fuel_assembly.png
    style=width:45%
    caption=Figure 2: Fuel Assembly Mesh without RSC Channel

!listing htgr/mhtgr/3D_mesh/3D_mhtgr_final.i block=Mesh/fuel_assembly

The assembly with the RSC is composed of 6 burnable poison pin meshes, 132 fuel pin mesh elements, 102 large coolant channel mesh elements, 7 empty pin mesh elements, 14 empty pin to delete (for the RSC) mesh elements, and 5 small coolant channel mesh elements.

!media media/htgr/mhtgr/3D_mesh/fuel_assembly_with_rsc.png
    style=width:45%
    caption=Figure 3: Fuel Assembly Mesh with RSC Channel

!listing htgr/mhtgr/3D_mesh/3D_mhtgr_final.i block=Mesh/fuel_assembly_with_rsc

The hexagonal fuel assembly with RSC then undergoes many modifications.
First, the pin cells are deleted. Then, a new block ID is assigned to the holes left by the deletion and the holes are remeshed. The boundary of the RSC channel is then generated and stitched back into the fuel assembly mesh. Finally, the holes and the assembly meshes are stitched together.

!listing htgr/mhtgr/3D_mesh/3D_mhtgr_final.i start=[delete_pins_for_rsc] end=[fuel_assembly_w_rsc_stitched]

The RSC is oriented in 6 different positions, so lastly all 6 variations are generated using transformations. Each transformation strips metadata from the input mesh, so the metadata must be re-added after each rotation.

!media media/htgr/mhtgr/3D_mesh/fuel_assembly_with_rsc_variations.png
    style=width:85%
    caption=Figure 4: Fuel Assembly Mesh Variations

The following code is repeated for each transformation.

!listing htgr/mhtgr/3D_mesh/3D_mhtgr_final.i start=[fuel_assembly_with_rsc_1] end=[fuel_assembly_w_rsc_0]

## Reflector Assembly

The base of the assembly is generated first. Then, the interior is deleted in order to re-mesh the assembly to border the fuel assemblies without leaving long, thin elements that intersect in the center of the hexagon.

!listing htgr/mhtgr/3D_mesh/3D_mhtgr_final.i start=[reflector_assembly_base] end=[reflector_assembly]

A reflector assembly which borders fuel assemblies on 3 sides must be adapted by deleting, rebuilding, remeshing, triangulating, stitching, and reapplying the metadata to the interior.

!listing htgr/mhtgr/3D_mesh/3D_mhtgr_final.i start=[reflector_assembly_base_0_1_2] end=[reflector_assembly_0_1_2]

Because of the MHTGR geometry, this must be done for 6 different variations, notably through rotations in order for each reflector assembly to border fuel assemblies on 3 sides.

The following code is repeated for each transformation.

!listing htgr/mhtgr/3D_mesh/3D_mhtgr_final.i start=[transform_reflector_assembly_1_2_3] end=[reflector_assembly_1_2_3]

The entire process of adapting the reflector assembly and generating the 6 different variations is then repeated for the reflector assemblies with border fuel assemblies on only 2 sides.

!media media/htgr/mhtgr/3D_mesh/reflector_assembly_0_1.png
    style=width:45%
    caption=Figure 5: Reflector Assembly Mesh that borders Fuel Assemblies on 2 sides.

!listing htgr/mhtgr/3D_mesh/3D_mhtgr_final.i start=[reflector_assembly_base_0_1] end=[reflector_assembly_1_2]

The process is repeated again for the reflector assemblies which have a control rod (CR) hole in them and border 2 fuel assemblies. These assemblies are also reflected, so we need 12 permutations, not 6.

!media media/htgr/mhtgr/3D_mesh/reflector_assembly_w_cr_hole_0_1.png
    style=width:45%
    caption=Figure 6: Reflector Assembly Mesh with CR hole that borders Fuel Assemblies on 2 sides.

!listing htgr/mhtgr/3D_mesh/3D_mhtgr_final.i start=[reflector_assembly_w_cr_base_0_1] end=[reflector_assembly_w_cr_hole_0_1]

The following code is repeated for each of the 12 permutations.

!listing htgr/mhtgr/3D_mesh/3D_mhtgr_final.i block=Mesh/transform_reflector_assembly_w_cr_hole_0_1_reflected

!listing htgr/mhtgr/3D_mesh/3D_mhtgr_final.i block=Mesh/reflector_assembly_w_cr_hole_0_1_reflected

Lastly, the process is repeated for the reflector assemblies which have a control rod (CR) hole in them and border only 1 fuel assembly.

!media media/htgr/mhtgr/3D_mesh/reflector_assembly_w_cr_hole_2.png
    style=width:45%
    caption=Figure 7: Reflector Assembly Mesh with CR hole that borders Fuel Assembly on 1 side.

!listing htgr/mhtgr/3D_mesh/3D_mhtgr_final.i block=Mesh/reflector_assembly_w_cr_base_0

!listing htgr/mhtgr/3D_mesh/3D_mhtgr_final.i block=Mesh/delete_reflector_assembly_interior_w_cr_0

!listing htgr/mhtgr/3D_mesh/3D_mhtgr_final.i block=Mesh/rebuild_reflector_assembly_interior_w_cr_0

!listing htgr/mhtgr/3D_mesh/3D_mhtgr_final.i block=Mesh/remesh_reflector_assembly_interior_w_cr_0

!listing htgr/mhtgr/3D_mesh/3D_mhtgr_final.i block=Mesh/triangulate_reflector_assembly_w_cr_hole_0

!listing htgr/mhtgr/3D_mesh/3D_mhtgr_final.i block=Mesh/stitch_reflector_assembly_w_cr_hole_0

!listing htgr/mhtgr/3D_mesh/3D_mhtgr_final.i block=Mesh/fill_reflector_assembly_cr_hole_0

!listing htgr/mhtgr/3D_mesh/3D_mhtgr_final.i block=Mesh/stitch_reflector_assembly_cr_hole_filled_0

!listing htgr/mhtgr/3D_mesh/3D_mhtgr_final.i block=Mesh/reflector_assembly_w_cr_hole_0

The following code is repeated for each of the 6 permutations.

!listing htgr/mhtgr/3D_mesh/3D_mhtgr_final.i block=Mesh/transform_reflector_assembly_w_cr_hole_1

!listing htgr/mhtgr/3D_mesh/3D_mhtgr_final.i block=Mesh/reflector_assembly_w_cr_hole_1

## Assembly to Remove

The last step of generating the core mesh is to create an assembly with a unique block ID that can be removed from the mesh later; this ensures that the final core is not required to have a perfect hexagonal pattern and can have one assembly removed in each corner.

!listing htgr/mhtgr/3D_mesh/3D_mhtgr_final.i block=Mesh/assembly_to_remove

## Final Assembly

All of the smaller, previously generated assembly meshes are used as inputs and are assembled into a patterned hexagonal lattice 2D mesh.

!media media/htgr/mhtgr/3D_mesh/hex_core.png
    style=width:85%
    caption=Figure 8: Hexagonal core mesh featuring close up of core assembly meshes

!listing htgr/mhtgr/3D_mesh/3D_mhtgr_final.i block=Mesh/hex_core

An additional ring boundary is added to the 2D mesh.

!media media/htgr/mhtgr/3D_mesh/ring_boundary.png
    style=width:85%
    caption=Figure 9: Hexagonal core mesh with ring boundary featuring close ups of ring boundary mesh and core assembly meshes

!listing htgr/mhtgr/3D_mesh/3D_mhtgr_final.i block=Mesh/ring_boundary

The mesh is extruded with 4 graphite axial layers for the bottom reflector, 10 fuel axial layers in the center for the core and 1 axial graphite layer for the top reflector to create a 3D mesh.

!listing htgr/mhtgr/3D_mesh/3D_mhtgr_final.i block=Mesh/extrude

The blocks are renamed for convenience, and then element and depletion ids are assigned.

!listing htgr/mhtgr/3D_mesh/3D_mhtgr_final.i block=Mesh/add_plane_id

!listing htgr/mhtgr/3D_mesh/3D_mhtgr_final.i block=Mesh/rename_blocks

!listing htgr/mhtgr/3D_mesh/3D_mhtgr_final.i block=Mesh/add_material_id

!listing htgr/mhtgr/3D_mesh/3D_mhtgr_final.i block=Mesh/add_depletion_id

## Coarse Mesh Overlay Definition

Lastly the coarse mesh hexagon is generated with the same dimensions as the fine mesh.

!media media/htgr/mhtgr/3D_mesh/coarse_hex_core.png
    style=width:45%
    caption=Figure 11: Coarse hexagonal core mesh

!listing htgr/mhtgr/3D_mesh/3D_mhtgr_final.i block=Mesh/coarse_mesh_hex

!listing htgr/mhtgr/3D_mesh/3D_mhtgr_final.i block=Mesh/coarse_mesh_hex_meta

!listing htgr/mhtgr/3D_mesh/3D_mhtgr_final.i block=Mesh/coarse_hex_core

The metadata is added to the coarse mesh, another ring boundary is created, and the 2D coarse mesh is then extruded.

!media media/htgr/mhtgr/3D_mesh/coarse_mesh_ring_extrude.png
    style=width:75%
    caption=Figure 12: Left: Coarse hexagonal core mesh with ring boundary; Right: 3D, Extruded coarse hexagonal core mesh

!listing htgr/mhtgr/3D_mesh/3D_mhtgr_final.i block=Mesh/coarse_ring

!listing htgr/mhtgr/3D_mesh/3D_mhtgr_final.i block=Mesh/coarse_extrude

Finally the coarse mesh is superimposed onto the fine mesh. The coarse mesh is used for Coarse Mesh Finite Difference, a transport acceleration technique. This results in the final 3D MHTGR hexagonal core mesh.

!listing htgr/mhtgr/3D_mesh/3D_mhtgr_final.i block=Mesh/coarse_mesh_id

This method is used when solving full-core analysis in the Nuclear Energy Advanced Modeling and Simulation (NEAMS) code Griffin. More information regarding Griffin is available [here](https://mooseframework.inl.gov/moose/help/inl/applications.html).

!media media/htgr/mhtgr/3D_mesh/final_mesh.png
    style=width:85%
    caption=Figure 13: 3D MHTGR Hexagonal core mesh featuring close ups of core assembly meshes and ring barrier mesh

