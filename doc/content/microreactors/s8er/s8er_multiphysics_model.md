# SNAP 8 Experimental Reactor (S8ER) Multiphysics Model

*Contact: Isaac Naupa, iaguirre6@gatech.edu*
*Contact: Stefano Terlizzi, Stefano.Terlizzi@inl.gov*

!alert note
For citing purposes, please cite [!citep](s8er_garcia2022) and [!citep](s8er_naupa2022).

## Introduction

The SNAP8ER is a good stress test for the MOOSE-based computational tools, specifically GRIFFIN due to its small size, high leakage, sensitivity to few group parameters, and material composition. 

Some aims of this model was to reduce the use of resources external to MOOSE, i.e. Cubit and to simplify the workflow from cross section generation to full griffin model. For this reason, the mesh is fully generated inside MOOSE using a variety of [Mesh Generator Objects](https://mooseframework.inl.gov/syntax/Mesh/index.html). Also for this reason, the [DFEM-SN Transport Scheme](https://griffin-docs.hpcondemand.inl.gov/latest/syntax/DFEM-SN/index.html), rather than the [CFEM-Diffusion Scheme](https://griffin-docs.hpcondemand.inl.gov/latest/syntax/CFEM-Diffusion/index.html) is used in the neutronic model. This allows us to have more a direct workflow from generation of the few group parameters and our griffin model, such as avoiding the generation of SPH correction factors, often needed for good agreement between griffin and reference solutions when using CFEM-Diffusion. DFEM-SN is also heavilyy optimized for parallel computation and comes in handy for larger problems such as this. 

!alert note
To request access to Bison or Griffin, please submit a request on the
[INL Modeling and Software Website](https://inl.gov/ncrc/).

## Generation of Few Group Parameters

For generation of the reference solution and neutronic data the monte carlo code [Serpent](https://serpent.vtt.fi/mediawiki/index.php/Main_Page) was used. It must be noted that this model is quite sensitive to the energy structure and spatial resolution used in the generation of the few group parameters. Various sensitivity studies were conducted to find the ideal parameters that were conducive to good agreement between Griffin and Serpent.

### Serpent Model

For the serpent model, only the the active core region including core barrel and internal reflectors were modeled. External reflector control drums are not included in this model, but will be included in future updates. 

!media s8er/s8er_core_snapshot.png
  caption= S8ER Core Snapshot, from [!citep](SNAP8Summary)
  style=width:60%;margin-left:auto;margin-right:auto

!media s8er/SNAP8ER_C3_2D_NODRUMS_WET_3_4.i_geom1.png
  caption= S8ER Serpent Model Core Snapshot, from [!citep](s8er_garcia2022)
  style=width:60%;margin-left:auto;margin-right:auto

!listing microreactors/s8er/serpent/SNAP8ER_C3_2D_NODRUMS_WET_1_1.i

A radial ring spatial resolution was used for generation of the few group parameters 8 ring fuel layers, 1 coolant ring layer, and 1 internal reflector and core barrel ring layer for a total of 10 radial ring layers. Serpent uses universes to define spatial domains for generation of few group parameters, below is a table defining each universe. This information will be used in the griffin model to map neutronic data to the mesh.

!table id=Radial Ring Universe Mapping caption= Radial Ring Universe Mapping
| Radial Layer | Universe ID | Universe Material/Region |
| -----------  | ----------- |------------ |
| 1      |   100   | Fuel Channel |
| 2      |   200   | Fuel Channel |
| 3      |   900   | Fuel Channel |
| 4      |   400   | Fuel Channel |
| 5      |   500   | Fuel Channel |
| 6      |   600   | Fuel Channel |
| 7      |   700   | Fuel Channel |
| 8      |   800   | Fuel Channel |
| 9      |   300        | Coolant Channel |
| 10     |   1200       | Internal Reflector + Core Barrel |

A 16 energy few group structure documented in [!citep](S8NuclearAnalysis) was used for the generation of few group parameters.

!table id=Few Group Energy Structure caption= Few Group Energy Structure
| Group     | Lower Limit (eV)  |
| ----------- | ----------- |
| 0      |    10E+06       |
| 1      |   3E+06    | 
| 2      |   1.4E+06     | 
| 3      |   0.9E+06    | 
| 4      |   0.4E+06     | 
| 5      |   0.1E+06     | 
| 6      |   17E+03     | 
| 7      |   3E+03     | 
| 8      |   0.55E+03     | 
| 9      |   100     | 
| 10     |   30     | 
| 11     |   10    | 
| 12     |   3     | 
| 13     |   1     | 
| 14     |   0.4     | 
| 15     |   0.1     | 
| 16     |   0.025     | 

### State Points

Reference data at each state point are generated for each tabulation parameter: fuel and coolant temperature, and each tabulation point: 300K, 600K, 900K, 1200K. This leads to a total of $2^{4}$ state points. The reflector temperature and the coolant density are maintained constant for each statepoint. Future updates to the model will include these effects. 

!table id=Serpent Model State Points caption= Serpent Model State Points
| Case      | Grid Index  | Fuel Temperature (K) | Coolant Temperature (K) |
| ----------- | ----------- |----------- | ----------- |
| 1      |   1 1     | 300 | 300 |
| 2      |   1 2     | 300 | 600 |
| 3      |   1 3     | 300 | 900 |
| 4      |   1 4     | 300 | 1200 |
| 5      |   2 1     | 600 | 300 |
| 6      |   2 2     | 600 | 600 |
| 7      |   2 3     | 600 | 900 |
| 8      |   2 4     | 600 | 1200 |
| 9      |   3 1     | 900 | 300 |
| 10     |   3 2     | 900 | 600 |
| 11     |   3 3     | 900 | 900 |
| 12     |   3 4     | 900 | 1200 |
| 13     |   4 1     | 1200 | 300 |
| 14     |   4 2     | 1200 | 600 |
| 15     |   4 3     | 1200 | 900 |
| 16     |   4 4     | 1200 | 1200 |

### Preparation of Neutronic Data for Griffin

Now having all the reference neutronic data generated by serpent, the data must be prepared for use in our griffin model. This is done through [ISOXML](https://griffin-docs.hpcondemand.inl.gov/latest/isoxml-user-manual/introduction.html#introduction), a general toolkit aimed at handling large multigroup libraries. This is also comes in handy for facilitating the coupling process and handling feedback effects by using the data generated for our various state points. 

!listing microreactors/s8er/serpent/core_2D_nodrums_16G_WET.xml

Full documentation on the serpent to ISOXML workflow can be found [here](https://griffin-docs.hpcondemand.inl.gov/latest/isoxml-user-manual/data_conversion.html#sec:data-conversion-serpent). ISOXML will use the grid indexes for each state point and parse the serpent results files and construct the multigroup library for use in our griffin model. 

## Griffin Model

In serpent, the fuel, ceramic, absorber, gap, cladding, coolant, internal reflectors, and barrel are all modeled explicitly. However, the homogenized universe data is generated at the channel level, meaning in griffin the mesh will also be done at the channel level to correspond with the homogenized universe data. 

### Geometry

The main tools used to generate this mesh were MOOSE based meshgenerators, primarily the [PolygonConcentricCircleMeshGenerator](https://mooseframework.inl.gov/source/meshgenerators/PolygonConcentricCircleMeshGenerator.html) for a fuel channel, [HexIDPatternMeshGenerator](https://mooseframework.inl.gov/source/meshgenerators/HexIDPatternedMeshGenerator.html) for a lattice of fuel channels, the [PeripheralRingMeshGenerator](https://mooseframework.inl.gov/source/meshgenerators/PeripheralRingMeshGenerator.html) for the internal reflector and barrel, and the [PlaneDeletionGenerator](https://mooseframework.inl.gov/source/meshgenerators/PlaneDeletionGenerator.html) for adjustments to the geometry.

!listing microreactors/s8er/core_2D_griffin_coupled.i block=Mesh

1. 9 individual fuel channels are modeled, 1 for each corresponding radial ring 
2. The fuel channels are mapped into the lattice in the appropiate arrangement from the homogenized universe data.
3. A peripheral ring is enclosed around the lattice to represent the internal reflector + core barrel (last radial layer)
4. The mesh is cut along the ring at various points to preserve the geometry and dimension of the reference serpent model. 
5. The blocks are mapped to their appropriate material ID.

A table with corresponding mapping between the Serpent Universe ID and the Griffin Block ID is shown below.

!table id=Homogenized Universe Mapping caption= Homogenized Universe Mapping
| Serpent Universe ID | Material ID | Block ID | Material/Region |
| -------- | ------- | ----- | ------------ |
| 100      |   100   |  1    | Fuel Channel |
| 200      |   200   |  2    | Fuel Channel |
| 900      |   900   |  3    | Fuel Channel |
| 400      |   400   |  4    | Fuel Channel |
| 500      |   500   |  5    | Fuel Channel |
| 600      |   600   |  6    | Fuel Channel |
| 700      |   700   |  7    | Fuel Channel |
| 800      |   800   |  8    | Fuel Channel |
| 300      |   300   |  9, 10 | Coolant Channel |
| 1200     |   1200  |  11   | Internal Reflector + Core Barrel |

!media s8er/griffin_universe_map.png
  caption= S8ER Griffin Mesh, from [!citep](s8er_naupa2022)
  style=width:100%;margin-left:auto;margin-right:auto

### TransportSystems

As stated previously, the Griffin model uses the newly optimized DFEM-SN transport scheme to solve for the eigenvalue. Here a 16 group energy structure is used with vacuum boundary conditions on the outer edge of the core barrel. The solver uses 9 azimuthal and 3 polar angles, typically the default for these are 6 and 2 respectively but because this system is highly anisotropic, a higher order of angles is required for solution fidelity. The benefit with using the DFEM-SN scheme rather than the stand CFEM-Diffusion scheme, is the removal of several layers of calculation for the same fidelity, however at the expense of a more expensive computation. The DFEM-SN scheme is optimized and scales well with problem size. 

!listing microreactors/s8er/core_2D_griffin_coupled.i block=TransportSystems

### Materials

Through the use of the [CoupledFeedbackMatIDNeutronicsMaterial](https://griffin-docs.hpcondemand.inl.gov/latest/source/materials/CoupledFeedbackMatIDNeutronicsMaterial.html#coupledfeedbackmatidneutronicsmaterial), by the mapping of `materialIDs` to the mesh done earlier, this object conveniently handles the direct mapping of neutronic data into the mesh. The object also has a feature to correct the neutronic data used in a material by adjusting the cross sections for a correction volume. This is done for the internal reflector and core barrel region to more appropriately match the reference model.

!listing microreactors/s8er/core_2D_griffin_coupled.i block=Materials

## Bison Model

Because bison is only taking the power distribution from the griffin model, we have the freedom to model each fuel channel component explicitly and hence we are able to capture unique heat transfer phenomena such as the gap radiative transfer and model thermal properties for each component. This model only captures heat conduction but future updates will include feedback from thermomechanical effects such as thermal expansion. 

!media s8er/fuelpin_components_label_bison.png
  caption= S8ER Bison Mesh, from [!citep](s8er_naupa2022)
  style=width:100%;margin-left:auto;margin-right:auto

### Geometry 

The process for generating the Bison mesh is almost identical to the process described for the Griffin mesh, with a few extra steps. This time since we are modeling the explicit fuel element geometry, we use the [PolygonConcentricCircleMeshGenerator](https://mooseframework.inl.gov/source/meshgenerators/PolygonConcentricCircleMeshGenerator.html) to model concentric rings corresponding to the outer radii of each material in the fuel element.

!listing microreactors/s8er/core_2D_bison_coupled.i block=Mesh

!table id=S8ER Bison Dimensions caption= S8ER Bison Dimensions
| Material/Region |  Radius (m) |
| --------------- | --------- |
| UZrH Radius              |   0.0067564)   |
| Ceramic Outer Radius     |   0.007130879  |
| Gap Outer Radius         |   0.006866719  |
| Cladding Outer Radius    |   0.007130879  |
| Lattice Pitch            |   0.007239     |

### Kernels, AuxKernels, Functions

The Kernels used are the [HeatConduction](https://mooseframework.inl.gov/source/kernels/ADHeatConduction.html) to solve the steady state heat conduction equation, as well as the [CoupledForce](https://mooseframework.inl.gov/source/kernels/CoupledForce.html) to couple the power distribution from bison as the spatially dependent heat generation term.

!listing microreactors/s8er/core_2D_bison_coupled.i block=Kernels

The AuxKernels used are a variety of function executors and variable normalizers for solving thermal properties that are temperature dependent, normalizing the power distribution for power conservation between Bison and Griffin, and for seperating the fuel, coolant, and reflector temperatures into individual variables to be used as the tabulation parameters.

!listing microreactors/s8er/core_2D_bison_coupled.i block=AuxKernels

The Functions used include the thermal conductivity, and specific heat of the fuel as a function of temperature from [!citep](SNAPFuel). 

!listing microreactors/s8er/core_2D_bison_coupled.i block=Functions

### Materials

The thermal properties of each material are modeled through using [GenericConstantMaterial](https://mooseframework.inl.gov/source/materials/GenericConstantMaterial.html). This allows you to set thermal properties such as the density, specific heat,  and thermal conductivity. In the case of the fuel we have documented formulations for the specific heat and thermal conductivity as a function of temperature. This temperature dependence can implemented through the use of the [HeatConductionMaterial](https://mooseframework.inl.gov/source/materials/HeatConductionMaterial.html) which allows you to set material properties as a function of temperature. 

!listing microreactors/s8er/core_2D_bison_coupled.i block=Materials

!table id=S8ER Thermal Parameters caption= S8ER Thermal Parameters, from [!citep](SNAPFuel), [!citep](SNAP8Summary)
| Material/Region | Density (kg/m^3) | Specfic Heat (J/kg-K) | Thermal Conductivity (W/m-K) |
| --------------- | ---------------- | --------------------- | --------------------- |
| UZrH            |   5963.13    |   472.27 + T(0.72)     |  27.73 + T(0.027)    |
| Ceramic         |   2242.584   |    837.36    |  1.73   |
| Gap             |   0.0166   |    5193.16    |  0.34   |
| Cladding        |   8617.93   |   418.68    |  18.85   |
| Internal Reflector |  1810.08   |    2721.42   |  131.53    |

## Multiphysics Coupling

The multiphysics coupling is done through MOOSE's [MultiApp](https://mooseframework.inl.gov/syntax/MultiApps) system, where Griffin is the main driver and executes Bison as a subapp. In this model the power distribution is solved by Griffin, where it is then transferred to Bison to solve the temperature distribution, where then the temperature distribution is transferred back to Griffin to calculate the new power distribution with updated neutronic data from the temperature feedback. This process is iterated by the `[Executioner]` until the system converges.

!media s8er/multiphysics_flowchart.png
  caption= Multiphysics Flow Diagram, from [!citep](s8er_naupa2022)
  style=width:60%;margin-left:auto;margin-right:auto

!listing microreactors/s8er/core_2D_griffin_coupled.i block=MultiApps

The data from each respective model is transfered using MOOSE's [Transfers](https://mooseframework.inl.gov/syntax/Transfers/index.html) system. Since the meshes are tailored for each application, the differences in each mesh must be accounted for in the transfers. As described earlier, the Griffin mesh is generated at the channel level, while the Bison mesh is generated with explicit fuel components modeled. For this reason the [MultiAppProjectionTransfer](https://mooseframework.inl.gov/source/transfers/MultiAppProjectionTransfer.html) is used, which is handy when projecting field variables from one mesh to another. In this case the power generated in the Griffin fuel channel is transfered to only the fuel in Bison. For this reason, a volume normalization factor must be applied to the power density transfered so that power between models is conserved. The normalization factor is simply the ratio of the fuel channel to fuel volume. 

The temperature distribution for each respective tabulation parameter i.e, fuel temperature and coolant temperature is transfered using the [MultiAppInterpolationTransfer](https://mooseframework.inl.gov/source/transfers/MultiAppInterpolationTransfer.html). This transfer is suitable for nodal variables such as variables in the `LAGRANGE` family.   

!listing microreactors/s8er/core_2D_griffin_coupled.i block=Transfers

Referring back to the `[Materials]` block, this is where the coupled feedback is taken into account. The [CoupledFeedbackMatIDNeutronicsMaterial](https://griffin-docs.hpcondemand.inl.gov/latest/source/materials/CoupledFeedbackMatIDNeutronicsMaterial.html#coupledfeedbackmatidneutronicsmaterial) takes the tabulated neutronic data and uses temperature from bison to interpolate between statepoints. For this reason,  Multiple transfers for each tabulation parameter are required so that the neutronic data can be properly interpolated between statepoints.


!listing microreactors/s8er/core_2D_griffin_coupled.i block=Materials

### Running the Model

The Discontinuous Finite Element Discrete Ordinate (DFEM-SN) solver in conjunction with the asynchronous parallel sweeper implemented in griffin for the inversion of the streaming operator allows to efficiently perform neutron transport calculations in a parallel fashion on unstructured mesh [!citep](GriffPerf). Additionally, it allows to streamline the modeling and simulation pipeline due to the enhanced fidelity that renders the generation of equivalence parameters not essential (agreement with Serpent within few hundreds of pcm for the effective multiplication factor).  The neutronic model coupled with heat conduction runs in one minute on one Sawtooth node composed of 48 processors.

!listing microreactors/s8er/core_2D_griffin_coupled.i block=Executioner

The code is executed with the following lines.

```
mpiexec -n 48 griffin-opt -i core_2D_griffin_coupled.i
```


!alert note
More information about the SNAP Reactors may be found [here](https://github.com/CORE-GATECH-GROUP/SNAP-REACTORS).

!bibtex bibliography
