# Kilopower Reactor Using Stirling TechnologY (KRUSTY)

!tag name=Kilopower Reactor Using Stirling TechnologY (KRUSTY)
     description=Steady state multiphysics simulation of the core of the Kilopower Reactor Using Stirling TechnologY using NEAMS tools
     image=https://mooseframework.inl.gov/virtual_test_bed/media/KRUSTY/krusty_quarter_mesh.png
     pairs=reactor_type:microreactor
           reactor:KRUSTY
           geometry:core
           simulation_type:neutronics;multiphysics
           input_features:reactor_meshing;cross_section_generation;multiapps
           transient:steady_state
           V_and_V:demonstration
           codes_used:Griffin;BISON;BlueCrab
           computing_needs:Workstation
           fiscal_year:2024
           sponsor:NEAMS
           institution:ANL

!vtb_model_summary
  contact_names=Yan Cao;Yinbin Miao;Kun Mo;Nicolas Stauff;
  contact_emails=ycao@anl.gov;ymiao@anl.gov;kunmo@anl.gov;nstauff@anl.gov
  github_url=https://github.com/idaholab/virtual_test_bed/tree/devel/microreactors/KRUSTY

!vtb_model_nav
    KRUSTY/Model_Description.md
    KRUSTY/Simplified_KRUSTY_Monte_Carlo_Model.md
    KRUSTY/Griffin-BISON_Multiphysics_Steady_State_Model.md
    KRUSTY/Neutronic_Multiphysics_Steady_State_Results.md
    KRUSTY/Griffin-BISON_Multiphysics_15C_Reactivity_Insertion_Test.md
    KRUSTY/Griffin-BISON_Multiphysics_30C_Reactivity_Insertion_Test.md
