# 2D Generic Heat Pipe Microreactor (gHPMR) Model Mesh

!alert warning
This meshing script generates a mesh in a coarse form. Convergence studies for the physics of interest should be performed by the user.

The 2D generic Heat Pipe Microreactor (gHPMR) Model Mesh is created in several steps:

1. The fuel pin cell and heat pipe pin cell meshes are generated.

2. The fuel assembly meshes are created.

3. The core mesh is generated from the lattice of assembly meshes.

4. The control drum meshes are generated and translated to account for each drum position and placement in the core.

5. The reflector mesh is generated.

6. The final 2D core mesh is generated including outer reactor vessel boundary.

A more detailed explanation of each step follows below.

## Fuel Pin Cell Meshes

First, there are 5 fuel pin meshes that are generated - 4 are for assemblies without a control rod channel and 1 for an assembly with a control rod channel.

!listing microreactors/gHPMR/2D_gHPMR_Final.i start=[fuel_pin_R0] end=[heat_pipe_pin]

!media media/gHPMR/fuel_pins.png
    style=width:75%;margin:auto;
    caption=Figure 1: The five 2D fuel pin cell meshes; the yellow pin mesh is the pin used in the fuel assembly which contains a control rod channel.

Then a pin cell mesh is generated for the heat pipe.

!listing microreactors/gHPMR/2D_gHPMR_Final.i block=Mesh/heat_pipe_pin

!media media/gHPMR/heat_pipe_pin.png
    style=width:50%;margin:auto;
    caption=Figure 2: The 2D heat pipe pin cell mesh.

Two fake pin cell meshes are generated for the purpose of deletion in future steps.

!listing microreactors/gHPMR/2D_gHPMR_Final.i start=[fake_pin] end=[assembly1_R0]

## Fuel Assembly

Fuel Pin assemblies are then generated for each of the 5 fuel pin meshes.

The fuel pin cell assembly is generated using the previous step's pin cell meshes. The fake pin cells are then deleted from the assembly mesh in order to create a void for the heat pipe meshes in future steps. The outer assembly boundary is generated. Boundary ids are renamed and meta data is added back to the assembly mesh. This process is repeated for the four other fuel assemblies.

!alert note title=Metadata
When the hexagonal meshes are modified, they lose the original metadata. Thus reapplying the metadata from before the modifications is necessary to generate the assemblies. This will no longer be necessary in future versions.

!listing microreactors/gHPMR/2D_gHPMR_Final.i start=[assembly1_R0] end=[assembly3]

!media media/gHPMR/fuel_assemblies.png
    style=width:100%;margin:auto;
    caption=Figure 3: The identical 2D fuel assembly meshes; heat pipe pin cell meshes are in green and the fuel pin cell meshes are in red.

The last fuel pin assembly mesh generated includes a control rod channel. The same steps as above are followed, but block ids must be assigned to the larger, to be deleted, void region before being meshed. Then the control rod hole is carved and stitched back to the hexagonal assembly mesh.

!listing microreactors/gHPMR/2D_gHPMR_Final.i start=[assembly3] end=[core1]

!media media/gHPMR/fuel_assembly_CR.png
    style=width:60%;margin:auto;
    caption=Figure 4: The 2D fuel assembly mesh containing a control rod channel in the center; heat pipe pin cell meshes are in green and the fuel pin cell meshes are in red.

## Hexagonal Core Assembly

The hexagonal core assembly mesh is generated using the previous step's fuel pin assembly meshes. The block ids are renamed to separate the monolith triangular elements. Then the outer core ring boundary is created.

!listing microreactors/gHPMR/2D_gHPMR_Final.i start=[core1] end=[control_drum_base]

!media media/gHPMR/hex_core.png
    style=width:60%;margin:auto;
    caption=Figure 5: The 2D hexagonal core assembly mesh.

## Control Drum Meshes

The meshes for the 12 control drums are then generated. The control drum base mesh is first generated, then the outer polygon area is deleted to keep only the circular control drum.

!listing microreactors/gHPMR/2D_gHPMR_Final.i start=[control_drum_base] end=[control_drum_S1_A]

The control drum mesh is rotated then translated multiple times to account for every position and placement of the drums in the core.

!listing microreactors/gHPMR/2D_gHPMR_Final.i start=[control_drum_S1_A] end=[reflector_polygon]

!media media/gHPMR/control_drums.png
    style=width:75%;margin:auto;
    caption=Figure 6: Six control rods with different orientations.

## Reflector Mesh

The mesh for the reflector is generated using a lattice of polygonal meshes to keep a more structured mesh, and avoid generating a 2D mesh in a large area. The mesh is then translated several times to account for every position and placement of reflectors in the core.

!listing microreactors/gHPMR/2D_gHPMR_Final.i start=[reflector_polygon] end=[outer_core_mesh]


## Outer Core Mesh

Lastly, the core mesh is merged with the control drum and reflector meshes to generate a final core mesh which includes the outer core area. Block ids are renamed to keep triangular and quadrilateral elements separate. The outer vessel mesh is generated and sidesets are added to specify the radial boundary of the reactor vessel.

!listing microreactors/gHPMR/2D_gHPMR_Final.i start=[outer_core_mesh] end=final_generator

!media media/gHPMR/final_core.png
    style=width:65%;margin:auto;
    caption=Figure 8: The 2D final core assembly mesh featuring 12 control drums, exterior reactor vessel ring in red, fuel assemblies in yellow, and fuel assemblies with control rod channels in pink.

!media media/gHPMR/final_core_closeup.png
    style=width:75%;margin:auto;
    caption=Figure 9: Closeup of the 2D final core assembly mesh featuring control drums in gray and fuel assemblies with and without control rod channels.


## Extrusion to 3D Specifications

The spacial discretization specifications are summarized below.

!table id=table-floating caption=The 2D mesh can be extruded to form a 3D mesh. Table 1 summarizes the extrusion specifications in the gHPMR model, from [!cite](gHPMR_main).
| Spacial Discretization                          | Value                              |
|:------------------------------------------------|:-----------------------------------|
| Number of Axial Elements in Evaporator Section  | 18                                 |
| Number of Axial Elements in Adiabatic Section   | 4                                  |
| Number of Axial Elements in Condenser Section   | 18                                 |
| Number of Radial Elements in Wick Region        | 2                                  |
| Number of Radial Elements in Annular Gap Region | 2                                  |
| Number of Radial Elements in Cladding Region    | 2                                  |
