# Sodium-cooled Thermal-spectrum Advanced Research Test Reactor (STARTR)

STARTR is a "starter" Sodium-cooled Thermal Spectrum (STR) reactor, modeled using publicly available Microreactor Applications Research Validation and Evaluation (MARVEL) reactor specifications where possible and approximations where applicable. Simple and optimized for runtime, STARTR is intended for rapid design iteration to understand STR microreactor physics and sensitivities.

## Basic Geometry

STARTR utilizes uranium-zirconium hydride (UZrH) as the fuel meat, where uranium comprises 30 wt% and is enriched to 19.75% U-235, standard in Training, Research, Isotopes, General Atomics (TRIGA) fuel rods. STARTR modifies a standard TRIGA fuel rod slightly by including five pellets of UZrH instead of the standard three. STARTR houses 36 fuel rods arranged in a hexagonal lattice, with one empty fuel rod located at the center of the reactor. Surrounding the fuel rods in a hexagon is sodium coolant, and the gap between this hexagon and the vessel wall is surrounded by metallic beryllium. Finally, outside the vessel is a stationary reflector made of beryllium oxide and four control drums that contain 120 degree sections of boron carbide poison. The control drums are withdrawn synchronously counter-clockwise to control the reactivity. 

!media xy-root-universe.png
	id=root
	caption=STARTR reactor geometry
	style=width:80%;margin-left:auto;margin-right:auto

Both the OpenMC and MCNP models are coded for k-eigenvalue problems as posted on the VTB, but tallies can easily be applied for more detailed analysis as performed on the results page.

## Materials

The summary of all materials used in the model are listed below. The complex materials table includes materials with percent compositions of elements that can vary based on the specifics of manufacturing. The materials in the simple table have defined integer chemical compositions.

!table id=table1 caption=Complex STARTR Materials
| Material | Element | wt%  | Density [g/cc] |
| :- | :- | :- | :- |
| UZrH     | Zr      | 68.8 | 7.135          |
|          | U-238   | 24.1 |                |
|          | U-235   | 5.90 |                |
|          | H       | 1.20 |                |
| SS 304   | Fe      | 69.5 | 7.93           |
|          | Cr      | 19.0 |                |
|          | Ni      | 9.50 |                |
|          | Mn      | 2.00 |                |

!table id=table2 caption=Simple STARTR Materials
| Material        | Density [g/cc] |
| :- | :- |
| Zirconium       | 6.51           |
| Graphite        | 1.70           |
| Molybdenum      | 10.22          |
| Sodium          | Varies         |
| Boron Carbide   | 2.52           |
| Beryllium       | 3.01           |
| Beryllium Oxide | 1.85           |

The density of sodium is calculated as
\begin{equation}
\label{eq:na-density}
\rho\ [g/cc] = 0.9501 - 2.297t\times10^{-4} - 1.46t^2\times10^{-8} + 5.638t^3\times10^{-12}
\end{equation}

where $t$ is the temperature in degrees celsius [!citep](NaK1972). It is the only liquid material in the model, and thus experiences a density change significant enough to warrant inclusion of its temperature dependence.

Details of the geometry construction are too verbose to include here, the OpenMC and MCNP inputs are commented throughout with explanations of the geometry construction and references where applicable.

There is one unresolved open item for the MCNP and OpenMC analysis of STARTR. There are significant and unexpected differences in the calculated control drum worths for MCNP compared to OpenMC for partially rotated control drum positions. Due to time and funding restraints, the models are being released with this open item unresolved and will be updated when additional analysis can be made to identify the source of the differences. 
