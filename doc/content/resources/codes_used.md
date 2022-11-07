# Reactor models sorted by simulation tool used

While every advanced reactor has unique characteristics, with different coolants, fuel shapes or
control mechanisms, most NEAMS tools are at their core rather reactor-agnostic and thus there
are many similarities in the input files. The reader may find below an index of the codes used
in the input files of the virtual test bed.

!alert note title=Fully Open-Source
The codes required to run these inputs are all open-source. Please refer to the inputs or the index below for the codes used.\\
- Reflector bypass flow in the PB-FHR [documentation](pbfhr/reflector.md) [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/pbfhr/reflector)\\
- Molten Salt Fast Reactor core CFD [documentation](msr/msfr/nek5000_cfd_model.md) [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/msr/msfr/core_cfd)\\
- HTGR assembly multiphysics simulation [documentation](htgr/assembly/index.md) [inputs](https://github.com/idaholab/virtual_test_bed/tree/htgr/assembly)


!alert note title=Partially Open-Source
Some of the codes required to run these inputs are open-source. You will not be able to run the full multiphysics simulation, but
often by removing the `[MultiApps]` and `[Transfers]` blocks, you should be able to run part of the problem standalone. 
Please refer to the inputs or the index below for the codes used.\\
- Molten Salt Fast Reactor (using MOOSE Navier-Stokes) [documentation](msr/msfr/griffin_pgh_model.md) [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/msr/msfr/steady)\\
- Versatile Test Reactor core model [documentation](sfr/vtr/index.md) [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/sfr/vtr) \\
- High Temperature Test Facility transient simulations (core conduction) [documentation](htgr/httf/index.md) [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/httf)


## Neutronics

### Griffin

- Molten Salt Fast Reactor [documentation](msr/msfr/griffin_pgh_model.md) [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/msr/msfr/steady)

- Pebble Bed Fluoride salt cooled High temperature Reactor [documentation](pbfhr/steady/griffin_pgh_model.md) [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/pbfhr/steady)

- Micro-Reactor [documentation](mrad/index.md) [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/mrad/steady)

- Pebble Bed Modular Reactor [documentation](htgr/pbmr/index.md) [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/pbmr400/steady)

- HTR-10 Griffin Benchmark [documentation](htgr/htr10/index.md) [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/htr10)

- Versatile Test Reactor core model [documentation](sfr/vtr/index.md) [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/sfr/vtr)


### Cardinal / OpenMC

- HTGR assembly multiphysics simulation [documentation](htgr/assembly/index.md) [inputs](https://github.com/idaholab/virtual_test_bed/tree/htgr/assembly)


## Multi-dimensional Thermal-hydraulics

### NekRS / Nek5000

- Reflector bypass flow in the PB-FHR [documentation](pbfhr/reflector.md) [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/pbfhr/reflector)

- Molten Salt Fast Reactor core CFD [documentation](msr/msfr/nek5000_cfd_model.md) [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/msr/msfr/core_cfd)


### Pronghorn

- Molten Salt Fast Reactor [documentation](msr/msfr/griffin_pgh_transient_model.md) [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/msr/msfr/transient)

- Pebble Bed Fluoride salt cooled High temperature Reactor [documentation](pbfhr/steady/griffin_pgh_model.md) [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/pbfhr/steady)

- Pebble Bed Modular Reactor [documentation](htgr/pbmr/index.md) [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/pbmr400/transient)


## Systems analysis and 1D Thermal-hydraulics

### SAM

- Assembly in a Sodium Fast Reactor [documentation](sfr/single_assembly/sfr.md) [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/sfr/single_assembly)

- Versatile Test Reactor core model [documentation](sfr/vtr/index.md) [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/sfr/vtr)

- Modular High Temperature Reactor [documentation](mhtgr/sam_mhtgr_model.md) [inputs](https://github.com/idaholab/virtual_test_bed/blob/main/htgr/mhtgr)

- Molten Salt Reactor Experiment [documentation](msr/msre/msre_sam_model.md) [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/msr/msre)

- Pebble Bed Fluoride salt cooled High temperature Reactor [documentation](pbfhr/pbfhr_sam/pbfhr_sam.md) [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/pbfhr/sam_model)

- Advanced Burner Test Reactor [documentation](sfr/abtr/abtr.md) [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/sfr/abtr)


### Thermal-hydraulics module

- HTGR assembly multiphysics simulation [documentation](htgr/assembly/index.md) [inputs](https://github.com/idaholab/virtual_test_bed/tree/htgr/assembly)


### Sockeye

- Micro reactor with heat pipes [documentation](mrad/index.md) [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/mrad)


### RELAP-7

- High Temperature Test Facility transient simulations [documentation](htgr/httf/index.md) [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/httf)


## Thermo-mechanics

### Bison

- Micro-Reactor [documentation](mrad/index.md) [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/mrad/steady)

- Assembly in a Sodium Fast Reactor [documentation](sfr/single_assembly/sfr.md) [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/sfr/single_assembly)

- 1D TRISO fuel depletion [documentation](htgr/triso/triso_model.md) [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/triso_fuel)


### Thermo-mechanics module

- Versatile Test Reactor core model [documentation](sfr/vtr/index.md) [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/sfr/vtr)

- Sodium Fast Reactor duct bowing [documentation](sfr/hex_duct_bowing/index.md) [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/sfr/hex_duct_bowing)


### Heat conduction module

- HTGR assembly multiphysics simulation [documentation](htgr/assembly/index.md) [inputs](https://github.com/idaholab/virtual_test_bed/tree/htgr/assembly)

- Reflector bypass flow in the PB-FHR [documentation](pbfhr/reflector.md) [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/pbfhr/reflector)


### Pronghorn pebble models

- Pebble Bed Fluoride salt cooled High temperature Reactor [documentation](pbfhr/steady/griffin_pgh_model.md) [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/pbfhr/steady)

- Pebble Bed Modular Reactor [documentation](htgr/pbmr/index.md) [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/pbmr400/steady)



!alert note
The input file links are not automatically checked by the VTB automated testing. If you hit a broken
link please report it to the [VTB team](abdalla.aboujaoude@inl.gov), thank you for your help!
