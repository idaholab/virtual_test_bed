# Kilopower Reactor Using Stirling TechnologY (KRUSTY)

*Contacts: Yan Cao (ycao.at.anl.gov), Yinbin Miao (ymiao.at.anl.gov), Kun Mo (kunmo.at.anl.gov), Nicolas Stauff (nstauff.at.anl.gov)*

*Model link: [KRUSTY](https://github.com/idaholab/virtual_test_bed/tree/devel/microreactors/KRUSTY)*

!tag name=Kilopower Reactor Using Stirling TechnologY (KRUSTY)
     description=Steady state multiphysics simulation of the core of the Kilopower Reactor Using Stirling TechnologY using NEAMS tools
     image=https://mooseframework.inl.gov/virtual_test_bed/media/KRUSTY/krusty_quarter_mesh.png
     pairs=reactor_type:microreactor
                       reactor:KRUSTY
                       geometry:core
                       simulation_type:neutronics;multiphysics
                       input_features:reactor_meshing;cross_section_generation;multiapps
                       transient:steady_state
                       codes_used:Griffin;BISON;BlueCrab
                       computing_needs:Workstation
                       fiscal_year:2024
                       sponsor:NEAMS
                       institution:ANL

[Model Description](KRUSTY/Model_Description.md)

[Simplified KRUSTY Monte Carlo Model](KRUSTY/Simplified_KRUSTY_Monte_Carlo_Model.md)

[Griffin-BISON Multiphysics Steady State Model](KRUSTY/Griffin-BISON_Multiphysics_Steady_State_Model.md)

[Neutronic and Multiphysics Steady State Results](KRUSTY/Neutronic_Multiphysics_Steady_State_Results.md)

[Griffin-BISON Multiphysics 15 Ȼ Reactivity Insertion Test](KRUSTY/Griffin-BISON_Multiphysics_15C_Reactivity_Insertion_Test.md)

