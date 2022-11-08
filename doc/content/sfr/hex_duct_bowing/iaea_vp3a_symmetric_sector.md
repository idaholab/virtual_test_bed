# Symmetric Sector Bowing - Linear Thermal Gradient (IAEA VP3A)

*Contact: Nick Wozniak, nwozniak.at.anl.gov*

## High Level Summary of Model

This model examines the restrained thermal bowed deformation of a 3D hexagonal assembly (duct) which is subject to thermal gradients along the axial and radial directions bowing into a sector of a reactor core. The ducts are mechanically fixed at the bottom. The model specification is based on Verification Problem 3A (VP3A) in the series of benchmark problems published in [!cite](IWGFR_75) to support the verification and validation of Liquid Metal Fast Breeder Reactor (LMFBR) analysis codes organized by The International Atomic Energy Agency (IAEA)’s International Working Group on Fast Reactors (IWGFR). This model employs the MOOSE Tensor Mechanics Module to model the thermo-mechanical deformation response due to the thermal gradients in the duct, and the Contact Module to model the inter-assembly contact at specific locations along the ducts. This type of deformation is present in liquid-metal cooled fast reactors and serves as an important reactivity feedback effect. The results obtained from this MOOSE-based model demonstrate proper set up of a single assembly thermal duct bowing problem which can be used to build larger and more complex models.

## Computational Model Description

In this example, known as IAEA Verification Problem 3A (VP3A), a known linearly varying thermal gradient is applied to the hexagonal duct, along the axial height in the active core region, as shown in [temp_gradient]. Below the active core, the duct is at 400&deg;C which varies linearly from the core inlet to 550&deg;C at the left corner midwall and 500&deg;C at the far right corner midwall. Along the cross-section, the temperature follows a linear gradient at each axial location. Above the active core, the temperatures are held constant from the core outlet to the top of the duct. The cross-sectional thermal gradient produces a differential thermal expansion where the hotter side of the duct expands more than the cooler side, causing a bowed displacement from hot side towards cold side. The duct is a single assembly of a reactor core sector, shown in [vp3a_sector]. The model for VP3A is a 60&deg; sector of the hexagonal-assembly core freed from the rest of the core. In this configuration, the center duct thermally bows in the y-axis direction into the top 60&deg; sector, which has a free boundary around the edges as shown in [vp3a_sector]. All the other ducts remain at 400&deg;C.

!media hex_duct_bowing/linear_grad.png
  id=temp_gradient
  caption=Representation of thermal gradient along duct axial location, from 400&deg;C below the core extending to 500&deg;C and 550&deg;C on opposite corners of the duct.
  style=width:60%;margin-left:auto;margin-right:auto

!media hex_duct_bowing/vp3a_sector.png
  id=vp3a_sector
  caption=IAEA VP3A core layout showing the free boundary around the sector with red dashed lines and the bowing direction with a blue arrow, (right) sector removed from the full core (Adapted from [!cite](IWGFR_75) © IAEA).
  style=width:60%;margin-left:auto;margin-right:auto

[duct_geom] shows the geometry of the duct in both elevation and cross-section view, with the primary geometric parameters labeled. [geom_parameters] summarizes the values for the geometric parameters. The duct is 4000 mm long, with the active core region extending from 1500 mm along the axial direction to 2500 mm. There is an above core load pad (ACLP) located at 3000 mm axial height. Normally in a Fast Reactor design there is also a top load pad (TLP) at the top of the duct, but in this design, a TLP is omitted even though contact is assumed to occur at the top of the duct. The duct is a sharp cornered hexagon with a distance between the mid-walls of the corners of 150 mm and a wall thickness of 3 mm at room temperature, 20&deg;C. The ACLP has a thickness on top of the duct wall of 2.75 mm and an arbitrary height of 100 mm. The duct and load pad are made of a fictitious steel material with constant material properties (not dependent on temperature) which are given in [material_properties].

!media hex_duct_bowing/duct_geom.png
  id=duct_geom
  caption=Schematic showing duct model geometric parameters.
  style=width:60%;margin-left:auto;margin-right:auto

!table id=geom_parameters caption=Duct Geometric Parameters.
| Parameter | Value (mm) |
| :- | :- |
| Duct |  |
| Corner-to-corner | 150 |
| Assembly Length | 4000 |
| Wall Thickness | 3 |
| ACLP Thickness | 2.75 |
| ACLP Height | 100 |
| Axial Location |  |
| Core Bottom | 1500 |
| Core Top | 2500 |
| Above Core Load Pad (ACLP) | 3000 |

!table id=material_properties caption=Duct Material Properties.
| Property | Value |
| :- | :- |
| Young's Modulus | $1.7\times10^{5} MPa$ |
| Poisson's Ratio | $0.3$ |
| Coefficient of Thermal Expansion | $18\times10^{-6}{/^\circ C}$ |

The geometry and phenomenon in this model are relevant to core-bowing phenomena present in liquid-metal cooled fast reactor design and analysis. The core bowing present in reactor assemblies induces reactivity feedback effects due to sensitivity of fast neutron reactors to leakage pathways. The MOOSE Reactor Module is used to generate the duct mesh, and the MOOSE Tensor Mechanics module is used to calculate the thermo-mechanical response of the duct due to differential thermal expansion and the MOOSE Contact Module is used to simulate the contact behavior between ducts as they bow into one another. This work was originally performed as part of an assessment of the MOOSE Tensor Mechanics module for calculating radial core expansion for fast reactors in [!cite](moose_tm_assess_2021) and [!cite](continued_verification_2022) funded under the NEAMS program. The temperature along the cold ($T_1$) corner of the duct is defined by [eq:temp1]:

\begin{equation}\label{eq:temp1}
T_1(z) =
\begin{cases}
400^\circ C \ & \text{if } \ z \leq 1.5m \\
(250 + 100z) ^\circ C \ & \text{if } \ 1.5 m < z \leq 2.5m \\
500^\circ C \ & \text{if } \ z > 2.5 m
\end{cases}
\end{equation}

The temperature along the hot ($T_2$) corner of the duct is defined by [eq:temp2]:

\begin{equation}\label{eq:temp2}
T_2(z) =
\begin{cases}
400^\circ C \ & \text{if } \ z \leq 1.5m \\
(175 + 150z) ^\circ C \ & \text{if } \ 1.5 m < z \leq 2.5m \\
550^\circ C \ & \text{if } \ z > 2.5 m
\end{cases}
\end{equation}

Due to the complex contact interaction between multiple assemblies at different axial locations, there is no closed-form solution for this example. The problem must be solved numerically with iteration steps to ensure contact enforcement. Due to the nonlinear behavior of the contact interaction, the model was defined as a transient simulation with the temperature applied incrementally over the pseudo-time steps from 0 to 1s incremented by 0.1s.

## Mesh Block

The core sector was meshed using CUBIT v15.5 [!cite](cubit15). The mesh is defined with the `file` parameter referencing the mesh file in the local directory. Since the dimensions were provided at room temperature, the model was created with dimensions at 400&deg;C to consider the initial warm up phase from 20&deg;C and grid plate expansion, which increases the pitch and gaps. To reduce computational expense, a symmetric model was set up with symmetry along the YZ plane. In addition, only ducts 1, 3, 10, and 11 were modeled because the IAEA report results show contact only between ducts 1 and 3 at the TLP and between ducts 3 and 10 at the ACLP. For computational efficiency, the ducts beyond 10 and 11 were not included since they are at constant 400 &deg;C, and ducts 10 and 11 should not deflect far enough to close the gap between the outside ducts. The mesh is shown in [vp3a_mesh] with a top-down view showing the duct numbering consistent with [vp3a_sector] to show which ducts are included, and an isometric view.

!listing /sfr/hex_duct_bowing/iaea_vp3a_symmetric_sector.i block=Mesh

!media hex_duct_bowing/vp3a_mesh.png
  id=vp3a_mesh
  caption=VP3A symmetric model mesh, with the (left) top-down view at the ACLP elevation and (right) isometric view showing the top portion of the ducts.
  style=width:60%;margin-left:auto;margin-right:auto

## Variables

The `TensorMechanics` module solves for the displacement variables in x, y, and z directions. These represent the (x,y,z) components of the vector displacement at each node in the duct. 

!listing /sfr/hex_duct_bowing/iaea_vp3a_symmetric_sector.i block=Variables

## Thermal Gradient Function

The applied temperature along the duct is defined with a MOOSE function, `temp_func`, of type `ParsedFunction` which specifies linear variation of temperature along the active core region in both the radial and axial directions as in [eq:temp1] and [eq:temp2]. The variable `t` is included so the temperature can be increased incrementally over a pseudo-time to allow for convergence of the contact algorithm. 

!listing /sfr/hex_duct_bowing/iaea_vp3a_symmetric_sector.i block=Functions

The MOOSE AuxVariable, `temp`, is defined as the placeholder for temperature. The Tensor Mechanics module will use this variable to calculate the duct thermal expansion. 

!listing /sfr/hex_duct_bowing/iaea_vp3a_symmetric_sector.i block=AuxVariables

Since the duct temperature is space-dependent rather than a constant value, the MOOSE AuxKernel of type `FunctionAux`  instructs MOOSE to retrieve the temperature from the temp_func  Function and stores it in the AuxVariable, `temp`. 

!listing /sfr/hex_duct_bowing/iaea_vp3a_symmetric_sector.i block=AuxKernels

## Boundary Conditions

The bottom surface of the duct is fixed from translation in all directions (X, Y, and Z displacements) to simulate a cantilever beam bending. This is achieved through the assignment of Dirichlet boundary conditions in the BCs block. The `variable` parameter represents the variable on which this BC operates, and the `value` parameter is the value of the variable at the specified boundary. For this model, a “fixed” boundary sideset was named to easily reference the bottom of the duct to assign the boundary condition. 

!listing /sfr/hex_duct_bowing/iaea_vp3a_symmetric_sector.i block=BCs

## Tensor Mechanics Module

The Tensor Mechanics Module is a library of code modules which models the mechanical deformation and stress of solids. The basic set of calculations required for stress calculation problems include computing the strain, the elasticity/constitutive relationship, and the stress tensors. In this model, finite strain formulation is used to account for large relative deformations in the thin wall cross-section. For thermal expansion calculations, an eigenstrain, which is a mechanical deformation not caused by external stresses, is defined as `thermal_expansion`. 

!listing /sfr/hex_duct_bowing/iaea_vp3a_symmetric_sector.i block=Modules

To compute the stresses and relate them with the strains, the elasticity (constitutive relationship) tensor is required. The constitutive relationship between the stress and the strain is shown in [eq:elasticity]

\begin{equation}
\label{eq:elasticity}
\sigma_{ij} = C_{ijkl}\Delta\epsilon_{kl}
\end{equation}

Where $C$ is the elasticity tensor, and $\delta\epsilon$ is the incremental strain. Because the material is defined as steel, which is considered an isotropic material, the elasticity tensor is computed with `ComputeIsotropicElasticityTensor` material property, which requires the Young’s Modulus (modulus of elasticity) and Poisson’s ratio. The stress tensor is also required, which is calculated with `ComputeFiniteStrainElasticStress`, because the finite strain formulation is defined in the `TensorMechanics` block. To compute the thermal expansion due to the temperature, `temp`, the `ComputeThermalExpansionEigenstrain` property is added to compute the eigenstrain which is defined in the `TensorMechanics` block. Then the total strain in the duct is the summation of the elastic strain and the eigenstrain.

!listing /sfr/hex_duct_bowing/iaea_vp3a_symmetric_sector.i block=Materials

## Contact Module

Contact was enforced at the ACLP and TLP with node-face contact using a frictionless, penalty contact. Thus, the `model` parameter is set to `frictionless` and the `formulation` parameter is set to `penalty` with a penalty parameter equal to 1e10. Care must be taken to not set the penalty parameter to a very low value. Since the contact volumes are thin-walled ducts, we need to control the penetration value to be as small as possible. However, setting the value of the penalty parameter too high could lead to convergence issues in the simulation solve. Each load pad face was assigned to its own sideset to determine the `primary` and `secondary` sidesets for the contact definition, shown in [lp_sideset]. The sidesets were named based on the location, ACLP or TLP, the duct on which the sideset was defined, and the neighboring duct number to quickly identify the proper contact sets. Thus, `ACLP1_3` refers to the face on Duct 1 ACLP, which is adjacent to Duct 3.

!media hex_duct_bowing/lp_sideset.png
  id=lp_sideset
  caption=Example of duct 1 ACLP sidesets showing each face on the load pad is assigned to its own sideset.
  style=width:20%;margin-left:auto;margin-right:auto  

!listing /sfr/hex_duct_bowing/iaea_vp3a_symmetric_sector.i block=Contact

## Results

As a debugging check, the temperature calculated with the defined function is plotted in [vp3a_gradient_defl] to ensure the temperatures have been correctly mapped to the duct. We can visually verify that the temperature below the active core region is 400&deg;C, the temperature increases through the active core region, and above the active core the temperature on each side of the duct is held constant. The deformation output from the MOOSE simulation is also plotted in [vp3a_gradient_defl]. Duct 1 visibly bows from the high temperature side (bottom) towards the cooler temperature side (top) into the sector of ducts and contacts at the top of the duct.  

!media hex_duct_bowing/vp3a_temp_defl.png
  id=vp3a_gradient_defl
  caption=Temperature gradient mapping of the duct (left) and duct bowing (right). 
  style=width:60%;margin-left:auto;margin-right:auto

Since MOOSE models only the duct walls, the centerline deformation of the duct is estimated by averaging the  deformation of the flat faces at each axial height. The deformation from MOOSE simulation output for duct 1 is plotted in [duct1_3a_plot] along with the calculation results from the participants from the IAEA report [!cite](IWGFR_75) and agree well. A comparison of the deformation values at the core top, ACLP, and TLP are presented in [bowing_results], comparing the IAEA and MOOSE results. The values are all in good agreement, with MOOSE giving the maximum displacement of 8.59 mm at the TLP for duct 1 and the IAEA 8.54 mm. This benchmark verifies the MOOSE physics modules (Tensor Mechanics and Contact) for a small cluster of assemblies undergoing thermal bowing along the corner direction of the hexagonal assembly and contacting at load pads. Notable, reflective boundary conditions and a prior knowledge about which ducts would contact were used to substantially reduce the computational cost of the full sector problem.

!media hex_duct_bowing/duct1_3a_plot.png
  id=duct1_3a_plot
  caption=Duct bowing results for MOOSE calculations compared with closed-form solution results. 
  style=width:30%;margin-left:auto;margin-right:auto

!table id=bowing_results caption=Bowing results (in mm) at the top of the core, ACLP, and the TLP locations.
| Duct | IAEA | MOOSE |
| :- | :- | :- |
| ACLP |  |  |
| 1 | 0.88 | 0.93 |
| 3 | 0.94 | 0.92 |
| 10 | 0.43 | 0.42 |
| TLP |  |  |
| 1 | 8.54 | 8.59 |
| 3 | 1.51 | 1.48 |
| 10 | 0.65 | 0.63 |

## Run Command

This model requires the openly available Tensor Mechanics and Contact Modules which can be independently compiled from a MOOSE framework installation or leveraged from a MOOSE application which links to a version of MOOSE containing both these modules. 

```language=bash
mpirun -np 20 /path/to/APP -i iaea_vp3a_symmetric_sector.i
```

!bibtex bibliography