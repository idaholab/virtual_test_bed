# FHR Steady-State Model

*Contact: Guillaume Giudicelli, guillaume.giudicelli.at.inl.gov*

*Model link: [FHR Steady-State Multiphysics Model](https://github.com/idaholab/virtual_test_bed/tree/devel/pbfhr/steady)*

!tag name=FHR Core Steady-State Model pairs=reactor_type:PB-FHR
                       reactor:Mk1-FHR
                       geometry:core
                       simulation_type:core_multiphysics
                       input_features:multiapps
                       code_used:BlueCrab
                       computing_needs:Workstation
                       fiscal_year:2020

These input files may be used to perform a coupled multiphysics steady state simulation of the
Mk1-FHR. Each physics is solved by the relevant MOOSE application: the [neutronics](steady/griffin.md) by Griffin, the
[thermal hydraulics](steady/pronghorn.md) by Pronghorn and the [fuel performance](steady/pebble.md) by the combined usage of Pronghorn and the MOOSE heat conduction module. A
combined application, Direwolf (all users) or BlueCRAB (NRC only), is currently necessary to run the multiphysics coupled problem.

The physics coupling is performed using the MultiApp system. In MOOSE vocabulary, the neutronics application is
the main application, the thermal hydraulics and heat conduction are sub-apps. The coupling scheme is
shown in Figure 1. Applications are run successively with Picard fixed-point iterations to converge
the multiphysics problem. They are said to be tightly coupled, as opposed to loose coupling if the scheme was not
iterated, and fully-coupled if a single calculation/matrix was used to solve the multiphysics problem.

!media media/pbfhr/coupling_scheme_current.png
       style=width:70%;margin-left:15%
       caption=Figure 1: Current multiphysics computation scheme for the Mk1-FHR model steady state model

Results for the steady state solution are shown [here](steady/griffin_pgh_results.md).

!alert note
To request access to Direwolf, Pronghorn or Griffin, please submit a request on the
[INL modeling and software website](https://inl.gov/ncrc/).

## Quick links:

[neutronics - Griffin](steady/griffin.md)

[thermal hydraulics - Pronghorn](steady/pronghorn.md)

[pebble heat conduction](steady/pebble.md)

[TRISO heat conduction](steady/triso.md)

[Griffin-Pronghorn steady state results](steady/griffin_pgh_results.md)
