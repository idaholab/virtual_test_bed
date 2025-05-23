# Multiphysics Modeling of the Whole Core Gas-Cooled Microreactor (GCMR)

*Contacts: Yinbin Miao (ymiao.at.anl.gov), Ahmed Abdelhameed (aabdelhameed.at.anl.gov), Nicolas Stauff (nstauff.at.anl.gov)*

!tag name=Gas-Cooled Microreactor Core
     description=3D core model of a Gas Cooled Micro Reactor with heterogeneous transport
     image=https://mooseframework.inl.gov/virtual_test_bed/media/gcmr/gcmr_ss.png
     pairs=reactor_type:microreactor
           reactor:GCMR
           geometry:core
           simulation_type:multiphysics
           V_and_V:demonstration
           input_features:multiapps;reactor_meshing;mixed_restart
           transient:steady_state;channel_blockage;coolant_depressurization
           codes_used:BlueCrab;Griffin;BISON
           computing_needs:HPC
           fiscal_year:2025
           sponsor:NEAMS
           institution:ANL

## Overview

The GCMR multiphysics model, developed at Argonne National Laboratory [!citep](stauff2024assessment), builds upon the GCMR core design and neutronics model outlined in [/GCMR_Core_Neutronics.md]. This enhanced model incorporates heat conduction in solid reactor components and simulates the performance of helium coolant channels. The physical problems addressed here are analogous to the assembly models described in [/GCMR_Multiphysics_models.md], but are extended to a full-core scale (i.e., 1/6-core with symmetry)

[Multiphysics Models](gcmr/GCMR_Core_Multiphysics_models.md)

[Single Channel Blockage Transient](gcmr/GCMR_Core_SCB.md)

[Full Core Depressurization Transient](gcmr/GCMR_Core_DP.md)
