# Gas-cooled Microreactor Assembly Model Description

The Gas-Cooled Microreactor (GC-MR) assembly model was developed at ANL as a modeling experiment that gathers several expected modeling challenges encountered by the U.S. industry. The GC-MR assembly uses a graphite structure, TRISO fuel blocks with 19.95 at% LEU fuel, YH2 moderator pins with FeCrAl envelope, and upper/lower BeO reflector regions. Additional modeling specificities were implemented in the GC-MR such as burnable poison blocks, helium coolant channels and a central control and shutdown rod.
[Fig_1] illustrates the GC-MR assembly model.

!media media/gcmr/Fig_1.jpg
      style=display: block;margin-left:auto;margin-right:auto;width:80%;
      id=Fig_1
      caption= Description of the GC-MR assembly model

* Blocks contain both triangular and hexahedron elements*

The major technical parameters for the GC-MR assembly model are:

| Parameter (unit)| Value |
| - | - |
| Reactor Power (kWt) | 225 |
| Fuel | TRISO, 40% packing fraction |
| Coolant | He |
| Moderator (Coating, Envelope) | YH2 (Cr, FeCrAl) |
| Burnable poison absorber | B4C particles, 25% packing fraction |
| Control rod | B4C |
| Reflector | BeO |
| Inlet/ avg. outlet temperature (K) | 873.15/ 1133.65 |
| Pressure (MPa) | 7 |
| Inlet velocity (m/s) | 15 |
| Pin lattice pitch (cm) | 2.00 |
| Total height (cm) | 200 |
| Active height (cm) | 160 |
| TRISO fuel compact radius (cm) | 0.9 |
| Moderator compact radius (cm), density ($g/cm^{3}$) | 0.843, 4.085 |
| Cr coating thickness (cm), density ($g/cm^{3}$) | 0.007, 7.19 |
| FeCrAl envelope thickness (cm), density ($g/cm^{3}$) | 0.05, 7.055 |
| Burnable poison compact radius (cm) | 0.25 |
| Coolant compact radius (cm) | 0.6 |
| Control compact radius (cm) | 0.99 |

Both the TRISO and B4C poison particles are composed of concentric spherical regions. The particles are packed into graphite compacts. The TRISO particles have the following regions

| Region | Outer Radius (cm) | Density ($g/cm^{3}$) |
| - | - | - |
| UCO | 212.5E-4 | 10.744 |
| C (buffer) | 312.5E-4 | 1.04 |
| PyC1 | 352.5E-4 | 1.882 |
| SiC | 387.5E-4 | 3.171 |
| PyC2 | 427.5E-4 | 1.882 |

The B4C poison particles have the following regions

| Region | Outer Radius (cm) | Density ($g/cm^{3}$) |
| - | - | - |
| B4C | 100.0E-4  | 2.47 |
| C (buffer) | 118.0E-4 | 1.04 |
| PyC1 | 141.0E-4 | 1.882 |

The following thermal conductivities are used for modeling heat conduction. Certain materials have dedicated MOOSE (BISON) objects to represent their thermal properties as functions of temperature, while others can use a nominal value:

Either a specific value or a more detailed BISON model that computes thermal conductivity as a function of temperature is specified.

| Region |  Thermal Conductivity ($W/m-K$) |
| - | - |
| UCO | [UCOThermal BISON Model](https://mooseframework.inl.gov/bison/source/materials/UCOThermal.html) |
| C (buffer) | [BufferThermal BISON Model](https://mooseframework.inl.gov/bison/source/materials/BufferThermal.html) |
| PyC1 | 4.0 |
| SiC | [MonolithicSiCThermal](https://mooseframework.inl.gov/bison/source/materials/MonolithicSiCThermal.html) |
| PyC2 | 4.0 |
| B4C | 92 |
| YH2 | 20 |
| Cr coating | [ChromiumThermal](https://mooseframework.inl.gov/bison/source/materials/ChromiumThermal.html)|
| FeCrAl envelope | [FeCrAlThermal](https://mooseframework.inl.gov/bison/source/materials/FeCrAlThermal.html) |
| Graphite Matrix | [GraphiteMatrixThermal](https://mooseframework.inl.gov/bison/source/materials/GraphiteMatrixThermal.html) |
| BeO | [BeOThermal](https://mooseframework.inl.gov/bison/source/materials/BeOThermal.html) |

The [GraphiteMatrixThermal](https://mooseframework.inl.gov/bison/source/materials/GraphiteMatrixThermal.html) also provides various models for homogenizing TRISO into graphite.

The helium coolant has the following properties

| Property | Value | Units |
| - | - | - |
| Molar Mass | 0.004003 | $kg/mol$ |
| Dynamic Viscosity | 4.2926127588e-05 | $Pa-s$ |
| Thermal Conductivity | 0.338475615 | $W/m-K$ |
| $\gamma=\frac{c_{p}}{c_{v}}$ | 1.66 | - |
