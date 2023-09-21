# High Temperature Engineering Test Reactor (HTTR) Null Transient Model Description

*Contact: Vincent Laboure, vincent.laboure.at.inl.gov*

*Model link: [HTTR Null Transient](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/httr)*

!tag name=High Temperature Engineering Test Reactor (HTTR) Null Transient Model pairs=reactor_type:HTGR
                       reactor:HTTR
                       geometry:core
                       simulation_type:core_multiphysics
                       multiapps:true
                       transient:null
                       code_used:Sabertooth
                       computing_needs:Workstation
                       fiscal_year:2023

A detailed description of the steady-state model is available [here](httr/httr_steady_state_model_description.md). Only modifications necessary to set up a null-transient state are explained below.

For all null-transient input files, initial conditions (`[ICs]` block and `initial_condition` parameters) have been removed. All child applications (thermal hydraulics and fuel element heterogeneous heat conduction) are restarted using the parent full core heat conduction checkpoint. The full-core neutronics model
uses an Exodus file for restart for the mesh as well as Griffin's binary restart.

## Neutronics

#### Mesh

Parameter `use_for_exodus_restart` has been set to true to enable the `[Mesh]` block to restart the fluxes from the exodus file populated from
the [steady state neutronics](httr/httr_steady_state_model_description.md#neutronics) simulation.

!listing httr/steady_state_and_null_transient/neutronics_null.i block=Mesh

#### Transport System

The `[TransportSystems]` block restarts with the eigenvalue solved from the steady state neutronics calculation,
to scale the fission cross sections so the core is critical. The parameter `equation_type` has been changed to `transient`.

!listing httr/steady_state_and_null_transient/neutronics_null.i block=TransportSystems

#### User Objects

Values not included in the exodus file are restarted from binary in the `[UserObjects]` block
using a [XXXXXXXXXX](dss.i)

!listing httr/steady_state_and_null_transient/neutronics_null.i block=UserObjects

#### MultiApps

The `[MultiApps]` block has been modified to utilize a `TransientMultiApp` type. This is because all the physics simulations
will progress synchronized in time, there won't be an eigenvalue neutronics calculation as there was previously for the steady state.

!listing httr/steady_state_and_null_transient/neutronics_null.i block=MultiApps

## Heat Transfer

### Heat Transfer - Homogenized Full Core

#### Mesh

The `[Mesh]` block now loads the mesh the checkpoint created from the steady simulation homogenized simulation.

!listing httr/steady_state_and_null_transient/full_core_ht_null.i block=Mesh


#### Executioner

The `Executioner` block has been updated to use a Transient type and include time steps for a 50 second transient run.

!listing httr/steady_state_and_null_transient/full_core_ht_null.i block=Executioner

### Heat Transfer - Single Pin Heterogeneous

#### Mesh

The `Mesh` block has been restarted with the checkpoint created from the steady state single pin heterogeneous calculation.

!listing httr/steady_state_and_null_transient/fuel_elem_null.i block=Mesh

#### Kernels

The `Kernels` block has time derivatives added back into the nested `heat_ie` block.

!listing httr/steady_state_and_null_transient/fuel_elem_null.i block=Kernels/heat_ie

#### Executioner

The `Executioner` block has been updated to use a Transient type and include time steps for a 50 second transient run.

!listing httr/steady_state_and_null_transient/fuel_elem_null.i block=Executioner

## Thermal-Hydraulics

### Thermal-Hydraulics - Control Rods

#### Executioner

The `Executioner` block has been updated to use a Transient type and include time steps for a 50 second transient run.

!listing httr/steady_state_and_null_transient/thermal_hydraulics_CR_null.i block=Executioner

### Thermal-Hydraulics - Fuel Pins

#### Executioner

The `Executioner` block has been updated to use a Transient type and include time steps for a 50 second transient run.

!listing httr/steady_state_and_null_transient/thermal_hydraulics_fuel_pins_null.i block=Executioner

## Null Transient Model input summary:

The inputs can be found below or on the relevant folder on the Github repository.

Griffin model

!listing httr/steady_state_and_null_transient/neutronics_null.i

Full-core heat transfer model

!listing httr/steady_state_and_null_transient/full_core_ht_null.i

BISON 5-pin model

!listing httr/steady_state_and_null_transient/fuel_elem_null.i

RELAP-7 Control Rod Assembly thermal-hydraulics model

!listing httr/steady_state_and_null_transient/thermal_hydraulics_CR_null.i

RELAP-7 Fuel Assembly thermal-hydraulics model

!listing httr/steady_state_and_null_transient/thermal_hydraulics_fuel_pins_null.i

## Running the simulation

To apply for access to Sabertooth and access to INL High Performance Computing, please visit [NCRC](https://ncrcaims.inl.gov/).
These inputs can be run on your local machine or on a computing cluster, depending on your level of access to the simulation
software and the computing power available to you.

### Idaho National Laboratory HPC

In all cases (steady-state and null-transient - which should be executed in this order), run the Griffin input with Sabertooth.
With at least level 1 access to Sabertooth, the `sabertooth` module can be loaded and from the `sabertooth-opt` executable can be used.
If you have already run the steady state calculation, you can skip the second step below.

```language=CPP

module load use.moose moose-apps sabertooth


mpirun -n 6 sabertooth-opt -i neutronics_eigenvalue.i

mpirun -n 6 sabertooth-opt -i neutronics_null.i

```

### Local Device

In all cases (steady-state and null-transient - which should be executed in this order), run the Griffin input with Sabertooth.

For instance, if you have *level 2* access to the binaries, you can download sabertooth through `miniconda` and use
them as follows:

```language=CPP

conda activate sabertooth

mpirun -n 6 sabertooth-opt -i neutronics_eigenvalue.i

mpirun -n 6 sabertooth-opt -i neutronics_null.i

```

## Citing and credits

If using or modifying this model, please cite:

```language=cpp
Vincent Labouré, Javier Ortensi, Nicolas Martin, Paolo Balestra, Derek Gaston, Yinbin Miao, Gerhard Strydom, "Improved multiphysics model of the High Temperature Engineering Test Reactor for the simulation of loss-of-forced-cooling experiments", Annals of Nuclear Energy, Volume 189, 2023, 109838, ISSN 0306-4549, https://doi.org/10.1016/j.anucene.2023.109838. (https://www.sciencedirect.com/science/article/pii/S0306454923001573)

Vincent M Laboure, Matilda A Lindell, Javier Ortensi, Gerhard Strydom and Paolo Balestra, "FY22 Status Report on the ART-GCR CMVB and CNWG International Collaborations." INL/RPT-22-68891-Rev000 Web. doi:10.2172/1893099.
```

Documentation written by Kylee Swanson.
