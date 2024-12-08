# SAM Generic PBR Model and Results

!tag name=SAM HTR-PM Model
  image=https://mooseframework.inl.gov/virtual_test_bed/media/htrpm_sam/loop-schematics-VTB.png
  description=This is a SAM HTR-PM reference plant model with steady-state and transient PLOFC simulations
  pairs=reactor_type:HTGR
                       reactor:HTR_PM
                       geometry:core;primary_loop
                       simulation_type:thermal_hydraulics
                       transient:steady_state;PLOFC
                       input_features:checkpoint_restart;multiapps
                       V_and_V:verification
                       codes_used:SAM
                       computing_needs:Workstation
                       fiscal_year:2024
                       sponsor:NRC
                       institution:ANL

[SAM HTR-PM model](htr-pm/htr-pm_model.md)

[SAM HTR-PM results](htr-pm/htr-pm_results.md)
