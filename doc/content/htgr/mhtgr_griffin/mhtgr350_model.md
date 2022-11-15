# MHTGR Numerical Benchmark

## Benchmark Description id=benchmark

*Contact: Javier Ortensi, javier.ortensi.at.inl.gov

The MHTGR-350 is a benchmark problem organized by the OECD/NEA ([!cite](mhtgr_benchmark)).
The scope of the benchmark is twofold: 1) to establish a well-defined problem, based on a
common given data set, to compare methods and tools in core simulation and thermal fluids
analysis through a set of multi-dimensional computational test problems, 2) to test the depletion
capabilities of various lattice physics codes available for prismatic reactors.
The steady-state benchmark calculations are split into three exercises as detailed below.

- Exercise 1: Neutronics solution with fixed cross sections.

- Exercise 2: Thermal fluids solution with given power/heat sources.

- Exercise 3: Coupled neutronics -- thermal fluids steady-state solution.

!alert note
The MHTGR-350 model on the VTB only covers [Exercise 1](#exercise1).
In this exercise, the cross-section set is given with no state parameter dependence.
Both hexagonal and triangular meshes were submitted for the benchmark, however, the
[triangular mesh](#comp_mesh) will only be reported here.
A more detailed description of the steady-state benchmark can be found in
Volume II of [!cite](mhtgr_benchmark).

## Historical Context id=history

The prismatic modular reactor (PMR) is one of several
high-temperature reactor (HTR) design concepts that have existed for decades.
Several prismatic units have operated in the world (Dragon, Fort Saint Vrain
and Peach Bottom) and one unit is still in operation
-- the High Temperature Test Reactor (HTTR) -- in Japan.
The deterministic neutronics, thermal fluids, and transient analysis tools
and methods available to design and analyze PMRs have, in many cases,
lagged behind the state of the art compared to other reactor technologies.
This delay is driving the testing of existing methods for high-temperature
gas-cooled reactors, as well as the development of more accurate and
efficient tools to analyze the neutronics and thermal-fluid behavior
for the design and safety evaluations of the PMR.
In addition to the development of new methods,
the exercise includes the definition of an appropriate benchmark
to perform code comparisons of such new methods.

Benchmark exercises provide some of the best avenues for better understanding current
analysis tools.
A very good example was the PBMR Coupled Neutronics/Thermal Hydraulics
Transient Benchmark for the PBMR-400 Core Design ([!cite](PBMR400)), which served as the foundation for the
MHTGR-350 benchmark.
The purpose of this exercise is to identify significant differences between neutronics models
used in determining key integral parameters and between distributions in prismatic HTRs.
An important issue in the prismatic neutronics HTR community is the treatment of control rods (CRs) in full core
modelling and simulation.
Two spatial homogenizations (hexagonal and triangular) of the CRs are included in the present benchmark.

## The MHTGR-350 core description id=core

The reference design is based on the modular high-temperature gas-cooled reactor
(MHTGR) 350-MW core design developed in the 1980s at General Atomics.
This annular core configuration was selected, along with the average power
density of 5.9 MW/m$^3$, to achieve maximum power rating and still permit
passive core heat removal while maintaining the silicon carbide temperature
below 600 $^\circ$C during a conduction cooldown event.
The benchmark specification employs a simplified model of the reactor design.
The axial and radial core layouts of this simplified model are presented in
[axial_core] and [radial_core].
The active core consists of hexagonal graphite fuel elements containing blind holes for
fuel compacts and full-length channels for helium coolant flow.
The fuel elements are stacked to form columns (10 fuel elements per column) that rest on
support structures.
The active core columns form a three-row annulus with columns of hexagonal graphite
reflector elements in the inner and outer regions.
Thirty reflector columns contain channels for CRs, and 12 columns in the core also
contain channels for the reserve shutdown material.
In the active core region, the standard blocks are red and the CR blocks are orange.
The replaceable reflectors are shown in grey and the permanent reflectors in green.
The yellow dashed lines depict the limit of the solution domain for the
neutron transport problem.

!media axial_core_layout.png
       style=width:50%;margin-left:auto;margin-right:auto
       id=axial_core
       caption=Axial core layout (neutronic boundary shown in yellow) ([!cite](mhtgr_benchmark)).

!media radial_core_layout.png
       style=width:50%;margin-left:auto;margin-right:auto
       id=radial_core
       caption=Radial core layout (neutronic boundary shown in yellow) ([!cite](mhtgr_benchmark)).

## Description of Exercise 1 id=exercise1

The benchmark employs a three-dimensional one-third symmetric representation of the core.
The cross-sections for the model were developed with DRAGON-4 using fine group
libraries based on the ENDF/B-VII.r0 data set.
General Atomics provided the end of equilibrium cycle (EOEC) core number densities.
The active core is comprised of 22 radial and 10 axial regions (physical blocks).
There are separate cross-sections for each of the 220 active core regions, 11 reflector regions and 1 CR region.
The power generated is assumed at 200 MeV per fission event.
It should be noted that, traditionally, equivalence parameters  either super homogenization
or discontinuity factors  are provided for this type of calculations in light water reactors
to correct for the homogenization error.
The development of appropriate equivalence parameters for this core would entail the use of
larger spatial domains or full core reference transport calculations.
Since the cross-sections originate from single block lattice calculations,
no attempt was made to preserve the reaction rates in the fuel blocks.
It is well established that lattice fuel block calculations for HTRs with low-enriched uranium
produce cross-sections that lead to larger errors in regions near the reflectors and, in this
reactor design, a significant number of fuel blocks are located next to the reflectors.
Instead, the preferred way to alleviate some of the error in the cross-sections is to allow better
spectrum information to be transferred in the full core calculations by using a
large number of coarse energy groups, for example with 26 groups in this case.
The two spatial homogenizations of the CRs are shown in [cr_homogenization].
The first approach ([cr_homogenization] (b)) is to homogenize the CR entirely with the rest of the fuel block,
whereas in the second approach ([cr_homogenization] (c)), the CR is homogenized over a one-sixth region of the block.
The homogenization of the CR is important, and ideally, it should be homogenized in isolation
from fuel to minimize errors in the computation of the absorption and fission reaction rates,
especially for depletion calculations.

!media homogenization_schemes.png
       style=width:50%;margin-left:auto;margin-right:auto
       id=cr_homogenization
       caption=Homogenisation of the CR (homogenization region with yellow highlight) ([!cite](mhtgr_benchmark)).

The fuel loading pattern for this core is included in [fuel_loading], which will aid in the
understanding of the various power and flux distributions discussed in this report.
Since the core number densities used in the cross-section preparation were obtained for an EOEC
core, the locations labelled A (red) correspond to once-burned fuel, whereas twice-burned fuel is in B (blue) locations.

!media fuel_loading.png
       style=width:40%;margin-left:auto;margin-right:auto
       id=fuel_loading
       caption=Fuel loading pattern ([!cite](mhtgr_benchmark)).

## Benchmark Participants id=participants

Seven participants and solutions from nine computer codes were submitted for this portion
of the benchmark. The list of participants and computer codes are shown in [participants].

!table id=participants caption=List of participants and transport codes used.
| Organization \\ label | Organization | Codes used in \\ calculations | CR Homogenization | Method | Country |
|            -          |      -       |              -                |         -         |   -    |    -    |
|  INL  | Idaho National Laboratory | INSTANT \\ [!style color=orange](Rattlesnake*) | Full, one-sixth \\ Full, one-sixth | Hybrid finite element method (FEM) $P_N$ transport \\ FEM diffusion | US |
| UMICH | University of Michigan | PARCS | Full | Nodal expansion method (NEM) diffusion | US |
| KAERI | Korea Atomic Energy Research Institute | CAPP | Full, one-sixth | FEM diffusion | Korea |
| SNU   | Seoul National University | McCARD | Full, one-sixth | Multi-group (MG) Monte Carlo transport | Korea |
| UNIST | Ulsan National Institute of Science and Technology | MCS | Full, one-sixth | MG Monte Carlo transport | Korea |
| HZDR  | Helmholtz-Sentrum Dresden-Rossendorf | DYN3D | Full | Nodal simplified $P_N$ transport | Germany |
| GRS   | Gesellschaft fur Anlagen-und Reaktorsicherheit | DIF3D \\ PARCS | Full, one-sixth \\ Full | Finite volume diffusion \\ NEM diffusion | Germany |

!alert note
[!style color=orange](*Rattlesnake) has been merged into Griffin, a joint venture between INL and ANL.
Griffin development began as a combination of INL's MAMMOTH and Rattlesnake codes.
In order to expand Griffin's capabilities, methods utilized in the ANL codes
PROTEUS, MC2-3, and Cross Section Application Programming Interface (CSAPI) are being integrated in Griffin.

