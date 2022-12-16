# Reactor models sorted by simulation tool used

While every advanced reactor has unique characteristics, with different coolants, fuel shapes or
control mechanisms, most NEAMS tools are at their core rather reactor-agnostic and thus there
are many similarities in the input files. The reader may find below an index of the codes used
in the input files of the virtual test bed.

!alert note title=Fully Open-Source
The codes required to run these inputs are all open-source. Please refer to the documentation or the indexing below for the codes used. Part of the inputs not listed here may be run with open-source codes as well.\\
- Reflector bypass flow in the PB-FHR [documentation](pbfhr/reflector.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/pbfhr/reflector)\\
- Molten Salt Fast Reactor core CFD [documentation](msr/msfr/nek5000_cfd_model.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/msr/msfr/core_cfd)\\
- HTGR assembly multiphysics simulation [documentation](htgr/assembly/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/htgr/assembly)\\
- Sodium Fast Reactor duct bowing [documentation](sfr/hex_duct_bowing/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/sfr/hex_duct_bowing)


!alert note title=Partially Open-Source
Some of the codes required to run these inputs are open-source. You will not be able to run the full multiphysics simulation, but
often by removing the `[MultiApps]` and `[Transfers]` blocks, you should be able to run part of the problem standalone.
Please refer to the documentation or the indexing below for the codes used.\\
- Molten Salt Fast Reactor (using MOOSE Navier-Stokes) [documentation](msr/msfr/griffin_pgh_model.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/msr/msfr/steady)\\
- Versatile Test Reactor core model [documentation](sfr/vtr/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/sfr/vtr) \\
- High Temperature Test Facility transient simulations (core conduction) [documentation](htgr/httf/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/httf)

Multiphysics models will often require access to multiple applications linked or built together, that can run inputs for each code involved.
Licensing for coupled applications (BlueCRAB and Direwolf) and their export-controlled (Griffin, SAM, Bison, etc) components can be
obtained through INL's [NCRC](https://inl.gov/ncrc/).

## Neutronics

### Griffin

- Molten Salt Fast Reactor core & plant multiphysics [documentation](msr/msfr/griffin_pgh_model.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/msr/msfr/steady)

- Pebble Bed Fluoride salt cooled High temperature Reactor [documentation](pbfhr/steady/griffin_pgh_model.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/pbfhr/steady)

- Pebble Bed Modular Reactor (PBMR400) [documentation](htgr/pbmr/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/pbmr400/steady)

- HTR-10 Griffin Benchmark [documentation](htgr/htr10/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/htr10)

- Versatile Test Reactor core model [documentation](sfr/vtr/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/sfr/vtr)

- Generic Molten Salt Fast Reactor Depletion [documentation](msr/msr_generic/depletion/model.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/msr/msr_generic/depletion)

- SNAP-8 NTP reactor core model [documentation](microreactors/s8er/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/microreactors/s8er)

- MHTGR Griffin Benchmark [documentation](htgr/mhtgr_griffin/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/mhtgr_griffin/benchmark)

- LFR Griffin Benchmark [documentation](lfr/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/lfr/heterogeneous_single_assembly_3D/neutronics_standalone)

- Gas Cooled Micro Reactor assembly multiphysics [documentation](gcmr/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/devel/microreactors/gcmr/assembly)

- Dispersed UO2 LEU pulse model [documentation](htgr/leu_pulse) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/devel/htgr/leu_pulse)


### Cardinal / OpenMC (open-source)

- HTGR assembly multiphysics simulation [documentation](htgr/assembly/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/htgr/assembly)


## Multi-dimensional Thermal-hydraulics

### NekRS / Nek5000 (open-source)

- Reflector bypass flow in the PB-FHR [documentation](pbfhr/reflector.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/pbfhr/reflector)

- Molten Salt Fast Reactor core CFD [documentation](msr/msfr/nek5000_cfd_model.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/msr/msfr/core_cfd)

- 67 pebbles conjugate heat transfer [documentation](pb67_cardinal/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/devel/htgr/pb67_cardinal)


### Pronghorn

- Molten Salt Fast Reactor core & plant multiphysics [documentation](msr/msfr/griffin_pgh_transient_model.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/msr/msfr/transient)

- Pebble Bed Fluoride salt cooled High temperature Reactor [documentation](pbfhr/steady/griffin_pgh_model.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/pbfhr/steady)

- Pebble Bed Modular Reactor [documentation](htgr/pbmr/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/pbmr400/transient)


### Pronghorn subchannel

- Subchannel ORNL 19 pins and Toshiba 37 pins benchmarks [documentation](sfr/subchannel/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/devel/sfr/subchannel)


## Systems analysis and 1D Thermal-hydraulics

### SAM

- Assembly in a Sodium Fast Reactor [documentation](sfr/single_assembly/sfr.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/sfr/single_assembly)

- Versatile Test Reactor core model [documentation](sfr/vtr/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/sfr/vtr)

- Modular High Temperature Reactor [documentation](mhtgr_sam/sam_mhtgr_model.md) and [inputs](https://github.com/idaholab/virtual_test_bed/blob/main/htgr/mhtgr_sam)

- Molten Salt Reactor Experiment [documentation](msr/msre/msre_sam_model.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/msr/msre)

- Pebble Bed Fluoride salt cooled High temperature Reactor [documentation](pbfhr/pbfhr_sam/pbfhr_sam.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/pbfhr/sam_model)

- Advanced Burner Test Reactor [documentation](sfr/abtr/abtr.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/sfr/abtr)

- Molten Salt Fast Reactor plant multiphysics [documentation](msr/msfr/griffin_pgh_transient_model.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/msr/msfr/transient)

- Gas Cooled Micro Reactor assembly multiphysics [documentation](gcmr/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/devel/microreactors/gcmr/assembly)

- Mk1 FHR Primary loop simulation [documentation](pbfhr/pbfhr_sam/pbfhr_sam.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/devel/pbfhr/sam_model)


### Thermal-hydraulics module (open-source)

- HTGR assembly multiphysics simulation [documentation](htgr/assembly/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/htgr/assembly)


### Sockeye

- Heat Pipe Micro-Reactor [documentation](mrad/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/mrad)


### RELAP-7

- High Temperature Test Facility transient simulations [documentation](htgr/httf/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/httf)


## Thermo-mechanics

### Bison

- Heat Pipe Micro-Reactor [documentation](mrad/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/mrad/steady)

- Assembly in a Sodium Fast Reactor [documentation](sfr/single_assembly/sfr.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/sfr/single_assembly)

- 1D TRISO fuel depletion [documentation](htgr/triso/triso_model.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/triso_fuel)

- SNAP-8 NTP reactor core model [documentation](microreactors/s8er/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/microreactors/s8er)

- Gas Cooled Micro Reactor assembly multiphysics [documentation](gcmr/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/devel/microreactors/gcmr/assembly)


### Thermo-mechanics module (open-source)

- Versatile Test Reactor core model [documentation](sfr/vtr/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/sfr/vtr)

- Sodium Fast Reactor duct bowing [documentation](sfr/hex_duct_bowing/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/sfr/hex_duct_bowing)


### Heat conduction module (open-source)

- HTGR assembly multiphysics simulation [documentation](htgr/assembly/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/htgr/assembly)

- Reflector bypass flow in the PB-FHR [documentation](pbfhr/reflector.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/pbfhr/reflector)

- Dispersed UO2 LEU fuel model [documentation](htgr/leu_pulse) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/devel/htgr/leu_pulse/ht_20r_leu_fl.i)

- 67 pebbles conjugate heat transfer [documentation](pb67_cardinal/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/devel/htgr/pb67_cardinal)


### Pronghorn pebble models

- Pebble Bed Fluoride salt cooled High temperature Reactor [documentation](pbfhr/steady/griffin_pgh_model.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/pbfhr/steady)

- Pebble Bed Modular Reactor (PBMR400) [documentation](htgr/pbmr/index.md) and [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/pbmr400/steady)



!alert note
The input file links are not automatically checked by the VTB automated testing. If you hit a broken
link please report it to the [VTB team](abdalla.aboujaoude@inl.gov), thank you for your help!
