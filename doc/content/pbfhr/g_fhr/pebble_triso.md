# Pebble - Triso heat conduction for Equilibrium Core

*Contact: Dr. Mustafa Jaradat, Mustafa.Jaradat\@inl.gov*

*Sponsor: Dr. Steve Bajorek (NRC)*

*Model summarized, documented, and uploaded by Dr. Mustafa Jaradat and Dr. Samuel Walker*

The neutronics and thermal hydraulics simulation provide us with the power distribution and
the fluid and solid phase temperature on the macroscale. They do not resolve the individual pebbles,
and therefore cannot directly inform us on local effects such as temperature gradients within a pebble.
These are important to lead fuel performance studies, to verify that the pebbled-fuel remains within
design limitations in terms of temperature and burnup.

We use a multiscale approach to resolve the pebble conditions within the reactor. Using the [PebbleDepletion](https://griffin-docs.hpc.inl.gov/latest/syntax/PebbleDepletion/index.html) action with [ConstantStreamLineEquilibrium](https://griffin-docs.hpc.inl.gov/latest/source/pebbledepletion/pebbledepletionschemes/ConstantStreamlineEquilibrium.html) allows us to track the depletion and fuel performance of the cycling pebbles.

This pebble-triso model is run for each time step in the depletion action so that the heat and decay heat from the pebbles can be accurately predicted. For more information on the specifics of the 1-D heat conduction equation that is implemented please see the [Mark 1 pebble model](pbfhr/mark_1/steady/pebble.md) and the corresponding [Mark 1 triso model](pbfhr/mark_1/steady/triso.md).

## Problem Parameters

Similar to the other inputs files, we identify key problem parameters such as the geometric values for the pebbles and triso kernels as well as the initial power density and temperature.

## Mesh

Next we define the [Mesh](https://mooseframework.inl.gov/application_usage/mesh_block_type.html) block which defines both the `pebble_mesh` and the `triso_mesh` at different scales and their corresponding surfaces in a `RSPHERICAL`  coordinate system.

!listing /pbfhr/gFHR/steady/gFHR_pebble_triso_ss.i block=Mesh

## Variables

Next we identify the [Variables](https://mooseframework.inl.gov/syntax/Variables/) that will be solved in this sub-application - the pebble and triso temperatures.

!listing /pbfhr/gFHR/steady/gFHR_pebble_triso_ss.i block=Variables

## Kernels

The [Kernels](https://mooseframework.inl.gov/syntax/Kernels/)
block sets up the various Kernels which will operate on the variables and define the equations that will be solved.

Here we include the `ADHeatConduction`, and `CoupledForce` to model the 1-D heat conduction and heat source from the power density calculated from the Griffin neutronics solve which will be identified later in the `Postprocessors` block.

!listing /pbfhr/gFHR/steady/gFHR_pebble_triso_ss.i block=Kernels

## Auxiliary Variables

Next the [AuxVariables](https://mooseframework.inl.gov/syntax/AuxVariables/) block lists variables that are not solved for explicitly, but can be used in other kernels or in multiphysics transfers. Here the `pebble_power_density` is one such variable that gets transferred from Griffin in the `Postprocessors` block.

!listing /pbfhr/gFHR/steady/gFHR_pebble_triso_ss.i block=AuxVariables

## Auxiliary Kernels

Similarly we can have [Auxiliary Kernels](https://mooseframework.inl.gov/moose/syntax/AuxKernels/) which operate on the Auxiliary Variables. In this case, we have some `ScaleAux` and `ParsedAux` which operate on the variables `pebble_power_density`, `pfuel_power_density`, and `kernel_power_density` respectively to do simple calculations based upon the geometry of the pebbles and triso kernels.

!listing /pbfhr/gFHR/steady/gFHR_pebble_triso_ss.i block=AuxKernels


## Materials

The [Materials](https://mooseframework.inl.gov/moose/syntax/Materials/) block set up specific materials for specific areas of the model. In this case we set up the `pebble_fuel`, `pebble_graphite_core`, and `pebble_graphite_shell` with the temperature from `T_pebble` for the pebbles. Additionally, the Triso materials are also set here with `kernel`, `buffer`, `ipyc`, `sic`, and `opyc`,
all set with `T_triso` for the temperature.

!listing /pbfhr/gFHR/steady/gFHR_pebble_triso_ss.i block=Materials

## User Objects

The [User Objects](https://mooseframework.inl.gov/moose/syntax/UserObjects/) can be used to specify various objects that are used within the MOOSE framework. In this case we are specifying `FunctionSolidProperties` for the Triso particles defining the thermal conductivity, density, and heat capacity of each material layer. Then Mixture objects are defined that use `CompositeSolidProperties` to form the discrete triso particles using the various material layers, adn the pebble_fuel using the `triso` and `gmatrix` (graphite matrix) materials with their associated solid thermodynamic properties.

!listing /pbfhr/gFHR/steady/gFHR_pebble_triso_ss.i block=UserObjects

## Boundary Conditions

The [Boundary Conditions](https://mooseframework.inl.gov/syntax/BCs/) block specifies boundary conditions when solving the equations involving the `Variables` and `Kernels` which must be constrained. Here a `PostprocessorDirichletBC` is defined for the `pebble_surface` boundary and is set to the postprocessor which reads in the `T_surface` variable value. Similarly the `T_triso` variable is constrained by a Dirichlet boundary condition read in by the `pebble_fuel_average_temp` postprocessor at the `triso_surface` boundary.

!listing /pbfhr/gFHR/steady/gFHR_pebble_triso_ss.i block=BCs

## Executioner

The [Executioner](https://mooseframework.inl.gov/syntax/Executioner/index.html) block defines how the non-linear system will be solved. Here the solve is set to steady-state and the non-linear relative and absolute tolerances are set.

!listing /pbfhr/gFHR/steady/gFHR_pebble_triso_ss.i block=Executioner

## Postprocessors

Nearing the end of the model, the [Postprocessors](https://mooseframework.inl.gov/syntax/Postprocessors/) block allows for specific calculations on specific variables or auxiliary variables in the model or from other applications to be calculated and then used in the solution of this sub-application.

Here `ElementIntegralVariablePostprocessor` is used to sum up certain fields over the entire problem domain including the power densities of the pebbles in the core, and shell, as well as the triso power densities.

Next there are some `Receivers` which act similar to transfers where they read in variables from Griffin for the `pebble_power_density` and the `T_surface`. There are also postprocessors used for the Triso-Pebble communication including `pebble_fuel_average_temp` and for this sub-app heat conduction model back to the Griffin-Depletion model via `T_mod` and `T_fuel`.

!listing /pbfhr/gFHR/steady/gFHR_pebble_triso_ss.i block=Postprocessors

## Outputs

Lastly, the outputs block is specified, and here we don't want to output results since we will just feed the information from this heat conduction sub-app to Griffin.

!listing /pbfhr/gFHR/steady/gFHR_pebble_triso_ss.i block=Outputs

