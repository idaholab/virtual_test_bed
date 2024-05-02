# Reactor models sorted by simulation type

While every advanced reactor has unique characteristics, with different coolants, fuel shapes or
control mechanisms, most NEAMS tools are at their core rather reactor-agnostic and thus there
are many similarities in the input files. The reader may find below an index of the types of
simulations that are present in the virtual test bed. If the exact simulation of interest is not
present for the reactor you wish to see it for, the inputs for another reactor type will likely
help creating it.

## Steady state

### Component analysis

- Reflector bypass flow in the PB-FHR [documentation](pbfhr/reflector.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/pbfhr/reflector)

- Sodium Fast Reactor duct bowing [documentation](sfr/hex_duct_bowing/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/sfr/hex_duct_bowing)

- HTTF Lower Plenum CFD Model [documentation](httf/lower_plenum_cfd.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/httf/lower_plenum_mixing)


### Fuel centric analysis

- 67 pebbles conjugate heat transfer [documentation](pb67_cardinal/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/pb67_cardinal)

- 1D TRISO fuel depletion [documentation](htgr/triso/triso_model.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/triso_fuel)


### Assembly multiphysics calculation

- HTGR assembly multiphysics simulation [documentation](htgr/assembly/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/assembly)

- Assembly in a Sodium Fast Reactor [documentation](sfr/single_assembly/sfr.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/sfr/single_assembly)

- Gas Cooled Micro Reactor assembly multiphysics [documentation](gcmr/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/microreactors/gcmr/assembly)

- LFR Griffin Benchmark [documentation](lfr/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/lfr/heterogeneous_single_assembly_3D/neutronics_standalone)

- Heat Pipe Micro-Reactor Assembly [documentation](hpmr_assembly/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/microreactors/hpmr_assembly)

### Multiphysics core simulations

- Molten Salt Fast Reactor core multiphysics [documentation](msr/msfr/griffin_pgh_model.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/msr/msfr/steady)

- Pebble Bed Fluoride salt cooled High temperature Reactor [documentation](pbfhr/steady/griffin_pgh_model.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/pbfhr/steady)

- Heat Pipe Micro-Reactor [documentation](mrad/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/microreactors/mrad/steady)

- Pebble Bed Modular Reactor (PBMR400) [documentation](htgr/pbmr/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/pbmr400/steady)

- Versatile Test Reactor core model [documentation](sfr/vtr/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/sfr/vtr)

- High Temperature Test Facility transient simulations [documentation](htgr/httf/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/httf)

- SNAP-8 NTP reactor core model [documentation](microreactors/s8er/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/microreactors/s8er)

- MHTGR Benchmark Griffin model [documentation](htgr/mhtgr_griffin/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/mhtgr_griffin/)

- Generic Pebble Bed Reactor core model [documentation](htgr/generic-pbr/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/generic-pbr)

- Heat Pipe Micro-Reactor [documentation](mrad/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/microreactors/mrad)

- HTTR Core multiphysics [documentation](httr/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/httr/steady_state_and_null_transient)

- Micro Reactor Drum Rotation Model [documentation](microreactors/drum_rotation/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/microreactors/drum_rotation)

- Lotus Molten Chloride Reactor Steady State Model [documentation](msr/lotus/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/msr/lotus/steady_state)

- Heat Pipe Microreactor with Hydrogen Redistribution (HPMR_H2) Steady State Model [documentation](microreactors/hpmr_h2/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/devel/microreactors/hpmr_h2/steady)

- Molten Salt Reactor Experiment RZ multiphysics core model [documentation](msr/msre/multiphysics_rz_model/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/msr/msre/multiphysics_core_model/steady_state)

- Thermochimica Steady-State Model of Molten Salt Fast Reactor Core [documentation](msr/msfr/thermo_model) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/devel/msr/msfr/thermochemistry)

### Primary loop analysis

- Molten Salt Fast Reactor plant multiphysics [documentation](msr/msfr/plant/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/msr/msfr/plant)

- Pebble Bed Fluoride salt cooled High temperature Reactor Plant multiphysics [documentation](pbfhr/balance_of_plant/plant.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/pbfhr/plant)

- Mk1 FHR Primary loop simulation [documentation](pbfhr/pbfhr_sam/pbfhr_sam.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/pbfhr/sam_model)


### Integrated plant analysis

- Modular High Temperature Gas Reactor [documentation](mhtgr_sam/sam_mhtgr_model.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/mhtgr/mhtgr_sam)

- Molten Salt Reactor Experiment [documentation](msr/msre/msre_sam_model.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/msr/msre)

- Pebble Bed Fluoride salt cooled High temperature Reactor [documentation](pbfhr/pbfhr_sam/pbfhr_sam.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/pbfhr/sam_model)

- Advanced Burner Test Reactor [documentation](sfr/abtr/abtr.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/sfr/abtr)


## Transient

### Null transient

- HTTR Core multiphysics [documentation](httr/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/httr/steady_state_and_null_transient)


### Reactivity insertion accident (RIA)

- Molten Salt Reactor Experiment Reactivity Insertion Tests [documentation](msr/msre/msre_sam_model.md#MSRE-Reactivity-Insertion-Test) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/msr/msre/reactivity_insertion)

- High Temperature Test Facility simulated power increase simulations [documentation](htgr/httf/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/httf)

- Dispersed UO2 LEU pulse model [documentation](leu_pulse/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/leu_pulse)

- Micro Reactor Drum Rotation Model [documentation](microreactors/drum_rotation/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/microreactors/drum_rotation)

- Molten Salt Reactor Experiment RZ multiphysics transient (using MOOSE Navier-Stokes) [documentation](msr/msre/multiphysics_rz_model/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/devel/msr/msre/multiphysics_core_model/transient)

### Protected loss of coolant flow

- Pebble Bed Modular Reactor (PBMR400) [documentation](htgr/pbmr/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/pbmr400/transient)

- Mk1 FHR Primary loop simulation [documentation](pbfhr/pbfhr_sam/pbfhr_sam.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/pbfhr/sam_model)


### Unprotected loss of coolant flow (ULOF)

- Molten Salt Fast Reactor core multiphysics [documentation](msr/msfr/griffin_pgh_transient_model.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/msr/msfr/transient)

- Gas Cooled Micro Reactor assembly multiphysics [documentation](gcmr/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/microreactors/gcmr/assembly)


### Load following

- Heat Pipe Micro-Reactor [documentation](mrad/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/microreactors/mrad)


## Depletion

### Core depletion

- Upcoming for PB-FHR


### Fuel depletion

- 1D TRISO fuel depletion [documentation](htgr/triso/triso_model.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/triso_fuel)

- Generic Molten Salt Fast Reactor Depletion [documentation](msr/msr_generic/depletion/model.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/msr/msr_generic/depletion)


!alert note
The input file links are not automatically checked by the VTB automated testing. If you hit a broken
link please report it to the [VTB team](guillaume.giudicelli.at.inl.gov)
