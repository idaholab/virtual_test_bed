# 7. Advanced Topics

!alert note
Under construction

## Debugging Numerical Instability

- Relaxation

- Better initialization (make sure the finicky app does not have to deal with a bad solution from the other app) Plenty of techniques: run uncouple first for example

## Reliability of Transfer

## How to Handle Single App Crashes

- +How to handle TransientMultiapp when a child app fails+

As previously stated, the default behavior when running `TransientMultiApps` is that their time state is incremented, e.g. they are `auto-advance` even the sub-apps solution fails. Despite the obvious disadvantage of this approach, the syncing of main and sub-application states was implemented to enable a clear checkpoint output. The Checkpoint output object is designed to perform restart and recovery of simulations. The output files created contain a complete snapshot of the simulation. These files are required to perform restart or recovery operations with a MOOSE-based application. There could be multiple ways to turn a failed sub-application solve from a warning into an exception that will force corrective behavior by, for example, setting `auto_advance = false` in the Executioner block of the main application. This will cause the main application to immediately cut its time-step when the sub-application fails.

However, setting this parameter to false also eliminates the possibility of doing restart/recover because the main and sub apps will be out of sync if/when checkpoint output occurs. Or the user may instead set `catch_up = true` in the TransientMultiApp block. This allows failed sub-app solves to attempt to 'catch up' using smaller timesteps. If catch-up is unsuccessful, then MOOSE registers this as a true failure of the solve, and the main dt will then get cut. This option has the advantage of keeping the main and sub transient states in sync, enabling accurate restart/recover data. In general, if the user wants sub-application failed solves to be treated as exceptions, we recommend using `catch_up = true`. An example of the MultiApps block for transient multi-physics Griffin-NS (Navier-Stokes) simulation is illustrated below:

!listing /msr/msfr/transient/run_neutronics.i
         block=MultiApps
         id=catch_up
         caption=An example of using the `catch_up` option in `TransientMultiApps`.
