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
