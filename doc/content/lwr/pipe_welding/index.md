# Multi-Pass Pipe Welding and Cooldown Residual Stress Model

!tag name=Multi-Pass Pipe Welding and Cooldown Residual Stress Model
     description=Grizzly 3D thermomechanical model of an 8-pass girth weld in a 40 mm thick pipe wall, followed by cooldown, for weld residual stresses
     image=https://mooseframework.inl.gov/virtual_test_bed/media/lwr/pipe_welding/fig3_vonmises_after_cooldown.png
     pairs=reactor_type:LWR
                       geometry:pipe_weld
                       simulation_type:component_analysis;thermo_mechanics
                       input_features:element_activation;restart
                       transient:welding;cooldown
                       codes_used:Grizzly;MOOSE_Solid_Mechanics;MOOSE_HeatTransfer
                       computing_needs:Workstation
                       V_and_V:demonstration
                       open_source:partially
                       fiscal_year:2026
                       institution:ANL
                       sponsor:NRC

!vtb_model_summary github_url=https://github.com/idaholab/virtual_test_bed/tree/main/lwr/pipe_welding
                   contact_names=Bipul Barua;Cheng-Hau Yang
                   contact_emails=barau@anl.gov;chenghau.yang@anl.gov
                   vv_summary=Through-thickness axial residual stresses compared with the measurements and analysis of the R5 sample problem by Barua and Messner (2024), see [the welding page](pipe_welding_welding.md)

This is a demonstration case of a 3D multi-pass welding and cooldown simulation with element
activation and restart. The residual stress field it computes can be used as the initial state of
structural integrity assessments, such as the
[reactor pressure vessel probabilistic fracture mechanics model](lwr/rpv_fracture/index.md).

[Stage 1: 3D Multi-Pass Welding Model](pipe_welding_welding.md)

[Stage 2: 3D Cooldown Model](pipe_welding_cooldown.md)
