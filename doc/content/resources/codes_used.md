# Reactor models sorted by simulation tool used

While every advanced reactor has unique characteristics, with different coolants, fuel shapes or
control mechanisms, most NEAMS tools are at their core rather reactor-agnostic and thus there
are many similarities in the input files. The reader may find below an index of the codes used
in the input files of the virtual test bed.

## Neutronics

### Griffin

- Molten Salt Fast Reactor [documentation](msr/msfr/griffin_pgh_model.md) [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/msr/msfr/steady)

- Pebble Bed Fluoride salt cooled High temperature Reactor [documentation](pbfhr/steady/griffin_pgh_model.md) [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/pbfhr/steady)

- Micro-Reactor [documentation](mrad/index.md) [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/mrad/steady)

- Pebble Bed Modular Reactor [documentation](htgr/pbmr/index.md) [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/pbmr400/steady)


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

- Assembly in a Sodium Fast Reactor [documentation](sfr/sfr.md) [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/sfr)

- Modular High Temperature Reactor [documentation](mhtgr/sam_mhtgr_model.md) [inputs](https://github.com/idaholab/virtual_test_bed/blob/main/htgr/mhtgr)

- Molten Salt Reactor Experiment [documentation](msr/msre/msre_sam_model.md) [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/msr/msre)

- Pebble Bed Fluoride salt cooled High temperature Reactor [documentation](pbfhr/pbfhr_sam/pbfhr_sam.md) [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/pbfhr/sam_model)

- Advanced Burner Test Reactor [documentation](sfr/abtr.md) [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/sfr/abtr)


### Thermal-hydraulics module

- HTGR assembly multiphysics simulation [documentation](htgr/assembly/index.md) [inputs](https://github.com/idaholab/virtual_test_bed/tree/htgr/assembly)


### Sockeye

- Micro reactor with heat pipes [documentation](mrad/index.md) [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/mrad)


### RELAP-7

## Thermo-mechanics

### Bison

- Micro-Reactor [documentation](mrad/index.md) [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/mrad/steady)

- Assembly in a Sodium Fast Reactor [documentation](sfr/sfr.md) [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/sfr/singe_assembly)

- 1D TRISO fuel depletion [documentation](htgr/triso/triso_model.md) [inputs](https://github.com/idaholab/virtual_test_bed/tree/devel/htgr/triso_fuel)


### Heat conduction module

- HTGR assembly multiphysics simulation [documentation](htgr/assembly/index.md) [inputs](https://github.com/idaholab/virtual_test_bed/tree/htgr/assembly)

- Reflector bypass flow in the PB-FHR [documentation](pbfhr/reflector.md) [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/pbfhr/reflector)


### Pronghorn pebble models

- Pebble Bed Fluoride salt cooled High temperature Reactor [documentation](pbfhr/steady/griffin_pgh_model.md) [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/pbfhr/steady)

- Pebble Bed Modular Reactor [documentation](htgr/pbmr/index.md) [inputs](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/pbmr400/steady)



!alert note
The input file links are not automatically checked by the VTB automated testing. If you hit a broken
link please report it to the [VTB team](abdalla.aboujaoude@inl.gov), thank you for your help!
