# Heat Pipe Microreactor with Hydrogen Redistribution (HPMR-H$_2$) Description

*Contact: Stefano Terlizzi, stefano.terlizzi\@inl.gov, Vincent Labour&#233;, vincent.laboure\@inl.gov*

## Introduction

The VTB Heat Pipe Microreactor with Hydrogen Redistribution (HPMR-H$_2$) model is based upon the Simplified Microreactor Benchmark Assessment problem described in [!citep](Terlizzi2023). The latter is a numerical assessment problem based on the  Empire reactor [!citep](Empire) and the problem described in [!citep](ArgonneReport). The details of the design were made generic enough to avoid any proprietary concerns, but specific enough to capture the primary design characteristics of the envisioned HP-cooled monolithic microreactors.  In this model, the coupled neutron transport, heat transfer, HP response, and hydrogen redistribution equations are solved.

Four characteristics distinguish this HPMR-H$_2$ model from current VTB microreactors models:

- The neutronics analysis considers the impact of hydrogen redistribution within the yttrium hydride pins. This is achieved by incorporating hydrogen redistribution modeling into Bison [!citep](BISON) and by parameterizing the multigroup macroscopic cross sections based on the stoichiometric ratio.
- The coupling between neutronics and solid heat conduction, including the 101 heat pipe sub-applications, is achieved through a fixed-point iteration approach. This logic relies on the effective multiplication factor's residual error reduction, deviating from the default coupling method performed at each Richardson iteration. This logics allows to minimize the number of iterations between neutron transport and the other physics, and, therefore, the execution time of the simulation.
- The heat pipe is modeled using the Vapor-Only Flow Model (VOFM) in Sockeye. This heat pipe model couples "a 1D single-phase, compressible flow formulation for the vapor phase in the core region to 2D heat conduction in the wick and annulus" [!citep](SOCKEYE). The VOFM allows to obtain better accuracy with respect to the Conduction Heat Pipe Model, based on thermal resistance, while being numerically more stable than the two-phase Flow-Model.
- Special care is taken to obtain excellent mass and energy conservation across the multiphysics model, without relying on mesh refinement. As detailed in [!citep](Terlizzi2023), the total hydrogen mass was conserved within 4e-5% and the total global energy discrepancy is below 0.04%.

!media hpmr_h2/hpmr_h2_geometry.jpeg
    caption= Overview of the reactor geometry [!citep](Terlizzi2023).
    id=hpmr_h2_geometry
    style=width:100%;margin-left:auto; margin-right:auto

## Core Description

The HPMR-H$_2$ is a 2-MW microreactor composed of 18 hexagonal assemblies arranged into two rings (see [hpmr_h2_geometry]). The tops and bottoms of these 160-cm-high assemblies are surrounded by 20-cm-high axial beryllium reflectors. Each assembly contains 96 fuel pins that are 1 cm in radius, 60 $YH_x$ pins that are 0.975 cm in radius, and 61 1-cm-radius sodium heat pipes (HPs) drilled into a graphite monolith. The HPs penetrate only into the top axial reflector, making the reactor axially asymmetric. The central shutdown rod slot is empty. The core is surrounded by 12 control drums, with boron carbide employed as the absorbing material. For a simplified mesh, the beryllium radial reflector is hexagonal. The geometries and material specifications of the HPMR-H$_2$ reactor assembly components are reported in [table-floating1] and [table-floating2].

!table id=table-floating1 caption=Materials of each component and their corresponding densities [!citep](Terlizzi2023).
| Component | Material | Density, $g/cm^3$ | Conductivity, W/(m K) |
| --------- | -------- | --------------- | --------------------- |
| Fuel      | UN       | 14.3            | 300                   |
| Moderator | $YH_{1.8}$ | 4.30            | 500                   |
| Monolith  | Graphite | 1.80            | 1830                  |
| Heat Pipe | SS-316+Sodium | 2.27       | N/A                   |
| Absorber  | $B_4C$   | 2.52            | 20                    |
| Reflector | Be       | 1.85            | 200                   |

The thermal conductivities of the materials are constant and do not depend on hydrogen content and hydride temperature. However, using more realistic temperature-dependent functions is a trivial change in the DireWolf model. The values were chosen based on the actual values of the properties at 1100 K, a temperature that is representative of the average thermal conditions in the reactor. The geometrical dimensions and material properties of the HPs were taken from Table II of [!citep](matthews2021coupled). In the neutronic model, the sodium and the wall material (stainless steel) of the HPs are homogenized.

!table id=table-floating2 caption=Overview of the HPMR-H$_2$ reactor specifications [!citep](Terlizzi2023).
| Property      | Value  |
| ----------- | ----------- |
| Fuel Radius, cm                  | 1.0   |
| Moderator Radius, cm             | 0.975 |
| Heat Pipe External Radius, cm    | 1.0   |
| Monolith Pitch, cm               | 2.15  |
| Unit Assembly Flat-to-Flat, cm   | 32    |
| Assembly Height, cm              | 160   |
| Core Flat-to-Flat, cm            | 195.3 |
| Poison Strip Internal Radius, cm | 14.8  |
| Arc Width for Poison Strip, deg  | 120   |
| Control Drum External Radius, cm | 15.0  |
| Axial Reflector Thickness, cm    | 20.0  |
| Enrichment, wt%                  | 19.75 |


!bibtex bibliography
