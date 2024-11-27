# BISON-FIPD Integration

To facilitate the use of the precious data stored in [!ac](FIPD) for BISON metallic fuel model V&V, efforts have been made on both [!ac](FIPD) and BISON sides through the [BISON-FIPD integration](https://mooseframework.inl.gov/bison/syntax/fipd_integration.html) project supported by [!ac](NEAMS) Fuel Performance Technical Area. The FIPD-based data as well as the related BISON/MOOSE classes used to handle those data are listed in [Table 1](#fipd_integration).

!table id=bison-fipd_integration caption=Use of BISON-FIPD Integration for the fuel performance simulation of Pin DP11
| FIPD-Based Data Type | Related BISON/MOOSE Class  | Category of Data |
| :- | :- | :- |
| Fuel Pin Design Data | [`FIPDRodletMeshGenerator`](https://mooseframework.inl.gov/bison/source/meshgenerators/FIPDRodletMeshGenerator.html) | Pin Design & Geometry |
| Time-Varying Pin-Averaged Power | [`PiecewiseLinear`](https://mooseframework.inl.gov/bison/source/functions/PiecewiseLinear.html) | Irradiation Conditions |
| Time-Varying Pin-Averaged Fast Neutron Flux | [`PiecewiseLinear`](https://mooseframework.inl.gov/bison/source/functions/PiecewiseLinear.html) | Irradiation Conditions |
| Power Peaking Factor | [`FIPDAxialProfileFunction`](https://mooseframework.inl.gov/bison/source/functions/FIPDAxialProfileFunction.html) | Irradiation Conditions |
| Fast Neutron Flux Peaking Factor | [`FIPDAxialProfileFunction`](https://mooseframework.inl.gov/bison/source/functions/FIPDAxialProfileFunction.html) | Irradiation Conditions |
| Time-Varying Cladding Outer Surface Temperature | [`FIPDAxialProfileFunction`](https://mooseframework.inl.gov/bison/source/functions/FIPDAxialProfileFunction.html) | Irradiation Conditions |
| Axial-Dependent Cladding Strain | [`FIPDAxialPIEComparison`](https://mooseframework.inl.gov/bison/source/vectorpostprocessors/FIPDAxialPIEComparison.html) | Post-Irradiation Examination Data |

Unlike other metallic fuel pins irradiated during the [!ac](IFR) program, all the related data needed for BISON fuel performance are already available in open literature for Pin DP11. Hence, access to [!ac](FIPD) is not required for this VTB model. =+Instead, all the openly available data needed to run the BISON fuel performance simulation for Pin DP11 are provided in the same format as provided in [!ac](FIPD) so that this VTB model also works as a demonstration case for BISON-FIPD Integration powered BISON metallic fuel model V&V.+=

!media media/ebr2_x447_dp11/dp11_power.png
       id=dp11_power
       caption=Time and axial dependent power profile for pin DP11.
       style=display: block;margin-left:auto;margin-right:auto;width:50%;

## Pin Design Data 

The fuel pin design data of DP11 are provided as a CSV file with the same format as the pin design data file available in [!ac](FIPD). Note that the pin design data items that are not used by BISON or not openly available have been removed. This CSV file that contains the essential pin design data for Pin DP11 is read by BISON's [`FIPDRodletMeshGenerator`](https://mooseframework.inl.gov/bison/source/meshgenerators/FIPDRodletMeshGenerator.html) to generate the axisymmetric 2D mesh as well as the corresponding `MeshMetaData`.

## Operating Conditions and Irradiation History

!media media/ebr2_x447_dp11/dp11_flux.png
       id=dp11_flux
       caption=Time and axial dependent fast neutron flux profile for pin DP11.
       style=display: block;margin-left:auto;margin-right:auto;width:50%;

Calculated pin-by-pin operating conditions data are used in this VTB model. For each pin, time-varying pin-averaged power and fast neutron flux information are used along with corresponding axial peaking factors to provide complete time and axial dependent irradiation condition profiles (see [dp11_power] and [dp11_flux]). Here, the power profile is used as the heat source and then to deduce fuel depletion (burnup) for other models, while the fast neutron flux profile is used to account for irradiation effects especially the irradiation creep of the cladding.

Both power and fast neutron flux data are provided in the form of two separate CSV files, respectively: a time-dependent average power/flux CSV file in the standard format that can be directly loaded by MOOSE's intrinsic [`PiecewiseLinear`](https://mooseframework.inl.gov/bison/source/functions/PiecewiseLinear.html) Function class, and a peaking profile CSV file that can be loaded by BISON's dedicated [`FIPDAxialProfileFunction`](https://mooseframework.inl.gov/bison/source/functions/FIPDAxialProfileFunction.html). These data are consistent with the data of Pin DP11 reported previously [!citep](Miao2021X447).

!media media/ebr2_x447_dp11/dp11_odtemp.png
       id=dp11_odtemp
       caption=Time and axial dependent outer surface temperature profile for pin DP11.
       style=display: block;margin-left:auto;margin-right:auto;width:50%;

Due to the existence of the dummy pins and pin reconstitution in the experiment X447, BISON's intrinsic coolant channel models (i.e., the generic [`CoolantChannelAction`](https://mooseframework.inl.gov/bison/source/actions/CoolantChannelAction.html) and the specific [`SodiumCoolantChannel`](https://mooseframework.inl.gov/bison/source/materials/SodiumCoolantChannelMaterial.html)) might not make the best prediction, especially when the neighboring fuel pins have dissimilar power profiles. In that case, time-varying cladding outer surface temperature available in the FIPD database, which is calculated by thermal hydraulics code SuperEnergy2 [!citep](BASEHORE1980SE2), is used directly as the temperature boundary conditions (see [dp11_odtemp]).

The time-varying cladding outer surface temperature is provided as a single CSV file for Pin DP11, which can also be read by [`FIPDAxialProfileFunction`](https://mooseframework.inl.gov/bison/source/functions/FIPDAxialProfileFunction.html).

## [!ac](PIE)

The main focus of this VTB model is the consequences of cladding degradation due to the [!ac](FCCI)/[!ac](CCCI) development, which is the deformation and failure of the HT9 cladding. The damage/failure of the cladding is usually quantified by cumulative damage fraction (CDF), which is a statistical and virtual quantity that cannot be directly measured. Therefore, the major experimentally measured data that are valuable here are the deformation profiles of the HT9 cladding. The cladding deformation of Pin DP11 was measured by contact profilometry. The digitized data have been reported [!citep](Pahl1993X447) and are available in [!ac](FIPD). The data is used in this VTB model for assessing the cladding deformation predicted by BISON.

The cladding strain profile based on profilometry measurement is provided in a single CSV file for Pin DP11. The data can be loaded by [`FIPDAxialPIEComparison`](https://mooseframework.inl.gov/bison/source/vectorpostprocessors/FIPDAxialPIEComparison.html) to be directly compared with the BISON predictions.

In addition to the cladding deformation information, additional relevant information is revealed by other [!ac](PIE) approaches. Fission gas analysis of an irradiated pin shows the percentage of fission gas generated within the fuel is released into the plenum. The [!ac](NRAD) can be used to measure the axial growth of the fuel slug. More importantly, the irradiated pin is sectioned at several axial positions of interest. The cross sections are then polished and etched for metallography, which can be used to measure the wastage thickness of both [!ac](FCCI) and [!ac](CCCI). All of the aforementioned [!ac](PIE) data, which are also available in [!ac](FIPD), are also used as reference in this VTB model.

!style halign=right
[Go to +Next Section: Fuel Performance Models+](/dp11_models.md)
