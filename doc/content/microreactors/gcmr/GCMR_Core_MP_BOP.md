# Full Core GCMR Multiphysics Model with Balance-of-Plant

## Overview

This model extends the [Full Core GCMR Multiphysics Model](/GCMR_Core_Multiphysics_models.md) by coupling the reactor core to a plant-level power conversion system, i.e., the balance of plant (BOP). The GCMR power conversion system employs an open-air recuperated Brayton cycle as the secondary loop, designed to convert the 20 MW$_{\text{th}}$ produced by the core into electrical power. The core neutronics (Griffin) and heat conduction (BISON) models are inherited from the baseline model and are not repeated here; the distinguishing feature of this model is the addition of a self-contained thermal-hydraulic loop model, built with the MOOSE Thermal-Hydraulics Module (THM), that represents the complete primary and secondary loops together with the turbomachinery dynamics.

Whereas the baseline model prescribes fixed core inlet conditions (inlet temperature, outlet pressure, and inlet velocity) for the detailed per-channel coolant model, the BOP model computes these boundary conditions dynamically from the plant response. This closes the loop between the core and the power conversion system and enables plant-level transient analyses that a stand-alone core model cannot capture, such as the full startup sequence and load-following maneuvers.

Two simulation cases are provided:

1. A **plant startup transient** (`steady_state_bop/`), which brings the plant from a cold, static state to full-power steady-state operation. The converged end state is stored via a checkpoint and serves as the initial condition for the transient case.
2. A **load-following transient** (`transient_bop/`), which reduces the secondary motor torque to modulate the helium mass flow rate and demonstrates the passive self-regulation of the coupled core–BOP system.

## Balance-of-Plant Model

The BOP loop is modeled with THM [!cite](SAMTheoryManual) and is referenced by BISON as a thermal-hydraulic sub-application. On the primary side, the core geometry is simplified to a one-dimensional/two-dimensional (1D–2D) representation, in which all coolant channels in the core are collapsed into a single representative channel coupled to a single cylindrical heat structure. This heat structure represents the combined fuel, graphite matrix, and moderator regions using concentric hollow cylinders with geometric parameters chosen to preserve the total volume of each material region.

On the secondary side, the model represents the complete Brayton cycle loop: ambient-temperature air enters a compressor, is preheated by exhaust gases in a recuperator, and is then further heated in a primary-to-secondary heat exchanger where the full 20 MW$_{\text{th}}$ is transferred from the helium primary loop. The heated air expands through a turbine, which drives both the compressor and an electrical generator via a common shaft. The turbine exhaust passes back through the recuperator to recover residual thermal energy before being released to the atmosphere.

The THM BOP model also incorporates the mechanical dynamics of the turbomachinery shaft system, including the coupled rotational inertia of the compressor, turbine, and generator. A motor provides the initial torque to spin up the shaft from rest during reactor startup. The motor torque is governed by a proportional-integral-derivative (PID) controller, which rapidly increases the shaft speed during the first few seconds of the startup transient and then gradually reduces the motor torque to zero once the turbine generates sufficient torque to sustain operation independently.

The following section describes in detail the PID trip and shutdown logic implemented in the THM framework for the gas cooled microreactor, as illustrated in the two figures. The objective of this logic is to supervise the shaft torque balance and, when necessary, to transfer the system from normal PID controlled operation to a controlled motor shutdown.
During normal operation the motor torque is regulated by a PID controller so that the shaft speed remains at its design value. In this regime the turbine torque is expected to remain lower than the motor torque, and the PID loop simply adjusts the motor torque set point to maintain speed. When the motor torque is lower than its designated shutdown value, the PID system is considered “tripped.” 

At that instant the logic performs two key actions:
1.It records the trip time, t_"trip" , which is the time at which the torque imbalance was first detected.
2.It sets a trip status flag that later enables the shutdown function to ramp the motor torque down in a controlled manner.

After the trip has been detected and recorded, the normal PID action on the motor torque is effectively bypassed and replaced by a secondary function that drives the motor torque to zero (or another predefined shutdown value) according to a prescribed ramp.

[Blocks_for_PID_control] shows the sketch of logic for PID control for GCMR. This structure allows the THM framework to represent the PID trip behavior in a transparent, modular way, facilitating verification of the control logic and straightforward modification for alternative shutdown strategies. [Sketch_of _logic_for_PID] described a tightly integrated set of Functions, AuxVariables, AuxScalarKernels, and Controls in detail. 

!media media/gcmr/FCMP/Blocks_for_PID_control.png
      id=coupling_hierarchy_strategy
      style=display: block;margin-left:auto;margin-right:auto;width:65%;
      caption= Sketch of logic for PID control for GCMR

!media media/gcmr/FCMP/Sketch_of_logic_for_PID.png
      id=coupling_hierarchy_strategy
      style=display: block;margin-left:auto;margin-right:auto;width:65%;
      caption= Detailed description on essential Functions, AuxVariables, AuxScalarKernels and Controls in THM for PID control 

The plant-level parameters (rated power, mass flow rate, pump/turbine performance, and shaft inertia) are collected at the top of the THM loop input file:

!listing microreactors/gcmr/core/Multiphysics/steady_state_bop/MP_THM_loop_bop_ss.i block=GlobalParams

The turbomachinery performance maps (compressor and turbine pressure ratios, Bingham pump head and torque) are tabulated in CSV files under the shared `param/` directory and read by the corresponding THM components. The complete component network, control logic, and postprocessors are defined in the loop input file, [`MP_THM_loop_bop_ss.i`](https://github.com/idaholab/virtual_test_bed/blob/main/microreactors/gcmr/core/Multiphysics/steady_state_bop/MP_THM_loop_bop_ss.i).

## Multiphysics Coupling

The high fidelity Griffin and Bison model are coupled with THM and SAM in a three-level MultiApp hierarchy of the baseline model and augments the BISON level with two thermal-hydraulic sub-applications:

!media media/gcmr/FCMP/coupling_hierarchy_strategy.png
      id=coupling_hierarchy_strategy
      style=display: block;margin-left:auto;margin-right:auto;width:65%;
      caption= Coupling hierarchy and strategy of the multiphysics model

- `htgr` — the THM BOP loop, which returns the plant-computed core boundary conditions (inlet temperature, outlet pressure, and inlet velocity).
- `coolant_full_MA` — the detailed per-channel helium coolant model (SAM/THM), identical in role to the baseline coolant model, which returns the fluid temperature, and convective heat transfer coefficient for each channel.

!listing microreactors/gcmr/core/Multiphysics/steady_state_bop/MP_BISON_bop_ss.i block=MultiApps

Griffin is the main application and drives the outer Picard iteration. It calculates the power density and transfers it to BISON while BISON feedback fuel and moderator temperature for further iteration. Volumetric heating density in coolant channel is calculated in BISON and transferred to THM to serve as the heart source for the BOP loop, which is used to calculate the plant-level boundary conditions such as core inlet velocity, temperature and core outlet pressure. These parameters need to be transferred to SAM for fluid temperature and convective heat transfer coefficient calculation. Instead of transferring them directly, they go through BISON just for data transfer purposes. The wall temperature is also transferred to SAM from BISOM to make a closure for the coupling system.

!listing microreactors/gcmr/core/Multiphysics/steady_state_bop/MP_BISON_bop_ss.i block=Transfers

## Plant Startup Transient

### Scenario Description

The startup transient (`steady_state_bop/`) simulates bringing the plant from a cold, static state to full-power steady-state operation, spanning approximately 55 hours of physical time. The simulation begins with all components at rest—no coolant flow, no shaft rotation, and all temperatures at ambient. The reactor power and the secondary motor torque are ramped up under control-logic supervision, and the run terminates once the plant reaches thermodynamic equilibrium. The converged state is written to a checkpoint that provides the initial condition for the load-following case.

!listing microreactors/gcmr/core/Multiphysics/steady_state_bop/MP_THM_loop_bop_ss.i block=Outputs/cp

The startup sequence is orchestrated by the THM control logic, which ramps the reactor power, manages the PID-controlled motor, and triggers the motor-to-turbine handoff:

!listing microreactors/gcmr/core/Multiphysics/steady_state_bop/MP_THM_loop_bop_ss.i block=ControlLogic

### Shaft and Turbomachinery Dynamics

A secondary motor provides the initial driving torque to spin up the turbomachinery shaft. As the Brayton cycle begins to circulate working fluid and the primary helium loop heats up, the turbine begins generating torque from the expanding gas. At the onset of the thermal equilibration phase, the secondary motor torque is approximately 150 N$\cdot$m while the turbine already generates approximately 460 N$\cdot$m; as the turbine output rises, the motor torque declines, falling to zero within approximately 2 hours ([tr_bop_st_torque]).

The key operational milestone in the startup sequence is the motor-to-turbine torque handoff. As the turbine torque rises, the secondary motor torque is progressively reduced until the motor reaches zero output, leaving the turbine to sustain shaft rotation independently. The turbine torque ultimately reaches a steady-state value of approximately 670 N$\cdot$m ([tr_bop_st_torque]), while the shaft speed stabilizes at a final rotational speed of approximately 125,000 RPM ([tr_bop_st_shaft]).

!media media/gcmr/FCMP/tr_bop_st_shaft.png
      id=tr_bop_st_shaft
      style=display: block;margin-left:auto;margin-right:auto;width:65%;
      caption=Time evolution of the turbomachinery shaft speed during the startup transient.

!media media/gcmr/FCMP/tr_bop_st_torque.png
      id=tr_bop_st_torque
      style=display: block;margin-left:auto;margin-right:auto;width:65%;
      caption=Time evolution of the motor and turbine torques during the startup transient, showing the motor-to-turbine handoff.

### Thermal Response

The primary loop temperatures reflect the thermal equilibration of both the core and the secondary loop. The core helium inlet temperature reaches approximately 797 K within approximately 20 hours of startup ([tr_bop_st_loop]), while the core outlet temperature stabilizes at approximately 1050 K, yielding the design-point temperature rise of approximately 200 K across the core. The maximum, average, and minimum fuel temperatures reach approximately 1130 K, 1000 K, and 835 K, respectively ([tr_bop_st_tempf]). These values are consistent with the steady-state multiphysics results reported for the [baseline model](/GCMR_Core_Multiphysics_models.md), confirming the self-consistency of the primary and secondary loop thermal coupling.

!media media/gcmr/FCMP/tr_bop_st_loop.png
      id=tr_bop_st_loop
      style=display: block;margin-left:auto;margin-right:auto;width:65%;
      caption=Time evolution of key primary loop gas parameters during the startup transient.

!media media/gcmr/FCMP/tr_bop_st_tempf.png
      id=tr_bop_st_tempf
      style=display: block;margin-left:auto;margin-right:auto;width:65%;
      caption=Time evolution of the maximum, average, and minimum fuel temperatures during the startup transient.

All key state variables—inlet temperature, outlet temperature, shaft speed, and torques—reach their steady-state values within approximately 20 hours, well within the 55-hour simulation window. Capturing this plant startup behavior requires the full secondary-loop turbomachinery model, including the PID-controlled motor startup and rotating shaft dynamics, in addition to the core neutronics and heat conduction models—a capability that stand-alone core-physics models cannot replicate.

## Load-Following Transient

### Scenario Description

The load-following transient (`transient_bop/`) starts from the converged startup checkpoint and analyzes the plant response to a reduction in secondary motor torque. Reducing the motor torque decreases the compressor output and therefore the helium mass flow rate through the primary loop. The transient is driven by a parsed torque function that ramps the primary motor torque to its reduced value:

!listing microreactors/gcmr/core/Multiphysics/transient_bop/MP_THM_loop_bop_tr.i block=Functions/pri_torque_func

The core neutronics and heat conduction sub-applications restart from the startup steady state. Griffin stores a vector file of neutronics variables of steady state so that the transient run can load them as initial condition. The BISON sub-application reads the converged solid-temperature field from the checkpoint written by the `steady_state_bop` case.

!listing microreactors/gcmr/core/Multiphysics/transient_bop/MP_Griffin_bop_tr.i block=UserObjects/ss

!listing microreactors/gcmr/core/Multiphysics/transient_bop/MP_BISON_bop_tr.i block=Problem

### Loop and Power Response

The reduction in motor torque lowers the core helium inlet velocity from approximately 15 m/s to approximately 10.7 m/s (a reduction of roughly 29%), and the core inlet temperature decreases by approximately 53 K (from ~797 K to ~744 K), since the recuperator preheats the working fluid less effectively at lower mass flow. Both the inlet velocity and inlet temperature reach their new steady-state values within approximately 350 seconds ([tr_bop_lf_loop]).

!media media/gcmr/FCMP/tr_bop_lf_loop.png
      id=tr_bop_lf_loop
      style=display: block;margin-left:auto;margin-right:auto;width:65%;
      caption=Time evolution of key primary loop gas parameters during the load-following transient.

The reduction in coolant flow temporarily diminishes heat removal from the high-power outlet region of the core, causing local fuel temperatures to rise and introducing negative Doppler reactivity feedback. Consequently, the normalized reactor power dips to approximately 94.3% at around 350 seconds before recovering to a new steady-state value of approximately 98.8% by approximately 1000 seconds ([tr_bop_lf_pow]).

!media media/gcmr/FCMP/tr_bop_lf_pow.png
      id=tr_bop_lf_pow
      style=display: block;margin-left:auto;margin-right:auto;width:55%;
      caption=Normalized reactor power evolution during the load-following transient.

### Fuel Temperature Response

The spatial fuel temperature distribution shifts accordingly. The maximum fuel temperature rises by approximately 25 K (from ~1125 K to ~1150 K) in the outlet region where cooling is most reduced, while the minimum fuel temperature decreases by approximately 42 K (from ~833 K to ~791 K) in the inlet region where the cooler incoming helium lowers the local temperature. The volume-averaged fuel temperature remains nearly unchanged at approximately 1000 K ([tr_bop_lf_tempf]).

!media media/gcmr/FCMP/tr_bop_lf_tempf.png
      id=tr_bop_lf_tempf
      style=display: block;margin-left:auto;margin-right:auto;width:65%;
      caption=Time evolution of the maximum, average, and minimum fuel temperatures during the load-following transient.

The reactor self-regulates to the new equilibrium without operator intervention, demonstrating the passive load-following capability of the integrated BOP–core multiphysics model.
