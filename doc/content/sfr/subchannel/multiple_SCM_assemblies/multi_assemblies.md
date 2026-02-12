# Thermal coupling of multiple SCM assemblies

*Contact: Vasileios Kyriakopoulos, vasileios.kyriakopoulos.at.inl.gov*

*Model link: [Multiple SCM assemblies in a wrapper/inter-wrapper configuration](https://github.com/idaholab/virtual_test_bed/tree/devel/sfr/subchannel/multiple_SCM_assemblies)*

!tag name=Thermal coupling of SCM assemblies
     description=Multiple SCM assemblies coupled thermally in a wrapper/inter-wrapper configuration
     image=https://mooseframework.inl.gov/virtual_test_bed/media/subchannel/multiple_SCM_assemblies/19SCM.png
     pairs=reactor_type:SFR
                       geometry:assembly
                       simulation_type:thermal_hydraulics
                       codes_used:MOOSE_Subchannel
                       computing_needs:Workstation
                       transient:steady_state
                       fiscal_year:2025
                       sponsor:NEAMS
                       institution:INL

We include two example cases of coupling multiple subchannel models (`SCM`) with a 3D heat conduction model (`MOOSE`) of the wrapper and inter-wrapper. The wrapper is the hexagonal duct that contains the subchannel assemblies and the inter-wrapper is the space in-between the ducts. A picture of the wrapper and inter-wrapper for the case of 19 assemblies is shown in [inter-wrapper]

!media subchannel/multiple_SCM_assemblies/19inter.png
    style=width:90%;margin-bottom:2%;margin:auto;
    id=inter-wrapper
    caption=Wrapper and inter-wrapper of 19 hexagonal assemblies

The index of the fuel-pins/subchannels and their relative location for the SCM model is shown in [pin_position]

!media subchannel/multiple_SCM_assemblies/pin_position.png
    style=width:90%;margin-bottom:2%;margin:auto;
    id=pin_position
    caption=Index and location of fuel pin centers and subchannel centroids

## Example Description

One example models 7 subchannel assemblies with a heat conduction model of the wrapper/inter-wrapper and the other one models 19 subchannel assemblies with a heat conduction model of the wrapper/inter-wrapper. In both models subchannel simulations are run as a `MultiApp` and heat conduction as the main app. The wrapper material is steel and the inter-wrapper is liquid sodium. Both materials are treated as solids and only heat conduction is considered. In both cases the central assembly has twice the power of its neighbors.

## Coupling scheme

The coupling approach is that of domain decomposition. The main app calculates the temperature field in the wrapper and inter-wrapper regions. Based on the temperature field it calculates the heat-flux $(W/m^2)$ on the inner surface of the wrapper (inner surface of the hexagonal ducts) and transfers that information to the equivalent duct model of SCM. The calculated heat-flux by the heat conduction model for the 7 assemblies case is shown in [heat-flux]

!media subchannel/multiple_SCM_assemblies/heat_flux.png
    style=width:60%;margin-bottom:2%;margin:auto;
    id=heat-flux
    caption=Heat-flux on the inner ducts for the 7 assembly case. Heat conduction model.

The heat-flux transfered to the duct model of SCM is shown in [heat-flux2].

!media subchannel/multiple_SCM_assemblies/heat_flux2.png
    style=width:60%;margin-bottom:2%;margin:auto;
    id=heat-flux2
    caption=Heat-flux on the inner ducts for the 7 assembly case. SCM model.

We show in [heat-flux2] two out of the seven SCM inner ducts. The center inner duct and one neighbor. In the 7 assembly case, the central assembly has twice the power of its neighbors. For this reason, heat flows from the high temperature, high power assembly through the wrapper/inter-wrapper domain into the neighboring colder, lower power assemblies.

SCM calculates the duct temperature at the inner duct surface and that information is transferred to the heat conduction model to be used as a boundary condition. All other inter-wrapper/wrapper surfaces assume a Neumann boundary condition. The SCM calculated duct temperature and the transferred BC are shown in [Tduct] and [Tduct2].

!media subchannel/multiple_SCM_assemblies/Tduct.png
    style=width:60%;margin-bottom:2%;margin:auto;
    id=Tduct
    caption=Duct temperature calculated in two of the seven SCM assemblies.

!media subchannel/multiple_SCM_assemblies/Tduct2.png
    style=width:60%;margin-bottom:2%;margin:auto;
    id=Tduct2
    caption=Duct temperature transfered to the wrapper/inter-wrapper model.

## Energy conservation

There is a postprocessor defined in the main app of type: "ADSideDiffusiveFluxIntegral" for each inner duct that calculates the total heat that flows through each duct.

!listing sfr/subchannel/multiple_SCM_assemblies/7assemblies/HC_master.i block=Postprocessors language=moose

There is also a postprocessor defined in the sub apps of type: "SCMDuctHeatRatePostprocessor" that calculates the total heat that flows through the SCM duct model.

!listing sfr/subchannel/multiple_SCM_assemblies/7assemblies/SCM_output.i language=moose

The "MultiAppGeneralFieldNearestLocationTransfer" uses these postprocessors as inputs to the parameters: "from_postprocessors_to_be_preserved, to_postprocessors_to_be_preserved" to ensure that energy is conserved during the transfer.

!listing sfr/subchannel/multiple_SCM_assemblies/7assemblies/HC_master.i block=Transfers language=moose

## Input files

The input files are the following:

### 7 assemblies

- Input file to creates the wrapper/interwrapper model geometry. This only needs to be run once to generate the mesh.

!listing sfr/subchannel/multiple_SCM_assemblies/7assemblies/abr_7assemblies.i language=moose

- File that runs the main App, the heat conduction solve in the wrapper/interwrapper.

!listing sfr/subchannel/multiple_SCM_assemblies/7assemblies/HC_master.i language=moose

- Files that run the MultiApp.

!listing sfr/subchannel/multiple_SCM_assemblies/7assemblies/fuel_assembly_1.i language=moose

!listing sfr/subchannel/multiple_SCM_assemblies/7assemblies/fuel_assembly_center.i language=moose

- File that creates a 3D visualization model of the SCM solution. This is executed by each SCM simulation (grandchild app).

!listing sfr/subchannel/multiple_SCM_assemblies/7assemblies/3d.i language=moose

### 19 assemblies

- Input file to creates the wrapper/interwrapper model geometry. This only needs to be run once to generate the mesh.

!listing sfr/subchannel/multiple_SCM_assemblies/19assemblies/abr_19assemblies.i language=moose

- File that runs the main App, the heat conduction solve in the wrapper/interwrapper.

!listing sfr/subchannel/multiple_SCM_assemblies/19assemblies/HC_master.i language=moose

- File for the subchannel simulation, executed as a `MultiApp`.

!listing sfr/subchannel/multiple_SCM_assemblies/19assemblies/fuel_assembly_center.i language=moose

- File that creates a 3D visualization model of the SCM solution. This is executed by each SCM simulation (grandchild app).

!listing sfr/subchannel/multiple_SCM_assemblies/19assemblies/3d.i language=moose

## Results

The temperature field for the coupled simulation is shown in [7SCM] and [19SCM]

!media subchannel/multiple_SCM_assemblies/7SCM.png
    style=width:60%;margin-bottom:2%;margin:auto;
    id=7SCM
    caption=Temperature field for the 7 assemblies example.

!media subchannel/multiple_SCM_assemblies/19SCM.png
    style=width:60%;margin-bottom:2%;margin:auto;
    id=19SCM
    caption=Temperature field for the 19 assemblies example.

In both examples the center assembly has twice the power of its neighbors. The wrapper/inter-wrapper region is hotter around the center assembly. In the 19 assembly case all the assemblies have the same power. The wrapper/inter-wrapper region has a uniform temperature profile far away from the central duct.
