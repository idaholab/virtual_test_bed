# Hexagonal Duct Bowing - Linear Thermal Gradient (IAEA VP1)

*Contact: Nick Wozniak, nwozniak.at.anl.gov*

## High Level Summary of Model

This model examines the free (unrestrained) thermal bowed deformation of a single, 3D hexagonal assembly (duct) which is subject to thermal gradients along the radial and axial directions. The duct is mechanically fixed at the bottom. The model specification is taken directly from Verification Problem 1 (VP1) in the series of benchmark problems published in [!cite](IWGFR_75) to support the verification and validation of Liquid Metal Fast Breeder Reactor (LMFBR) analysis codes organized by The International Atomic Energy Agency (IAEA)’s International Working Group on Fast Reactors (IWGFR). Eleven participating agencies in nine different countries contributed numerical solutions to the set of benchmarks. This model employs the MOOSE Tensor Mechanics Module to model the thermo-mechanical deformation response due to the thermal gradients in the duct. This type of deformation is present in liquid-metal cooled fast reactors and serves as an important reactivity feedback effect. The results obtained from this MOOSE-based model demonstrate proper set up of a single assembly thermal duct bowing problem which can be used to build larger and more complex models.

## Computational Model Description

In this example, known as IAEA Verification Problem 1 (VP1), a known linearly varying thermal gradient is applied to the hexagonal duct along the axial height in the active core region, as shown in [temp_gradient]. Below the active core, the duct is at 400&deg;C which varies linearly from the core inlet to 550&deg;C at the left corner midwall and 500&deg;C at the far right corner midwall. Along the cross-section, the temperature follows a linear gradient at each axial location. Above the active core, the temperatures are held constant from the core outlet to the top of the duct. The cross-sectional thermal gradient produces a differential thermal expansion where the hotter side of the duct expands more than the cooler side, causing a bowed displacement from hot side towards cold side. 

!media hex_duct_bowing/linear_grad.png
  id=temp_gradient
  caption=Representation of thermal gradient along duct axial location, from 400&deg;C below the core extending to 500&deg;C and 550&deg;C on opposite corners of the duct.
  style=width:60%;margin-left:auto;margin-right:auto

[duct_geom] shows the geometry of the duct in both elevation and cross-section view, with the primary geometric parameters labeled. [geom_parameters] summarizes the values for the geometric parameters. The duct is 4000 mm long, with the active core region extending from 1500 mm along the axial direction to 2500 mm. There is an above core load pad (ACLP) located at 3000 mm axial height. The duct is a sharp cornered hexagon with a distance between the mid-walls of the corners of 150 mm   and a wall thickness of 3 mm at room temperature, 20&deg;C. The ACLP has a thickness on top of the duct wall of 2.75 mm and an arbitrary height of 100 mm. The duct and load pad are made of a fictitious steel material  with constant material properties (not dependent on temperature) which are given in [material_properties].

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

The geometry and phenomenon in this model are relevant to core-bowing phenomena present in liquid-metal cooled fast reactor design and analysis. The core bowing  present in reactor assemblies induces reactivity feedback effects due to sensitivity of fast neutron reactors to leakage pathways. The MOOSE Reactor Module is used to generate the duct mesh, and the MOOSE Tensor Mechanics module is used to calculate the thermo-mechanical response of the duct due to differential thermal expansion. This work was originally performed as part of an assessment of the MOOSE Tensor Mechanics module for calculating radial core expansion for fast reactors [!cite](moose_tm_assess_2021) funded under the NEAMS program. The temperature along the cold ($T_1$) corner of the duct is defined by [eq:temp1]:

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

The bending moment along the duct axial height can be represented by the moment in a beam induced by thermal gradients given by the following equation:

\begin{equation}
\label{eq:moment}
M_T(z) = \frac{EI\alpha(T_2(z) - T_1(z))}{D}
\end{equation}

Where $E$ is the Young’s modulus, $I$ is the area moment of inertia, $\alpha$ is the thermal expansion coefficient per $^\circ C$, $T_2$ and $T_1$ are the temperatures evaluated at the hot and cold corners of the cross section, $D$ is the depth of the beam along the cross section in the direction of the bending deflection, and $z$ is the axial height above the fixed boundary condition (located $z=0 \ m$). It should be noted that the moment is also defined as a piecewise continuous function along the same $z$ values as the temperature. The deflection of the duct, $w(z)$, can then be found as the deflection of a cantilever beam. Based on beam theory [!cite](mechanics_2012), the second derivative of the deflection multiplied by $E$ and $I$ is equal to bending moment of the beam, which is defined in [eq:moment_defl]:

\begin{equation}
\label{eq:moment_defl}
EI\frac{d^2w}{dz^2} = M_T(z)
\end{equation}

The deflection of the beam is then found through double integration of the moment and applying continuity boundary equations to the piecewise continuous sections:

\begin{equation}\label{eq:defl}
w(z) =
\begin{cases}
0 \ m \ & \text{if } \ z \leq 1.5m \\
\frac{\alpha}{D}\left( \frac{25z^3}{3} - 37.5z^2 + 56.25z -28.125 \right) \ m \ & \text{if } \ 1.5 m < z \leq 2.5m \\
\frac{\alpha}{D}\left(25z^2 - 100z + 56.25z + \frac{1225}{12} \right) \ m \ & \text{if } \ z > 2.5 m
\end{cases}
\end{equation}

## Mesh Block

The mesh was created with the MOOSE Reactor Module. First, a 2D duct cross-section is created with `PolygonConcentricCircleMeshGenerator`, followed by removal of the duct interior by  `BlockDeletionGenerator` to create a thin-walled hexagonal duct. The 2D duct is extruded to 3D using `MeshExtruderGenerator`. We note that while the presence of load pads is not important physically for this particular problem as no contact occurs, load pads are modeled so that this mesh can be re-used in more complex multi-assembly models. Therefore, the same steps are taken to create the load pad, which is moved axially along the duct to the correct position using `TransformGenerator` and stitched to the duct with `StitchedMeshGenerator`. Sidesets are renamed using `RenameBoundaryGenerator`, which are useful to name the duct and load pad faces for creating contact sets or for post-processing. The sideset on the bottom of the duct is renamed to “fixed” so the boundary conditions can be applied by easily identifying the sideset by name.  The mesh of the top-down view and the duct at the load pad is shown in [duct1_mesh].

!listing /sfr/hex_duct_bowing/single_duct_linear_gradient.i block=Mesh

!media hex_duct_bowing/duct1_mesh.png
  id=duct1_mesh
  caption=Single duct mesh top down and load pad location.
  style=width:40%;margin-left:auto;margin-right:auto

## Variables

The `TensorMechanics` module solves for the displacement variables in $x$, $y$, and $z$ directions. These represent the $(x,y,z)$ components of the vector displacement at each node in the duct.

!listing /sfr/hex_duct_bowing/single_duct_linear_gradient.i block=Variables

## Thermal Gradient Function

The applied temperature along the duct is defined with a MOOSE function, `temp_func`, of type `ParsedFunction` which specifies linear variation of temperature along the active core region in both the radial and axial directions as in [eq:temp1] and [eq:temp2].

!listing /sfr/hex_duct_bowing/single_duct_linear_gradient.i block=Functions

The MOOSE AuxVariable, `temp`, is defined as the placeholder for temperature with the initial condition of 400&deg;C, which is the temperature of the duct below the active core region. The Tensor Mechanics module will use this variable to calculate the duct thermal expansion.

!listing /sfr/hex_duct_bowing/single_duct_linear_gradient.i block=AuxVariables

Since the duct temperature is space-dependent rather than a constant value, the MOOSE AuxKernel of type `FunctionAux`  instructs MOOSE to retrieve the temperature from the `temp_func` Function and stores it in the AuxVariable, `temp`.

!listing /sfr/hex_duct_bowing/single_duct_linear_gradient.i block=AuxKernels

## Boundary Conditions

The bottom surface of the duct is fixed from translation in all directions ($x$, $y$, and $z$ displacements) to simulate a cantilever beam bending. This is achieved through the assignment of Dirichlet boundary conditions in the BCs block. The `variable` parameter represents the variable on which this BC operates, and the `value` parameter is the value of the variable at the specified boundary. For this model, a “fixed” boundary sideset was named to easily reference the bottom of the duct to assign the boundary condition. 

!listing /sfr/hex_duct_bowing/single_duct_linear_gradient.i block=BCs

## Tensor Mechanics Module

The Tensor Mechanics Module is a library of code modules which models the mechanical deformation and stress of solids. The basic set of calculations required for stress calculation problems include computing the strain, the elasticity/constitutive relationship, and the stress tensors. In this model, finite strain formulation is used to account for large relative deformations in the thin wall cross-section. For thermal expansion calculations, an eigenstrain, which is a mechanical deformation not caused by external stresses, is defined as `thermal_expansion`.

!listing /sfr/hex_duct_bowing/single_duct_linear_gradient.i block=Modules

To compute the stresses and relate them with the strains, the elasticity (constitutive relationship) tensor is required. The constitutive relationship between the stress and the strain is shown in [eq:elasticity]:

\begin{equation}
\label{eq:elasticity}
\sigma_{ij} = C_{ijkl}\Delta\epsilon_{kl}
\end{equation}

Where $C$ is the elasticity tensor, and $\Delta\epsilon$ is the incremental strain. Because the material is defined as steel, which is considered an isotropic material, the elasticity tensor is computed with `ComputeIsotropicElasticityTensor` material property, which requires the Young’s Modulus (modulus of elasticity) and Poisson’s ratio. The stress tensor is also required, which is calculated with `ComputeFiniteStrainElasticStress`, because the finite strain formulation is defined in the `TensorMechanics` block. To compute the thermal expansion due to the temperature, `temp`, the `ComputeThermalExpansionEigenstrain` property is added to compute the eigenstrain which is defined in the `TensorMechanics` block. Then the total strain in the duct is the summation of the elastic strain and the eigenstrain. 

!listing /sfr/hex_duct_bowing/single_duct_linear_gradient.i block=Materials

## Results

As a debugging check, the temperature calculated with the defined function is plotted in [gradient_defl] to ensure the temperatures have been correctly mapped to the duct. We can visually verify that the temperature below the active core region is 400&deg;C, the temperature increases through the active core region,  and above the active core the temperature on each side of the duct is held constant. The deformation output from the MOOSE simulation is also plotted in [gradient_defl], magnified to show the deformed shape. The duct visibly bows from the high temperature side (left) towards the cooler temperature side (right).

!media hex_duct_bowing/duct1_temp_defl.png
  id=gradient_defl
  caption=Temperature gradient mapping of the duct (left) and duct bowing (right, magnified). 
  style=width:60%;margin-left:auto;margin-right:auto

A closed form solution is available for the expected deformation of the duct centerline as shown in [eq:defl]. Since MOOSE models only the duct walls, the centerline deformation of the duct is estimated by averaging the deformation of the flat faces at each axial height. The deformation from the closed-form solution and the MOOSE output are plotted in [duct1_plot] and agree well. The IAEA report [!cite](IWGFR_75) compares the different participant codes and averages their results to compare with the closed form solution at the core top, the ACLP, and the top of the duct. Those values are presented in [bowing_results], comparing the closed form, the IAEA average, and the MOOSE results. The MOOSE simulation results agree well with both the code averages and the closed-form solution, with a deformation at the core top equal to 1.00 mm, deformation at the ACLP equal to 3.25 mm, and deformation at the top of the duct equal to 12.26 mm.

!media hex_duct_bowing/duct1_plot.png
  id=duct1_plot
  caption=Duct bowing comparison between MOOSE and the closed-form solution.
  style=width:30%;margin-left:auto;margin-right:auto

!table id=bowing_results caption=Bowing results (in mm) at the top of the core, ACLP, and the top of the duct locations.
| Location | Equation | IAEA | MOOSE |
| :- | :- | :- | :- |
| Core Top | 1.00 | 1.00 | 1.00 |
| ACLP | 3.25 | 3.25 | 3.25 |
| Duct Top | 12.25 | 12.25 | 12.26 |

## Run Command

This model requires the openly available Reactor and Tensor Mechanics Modules which can be independently compiled from a MOOSE framework installation or leveraged from a MOOSE application which links to a version of MOOSE containing both these modules. 

```language=bash
mpirun -np 20 /path/to/APP  -i hex_duct_linear_gradient.i
```

!bibtex bibliography