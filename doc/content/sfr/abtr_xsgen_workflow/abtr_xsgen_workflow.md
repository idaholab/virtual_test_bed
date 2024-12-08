# Advanced Burner Test Reactor (ABTR) Cross Section Generation and Full-Core Eigenvalue Calculation

*Contact: Shikhar Kumar, kumars.at.anl.gov*

*Model link: [ABTR Cross Section Generation and Full-Core Model](https://github.com/idaholab/virtual_test_bed/tree/main/sfr/abtr_xsgen_workflow)*

!tag name=Advanced Burner Test Reactor Cross Section Generation and Full-Core Eigenvalue Calculation
     description=This model presents a workflow for generating group cross sections and performing homogenized neutronics core calculations of the Advanced Burner Test Reactor
     image=https://mooseframework.inl.gov/virtual_test_bed/sfr/abtr_xsgen_workflow/plots/eqv_fullhomcore.png
     pairs=reactor_type:SFR
                       reactor:ABTR
                       geometry:core
                       simulation_type:neutronics
                       codes_used:Griffin
                       transient:steady_state
                       V_and_V:demonstration
                       features:data_driven_mesh;reactor_meshing
                       computing_needs:HPC
                       cross_sections:MCC3
                       fiscal_year:2024
                       institution:ANL
                       sponsor:NEAMS
                       input_features:cross_section_generation

## Introduction

This tutorial describes the methodology used for generating multigroup cross sections for a [!ac](SFR) model, and how these cross sections can then be applied to a full-core steady-state eigenvalue solve in Griffin. The cross section generation methodology is based on a two-step procedure that is used by the MC$^2$-3 code [!citep](MCC3manual), and the specifications for a 3-D [!ac](ABTR) model [!citep](Chang2008) are chosen to demonstrate these capabilities. This tutorial will cover the following topics:

- Overview of cross section generation methodology and codes used, found in [#sec:xsgen_overview]
- Description of how to set up fast reactor cross section generation workflow in Griffin, found in [#sec:xsgen_input_description]
- Description of how to set up fast reactor full-core eigenvalue calculation in Griffin, found in [#sec:fullcorecalc_input_description]

Some familiarity with setting up a basic Griffin input file is assumed.

## Overview of Cross Section Generation Methodology id=sec:xsgen_overview

The cross section generation workflow comprises of several sequential steps. This section summarizes the overall workflow employed by Griffin and MC$^2$-3 to generate the multigroup cross section set that will be used by the downstream full-core Griffin calculation. All of the steps described here are controlled through a unified Griffin input file, where the Griffin executable will spawn additional calls to run MC$^2$-3 wherever relevant. It should be noted that MC$^2$-3 is installed together with Griffin, and users should not have to concern themselves with MC$^2$-3 installation if they have access to a Griffin executable.

!media plots/xsgen_workflow.png
       style=width:80%
       id=fig:xsgen_workflow
       caption=Diagram of workflow outlining the different steps that are taken as part of the cross section generation workflow using Griffin and MC$^2$-3.

[fig:xsgen_workflow] shows a schematic of the inputs and outputs related to the cross section generation workflow, as well as a blueprint for all of the steps taken as part of the cross section generation procedure. For the purposes of this tutorial, it is assumed that fast reactor cross sections are generated using a 2-step method in MC$^2$-3 with an intermediate R-Z flux calculation, as this method has been shown to generate the most accurate cross section datasets for use with downstream full-core eigenvalue calculations [!citep](pyarc_report).

Griffin requires three pieces of information as inputs to the cross section generation workflow :

- the input heterogeneous geometry, defined using the [!ac](RGMB) mesh generators
- all parameters related to the execution of 2-step MC$^2$-3 cross section generation
- all parameters related to the intermediate Griffin R-Z flux calculation.

[!ac](RGMB) mesh generators provide a simplified pathway for defining pin, assembly, and core geometries that follow structured lattice patterns. Moreover, these mesh generators also define region ID mappings directly on the mesh. Through these specifications, Griffin is able to automatically determine unique subassembly regions based on geometrical and region ID based differences, and this information can then inform how to automatically generate downstream R-Z and assembly-homogenized meshes used as part of Griffin calculations, as well as provide information about how to setup the MCC-3 calculations that are needed. More information about how to perform mesh generation through RGMB will be provided in [#subsec:rgmb_meshgen]. In addition to the input mesh, the rest of the input file describes the control parameters for the Griffin and MC$^2$-3 calculations that comprise the cross section generation workflow, where a special `[MCC3CrossSection]` block is used to define parameters specific to this workflow. As output to this cross section generation, a 33-group cross section library is generated for each unique subassembly region in ISOXML format, which can be directly read by Griffin to run subsequent full-core analysis.

As shown in [fig:xsgen_workflow], the cross section generation workflow comprises of three steps. In the first step, pre-processed pointwise isotopic cross sections are condensed to a [!ac](UFG) structure for each subassembly type by solving the slowing down problem for a homogeneous mixture based on the composition of the subassembly under consideration. In this particular tutorial problem, the [!ac](UFG) structure follows the ANL1041 group structure. It should also be noted that a unique subassembly region is defined as a combination of assembly location and axial location that possesses a unique geometry and assignment of region IDs within the subassembly region. Going forward, this MCC-3 calculation will be referred to as the "Step 1 MC$^2$-3 Calculation".

From the [!ac](UFG) cross section set for each subassembly region, a whole-core transport calculation is performed in a cylindrical-Z (R-Z) geometry to calculate the full-core [!ac](UFG) flux distribution to account for spectral effects between subassembly regions. The R-Z geometry is automatically created by preserving the total volume of like hexagonal assemblies that are grouped together within the assembly lattice. This spectrum calculation is done in Griffin using the DFEM-SN solver, and is referred to as the "Griffin R-Z Spectrum Calculation". The flux spectrum is then passed back to MC$^2$-3 in the final step of the cross section generation workflow, where the [!ac](UFG) cross sections are condensed to a Broad Group (BG) cross section set for each unique subassembly region, referred here onwards as the "Step 2 MC$^2$-3 Calculation". In this example, the BG structure will follow the ANL33 group structure, and for each subassembly region that contains fuel or strong neutron absorbers, the cross section condensation step can optionally involve a 1-D collision probability method (CPM) calculation to account for local heterogeneity effects within the subassembly region. The 33-group BG cross section data library will be outputted as a single ISOXML file.

The cross section generation workflow has been implemented in such a way that many of the input file generation steps, data transfers, and generation of input meshes and problem boundaries related to how Griffin and MCC-3 operate have been automated. It should also be noted that all intermediate meshes and composition mappings are also automatically inferred from the input heterogeneous mesh, which directly contains all region ID and mesh specifications for each pin, assembly, and core region. Users who require more background on this cross section generation workflow are referred to [!citep](MCC3manual) and [!citep](lee2023improved). The following section details how to define the heterogeneous input mesh through the use of RGMB mesh generators, as well as how to set the control parameters within the Griffin input file to dictate how MCC-3 and Griffin are executed within the three steps that comprise the cross section generation workflow.

## Input File Description for Cross Section Generation Workflow id=sec:xsgen_input_description

This section focuses on the input files needed to run the cross section generation worfklow. For this tutorial, this step is comprised of three input files: `abtr_het_mesh.i` defines the heterogeneous mesh through [!ac](RGMB) mesh generators, `xs_generation_mesh.i` takes this heterogeneous mesh as input and generates the equivalent R-Z mesh that will be used as part of the Griffin R-Z spectrum calculation, while `xs_generation.i` defines all control parameters related to the cross section generation workflow. Using the `!include <FILENAME>.i` command in the input file, `xs_generation.i` directly imports the contents of `xs_generation_mesh.i`, which also uses this command to directly import the contents of `abtr_het_mesh.i`. This makes it so that only the file `xs_generation.i` needs to be called from the command line in order to expand the contents of all three input files and run the entire cross section generation workflow. The commands to run the cross section generation workflow from start to finish are shown below:

```
# Generate equivalent R-Z spectrum mesh and run XS generation workflow through Griffin
mpirun -np <N_PROC_TOTAL> /path/to/griffin/griffin-opt -i xs_generation.i
```

, where `<N_PROC_TOTAL>` refers to the total number of MPI processes available for the simulation. `abtr_het_mesh.i` and `xs_generation_mesh.i` generate an output 2-D R-Z mesh from an input mesh that represents the geometry and material ID assignment for the 3-D heterogeneous [!ac](ABTR) core. `xs_generation.i` contains all of the information related to the cross section generation worklow. [#subsec:rgmb_meshgen] and [#subsec:rz_eqv_core] describe sections of `abtr_het_mesh.i` and `xs_generation_mesh.i` in more detail, respectively, while [#subsec:mcc3_params] and [#subsec:griffin_rz_params] describe the specifics of `xs_generation.i`.

### Heterogeneous input mesh generation through [!ac](RGMB) mesh generators id=subsec:rgmb_meshgen

The [ReactorMeshParams](https://mooseframework.inl.gov/source/meshgenerators/ReactorMeshParams.html), [PinMeshGenerator](https://mooseframework.inl.gov/source/meshgenerators/ReactorMeshParams.html), [AssemblyMeshGenerator](https://mooseframework.inl.gov/source/meshgenerators/AssemblyMeshGenerator.html), and [CoreMeshGenerator](https://mooseframework.inl.gov/source/meshgenerators/CoreMeshGenerator.html) in `abtr_het_mesh.i` make use of the [!ac](RGMB) mesh generation system within the Reactor module to streamline the definition of latticed core geometries and the reporting IDs associated with such structures [!citep](shemon2023reactor). Mesh generation through [!ac](RGMB) is a requirement for taking advantage of Griffin's [!ac](SFR) cross section generation workflow, as it ensures that all reporting IDs related to region ID mappings as well as IDs corresponding to groupings of pin structures, assembly structures, and axial layers are defined in a consistent and predictable manner.

At the top of the `abtr_het_mesh.i` file, all global variables related to the mesh geometry as well as the region/material IDs are defined as global constants to be used within the `[Mesh]` block. For the purposes of this workflow, the region/material IDs defined in this section can be understood as unique material zones on the heterogeneous mesh that each have their own mappings of isotopic compositions. Thus, for this problem there are 12 unique material types within the heterogeneous core specifications.

!listing sfr/abtr_xsgen_workflow/abtr_het_mesh.i start=fuel_pin_pitch end=mid_control_empty include-end=True

Within the `[Mesh]` block, the `ReactorMeshParams` object defines the global parameters related to the heterogeneous mesh. This includes:

- Number of dimensions of the output mesh, controlled by `ReactorMeshParams/dim`
- Geometry type of the output mesh (Hexagonal or Cartesian), controlled by `ReactorMeshParams/geom`
- Assembly pitch, controlled by `ReactorMeshParams/assembly_pitch`
- Assembly layer thicknesses and number of subintervals per axial layer, controlled by `ReactorMeshParams/axial_regions` and `ReactorMeshParams/axial_mesh_intervals`, respectively
- Boundary IDs assigned to the top, bottom, and radial sidesets of the outer boundary of the reactor core, controlled by `ReactorMeshParams/top_boundary_id`, `ReactorMeshParams/bottom_boundary_id` and `ReactorMeshParams/radial_boundary_id`, respectively.

The axial discretization used by the heterogeneous mesh, controlled by `ReactorMeshParams/axial_regions` and `ReactorMeshParams/axial_mesh_intervals`, will also be used as is to define the axial discretization of the equivalent homogenized, partially homogenized, or 2-D R-Z that is outputted by the `[Mesh]` block.

!listing sfr/abtr_xsgen_workflow/abtr_het_mesh.i start=Define global reactor mesh parameters end=Define constituent pins include-end=False

Pin structures are defined by calling `PinMeshGenerator`, and four different pin types are created, three of them used to create three fuel assembly types of varying fuel compositions, and one to define the control rod assembly. Each of these pin definitions have a unique values for `PinMeshGenerator/pin_type` to indicate uniqueness of pin types to the [!ac](RGMB) workflow.

!listing sfr/abtr_xsgen_workflow/abtr_het_mesh.i start=Define constituent pins of fuel assemblies end=Define fuel assemblies include-end=False

Pins are defined as a collection of ring radii surrounded by a background region and an optional duct region. The following parameters control the geometrical aspects of the pin structure:

- `pitch`: pitch of pin structure
- `num_sectors`: number of azimuthal sectors for each side of the hexagonal pin
- `ring_radii`: location of radii used to define circular pin section of mesh
- `mesh_intervals`: Number of subintervals to discretize the pin structure, where the values correspond to the innermost to outermost ring regions, the background region, and finally the innermost to outermost duct regions.

The `region_ids` parameter is used to set the region ID reporting IDs for the pin structure, where the horizontal axis from left to right represents the region IDs of the innermost to outermost radial ring regions, followed by the background region, and the vertical axis from top to bottom represents the region IDs of the four axial layers in the problem, from bottom to top. These region ID mappings are iterated on for each combination of axial and radial assembly location to determine which subassembly regions have unique material zone mappings on the heterogeneous mesh.

These four pin types are then stitched into assembly structures by calling `AssemblyMeshGenerator`. Here, three different fuel assembly types and one control assembly type are created, each of which has a different value for `AssemblyMeshGenerator/assembly_type` to indicate uniqueness of assembly types to the [!ac](RGMB) workflow. `AssemblyMeshGenerator/background_intervals` and `AssemblyMeshGenerator/duct_intervals` control how many subdiscretizations should be applied for each background and duct region, respectively, and `AssemblyMeshGenerator/duct_halfpitch` defines the halfpitch of each duct region.

!listing sfr/abtr_xsgen_workflow/abtr_het_mesh.i start=Define fuel assemblies end=Define homogenized reflector and shielding assemblies include-end=False

Similar to `PinMeshGenerator/region_ids`, `AssemblyMeshGenerator/background_region_id` and `AssemblyMeshGenerator/duct_region_ids` set the region IDs of the background and duct regions, respectively, where the horizontal axis represents the radial region IDs (from innermost to outermost), and the vertical axis represents the axial region IDs (from bottom to top). [fig:assembly_region_ids] shows how the 3-D region IDs are represented for `Mesh/fuel_assembly_1` and `Mesh/control_assembly`.

!media plots/assembly_region_ids.png
       style=width:25%
       id=fig:assembly_region_ids
       caption=3D region ID distribution of `Mesh/fuel_assembly_1` (left) and `Mesh/control_assembly` (right)

In order to define homogenized assembly regions, `PinMeshGenerator` is called with `PinMeshGenerator/use_as_assembly` set to true. This is done so that the resulting mesh, which acts as an assembly mesh but does not have any constituent pin structures, can be stitched into `CoreMeshGenerator` in the next step. In this problem, this is done for the reflector and shielding regions, which are represented using a single region ID throughout the entire axial and radial extent.

!listing sfr/abtr_xsgen_workflow/xs_generation_mesh.i start=Define homogenized reflector and shielding assemblies end=Define heterogeneous core include-end=False

The resulting assembly structure definitions can then be stitched together to define the heterogeneous core mesh. Here, a dummy assembly mesh does not have to be explicitly defined, and can be specified in `CoreMeshGenerator/inputs` by providing a dummy assembly name in `CoreMeshGenerator/dummy_assembly_name`. [fig:hetcore_region_ids] shows the resulting region ID distribution for the 3-D heterogeneous reactor core mesh.

!listing sfr/abtr_xsgen_workflow/abtr_het_mesh.i start=Define heterogeneous core end=Define equivalent RZ core from input heterogeneous RGMB core include-end=False

!media plots/hetcore_region_ids.png
       style=width:60%
       id=fig:hetcore_region_ids
       caption=3D region ID distribution of heterogeneous core created through [!ac](RGMB) mesh generators.

### Definition of equivalent R-Z core through `EquivalentCoreMeshGenerator` id=subsec:rz_eqv_core

Through the definition of the heterogeneous core input mesh using [!ac](RGMB) mesh generators, a Griffin-specific mesh generator called `EquivalentCoreMeshGenerator` is called to enable all downstream calculations used as part of the cross section generation workflow.

!listing sfr/abtr_xsgen_workflow/xs_generation_mesh.i start=Define equivalent RZ core from input heterogeneous RGMB core end=Define and apply a coarse RZ mesh include-end=False

In this step, `EquivalentCoreMeshGenerator` accomplishes two tasks:

1. Generation of equivalent R-Z mesh for use with downstream Griffin R-Z spectrum calculation
2. Definition of all metadata related to setting up downstream MC$^2$-3 calculations.

Related to the first point, `EquivalentCoreMeshGenerator/input` takes a heterogeneous input core mesh defined through the use of `CoreMeshGenerator`, and creates an equivalent homogenized, partially homogenized, or 2-D R-Z mesh without the need for a user to generate this intermediate mesh from scratch. Since the downstream Griffin calculation in the cross section generation workflow requires a 2-D R-Z mesh, `EquivalentCoreMeshGenerator/target_geometry` is set to `rz`. However, at the full-core analysis step described in [#sec:fullcorecalc_input_description], a fully homogeneous input mesh needs to be generated from the input heterogeneous mesh instead, so this is done by following the same mesh generation workflow and setting `EquivalentCoreMeshGenerator/target_geometry` to `full_hom`. Other options for this parameter include `ring_het` and `duct_het` for ring-heterogeneous and duct heterogeneous intermediate output meshes, respectively.

Most of the remaining parameters in the `[rz_core]` control how the 2-D R-Z mesh should be discretized, where `max_radial_mesh_size` controls the maximum radial mesh size to subdivide the radial boundaries of the 2-D R-Z mesh. By default, `EquivalentCoreMeshGenerator` automatically infers the R-Z mesh boundaries by collapsing the input core lattice pattern by each hexagonal ring and grouping like assembly types. However, the R-Z mesh radial boundary and region assignments can also be specified manually by setting `EquivalentCoreMeshGenerator/radial_boundaries` and `EquivalentCoreMeshGenerator/radial_assembly_names`, respectively, where the names in `EquivalentCoreMeshGenerator/radial_assembly_names` correspond to the assembly names defined in `CoreMeshGenerator/inputs` to place the homogenized region IDs in each radial and axial region of the 2-D R-Z mesh. The manual approach is taken in this example, where the radial boundary and region assignments are based on prior studies done for the [!ac](ABTR) core [!citep](pyarc_report). The axial discretization used in the 2-D R-Z mesh uses the same discretization as the input heterogeneous mesh, which is controlled by the parameters `ReactorMeshParams/axial_regions` and `ReactorMeshParams/axial_mesh_intervals`.

!media plots/eqv_rzcore.png
       style=width:60%
       id=fig:eqv_rzcore
       caption=Generation of 2-D R-Z core mesh (right) from heterogeneous core created through [!ac](RGMB) mesh generators (left).

[fig:eqv_rzcore] shows how the input heterogeneous mesh is converted to an equivalent 2-D R-Z mesh. This is done by iterating through each assembly type defined within the core, and determining which combinations of (assembly type, axial layer) are unique, where uniqueness is based on the heterogeneous mesh geometry of subassembly region AND the distribution of heterogeneous region IDs within the subassembly region. In order to illustrate this point, notice how the homogenized fuel subassemblies corresponding to `[fuel_assembly_1]`, `[fuel_assembly_2]`, `[fuel_assembly_3]` in the 2-D R-Z mesh have different IDs associated with the second axial layer from the bottom. Despite the heterogeneous geometry of these three subassembly regions being identical from a mesh discretization standpoint, `EquivalentCoreMeshGenerator` designates these homogenized regions as being unique due to the fact that the region IDs in the heterogeneous fuel pin regions of these subassemblies are not identical. [tab:subassembly_id_mapping] describes the mapping of each combination of assembly name and axial layer to the homogenized subassembly ID (defined in increments of 100).

!table id=tab:subassembly_id_mapping caption=Mapping of assembly name and axial ID to subassembly ID
| Heterogeneous assembly name | Axial ID (1 = bottommost layer, 4 = topmost layer)  | Subassembly region ID  |
| :- | :- | :- |
| fuel_assembly_1    | 1 | 100   |
|                    | 2 | 200   |
|                    | 3 | 300   |
|                    | 4 | 400   |
| fuel_assembly_2    | 1 | 100   |
|                    | 2 | 500   |
|                    | 3 | 300   |
|                    | 4 | 400   |
| fuel_assembly_3    | 1 | 100   |
|                    | 2 | 600   |
|                    | 3 | 300   |
|                    | 4 | 400   |
| control_assembly   | 1 | 700   |
|                    | 2 | 700   |
|                    | 3 | 800   |
|                    | 4 | 800   |
| reflector_assembly | 1 | 900   |
|                    | 2 | 900   |
|                    | 3 | 900   |
|                    | 4 | 900   |
| shielding_assembly | 1 | 1000  |
|                    | 2 | 1000  |
|                    | 3 | 1000  |
|                    | 4 | 1000  |

The mapping shown in [tab:subassembly_id_mapping] is computed by `EquivalentCoreMeshGenerator` and stored as metadata on the mesh. This metadata is what is primarily used to set up the MCC-3 execution and MCC-3 input file generation, which all happens under the hood. For example, each subassembly region ID shown in the third column of [tab:subassembly_id_mapping] represents a separate subassembly region for which MC$^2$-3 needs to be executed. The following metadata is also defined by `EquivalentCoreMeshGenerator`, which is used by downstream MC$^2$-3 calculations:

- Homogenized volume fractions: For each subassembly ID shown in [tab:subassembly_id_mapping], a list of volume fractions for each heterogeneous region ID found within the subassembly is stored. This is used in the Step 1 MC$^2$-3 calculation step to set the compositions of the homogenized mixture calculation for each subassembly region.
- 1-D radial boundaries: For each subassembly ID shown in [tab:subassembly_id_mapping], the heterogeneous subassembly geometry and region ID layout is represented as a series of volume-preserved concentric rings, and this 1-D ring representation is used by the Step 2 MC$^2$-3 calculation to setup the 1-D CPM calculations wherever needed.

For a more comprehensive list of metadata stored by `EquivalentCoreMeshGenerator`, the console output from setting `EquivalentCoreMeshGenerator/debug_equivalent_core = true` can be inspected. As a final step for mesh generation, an explicity defined coarse mesh is defined for the output R-Z mesh in order to use with [!ac](CMFD) acceleration as part of the downstream Griffin R-Z spectrum calculation step, and setting `Mesh/coord_type = RZ` specifies that an RZ coordinate system should be used with the 2D mesh.

!listing sfr/abtr_xsgen_workflow/xs_generation_mesh.i start=Define and apply a coarse RZ mesh end=data_driven_generator include-end=True

Finally, `Mesh/data_driven_generator` indicates to the mesh generator system that it should define the input heterogeneous mesh specifications through metadata defined by [!ac](RGMB), instead of building a physical heterogeneous input mesh. The value of this parameter should point to the name of the `EquivalentCoreMeshGenerator` instance. The data-driven model is an optimization that Griffin requires to speed up mesh generation workflows that invoke `EquivalentCoreMeshGenerator`.

### Input Parameters Specific to MC$^2$-3 Execution and Overall Cross Section Generation Workflow id=subsec:mcc3_params

As explained in [#subsec:rgmb_meshgen] and [#subsec:rz_eqv_core], the combination of `abtr_het_mesh.i` and `xs_generation_mesh.i` defines the `[Mesh]` block that generates a 2-D R-Z mesh from a fully-heterogeneous core geometry definition. However, since the output mesh does not contain any information about the isotopic compositions related to each region ID defined on the input mesh, the `[Compositions]` block in `xs_generation.i` is used to map the region IDs defined in `xs_generation_mesh.i` to physical isotopic compositions within each heterogeneous region:

!listing sfr/abtr_xsgen_workflow/xs_generation.i block=Compositions

`IsotopeComposition` is used to map compositions of individual isotopes and their atomic densities to a specific region, while `MixedComposition` is used to define compositions as volume fractions of existing `IsotopeComposition` instances. Compositions listed in the `[Compositions]` block are mapped to a region ID defined on the heterogeneous mesh through the parameter `IsotopeComposition/composition_ids` or `MixedComposition/composition_ids`.

`xs_generation.i` also defines the control logic related to the cross section generation workflow calculations in Griffin and MC$^2$-3 that are set by the user. This file resembles a typical Griffin input file except for a key difference, which is the `[MCC3CrossSection]` block. This input block controls aspects specific to the cross section generation workflow, and will be explained in more detail in this section.

!listing sfr/abtr_xsgen_workflow/xs_generation.i block=MCC3CrossSection

`MCC3CrossSection/remove_pwfiles`, `MCC3CrossSection/remove_inputs`, `MCC3CrossSection/remove_outputs`, and `MCC3CrossSection/remove_xmlfiles` control whether intermediate files generated by MCC-3 execution are removed after the simulation. `MCC3CrossSection/griffin_data` points to the location of where the griffin_data repository (a submodule of the Griffin repository) can be found, while `MCC3CrossSection/endfb_version` points to the ENDF/B library version that should be used for input cross section data. `MCC3CrossSection/library_pointwise` refers to a directory that has pre-generated pointwise data for use with Step 1 MCC-3 calculations. If this directory does not exist, this data library will be automatically generated as part of the cross section generation workflow execution.

`MCC3CrossSection/xml_macro_cross_section` controls whether the output cross section library should generate macroscopic multigroup cross sections (true) or microscopic multigroup cross sections (false), `MCC3CrossSection/xml_filename` controls the filename of the output xml cross section data library, and `MCC3CrossSection/generate_core_input` controls whether a Griffin input file should be automatically generated for running a full-core eigenvalue calculation. By setting this value to true, the input file that will be run in [#sec:fullcorecalc_input_description] will be generated during the execution of the cross section workflow.

Additionaly, setting `MCC3CrossSection/rz_calculation` to true indicates that an intermediate Griffin flux RZ calculation should be conducted as part of the cross section generation workflow. `MCC3CrossSection/rz_spectrum_pn_order` sets the maximum $P_N$ flux moment order of the RZ flux spectrum, `MCC3CrossSection/rz_group_structure` sets the group structure of the intermediate flux spectrum calculation, while `MCC3CrossSection/group_structure` sets the final group structure of the output cross section library after running the Step 2 MC$^2$-3 calculation.

`MCC3CrossSection/map_het_grid_name`, `MCC3CrossSection/map_het_grid_ref_value`, and `MCC3CrossSection/map_het_grid_values` control how cross sections are tabulated as a function of tabulation variables such as temperature. `MCC3CrossSection/map_het_grid_name` maps each composition defined in the `[Compositions]` block that has an associated region ID to an associated grid variable. For the purposes of this tutorial, each heterogeneous region has a single temperature variable it is tabulated against, where `Tfuel` represents the fuel temperature, and `Tcool` represents the coolant temperature. `MCC3CrossSection/map_het_grid_ref_value` sets the reference value for each grid variable of interest, while `MCC3CrossSection/map_het_grid_values` defines all tabulated values that are assocaited with each grid variable.

Finally, `MCC3CrossSection/target_core` sets what type of core mesh will be generated for the full-core analysis step (fully homogeneous, duct heterogeneous, or ring heterogeneous), and this informs how many cross section regions should be computed for the output cross section dataset for each subassembly region. In this case, the full-core analysis step will be conducted on a fully homogeneous target core, so a single cross section material zone will be defined for each subassembly region, as opposed to multiple material zones per subassembly region for duct heterogeneous and ring heterogeneous target cores. `MCC3CrossSection/het_cross_sections` defines heterogeneous compositions that should be solved in the Step 2 MC$^2$-3 calculation step using the 1D CPM method to capture local spatial self-shielding effects, while `MCC3CrossSection/max_het_mesh_size` controls the maximum sub-discretization that should be used for each ring region within 1D CPM calculations.

In order to provide more detail about how Step 1 MC$^2$-3 input files are created, the metadata extracted from the mesh generator listed in `MCC3CrossSection/rz_meshgenerator` defines all unique subassembly regions within the reactor core. For each unique subassembly region, the homogenized mixture composition is then inferred using the volume fractions for each heterogeneous region IDs found in the subassembly (also computed as metadata), as well as the isotopic compositions for each of these region IDs. This mixture composition is written as part of the MC$^2$-3 input file before being executed by MC$^2$-3 and processed for use with the downstream Griffin R-Z flux spectrum calculation.

For Step 2 MC$^2$-3 input file generation, the same subassembly regions are considered as part of the BG cross section condensation step, with the primary difference being that some of these subassembly regions undergo a 1D CPM calculation step to incorporate local spatial self-shielding effects into the condensed cross sections. Only subassembly regions that contain region IDs associated with any of the compositions listed in `MCCCrossSection/het_cross_sections` will undergo this 1D CPM calculation step. Otherwise the condensation occurs assuming a homogenized mixture composition. Based on the data presented in [tab:subassembly_id_mapping], subassemblies with IDs 200, 500, 600, and 800 will undergo 1D CPM calculations, as these are the fuel and control subassemblies that contain the compositions specified by `MCCCrossSection/het_cross_sections`. The problem parameters for each of these 1D CPM calculations are based on the specifications of the ring boundaries and isotopic compositions for each ring region in the MC$^2$-3 input file. This is automatically inferred through the 1D ring model that is defined by `EquivalentCoreMeshGenerator` and stored as metadata. For example, for the fuel subassembly region with ID 200 (assembly named `[fuel_assembly_1]` in mesh input file at second-to-the-bottom axial layer) that undergoes the 1D CPM calculation step, [fig:1d_cpm_geometry] shows the equivalent 1D ring geometry that MC$^2$-3 uses to run the 1D CPM calculation. Since 1D CPM calculations require a fission source to run, for heterogeneous regions such as control subassemblies that do not have any fuel material, the 1D CPM calculation will arbitrarily add a fuel region surrounding the 1D geometry, based on the homogenized composition of one of the fuel subassembly regions in the reactor core.

!media plots/1d_cpm_geometry.png
       style=width:60%
       id=fig:1d_cpm_geometry
       caption=2-D region ID layout of fuel subassembly region (left), and associated 1-D ring geometry that is solved in Step 2 MC$^2$-3 calculation step (right).

### Input Parameters Specific to Intermediate Griffin R-Z flux calculation id=subsec:griffin_rz_params

Outside of the `[Compositions]` and `[MCC3CrossSection]` blocks, the rest of the `xs_generation.i` input file specifies control parameters for the intermediate R-Z flux spectrum calculation that is calculated in Griffin. The associated mesh that is defined in the `[Mesh]` block is the R-Z mesh that will be used to solve for the [!ac](UFG) flux spectrum, and the `[TransportSystems]` block sets up the eigenvalue transport problem that will be solved with the DFEM-SN solver, while the `[Executioner]` block defines the problem convergence tolerances and parameters specific to [!ac](CMFD) acceleration.

!listing sfr/abtr_xsgen_workflow/xs_generation.i start=[TransportSystems] end=[Outputs] include-end=False

Here, `TransportSystems/G` must match the number of groups defined in `MCC3CrossSection/rz_group_structure`, and `TransportSystems/VacuumBoundary` and `TransportSystems/ReflectingBoundary` set the boundary conditions to be used in the 2-D R-Z problem. The resulting flux distribution that is solved for by Griffin is automatically passed to MC$^2$-3 to run the MC$^2$-3 step 2 calculations for each subassembly region.

## Input File Description for Full-Core Eigenvalue Calculation id=sec:fullcorecalc_input_description

By running Griffin on the `xs_generation.i` file, two files are created that are used for the full-core eigenvalue calculation step that will be explained in this section. The first is the BG cross section library, named `mcc3xs.xml` (this name is controlled by `MCCCrossSection/xml_filename`), and the second is the Griffin input file that will be used for this section, named `core_hom_macro.i` (this is a fixed name, based on whether assembly homogenized cross sections are calculated, and whether microscopic or macroscopic cross sections are used in the output cross section library). The automatic generation of this input file streamlines the setup of the full-core analysis step, and the contents of this file are shown below:

!listing sfr/abtr_xsgen_workflow/core_hom_macro.i

Users are encouraged to look through this input file in detail and update input parameters accordingly based on their modeling needs. At a minimum however, a mesh file related to the heterogeneous reactor core needs to be defined with a name that matches `Mesh/eqv_core/input`, and boundary conditions for the full-core eigenvalue problem need to be defined by setting the appropriate outer boundary sidesets using `TransportSystems/VacuumBoundary` and `TransportSystems/ReflectingBoundary`. By looking at this file, it can be seen that the mapping between mesh blocks and cross section material ID is automatically done by calling `MixedMatIDNeutronicsMaterial` in the `[Materials]` block, and this assumes that the homogeneous input reactor core mesh has been generated with `EquivalentCoreMeshGenerator`.

In its current form, the `[Mesh]` block in `core_hom_macro.i` is incomplete and needs the heterogeneous reactor specifications to be defined as input to `[eqv_core]`. Since the heterogeneous input mesh was already defined in the cross section generation step, `abtr_het_mesh.i` can be used directly for this purpose in the full-core calculation step as well. The `[Mesh]` block in `core_hom_macro.i` follows very similar steps as the ones explained in `xs_generation_mesh.i`, `EquivalentCoreMeshGenerator` is responsible for generating the homogeneous mesh from the input heterogeneous mesh specifications.

In `core_hom_macro.i`, `EquivalentCoreMeshGenerator/target_geometry` is set to `full_hom` to specify a full-homogeneous reactor mesh as the output mesh. Additionally, `EquivalentCoreMeshGenerator/quad_center_elements` can be set to dictate whether the homogeneized hexagonal prism regions are discretized into 2 quadrilaterial prism regions (true) or 6 triangular prism regions (false).

!media plots/eqv_fullhomcore.png
       style=width:80%
       id=fig:eqv_fullhomcore
       caption=Generation of 3-D fully homogeneous core mesh (right) from 3-D heterogeneous core created through [!ac](RGMB) mesh generators (left).

While `core_hom_macro.i` does not define a coarse mesh for the output mesh, this can be done manually by adding the following lines to the end of the `[Mesh]` block in `core_hom_macro.i`:

```
[Mesh]
  [coarse_mesh]
    type = CoarseMeshExtraElementIDGenerator
    input = block_numbering
    coarse_mesh = block_numbering
    extra_element_id_name = coarse_element_id
  []
[]
```

Here, the coarse mesh is defined to be identical to the fine mesh, which in this case is the assembly-homogeneous mesh created by `EquivalentCoreMeshGenerator`. Thus, the full-core eigenvalue calculation can be run by running the following commands:

```
# Run full-core eigenvalue calculation and override default parameters defined in core_hom_macro.i
mpirun -np <N_PROC_TOTAL> /path/to/griffin/griffin-opt -i abtr_het_mesh.i core_hom_macro.i
    Mesh/eqv_core/quad_center_elements=true max_axial_mesh_size=10 Mesh/uniform_refine=1
    TransportSystems/ReflectingBoundary='' TransportSystems/VacuumBoundary='outer_core top bottom'
    TransportSystems/dfem_sn/NAzmthl=4 TransportSystems/dfem_sn/NPolar=3
    Executioner/coarse_element_id=coarse_element_id Executioner/cmfd_eigen_solver_type=krylovshur
    PowerDensity/power=250000000 PowerDensity/power_density_variable=power --distributed-mesh
```

The command line options specify the following:

 - mesh refinement should be applied
 - `EquivalentCoreMeshGenerator` settings are updated through the `[Mesh]` block
 - the boundary conditions sidesets are set
 - DFEM-SN angular discretizations are updated to increase solution accuracy through the `[TransportSystems]` block
 - CMFD settings are updated through the `[Executioner]` block
 - the reactor power is set through the `[PowerDensity]` block.

These parameter settings ensure that calculated eigenvalues are predicted to within 100pcm of previous modeling work for the [!ac](ABTR) reactor core [!citep](pyarc_report).
