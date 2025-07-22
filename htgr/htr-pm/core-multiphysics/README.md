#  Gas-Cooled High-Temperature Pebble-Bed Reactor Reference Plant Model

# Authorship:
1. Mustafa Jaradat: neutronics model development and Multiphysics analysis (INL).
2. Sebastian Schunert: conceptual development, code development, thermal fluids model development (INL).
3. Javier Ortensi: conceptual development, cross sections, Principal Investigator (INL).


# Design Description

The HTR-PM design is based on the combined experience from the German pebble-bed reactor program from the 1960s through the 1990s and the HTR-10 experience in China [Ref.1].
We selected the HTR-PM reactor for this study because of 
1. The availability of open literature data
2. it is the only pebble-bed reactor currently in operation
3. its design is contemporaneous with past concepts.

The HTR-PM is 250 MWth reactor with the main characteristics include a cylindrical pebble-bed region surrounded by radial, lower, and upper reflectors made of graphite and it is gas cooled reactor. 
The radial reflector includes various orifices for the control rod channels, \acrfull{klak} channels (shutdown system), and fluid riser channels. 

The Pebble-bed has a radius of 1.5 m and a height of 11.0 m with reflector outer radius of 2.5 m.
The core inlet/outlet temperatures are 523 K / 1023 K.
In this benchmark problem, we used information available on the open literature to develop an equilibrium model of the HTR-PM by depleting fresh core and considering Pebble loading and unloading from the core [Ref.3].

<p align="center">
  <img src="doc_include/htr-pm-domain.png" align="center" width=40% height=40%>
</p>

# Applications Utilizied

The model uses BlueCRAB with following applications:
1. Griffin: Neutronics & Pebble depletion
2. BISON: Pebble conduction
3. Pronghorn: Thermal fluids  

# Model Description

## Reactor Physics

In the reactor physics modeling we consider the preparation of cross sections, and the development of the equilibrium core model.

### Cross Sections

The cross-section preparation capability for PBRs in Griffin is not currently available. We relied on the lattice code DRAGON [Ref. 3] to prepare microscopic cross sections in this work. 

The DRAGON data libraries used in this work are based on the ENDF/B-VIII.r0 evaluation. For the neutron self-shielding method, the SHEM 281 group library was used with the subgroup projection method [Ref. 4]. The double heterogeneity treatment is based on the H\'ebert method. A \acrfull{cccp} flux solution is used for spatial homogenization and energy condensation of microscopic cross sections. The intra-core neutron leakage affects the local spectrum significantly, and it will have an impact on the cross-section homogenization. Nevertheless, this approach with the generated cross sections serves as an initial set to perform preliminary calculations until more sophisticated methods are available in Griffin. 

### Neutronics Model

A neutronics model of the HTR-PM core was developed with Griffin using an axisymmetric (R-Z) geometry with homogenized core regions. Griffin solves steady-state neutron diffusion equation and pebble   streamline calculations which solves 1D streamline advection transmutation equation for pebble depletion.

The Griffin model uses six equally spaced streamlines to represent pebble depletion that are centered within the active core elements. The streamlines are located at radii of $r=12.5, 37.5, 62.5, 87.5, 112.5, 137.5$ cm. Pebble velocity is assumed to be uniform so that the fraction of the volumetric flow rate of pebbles through each channel is proportional to the channel area. The six channels are straight down and end at the bottom of the pebble bed. 

The heavy metal loading of $7$ g per pebble, the average discharge burnup of $90$ MWd/kg, the average power density, and the packing fraction of $0.61$, the total irradiation time in the core is estimated to be $1,055$ days, which corresponds to $70$ days per pass in the 15-pass core design The pebble speed ($15.6$ cm/d) and pebble reloading rates ($5,949$ pebbles per day). The discharge burnup of $90$~MWd/kg or $4.82E+14$ $J/m^3$. A total of 10 burnup groups forms the base discretization of the burnup variable. 

The local decay heat power in Griffin is computed from the decay released by fission products as a function of time along with provided by the neutron transmutation and decay chain.

## Thermal Fluids Model

The thermal-hydraulics model for Pronghorn is based on ongoing NEAMS work [Ref. 5] with some additional improvements. The Pronghorn model uses the weakly compressible finite volume formulation for discretizing the fluid mass, fluid momentum, fluid energy, and solid energy conservation equations. The model includes a riser and bypass flow channels, and the fueling chute as an open flow region.


The cold fluid from the circulators enters the core via the vertical risers in the reflector region. The flow then enters the cold plenum, where the flow is diverted into the cavity, upper reflector, and control and shutdown system bypass channels. From the upper cavity, the fluid enters the active core region, then the lower reflector, and finally the outlet plenum.


The radiative heat transfer at the outer boundary of the reactor vessel has a small impact on steady-state calculations and a larger impact during the loss of forced cooling (DLOFC) transients. Also, during the loss of flow transient, fluid inflow and outflow boundary conditions are not changed to wall boundary conditions, which leads to a significant change in the helium leaving the core due to thermal expansion, which tends to increase temperature estimates.

## Pebble Conduction Model:

The pebble heat conduction model solves the 1D spherical conduction problem assuming a thermal equilibrium approximation in pebble simulations during transient calculations.


Several sources of heat transfer nonuniformity around the pebble were ignored: the coolant flow orientation, pebble-to-pebble contact, pebble-to-reflector contact, and radiation.


A Dirichlet boundary condition is set at the TRISO surface to obtain the fuel temperature, and a Neumann boundary condition would improve energy conservation.

<p align="center">
  <img src="doc_include/apps_setup_3.png" align="center" width=50% height=50%>
</p>

# Files

## Cross Section File

The cross-section files are located under "\HTR_PM_PD\xsections\HTR-PM_9G-Tnew.xml.tar.gz".
first you need to unzip the compressed file using the following command

tar -zxvf HTR-PM_9G-Tnew.xml.tar.gz

The transmutation and decay chain file is located under "HTR_PM_PD\xsections\DRAGON5_DT.xml".

The cross sections were prepared in 9 energy group structure and the transmutaion and decay chain has 295 isotopes. 

## Input Files

The steady-state equilibrium core model consists of three main components coupled to perform equilibrium core calculations and to establish initial condition for transient analyses. 
The transient model consists of three main components coupled to perform transient calculations and it is restarted from steady-state solution of the equilibrium core. 

1. Neutronics / Griffin: solves steady-state or time dependent neutron diffusion equation. 
2. Thermal Hydraulics / Pronghorn: solves time dependent mass, momentum, and energy equations in porous media. 
3. Pebble Temperature / moose heat conduction: solves steady-state heat conduction equation in spherical geometry to obtain pebble temperatures at each time step.


### Equilibrium Core / Steady State Input Files

1. "htr_pm_neutronics_ss.i"       : Griffin steady state neutron diffusion model.
2. "depletion_sub.i"              : Griffin pebble depletion model.
2. "htr-pm-flow-fv-ss.i"          : Pronghorn thermal fluids steady state or Pseudo transient model.
3. "pebble_triso.i"               : Pebble steady state heat conduction model.

### Updated Equilibrium Core / Steady State Input Files

An updated model was developed for the current HTR-PM model and it is located under: "/HTR_PM_PD/updated_equilibrium_core/". The main difference of the updated model is more user friendly and shorter in length which make it easier to follow.

1. "htr_pm_neutronics_ss.i"       : Griffin steady state diffusion and pebble depletion model.
2. "htr-pm-flow-fv-ss.i"          : Pronghorn thermal fluids steady state or Pseudo transient model.
3. "pebble_triso.i"               : Pebble steady state heat conduction model.

### Transient Input Files

1. "htr_pm_neutronics_tr_null.i"  : Griffin null transient model.
2. "htr-pm-flow-fv-tr-null.i"     : Pronghorn null transient model.
3. "htr_pm_neutronics_tr_dlofc.i" : Griffin DLOFC transient model.
4. "htr-pm-flow-fv-tr-dlofc.i"    : Pronghorn DLOFC transient model.

# Execution

First load the blue_crab module as 

module load use.moose moose-apps blue_crab

## Input Execution

The execution lines for the equilibrium core calculations, null transient, and DLOFC transient 

1. mpirun -np 48 blue_crab-opt -i  htr_pm_neutronics_ss.i
2. mpirun -np 48 blue_crab-opt -i  htr_pm_neutronics_tr_null.i
3. mpirun -np 48 blue_crab-opt -i  htr_pm_neutronics_tr_dlofc.i

Note that the steady state solution should be provided before running any transient calculations to setup initial conditions.


# Steady State Coupled Solution

The steady state solutions of the equilibrium are shown in the figure below for power density, peak power, decay power, U-235 and Pu-239 nuclide distributions in the core region. Also, the fluid and solid temperature distributions along with velocity and pressure fields are provided. The current steady state equilibrium core model has
1. An eigenvalue of 0.99580.
2. Peak power 2.00.
3. Fuel average temperature of 625.82 °C (898.97 K).
3. Fuel maximum temperature of 851.40 °C (1124.55 K).
5. Decay heat fraction of 6.426%.

<p align="center">
  <img src="doc_include/ss_neutronics_distributions.png" align="center" width=40.0% height=40%>
</p>
<p align="center">
  <img src="doc_include/ss_TH_distributions.png" align="center" width=40% height=40%>
</p>

# Depressurized Loss of Forced Cooling Transient (DLOFC)

The DLOFC transient simulation was initiated by [Ref.3]
1. Reducing the mass flow rate of the coolant linearly from its nominal value to zero over thirteen seconds. 
2. The system pressure was reduced linearly from 7.0 MPa to atmospheric pressure (0.101 MPa).
3.  the control rods were fully inserted (SCRAM) to shutdown the reactor after completing the flow rate and pressure ramps. 
4. Beyond that, there were no changes to the system's  main parameters, and the simulation was performed for up to 140 hours. 

During the DLOFC transient simulation, coupled neutronics and thermal-hydraulics calculations were performed and The following progression of the reactor parameters was observed during the transient:
1. The reactor power starts decreasing at the beginning of the transient due to the negative thermal feedback.
2. The prompt power goes to zero while the remaining reactor power is just the decay heat component of the fuel. 
3. The maximum fluid and solid temperatures start moving axially and toward the top of the core.
4. Temperature distributions change mainly in the radial direction, and there is a significant change in the solid temperature of the reflector and RPV regions.
5. The maximum fuel temperature reaches 1503.26 °C (1776.41 K) during DLOFC transient compared to the reference results which is around 1500 °C [Ref.4 and 5].

The figure below shows the fuel and solid temperatures evolution are provided.

<p align="center">
  <img src="doc_include/dlofc_fuel_temp.png" align="center" width=40% height=40%>
</p>
<p align="center">
  <img src="doc_include/dlofc_solid_temp_field.png" align="center" width=40% height=40%>
</p>


# References: 

1. Z. Zhang, et al, “The shandong shidao bay 200 mwe high-temperature gas-cooled reactor pebble-bed module (htr-pm) demonstration power plant: An engineering and technological innovation,” Engineering, vol. 2, pp. 112–118, 03 2016.
2. D. Tian, L. Shi, L. Sun, Z. Zhang, Z. Zhang, and Z. Zhang, “Installation of the graphite internals in htr-pm,” Nuclear Engineering and Design, vol. 363, p. 110585, 2020.
3. PBMR Coupled Neutronics / Thermal-hydraulics Transient Benchmark The PBMR-400 Core Design, Volume 1, The Benchmark Definition, NEA/NSC/DOC(2013)10, July 2013. 
4. Yanhua, Z., et al., 2018. Study on the DLOFC and PLOFC accidents of the 200 MWe pebble-bed modular high temperature gas-cooled reactor with TINTE and SPECTRA codes. Annals of Nuclear Energy 120 (2018) 763–777. 
5. Strydom, G., 2008. TINTE Transient Results for the OECD 400 MW PBMR Benchmark, Proceedings of ICAPP ’08, Anaheim, CA USA, June 8-12, 2008.




