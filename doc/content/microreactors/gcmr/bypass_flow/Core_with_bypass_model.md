# GCMR Core Thermal Model

*Point of Contact: Lise Charlot (lise.charlot.at.inl.gov)*

*Model link: [GCMR Core Thermal Model](https://github.com/idaholab/virtual_test_bed/tree/devel/microreactors/gcmr/bypass_flow)*

!tag name=GCMR Core Thermal Model pairs=reactor_type:microreactor
                       reactor:GCMR
                       geometry:core
                       simulation_type:core_thermalhydraulics
                       input_features:multiapps
                       code_used:Pronghorn_subchannel;MOOSE_HeatTransfer;MOOSE_ThermalHydraulics
                       computing_needs:Workstation
                       open_source:partial
                       fiscal_year:2023

## Mesh file

A 3-D mesh for the core is generated using the MOOSE [`Reactor module`](https://mooseframework.inl.gov/modules/reactor/index.html). Details of the mesh for an assembly is shown in [assembly_mesh].

!media media/gcmr/bypass_flow/assembly_mesh.png
      style=display: block;margin-left:auto;margin-right:auto;width:60%;
      id=assembly_mesh
      caption= Details of the core 3D mesh

First, the pincell for the moderator, fuel and coolant channels are created.
Several rings are used for the fuel channels to be able to prescribe a non-uniform power density in the assembly.

!listing microreactors/gcmr/bypass_flow/mesh_bypass.i   start=moderator_pincell
         end=fuel_pincell_ring2

Using multiple pincells, the assembly pattern is created using the [PatternedHexMeshGenerator](https://mooseframework.inl.gov/source/meshgenerators/PatternedHexMeshGenerator.html). The outermost duct block represents the bypass and will be deleted.

!listing microreactors/gcmr/bypass_flow/mesh_bypass.i  block=Mesh/fuel_assembly

The assembly mesh is then used to create the core layout.


!listing microreactors/gcmr/bypass_flow/mesh_bypass.i  block=Mesh/core

The reflector is added using the [PeripheralRingMeshGenerator](https://mooseframework.inl.gov/source/meshgenerators/PeripheralRingMeshGenerator.html) mesh generator.


!listing microreactors/gcmr/bypass_flow/mesh_bypass.i  block=Mesh/reflector

This 2-D mesh is then extruded to create the 3D mesh.


!listing microreactors/gcmr/bypass_flow/mesh_bypass.i  block=Mesh/extrude

A sideset for the coolant boundary is created and the coolant channels removed.

!listing microreactors/gcmr/bypass_flow/mesh_bypass.i   start=add_coolant_boundary
         end=###


A sideset for the bypass boundary is created and the bypass block is removed.

!listing microreactors/gcmr/bypass_flow/mesh_bypass.i   start=add_bypass_boundary
         end=###

The mesh is then rotated to match the subchannel mesh orientation.

!listing microreactors/gcmr/bypass_flow/mesh_bypass.i  block=Mesh/rotate

This mesh is used for the heat conduction problem. The coolant channels and the bypass flow have their own meshes generated internally.

## Heat Conduction Model

The heat conduction input file solves for the temperature in the fuel channels, moderator and reflector. The material properties for each block are defined depending on their composition using the [HeatConductionMaterial](https://mooseframework.inl.gov/source/materials/HeatConductionMaterial.html) and [Density](https://mooseframework.inl.gov/source/materials/Density.html) material blocks.

A spatially variable power density is imposed in the fuel rods. This is done using several functions and assigning them to the `power_density` AuxVariable. The heat source is then applied using a [CoupledForce](https://mooseframework.inl.gov/source/kernels/CoupledForce.html) kernel.


!listing microreactors/gcmr/bypass_flow/core.i block=heat_source_fuel

The coupling to the helium flow in the cooling channels and in the bypass between the assemblies is performed through convective boundary conditions. AuxVariables for the heat transfer coefficient and bulk temperatures in the coolant channels and in the bypass are created and used in the boundary condition blocks. The value of these variables will be assigned by the Transfers system.


!listing microreactors/gcmr/bypass_flow/core.i start=cooling_channels end=outer_to_env

In addition, a convective boundary condition is assigned to the outer surface to model the heat losses through the vessel.


!listing microreactors/gcmr/bypass_flow/core.i block=outer_to_env

## Bypass flow Model

The bypass flow is modeled using Pronghorn-SC. It includes a specific problem for inter-assembly subchannels in an hexagonal pattern.

!alert warning
The tri-inter wrapper model has not been validated for gases. This model has been developed is for capability demonstration purposes only.


The mesh is defined using the `TriInterWrapperMesh` with parameters consistent with the 3D mesh used for the heat conduction problem.


!listing microreactors/gcmr/bypass_flow/bypass.i block=Mesh

The helium fluid properties are defined using an ideal gas with the following parameters:

!listing microreactors/gcmr/bypass_flow/bypass.i block=FluidProperties

The flow area and wet perimeter of the subchannels are defined as AuxVariables. They are initialized using the `TriInterWrapperFlowAreaIC` and `TriInterWrapperWettedPerimIC` objects to be consistent with the mesh.

The heat transferred from the moderator block is applied using the linear heat rate AuxVariable `q_prime`. It is defined using a [ParsedAux](https://mooseframework.inl.gov/source/auxkernels/ParsedAux.html) AuxKernel using the wet perimeter (which is equal to the heated perimeter in this case), and the flux transferred from the heat conduction problem. The value of the linear heat rate is bounded to improve the convergence of the fixed point algorithm.

!listing microreactors/gcmr/bypass_flow/bypass.i block=AuxKernels/q_prime_aux

The heat transfer coefficient to be transferred to the heat conduction problem is calculated using [ParsedAux](https://mooseframework.inl.gov/source/auxkernels/ParsedAux.html) AuxKernel. It is set here to a constant value, but a more complex correlation such as Dittus-Boelter could be implemented. This approach was not chosen for this case because it was significantly increasing the number of the fixed point iterations of the multiphysics coupling.

The solver and flow model are set using the `LiquidMetalInterWrapper1PhaseProblem`.


!listing microreactors/gcmr/bypass_flow/bypass.i block=SubChannel

Note that `P_out` is set to the outlet pressure and the AuxVariable `P` is initialized to zero as `P` is the pressure difference with the outlet pressure. The value P+P_out is used to calculate the fluid properties.



## Thermal-hydraulic model of the coolant channels

The MOOSE thermal-hydraulics module (THM) is used to mode the response of the coolant channels. The input file represents a single channel that will be replicated and translated through the MultiApp system.

The helium fluid properties are defined using an ideal gas with the following parameters:

!listing microreactors/gcmr/bypass_flow/cooling_channel.i block=FluidProperties

The friction factor and heat transfer coefficient are defined using the default correlations of  the [Closures1PhaseTHM](https://mooseframework.inl.gov/source/closures/Closures1PhaseTHM.html) closures sets which are the Churchill equation for the friction factor and the Dittus Boelter correlation for the heat transfer coefficient.

!listing microreactors/gcmr/bypass_flow/cooling_channel.i block=Closures

The channel is defined using a [FlowChannel1Phase](https://mooseframework.inl.gov/source/components/FlowChannel1Phase.html)  component and the geometry parameters of a single coolant channel.

The fluid temperature and velocity are prescribed at the channel inlet using a [InletVelocityTemperature1Phase](https://mooseframework.inl.gov/source/components/InletVelocityTemperature1Phase.html) component. The outlet pressure is prescribed using a [Outlet1Phase](https://mooseframework.inl.gov/source/components/Outlet1Phase.html) component.

A convective boundary condition is applied on the channel wall using a[HeatTransferFromExternalAppTemperature1Phase](https://mooseframework.inl.gov/source/components/HeatTransferFromExternalAppTemperature1Phase.html) component. It will use the `T_wall` AuxVariable, the fluid bulk temperature, and the heat transfer coefficient generated by the closure set to compute the heat transferred to the channel. The value of `T_wall` will be transferred from the 3D heat conduction problem in the core.


!listing microreactors/gcmr/bypass_flow/cooling_channel.i block=Components

The `Steady` Executioner is used. The initial guess for the velocity is defined as the inlet velocity, the pressure initial guess is the outlet pressure, and the temperature is set to a linear function ranging from the prescribed inlet temperature to the arbitrary value of 1100 K.


## Multiphysics Coupling

The heat conduction simulation is the parent app. The cooling channels and bypass flow are sub apps.

!listing microreactors/gcmr/bypass_flow/core.i block=MultiApps

 The variables transfers are shown in [transfers].

!media media/gcmr/bypass_flow/transfers.png
      style=display: block;margin-left:auto;margin-right:auto;width:60%;
      id=transfers
      caption= MultiApp and transfers

The wall temperature needed for the flow in the cooling channels is calculated using a [NearestPointLayeredSideAverage](https://mooseframework.inl.gov/source/userobjects/NearestPointLayeredSideAverage.html) UserObject in the heat conduction input file.


!listing microreactors/gcmr/bypass_flow/core.i block=T_wall_coolant_uo

It is then transferred using a [MultiAppGeneralFieldUserObjectTransfer](https://mooseframework.inl.gov/source/transfers/MultiAppGeneralFieldUserObjectTransfer.html).


!listing microreactors/gcmr/bypass_flow/core.i block=T_wall_to_coolant


The heat flux for the bypass flow is calculated using the bypass wall temperature. The wall temperature is calculated with a [NearestPointLayeredSideAverage](https://mooseframework.inl.gov/source/userobjects/NearestPointLayeredSideAverage.html) UserObject and assigned to the `T_wall_bypass` AuxVariable using a [SpatialUserObjectAux](https://mooseframework.inl.gov/source/auxkernels/SpatialUserObjectAux.html) AuxKernel. The heat flux is then calculated using a [ParsedAux](https://mooseframework.inl.gov/source/auxkernels/ParsedAux.html) AuxKernel.


!listing microreactors/gcmr/bypass_flow/core.i block=T_wall_bypass_uo

!listing microreactors/gcmr/bypass_flow/core.i block=T_wall_bypass_aux

!listing microreactors/gcmr/bypass_flow/core.i block=flux_aux

The heat flux is then transferred to the bypass flow sub-app using a [MultiAppGeometricInterpolationTransfer](https://mooseframework.inl.gov/source/transfers/MultiAppGeometricInterpolationTransfer.html) transfer.


!listing microreactors/gcmr/bypass_flow/core.i block=flux_to_bypass

Finally, the bulk coolant temperatures and heat transfer coefficient are transferred form the sub-apps using [MultiAppGeneralFieldNearestLocationTransfer](https://mooseframework.inl.gov/source/transfers/MultiAppGeneralFieldNearestLocationTransfer.html) transfers.

!listing microreactors/gcmr/bypass_flow/core.i block=Transfers
