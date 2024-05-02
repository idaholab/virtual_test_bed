# Reactor models sorted by input file features

While every advanced reactor has unique characteristics, with different coolants, fuel shapes or
control mechanisms, most NEAMS tools are at their core rather reactor-agnostic and thus there
are many similarities in the input files. The reader may find below an index of the features that are present in the input files of the virtual test bed. If the exact feature is not
present for the reactor you wish to see it for, the inputs for another reactor type will likely
help creating it.

## Mesh treatment

### In-MOOSE basic mesh generation

- Dispersed UO2 LEU pulse model [documentation](leu_pulse/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/leu_pulse)


### In-MOOSE reactor module mesh generation

- HTGR assembly multiphysics simulation [documentation](htgr/assembly/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/assembly)

- Assembly in a Sodium Fast Reactor [documentation](sfr/single_assembly/sfr.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/sfr/single_assembly)

- Pebble Bed Modular Reactor [documentation](htgr/pbmr/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/pbmr400/steady)

- Sodium Fast Reactor duct bowing [documentation](sfr/hex_duct_bowing/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/sfr/hex_duct_bowing)

- SNAP-8 NTP reactor core model [documentation](microreactors/s8er/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/microreactors/s8er)

- LFR Griffin Benchmark [documentation](lfr/index.md) [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/lfr/heterogeneous_single_assembly_3D/neutronics_standalone)

- Gas Cooled Micro Reactor assembly multiphysics [documentation](gcmr/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/microreactors/gcmr/assembly)

- Micro Reactor Drum Rotation Model [documentation](microreactors/drum_rotation/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/microreactors/drum_rotation)

- Heat Pipe Micro-Reactor Assembly [documentation](hpmr_assembly/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/microreactors/hpmr_assembly)


### Cubit mesh generation

The mesh generation scripts using external software are not included in
the input file, but generally reside in the same folder in the repository.

- Molten Salt Fast Reactor core multiphysics [documentation](msr/msfr/griffin_pgh_model.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/msr/msfr/steady)

- Pebble Bed Fluoride salt cooled High temperature Reactor [documentation](pbfhr/steady/griffin_pgh_model.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/pbfhr/steady)


## Coupling through MultiApps

### Multiphysics but same spatial scale simulations

- Molten Salt Fast Reactor [documentation](msr/msfr/griffin_pgh_model.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/msr/msfr/steady)

- Pebble Bed Fluoride salt cooled High temperature Reactor [documentation](pbfhr/balance_of_plant/plant.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/pbfhr/plant)

- Pebble Bed Modular Reactor (PBMR400) [documentation](htgr/pbmr/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/pbmr400/steady)

- Assembly in a Sodium Fast Reactor [documentation](sfr/single_assembly/sfr.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/sfr/single_assembly)

- Versatile Test Reactor core model [documentation](sfr/vtr/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/sfr/vtr)

- Micro reactor with heat pipes [documentation](mrad/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/microreactors/mrad)

- HTGR assembly multiphysics simulation [documentation](htgr/assembly/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/assembly)

- Reflector bypass flow in the PB-FHR [documentation](pbfhr/reflector.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/pbfhr/reflector)

- SNAP-8 NTP reactor core model [documentation](microreactors/s8er/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/microreactors/s8er)

- Gas Cooled Micro Reactor assembly multiphysics [documentation](gcmr/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/microreactors/gcmr/assembly)

- Dispersed UO2 LEU pulse model [documentation](leu_pulse/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/leu_pulse)

- 67 pebbles conjugate heat transfer [documentation](pb67_cardinal/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/pb67_cardinal)

- Micro Reactor Drum Rotation Model [documentation](microreactors/drum_rotation/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/microreactors/drum_rotation)

- Lotus Molten Chloride Reactor Steady State Model [documentation](msr/lotus/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/msr/lotus/steady_state)

- Heat Pipe Micro-Reactor Assembly [documentation](hpmr_assembly/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/microreactors/hpmr_assembly)

- Molten Salt Reactor Experiment RZ multiphysics steady state and transient [documentation](msr/msre/multiphysics_rz_model/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/devel/msr/msre/multiphysics_core_model)

- Micro Reactor Drum Rotation Model [documentation](microreactors/drum_rotation/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/devel/microreactors/drum_rotation)

- Thermochimica Steady-State Model of Molten Salt Fast Reactor Core [documentation](msr/msfr/thermo_model) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/devel/msr/msfr/thermochemistry)

### Multiphysics and multiscale simulations

- Pebble Bed Fluoride salt cooled High temperature Reactor [documentation](pbfhr/steady/griffin_pgh_model.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/pbfhr/steady)

- High Temperature Test Facility coupling between core and hundreds of channel calculations [documentation](htgr/httf/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/httf)

- HTTR Core multiphysics [documentation](httr/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/httr/steady_state_and_null_transient)


## Restarting from a previous simulation

Transient simulations are often started from stable steady state initializations rather than uniform power, temperature, flux, etc
distributions. This can be done in numerous ways:

### Checkpoint

Documentation for the [Checkpoint system](https://mooseframework.inl.gov/application_usage/restart_recover.html)

- Molten Salt Fast Reactor loss of flow transient [documentation](msr/msfr/griffin_pgh_transient_model.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/msr/msfr/transient)

- Molten Salt Reactor Experiment reactivity insertion transients [documentation](msr/msre/msre_sam_model.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/msr/msre/reactivity_insertion)

- Pebble Bed Fluoride salt cooled High temperature Reactor Plant multiphysics [documentation](pbfhr/balance_of_plant/plant.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/pbfhr/plant)

- Advanced Burner Test Reactor loss of flow transient [documentation](sfr/abtr/abtr.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/sfr/abtr)

- HTTR Core multiphysics [documentation](httr/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/httr/steady_state_and_null_transient)


### Binary restart

Binary restart is only used by Griffin. It is only used to restart the neutronics simulation. Any MultiApps has to be
initialized using another restart solution. For `Checkpoint`, the additional `Problem/force_restart=true` must be
specified. The MRAD and PBMR-400 models listed below are an example of this.

- Gas Cooled Micro Reactor assembly multiphysics [documentation](gcmr/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/microreactors/gcmr/assembly)

- Micro reactor with heat pipes [documentation](mrad/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/microreactors/mrad)

- Pebble Bed Modular Reactor [documentation](htgr/pbmr/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/pbmr400/transient)


### Restarting from Exodus simulation files

- Molten Salt Fast Reactor core multiphysics [documentation](msr/msfr/griffin_pgh_model.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/msr/msfr/steady)

- Thermochimica Steady-State Model of Molten Salt Fast Reactor Core [documentation](msr/msfr/thermo_model) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/devel/msr/msfr/thermochemistry)


### Mixed Exodus/Checkpoint Multiapp restart

- HTTR Core multiphysics [documentation](httr/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/httr/steady_state_and_null_transient)


## Computing requirements

### Runs on a laptop or workstation

- Assembly in a Sodium Fast Reactor [documentation](sfr/single_assembly/sfr.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/sfr/single_assembly)

- Versatile Test Reactor core model [documentation](sfr/vtr/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/sfr/vtr)

- Advanced Burner Test Reactor [documentation](sfr/abtr/abtr.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/sfr/abtr)

- Modular High Temperature Gas Reactor [documentation](htgr/mhtgr_sam/sam_mhtgr_model.md) and [inputs](https://github.com/idaholab/virtual_test_bed/blob/main/htgr/mhtgr)

- Pebble Bed Modular Reactor (PBMR400) [documentation](htgr/pbmr/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/pbmr400/transient)

- Molten Salt Fast Reactor [documentation](msr/msfr/griffin_pgh_transient_model.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/msr/msfr/transient)

- Molten Salt Reactor Experiment [documentation](msr/msre/msre_sam_model.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/msr/msre)

- Pebble Bed Fluoride salt cooled High temperature Reactor [documentation](pbfhr/pbfhr_sam/pbfhr_sam.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/pbfhr/sam_model)

- 1D TRISO fuel depletion [documentation](htgr/triso/triso_model.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/triso_fuel)

- HTR-10 Griffin Benchmark [documentation](htgr/htr10/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/htr10)

- Sodium Fast Reactor duct bowing [documentation](sfr/hex_duct_bowing/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/sfr/hex_duct_bowing)

- SNAP-8 NTP reactor core model [documentation](microreactors/s8er/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/microreactors/s8er)

- 1D TRISO fuel depletion [documentation](htgr/triso/triso_model.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/triso_fuel)

- Subchannel ORNL 19 pins and Toshiba 37 pins benchmarks [documentation](sfr/subchannel/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/sfr/subchannel)

- Dispersed UO2 LEU pulse model [documentation](leu_pulse/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/leu_pulse)

- Mk1 FHR Primary loop simulation [documentation](pbfhr/pbfhr_sam/pbfhr_sam.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/pbfhr/sam_model)

- Generic Pebble Bed Reactor core model [documentation](htgr/generic-pbr/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/generic-pbr)

- Micro Reactor Drum Rotation Model [documentation](microreactors/drum_rotation/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/microreactors/drum_rotation)

- Heat Pipe Micro-Reactor Assembly [documentation](hpmr_assembly/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/microreactors/hpmr_assembly)

- Molten Salt Reactor Experiment RZ multiphysics core model [documentation](msr/msre/multiphysics_rz_model/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/msr/msre/multiphysics_core_model/steady_state)

- Thermochimica Steady-State Model of Molten Salt Fast Reactor Core [documentation](msr/msfr/thermo_model) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/devel/msr/msfr/thermochemistry)

### HPC required

- HTGR assembly multiphysics simulation [documentation](htgr/assembly/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/assembly)

- MHTGR Griffin Benchmark [documentation](htgr/mhtgr_griffin/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/mhtgr/mhtgr_griffin/benchmark)

- Micro reactor with heat pipes [documentation](mrad/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/microreactors/mrad)

- Heat Pipe Microreactor with Hydrogen Redistribution (HPMR_H2) Steady State Model [documentation](microreactors/hpmr_h2/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/devel/microreactors/hpmr_h2/steady)

- Reflector bypass flow in the PB-FHR [documentation](pbfhr/reflector.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/pbfhr/reflector)

- High Temperature Test Facility transient simulations [documentation](htgr/httf/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/httf)

- Molten Salt Fast Reactor plant multiphysics [documentation](msr/msfr/plant/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/msr/msfr/plant)

- Pebble Bed Fluoride salt cooled High temperature Reactor Plant multiphysics [documentation](pbfhr/balance_of_plant/plant.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/pbfhr/plant)

- Molten Salt Fast Reactor core CFD [documentation](msr/msfr/nek5000_cfd_model.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/msr/msfr/core_cfd)

- LFR Griffin Benchmark [documentation](lfr/index.md) [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/lfr/heterogeneous_single_assembly_3D/neutronics_standalone)

- Gas Cooled Micro Reactor assembly multiphysics [documentation](gcmr/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/microreactors/gcmr/assembly)

- 67 pebbles conjugate heat transfer [documentation](pb67_cardinal/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/pb67_cardinal)

- HTTF Lower Plenum CFD Model [documentation](httf/lower_plenum_cfd.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/httf/lower_plenum_mixing)

- HTTR Core multiphysics [documentation](httr/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/httr/steady_state_and_null_transient)

- Lotus Molten Chloride Reactor Steady State Model [documentation](msr/lotus/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/msr/lotus/steady_state)

### GPU-enabled

- Reflector bypass flow in the PB-FHR [documentation](pbfhr/reflector.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/pbfhr/reflector)

- 67 pebbles conjugate heat transfer [documentation](pb67_cardinal/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/pb67_cardinal)


!alert note
If there is a feature which you would find useful to be highlighted, please reach out to [VTB team](abdalla.aboujaoude@inl.gov)

!alert note
The input file links are not automatically checked by the VTB automated testing. If you hit a broken
link please report it to the [VTB team](guillaume.giudicelli.at.inl.gov)
