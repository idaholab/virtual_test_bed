# Multiphysics Model

*Contact: Nicolas Stauff (nstauff.at.anl.gov), Yinbin Miao (ymiao.at.anl.gov)*

*Model link: [HPMR Model](https://github.com/idaholab/virtual_test_bed/tree/devel/microreactors/mrad)*

!alert note title=Acknowledgement
This HP-MR model was built upon earlier work performed under ARPA-E MEITNER project and reported in the journal paper [!citep](matthews2021coupled), and some parts of the inputs are coming from these original models.

## Mesh File

As a series of powerful reactor-focused mesh generators have been implemented into MOOSE as the [Reactor Module](https://mooseframework.inl.gov/modules/reactor/index.html) [!citep](shemon2022moose), the meshing tool used for the HP-MR simulation has been moved from [Cubit](https://cubit.sandia.gov/) to MOOSE's intrinsic mesh generator set.

While Sockeye uses its own simple implemented 2D axisymetric heat pipe meshing capabilities, both Griffin and BISON applications adopt meshes generated by MOOSE's intrinsic mesh generators in this HP-MR model. The input file used to generate the Griffin mesh is listed as follows.

!listing /mrad/mesh/HPMR_OneSixth_Core_meshgenerator_tri.i max-height = 10000

!media media/mrad/hpmr_mesh_proc.png
       style=display: block;margin-left:auto;margin-right:auto;width:90%;
       id=hpmr_mesh_proc
       caption=A cartoon showing the step-by-step procedures to generate the HP-MR mesh.

A 1/6 HP-MR core was generated using the input file shown above with steps illustrated in [hpmr_mesh_proc]. This mesh contains stainless steel envelopes for moderators and heat pipes, while the helium gaps are not meshed. The mesh density in radial direction is high, as multiple small features (fuel rods, moderators, heat pipes and control drums) are involved.

Compared with the mesh used in the [legacy model](/legacy_mrad_model.md), which was created from Cubit:

- An outer surface zone surrounding the reflectors was added to provide the appropriate convex boundary for neutronic calculation.
- The mesh was adjusted to preserve the actual physical volume of each material region.

The same mesh used by Griffin could also be adopted by BISON. However, the relatively coarse Griffin mesh would lead to power balance issues. To be specific, near the external boundaries (i.e., top/bottom/peripheral surfaces) as well as the interfaces between the reactor matrix and heat pipes, the mesh is not fine enough to ensure accurate calculation of heat flux, which is proportional to the temperature gradient. This issue is especially important to the interfaces between the reactor matrix and heat pipe outer surfaces, because they are the major heat sink of the system. Therefore, for the BISON mesh, the `boundary layer` and `biased meshing` features available in the [Reactor Module](https://mooseframework.inl.gov/modules/reactor/index.html) are used to create a finer mesh with a focus on these external boundaries and interfaces. Only minor modifications on the mesh generation input file are needed to achieve these features, as indicated in the comments in the Griffin mesh generation input file shown above. The differences between the Griffin and the BISON meshes are illustrated in [hpmr_mesh_diff].

!media media/mrad/MeshDen.png
       style=display: block;margin-left:auto;margin-right:auto;width:70%;
       id=hpmr_mesh_diff
       caption=The difference between the meshes used by the Griffin model (left) and the BISON model (right).

A more detailed comparison can be found in [hpmr_mesh_effect], which shows that using a finer mesh for BISON significantly reduced the power imbalance issue.

!table id=hpmr_mesh_effect caption=Percentages of power removed from different surfaces of the HPMR showing i the improvements made by using a finer mesh for BISON modeling.
|  | Total Energy Removed | Heat Pipes | Top/Bottom Surfaces | Symmetric Boundary | Peripheral Surface |
| - | - | - | - | - | - |
| Coarse Mesh for BISON, standalone BISON with flat power profile | 93.31% | 90.04% | 2.84% | 0.40% | 0.02% |
| Fine Mesh for BISON, standalone BISON with flat power profile | 98.66% | 96.05% | 2.19% | 0.40% | 0.03% |
| Fine Mesh for BISON, steady-state multiphysics simulation | 99.30% | 97.50% | 1.37% | 0.41% | 0.03% |

The input file used to generate the fine BISON mesh is listed as follows. Note the boundary layers and biasing setup in the input file. Additionally, the heat pipe related blocks are deleted from the BISON mesh and the heat pipe surfaces are defined as boundaries.

!listing /mrad/mesh/HPMR_OneSixth_Core_meshgenerator_tri_fine.i max-height = 10000

## Multiphysics Model Setup

### Cross-Section Generation Using Serpent Code

The first step is to generate homogenized multi-group cross-sections using Serpent-2. The generated cross-sections are then converted into an XML-format file for compatibility with Griffin.

!listing /mrad/Serpent_Model/serpent_input.i max-height = 10000


####  Note on LFS

**Large File Storage (LFS)** is used for the following file: `TRISO_U900_PF40_R100`

This file defines the distribution, and radius of the TRISO particles to achieve 40% packing fraction.
Make sure to install git lfs, then fetch and pull these files to be able to run the Serpent inputs.

The Monte Carlo Serpent-2 model has been set up to simulate the double heterogeneity of the HP-MR full core explicitly with the most recent ENDF/B-8.0 cross section data sets. This Monte Carlo model is used not only to provide reference solutions to the Griffin neutronics model for multiphysics simulations, but also to generate condensed multigroup cross sections for Griffin.

In particular, multigroup cross sections were generated for each material zone by tallying the average reaction rates and group fluxes within that material region in Serpent-2 criticality calculations. Different sets of cross sections were prepared with fuel and moderator temperatures ($T_f$ and $T_m$) assumed at 600 K, 700 K, 800 K, 1000 K, and 1200 K respectively.

These cross-section sets were then read by the ISOXML utility module in Griffin to create a bi-dimensional cross-section table, which was used in the multiphysics coupled transient simulations.

### Griffin Model

Griffin is used to govern the neutronics of the HP-MR as the parent application of the multiphysics simulation.


The DFEM-SN(1,3) neutronics solver with CMFD acceleration in Griffin is used in this model.

!listing /mrad/steady/HPMR_dfem_griffin_ss.i max-height = 10000

### BISON Model

BISON is used to simulate thermal physics of the 1/6 HP-MR core as a child application, as it is equipped with a comprehensive set of thermophysical properties of relevant nuclear materials, especially the TRISO-loaded graphite and 316SS.

As the heat pipe behavior is simulated by Sockeye, the heat pipe blocks are removed from the mesh used by BISON. The thermal behavior of the rest of the HP-MR core is dominated by heat conduction. Convective boundary conditions were defined at the top and bottom of the model with an external temperature of 800 K and a heat transfer coefficient (HTC) of 100 W/m^2^•K.

!listing /mrad/steady/HPMR_thermo_ss.i max-height = 10000

### Sockeye Model

For each heat pipe in the 1/6 HP-MR core, a Sockeye grandchild application is used to calculate its thermal performance.

The effective thermal conductivity model, i.e., a 2D axisymmetric conduction model with a very high thermal conductivity of 2×10^5^ W/m•K is applied to the vapor core. A heat flux boundary condition is applied to the exterior of the casing in the evaporator section, which is provided by the bulk conduction model. A convective boundary condition is applied to the exterior of the envelope in the condenser section, with an external temperature of 800 K and a heat transfer coefficient (HTC) of 10^6^ W/m^2^•K (the value is intentionally set high to achieve an effective Dirichlet boundary condition).

!listing /mrad/steady/HPMR_sockeye_ss.i max-height = 10000

### MultiApps Hierarchy

The three MOOSE applications that govern different physics respectively are coupled together leveraging the MOOSE MultiApps system. Each code has its own mesh and corresponding space and time scales. The MOOSE MultiApp system is used to tightly couple the different codes via fixed point iterations as illustrated below in [hpmr_multiapps].

At the top level, Griffin calculates the power density based on its neutronics results given the fuel and moderator temperatures taken from the BISON child application. The calculated power density is also provided to BISON to update the temperature calculation. On the other hand, for the surface of each heat pipe, BISON calculates the layered average heat flux along the normal direction of the surface and transfers the 1D field values to the respective Sockeye sub-application so that Sockeye can use them as its boundary condition. Meanwhile, BISON takes the heat pipe surface temperature calculated by Sockeye back for its own boundary condition on the heat pipe surface.

!media media/mrad/multiapps.png
       style=display: block;margin-left:auto;margin-right:auto;width:60%;
       id=hpmr_multiapps
       caption=MultiApps hierarchy of the HP-MR multiphysics simulations.

## Simulation Cases

Three different scenarios are simulated in this HP-MR model. The most fundamental case is the steady state operation of the HP-MR, where the thermal power of the full reactor core is preset as 2.07 MW (i.e., 345.6 kW per 1/6 core). Using the steady state simulation results as the reference case, two different transient scenarios are also simulated: a load following transient and a transient event initiated by the failure of a single heat pipe.

### Steady State Operation

For steady state simulation, the Griffin parent application performs an Eigenvalue calculation with a fixed preset integrated power (345.6 kW) to compute $k_{eff}$ as well as the shape of power distribution. In the meantime, the BISON child application works with multiple Sockeye grandchild sub-applications to perform transient thermal calculation using the given power density distribution until a thermal equilibrium is achieved. Once the fixed point iteration between different levels of MultiApps is converged, the steady state operation condition of the HP-MR at the given power level is obtained.

Optionally, the fixed preset integrated power level can be raised to force the HP-MR to operate at an overpower level. This is useful to demonstrate the capabilities of the NEAMS codes to predict some types of power transients that only occurs in the case of overpowered operation, such as the heat pipe cascade failure event to be demonstrated in this model.

### Load Following Transient

The load following transient is initiated by introducing a drop in the heat removal capability of the secondary coolant loop that transfer the heat from the condensor regions of the heat pipes to either a heat exchanger or directly to the energy coversion component. During steady state operation, a high heat transfer coefficient (HTC) of 10^6^ W/m^2^•K is used on the outer surface of the heat pipe condensor region. To initiate the load following transient event, the HTC value is reduced by 99.99% to 10^2^ W/m^2^•K to mimic a load reduction event. The same transient solving approach is used for BISON and Sockeye applications. However, instead of an Eigenvalue calculation, Griffin here also performs transient calculation. Based on the changes in $k_{eff}$ induced by temperature evolution calculated by BISON/Sockeye, Griffin predicts the corresponding kinetics of neutronics and consequent power distribution.

### Transient Initiated by a Single Heat Pipe Failure

Another type of transient to be simulated in this model is more localized. Instead of reducing the condensor region HTC of all heat pipes, the condensor region HTC of a single heat pipe is nearly eliminated (i.e. reduced from 10^6^ W/m^2^•K to 10^-2^ W/m^2^•K) to mimic a single heat pipe failure event, while the other heat pipes are kept unchanged (note that actually there are six heat pipes that are compromised due to the 1/6 symmetric mesh used here in this model). The failed heat pipe is intentionally selected to be in the hottest region of the HP-MR (i.e., in the center region of the center assembly).

#### Localized Single Heat Pipe Failure

The favored consequence of a single heat pipe failure in an HP-MR is that the extraneous heat that was removed by the failed heat pipe can be removed by the surrounding functioning heat pipes. In that case, the effects of the failed heat pipe are localized and the average core temperature only experiences a very minor increase. As a result, the HP-MR can still operate normally with a minor decrease in power. Ideally, the designed HP-MR power need to be set at an appropriate level that a single heat failure can be localized. Therefore, this is the expected simulation result for the HP-MR operating at the designed power level.

#### Heat Pipe Cascade Failure

On the other hand, when the HP-MR is operating at an overpower level (e.g., 720 kW in this model), the heat pipes in the hottest region are already operaing at a heat removal rate very close to their operating limits. Therefore, if a single heat pipe fails, its surrounding heat pipes will exceed their operating limits and then fail subsequently. This kind of failure events will then spread to a wider range and lead to heat pipe cascade failure. As a significant fraction of the heat pipes in an HP-MR fail, the average core temperature increases prominently and leads to a major power drop. Consequently, the HP-MR can no longer maintain its normal operation. A reliable HP-MR model should be able to predict such an unfavored transient event. In this model, the HP-MR is also intentionally set to run at an overpower of 720 kW before a single heat pipe failure is introduced to demonstrate such modeling capability.

## Guidance of Running Different Simulation Cases

Fist of all, the user needs to run the mesh generation input [file](/mrad/mesh/HPMR_OneSixth_Core_meshgenerator_tri.i) to generate the needed EXODUS mesh file that is required by the Griffin simulation. The mesh generation input file only uses objects available in the MOOSE Framework and the Reactor Module, so the input file can be run by any MOOSE applications that are compiled with the Reactor Module, such as Griffin. The example command to generate the mesh EXODUS file is listed as follows:

!listing language=bash
cd /mrad/mesh
griffin-opt -i HPMR_OneSixth_Core_meshgenerator_tri.i --mesh-only HPMR_OneSixth_Core_meshgenerator_tri_rotate_bdry.e

The mesh used by BISON is finer than the Griffin mesh, so some modifications need to be made to [file](/mrad/mesh/HPMR_OneSixth_Core_meshgenerator_tri.i). Also, the heat pipe surface boundaries need to be defined, and the heat pipe blocks themselves need to be removed. Thus, a separate [input file](/mrad/mesh/HPMR_OneSixth_Core_meshgenerator_tri_fine.i) is provided for the BISON mesh generation. Users can run the following command to generate the BISON mesh as an EXODUS file:

!listing language=bash
cd /mrad/mesh
griffin-opt -i HPMR_OneSixth_Core_meshgenerator_tri_fine.i --mesh-only HPMR_OneSixth_Core_meshgenerator_tri_rotate_bdry_fine.e

Then, the steady state simulation can be run. As the output files of the steady state simulation are already required as the initial status of the transient simulations, it is also required to be run before any transient simulations. The multiphysics steady state simulation uses Griffin, BISON and Sockeye objects. Therefore, users should use a super application that covers these three applications, such as DireWolf or BlueCRAB (compiled with Sockeye included). The example command to run the steady state simulation is shown as folllows:

!listing language=bash
cd /mrad/steady
mpirun -n 40 dire_wolf-opt -i HPMR_dfem_griffin_ss.i

With the EXODUS and checkpoint output file of the steady state simulation, the transient simulatons can be run. Before running any real cases, it is recommended to verify that the steady state obtained is correct. To do this, a null transient (i.e., a time dependent simulation with exactly the same conditions as the steady state simulation). If the steady state is correct, the null transient should yield constant values for all time-dependent quantities. The application needed to run transient simulations should be the same as the one used to obtain the steady state. The example command to run the null transient simulation is shown as folllows:

!listing language=bash
cd /mrad/transient_null
mpirun -n 40 dire_wolf-opt -i HPMR_dfem_griffin_trN.i

Once the steady state obtained is verified, the real transient cases can be run using the similar approach.

!listing language=bash
cd /mrad/load_following
mpirun -n 40 dire_wolf-opt -i HPMR_dfem_griffin_tr.i

!listing language=bash
cd /mrad/heat_pipe_failure
mpirun -n 40 dire_wolf-opt -i HPMR_dfem_griffin_tr.i

### Overpower Simulation

The default power values in the input files in this repository are all set at the nominal power (i.e., 345.6 kW for the 1/6 HP-MR core). To run the overpower case to simulate the heat pipe cascade failure, the following values need to be changed to the 720 kW overpower level. The steady state configuration must be re-generated before the overpower transient may be run.

!listing /mrad/steady/HPMR_dfem_griffin_ss.i block=PowerDensity

!listing /mrad/transient_null/HPMR_dfem_griffin_trN.i block=PowerDensity

!listing /mrad/heat_pipe_failure/HPMR_dfem_griffin_tr.i block=PowerDensity
