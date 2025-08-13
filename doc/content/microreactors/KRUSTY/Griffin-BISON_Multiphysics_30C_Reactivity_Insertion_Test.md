# Griffin-BISON Multiphysics 30 Ȼ Reactivity Insertion Test

This document outlines the efforts on modeling the 30 Ȼ reactivity insertion tests conducted in the KRUSTY warm critical experiments. This model is developed based on the 15 Ȼ Reactivity Insertion Test model. 

## Overview

Similar to the [15 Ȼ reactivity insertion transient](Griffin-BISON_Multiphysics_15C_Reactivity_Insertion_Test.md), KRUSTY was operated at a zero-power critical state (fission power negligible) at room temperatures prior to the transient. The 30 Ȼ test started by repeating the 15 Ȼ test with roughly 15 Ȼ reactivity inserted in a single step to initiate the transient [!citep](Poston2020_1). Fission heat generated in the UMo fuel region increased as the radial reflector of KRUSTY was lifted upwards, covering more portion of the fuel disk. The fuel region heated up and thermally expanded, creating negative reactivity feedback to reduce the power. The power peaked at 3.65 kW and was brought down due to increased neutron leakages. An additional 15 Ȼ reactivity was added to the core incrementally when the reactor power dropped at about 3 kW. With small reactivity inserted to the core, the reactor power was maintained around 3 kW for about 150 s. During this period, the fuel temperature increased continuously which led to more negative reactivity feedback. With no additional reactivity added to the core, the reactor power dropped again due to the increased negative reactivity feedback. The total excess reactivity inserted to the core was estimated to be about 29.9 Ȼ. The β_eff was assumed to be 650 pm [!citep](Poston2020_1).

## Griffin-BISON Multiphysics Model

The Multiphysics model to simulate the 30 Ȼ run are very similar to the model developed for the 15 Ȼ test [!citep](Poston2020_1). Specifically, a two-level MOOSE MultiApp hierarchy with Griffin for neutronics and BISON for thermos-mechanics was used to couple the two codes. Fission power was calculated using the DFEM-SN(2,3) solver accelerated with the CMFD technique. Anisotropic scattering of neutrons in the reflectors were modeled by setting NA=3 and adopting a hybrid cross section set. BISON read the fission power from Griffin to solve for core temperatures and displacement fields. Griffin neutronic calculations were then repeated with the updated temperature fields and displacement fields and provided updated fission power to BISON. 

The approach to model the first 15 Ȼ reactivity insertion for starting up the 30 Ȼ transient is the same as those in the 15 Ȼ model [!citep](Poston2020_1), except that the radial reflector displacement was slightly reduced (1.447 mm instead of the 1.48 mm) considering the measured peak power was 3.65 kW instead of 3.75 kW. To model the control mechanism used in KRUSTY for maintaining a constant power, an automatic reactivity insertion mechanism was implemented. The radial reflector was raised by about 0.126 mm whenever the quarter-core power passed below 750 W. With this mechanism, the reactor power was successfully maintained between 750 ∼760 W window for approximately 150 seconds in the simulation. The total displacement of the radial reflector during the second stage is 1.638 mm, resulting in a total of 3.085 mm reflector insertion throughout the simulation of the 30 Ȼ test. The total reactivity added in the numerical model was estimated to be about 29.7 Ȼ, which is close to the 29.9 Ȼ from experiments. 
The displacements were created by applying a Dirichlet boundary condition to the bottom surface of the solid assembly in BISON. Figure 1 presents the calculated displacement fields before the transient, after the startup and after all 29.7 Ȼ inserted to the core. 

!media media/KRUSTY/reactivity_insertion_30c.png
      style=display: block;margin-left:auto;margin-right:auto;width:85%;
      id=reactivity_insert
      caption=Displacement field prior the 30 Ȼ transient (left), at the beginning of the transient (middle) and after the transient (right).

The steps of modeling the 30 Ȼ transient are like the steps for 15 Ȼ test. Griffin was the main application which calculates the fission power, controls the time steps, and calls the BISON sub-application to calculate the temperature distributions as well as the displacement fields. Listing 1-6 include the key blocks that were unique for modeling the 30 Ȼ tests, in particular for modeling the second step of the transient. 

!listing microreactors/KRUSTY/Multiphysics_30C_RIT/KRUSTY_Griffin_SN23_NA23_CMFD_TR.i
         block=Executioner/TimeStepper
         id=input_tr_timestep
         caption=Input block in Griffin main application to control the time step based on the number of iterations and power evolution.

The upper limit for the current time step length between 755 second and 900 s is determined by the postprocessor “power_driven_dt” which is defined in [power_driven_dt].

!listing microreactors/KRUSTY/Multiphysics_30C_RIT/KRUSTY_Griffin_SN23_NA23_CMFD_TR.i
         block=Postprocessors/power_driven_dt
         id=power_driven_dt
         caption=Input block which defines the postprocessor `power_driven_dt`, which is utilized to control the time step size.

These postprocessors help make it possible to control the time step size during the insertion of the second 15 Ȼ.

!listing microreactors/KRUSTY/Multiphysics_30C_RIT/KRUSTY_Griffin_SN23_NA23_CMFD_TR.i
         block=Transfers/from_bison_disp Transfers/to_bison_disp
         id=transfers
         caption=Input blocks to transfer the displacement positions between BISON and Griffin for modeling the second step of the experiment.

As an essential part of the control approach used for the second stage of reactivity insertion, the shift value of the radial reflector at the last time step must be accessible by the control algorithm. To prevent the confusion caused by fixed point iteration, this value is transferred to the main application and transferred back into another postprocessor.
The input blocks for the three postprocessor, in which the `disp_old_medium` is defined in the Griffin input and the other two defined in BISON input are included in the [bison_pp].

!listing microreactors/KRUSTY/Multiphysics_30C_RIT/KRUSTY_BISON_THERMOMECHANICS_TR.i
         block=Postprocessors/disp_old_origin Postprocessors/disp_old_target
         id=bison_pp
         caption=Input blocks for defining the postprocessors in transferring the displacements.

!listing microreactors/KRUSTY/Multiphysics_30C_RIT/KRUSTY_BISON_THERMOMECHANICS_TR.i
         block=Functions/ref_mov
         id=ref_mov_func
         caption=Input blocks that define the function “ref_mov” in [bison_pp].

The definitions for each of the variables and symbols were listed in [ref_mov_defs] below:

!table id=ref_mov_defs caption=Definition of the constant values in the `ref_mov` function that used to describe the radial reflector movement in the second step of the 30 Ȼ test.
| Constant Name | Description |
| :- | :- |
| `reflector_disp_init` | initial reflector displacement at the start of the test |
| `reflector_disp_increment_1` | increment of the reflector displacement at the first 15 Ȼ insertion |
| `reflector_disp_increment_2` | nominal total increment of the reflector displacement at the second 15 Ȼ insertion |
| `rdi2_scale_factor` | scale factor for the second 15 Ȼ insertion that is tuned to achieve ~150 second power maintenance |
| `t_first_15c_insertion` | time at which the first 15 Ȼ insertion is completed (starting from t = 0) |
| `t_start_power_monitoring` | time at which the power starts to be monitored for power maintenance during the second 15 Ȼ insertion |
| `existing_reflector_disp` | existing reflector displacement recorded by a post-processor |
| `unit_increment_fraction` | fraction of the nominal total increment of the reflector displacement at the second 15 Ȼ insertion that is applied during each insertion step; the value is obtained by tuning to limit the power jump during each step of the insertion |
| `pw` | total current power of the microreactor |
| `pw_ref` | reference power for power maintenance during the second 15 Ȼ insertion |


The  function “Ref_mov” has also been used to prescribe the boundary condition for generating the displacement mesh as its input block is included in Listing 6. 

!listing microreactors/KRUSTY/Multiphysics_30C_RIT/KRUSTY_BISON_THERMOMECHANICS_TR.i
         block=BCs/BottomSSFixZ
         id=bison_bcs
         caption=Input block for defining the BISON boundary condition at the bottom surface the comet

## Simulation Results

[power_tr_30c] compares the total power calculated by Griffin with the measured total power from neutron detectors. Overall, the calculated power history matches experimental history well. The multiphysics model predicted the power peaking accurately. In experiment, the experiment achieved a peak power of 3.65 kW, or a quarter-core power of 913 W, and the numerical model calculated a peak quarter-core power of 913.5 W. After the peaking, when the quarter-core power drops to 750 W, the automatic reactivity insertion mechanism was proved to be able to maintain the quarter-core power within the 750~760 W window for approximately 150 seconds, which agrees also well with the experimental data. Finally, in the absence of additional reactivity insertion, reactor power started to decrease continuously. [power_tr_30c] also shows that the multiphysics model predicts the power decreasing rate correctly. 

!media media/KRUSTY/power_30c_tr.png
      style=display: block;margin-left:auto;margin-right:auto;width:60%;
      id=power_tr_30c
      caption= Predicted power evolution vs measurement (30 ₵ test)