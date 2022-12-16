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


### Assembly multiphysics calculation

- HTGR assembly multiphysics simulation [documentation](htgr/assembly/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/htgr/assembly)

- Assembly in a Sodium Fast Reactor [documentation](sfr/single_assembly/sfr.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/sfr/single_assembly)


### Multiphysics core simulations

- Molten Salt Fast Reactor core multiphysics [documentation](msr/msfr/griffin_pgh_model.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/msr/msfr/steady)

- Pebble Bed Fluoride salt cooled High temperature Reactor [documentation](pbfhr/steady/griffin_pgh_model.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/pbfhr/steady)

- Heat Pipe Micro-Reactor [documentation](mrad/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/mrad/steady)

- Pebble Bed Modular Reactor (PBMR400) [documentation](htgr/pbmr/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/pbmr400/steady)

- Versatile Test Reactor core model [documentation](sfr/vtr/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/sfr/vtr)

- High Temperature Test Facility transient simulations [documentation](htgr/httf/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/httf)

- SNAP-8 NTP reactor core model [documentation](microreactors/s8er/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/microreactors/s8er)

- MHTGR Benchmark Griffin model [documentation](htgr/mhtgr_griffin/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/mhtgr_griffin/)


### Primary loop analysis

- Molten Salt Fast Reactor plant multiphysics [documentation](msr/msfr/plant/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/msr/msfr/plant)

- Pebble Bed Fluoride salt cooled High temperature Reactor Plant multiphysics [documentation](pbfhr/balance_of_plant/plant.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/pbfhr/plant)


### Integrated plant analysis

- Modular High Temperature Gas Reactor [documentation](mhtgr_sam/sam_mhtgr_model.md) and [inputs](https://github.com/idaholab/virtual_test_bed/blob/main/htgr/mhtgr_sam)

- Molten Salt Reactor Experiment [documentation](msr/msre/msre_sam_model.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/msr/msre)

- Pebble Bed Fluoride salt cooled High temperature Reactor [documentation](pbfhr/pbfhr_sam/pbfhr_sam.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/pbfhr/sam_model)

- Advanced Burner Test Reactor [documentation](sfr/abtr/abtr.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/sfr/abtr)


## Transient

### Reactivity insertion accident (RIA)

- Molten Salt Reactor Experiment Reactivity Insertion Tests [documentation](msr/msre/msre_sam_model.md#MSRE-Reactivity-Insertion-Test) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/msr/msre/reactivity_insertion)

- High Temperature Test Facility simulated power increase simulations [documentation](htgr/httf/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/httf)


### Protected loss of coolant flow

- Pebble Bed Modular Reactor (PBMR400) [documentation](htgr/pbmr/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/pbmr400/transient)


### Unprotected loss of coolant flow (ULOF)

- Molten Salt Fast Reactor core multiphysics [documentation](msr/msfr/griffin_pgh_transient_model.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/msr/msfr/transient)


## Depletion

### Core depletion

- Upcoming for PB-FHR


### Fuel depletion

- 1D TRISO fuel depletion [documentation](htgr/triso/triso_model.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/devel/htgr/triso_fuel)

- Generic Molten Salt Fast Reactor Depletion [documentation](msr/msr_generic/depletion/model.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/msr/msr_generic/depletion)


!alert note
The input file links are not automatically checked by the VTB automated testing. If you hit a broken
link please report it to the [VTB team](abdalla.aboujaoude.at.inl.gov)
