# Neutronic Modeling of the Whole Core Gas-Cooled Microreactor (GCMR)

*Contacts: Ahmed Abdelhameed (aabdelhameed.at.anl.gov), Yinbin Miao (ymiao.at.anl.gov), Nicolas Stauff (nstauff.at.anl.gov)*

*Model link: [GCMR Whole Core Neutronics](https://github.com/idaholab/virtual_test_bed/tree/main/microreactors/gcmr/core)*

!tag name=Gas-Cooled Microreactor Core
     description=2D core model of a Gas Cooled Micro Reactor with heterogeneous transport
     image=https://mooseframework.inl.gov/virtual_test_bed/media/gcmr/Fig12.jpg
     pairs=reactor_type:microreactor
            reactor:GCMR
            geometry:core
            simulation_type:neutronics
            V_and_V:verification
            codes_used:Griffin
            transient:steady_state
            computing_needs:HPC
            institution:ANL
            sponsor:NEAMS
            fiscal_year:2024

## GCMR Core Description

The GCMR model, developed at ANL, serves as a modeling experiment to explore design options considered by microreactor vendors, encompassing features like control drums, hydride metal, and TRISO fuel. This horizontal gas-cooled microreactor system boasts a thermal power of 20 MW and an approximate lifespan of 9.5 years. Its power conversion cycle utilizes a Brayton cycle, circulating high-temperature (650°C-850°C) and high-pressure (7 MPa) helium coolant. Surrounding the core are BeO radial and axial neutron reflectors, with twelve control drums positioned in the reflector encircling the core. These control rods, containing 96%-enriched B4C, are inserted into holes within the middle core assemblies. Displayed in [Fig_1] and [Fig_2]  are radial and axial views of the core, which is relatively compact, measuring 2.42 m in diameter and 2.40 m in length.


!media media/gcmr/Fig12.jpg
      id=Fig_1
      style=display: block;margin-left:auto;margin-right:auto;width:60%;
      caption=Radial View of the GCMR core



!media media/gcmr/Fig13.jpg
      id=Fig_2
      style=display: block;margin-left:auto;margin-right:auto;width:60%;
      caption= Axial view of the GCMR core



The core comprises three types of fuel assemblies: Assembly A in the inner region, Assembly B in the middle, and Assembly C in the outer core region. Each fuel assembly incorporates TRISO fuel blocks containing 19.75 wt% of LEU fuel and Yttrium hydride moderator pins encased in FeCrAl envelopes. Additionally, burnable poison blocks, composed of Gd2O3 particles with a 25% packing fraction distributed axially, and Helium coolant channels are integrated. Assembly A's detailed design is provided in [Fig_3], while [Fig_4] illustrates the design differences among the three assemblies. Assemblies B and C are nearly identical, except for the presence of a central shutdown rod location in assembly B. Each of assemblies B and C is equipped with 6 burnable poison rods, 6 moderator pins, and 48 fuel rods. In contrast, Assembly A contains 12 burnable poison rods and 42 fuel rods. The key design parameters of the GCMR core comprise of:



!media media/gcmr/Fig14.jpg
      id=Fig_3
      style=display: block;margin-left:auto;margin-right:auto;width:60%;
      caption= GCMR assembly of Type A



!media media/gcmr/Fig15.jpg
      id=Fig_4
      caption= Design of the three types of fuel assemblies in the core



| Parameter (unit)| Value |
| - | - |
| Reactor Power (MWth) | 20.0 |
| Core diameter (cm) | 242.0 |
| Core height (cm) | 240.0 |
| Active height (cm) | 200.0 |
| Different radial core zones | 3 |
| Number of control drums | 12 |
| Lattice pitch (cm) | 20.8 |
| Pin pitch (cm) | 2.0 |
| TRISO fuel compact radius (cm) | 0.85 |
| Moderator compact radius (cm) | 0.75 |
| Cr coating thickness (cm) | 0.007 |
| FeCrAl envelope thickness (cm) | 0.05 |
| Burnable poison compact radius (cm) | 0.25 |
| Coolant compact radius (cm) | 0.6 |
| Control compact radius (cm) | 0.95 |
| Fuel | TRISO, 40% packing fraction |
| Coolant | He |
| Moderator (Coating, Envelope) | YH1.8 (Cr, FeCrAl) |
| Burnable poison absorber | Gd2O3 particles, 25% packing fraction |
| Control rod | B4C (96% B-10 enrichment) |

## Mesh

MOOSE's Reactor Module [!citep](shemon2023reactor) was used to create the mesh structure for the entire core of the GC-MR reactor. This tool was particularly useful in addressing intricate modeling prerequisites for the microreactor core such as fuel assemblies exhibiting different designs, distinct axial loading configurations of the burnable absorbers within the core, and modeling intricacies of control drum designs. The transition of the mesh from a 2D to a 3D structure, along with the incorporation of distinct axial regions, was made notably straightforward by employing the [AdvancedExtruderGenerator](https://mooseframework.inl.gov/source/meshgenerators/AdvancedExtruderGenerator.html). The tool's adaptability became especially useful when altering the mesh element size to examine the trade-off between accuracy and computational cost through coarser mesh. [Fig_5]  illustrates a depiction of the 3-D GCMR, detailing both the axial and radial discretization.



!media media/gcmr/Fig16.jpg
      id=Fig_5
      style=display: block;margin-left:auto;margin-right:auto;width:60%;
      caption= Detailed 3-D GCMR core mesh



!listing microreactors/gcmr/core/MESH/Griffin_mesh.i



## Griffin Model

The first step is to generate homogenized multi-group cross-sections using Serpent-2, which are then converted into XML-format cross-section file. Griffin utilizes the cross-sections in an XML-format file in conjunction with the mesh file. The 3D whole-core mesh was constructed utilizing MOOSE’s Reactor module, ensuring consistency between geometric representations in the mesh file and Serpent-2. Griffin solves the neutron transport equation employing discontinuous finite element (DFEM) with SN transport and CMFD acceleration, utilizing on-the-fly coarse mesh generation for CMFD. Efforts were dedicated to simplifying the 3D whole-core GC-MR mesh to alleviate computational demands, with careful consideration to avoid excessive mesh sizes, particularly in specific regions like the radial reflector and control drum areas, to ensure proper convergence of DFEM-SN with CMFD.



!listing microreactors/gcmr/core/ISOXML/Serpent_Model/serpent_input.i  max-height = 10000



!listing microreactors/gcmr/core/Neutronics/Griffin_steady_state.i


## Run Commands

The mesh file can be generated using the --mesh-only option as such:

!listing
mpirun -np <number_of_cores> /path/to/griffin-opt -i mesh_input.i --mesh-only


We can then execute the simulation as follows:

!listing
mpirun -np <number_of_cores> /path/to/griffin-opt -i Griffin_steady_state.i

The Griffin code is a component of the blue_crab code package, so `griffin-opt` can be replaced with the
BlueCrab executable : `blue_crab-opt`.


## Results

Segmentations of the whole-core GC-MR mesh utilized in the analyses, employing DFEM-SN with CMFD and an 11-energy-group structure, are illustrated in [Fig_6]. The simulation was conducted for 1/6 of the core with reflected boundary conditions on the cut surfaces and vacuum boundaries for the remaining surfaces. The resulting k-eff value for 2 polar angles and 3 azimuthal angles in the SN was determined as 1.051468, reasonably aligning with the k-eff value obtained from the Monte Carlo Serpent-2 code, which is 1.054670 ± 16 pcm. It was determined that an even closer alignment could be achieved with higher numbers of polar and azimuthal angles. [Fig_7] presents a comparison between the normalized axial power distribution computed by both Serpent-2 and Griffin for DFEM-SN (n_polar=2,n_azimuthal=3) with CMFD.



!media media/gcmr/Fig17.jpg
      id=Fig_6
      style=display: block;margin-left:auto;margin-right:auto;width:60%;
      caption= 1/6 GCMR core with reflective boundary condition



!media media/gcmr/Fig18.jpg
      id=Fig_7
      style=display: block;margin-left:auto;margin-right:auto;width:60%;
      caption= Normalized axial power distribution computed by both Serpent-2 and Griffin
