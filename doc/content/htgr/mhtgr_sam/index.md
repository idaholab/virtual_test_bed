# SAM MHTGR Model and Results

*Contact: Thanh Hua, hua.at.anl.gov*

*Model link: [MHTGR SAM Model](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/mhtgr/mhtgr_sam)*

!tag name=MHTGR SAM Model
     description=Simulation of the MHTGR primary loop during steady-state operation
     image=https://mooseframework.inl.gov/virtual_test_bed/media/mhtgr/mhtgr_sam_model.png
     pairs=reactor_type:HTGR
                       reactor:MHTGR
                       geometry:primary_loop
                       simulation_type:balance_of_plant
                       input_features:checkpoint_restart
                       codes_used:SAM
                       computing_needs:Workstation
                       fiscal_year:2022
                       sponsor:NEAMS
                       institution:ANL

[SAM MHTGR model](mhtgr_sam/sam_mhtgr_model.md)

[SAM MHTGR results](mhtgr_sam/sam_mhtgr_results.md)

