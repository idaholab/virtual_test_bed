# Versatile Test Reactor (VTR)

*Contact: Nicholas Martin, nicolas.martin.at.inl.gov*

## VTR core description

The VTR conceptual design presented in [!citep](heidet2020) is used for this study. 
This VTR design is a 300-MW thermal, ternary-metallic fueled (U-20Pu-10Zr), low-pressure, 
high-temperature, fast-neutron flux $\left(>10^{15} \frac{n}{cm^2 \cdot s} \right)$,
liquid sodium-cooled test reactor. 
The VTR is designed with an orificing strategy to yield lower nominal peak cladding 
temperatures in each orifice group by controlling the flow rate in each assembly. 
The reference VTR core, shown in [fig:vtr_radial], contains 66 fuel assemblies,
six primary control rods, three secondary control rods, 114 radial reflectors, 114 radial 
shield reflectors, and 10 test locations.
Of the 10 test locations, five are fixed due to the required penetrations in the cover
heads (instrumented), and five are free to move anywhere in the core (non-instrumented).
The number of non-instrumented test locations can be easily increased or decreased depending
on testing demand, but this may lead to slightly different core performance characteristics
(e.g., flux) due to the different core layouts. 
Although the test assemblies will contain a wide variety of materials, they are modeled as
assembly ducts that are only filled with sodium and axial reflectors to have a consistent
core layout for subsequent analyses [!citep](heidet2020).
The axial configurations of the five different types of assemblies (fuel, control rod, test, reflector, shield)
present in the reference VTR are shown in [fuel_assemblies].
The cold dimensions of the driver fuel assemblies and the control rod assemblies are provided in
[fuel_dimensions] and [cr_dimensions], respectively.

In addition to these characteristics, the VTR is being designed to have a cycle length of 100 effective full
power days (EFPD) before it has to be refueled.
During refueling, the VTR will follow a discrete refueling scheme in that there is no fuel reshuffling,
rather the fuel assemblies will be replaced with a fresh fuel assembly depending on its batch number.
The number of cycles the fuel assembly stays in the core is dictated by the desired average fuel discharge
burnup of 50 GWD/t (i.e., the fuel assemblies are discharged with an average burnup as close as possible to
the targeted batch-average burnup of 50 GWD/t). 
This means fuel assemblies at the core periphery will remain in the core longer than those at the core center.
This is all done in an effort to avoid unnecessary fuel handling operations that would complicate the design 
and increase operational costs.
The discrete fuel management scheme is shown in [fig:fuel_loading], where the 12 central most fuel
assemblies (in Row 1--3) remain in the core for three cycles, the next 18 fuel assemblies (in Row 4) remain
in the core for four cycles, the following 12 fuel assemblies (in Row 5) remain in the core for five cycles,
and the remaining 24 assemblies (in Row 6) remain in the core for six cycles [!citep](heidet2020).
In [fuel_loading], the first number in each assembly corresponds to the the number
of cycles that the assembly will remain in the core and the second number corresponds to when that assembly will be replaced.
For example, the designation "6-4" indicates that this assembly will remain in the core for six cycles and
is replaced every fourth cycle out of six.
This fuel management scheme will result in the equilibrium core to having a periodicity of 60 cycles,
meaning that the core configuration and performance will be identical every 60 cycles with small variations in between. 

!media VTR_Core.png
       style=width:60%;margin-left:auto;margin-right:auto

!media vtr/VTR_Core.png
       id=vtr_radial
       caption=Radial configuration of the VTR core layout, taken from [!citep](heidet2020).

!media VTR_Assemblies.png
       id=fuel_assemblies
       caption=Axial configuration of the VTR fuel assemblies.

!table id=fuel_dimensions caption=Driver Fuel Assembly Dimensions, taken from [!citep](shemon2020).
| Parameter             | Cold Dimension | Unit |
|          -            |       -        |  -   |
| Assembly Pitch        | 12             | cm   |
| Duct flat-to-flat     | 11.7           | cm   |
| Duct thickness        | 0.3            | cm   |
| Number of rods        | 217            | -    |
| P/D                   | 1.18           | -    |
| Cladding outer radius | 0.3125         | cm   |
| Cladding thickness    | 0.0435         | cm   |
| Sodium bond thickness | 0.0360         | cm   |
| Fuel slug radius      | 0.2330         | cm   |
| Wire Wrap             | yes            | -    |
| Active fuel length    | 80             | cm   |

!table id=cr_dimensions caption=Control Rod Dimensions, taken from [!citep](shemon2020).
| Parameter                        | Cold Dimension | Unit |
|            -                     |       -        |  -   |
| Assembly Pitch                   | 12             | cm   |
| Inter-assembly gap               | 0.3            | cm   |
| Outer duct outside flat-to-flat  |         11.7   | cm   |
| Outer duct inside flat-to-flat   |         11.1   | cm   |
| Outer duct thickness             |         0.3    | cm   |
| Inner duct sodium gap thickness  |         0.3    | cm   |
| Inner duct outside flat-to-flat  |         10.5   | cm   |
| Inner duct inside flat-to-flat   |         9.9    | cm   |
| Number of rods                   |         37     | -    |
| P/D.                             |       1.02231  | -    |
| Cladding outer radius            |       0.7398   | cm   |
| Cladding thickness               |       0.0825   | cm   |
| Helium bond thickness            |       0.0514   | cm   |
| B4C absorber radius              |       0.6060   | cm   |
| Wire wrap                        |       yes      | -    |

!media VTR_fuel_loading.png
       id=fuel_loading
       caption=Fuel Management Strategy, taken from [!citep](heidet2020).


## VTR model description

This VTB model provides a conceptual design to the proposed VTR.
Reactor core analyses of the VTR, or more generally SFRs, require the modeling of multiple physics systems, such as:

- Neutron flux distribution throughout the core, obtained by solving the neutron transport equation.

- Coolant temperature and density distribution, obtained by solving the thermal-hydraulic equation system for the flowing sodium.

- Fuel temperature distribution, obtained by solving the heat conduction equation in the fuel rods.

- Due to the large temperature gradients occurring in SFR cores, thermal expansion plays a significant role and needs to be accounted for by computational models.

The VTR model captures the predominant feedback mechanisms and consists of 4 independent application inputs:

1. A 3D Griffin neutronics model, whose main purpose is to compute the 3D neutron flux / power given the local field temperatures and mechanical deformations due to thermal expansion.

2. A 2D axisymmetric BISON model of the fuel rod which predicts the thermal response given a power density, as well as the thermal expansion occurring in the fuel/clad materials. The predicted quantities (fuel temperature, axial expansion in the fuel) are then passed back to the neutronics model. One BISON input is instantiated per fuel assembly.

3. A tensor mechanic input of the core support plate, predicting the stress-strain relationships given the inlet sodium temperature. The displacements are passed to the neutronics model to account for the radial displacements in the core geometry. Since the core support plate expansion is tied to the inlet temperature (fixed in this analysis), this model is only called once at the beginning of the simulation.

4. A SAM 1D channel input, whose purpose is to compute the coolant channel temperature / density profile and pressure drop, given the orifice strategy selected which dictates the input mass flow rate and outlet pressure and the wall temperature coming from the BISON thermal model. The coolant density and heat transfer coefficient is passed back to BISON to be used in a convective heat flux boundary condition. The coolant density is also passed back to the neutronics model for updating the cross sections. One SAM input is instantiated per coolant channel. The coupling scheme with the variables exchanged between solvers is given in [sfr_scheme].


!alert note
Note: this model consists of one single assembly in 3D, with reflective boundary conditions radially for the neutronics model so as to mimic an infinite domain in the X and Y directions, and void boundary conditions axially. A representative fuel rod is modeled with BISON where the power density generated by Griffin is normalized to correspond to the average pin power. The coolant channel is modeled via a 1D model in SAM. This example provides all the functionalities required for scaling up to a full 3D model without having to provide any proprietary fuel and core dimensions.
