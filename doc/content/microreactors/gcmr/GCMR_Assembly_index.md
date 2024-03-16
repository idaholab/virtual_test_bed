# Gas-Cooled Microreactor Assembly

*Contacts: Ahmed Abdelhameed (aabdelhameed.at.anl.gov), Yinbin Miao (ymiao.at.anl.gov), Nicolas Stauff (nstauff.at.anl.gov)*

!tag name=Gas-Cooled Microreactor Assembly pairs=reactor_type:microreactor
                       reactor:GCMR
                       geometry:assembly
                       simulation_type:multiphysics
                       codes_used:BlueCrab;Griffin;BISON
                       input_features:multiapps
                       transient:steady_state;RIA;flow_blockage
                       computing_needs:HPC
                       fiscal_year:2023
                       institution:ANL
                       sponsor:NEAMS

[Description of the assembly design](gcmr/GCMR_Assembly_Model_Description.md)

[Multiphysics Models](gcmr/GCMR_Multiphysics_models.md)

[Dynamic Multiphysics simulation of flow blockage](gcmr/GCMR_results_FlowBlockage.md)

[Dynamic Multiphysics simulation of a Reactivity Insertion Accident](gcmr/GCMR_results_RIA.md)
