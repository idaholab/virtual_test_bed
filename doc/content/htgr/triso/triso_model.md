# TRISO Bison Model

*Contact: Wen Jiang, wjiang8.at.ncsu.edu*

*Model link: [TRISO Bison Model](https://github.com/idaholab/virtual_test_bed/tree/devel/htgr/triso_fuel)*

!tag name=TRISO Bison Model pairs=reactor_type:HTGR
                       geometry:TRISO
                       simulation_type:fuel_performance
                       codes_used:BISON
                       transient:depletion
                       computing_needs:Workstation
                       fiscal_year:2022
                       sponsor:NEAMS
                       institution:INL

The input file of `triso_1d.i` is a 1D TRISO model with perfectly spherical geometry. The input files of `triso_2d_aspherical.i` and `triso_2d_ipyc_cracking.i` are 2D RZ-symmetric TRISO models with spherical geometry and IPyC cracking, respectively. The input file of `triso_3d` is a one-eighth 3D TRISO model with perfectly spherical geometry. Interested readers are referred to [!citep](bison_triso_model) for more details about TRISO modeling capability in Bison.

The fuel parameters are given in [table:fuel_parameters]. The irradiation condition is summarized in [table:condition]

!table id=table:fuel_parameters caption=Fuel parameters used in this input file
| Parameter                           | Values |
|-------------------------------------|--------|
| $^{235}$U enrichment (wt %)         | 15.5   |
| Carbon/uranium (atomic ratio)       | 0.4    |
| Oxygen/uranium (atomic ratio)       | 1.5    |
| Kernel diameter ($/mu$ m)             | 425    |
| Buffer thickness ($/mu$ m)            | 100    |
| IPyC/OPyC thickness ($\mu$ m)         | 40     |
| SiC thickness ($\mu$ m)               | 35     |
| Kernel density (g/cm$^3$)             | 11.0   |
| Kernel theoretical density (g/cm$^3$) | 11.4   |
| Buffer density (g/cm$^3$)             | 1.05   |
| Buffer theoretical density (g/cm$^3$) | 2.25   |
| IPyC density (g/cm$^3$)               | 1.90   |
| OPyC density (g/cm$^3$)               | 1.90   |
| IPyC/OPyC BAF                       | 1.05   |

!table id=table:condition caption=Irradiation condition used in this input file
| EFPD | Burnup (%FIMA) | Fast fluency ($\times 10^25 n/m^2$, E>0.18 Mev) | Irradiation temperature ($\degree$C) |
|------|----------------|-------------------------------------------------|--------------------------------------|
| 500  | 13.5           | 5                                               | 700                                  |

Users can plot the stress histories using the `csv` output. As shown in Figure 1, the tangential stress is compressive in the SiC layer  . The compressive stress in the SiC layer decreases due to irradiation creep. The internal pressure that results in increasing tensile stress in the SiC layer is caused by fission gas buildup. More results of this example can be found in [!cite](bison_triso_model).

!media media/htgr/bison_sic_stress.png
       style=width:800;float:right;
       caption=Figure 1: Tangential stress for SiC.

# Input Description

Bison uses a block-structured input syntax. Each block begins with square
brackets which contain the type of input and ends with empty square
brackets. Each block may contain sub-blocks. The blocks in the input
file are described in the order as they appear.
Before the first block entries, users can define variables and specify
their values which are subsequently used in the input model.  For example,

!listing
kernel_radius = 213.35e-6 # micron
buffer_thickness = 98.9e-6 # micron
IPyC_thickness = 40.4e-6 # micron
SiC_thickness = 35.2e-6 # micron
OPyC_thickness = 43.4e-6 # micron

In Bison, comments are entered after the `#` sign

If not explicitly specified, the blocks described below apply across 1D, 2D, and 3D cases.

## Global parameters

This block contains the parameters that might be used in multiple blocks.  For example, to specify initial Oxygen to Uranium atom ratio, the user can input

```language=bash

O_U	= 1.5

```

## Mesh

`TRISO1DMeshGenerator` creates a 1D mesh appropriate for use in TRISO analysis.
The user supplies radial coordinates that mark the boundaries of mesh blocks.  A
list of numbers of radial elements per block is also supplied. A `0` for the
elements in the block represents a gap and is typically used for the gap that
opens between the buffer and IPyC layers.

!listing htgr/triso_fuel/triso_1d.i block=gen language=cpp

`TRISO2DMeshGenerator` creates a 2D mesh appropriate for use in TRISO analysis.  The user supplies radial coordinates that mark the boundaries of mesh blocks.  A list of numbers of elements per block is also supplied. A `0` for the elements in the block represents a gap and is typically used for the gap that opens between the buffer and IPyC layers. Aspherical meshes are supported, allowing the mesh to have a flat facet at the bottom of the particle.  This is accomplished through the `aspect_ratio` parameter. Two varieties of aspherical meshes are available.  These are selected through the `aspherical_type` parameter.  The first of these, `vary_buffer`, creates meshes with thinned buffers.  The resulting mesh includes a small fillet at the junction of the flat facet and the original, circular geometry.  The second type, `vary_outer`, thins the outer layers slightly near the centerline and thickens them toward the edge of the facet.

!listing htgr/triso_fuel/triso_2d_aspherical.i block=gen language=cpp

`TRISO3DMeshGenerator` creates a 3D mesh appropriate for use in TRISO analysis.  The user supplies radial coordinates that mark the boundaries of mesh blocks.  A list of numbers of elements per block is also supplied. A `0` for the elements in the block represents a gap and is typically used for the gap that opens between the buffer and IPyC layers.

!listing htgr/triso_fuel/triso_3d.i block=gen language=cpp

## UserObjects

`TRISOGeometry` outputs the TRISO particle and pebble geometry determined from the mesh at the beginning of the simulation. This capability is available in 2D and 3D.

!listing htgr/triso_fuel/triso_1d.i block=particle_geometry language=cpp

Only for 2D IPyC cracking case, we need to use this userobject to model the crack with the X-FEM module. The crack geometry is specified by `LineSegmentCutUserObject`.

!listing htgr/triso_fuel/triso_2d_ipyc_cracking.i block=ipyc_crack language=cpp

## XFEM Action

We only need to add this Action for the 2D IPyC cracking case. The X-FEM `XFEM` action is needed to model a crack in the IPyC layer. The X-FEM quadrature rule is selected through the `qrule` parameter and the output the XFEM cut plane and volume fraction can be specicifed by `output_cut_plane` parameter.

## Tensor Mechanics Action

The tensor mechanics `Master` action simplifies the input file syntax for creating a tensor mechanics model. It specifies the thermo-mechanical models of the kernel, buffer, IPyC/OPyC and SiC.

!listing htgr/triso_fuel/triso_1d.i block=Modules/TensorMechanics/Master language=cpp

## Kernel

The kernels used for solving heat equations are listed here.

!listing htgr/triso_fuel/triso_1d.i block=heat_ie language=cpp

!listing htgr/triso_fuel/triso_1d.i block=heat language=cpp

!listing htgr/triso_fuel/triso_1d.i block=heat_source language=cpp

## Thermal Contact

The `ThermalContactAction` action sets up the set of models used to enforce thermal contact across the buffer and IPyC surfaces.

!listing htgr/triso_fuel/triso_1d.i block=thermal_contact language=cpp

## Boundary Condition

The boundary conditions of displacements and temperature are set in this block. The inner pressure caused by fission gas buildup is set by `PlenumPressure` Action.

!listing htgr/triso_fuel/triso_1d.i block=plenumPressure language=cpp

If IPyC cracking is modeled, the symmetric boundary conditions need to exclude the boundary of crack surface.

!listing htgr/triso_fuel/triso_2d_ipyc_cracking.i block=no_disp_y language=cpp

For this 3D example, symmetric boundary conditions are applied.

## Material

Thermo-mechanical properties of a TRISO particle are specified in this block. The description of each model can be found in [!cite](bison_triso_model).

## Postprocessors

This block is used to specify the output variables written to a `csv` file that can be further processed in Excel or Python. For example, to output the tangential stress in SiC:

!listing htgr/triso_fuel/triso_1d.i block=SiC_stress language=cpp
