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
                       open_source:partially
                       fiscal_year:2026
                       institution:ANL
                       sponsor:TBD

!vtb_model_summary github_url=https://github.com/idaholab/virtual_test_bed/tree/devel/lwr/pipe_welding
                   contact_names=TBD
                   contact_emails=TBD
                   vv_summary=Regression tests of the chained welding and cooldown stages;
                              Displacement transfer from welding to cooldown verified to round-off in [the cooldown page](pipe_welding_cooldown.md)

[Stage 1: 3D Multi-Pass Welding Model](pipe_welding_welding.md)

[Stage 2: 3D Cooldown Model](pipe_welding_cooldown.md)
