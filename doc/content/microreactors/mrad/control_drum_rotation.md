# 3D Multiphysics Simulation of Control Drum Inadvertent Rotation in HP-MR

*Contact: Ahmed Amin Abdelhameed (aabdelhameed.at.anl.gov), Yinbin Miao (ymiao.at.anl.gov) ), Nicolas Stauff (nstauff.at.anl.gov)*

*Model link: [HPMR Model](https://github.com/idaholab/virtual_test_bed/tree/devel/microreactors/mrad/3D_core_drum_rotation_tr)*

## Overview

In microreactors, modeling events involving rotating control drums can present challenges due to geometry deformation, localized power peaking, and complex multiphysics feedback. These effects must be accurately captured in high-fidelity, three-dimensional multiphysics simulations.

In this work, we investigate inadvertent drum rotation in HP-MR using a fully coupled 3D multiphysics model involving **Griffin**, **BISON**, and **Sockeye**.

A MOOSE MultiApp system with Griffin as the parent application was used. The MultiApp system enables seamless data exchange between Griffin, its child application (BISON), and its grandchild application (Sockeye).


!media media/mrad/MultiApp2.png
       style=display: block;margin-left:auto;margin-right:auto;width:90%;
       id=MultiApp_Hierarchy_HP-MR Model
       caption=MultiApp hierarchy of the HP-MR model.


In this coupling strategy, **Griffin** solves the high-fidelity neutronics problem to obtain the power density distribution at each time step of the dynamic transient. This power data is transferred to **BISON** using shape-function-preserving mapping to ensure integrated power conservation, allowing BISON to solve the heat conduction equations and compute solid temperatures. The resulting heat flux at the heat pipe surfaces is passed to **Sockeye**, which solves the thermal transport in the heat pipes and returns the updated surface temperatures to BISON for feedback. The simulation is tightly coupled using a **Picard fixed-point iteration** with defined convergence criteria to ensure stability and accuracy.

## Mesh File

In this analysis, a 3D whole-core model with 1/6 symmetry was employed. The **MOOSE Reactor Module** provides several tools for generating finite element meshes, enabling rapid construction of detailed heterogeneous reactor geometry—including pins, assemblies, control drums, and peripheral zones—through operations such as extrusion and rotation.

!listing /mrad/mesh/HPMR_OneSixth_finercdrum.i max-height = 10000

### Mesh Generation Workflow

The meshing process begins by defining various pin types (moderator pins, heat pipe pins, and fuel pins) using the `PolygonConcentricCircleMeshGenerator`. These pins are then arranged within fuel assemblies using the `PatternedHexMeshGenerator`. To handle external boundaries of the hexagonal assemblies, the `PatternedHexPeripheralModifier` is applied. This class uses `FillBetweenPointVectorsTools` to replace the outermost layer of quadrilateral elements with a transitional layer of triangular elements. This ensures node placement at designated boundary positions, facilitating the stitching of adjacent hexagonal assemblies with differing boundary node counts due to interior pin variations or azimuthal discretization.

### Control Drum Meshing

Control drums were meshed using the `HexagonConcentricCircleAdaptiveBoundaryMeshGenerator`. For drum-containing assemblies, the `num_sectors_per_side` parameter was increased to ensure mesh refinement in the drum region, guaranteeing the drum's front face aligns with element edges at each time step.


!media media/mrad/mesh_hpmr_drum.png
       style=display: block;margin-left:auto;margin-right:auto;width:90%;
       id=hpmr_mesh_used
       caption=HP-MR mesh used in the analysis.


### Reflector and 3D Core Construction

The radial reflector was modeled with the `PeripheralRingMeshGenerator` to generate the outer shield region. A dummy fuel assembly was temporarily added to complete the hexagonal core pattern and later removed using the `BlockDeletionGenerator`.
Assemblies (including those with control drums) were patterned with the `PatternedHexMeshGenerator`. A 1/6 symmetry model of the HP-MR core was created by trimming the full hexagonal core using the `PlaneDeletionGenerator`. The resulting 2D mesh was extruded into 3D using the `AdvancedExtruderGenerator`, with axial layers defined via the `subdomain_swaps` parameter.


## Griffin Neutronics Simulation

### Multi-Group Cross Sections

Multi-group cross sections with 11 energy groups were generated using the **Serpent 2 Monte Carlo code**, based on a parametric grid defined by **Control drum rotation angle** (4 values), **Fuel temperature** (5 values), and **Temperature of moderator, reflector, monolith, and heat pipe** (4 values), using a total of 80 Serpent-2 simulations.


!listing /mrad/3D_core_drum_rotation_tr/HPMR_dfem_griffin_tr.i max-height = 10000


### Mesh Split

A split-mesh workflow in Griffin entails first generating the appropriate mesh split configuration before running simulations with MOOSE. This process is guided by the Mesh block in Griffin’s input files. If a presplit mesh is not already available, the user must first generate it by uncommenting all mesh blocks, using the Exodus mesh file in the `[fmg]` block, and commenting out the `parallel_type = distributed`. Then, the MOOSE executable is used to perform the mesh splitting. Once the pre-split mesh is generated, the user switches to simulation mode by commenting all mesh blocks except the `[fmg]` block, replacing the Exodus file with the split .cpr file, and uncommenting the `parallel_type = distributed` line to enable distributed processing during simulation.

### Mesh Configuration and Element ID Assignment

In the `[Mesh]` block, the `SubdomainExtraElementIDGenerator` was used to assign extra element IDs that were derived from the mesh’s subdomain IDs. The `subdomains` parameter in this case used numeric identifiers. The `extra_element_ids` input was specified as a two-dimensional vector, with each row corresponding to an entry in the `extra_element_id_names` parameter.

A coarse mesh was generated using the `GeneratedMeshGenerator`, with the mesh dimension set to three and the number of elements in the x, y, and z directions set to 10. The mesh boundaries were defined using the `xmax`, `xmin`, `ymax`, `ymin`, `zmax`, and `zmin` parameters. To associate coarse element IDs with the fine mesh, the `CoarseMeshExtraElementIDGenerator` was applied. This generator used the `coarse_mesh` parameter to specify the coarse mesh source, and the `extra_element_id_name` parameter was used to define the name of the element ID field that was added to the fine mesh. This setup ensured that each element in the fine mesh received a coarse ID based on the spatial mapping defined by the coarse mesh.

### Griffin Solver

The Griffin simulations used the **DFEM-SN transport solver** with **CMFD acceleration**. Angular discretization was performed using a Gauss-Chebyshev quadrature. In the multiphysics analysis, the angular quadrature was configured with one polar angle and three azimuthal angles, which produced a total of 24 discrete directions in the three-dimensional model. The finite element shape function family for the primal variables, i.e., the angular fluxes, was set to `MONOMIAL`, using first-order shape functions. The maximum order of scattering anisotropy was set to 2.

To improve computational efficiency, the `using_array_variable` setting was enabled. This allowed angular fluxes for each group to be stored using MOOSE’s `ArrayVariable` system, which reduces the number of computational kernels and lowers the overall cost. In addition, the `collapse_scattering` option was enabled to allow in-group scattering sources to be formed directly within the scattering kernels, further decreasing simulation runtime.

CMFD acceleration was enabled to assist with convergence. The `prolongation_type` was set to `multiplicative`, meaning that the coarse mesh solution was used to update the fine mesh flux in a multiplicative manner. This choice affects convergence behavior and may be tuned based on solver performance. A maximum diffusion coefficient value of 1 was defined using the `max_diffusion_coefficient` parameter. When this cap is triggered, a warning is issued, and the value is clipped. Users must ensure that the Richardson iteration converges properly when this cap is applied, as limiting the diffusion coefficient can have a negative impact on convergence.

### Solver Configuration

The Richardson outer iteration was configured with an absolute tolerance of 1e-4, a relative tolerance of 5e-5, and a maximum of 1000 iterations. The inner linear solver used GMRES, with a maximum of 100 iterations per solve.

### Neutronics Material Models

For all material regions except the control drums, the `CoupledFeedbackMatIDNeutronicsMaterial` was used. This material model performs on-the-fly interpolation of cross sections that are tabulated in the ISOXML XML format. The tabulation is evaluated dynamically using the local values of coupled variables governing the feedback mechanisms, such as temperature.

For control drum regions, the `CoupledFeedbackRoddedNeutronicsMaterial` was employed. This material type is specifically designed to handle control drum and control rod movements. Drum rotation is modeled using a set of Griffin input parameters including `rod_segment_length`, `front_position_function`, `rotation_center`, and `segment_material_ids`. These inputs define the poison and non-poison regions and their associated materials. The drum’s rotational position is governed by the `front_position_function`, which references a MOOSE Function that varies with simulation time.


## Heat Transfer Modeling

Heat conduction in solid components of the HP-MR system was modeled using BISON, which employed the `HeatConduction` object from MOOSE. This simulation included all solid materials except for the heat pipes. Sockeye was used to model the heat pipes, employing a 2D R-Z axisymmetric conduction model to simulate transient temperature profiles.

!listing /mrad/3D_core_drum_rotation_tr/HPMR_thermo_tr.i max-height = 10000

!listing /mrad/3D_core_drum_rotation_tr/HPMR_sockeye_tr.i max-height = 10000

## Neutronic Results

Before proceeding to the full multiphysics analysis, it is beneficial to first examine the neutronics-only results to establish a baseline for comparison. In this study, a dynamic simulation was performed on a 1/6 core model, where the middle control drum (the one not intersected by any symmetry lines) was rotated, while the other two drums remained stationary. Due to the 1/6 core symmetry, rotating this single drum represents the synchronized rotation of all six control drums in the full core. Reflective boundary conditions were applied along the symmetry planes, and vacuum boundary conditions were imposed on the top, bottom, and outer radial surfaces. At the start of the simulation, the rotating drum was inserted by 35 degrees, while the two stationary drums remained in the fully withdrawn position throughout the simulation.

The neutronics-only transient simulations were carried out by disabling the `[MultiApps]` and `[Transfers]` blocks, as well as any postprocessors related to heat transfer. The initial condition for the transient run was obtained from a previously computed steady-state solution. This steady-state solution is saved to a file and then imported into the transient simulation using the `TransportSolutionVectorFile` user object. To generate the steady-state solution file, appropriate `UserObjects` are added to the steady-state input file, with execute_on = final to ensure the solution is captured at the end of the simulation.

The transient simulation employed the DFEM-SN method with CMFD acceleration, using an SN(2,3) with NA=2. Two scenarios were analyzed. In Scenario I, the control drums accidentally rotate outward at a rate of 5 degrees per second for 1 second, followed by an inward rotation at the same rate for 2 seconds due to reinserting the drums. In Scenario II, the drums rotate outward at a faster rate of 20 degrees per second for 1 second, then inward at the same speed for 2 seconds. As the drums move outward from their initial position, positive reactivity is introduced, causing a rise in reactor power. This is subsequently reduced as the drums are reinserted during the corrective action.

!media media/mrad/CDR_Neutronics.gif
       style=display: block;margin-left:auto;margin-right:auto;width:90%;
       id=3D_Visualization_Griffin_only
       caption=Scenario I: 3D Visualization of Power Density (Griffin-Only).

!media media/mrad/CDR_Neutronic_I.png
       style=display: block;margin-left:auto;margin-right:auto;width:90%;
       id=ScenarioI_Normalizedpower
       caption=Scenario I: Normalized power (Griffin-Only).

!media media/mrad/CDR_Neutronic_II.png
       style=display: block;margin-left:auto;margin-right:auto;width:90%;
       id=ScenarioII_Normalizedpower
       caption=Scenario II: Normalized power (Griffin-Only).

## Multiphysics Results

The control drum rotation in Griffin was modeled using a multiphysics simulation that coupled Griffin, BISON, and Sockeye, as previously described, to capture the reactor’s reactivity response to drum movement while accounting for temperature effects. Each time step in the simulation required approximately 15 Richardson iterations involving both the BISON child application and the Sockeye grandchild application, making the multiphysics control drum rotation transient computationally expansive. To reduce computational demands, the neutronics model used for the multiphysics simulation was simplified from SN(2,3) NA=2 to SN(1,3) NA=2.
 Compared to the neutronics-only model, the multiphysics simulation predicted a slightly lower power increase during control drum rotation. This difference is primarily attributed to temperature feedback effects, which are not captured in the single-physics (neutronics-only) model. As the control drums rotate outward, they insert positive reactivity, resulting in a rapid increase in reactor power. This power spike leads to a prompt rise in both fuel and moderator temperatures. Due to the inherently negative temperature reactivity feedback of the core, this temperature rise introduces negative reactivity, which counteracts the initial positive reactivity and ultimately suppresses the peak power.
After one second of outward drum rotation, the control drums are reinserted, leading to a quick drop in both reactor power and temperatures. By the third second of the transient, both the multiphysics and neutronics-only models converge to nearly identical power levels. At this stage, the moderator and fuel temperatures are below their nominal values, and the control drums are inserted deeper than their original positions prior to the transient.

!media media/mrad/CDR_MP.gif
       style=display: block;margin-left:auto;margin-right:auto;width:90%;
       id=CDR_MP
       caption=Multiphysics 3D visualization of HP-MR power density during the power increase period caused by control drum rotation.

!media media/mrad/CDR_MP_Power.png
       style=display: block;margin-left:auto;margin-right:auto;width:90%;
       id=CDR_MP_Power
       caption=Time evolution of HP-MR power due to control drum rotation: multiphysics simulation compared to single-physics neutronics

!media media/mrad/CDR_MP_Temp.png
       style=display: block;margin-left:auto;margin-right:auto;width:90%;
       id=CDR_MP_Temp
       caption=Time evolution of the average fuel and moderator temperature from multiphysics simulation due to control drum rotation.
