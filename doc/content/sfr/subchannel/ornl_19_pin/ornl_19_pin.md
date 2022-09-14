# Subchannel model for the Oakride National Laboratory (ORNL) 19-pin benchmark

*Contact: Mauricio Tano, mauricio.tanoretamales.at.inl.gov*

## Benchmark description

The ORNL 19-pin experiment was built at Oakride National Laboratory for studying the thermal-hydraulic flow characterisitics in SFRs assemblies as described in [!citep](fontana74).
The cross section of the experimental facility is depicted in [configuration].
The validation exercise was done for test series 2 of this experiement.
In this series, the fuel rods of the experiment were heated by 19 identical electric cartridges.
The configuration and external heat fluxes of this cartidges matches typical values expected for SFRs.
The measurements in test series 2 focused on the distribution of temperatures at the exit of the fuel assembly, the duct walls, and the rod bundle.
The nature of the heat source and the lack of neighboring assemblies assembly make the distribution of temperatures at the rod bundle and duct atypical for LMRs. 
Therefore, this data was deemed of secondary importance for validating the subchannel code.
In contrast, the distribution of temperatures at the exit of the fuel assembly is indicative of the heating of the coolant and flow mixing in the fuel bundle, which is expected to be representative of the one in an actual SFR.
Therefore, we have focused our validation work in predicting the distribution of temperatures at the exit of the fuel assembly.

!media subchannel/ORNL_19_configuration.png
       style=width:80%
       id=configuration
       caption=Left: heating rod positions for the experiment. Right: subchannel positions in the experiement.

The design parameters for the test series 2 of the ORNL 19-pin experiment are presented in [parameters].
Pressure is assumed to be constant at the outlet of the assembly and temperature and mass flux to be constant at its inlet.
The fuel bundle is divided between inlet, heated, and outlet sections along the rod in increasing elevation.
A nonzero linear heat rate is only assigned to the heated part of the rod, while no power is imposed at the inlet and outlet sections.

!table id=parameters caption=Design and operational parameters for ORNL's 19-pin benchmark.
| Experiment Parameter (unit) | Value  |
| :- | :- |
| Number of pins (-) | 19 |
| Rod Pitch (cm) | 0.726 |
| Rod Diameter (cm) | 0.584 |
| Wire wrap diameter (cm) | 0.142 |
| Wire wrap axial pitch (cm) | 30.48 |
| Flat-to-flat duct distance (cm) | 3.41 |
| Inlet length (cm) | 40.64 |
| Heated length (cm) | 53.34 |
| Outlet length (cm) | 7.62 |
| Outlet pressure (Pa) | 1.01E5 |
| Inlet Temperature (K) | 588.5 |
| Power profile (-) | Uniform |


Due to hexagonal symmetry in the experiment, the temperature distribution has been measured over the subchannels that approximately lie on a the diagonal line that connects the opposed vertices in the duct.
The orientation of the meassuring line connects the south-west vertex to the north-east one.
For our numbering convention, this lines includes subchannels 37, 36, 20, 10, 4, 1, 12, and 28.

Three different flow and heating configuration were evaluated for the experiment validation.
These configurations are summarized in [cases].

!table id=cases caption=Validation cases selected in the ORNL benchmark
| Naming | Run ID | Rod Power (W/cm) | Flow rate (m$^3$/s) | Reynolds number |
| :- | :- | :- | :- | :- |
| High flow rate | 022472-hf | 318.2 | 3.47E-03 | 6.72E4 |
| Medium flow rate | 020372 | 30.8 | 3.15E-04 | 7.35E3 |
| Low flow rate | 022472-lf | 4.9  | 4.67E-05 | 9.05E2 |

## Subchannel input

### General parameters

```language=bash

 T_in = 588.5
 flow_area = 0.0004980799633447909 #m2
 mass_flux_in = ${fparse 55*3.78541/10/60/flow_area}  # [1e+6 kg/m^2-hour] turns into kg/m^2-sec
 P_out = 2.0e5 # Pa

```

### Mesh

!listing sfr/subchannel/ornl_19_pin/ornl_19_pin.i block=TriSubChannelMesh language=cpp

!listing msr/msfr_coupled/transient/msfr_system_1d.i  block=EOS language=cpp

### Variables

### Modules

### Problem

### Initial Conditions

### Auxiliary Kernels

### Outputs

### Executioner

### MultiApp system

## Results

The key factor dominating the temperature profile in the outlet of the domain is the competing effect between heat convection and heat conduction in the coolant.
An example of the axial and lateral mass flow rates and the temperature and viscosity fields obtained for a high-flow-rate configuration in the ORNL 19-pin benchmark is presented in [3dres].
The flow rapidly develops over the assembly.
However, there is a significantly larger flow field in the outer gaps of the rod bundle.
This results in the outer rod and channels being colder than the center ones.
The temperature difference between outlet and inner subchannels increases with the increasing mass flow rate.
There is a small competing effect due to the viscosity in the center of the channels being smaller due to heating, but this effect is of second order compared with the flow driven by the pressure drop effects.
However, as mass flow decreases, heat conduction in the sodium coolant starts dominating over heat convection and, hence, the temperature profiles become flatter at the exit.
In summary, the temperature distribution measured at the outlet of the assembly can be regulated by the balance between convection and conduction, which is experimentally regulated by changing the axial mass flux and the power at the rod bundles.

!media subchannel/ORNL_19_results_3D.png
       style=width:80%
       id=3dres
       caption=Example of simulation results for the high-flow test case in the ORNL-19 benchmark. (a) Distribution of axial mass flow. (b) Distribution of lateral mass flow. (c) Distribution of temperature. (d) Distribution of dynamic viscosity due to heating.




!media subchannel/ORNL_19_results_plots.png
       style=width:55%
       id=plots
       caption=Comparison of results obtained for ORNL-19 pin case between experimental measurements, the SUBAC code, the MATRA-LMR code, and the current code. (a) High mass flow case. (b) Medium mass flow case. (c) Low mass flow case

## SFR model description

This VTB model provides an example representative of a Sodium cooled Fast Reactor (SFR) using metallic fuel.
Reactor core analyses of SFR require the modeling of multiple physics systems, such as:

- Neutron flux distribution throughout the core, obtained by solving the neutron transport equation.

- Coolant temperature and density distribution, obtained by solving the thermal-hydraulic equation system for the flowing sodium.

- Fuel temperature distribution, obtained by solving the heat conduction equation in the fuel rods.

- Due to the large temperature gradients occurring in SFR cores, thermal expansion plays a significant role and needs to be accounted for by computational models.

The proposed VTB multiphysics SFR model captures the predominant feedback mechanisms and consists of 4 independent application inputs:

1. A 3D Griffin neutronics model, whose main purpose is to compute the 3D neutron flux / power given the local field temperatures and mechanical deformations due to thermal expansion.

2. A 2D axisymmetric BISON model of the fuel rod which predicts the thermal response given a power density, as well as the thermal expansion occurring in the fuel/clad materials. The predicted quantities (fuel temperature, axial expansion in the fuel) are then passed back to the neutronics model. One BISON input is instantiated per fuel assembly.

3. A tensor mechanic input of the core support plate, predicting the stress-strain relationships given the inlet sodium temperature. The displacements are passed to the neutronics model to account for the radial displacements in the core geometry. Since the core support plate expansion is tied to the inlet temperature (fixed in this analysis), this model is only called once at the beginning of the simulation.

4. A SAM 1D channel input, whose purpose is to compute the coolant channel temperature / density profile and pressure drop, given the orifice strategy selected which dictates the input mass flow rate and outlet pressure and the wall temperature coming from the BISON thermal model. The coolant density and heat transfer coefficient is passed back to BISON to be used in a convective heat flux boundary condition. The coolant density is also passed back to the neutronics model for updating the cross sections. One SAM input is instantiated per coolant channel. The coupling scheme with the variables exchanged between solvers is given in [sfr_scheme].

!media sfr_scheme.png
       style=width:100%;margin-left:auto;margin-right:auto
       id=sfr_scheme
       caption=The coupling scheme used for the SFR model.

!alert note
Note: this model consists of one single assembly in 3D, with reflective boundary conditions radially for the neutronics model so as to mimic an infinite domain in the X and Y directions, and void boundary conditions axially. A representative fuel rod is modeled with BISON where the power density generated by Griffin is normalized to correspond to the average pin power. The coolant channel is modeled via a 1D model in SAM. This example provides all the functionalities required for scaling up to a full 3D model without having to provide any proprietary fuel and core dimensions.

## Griffin Model

### Griffin geometry

The geometry used in this test case contains a single 3D assembly for the neutronics model, coupled with a single 2D RZ BISON model for the thermo-mechanical model, as well as a 1D thermal-hydraulic channel model. The dimensions are non proprietary and representative of past and current SFR designs. The fuel assembly pitch is 12 cm, with 217 pins. Axially, the fuel is composed of a bottom reflector, a fuel region, a plenum region to accommodate fission gas releases, and a top reflector. The reflector regions are assumed to be each one meter, and the fuel rod is 2 meters: one meter for the rodded part, and one meter for the plenum region, leading to a fuel assembly height of 4 meters. The assembly mesh is displayed in [griffin_mesh]. A 2D core support plate model is also provided with the corresponding dimensions.

!media griffin_mesh.png
       style=width:40%;margin-left:auto;margin-right:auto
       id=griffin_mesh
       caption=Mesh used for Griffin. Red indicates the bottom and top axial reflectors. White corresponds to the fuel region.

### Griffin Cross Section Model for SFR

Cross sections for Griffin are provided for the 4 material required for this model (bottom reflector, fuel, plenum, top reflector). The cross sections are functionalized as a function of the fuel temperature, and coolant temperature.
Note that material density changes, due to mesh displacements from the core support plate model and the BISON mechanical model are also captured by the neutronics cross sections and thus the results (Keff, flux).
The cross section parametrization can be written using a functional formulation:
\begin{equation}
    \Sigma_{m,g}(\mathbf{r}) = f(T_{fuel},T_{cool})
\end{equation}
Where `f` is approximated by a piece-wise linear function that uses the local parameter values at each element of the mesh coming from the other physics models.
The grid selected for each parameter is:
 - $T_{fuel}=[600,900,1800]$ $K$.
 - $T_{cool}=[595,698,801]$ $K$

The maximum fuel temperature was selected to coincide with the value used for generating Doppler coefficient in the ARC reference calculation (1800 K), so as to avoid extrapolation. No changes in density was applied when varying the fuel temperature during the cross section generation process. It is justified since the BISON model in [#bison] will provide the change in fuel temperature. Changes in the fuel density, e.g. due to thermal expansion, will be accounted for by the mesh deformation capability of Griffin and will be presented later.

The change in coolant temperature is actually capturing the change in coolant density, and the cross sections were generated in Serpent by using the sodium density $\rho(T)$ corresponding to each temperature. The temperatures selected correspond to a $\pm$ 3% change in sodium density, which was arbitrarily selected to cover the perturbation range used for the sodium density coefficient (+1%). Using the sodium density correlation, a $\pm$ 3% change in density corresponds to $\mp$ 103 K. Both parameters could be then used in Griffin (either temperature or density, since density is a bijective function of the temperature), as long as the consistent data is passed from the thermal hydraulic model. Note that the Serpent model includes an axial variation in coolant density/temperature, corresponding for the nominal case to 623 K at the bottom inlet and bottom reflector region, 698 K in the active core region, and 773 K in the top region. The temperature axial profile is uniformly increased or decreased by a value corresponding to $T_{cool}^{region}\pm 103$ K for the perturbed cases.

## BISON thermo-mechanical model
  id=bison

There are multiple purposes for this model in this analysis. First, it captures changes in fuel temperature due to changes in power density, and thus is tightly coupled to the neutronics model, as a change in fuel temperature will change the multigroup cross sections, which will change the power density, and so forth. It also models the axial thermal expansion of the fuel rod resulting from an increase in the fuel temperature. The axial expansion of the fuel is also tightly coupled to the neutronics model, via a geometrical effect (increased fuel rod dimensions, thus increased leakage) combined with a density effect (less fissile material per volume), which will change the power density, thus the fuel temperature, and therefore the axial expansion itself. Solving both the heat conduction and the momentum conservation PDEs into a fully coupled approach by a single solve was found difficult from a numerical standpoint and often resulted in solve failures. A more robust approach was to dissociate the thermal feedback from the mechanical one. For each fuel assembly, two BISON inputs were thus created, sharing the exact same geometry but upon which different physics are solved:

1.  One input solving only the heat conduction problem across the fuel rod.

2.  One input modeling the mechanical expansion in the fuel and clad as a function of the temperature.

The 2D RZ mesh for the fuel rod is provided in [bison_mesh], with a refined view of the mesh for the fuel and cladding in [bison_mesh_zoomed].

!media bison_mesh.png
       style=width:10%;margin-left:auto;margin-right:auto
       id=bison_mesh
       caption=2D RZ mesh used for BISON.

!media bison_mesh_zoomed.png
       style=width:40%;margin-left:auto;margin-right:auto
       id=bison_mesh_zoomed
       caption=BISON mesh, zoomed. Red is fuel, white is cladding, green is cladding for use in boundary condition for SAM.

## SAM thermal-hydraulic model

A single channel model is used for this analysis, for which the inlet temperature and outlet pressure are imposed as boundary conditions.
The inlet mass flow rate and corresponding sodium velocity are also imposed and are representative of full power/flow conditions.
The mesh is 1D as shown in [sam_mesh].


!media sam_mesh.png
       style=width:100%;margin-left:auto;margin-right:auto
       id=sam_mesh
       caption=1D Mesh used for SAM.


## Core Support Plate Model

A 2D model of the core support plate is built using the MOOSE tensor mechanics module and is provided in [csp_mesh]. The displacements are connected to the neutronics model in the multiphysics scheme, so the thermal expansion of the core support plates leads to an increase in fuel assembly pitch, which leads to a decrease in reactivity.

!media core_plate_mesh.png
       style=width:50%;margin-left:auto;margin-right:auto
       id=csp_mesh
       caption=2D Mesh used for the Core Support Plate.



## How to run the model

The model relies on the BlueCrab app, which incorporates the different required applications (Griffin, BISON, SAM). Owing to the simplified geometry, the computational cost of this model is very small. Only one or two processors  are sufficient, and the solution should be obtained in less than a minute. The total number of Picard iterations is 5.

Run it via:

 `mpiexec -n 2 blue_crab-opt -i griffin.i`
