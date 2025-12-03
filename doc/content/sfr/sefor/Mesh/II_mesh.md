# SEFOR Core I-I Griffin Model 

## SEFOR Mesh Model

The Core I-I mesh encompasses configurations absent in Core I-E, most notably the  Instrumentation Fuel Assembly (IFA) and fuel assemblies containing two GP rods and one B₄C rod. The mesh represents a fully heterogeneous 3D reactor core, capturing the various fuel assembly types and structural components. The Standard Fuel Assembly (FA) comprises multiple components, including the MOX fuel pin, void gap, SS316 cladding, BeO central pin, and several stainless-steel and sodium regions representing ducts, coolant, and inter-assembly gaps. 

Core I-I incorporates several FA variants such as FA with 1 GP, FA with 1 B4C, FA with 1 B4C & 1 GP, and FA 
with 2 GP & 1 B4C; as well as specialized assemblies like the FRED and IFA configurations. Beyond the fuel assemblies, the mesh includes peripheral and structural zones such as downcomers, radial reflectors, radial shields, and sodium-steel interface regions (e.g., Na-Grid Plate and Na Steel). Collectively, this mesh defines a detailed geometric and material representation essential for high-fidelity neutronic simulations of reactor behavior.

A detailed modeling of the heterogeneous SEFOR core was achieved through the use of several specialized mesh generators within the Reactor Module. Cylindrical reactor components such as fuel pins, insulators, wire-wraps, and absorber pins were meshed using the `AdvancedConcentricCircleGenerator`, designed to capture detailed concentric geometries. The central tightener pin and its enclosing duct were generated with the 
`HexagonConcentricCircleAdaptiveBoundaryMeshGenerator`, which provides adaptive boundary refinement tailored to hexagonal lattice structures. The fuel assemblies, including their ducts and inter-assembly gaps, were constructed using the `FlexiblePatternGenerator`, enabling the definition of multiple assembly configurations. These assemblies were subsequently arranged into the overall core layout via the `PatternedHexMeshGenerator`. To ensure continuity and geometric integrity, peripheral components such as the downcomer, outer vessel, radial reflector, and radial shield were integrated with the core using the `PeripheralRingMeshGenerator`. To transform the 2D core mesh into a fully three-dimensional reactor model, the `AdvancedExtruderGenerator` was 
employed. This mesh generator enables flexible axial extrusion of the 2D mesh to the full core height and supports the modification or reassignment of axial regions, allowing for an accurate representation of complex axial heterogeneities within the SEFOR reactor.

In the Core I-I configuration, special attention was required for axial layer discretization to accurately define regions corresponding to the sodium grid plate, reflector, insulator, fuel, void, and nickel reflector in the standard fuel pins. Additional axial zones were incorporated for specialized rods, including B₄C, tightener, and GP rods. The inclusion of Instrumentation Fuel Assembly (IFA) rods further increased the complexity of the axial meshing, as their axial zoning did not coincide with that of standard assemblies. This non-alignment necessitated finer axial mesh refinement within Core I-I to preserve the accuracy of material and geometric transitions across all rod types.



!listing sfr/sefor/Mesh/SEFORII_3D_450.i

