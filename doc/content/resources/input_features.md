# Reactor models sorted by input file features

While every advanced reactor has unique characteristics, with different coolants, fuel shapes or
control mechanisms, most NEAMS tools are at their core rather reactor-agnostic and thus there
are many similarities in the input files. The reader may find below an index of the features that are present in the input files of the virtual test bed. If the exact feature is not
present for the reactor you wish to see it for, the inputs for another reactor type will likely
help creating it.

## Mesh treatment

### In-MOOSE basic mesh generation

- Dispersed UO2 LEU pulse model [documentation](htgr/leu_pulse) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/devel/htgr/leu_pulse)


### In-MOOSE reactor mesh generation

- HTGR assembly multiphysics simulation [documentation](htgr/assembly/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/htgr/assembly)

- Assembly in a Sodium Fast Reactor [documentation](sfr/single_assembly/sfr.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/sfr/single_assembly)

- Pebble Bed Modular Reactor [documentation](htgr/pbmr/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/pbmr400/steady)

- Sodium Fast Reactor duct bowing [documentation](sfr/hex_duct_bowing/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/sfr/hex_duct_bowing)

- SNAP-8 NTP reactor core model [documentation](microreactors/s8er/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/microreactors/s8er)

- LFR Griffin Benchmark [documentation](lfr/index.md) [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/lfr/heterogeneous_single_assembly_3D/neutronics_standalone)

- Gas Cooled Micro Reactor assembly multiphysics [documentation](gcmr/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/devel/microreactors/gcmr/assembly)


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

- Micro reactor with heat pipes [documentation](mrad/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/mrad)

- HTGR assembly multiphysics simulation [documentation](htgr/assembly/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/htgr/assembly)

- Reflector bypass flow in the PB-FHR [documentation](pbfhr/reflector.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/pbfhr/reflector)

- SNAP-8 NTP reactor core model [documentation](microreactors/s8er/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/microreactors/s8er)

- Gas Cooled Micro Reactor assembly multiphysics [documentation](gcmr/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/devel/microreactors/gcmr/assembly)

- Dispersed UO2 LEU pulse model [documentation](htgr/leu_pulse) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/devel/htgr/leu_pulse)

- 67 pebbles conjugate heat transfer [documentation](pb67_cardinal/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/devel/htgr/pb67_cardinal)


### Multiphysics and multiscale simulations

- Pebble Bed Fluoride salt cooled High temperature Reactor [documentation](pbfhr/steady/griffin_pgh_model.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/pbfhr/steady)

- High Temperature Test Facility coupling between core and hundreds of channel calculations [documentation](htgr/httf/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/httf)


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

- 1D TRISO fuel depletion [documentation](htgr/triso/triso_model.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/devel/htgr/triso_fuel)

- Subchannel ORNL 19 pins and Toshiba 37 pins benchmarks [documentation](sfr/subchannel/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/devel/sfr/subchannel)

- Dispersed UO2 LEU pulse model [documentation](htgr/leu_pulse) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/devel/htgr/leu_pulse)

- Mk1 FHR Primary loop simulation [documentation](pbfhr/pbfhr_sam/pbfhr_sam.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/devel/pbfhr/sam_model)

- Generic Pebble Bed Reactor core model [documentation](htgr/generic-pbr/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/devel/htgr/generic-pbr)


### HPC required

- HTGR assembly multiphysics simulation [documentation](htgr/assembly/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/htgr/assembly)

- MHTGR Griffin Benchmark [documentation](htgr/mhtgr_griffin/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/mhtgr_griffin/benchmark)

- Micro reactor with heat pipes [documentation](mrad/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/mrad)

- Reflector bypass flow in the PB-FHR [documentation](pbfhr/reflector.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/pbfhr/reflector)

- High Temperature Test Facility transient simulations [documentation](htgr/httf/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/httf)

- Molten Salt Fast Reactor plant multiphysics [documentation](msr/msfr/plant/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/msr/msfr/plant)

- Pebble Bed Fluoride salt cooled High temperature Reactor Plant multiphysics [documentation](pbfhr/balance_of_plant/plant.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/pbfhr/plant)

- Molten Salt Fast Reactor core CFD [documentation](msr/msfr/nek5000_cfd_model.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/msr/msfr/core_cfd)

- LFR Griffin Benchmark [documentation](lfr/index.md) [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/lfr/heterogeneous_single_assembly_3D/neutronics_standalone)

- Gas Cooled Micro Reactor assembly multiphysics [documentation](gcmr/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/devel/microreactors/gcmr/assembly)

- 67 pebbles conjugate heat transfer [documentation](pb67_cardinal/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/devel/htgr/pb67_cardinal)


### GPU-enabled

- Reflector bypass flow in the PB-FHR [documentation](pbfhr/reflector.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/pbfhr/reflector)

- 67 pebbles conjugate heat transfer [documentation](pb67_cardinal/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/devel/htgr/pb67_cardinal)


!alert note
If there is a feature which you would find useful to be highlighted, please reach out to [VTB team](abdalla.aboujaoude@inl.gov)

!alert note
The input file links are not automatically checked by the VTB automated testing. If you hit a broken
link please report it to the [VTB team](abdalla.aboujaoude@inl.gov)
