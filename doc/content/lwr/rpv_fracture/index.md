# Light-Water Reactor Pressure Vessel Probabilistic Fracture Mechanics Model

!tag name=Light-Water Reactor Pressure Vessel Probabilistic Fracture Mechanics Model
     description=Grizzly 3D Light-Water Reactor Pressure Vessel Probabilistic Fracture Mechanics Model
     image=https://mooseframework.inl.gov/virtual_test_bed/media/lwr/rpv_fracture/rpv_mesh.png
     pairs=reactor_type:LWR
                       geometry:RPV
                       simulation_type:component_analysis;thermo_mechanics
                       codes_used:Grizzly;MOOSE_StochasticTools
                       computing_needs:Workstation;HPC
                       open_source:partial
                       fiscal_year:2024;2025
                       institution:INL
                       sponsor:NEAMS;LWRS

[3D Thermomechanical Model](rpv_thermomechanical_3d.md)

[3D Probabilistic Fracture Model](rpv_pfm_3d.md)
