# MSFR Griffin-Pronghorn-Thermochimica Model

*Contact: Samuel Walker, samuel.walker@inl.gov*

*Model link: [Thermochimica Steady-State Model](https://github.com/idaholab/virtual_test_bed/tree/devel/msr/msfr/thermochemistry)*

!tag name=MSFR Griffin-Pronghorn-Thermochimica Steady State Model pairs=reactor_type:MSR
                       reactor:MSFR
                       geometry:core
                       simulation_type:core_multiphysics
                       input_features:multiapps
                       code_used:BlueCrab
                       computing_needs:Workstation
                       fiscal_year:2023

Recent efforts funded by the Nuclear Energy Advanced Modeling and Simulation (NEAMS) program have worked to wrap the Gibbs Energy Minimizer Thermochimica [!citep](Thermochimica) within the MOOSE framework [!citep](FrameworkM3). Here the Thermochimica input file `thermo.i` will be discussed.
