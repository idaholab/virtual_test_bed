# Thermal coupling of multiple SCM subassemblies

*Contact: Vasileios Kyriakopoulos, vasileios.kyriakopoulos.at.inl.gov*

*Model link: [Multiple SCM subassemblies in a wrapper/inter-wrapper configuration](https://github.com/idaholab/virtual_test_bed/tree/devel/sfr/subchannel/multiple_SCM_subassemblies)*

!tag name=Multiple SCM subassemblies
     description=Multiple SCM subassemblies in a wrapper/inter-wrapper configuration
     image=https://mooseframework.inl.gov/virtual_test_bed/media/subchannel/multiple_SCM_subassemblies/19SCM.png
     pairs=reactor_type:SFR
                       geometry:assembly
                       simulation_type:thermal_hydraulics
                       V_and_V:neither
                       codes_used:SCM
                       computing_needs:Workstation
                       transient:steady_state
                       fiscal_year:2025
                       sponsor:NEAMS
                       institution:INL

We include two example cases of coupling multiple subchannel models (`SCM`) with a 3D heat conduction model (`MOOSE`) of the wrapper and inter-wrapper. The wrapper is the hexagonal duct that contains the subchannel subassemblies and the inter-wrapper is the space in-between the ducts. A picture of the wrapper and inter-wrapper for the case of 19 subassemblies is shown in [inter-wrapper]

!media subchannel/multiple_SCM_subassemblies/19inter.png
    style=width:90%;margin-bottom:2%;margin:auto;
    id=inter-wrapper
    caption=Wrapper and inter-wrapper of 19 hexagonal subassemblies

## Example Description

One example models 7 subchannel subassemblies with a heat conduction model of the wrapper/inter-wrapper and the other one models 19 subchannel subassemblies with a heat conduction model of the wrapper/inter-wrapper. In both models SCM is run as a MultiApp and heat conduction as the main app. The wrapper material is steel and the inter-wrapper is liquid sodium. Both materials are treated as solids and only heat conduction is considered. In the 7 subassembly case  the central subassembly has twice the power of its neighbors. In the 19 subassembly case or assemblies have the same power.

## Coupling scheme

The coupling approach is that of domain decomposition. The main app calculates the temperature field in the wrapper and inter-wrapper regions. Based on the temperature field it calculates the linear heat-flux (W/m) on the inner surface of the wrapper (inner surface of the hexagonal ducts) and transfers that information to the equivalent duct model of SCM. The calculated linear heat-flux by the heat conduction model for the 7 assemblies case is shown in [heat-flux]

!media subchannel/multiple_SCM_subassemblies/qprime.png
    style=width:60%;margin-bottom:2%;margin:auto;
    id=heat-flux
    caption=Linear heat-flux on the inner ducts for the 7 assembly case. Heat conduction model.

The linear heat-flux transfered to the duct model of SCM is shown in [heat-flux2].

!media subchannel/multiple_SCM_subassemblies/qprime2.png
    style=width:60%;margin-bottom:2%;margin:auto;
    id=heat-flux2
    caption=Linear heat-flux on the inner ducts for the 7 assembly case. SCM model.

We have chosen to show two out of the seven SCM inner ducts. The center inner duct and one neighbor. In the 7 assembly case the central assembly has twice the power of its neighbors.
Because of that heat flows from the high temperature assembly through the wrapper/inter-wrappe domain into the neighboring colder assemblies. Notice how the ranges of the values for heat-flux differ between the heat conduction model and the SCM models. This is because the cell size in SCM is larger in the lateral direction.

SCM calculates the duct temperature at the inner duct surface and that information is tranfered to the heat conduction model to be used as a boundary condition. All other inter-wrapper/wrapper surfaces assume a Neuman boundary condition. The SCM calculated duct temperature and the transfered BC are shown in [Tduct] and [Tduct2].

!media subchannel/multiple_SCM_subassemblies/Tduct.png
    style=width:60%;margin-bottom:2%;margin:auto;
    id=Tduct
    caption=Duct temperature calculated in two of the seven SCM subassemblies.

!media subchannel/multiple_SCM_subassemblies/Tduct2.png
    style=width:60%;margin-bottom:2%;margin:auto;
    id=Tduct2
    caption=Duct temperature transfered to the wrapper/inter-wrapper model.

## Input files

The input files are the following:

### 7 subassemblies

- File that creates the wrapper/intewrapper model geometry.

!listing sfr/subchannel/multiple_SCM_subassemblies/7subassemblies/abr_7assemblies.i language=moose

- File that runs the main App.

!listing sfr/subchannel/multiple_SCM_subassemblies/7subassemblies/HC_master.i language=moose

- Files that run the Multi-App.

!listing sfr/subchannel/multiple_SCM_subassemblies/7subassemblies/fuel_assembly_1.i language=moose

!listing sfr/subchannel/multiple_SCM_subassemblies/7subassemblies/fuel_assembly_center.i language=moose

- File that creates a 3D visualization model of the SCM solution

!listing sfr/subchannel/multiple_SCM_subassemblies/7subassemblies/3d.i language=moose

### 19 subassemblies

- File that creates the wrapper/intewrapper model geometry.

!listing sfr/subchannel/multiple_SCM_subassemblies/19subassemblies/abr_19assemblies.i language=moose

- File that runs the main App.

!listing sfr/subchannel/multiple_SCM_subassemblies/19subassemblies/HC_master.i language=moose

- File that run the Multi-App.

!listing sfr/subchannel/multiple_SCM_subassemblies/19subassemblies/fuel_assembly_center.i language=moose

- File that creates a 3D visualization model of the SCM solution

!listing sfr/subchannel/multiple_SCM_subassemblies/19subassemblies/3d.i language=moose

## Results

The temperature field for the coupled simulation is shown in [7SCM] and [19SCM]

!media subchannel/multiple_SCM_subassemblies/7SCM.png
    style=width:60%;margin-bottom:2%;margin:auto;
    id=7SCM
    caption=Temperature field for the 7 subassemblies example.

!media subchannel/multiple_SCM_subassemblies/19SCM.png
    style=width:60%;margin-bottom:2%;margin:auto;
    id=19SCM
    caption=Temperature field for the 19 subassemblies example.

In the 7 subassembly example case the center subassembly has twice the power of its neighbors. The wrapper/inter-wrapper region is hotter around the center subassembly. In the 19 subassembly case all the subassemblies have the same power. The wrapper/inter-wrapper region has a uniform temperature profile.