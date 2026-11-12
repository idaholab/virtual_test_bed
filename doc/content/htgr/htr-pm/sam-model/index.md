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

!vtb_model_summary contact_names=Zhiee Jhia Ooi;Stephen Bajorek
                   contact_emails=zooi@anl.gov;stephen.bajorek@nrc.gov
                   github_url=https://github.com/idaholab/virtual_test_bed/tree/main/htgr/htr-pm/ss

[SAM HTR-PM model](htr-pm/sam-model/htr-pm_model.md)

[SAM HTR-PM results](htr-pm/sam-model/htr-pm_results.md)
