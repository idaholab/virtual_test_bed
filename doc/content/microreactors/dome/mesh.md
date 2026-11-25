# DOME Mesh Description

The DOME shield is a concrete and water structure that is 29 ft wide, 47 ft long, and 23 ft high [!citep](MPR2025thermal). It surrounds a central cavity that houses the reactor under test and shields the facility from heat and radiation. [dome_shield_yz] shows a cross-section of the shield in the Y-Z plane. The shield has two doors, Door 1 and Door 2, with an air gap between them (Airgap 1) and a second air gap between Door 2 and the rest of the shield (Airgap 2). The floor has varying heights and varying materials, labeled Floor 1 and Floor 2 in the figure to distinguish the regions when generating the mesh.

!media media/dome/dome_shield_yz.png
       style=width:70%
       id=dome_shield_yz
       caption=Y-Z cross-sectional view of the DOME shield model.

Water tanks are positioned on three sides of the reactor and provide an additional layer of thermal shielding around the reactor region. Each water tank is surrounded by one inch of insulation on all sides. In addition, air gaps separate the outer wall of each water tank from the inner wall of the shield, as shown in [dome_shield_xz]. These air gaps are included in the model and reduce heat transfer from the water to the concrete because of the high thermal resistance of air.

!media media/dome/dome_shield_xz.png
       style=width:70%
       id=dome_shield_xz
       caption=X-Z cross-sectional view of the DOME shield model.

The floor and ceiling are divided into multiple regions to account for differences in geometry and material properties. Floor 3 is a separate section within the region labeled Floor 2, because the two floor regions have different material properties. Likewise, the ceiling is divided into several regions because Ceiling 2 has a different height than Ceiling 3 and Ceiling 5.

The ground beneath the floor is also included in the model, as a layer of normal-weight concrete whose top surface is at the bottom of the floor (z = 0). The bottom surface of the ground layer is the lower boundary of the model.

Door 2, Ceiling 1, Floor 3, and the ground are modeled with normal-weight concrete. All remaining structural components, including Floor 2, are modeled with heavy-weight concrete. For simplicity, the rebar within the concrete blocks is neglected. Resolving the rebar in the mesh is impractical, but the concrete and rebar could be homogenized using appropriate average thermal properties if the volume of rebar in each concrete block is known.

[dome_thermal_mesh] shows the mesh used in the thermal model. A simplified reactor core, consisting of a cylindrical heated region inside a box of insulation, is placed in the middle of the shield cavity. The space between the inner surface of the shield and the core is filled with a Delaunay tetrahedral mesh using the XYZDelaunayGenerator. Element transition layers are generated at the inner surface of the shield and at the outer surface of the core. These layers transition between the HEX8 (8-node) elements in the interiors of the shield and core and the TET4 (4-node) elements in the cavity using PYRAMID5 elements, which prevents hanging nodes.

!media media/dome/dome_thermal_mesh.png
       style=width:80%
       id=dome_thermal_mesh
       caption=Thermal model mesh with the cavity block removed and the ground layer omitted, cut with a Y-Z plane (left) and an X-Y plane (right).

## Mesh File Description

All the dimensions of the components of the DOME shield are specified in `params_base.i`.

!listing microreactors/dome/mesh/final/params_base.i
         id=dome_params_base
         caption=Dimensions of the shield.

The dimensions from [dome_params_base] are used in `shield_with_core_base.i`, which assigns the shield components (the doors, walls, floors, ceilings, air gaps, water tank, tank walls, and ground) to blocks of a Cartesian grid.

!listing microreactors/dome/mesh/final/shield_with_core_base.i
         id=dome_shield_base
         caption=Mesh file for the shield components.

The core mesh is described in `cyl_in_box.i` as a simple cylinder with insulation around it.

!listing microreactors/dome/mesh/reactors/cyl_in_box.i
         id=dome_core_mesh
         caption=Mesh file for the cylindrical core.

The core is added to the shield mesh in `shield_with_core.i`, which also defines the Cartesian grid, generates the cavity mesh around the core, and stitches the meshes together. The mesh is built in the following steps:

1. The Cartesian grid is generated, with grid lines placed at the boundaries of the shield components so that each component can be assigned to a block, as done in shield_with_core_base.i.
2. The cavity block is deleted, and its exposed surface is saved as the inner_surface boundary. The hexahedral elements along this surface are converted to pyramid and tetrahedral elements (blocks with the suffixes _pyr and _tet), so that they can connect to the tetrahedral cavity mesh.
3. The core mesh cyl_in_box.e is loaded and translated into the cavity. Its outer surfaces are combined into a single core_outer boundary.
4. The cavity between the inner_surface boundary and the core is filled with a tetrahedral mesh using the XYZDelaunayGenerator. Transition layers of pyramid and tetrahedral elements (core_insulation_pyr and core_insulation_tet) are generated on the outer surface of the core insulation.
5. The shield mesh and the cavity mesh are stitched together along the inner_surface boundary, which is kept so that it can be used to model thermal radiation from the core to the shield.

!listing microreactors/dome/mesh/final/shield_with_core.i
         id=dome_shield_with_core
         caption=Shield mesh file with the core included in the cavity.