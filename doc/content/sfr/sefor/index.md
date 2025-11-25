# Southwest Experimental Fast Oxide Reactor (SEFOR) Numerical Models

*Contacts: Donny Hartanto (hartantod.at.ornl.gov)*, Ahmed Amin E. Abdelhameed (aabdelhameed.at.anl.gov)*, Yan Cao  (ycao.at.anl.gov)*, Eva Davidson (davidsonee.at.ornl.gov), Emily Shemon (eshemon.at.anl.gov)

*Model link: [SEFOR](https://github.com/idaholab/virtual_test_bed/tree/devel/sfr/sefor)*

!tag name=Southwest Experimental Fast Oxide Reactor (SEFOR)
     description=Simulation a series of SEFOR Core using the NEAMS tools pairs=reactor_type:sfr
           reactor:SEFOR
           geometry:core
           simulation_type:neutronics
           input_features:reactor_meshing;shift_reference;cross_section_generation;Griffin_neutronics
           transient:steady_state
           V_and_V:verification
           codes_used:reactor_module;Griffin;
           computing_needs:HPC
           fiscal_year:2025 
           sponsor:NEAMS
           institution:ORNL;ANL

[Model Description](sefor/Model_description.md)

[Shift Reference Models](sefor/index_Shift.md)

[Cross Section Generations](sefor/index_xs.md)

[Mesh Generations](sefor/index_mesh.md)

[Griffin Models](sefor/index_griffin.md)

[SEFOR Tests](sefor/index_sefor_tests.md)