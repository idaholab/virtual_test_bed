# High Temperature Engineering Test Reactor (HTTR) Steady State Multiphysics Model Description

*Contact: Javier Ortensi javier.ortensi.at.inl.gov*

*Model link: [HTTR Steady State Multiphysics](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/httr)*

Introduced below is the steady-state multiphysics HTTR model, which includes neutronics, homogenized full core heat transfer, heterogeneous single pin heat transfer, and thermal-hydraulics channel simulations.

## Neutronics id=neutronics

The neutronics calculation utilizes the NEAMS code Griffin, [!cite](Griffin2020). The calculations rely on a two-step approach in which cross sections are generated for a multitude of core conditions that form a grid covering the conditions present in the steady state configuration. A 10-energy-group macroscopic cross sections tabulation is created based on the average moderator and fuel temperatures and assume time-independent temperature profiles. A continuous finite element diffusion transport solver is used, [!cite](osti_1893099).

#### Mesh

The 'Mesh' block loads a coarse mesh. The mesh loads 'material_id' and 'equivalence-id' with the 'exodus_extra_element_integers' parameter to match group cross sections and equivalence factors to mesh regions.

!listing httr/steady_state_and_null_transient/neutronics_eigenvalue.i block=Mesh

!media media/htgr/httr/neutronics_mesh.png
    style=width:60%
    caption=Figure 1: Radial cut of the 3D homogenized coarse mesh loaded in [neutronics_eigenvalue.i](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/httr/steady_state_and_null_transient/neutronics_eigenvalue.i).

#### Transport System

The 'TransportSystem' block defines the neutronics eigenvalue problem to be solved using 10 energy groups and a continuous finite element diffusion scheme.

!listing httr/steady_state_and_null_transient/neutronics_eigenvalue.i block=TransportSystems

#### Cross sections

We define group cross sections in the 'Materials' block. The macroscopic group cross section library file was specified in the GlobalParams block. It is tabulated with respect to fuel & moderator temperatures.

!listing httr/steady_state_and_null_transient/neutronics_eigenvalue.i block=Materials

#### Equivalence

The 'Equivalence' block specifies the equivalence-corrected (SPH) group cross section library, tabulated w.r.t fuel and moderator temperature, which is used to correct the macroscopic cross-sections.
The equivalence factors were computed on the full core geometry to ensure perfect preservation of reaction rates at tabulated conditions.

!listing httr/steady_state_and_null_transient/neutronics_eigenvalue.i block=Equivalence

#### Poison Tracking

Poison tracking is activated by setting the 'poison_tracking_chains' parameter in the 'PowerDensity' block. It is used to track the concentration of Xe-135 in the fuel regions. The same cross section file and interpolation variables are used in poison tracking as specified in 'Materials' block for the 'fuel_sph' material covering the fueled regions.

!listing httr/steady_state_and_null_transient/neutronics_eigenvalue.i block=PowerDensity

## Heat Transfer

Heat transfer simulations utilize the NEAMS code BISON, [!cite](BISON), as well as the heat conduction module in MOOSE. The model includes a macroscale 3-D full core homogenized heat transfer and 2-D axisymmetric pin-scale fuel rod heat transfer. The macroscale 3-D full core homogenized heat transfer model simulates the thermal behavior of the homogenized blocks.

!alert note
Some kernels in this input are actually extracted from Griffin. Therefore either Griffin or a combined application such as Sabertooth must be used.
Slight modifications can also be made to use BISON-only kernels.

The local heat flux in the homogenized calculation is not directly relied upon to couple to the distributed thermal-hydraulics channel simulations and 2-D axisymmetric pin-scale fuel rod heat transfer. Instead, two volumetric heat transfer terms are applied at the homogenized full-core level:

(1) $q^{'''} = \tilde{h}_{\text{gap}}(\textit{T}-\textit{T}_{\text{inner}})$,

where $\tilde{h}_{\text{gap}}$ is the homogenized gap conductance (in W/K/m$^3$) and $\textit{T}_{\text{inner}}$ is the block-averaged temperature of the outer surface of graphite sleeve (i.e., inner surface of the fuel cooling channels). Heat removal by convection is modeled by adding the following source to the homogenized fuel and CR columns, [!cite](osti_1893099):

(2) $q^{'''} = \tilde{h}_{\text{outer}}(\textit{T}-\textit{T}_{\text{fluid}})$,

where $\tilde{h}_{\text{outer}}$ is the homogenized heat transfer coefficient of the outer wall and $\textit{T}_{\text{fluid}}$ is the block-averaged fluid temperature, [!cite](osti_1893099).

Equation 1 relies on the thermal-hydraulics calculation to simulate heat removal by convection in the cooling channels; Equation 2 uses data from the pin-scale model to simulate heat transfer throughout the gaps between the graphite sleeve and graphite blocks by conduction and radiation, [!cite](osti_1893099,INL/CON-18-52202-Revision-0).

The homogenized full core heat transfer and heterogeneous single pin heat transfer solves will now be discussed.

### Heat Transfer - Homogenized Full Core

The homogenized full core model simulates the homogenized heat conduction of the core, solved by the heat conduction module.

#### Mesh

The 'Mesh' block loads a homogenized mesh from an Exodus file.

!listing httr/steady_state_and_null_transient/full_core_ht_steady.i block=Mesh

!media media/htgr/httr/fullcoremesh.png
    style=width:60%
    caption=Figure 2: Radial cut of the 3D homogenized coarse mesh loaded in [full_core_ht_steady.i](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/httr/steady_state_and_null_transient/full_core_ht_steady.i). The reactor pressure vessel exchanges heat with the core via radiation and conduction.


#### Boundary Conditions (BCs)

The 'BCs' block imposes a boundary conditions that are all applied to the temperature variable.

'RPV_in_BC' imposes a forced convective boundary condition on the inner side of the RPV.

!listing httr/steady_state_and_null_transient/full_core_ht_steady.i block=BCs/RPV_in_BC

'RPV_out_BC' imposes a natural convective boundary condition on the outer side of the RPV.

!listing httr/steady_state_and_null_transient/full_core_ht_steady.i block=BCs/RPV_out_BC

'radiative_BC' imposes a radiative boundary condition on the outer side of the RPV.

!listing httr/steady_state_and_null_transient/full_core_ht_steady.i block=BCs/radiative_BC

#### Kernels

The 'heat_conduction' block defines the heat conduction in the reactor pressure vessel.

!listing httr/steady_state_and_null_transient/full_core_ht_steady.i block=Kernels/heat_conduction

The 'aniso_heat_conduction' block defines the anisotropic heat conduction inside the core. The anisotropy accounts for holes in the radial direction, within fuel and CR blocks.

!listing httr/steady_state_and_null_transient/full_core_ht_steady.i block=Kernels/aniso_heat_conduction

The time derivative of the energy equation is added using 'HeatConductionTimeDerivative'.

!listing httr/steady_state_and_null_transient/full_core_ht_steady.i block=Kernels/heat_ie

!listing httr/steady_state_and_null_transient/full_core_ht_steady.i block=Kernels/aniso_heat_ie

A term that accounts for radiative and conductive heat transfers through the gap between the fuel pins and the graphite blocks is added.

!listing httr/steady_state_and_null_transient/full_core_ht_steady.i block=Kernels/heat_loss_conductance_active_fuel

!listing httr/steady_state_and_null_transient/full_core_ht_steady.i block=Kernels/heat_gain_conductance_active_fuel

A term that accounts for the heat extracted by fluid convection in the fuel and CR cooling channels is represented with those two kernels:

!listing httr/steady_state_and_null_transient/full_core_ht_steady.i block=Kernels/heat_loss_convection_outer

!listing httr/steady_state_and_null_transient/full_core_ht_steady.i block=Kernels/heat_gain_convection_outer


#### Thermal Contact

The 'ThermalContact' block is used to model radiation and conduction between the permanent reflectors and the reactor pressure vessel. The gap is filled with cooled helium gas. The two boundaries involved are '200' (boundary id) on the reactor pressure vessel and '1' (boundary id) on the permanent reflectors.

!listing httr/steady_state_and_null_transient/full_core_ht_steady.i block=ThermalContact

#### Materials

The material solid thermal properties are defined using 'HeatConductionMaterial' and 'AnisoHeatConductionMaterial'; this includes thermal conductivity and specific heat.

!listing httr/steady_state_and_null_transient/full_core_ht_steady.i block=Materials/graphite_moderator

!listing httr/steady_state_and_null_transient/full_core_ht_steady.i block=Materials/ss304_rpv

The thermal conductivity is defined as a function of temperature defined in the 'Functions' block. It is divided by the temperature to get the desired behavior with AnisoHeatConductionMaterial.

!listing httr/steady_state_and_null_transient/full_core_ht_steady.i block=Functions/IG110_k

Additionally the densities of the various regions are defined in the 'Materials' block.

!listing httr/steady_state_and_null_transient/full_core_ht_steady.i block=Materials/graphite_density_fuel33

!listing httr/steady_state_and_null_transient/full_core_ht_steady.i block=Materials/graphite_density_fuel31

!listing httr/steady_state_and_null_transient/full_core_ht_steady.i block=Materials/graphite_density_rr_fuel33

!listing httr/steady_state_and_null_transient/full_core_ht_steady.i block=Materials/graphite_density_rr_fuel31

!listing httr/steady_state_and_null_transient/full_core_ht_steady.i block=Materials/graphite_density_cr

!listing httr/steady_state_and_null_transient/full_core_ht_steady.i block=Materials/graphite_density_rest

!listing httr/steady_state_and_null_transient/full_core_ht_steady.i block=Materials/ss304_density

### Heat Transfer - Single Pin Heterogeneous

#### Mesh

The 'Mesh' block loads a mesh to simulate the 5 fuel pins within the fuel column.

!listing httr/steady_state_and_null_transient/fuel_elem_steady.i block=Mesh

!media media/htgr/httr/fuelpinmesh.png
    style=width:100%
    caption=Figure 3: The 2D heterogeneous mesh in RZ geometry loaded in [fuel_elem_steady.i](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/httr/steady_state_and_null_transient/fuel_elem_steady.i). Shown is one of the five fuel pins from the mesh; composed of a fuel block, in grey, a graphite sleeve, in red, and a graphite moderator block, in green. Areas 1, 2, and 3 contain the thermal contact boundaries and will be described in greater detail in the next section.


#### Thermal Contact

The `ThermalContact` block solves for the heat conduction and radiation in the gap between the graphite sleeve and the top of the fuel compact, the gap between the side of graphite sleeve and side of the fuel compact, and the gap between the side of the graphite sleeve and the side of the moderator block.

!listing httr/steady_state_and_null_transient/fuel_elem_steady.i block=ThermalContact/gap_top

!media media/htgr/httr/fuelpinmesh1.png
    style=width:50%
    caption=Figure 4: A close up of the fuel pin mesh, Area 1, showing the gap between the 'Sleeve_top' (the section of the graphite sleeve to the right, in red) and the 'Fuel_top' (the section of the fuel pin to the left, in grey), where heat transfer takes place; the boundaries are shown as faint pink lines.

!listing httr/steady_state_and_null_transient/fuel_elem_steady.i block=ThermalContact/gap_side

!media media/htgr/httr/fuelpinmesh2.png
    style=width:100%
    caption=Figure 5: A close up of the fuel pin mesh, Area 2, showing the 'Sleeve_side' (the section of the graphite sleeve at the top, in red) and the 'Fuel_side' (the section of the fuel pin at the bottom, in grey), which contains a very slight gap in which heat transfer takes place. The boundaries are shown as faint blue and yellow lines.


!listing httr/steady_state_and_null_transient/fuel_elem_steady.i block=ThermalContact/cooling_channel

!media media/htgr/httr/fuelpinmesh3.png
    style=width:100%
    caption=Figure 6: A close up of the fuel pin mesh, Area 3, showing the gap between the 'Inner_outer_ring' (the outer wall of the graphite sleeve, in red) and the 'Relap7_Tw' (the inner wall of the graphite block, in green) where heat transfer takes place. The boundaries are shown as faint teal and black lines.



#### Boundary Conditions (BCs)

We impose a zero heat flux using a Neumann boundary condition on the bottom of the graphite sleeve.

!listing httr/steady_state_and_null_transient/fuel_elem_steady.i block=BCs/Neumann

A pseudo-Dirichlet boundary is also defined; it weakly imposes 'T = Tmod' on the outer most radial wall of the graphite block.

!listing httr/steady_state_and_null_transient/fuel_elem_steady.i block=BCs/outside_bc

The convective heat transfer with the helium channel is modeled using 'CoupledConvectiveHeatFluxBC'.

The 'convective_inner' block specifies a heat transfer coefficient for the inner radius of the cooling channel in W/K/$m^2$.

!listing httr/steady_state_and_null_transient/fuel_elem_steady.i block=BCs/convective_inner

The 'convective_outer' block specifies a heat transfer coefficient for the outer radius of the cooling channel in W/K/$m^2$.

!listing httr/steady_state_and_null_transient/fuel_elem_steady.i block=BCs/convective_outer


#### Kernels

The 'Kernels' block defines a steady-state heat conduction equation. A source term is defined using the 'CoupledForce' kernel to model how much power is deposited in the fuel compact.

!listing httr/steady_state_and_null_transient/fuel_elem_steady.i block=Kernels



## Thermal-Hydraulics

The thermal-hydraulics calculations in the coolant channels use the NEAMS code RELAP-7, [!cite](RELAP7).

One cooling flow channel is simulated for each of the 30 fuel columns. Another flow channel simulation is performed for each of the 16 control rod channels. The cooling flow simulation is represented below in Figure 1, [!cite](osti_1893099); the cold helium flows downwards from the top of the reactor core through the control rod channels and the fuel rod channels to cool the fuel pins.

Fuel cooling channels have a specified mass flow rate applied that is different from the mass flow rate applied to the CR cooling channels. To simplify the coolant flow path of the HTTR, the flow in inter-column gaps is neglected and the bypass flow is set to a fixed value.

!media media/htgr/httr/ThermalHydraulics.png
    style=width:80%
    caption=Figure 1: Left: Radial cross-section of the Serpent model. Right: description of the RELAP-7 models for fuel and CR channels, at the example locations shown in the core view, from [!cite](osti_1893099).

### Thermal-Hydraulics - Control Rods

#### Components

The 'CR_cooling_channel' block describes the flow channels' position, orientation, and length to create 300 elements of equal length while providing the area of the pipe, hydraulic diameter, and wall friction.

!listing httr/steady_state_and_null_transient/thermal_hydraulics_CR_steady.i block=Components/CR_cooling_channel

The 'inlet' block defines the cooling channel inlet and imposes the temperature of the fluid and the mass flow rate, which are both constants.

!listing httr/steady_state_and_null_transient/thermal_hydraulics_CR_steady.i block=Components/inlet

The 'outlet' block defines the cooling channel outlet and imposes the value of the pressure as a constant, as an outlet boundary condition.

!listing httr/steady_state_and_null_transient/thermal_hydraulics_CR_steady.i block=Components/outlet

The 'ht_ext' block defines a convective boundary condition using the 'HeatTransferFromExternalAppTemperature1Phase'. This heat structure is attached to the flow channel by specifying the 'flow_channel' parameter.

!listing httr/steady_state_and_null_transient/thermal_hydraulics_CR_steady.i block=Components/ht_ext


#### Fluid Properties

In the 'FluidProperties' block, we use the Spline Based Table Lookup fluid properties for Helium.

!alert note
Helium SBTL properties are available as a submodule of RELAP-7. If your access level does not provide them,
please contact the MOOSE team for access. They should be open-sourced shortly.

!listing httr/steady_state_and_null_transient/thermal_hydraulics_CR_steady.i block=FluidProperties

### Thermal-Hydraulics - Fuel Pins

#### Components

The Components block sets up the geometry for the cooling channels, heat transfers for the flow channels, and boundary conditions to couple to the graphite moderator blocks and fuel pins. The pipe is broken up into three sections to account for the upper and lower reflectors (which contain no fuel). The interior and exterior wall temperatures and heated perimeter are specified to model the heat transfer throughout the cooling channel.

The 'pipe_top', 'pipe1', and 'pipe_bottom' blocks define a 'FlowChannel1Phase' type as well as the position, orientation, and length of this section of the pipe. It specifies the area and hydraulic diameter as constants; 'pipe1' uses a different hydraulic diameter than 'pipe_top' and 'pipe_bottom' to account for the fuel pin inside the cooling channel. 60 'pipe_top' elements, 180 'pipe1' elements, and 60 'pipe_bottom' elements are requested.

!listing httr/steady_state_and_null_transient/thermal_hydraulics_fuel_pins_steady.i block=Components/pipe_top

!listing httr/steady_state_and_null_transient/thermal_hydraulics_fuel_pins_steady.i block=Components/pipe1

!listing httr/steady_state_and_null_transient/thermal_hydraulics_fuel_pins_steady.i block=Components/pipe_bottom

The 'inlet' block defines the cooling channel inlet as an 'InletMassFlowRateTemperature1Phase' type. It imposes the temperature of the inlet and the mass flow rate, which are both constants.

!listing httr/steady_state_and_null_transient/thermal_hydraulics_fuel_pins_steady.i block=Components/inlet

The 'junction1' block defines the junction connecting 'pipe_top' to 'pipe1'.

!listing httr/steady_state_and_null_transient/thermal_hydraulics_fuel_pins_steady.i block=Components/junction1

The 'junction2' block defines the junction connecting 'pipe1' to 'pipe_bottom'.

!listing httr/steady_state_and_null_transient/thermal_hydraulics_fuel_pins_steady.i block=Components/junction2

The 'outlet' block imposes the pressure of helium as it exits the cooling channel as a constant.

!listing httr/steady_state_and_null_transient/thermal_hydraulics_fuel_pins_steady.i block=Components/outlet

The 'ht_int' block defines the BC on the interior radius of the cooling channel. It specifies a heat flux perimeter as a constant and has an initial wall temperature of 600K.

The 'ht_ext_top' block defines the BC on the exterior radius, the 'ht_ext' block defines the BC on the interior radius, and the 'ht_ext_bottom' block defines the BC on the exterior radius of the cooling channel. Each block specifies in a heat flux perimeter as a constant and has an initial wall temperature of 500K.

!listing httr/steady_state_and_null_transient/thermal_hydraulics_fuel_pins_steady.i block=Components/ht_int

!listing httr/steady_state_and_null_transient/thermal_hydraulics_fuel_pins_steady.i block=Components/ht_ext_top

!listing httr/steady_state_and_null_transient/thermal_hydraulics_fuel_pins_steady.i block=Components/ht_ext

!listing httr/steady_state_and_null_transient/thermal_hydraulics_fuel_pins_steady.i block=Components/ht_ext_bottom

## Coupled Multiphysics Model

The HTTR model released is a multiphysics model that combines 3-D full core super homogenization-corrected neutronics, macroscale 3-D full core homogenized heat transfer, 2-D axisymmetric pin-scale fuel rod heat transfer, and distributed 1-D thermal-hydraulics channels [!cite](INL/CON-18-52202-Revision-0), shown below in Figure 2. The HTTR model released utilizes the MOOSE framework's MultiApps and Transfers systems to couple the individual physics models.

!media media/htgr/httr/Coupling.png
    style=width:70%
    caption=Figure 2: Workflow of the steady-state coupling, from [!cite](osti_1893099).


#### Coupling Neutronics and Heat Conduction

The homogeneous full core heat conduction solve is a child application of the neutronics application. This is selected because the neutronics
solve is solved for steady state directly as an eigenvalue problem, while some of the downstream simulations are relaxation to steady-state transients.

!listing httr/steady_state_and_null_transient/neutronics_eigenvalue.i block=MultiApps

The neutronics data (local power) is sent to the homogenized heat conduction model, which then sends fuel temperature data back to the neutronics model.

!listing httr/steady_state_and_null_transient/neutronics_eigenvalue.i block=Transfers

#### Coupling Homogenized Heat Conduction and Heterogenous Heat Conduction

!media media/htgr/httr/MultiphysicsCoupling.png
    style=width:70%
    caption=Figure 4: Relationship between various sub-models, from [!cite](INL/CON-18-52202-Revision-0).


Distributed heterogeneous single pin heat transfer simulations and distributed thermal-hydraulics cooling channel calculations are created using MultiApps.

!listing httr/steady_state_and_null_transient/full_core_ht_steady.i block=MultiApps

The homogenized heat transfer model sends gap conductance information to the single pin heterogeneous heat transfer model and sleeve temperature data to both thermal-hydraulics models.

Power density, moderator temperature, fluid temperature, and temperatures of the inner and outer radius of fuel and cooling rod channel walls are all sent to the Bison Heat Transfer application.

!listing httr/steady_state_and_null_transient/full_core_ht_steady.i block=Transfers/pdens_to_bison

!listing httr/steady_state_and_null_transient/full_core_ht_steady.i block=Transfers/tmod_to_bison

!listing httr/steady_state_and_null_transient/full_core_ht_steady.i block=Transfers/tfluid_to_bison

!listing httr/steady_state_and_null_transient/full_core_ht_steady.i block=Transfers/htc_inner_to_bison

!listing httr/steady_state_and_null_transient/full_core_ht_steady.i block=Transfers/htc_outer_to_bison

Average fuel temperature, graphite sleeve temperature, inner radius temperature of the fuel and cooling rod channel walls, gap conductance heat source, total heat flux, and total power are then sent back from the Bison Heat Transfer application after further calculations have been made.

!listing httr/steady_state_and_null_transient/full_core_ht_steady.i block=Transfers/tfuel_from_bison

!listing httr/steady_state_and_null_transient/full_core_ht_steady.i block=Transfers/tsleeve_from_bison

!listing httr/steady_state_and_null_transient/full_core_ht_steady.i block=Transfers/twall_from_bison

!listing httr/steady_state_and_null_transient/full_core_ht_steady.i block=Transfers/heat_source_from_bison

!listing httr/steady_state_and_null_transient/full_core_ht_steady.i block=Transfers/total_power_from_bison

!listing httr/steady_state_and_null_transient/full_core_ht_steady.i block=Transfers/bison_heat_flux

Inner wall temperatures and outer wall temperatures of the fuel cooling channels are sent to the RELAP7 Thermal-Hydraulics application.

!listing httr/steady_state_and_null_transient/full_core_ht_steady.i block=Transfers/inner_twall_to_relap

!listing httr/steady_state_and_null_transient/full_core_ht_steady.i block=Transfers/tmod_to_relap

!listing httr/steady_state_and_null_transient/full_core_ht_steady.i block=Transfers/tmod_to_relap_topbottom

Fluid temperature, homogenized outer wall heat transfer coefficient, outlet temperature, and enthalpy difference are then sent back from the RELAP7 Thermal-Hydraulics application. The heat transfer coefficients and fluid temperatures can be used to compute the heat flux to verify conservation. The temperatures fields are
also gathered to the parent application for output of the fluid temperature on the core scale.


!listing httr/steady_state_and_null_transient/full_core_ht_steady.i block=Transfers/tfluid_from_relap

!listing httr/steady_state_and_null_transient/full_core_ht_steady.i block=Transfers/hw_inner_from_relap

!listing httr/steady_state_and_null_transient/full_core_ht_steady.i block=Transfers/hw_outer_from_relap

!listing httr/steady_state_and_null_transient/full_core_ht_steady.i block=Transfers/hw_outer_homo_from_relap

!listing httr/steady_state_and_null_transient/full_core_ht_steady.i block=Transfers/tout_from_relap

!listing httr/steady_state_and_null_transient/full_core_ht_steady.i block=Transfers/deltaH_from_relap


## Files

#### Cross section Files:

The cross sections are located in [httr/cross_sections](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/httr/cross_sections).

Multigroup cross-section library with Xe-135 contribution removed - [HTTR_5x5_9MW_profiled_VR_kappa_adjusted.xml](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/httr/cross_sections/HTTR_5x5_9MW_profiled_VR_kappa_adjusted.xml)

SPH factor library -  [HTTR_5x5_9MW_equiv_corrected.xml](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/httr/cross_sections/HTTR_5x5_9MW_equiv_corrected.xml)

#### Mesh Files:

Mesh files are located under [httr/mesh](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/httr/mesh).

Griffin full-core mesh - [full_core_HTTR.e](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/httr/mesh/full_core/full_core_HTTR.e)

Full-core heat transfer mesh - [thermal_mesh_in.e](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/httr/mesh/full_core/thermal_mesh_in.e)

BISON 5-pin mesh - [HTTR_fuel_pin_2D_refined_m_5pins_axialref.e](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/httr/mesh/fuel_element/HTTR_fuel_pin_2D_refined_m_5pins_axialref.e)

#### Input Files:

Input files are located in [httr/steady_state_and_null_transient](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/httr/steady_state_and_null_transient).

## Steady-State Model

Griffin model - [neutronics_eigenvalue.i](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/httr/steady_state_and_null_transient/neutronics_eigenvalue.i)

Full-core heat transfer model - [full_core_ht_steady.i](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/httr/steady_state_and_null_transient/full_core_ht_steady.i)

BISON 5-pin model - [fuel_elem_steady.i](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/httr/steady_state_and_null_transient/fuel_elem_steady.i)

RELAP-7 Control Rod Assembly thermal-hydraulics model - [thermal_hydraulics_CR_steady.i](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/httr/steady_state_and_null_transient/thermal_hydraulics_CR_steady.i)

RELAP-7 Fuel Assembly thermal-hydraulics model - [thermal_hydraulics_fuel_pins_steady.i](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/httr/steady_state_and_null_transient/thermal_hydraulics_fuel_pins_steady.i)

## Running the simulation

To apply for access to Sabertooth and access to INL High Performance Computing, please visit [NCRC](https://ncrcaims.inl.gov/).
These inputs can be run on your local machine or on a computing cluster, depending on your level of access to the simulation
software and the computing power available to you.

### Idaho National Laboratory HPC

Run the Griffin parent application input with Sabertooth.
With at least level 1 access to Sabertooth, the `sabertooth` module can be loaded and from the `sabertooth-opt` executable can be used.
The `neutronics_eigenvalue.i` input is the input for the steady state calculation. The null transient is considered on [this page](httr_null_transient_model_description.md).

```language=CPP
module load use.moose moose-apps sabertooth

mpirun -n 6 sabertooth-opt -i neutronics_eigenvalue.i
```

### Local Device

In all cases (steady-state and null-transient - which should be executed in this order), run the Griffin input with Sabertooth.

For instance, if you have *level 2* access to the binaries, you can download sabertooth through `miniconda` and use
them (once downloaded) as follows:

```language=CPP
conda activate sabertooth

mpirun -n 6 sabertooth-opt -i neutronics_eigenvalue.i
```


### If using or modifying this model, please cite:

1.
Vincent Labouré, Javier Ortensi, Nicolas Martin, Paolo Balestra, Derek Gaston, Yinbin Miao, Gerhard Strydom, "Improved multiphysics model of the High Temperature Engineering Test Reactor for the simulation of loss-of-forced-cooling experiments", Annals of Nuclear Energy, Volume 189, 2023, 109838, ISSN 0306-4549, https://doi.org/10.1016/j.anucene.2023.109838. (https://www.sciencedirect.com/science/article/pii/S0306454923001573)

2.
Vincent M Laboure, Matilda A Lindell, Javier Ortensi, Gerhard Strydom and Paolo Balestra, "FY22 Status Report on the ART-GCR CMVB and CNWG International Collaborations." INL/RPT-22-68891-Rev000 Web. doi:10.2172/1893099.

Documentation written by Kylee Swanson.
