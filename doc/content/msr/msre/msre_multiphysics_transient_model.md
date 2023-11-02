# Molten Salt Reactor Experiment (MSRE) Multiphysics Model

*Contact: Mauricio Tano, mauricio.tanoretamales\@inl.gov*

*Model summarized, documented, and uploaded by Andres Fierro*

This Transient model builds off of the existing Steady state model. Here only the difference will be highlighted to perform the transient analysis.

## Neutronics Transient Model

<!-- Double Check this Section Mauricio - Could write a short description how you "fake" the control rod movement and where this is done in the code?-->

#### User Objects

In order to start our transient, we need to load in the `UserOjbects` from the steady state solution. Both the `transport_solution_s1` and `auxvar_solution_s1` are loaded from the steady state files.

!listing msr/msre/multiphysics_core_model/transient/neu.i block=UserObjects

#### Executioner

Here the `Executioner` block sets is set to Transient, and the numerical method is changed from PJFNKMO to PJFNK. Additionally, the `TimeStepper` is used to determine how the neutronics solution steps through time during the transient.

!listing msr/msre/multiphysics_core_model/transient/neu.i block=Executioner

#### Multi Apps

Finally, the `MultiApps` block is altered to a `TransientMultiApp` solution.

!listing msr/msre/multiphysics_core_model/transient/neu.i block=MultiApps

## Thermal Hydraulics Transient Model

#### Mesh

Here the Mesh block loads in a restart file to correctly initialize the transient.

!listing msr/msre/multiphysics_core_model/transient/th.i start=[Mesh] end=[Problem]

#### Variables

Similarly, this block initializes these variables from the restart file with the `initial_from_file_var` option.

!listing msr/msre/multiphysics_core_model/transient/th.i start=[Variables] end=[FVKernels]

#### Aux Variables

Here too, the Aux Variables are also re-initialized from the restart file.

!listing msr/msre/multiphysics_core_model/transient/th.i start=[AuxVariables] end=[AuxKernels]

#### Executioner

Finally, the Executioner block is altered to run a `Transient` simulation. Additionally, the `TimeStepper` options determine how the thermal hydraulic simulation will run and when the simulation ends.

!listing msr/msre/multiphysics_core_model/transient/th.i start=[Executioner] end=[Outputs]
