#  Gas-Cooled High-Temperature Pebble-Bed Reactor Reference Plant Model

# Authorship:

1. Mustafa Jaradat: neutronics model development and Multiphysics analysis (INL).
2. Sebastian Schunert: conceptual development, code development, thermal fluids model development (INL).
3. Javier Ortensi: conceptual development, cross sections, Principal Investigator (INL).


# Design Description

The HTR-PM design is based on the combined experience from the German pebble-bed reactor program from the 1960s through the 1990s and the HTR-10 experience in China [!citep](zhang2016shandong).
The HTR-PM is 250 MWth reactor with the main characteristics include a cylindrical pebble-bed region surrounded by radial, lower, and upper reflectors made of graphite and it is gas cooled reactor. 
The radial reflector includes various orifices for the control rod channels, Kleine Absorber Kugel Systeme (KLAK) channels (shutdown system), and fluid riser channels.
This benchmark studies the HTR-PM core in equilibrium conditions and in depressurized loss of forced cooling (DLOFC) transient.
The benchmark problem uses information available on the open literature to develop an equilibrium model of the HTR-PM by depleting fresh core and considering Pebble loading and unloading from the core [!citep](reitsma2013pbmr).


The HTR-PM core specifications are as follows:

| Parameter | Value |
| :-------- |:-----:|
| Core power MWth                    | 250.00 |
| Core inlet temperature K           | 523.15 |
| Core outlet temperature K          | 1023.15 |
| Core outlet pressure MPa           | 7.0  |
| Pebble-bed radius m                | 1.50 |
| Pebble-bed height m                | 11.00 |
| Reflector outer radius m           | 2.50 |
| Control rods channels                | 24 |
| Reactivity Shutdown Channels         | 4 |
| Barrel outer radius m              | 2.69 |
| Bypass outer radius m              | 1.69 |
| Vessel outer radius m              | 3.00 |
| Number of pebbles                    | 419,384 (420,000) |
| Pebble types                         | 1 pebble type |
| Pebble packing fraction (average)    | 0.61 |
| Average number of passes             | 15 |
| Average pebble residence time days | 70.5 |


The HTR-PM pebble specifications are as follows:

| Parameter | Value |
| :-------- | :----:|
| Fueled region radius cm          | 2.5|
| Shell layer thickness cm         | 0.5|
| Pebble diameter cm               | 6.0|
| Heavy metal loading per pebble g | 6.95|
| Number of particles per pebble     | 11,668|
| Particle packing $\%$               | 7.034|
| Discharge burnup MWd/kg, J/m3    | 90, 4.82 $\times 10^{14}$|


The HTR-PM TRISO particle specifications are as follows

| Parameter | Value |
| :-------- | :----:|
| Fuel kernel radius cm | 0.025 |
| Buffer outer radius cm | 0.034 |
| IPyC outer radius cm | 0.038 |
| SiC outer radius cm | 0.0415 |
| OPyC outer radius cm | 0.0455 |
| Particle diameter cm | 0.091 |
| Fuel type | UO2 |
| Fuel enrichment | 8.6$\%$ |
| Fuel kernel density kg/m3 | 10,400 |
| Buffer graphite density kg/m3 | 1,100 |
| IPyC, OPyC graphite density kg/m3 | 1,900 |
| SiC density kg/m3 | 3,180 |


The benchmark model is composed of four elements. These are:
* Griffin neutronics model
* Griffin depletion model
* Pronghorn thermal-hydraulics model
* Pebble and TRISO temperature model


