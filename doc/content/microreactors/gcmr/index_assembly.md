# Gas Cooled Micro Reactor Assembly Multiphysics

*Contacts: Ahmed Abdelhameed (aabdelhameed.at.anl.gov), Yinbin Miao (ymiao.at.anl.gov), Nicolas Stauff (nstauff.at.anl.gov)*

!tag name=Gas-Cooled Microreactor Assembly Multiphysics
     description=3D model of an assembly of a Gas Cooled Micro Reactor with heterogeneous transport, fuel thermomechanics and coolant thermal-hydraulics
     image=https://mooseframework.inl.gov/virtual_test_bed/media/gcmr/Fig2.jpg
     pairs=reactor_type:microreactor
                       reactor:GCMR
                       geometry:assembly
                       simulation_type:neutronics;multiphysics
                       codes_used:Griffin;Bison;SAM;BlueCrab
                       transient:steady_state;flow_blockage;RIA
                       computing_needs:HPC
                       fiscal_year:2023

[Description of the assembly design](gcmr/GCMR_Assembly_Model_Description.md)

[Multiphysics Models](gcmr/GCMR_Multiphysics_models.md)

[Dynamic Multiphysics simulation of flow blockage](gcmr/GCMR_results_FlowBlockage.md)

[Dynamic Multiphysics simulation of a Reactivity Insertion Accident](gcmr/GCMR_results_RIA.md)
