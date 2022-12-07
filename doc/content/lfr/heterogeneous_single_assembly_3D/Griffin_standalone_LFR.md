# High Fidelity Neutronics Model for Lead-cooled Fast Reactor (LFR)

*Contact: Hansol Park, hansol.park@anl.gov*

This VTB model provides a high fidelity neutronics model for a representative example of a lead-cooled fast reactor with an annular MOX (UPuO) fuel. Its design is based on an early iteration of an LFR-prototype assembly provided by Westinghouse Electric Company, LLC [!citep](WECLFR). The original purpose of this model is to characterize the impact of various sources of uncertainties, such as theoretical and experimental uncertainties, instrumentation uncertainties, manufacturing tolerances, correlation uncertainties, and the method and simulation uncertainties, on peak cladding, fuel and coolant temperatures in the system. For this purpose, high fidelity neutronics (fine mesh heterogeneous transport - Griffin) and thermalhydraulics (computational fluid dynamics - NekRS) calculations were performed to compute hot channel factors (HCFs) [!citep](HCFReport). A 3D heterogeneous single assembly steady-state problem was used since a full core model is seldom used for the HCF evaluation. In this VTB model, only the neutronics standlone model is explained. 

First, the LFR model is described, followed by the cross section generation procedure using MC2-3 [!citep](MCC3manual). Then, the Griffin standalone calculation setting with the discontinuous fininte element method (`DFEM`) discrete ordinate (`SN`) scheme with the Coarse Mesh Finite Difference (`CMFD`) acceleration is explained and the results are discussed.

## Description of LFR design

The key parameters of the LFR design are listed in [lfrkeyparam]. The power output is 950 MWth (~450 MWe) for the whole core and the nominal power of an inner core fuel assembly is 3.7 MWth. The fuel assembly pitch is 16.3 cm with a 4 mm lead-filled gap between assemblies and 3.5 cm thick duct wall as shown on the right in [lfrgeom]. Each assembly contains 127 cladded fuel pins arranged in a triangular lattice with pitch 1.33 cm within a hexagonal wrapper (duct). Each fuel pin has a cold fuel inner/outer diameter of 4.00/8.55 mm respectively, a fuel-cladding gap of 0.175 mm and a cladding outer diameter of 10.7 mm with a cladding thickness of 0.90 mm, depicted in [annularfuel]. The center hole and gap are filled with helium. To minimize the flow speed and consequently mitigate corrosion issues, a relatively wide lattice (P/D=1.24) design is adopted. Grid spacers are planned to maintain pin spacing, rather than the wire wrap used in conventional SFR designs.

The active fuel region in the middle is located between upper and lower thermal insulators, gas plenum, bundle grid and pins plug, and inlet and outlet wrappers. Bundle grid and pins plug, inlet and outlet wrappers, and lower core plate are radially homogenized while radially heterogeneous fine-meshes were used in the other five axial regions. The annular fuel shape in [annularfuel] is explicitly modeled for the active fuel region and materials inside the cladding are radially homogenized for the four axial regions of thermal insulators and gas plenum.

!table id=lfrkeyparam caption=Key parameters of Lead-Cooled Fast Reactor (LFR) model
| Parameter | Value  | Unit  |
| :- | :- | :- |
| Thermal power | $950$ | $MW$  |
| Active core height | $105$  | $cm$ |
| Number of fuel pins per assembly | $127$ | $-$ |
| Gap thickness | $0.175$ | $mm$ |
| Duct thickness | $3.5$ | $mm$ |
| Fuel pin diameter | $10.7$ | $mm$ |
| Fuel pin pitch | $13.3$ | $mm$ |
| P/D | $1.24$ | $-$ |
| Cladding thickness | $0.9$ | $mm$ |
| Fuel pellet outer diameter | $8.55$ | $mm$ |
| Fuel pellet inner diameter | $4.0$ | $mm$ |
| Reynolds number | $51,000$ | $-$ |
| Prandtl number | $0.0136$ | $-$ |
| Peclet number | $705.21$ | $-$ |

!media lfr/LFRgeometry.jpg
       style=width:80%
       id=lfrgeom
       caption=Axial and radial geometry of the LFR single assembly model

!media lfr/annularfuel.png
       style=width:30%
       id=annularfuel
       caption=LFR annular fuel pin geometry

## Cross Section Generation using MC2-3

It is worth explaining the procedure to generate cross sections using MC2-3 for this model. MC2-3 is the cross section generation module in Griffin. The axial leakage effect needs to be considered using the MC2-3/TWODANT two-step procedure for the generation of both homogeneous cross sections for non-fuel axial regions and heterogeneous region-wise cross sections for the fuel axial region. At this point of time, the MC2-3/TWODANT procedure is not fully available in Griffin due to a licensing issue with TWODANT. Thus, MC2-3 was used externally, not via Griffin, in this work. Once the feature is available in Griffin, the description below will be updated.

### First step id=xs1st

The first step is to generate a 1041-group `rzmflx`, which is the flux solution file of a TWODANT [!citep](TWODANT) SN calculation. It contains zone-wise Legendre moments of the angular flux solution up to a specified order. In this problem, a pseudo one-dimensional (1D) slab problem is solved using TWODANT by assigning the reflective boundary condition on the left and right boundaries in the x-y geometry. TWODANT is called inside MC2-3 when its executable path is specified by the `c_twodantexe` input parameter in the `library` block of an MC2-3 input with `l_twodant=T`. If TWODANT is not available, PARTISN [!citep](PARTISN) can be used alternatively since it creates a `rzmflx` file. `c_twodant_group=BG` means that the TWODANT transport calculation is performed using a group structure specified in `c_group_structure`. `c_geometry_type=mixture` means that homogeneous materials cooresponding to axial regions are used to generate macroscopic cross sections (in the 1041-group structure in this example) to be used in the TWODANT transport calculation.

!listing lfr/heterogeneous_single_assembly_3D/cross_section/Step1/LFR_InnerFuel_HOM_1041g_TWODANT.mcc3.sh start=&library end=&material include-end=False

Volume-homogenized compositions representing different axial regions are specified in the `material` block. In each composition, a list of isotopes needs to be specified. Each line for an isotope should have four entries: an `MC2-ID` such as `FE54_7`, a user-defined name to be included in the ISOTXS file, for example, `FE54_IG`, an atomic number density (#/cm barn), and a temperature in Kelvin. (In this step, temperature does not need to be very accurate.) The full list of `MC2-ID`s is available in [!citep](MCC3manual). For the user-defined name, `_IG` is, for example, a suffix to indicate the name of the axial zone for the upper thermal insulator and differentiate the same isotope in different regions. In this first step, since the resulting ISOTXS file is only used for the TWODANT calculation, any suffix is allowed as long as the same isotope in different compositions can be differentiated by its name. This is needed because cross sections of all isotopes are contained in a single ISOTXS file where composition IDs are not present. This suffix needs to be set carefully in the second step as explained later.

!listing lfr/heterogeneous_single_assembly_3D/cross_section/Step1/LFR_InnerFuel_HOM_1041g_TWODANT.mcc3.sh start=&material end=/ include-end=True

The `twodant` block is to generate a TWODANT input internally for calling TWODANT. `niso` and `ngroup` are filled by MC2-3, `mt` and `nzone` are the number of materials and coarse meshes, `im` and `jm` are the number of coarse meshes in the x and y directions, `it` and `jt` are the total number of fine meshes in the x and y directions, `igeom=6` means x-y geometry, `isn` is the Sn order, and `maxlcm` and `maxscm` are the maximum memory size (in a unit of word = 2 bytes) of central small core memory and peripheral large core memory. `xmesh` and `ymesh` are x and y coordinates of coarse meshes, `xints` and `yints` are the number of fine meshes in each coarse x and y meshes, and `zones` are composition numbers in the `material` block assigned to each x and y coarse mesh.

Input parameters from `isct` to `rmflux` are solver options. Important ones are `isct`: Legendre order of scattering, `ievt=1`: calculation type=k-eff, `ibl, ibr, ibt, ibb`: boundary conditions for left, right, top and bottom (0/1/2/3=vacuum/reflective/periodic(only for top and bottom)/white), `epsi`: inner iteration convergence precision (default=0.0001), `epso`: outer iteration convergence precision (default=`epsi`), `oitm`: maximum number of outer iterations, `iitm, iitl`: maximum number of inner iterations per group at the first outer iteration and near fission source convergence.

The cross section set for the TWODANT calculation is the ISOTXS output file of the MC2-3 calculation in this first step. MC2-3 fills the `matls` option in the `twodant` block for the native TWODANT input with isotope names and atomic number densities taken from the `material` block. Thus, users do not need to take care of this part.

!listing lfr/heterogeneous_single_assembly_3D/cross_section/Step1/LFR_InnerFuel_HOM_1041g_TWODANT.mcc3.sh start=&twodant end=/ include-end=True

[LFR_rzmflx] compares the TWODANT spectra of different axial regions. The spectrum is hardest at the fuel region and gets softer at lower or upper regions due to moderations. [LFR_rzm_ufg_spectra] compares the TWODANT spectra with the infinite homogeneous medium ultrafine group (UFG: 2082-group) spectrum for each axial region. The infinite homogeneous medium spectrum is very similar to the TWODANT spectrum for the active fuel region. On the other hand, those two spectra are very different for thin lower and upper thermal insulator regions where neutrons quickly leak to their lower and upper regions without having a chance to be moderated enough, resulting in spectra similar to that of their adjacent source region which is the active fuel region. For information, just a fixed source slowing down problem is solved using the fission spectrum of U-238 as a fixed source to obtain an infinite homogeneous medium UFG spectrum of a composition which does not have any fissionable isotopes. For axial regions close to top and bottom boundaries, the TWODANT spectrum is softer than the infinite homogeneous medium spectrum since neutrons have been already moderated on the way to get their regions from the center fuel region and the amount of the moderation is stronger than that in the infinite homogeneous medium of the composition of the axial region of interest. This result indicates the need for considering the axial leakage effect via the TWODANT calculation for obtaining a weighting spectrum for condensation.

!media lfr/LFR_rzmflx.png
       style=width:70%
       id=LFR_rzmflx
       caption=Comparison of TWODANT spectra of different axial regions

!media lfr/LFR_rzm_ufg_spectra.png
       style=width:70%
       id=LFR_rzm_ufg_spectra
       caption=Comparison of zero-dimensional (0D) UFG and TWODANT spectra of different axial regions

### Second step id=xs2nd

The second step is to condense the UFG (2082-group) cross section to the broad group (BG) cross section using the TWODANT spectrum. For clarification, the TWODANT calculation in the first step is the 1041 group calculation. In this secton step, the 0D UFG calculation is performed for each mixture of non-fuel axial regions and the 1D UFG calculation is performed for the fuel axial region using MC2-3. Then, resulting UFG spectra are superimposed to 1041-group TWODANT spectra for condensation of UFG cross sections to the broad group structure specified in the `c_group_structure` of the `&control` block. Broad group cross sections for the activel fuel region and the other regions are prepared separately and merged at the last step.

For the fuel region, fine mesh-based region-wise cross sections need to be generated as the Griffin transport calculation is fine-mesh based. This can be achieved by setting up an MC2-3 input that employs a 1D heterogeneous tranport calculation using the collision probability method (CPM) whose model is shown in [onedxs_model]. Hexagonal ring-wise cross sections are generated for fuel (7 sets) and one set of cross sections is generated for each of clad, duct, and lead for inner and outer regions of duct. The annular fuel and helium hole and gap are smeared and its homogenized material is used to build the model as microscopic cross sections of isotopes comprising them are not affected by such volume homogenization.

!media lfr/onedxs_model.png
       style=width:70%
       id=onedxs_model
       caption=1D R-geometry model for hexagonal ring-wise cross section generation (red: fuel + helium, blue: lead, gray: clad, cyan: duct)

Below shows the `control` block. `c_group_structure` is the broad group structure (target group structure). Specifying `c_geometry_type=cylinder` automatically sets the problem type as a 1D CPM transport problem. `i_number_region` means the number of different cross section regions. The self-shielding condition is calculated per cross section region and thus UFG cross sections are unique per cross section region. `c_externalspectrum_ufg=rzmflx` means to use the TWODANT spectrum in the condensation step after transport calculation. For this, the `rzmflx` file needs to be placed in the same folder where the MC2-3 input exists with the filename of `rzmflx` without extension.

!listing lfr/heterogeneous_single_assembly_3D/cross_section/Step2/Fuel/LFR_127Pin_Fuel_1D_9g.mcc3.sh start=&control end=/ include-end=True

The most important part is `l_spatial_homogenization=F` in the `control1d` block. This is for region-wise cross section generation, not for assembly-homogenized one. To be more concrete, for each user-defined isotope name, its UFG microscopic cross sections are flux-volume averaged over regions where the isotope is present, not over the entire region, and condensed into a BG structure.

!listing lfr/heterogeneous_single_assembly_3D/cross_section/Step2/Fuel/LFR_127Pin_Fuel_1D_9g.mcc3.sh start=&control1d end=/ include-end=True

For 1D geometry, there should be 29 cross section regions as indicated by `i_number_region=29`, which means that the number of elements of `i_mesh` (the number of fine-mesh in each cross section region), `r_location` (coordinates of each cross section region from center to periphery in a unit of $cm$ determined to preserve each material volume), and `i_composition` (index of composition assigned to each cross section region) must be 29. Composition indices from 2 to 8 are fuel corresponding to hexagonal rings 1 to 7, 1 is lead inside the duct, 9 is clad, 10 is duct, and 11 is lead outside the duct, as shown in the `material` block. For 1D cylindrical and slab geometries, only the white boundary condition is used.

!listing lfr/heterogeneous_single_assembly_3D/cross_section/Step2/Fuel/LFR_127Pin_Fuel_1D_9g.mcc3.sh start=&geometry end=/ include-end=True

In the `material` block, 7 different materials are defined for the fuel regions of 7 hexagonal rings. Even though the composition is the same, different isotope names are assigned to the same isotope to generate cross sections separately. On the other hand, only a single material is defined for each of lead, clad and duct regions, which means that only the average values over multiple cross section regions are generated per material. `i_externalspectrum(1)=6` means that the TWODANT spectrum of Zone 6 is superimposed to cross section region-wise spectrum for condensation. The index of `i_externalspectrum`, which is 1 here, is a special rule for a heterogeneous MC2-3 calculation that the superposition is applied to all cross section regions.

Suffices in all compositions need special attention since it is directly related to how the ISOTXS file will be converted to the ISOXML file. When the resulting ISOTXS file that contains all isotopes in all compositions without composition IDs is converted to the ISOXML file, the last single character in the user-defined name is used to differentiate compositions and store cross sections of different compositions in different library IDs. Library IDs are increasing in the alphabetical order of the last single character, from the starting value of $1$. In this MC2-3 input, eleven compositions are differentiated by the characters from A to K and the library IDs of them in the ISOXML file to be converted in a later stage are from $1$ to $11$. If a isotope name excluding the last single character is not the standard isotope name defined in ISOXML, the pre-fix `pseudo_` is attached. Otherwise, the isotope name is used as is.

!listing lfr/heterogeneous_single_assembly_3D/cross_section/Step2/Fuel/LFR_127Pin_Fuel_1D_9g.mcc3.sh start=&material end=EOF include-end=False

The superposition rule is depicted in [MCCgenProc]. The first two boxes represent [#xs1st] to generate a TWODANT spectrum and the third up and low two boxes represent [#xs2nd] for non-fuel and fuel regions, respectively. If `c_geometry_type=mixture`, the 0D UFG solution of mixture is adjusted by the ratio of the TWODANT spectrum to the 0D solution condensed to the TWODANT group structure. If the TWODANT group structure is UFG, just the TWODANT spectrum is used as a weighting function for condensation. If `c_geometry_type` is not `mixture`, each region-wise UFG solution is adjusted by the ratio of the TWODANT spectrum to the whole domain-averaged solution condensed to the TWODANT group structure. To simply state, the adjusted region-wise UFG solution is obtained by multiplying the spatial self-shielding factor obtained by the MC2-3 1D calculation to the TWODANT spectrum.

!media lfr/MCCgenProc.jpg
       style=width:100%
       id=MCCgenProc
       caption=MC2-3 cross section generation procedure with the axial leakage effect considered using TWODANT

Without `l_spatial_homogenization=F` in an input, which is an easy mistake to make, one will end up using the assembly average cross section for each region in heterogeneous fine-mesh transport calculation. [XS_Hom_Vs_Reg] shows the relative difference of assembly average cross section to hexagonal ring-wise fuel cross section for U-238 capture. These differences are basically the same as the spatial self-shielding factor of each ring: the ratio of hexagonal ring-wise flux to assembly average flux. Since spectrum is softer for peripheral regions than for central regions, central region flux is lower than the assembly average flux at low energy and higher at high energy. Thus, a test showed that the use of assembly average cross section instead of region-wise cross section resulted in about +400 pcm error in k-effective due to underestimation of low energy capture and overestimation of high energy fission.

!media lfr/XS_Hom_Vs_Reg.jpg
       style=width:50%
       id=XS_Hom_Vs_Reg
       caption=Relative difference of assembly average cross section to hexagonal ring-wise fuel cross section for U-238 capture

For the non-fuel region, the setting is almost similar to the first step input except `c_externalspectrum_ufg=rzmflx` instead of `l_twodant=T` in the `control` block and `i_externalspectrum(composition #)=TWODANT zone #` in the `material` block. For reminder, `TWODANT zone #`s are found in the `zones=` section in the `&twodant` block of the MC2-3 input in [#xs1st]. In this input, nine compositions are differentiated by the character from A to J omitting F, resulting in library IDs from $1$ to $9$ in the ISOXML file to be converted. 

!listing lfr/heterogeneous_single_assembly_3D/cross_section/Step2/NonFuel/LFR_127Pin_NonFuel_9g.mcc3.sh

### Run scripts and merging ISOTXS files

The process to prepare the final isoxml file is described here. First, the TWODANT running script is run as

```
cd Step1
./LFR_InnerFuel_HOM_1041g_TWODANT.mcc3.sh
```

Once the `LFR_InnerFuel_HOM_1041g_TWODANT.mcc3.sh.rzmflx` file is created, two scripts need to be run as

```
cd ../Step2/Fuel
./LFR_127Pin_Fuel_1D_9g.mcc3.sh
cd ../NonFuel
./LFR_127Pin_NonFuel_9g.mcc3.sh
cd ../../
```

The order to run two scripts doesn't matter. Once the above two scripts are run, `LFR_127Pin_Fuel_1D_9g.mcc3.sh.ISOTXS` and `LFR_127Pin_NonFuel_9g.mcc3.sh.ISOTXS` files are created. The next step is to convert those two ISOTXS files to isoxml files by running

```
griffin-opt --isoxml-nisotxs ./Step2/Fuel/LFR_127Pin_Fuel_1D_9g.mcc3.sh.ISOTXS
griffin-opt --isoxml-nisotxs ./Step2/NonFuel/LFR_127Pin_NonFuel_9g.mcc3.sh.ISOTXS
```

, which creates `LFR_127Pin_Fuel_1D_9g.mcc3.sh.xml` and `LFR_127Pin_NonFuel_9g.mcc3.sh.xml` files in respective folders. Before merging these two files, library IDs in `LFR_127Pin_Fuel_1D_9g.mcc3.sh.xml` need to be manually shifted by the number of library IDs in `LFR_127Pin_NonFuel_9g.mcc3.sh.xml`. Without this manual change of the library ID, two xml files cannot be merged. Finally, two xml files are merged to produce the final xml file as

```
griffin-opt --isoxml-merge ./Step2/Fuel/LFR_127Pin_Fuel_1D_9g.mcc3.sh.xml ./Step2/NonFuel/LFR_127Pin_NonFuel_9g.mcc3.sh.xml > LFR_127Pin_9g.xml
```

In the final xml file, one will note that all the cross sections are tabulated at a single grid value of $300K$ in the grid name of `Tfuel`. This is the default setting in the conversion of ISOTXS to ISOXML. This is obviously wrong, but not of a concern though, because this work does not account for multiphysics coupling and temperature interpolation is not involved. For a Multiphysics coupled calculation, this part needs to be treated correctly.

## Griffin Model

This section decribes the input file for Griffin using the DFEM-SN solver with the CMFD acceleration.

### Input parameters id=inputparam

Defining input parameters in advance is beneficial to make the input tractable because the same value can be used in multiple places. Radial and axial specifications of pin and assembly, block IDs and material IDs to be assigned to block IDs and the total power are defined as input parameters to be used in the main input later. It should be noted that `Library IDs` need to be consistent with those in the final xml file.

!listing lfr/heterogeneous_single_assembly_3D/neutronics_standalone/neutronics.i start=Geometry Info. end=totalpower include-end=True

### Mesh id=mesh

The mesh system is built on-the-fly using the MOOSE reactor module [!citep](MOOSEReactorModule). 

First, pins for each hexagonal ring are defined using `PolygonConcentricCircleMeshGenerator`. Since there are 7 rings, 7 pins are defined. They have different block IDs (`bid_F_fuel_R1` to `bid_F_fuel_R7`) for fuel region so that different material IDs can be assigned later. Since generally different element types should have different block IDs, the innermost helium hole of a triangular element and the helium gap between fuel and cladding of a quadrilateral element need to have different block IDs (`bid_F_heliumc` and `bid_F_helium`). Through sensitivity study, carrying just one radial mesh for the annular fuel region was turned out to be enough.

!listing lfr/heterogeneous_single_assembly_3D/neutronics_standalone/neutronics.i start=[Mesh] end=This assembles the 7 pins into an assembly with a duct include-end=False

These pin types are used to build the assembly with duct using `HexIDPatternedMeshGenerator`. Each pin type represents fuel pins for each hexagonal ring. `HexIDPatternedMeshGenerator` is meant to assign some extra element integer ID, here `pin_id`, for differentiating pins. It should be noted that `background_block_id` needs to be different from `background_block_ids` for a pin in `PolygonConcentricCircleMeshGenerator` in order to properly generate `pin_id`, which is why `bid_F_lead + 1` is used instead of `bid_F_lead` in `background_block_id`. Note that duct and assembly lead gap regions are built using `duct_block_ids`, `duct_sizes` and `duct_intervals`.

!listing lfr/heterogeneous_single_assembly_3D/neutronics_standalone/neutronics.i start=This assembles the 7 pins into an assembly with a duct end=[] include-end=True

Before extruding the 2D assembly geometry built above, an interface between the duct and the lead region is added.

!listing lfr/heterogeneous_single_assembly_3D/neutronics_standalone/neutronics.i start=interface_define end=[] include-end=True

The 2D assembly is now extruded to the z-direction and new block IDs are assigned.

!listing lfr/heterogeneous_single_assembly_3D/neutronics_standalone/neutronics.i start=This extrudes the 7-pin assembly axially and renames block IDs appropriately end=[] include-end=True

Sidesets are renamed with common sensical names.

!listing lfr/heterogeneous_single_assembly_3D/neutronics_standalone/neutronics.i start=This renames sidesets to common sensical names end=[] include-end=True

Material IDs are assigned to block IDs. This part needs to be consistent with the specification in [#materials].

!listing lfr/heterogeneous_single_assembly_3D/neutronics_standalone/neutronics.i start=[assign] end=[] include-end=True

A coarse mesh is generated for the CMFD acceleration. For better alignment of peripheral pin meshes near duct, only the peripheral pins have two radial meshes divided by the cladding outer radius while inner pins have one radial mesh. Azimuthal divisions are the same as the fine mesh. The duct mesh is also the same as the fine mesh, otherwise the CMFD solve didn't converge. The axial mesh is also the same as the fine mesh because the use of a coarser axial mesh increased the number of transport sweeps significantly. 

!listing lfr/heterogeneous_single_assembly_3D/neutronics_standalone/neutronics.i start=[PinIn_CM] end=uniform_refine include-end=False

[Mesh] shows the radial cross section view of the fine and coarse meshes. Note that the coarse mesh on the right is not a separate mesh that Griffin holds, but just a visual representation of coarse element IDs assigned to the fine mesh on the left.

!media lfr/Mesh.jpg
       style=width:75%
       id=Mesh
       caption=Radial cross section view of (Left) fine mesh and (Right) coarse mesh

### Transport systems

For the transport system, `particle` is `neutron` and `equation_type` is `eigenvalue`. The number of energy groups is 9 given by `G` and `VacuumBoundary` and `ReflectingBoundary` are sideset names renamed in `[rename_sidesets]`. Top and bottom surfaces are vacuum and lateral surfaces are reflective. In the sub-block of `[sn]`, the DFEM-SN scheme is specified. Between `monomial` and `L2-Lagrange` families of basis functions supported for discontinuous elements, the `L2Lagrange` type is selected with the first order since it gives more accurate solution than `monomial` in general. The angular quadrature type (`AQtype`) is set to `Gauss-Chebyshev` for having a freedom to choose a different number of angles in the azimuthal direction and in the polar direction in 3D. The number of azimuthal angles (`NAzmthl`) and that of polar angles (`NPolar`) per octant are set to $3$ and $2$, respectively, from a sensitivity study. The anisotropic scattering order (`NA`) is set to 1. `using_array_variable=true` and `collapse_scattering=true` are recommended options for performance reason in general.

!listing lfr/heterogeneous_single_assembly_3D/neutronics_standalone/neutronics.i start=[TransportSystems] end=# ============================================================================== include-end=False

### Executioner

The `SweepUpdate` executioner is used for the CMFD acceleration. `SweepUpdate` is a special Richardson executioner for performing source iteration with a transport sweeper. This source iteration can be accelerated by turning on `cmfd_acceleration` which invokes the CMFD solve where the low order diffusion equation is solved with a convection closure term to make the diffusion system and the transport system consistent. `coarse_element_id` is a name of the extra element integer ID assigned by `CoarseMeshExtraElementIDGenerator` in `[Mesh]`. If the CMFD solve does not converge, one can use different options for `diffusion_eigen_solver_type` which is the eigenvalue solver for CMFD. There are four options: `power`, `arnoldi`, `krylovshur` and `newton`. `newton` is the default which is recommended to stick with. If `newton` does not converge a solution, either `krylovshur` is the second option to go with, or `cmfd_prec_type` can be changed to `lu` from its default value of `boomeramg` for a small problem. Also one can try `cmfd_closure_type=syw` or `cmfd_closure_type=pcmfd` as different ways, but it is recommended to stick with its default value of `traditional_cmfd`.

`richardson_rel_tol` or `richardson_abs_tol` is the tolerance used to check the convergence of the Richardson iteration. If `richardson_postprocessor` is specified, its `PostProcessor` value is used as the convergence metric. Otherwise Griffin uses the L2 norm difference of the angular flux solution between successive Richardson iterations, which is added to `richardson_postprocessor` with the name of `flux_error` internally. `richardson_rel_tol` is the tolerance for the ratio of the `richardson_postprocessor` value of the current iteration to that of the first iteration. `richardson_value` is for the console output purpose to show the history of `PostProcessor` values over Richardson iterations. `inner_solve_type` is about the way to perform the inner solve of the Richardson iteration. There are three options: `none`, `SI` and `GMRes`. `none` is just a direct transport operator inversion per residual evaluation, while scattering source is updated together for `SI` and `GMRes` per residual evaluation. The latter two options involve more number of transport sweeps per residual evaluation than `none`, leading to the reduction of the number of residual evaluations and possibly the total run time. For `GMRes`, the scattering source effect is accounted for at once by performing the GMRes iterations and `max_inner_its` is the maximum number of GMRes iterations. For `SI`, the scattering source effect is accounted for by performing source iterations and `max_inner_its` is the maximum number of source iterations. The whole energy group is solved at once for `enable_group_sweep=false` (default) and a within-group linear system is solved group-by-group for `enable_group_sweep=true` with the scattering source being updated during the group sweep using the latest flux solution. `max_thermal_its` (the number of thermal iterations) is not relevant to this problem since there is no up-scattering for the fast reactor application.

!listing lfr/heterogeneous_single_assembly_3D/neutronics_standalone/neutronics.i start=[Executioner] end=[] include-end=True

### Flux normalization for producing the total power

The flux solution can be normalized for producing the total power using the `[PowerDensity]` block. `power` is the user-specified total power and `power_density_variable` is a required `AuxVariable` name for power density. Power is calculated using the `kappaFission` cross section in the cross section library which is the total recoverable energy per fission multiplied by the fission cross section and does not account for non-fission heating.

!listing lfr/heterogeneous_single_assembly_3D/neutronics_standalone/neutronics.i start=[PowerDensity] end=[] include-end=True

!alert note
Non-fission heating will be added in the `[PowerDensity]` block in the future.

### Power output

To output pin-wise and axial mesh-wise power, `HexagonalGridVariableIntegral VectorPostprocessors` is used. `HexagonalGridVariableIntegral` performs integration of variables given in `variable` over the block IDs given in `block` confined by each cell of a hexagonal lattice defined by `center_point`, `pitch`, `rotation` and `num_rings` and by each axial layer given in `z_layers`. In `variable`, `volume`, `x_coord` and `y_coord` are for locating a center of each cell of the hexagonal lattice. `x_coord/volume` and `y_coord/volume` are the (x, y) coordinate of a cell.

!listing lfr/heterogeneous_single_assembly_3D/neutronics_standalone/neutronics.i start=[AuxVariables] end=# ============================================================================== include-end=False

### Materials id=materials

The `[Materials]` block is constructed using `MicroNeutronicsMaterial`. The main reason for using this material instead of `MixedNeutronicsMaterial` is that each library (library ID) in the library file is not generated for each material (material ID) in the Griffin transport calculation. Using `MicroNeutronicsMaterial`, different material IDs can be freely generated in the same library ID. For example, for `Fuel_Ring1_Hole`, two materials are defined with two different IDs of `mid_F_helium` and `mid_F_fuel_R1` using isotopes in the same library ID of `lid_F_fuel_R1`. These two materials are present in three block IDs of `bid_F_fuel_R1`, `bid_F_heliumc`, and `bid_F_helium`. This specification needs to be consistent with the material assignment in [#mesh]. Note that materials must be assigned in [#mesh] to use `MicroNeutronicsMaterial`. Materials are separated by semicolons and a material name given before a material ID is not used in the code but for user information. 

!listing lfr/heterogeneous_single_assembly_3D/neutronics_standalone/neutronics.i start=[GlobalParams] end= include-end=true

In `[GlobalParams]`, `is_meter=true` is to indicate that the mesh is in a unit of meter and `plus=true` to indicate that absorption, fission, and kappa fission cross sections are to be evaluated. `grid_names` is the grid name in `<Tabulation>` of a library and `grid` is its associated grid index of the target cross section table in the library. Since the grid name is the same and there is only one grid point of $300K$ in all the libraries, they are specified in `[GlobalParams]`. Again, the $300K$ value means nothing but is just a dummay value in this work.

## Results

The k-effective result of MCNP is $1.17169\pm 15$ and that of Griffin is $1.17202$ which is $+33$ pcm off. Pin power results are also in a good agreement with a root-mean-square error of $0.47\%$ and a maximum error of $1.67\%$. [PowerDist] shows the axial power distribution of each of 127 pins normalized to have the unity average value for the whole axial and radial meshes. They are very similar to each other since fuel pins are identical and the mean free path of neutron is much larger than the pin pitch. The axial power distribution is slightly top skewed because of slighly harder spectrum at the upper part of the fuel region caused by stronger leakage to the top than to the bottom. Harder spectrum causes more fission in a fast spectrum. [PowerDistErr] compares the axial power distribution of MCNP at the center pin with that of Griffin and shows the relative error of the Griffin result. The Griffin result matches well in $1\%$ error. Errors are similar for other pins. 

!media lfr/PowerDist.png
       style=width:55%
       id=PowerDist
       caption=MCNP axial power distribution for each of 127 pins

!media lfr/PowerDistError.png
       style=width:55%
       id=PowerDistErr
       caption=Comparison of MCNP and Griffin axial power distributions of the center pin and the relative error (%) of the Griffin result

[middlefig], [lowerfig], and [upperfig] show radial power density profiles of Griffin at the middle, lowest and highest axial meshes of the fuel region. At the lowest and highest axial meshes, inner pins have lower power, peripheral pins have higher power, and the corner pins have the highest power, with $\sim \pm 1.6\%$ difference between the highest and smallest power. At the middle axial mesh, center pins have relatively higher power than they do at lower and upper axial meshes and peripheral pins have relatively lower power than they do at lower and upper axial meshes, resulting in flatter radial profile with $\sim \pm 0.3\%$ difference between the highest and smallest power.

!media lfr/middle.png
       style=width:55%
       id=middlefig
       caption=Radial power density profile at the middle axial mesh of the fuel region

!media lfr/lower.png
       style=width:55%
       id=lowerfig
       caption=Radial power density profile at the lowest axial mesh of the fuel region

!media lfr/upper.png
       style=width:55%
       id=upperfig
       caption=Radial power density profile at the highest axial mesh of the fuel region

[CMFDperformance] compares performance of calculations with and without CMFD using different input options using 144 processors in the Sawtooth HPC cluster of Idaho National Laboratory. The top left plot shows the total number of Richardson iterations until convergence with the relative tolerance of $10^{-4}$. The legend applies to the other three plots, too. The top right plot shows the total computing wall time (minutes). The bottom left plot shows the average computing time (seconds) of transport sweeps per Richardson iteration. The bottom right plot shows the average computing time (seconds) of CMFD solves per Richardson iteration. `inner_solve_type`s of `GMRes` and `SI` with `enable_group_sweep=true` and `false`, and `inner_solve_type=none` were tested and a pure transport sweeps without the CMFD acceleration was also tested.

First of all, from the top left plot, the `GMRes` inner solve type is very effective, immediately dropping the number of Richardson iterations from $39$ to $14$. Then, the number of Richardson iterations does not decrease much over increasing maximum number of inner iterations, which means the small number of inner iterations is sufficient for `GMRes`. Meanwhile, `SI` is not immediately effective, but needs larger number of inner iterations to drop the number of Richardson iterations to the similar level with `GMRes`. The number of Richardson iterations of `SI` becomes smaller than that of `GMRes` at the maximum number of inner iterations of $6$ to $7$. Meanwhile, the total computing time of `SI` becomes smaller than that of `GMRes` at the maximum number of inner iterations of $3$ to $4$ mainly because of the smaller computing time of transport sweeps per Richardson iteration for `SI`. Turning `enable_group_sweep` on always degrades the performance because of larger transport sweeping time with almost no effect of decreasing the number of Richardson iterations. The best performance is observed with `SI` without group sweeping at the maximum number of inner iterations of $7$ (almost similar between $4$ to $12$). It should be noted that the CMFD acceleration shows an excellent performance of 10 times speed-up in total time (6.5 minutes with CMFD vs. 65 minutes without CMFD). `inner_solve_type=none` with the CMFD acceleration shows almost the same performance as `SI` with the maximum number of inner iterations of $1$. It should be noted that this performance characteristics is specific to this problem and calculation settings (fine and coarse meshes, etc.) and would be different for different problems.

!media lfr/CMFDperformance.png
       style=width:75%
       id=CMFDperformance
       caption=Performance comparison of calculations with and without CMFD using different input options

## Future works

Future works include the following.

- The cross section data will be generated in a single Griffin input. The MC2-3/TWODANT procedure will be replaced by a native Griffin procedure and the development is under progress.
- A multiphysics coupled calculation with the computational fluid dynamics code NekRS [!citep](NekRS) through the Cardinal [!citep](Cardinal) interface and the MOOSE heat conduction module will be performed .

## Run command

Griffin can be run using the following command. The additional command line argument `-pc_hypre_boomeramg_agg_nl` is for the speed-up of the calculation. Detailed information can be found in 
[HYPRE/BoomerAMG](https://mooseframework.inl.gov/releases/moose/v1.0.0/application_development/hypre.html).

```language=bash
mpirun -np 144 griffin-opt -i neutronics.i -pc_hypre_boomeramg_agg_nl 4 
```
