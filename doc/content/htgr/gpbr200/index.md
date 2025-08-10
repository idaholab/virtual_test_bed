# General Pebble Bed Reactor with Stochastic Analyses

*Contact: Zachary M. Prince, zachary.prince@inl.gov*

*Model link: [GPBR200 Model](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/gpbr200)*

!tag name=General Pebble Bed Reactor with Stochastic Analyses
     description=This 2D model of a pebble-bed HTGR reactor core studies multiphysics coupling and stochastic analyses.
     image=https://mooseframework.inl.gov/virtual_test_bed/media/gpbr200/gpbr200_geometry.png
     pairs=reactor_type:HTGR
           reactor:GPBR200
           geometry:core
           simulation_type:neutronics;thermal_hydraulics;thermo_mechanics;surrogate_modeling;sensitivity_analysis;
           input_features:multiapps;stochastic_tools
           transient:steady_state
           V_and_V:demonstration
           codes_used:BlueCRAB;Griffin;Pronghorn;Bison;MOOSE_StochasticTools
           computing_needs:Workstation;HPC
           open_source:partial
           fiscal_year:2024;2025
           sponsor:NEAMS;ART
           institution:INL

## Purpose and Background

This 200MWth General Pebble Bed Reactor (GPBR200) model is the latest iteration
of a series of pebble-bed high-temperature gas reactor (HTGR) models developed at Idaho
National Laboratory (INL) using MOOSE-based applications. These models are
primarily meant as a testing ground for multiphysics, optimization, and
stochastic methods for PBRs, some also serving as verification benchmarks. An
in-depth description of the latest iteration can be found in
[!cite](prince2024Sensitivity). It is recommended to read this paper before
continuing in the exposition here.

The purpose of this exposition is to show how to perform multiphysics
simulations of PBRs and stochastic analyses of reactors, in general, with
MOOSE-based applications. This is done by presenting and explaining the inputs
that perform:

- Equilibrium-core neutronics and depletion using Griffin [!cite](wang2025Griffin)
- Thermal-hydraulics simulation using weakly-compressible finite-volume fluids
  and finite-volume heat conduction with Pronghorn [!cite](novak2021Pronghorn)
- Pebble and particle thermomechanics with Bison [!cite](BISON)
- Multi-scale physics coupling using MOOSE MultiApps [!cite](giudicelli2024moose)
- Surrogate modeling and sensitivity analysis using the MOOSE stochastic tools
  module [!cite](Slaughter2023)

## Brief Geometry and Property Description

The GPBR200 model is 2D axisymmetric geometry shown in
[!ref](fig:gpbr200_geometry). The mesh shown was generated using a custom MOOSE
MeshGenerator, not currently available publicly. The relevant properties of the
model are shown in [!ref](tab:gpbr200_properties). Note that these are "nominal"
property values, where some of them will be varied as part of the stochastic
analyses.

!media gpbr200/gpbr200_geometry.png
    style=width:40%
    caption=Geometric diagram of GPBR200 model.
    id=fig:gpbr200_geometry

!table caption=Nominal properties of GPBR200 model. id=tab:gpbr200_properties
| Property                | Value | Unit        |
| :---------------------- | ----: | :---------- |
| Power                   | 200   | MW          |
| Core radius             | 1.2   | m           |
| Core height             | 8.93  | m           |
| Pebble diameter         | 6     | cm          |
| TRISO filling factor    | 9.34  | %           |
| Fuel kernel composition | UCO   | –           |
| Fuel kernel diameter    | 0.425 | mm          |
| Fuel enrichment         | 15.5  | %wt         |
| Discharge rate          | 1.5   | pebbles/min |
| Discharge limit         | 147.6 | MWd/kg      |
| He mass flow rate       | 64.3  | kg/s        |
| He inlet temperature    | 260   | °C          |
| He outlet pressure      | 5.8   | MPa         |
| RCCS temperature        | 70    | °C          |

## Outline

The remainder of this model description dives deeply into the inputs and a
presentation of results, which are mostly showcased in
[!cite](prince2024Sensitivity).

1. [Equilibrium Core Neutronics with Griffin](gpbr200/core_neutronics.md)
1. [Thermal Hydraulics with Pronghorn](gpbr200/core_thermal_hydraulics.md)
1. [Pebble Thermomechanics with Bison](gpbr200/pebble_thermomechanics.md)
1. [Multiphysics Coupling](gpbr200/coupling.md)
1. [Pebble Surrogate Modeling](gpbr200/pebble_surrogate_modeling.md)
1. [Design-Space Sensitivity Analysis](gpbr200/sensitivity_analysis.md)
