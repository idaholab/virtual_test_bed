# SEFOR Mesh Model for Core I-E

The MOOSE Reactor Module was used to set up geometry for Griffin calculations. To accurately model the heterogeneous SEFOR core, several specialized mesh generators within the Reactor Module were utilized [!citep](Shemon2023sefor). As depicted in [fuel_pin], the cylindrical reactor components, specifically fuel pins, insulators, wire-wraps, and absorber pins, were generated using the `AdvancedConcentricCircleGenerator` mesh generator. 

!listing sfr/sefor/Mesh/Mesh_Core-I-E_3D_450K.i
         block=std_fuel_pin
         id=fuel_pin
         caption=MOOSE Reactor Module input for modeling a single fuel pin.

[central_pin] shows that the `HexagonConcentricCircleAdaptiveBoundaryMeshGenerator` was used for the central tightener pin and its surrounding duct, which provides adaptive boundary meshing optimized for hexagonal structures. 

!listing sfr/sefor/Mesh/Mesh_Core-I-E_3D_450K.i
         block=std_central_pin_w_duct
         id=central_pin
         caption=MOOSE Reactor Module input for modeling the central rod and its tightener.

Following this, the fuel assemblies, including their ducts and assembly gaps, were defined using the `FlexiblePatternGenerator` mesh generator as illustrated in [SA], which supports different assembly types. The generated mesh of the different types of fuel assemblies is shown in [Mesh_model_FA] .

!listing sfr/sefor/Mesh/Mesh_Core-I-E_3D_450K.i
         start=std_assm
         end=gp2_fuel_pin
         id=SA
         caption=MOOSE Reactor Module input for modeling a standard fuel assembly.

!media media/sefor/Core_IE_Mesh_FA.png
      style=display: block;margin-left:auto;margin-right:auto;width:60%;
      id=Mesh_model_FA
      caption= Mesh model of SEFOR Core I-E fuel assemblies: (a) Standard Assembly (SA), (b) SA with a GP rod and a B<sub>4<sub>C rod, (c) SA with 2 GP rods, and (d) AFA

These assemblies were arranged into the complete reactor core layout using the `PatternedHexMeshGenerator` mesh generator  as illustrated in [Lattice]. 

!listing sfr/sefor/Mesh/Mesh_Core-I-E_3D_450K.i
         block=pattern_core
         id=Lattice
         caption=MOOSE Reactor Module input for modeling fuel lattice.

Additionally, peripheral reactor regions such as the downcomer, outer vessel, radial reflector, and radial shield were integrated with the core using the `PeripheralRingMeshGenerator` mesh generator shown in [outer_boundary]. At this stage, the reactor mesh represented a 2-D configuration as illustrated in [Mesh_model_2D] (a).

!listing sfr/sefor/Mesh/Mesh_Core-I-E_3D_450K.i
         start=del_dummy
         end=core_3d
         id=outer_boundary
         caption=MOOSE Reactor Module input for modeling radial layers outside the fuel lattice.

!media media/sefor/Core_IE_mesh_model.png
      style=display: block;margin-left:auto;margin-right:auto;width:60%;
      id=Mesh_model_2D
      caption= Mesh model of SEFOR Core I-E with (a) X-Y view (b) X-Z view

To expand this into a complete 3-D reactor geometry, the `AdvancedExtruderGenerator` mesh generator was employed as shown in [Mesh_model_3D], which allowed flexible axial extrusion of the existing 2-D mesh into the full axial height. This mesh generator also offers functionality to interchange or redefine axial regions, to enable accurate representation of complex axial geometry variations in the SEFOR reactor core . The 3-D axial core mesh depicted Core I-E in [Mesh_model_2D] (b). 

!listing sfr/sefor/Mesh/Mesh_Core-I-E_3D_450K.i
         block=core_3d
         id=Mesh_model_3D
         caption=MOOSE Reactor Module input for generating 3-D mesh.

