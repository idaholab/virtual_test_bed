# Full Core GCMR Multiphysics Model

## Mesh Generation

The same mesh as described in [/GCMR_Core_Neutronics.md] is used for the neutronics part of the multiphysics model. The mesh is generated using the MOOSE's intrinsic meshing capacity (see [gcmr_fc_mesh]). 

!media media/gcmr/FCMP/gcmr_fc_mesh.png
      id=gcmr_fc_mesh
      style=display: block;margin-left:auto;margin-right:auto;width:75%;
      caption=Mesh generation of the GCMR full core model

For heat conduction simulation, a finer mesh is needed to capture the heat flux near key interfaces and surfaces, particularly around the coolant channel surfaces and the external surface of the reactor. This is crucial to keep the energy balance of the model. That is, the heat removed from all the surfaces in the model needs to be reasonably consistent with the reactor power (e.g., >95%) at steady state (see [energy_bal]). As the mesh is generated using MOOSE's intrinsic meshing capabilities enabled by the Reactor module, the finer mesh used for heat conduction is generated using the same mesh input file as the neutronics model, with some mesh density parameters adjusted.

!media media/gcmr/FCMP/gcmr_mesh_comp_cc.png
      id=gcmr_mesh_cc
      style=display: block;margin-left:auto;margin-right:auto;width:50%;
      caption=Hierarchy of the GCMR Multiphysics Model

!media media/gcmr/FCMP/gcmr_mesh_comp_ext.png
      id=gcmr_mesh_ext
      style=display: block;margin-left:auto;margin-right:auto;width:65%;
      caption=Hierarchy of the GCMR Multiphysics Model

The two major differences in the mesh are illustrated in the following figures. [gcmr_mesh_cc] shows the mesh comparison around a coolant channel. Two additional layers of radial elements with biased mesh density are added to the reactor matrix adjacent to each coolant channel. [gcmr_mesh_ext] shows the mesh comparison near the top and bottom external surfaces of the reactor. Additional axial layers with biased mesh density are added.

!listing microreactors/gcmr/core/MESH/BISON_mesh.i

!table id=energy_bal caption=Energy balance of the GCMR multiphysics model using the refined BISON mesh
| Power Type | Unit | Value | % |
| - | - | - | - |
| Reactor Power (1/6 core) | +W+ | 3330000 | 100.00 |
| Heat Transfer to Coolant | +W+ | 3200658 | 96.11 |
| Heat Transfer to Environment | +W+ | 692 | 0.002 |
| Heat Loss on Symmetry Boundary | +W+ | 1501 | 0.005 |


## Neutronics Model

The same Griffin-based neutronics model as described in [/GCMR_Core_Neutronics.md] is used for the neutronics part of the multiphysics model. To reduce the computational cost, the original SN(3,5) NA=2 model is reduced to SN(1,3) NA=2.

Similar to the neutronics only GCMR fuel-core model the neutronics model here uses multi-group cross-sections generated with Serpent-2 and converted into ISOXML format. These cross-sections are tabulated over two grid variables: fuel temperature and hydrogen stoichiometry in the hydride moderator. The fuel temperature values are dynamically provided by the coupled heat conduction model, while the hydrogen content is assumed constant throughout the simulation. The cross-section grid spans fuel temperatures of 725, 825, 925, 1200, and 1700 K, and hydrogen stoichiometry levels of 0, 1, and 2. The same Serpent input described in [/GCMR_Core_Neutronics.md] was used to generate the cross-sections with expanded temperature and hydrogen stoichiometry grid values. Although a constant and uniform hydrogen stoichiometry of 1.94 is used in this model, the set up is ready to take the hydrogen stoichiometry from the corresponding model, such as SWIFT [!citep](matthews2021swift), in the future.

!listing microreactors/gcmr/core/Multiphysics/steady_state/MP_Griffin_ss.i

## Heat Conduction Model

The BISON-based heat conduction model is built upon using a similar approach as described in the [/GCMR_Assembly_Model_Description.md].  The GCMR core design is more complex than the single assembly. In particular, the full core contains three different types of assemblies in its different radial regions instead of a uniform assembly design. However, the key components of the GCMR, including fuel compacts, burnable poison rods, hydride moderator modules, coolant channels, reactor graphite matrix, as well as reflectors, are similar if not the same between the assembly and the full core designs. Therefore, the full core heat conduction model can be established by extending the assembly model to a full core scale using the same material properties.

The coolant channels are designed to be the main heat removal mechanism of the GCMR. Therefore, the external surface of the core is assumed to be effective insulated from the environment. A convective boundary condition with a low heat transfer coefficient (HTC) values of 0.15 W/K$\cdot$m$^2$ and ambient environment temperature of 300 K.

!listing microreactors/gcmr/core/Multiphysics/steady_state/MP_BISON_ss.i

## Coolant Channel Model

The coolant channel model also follows a similar input structure to the model from [/GCMR_Assembly_Model_Description.md]. The model utilizes the MOOSE Thermal Hydraulics Module through SAM. With updates to the component type, additional parameters were specified. In the model with `FlowChannel1Phase` components, the wall heat transfer coefficient and the Darcy friction factors are computed using the Dittus-Boelter correlation and the Churchill correlation, respectively. The `HeatTransferFromExternalAppTemperature1Phase` component and a `LayeredAverage` user object were utilized to enable heat transfer at the solid-fluid interface of the model. The number of axial layers used for temperature transfer was set to a total of 40 layers. The component and user object are used collectively to calculate the temperature and heat transfer coefficients and transferring temperature information at every time step via MOOSE’s MultiApp transfer system.

!listing microreactors/gcmr/core/Multiphysics/steady_state/MP_SAM_ss.i

Note that in this model, the inlet and outlet conditions of the coolant channels are independent from each other for simplicity.

## Multiphysics Coupling

The multiphysics model of the fuel-core GCMR is established by interconnecting the three aforementioned single-physics models using a similar hierarchy as what was used for the [GCMR assembly simulations](/GCMR_Assembly_Model_Description.md). A three-level Griffin-BISON-SAM MultiApp
simulation was created for the full GCMR core as illustrated in [gcmr_mp]. The coupled Griffin-BISON-SAM multiphysics model can be run using MOOSE-based combined application, BlueCRAB.

!media media/gcmr/FCMP/gcmr_mp.png
      id=gcmr_mp
      style=display: block;margin-left:auto;margin-right:auto;width:45%;
      caption=Hierarchy of the GCMR Multiphysics Model

## Steady State Simulation Results

The steady-state simulation results of the multiphysics GCMR model are illustrated in [gcmr_ss] and results are summarized in [GCMR_ss_results]. 

Determined by the inlet coolant temperature, the minimum fuel temperature of the GCMR is around 900 K, the fuel temperature increases along with the axial elevation and reaches 1200 K near the coolant outlet position. As coolant channels are densely distributed, the moderator temperature is comparable with the fuel temperature. Additionally, it is worth noting that the horizontal maximum temperature is not located near the geometric center of the GCMR. Instead, the horizontal maximum temperature is predicted to be in the middle core region, mainly due to the dissimilar assembly designs in different radial regions.

!media media/gcmr/FCMP/gcmr_ss.png
      id=gcmr_ss
      style=display: block;margin-left:auto;margin-right:auto;width:45%;
      caption=Steady state simulation results of the GCMR multiphysics model

!table id=GCMR_ss_results caption=Key predicted parameters by the GCMR models 
| Parameter | Unit | Value |
| - | - | - |
| Power (1/6 core) | +MW$_{th}$+ | 3.33 |
| $T_{fuel, avg}$ | +K+ | 1095.69 |
| $T_{fuel, max}$ | +K+ | 1225.75 |
| $T_{fuel, min}$ | +K+ | 910.86 |
| $T_{mod, avg}$ | +K+ | 1072.98 |
| $T_{mod, max}$ | +K+ | 1180.53 |
| $T_{mod, min}$ | +K+ | 912.44 |
| $k_{eff}$ | n/a | 1.0290067 |
