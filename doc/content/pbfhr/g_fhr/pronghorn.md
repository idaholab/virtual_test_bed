# Pronghorn thermal hydraulics steady state for gFHR

*Contact: Dr. Mustafa Jaradat, Mustafa.Jaradat\@inl.gov*

*Sponsor: Dr. Steve Bajorek (NRC)*

*Model summarized, documented, and uploaded by Dr. Mustafa Jaradat and Dr. Samuel Walker*

Pronghorn is the thermal hydraulics solver we use to simulate fluid flow and conjugate heat transfer in the gFHR core. In the same input file, we model the heat transfer in the solid phase in the core and heat conduction in the solid components around the core, for a total of five equations: conservation of mass, x- and y-momentum (in RZ coordinates),
fluid and solid energy.

We are using the finite volume capabilities in MOOSE to model all these physics. We use an
weakly-compressible approximation for the fluid flow. There are various closures used in the pebble bed for the heat transfer coefficients, the drag models, which are
detailed in the [Pronghorn manual](https://inldigitallibrary.inl.gov/sites/sti/sti/Sort_24425.pdf). For a more detailed analyses of the specific Navier-Stokes equations that are solved for FHRs please see the [Mark 1 Pronghorn Model](pbfhr/mark_1/steady/pronghorn.md).

## Problem Parameters

We first define in the input file header physical quantities such as the core geometry, hydraulic diameters of flow paths, porosities, interpolation methods, core power, fluid blocks, heat transfer coefficients, and a Forcheimer friction coefficient.

!listing /pbfhr/gFHR/steady/gFHR_pronghorn_ss.i start=inner_radius =  end=# end

## Global Parameters & Debug Block

We also define a few global parameters that will be added to every block that may use them. This is
done to reduce the length of the input file and improve its readability.

Here we set the pebble diameter, fluid properties, pressure, interpolation methods, density, acceleration, and Rhie-Chow user object.

!listing /pbfhr/gFHR/steady/gFHR_pronghorn_ss.i block=GlobalParams

Additionally, there's a very short `Debug` block which simply specifies that we want the variable residual norms to be showed in the output as the model runs.

!listing /pbfhr/gFHR/steady/gFHR_pronghorn_ss.i block=Debug

## Mesh and geometry

The mesh input is standardized across MOOSE applications. The [Mesh](https://mooseframework.inl.gov/application_usage/mesh_block_type.html) block is different from the one we saw for Griffin since the thermal-hydraulic mesh incorporates flow paths that go beyond the core. Similarly, we use the `CartesianMeshGenerator` to make our mesh. Then we generate side-sets to define boundaries using `SideSetsAroundSubdomainGenerator` and `SideSetsBetweenSubdomainsGenerator`.

The thermal-hydraulic mesh is shown in [thermal_hydraulic_mesh].

!media gFHR/gFHR_TH_mesh.png
  caption= Pronghorn thermal fluids mesh from [!citep](gFHR_report).
  id=thermal_hydraulic_mesh
  style=width:100%;margin-left:auto;margin-right:auto

!listing /pbfhr/gFHR/steady/gFHR_pronghorn_ss.i block=Mesh

## Physics - Navier Stokes Finite Volume Physics

Next we introduce a simplified approach to solving the thermal-hydraulic equations using the [Navier Stokes Finite Volume Physics](https://mooseframework.inl.gov/syntax/Physics/NavierStokes/index.html)

The Physics directly set up the numerical form of the thermal-hydraulic equations that will be solved rather than making the user define every single kernel explicitly. In this case the action uses a `weakly-compressible` formulation of the Navier-Stokes equations and adds in `porous_medium_treatment` to model flow through the graphite pebbles.

Boundary conditions are set here, with no slip `wall_boundaries`, `inlet_boundaries`, and `outlet_boundaries` where in fluid dynamics fashion, the inlet is a `fixed-velocity`, and the outlet is a `fixed-pressure`.

The heat convection from blocks to the coolant is defined in the `ambient_convection` section. Friction factors using the darcy and forchheimer friction factors are also read into the equations here. Lastly, the remaining advection interpolation methods for momentum and mass are defined as well.

A `Physics` is set up for every equation that is being solved. The `Physics` communicate with each other to verify their parameters to some extent, attempting to minimize the number of errors. The equations being solved here are:

- the mass and momentum equations by the `Flow` Physics


!listing /pbfhr/gFHR/steady/gFHR_pronghorn_ss.i block=Physics/NavierStokes/Flow

- the fluid energy conservation equation by the `FluidHeatTransfer` Physics


!listing /pbfhr/gFHR/steady/gFHR_pronghorn_ss.i block=Physics/NavierStokes/FluidHeatTransfer


- the solid energy conservation equation by the `SolidHeatTransfer` Physics


!listing /pbfhr/gFHR/steady/gFHR_pronghorn_ss.i block=Physics/NavierStokes/SolidHeatTransfer

## Auxiliary Variables

Next the [AuxVariables](https://mooseframework.inl.gov/syntax/AuxVariables/) are listed which can be used to define fields/variables that are not solved for. They may be used for coupling, for
computing material properties, for outputting quantities of interests, and many other uses. In this input file, we define auxiliary variables for items like the Courant-Friedrichs-Lewy (CFL) condition `CFL_Now`, density `rho_var`, or heat capacity `cp_var`. Additionally, we have auxiliary variables that are used in Multi-app Transfers such as the `power_density` from the neutronics solve, and `rho_var` from the thermal hydraulics solve. Lastly we have auxiliary variables used for heat transfer or friction factor correlations.

!listing /pbfhr/gFHR/steady/gFHR_pronghorn_ss.i block=AuxVariables

## Functions

The [Functions](https://mooseframework.inl.gov/syntax/Functions/index.html) block is defined next. Here functions are defined that can be used elsewhere in the input file. Most of these function define porosity for specific locations in the model using the `ParsedFunction` which is a versatile way of setting up various functions.

!listing /pbfhr/gFHR/steady/gFHR_pronghorn_ss.i block=Functions

## Auxiliary Kernels

Similarly we can have [Auxiliary Kernels](https://mooseframework.inl.gov/moose/syntax/AuxKernels/) which operate on the [Auxiliary Variables](https://mooseframework.inl.gov/syntax/AuxVariables/). Similarly - the `ParsedAux` is a powerful tool in performing various actions that operate on the Auxiliary Variables. Specifically - heat transfer, turbulence, and friction factor correlations can be implemented here.

!listing /pbfhr/gFHR/steady/gFHR_pronghorn_ss.i block=AuxKernels

## Fluid Properties

Very briefly we introduce the [Fluid Properties](https://mooseframework.inl.gov/moose/syntax/FluidProperties/) which imports thermophysical properties at evaluates this data at the temperature and pressure that is calculated by the thermal hydraulic solution. Here FLiBe molten salt thermophysical properties are loaded in.

!listing /pbfhr/gFHR/steady/gFHR_pronghorn_ss.i block=FluidProperties

## Functor Materials

Next we define [Functor Materials](https://mooseframework.inl.gov/moose/syntax/FunctormMterials/) which define specific materials which are functors and can be used and incorporated within the `Kernels` or `Auxiliary Kernels` to perform specific calculations.

A few examples here are the `GeneralFunctorFluidProps` which performs the evaluation of thermophysical properties of the FliBe salt from the `FluidProperties` and the thermal hydraulic variables that are being solved for (i.e., T_fluid, pressure, speed). Additionally, the characteristic length or the hydraulic diameter, porosity, and friction factors of flow regions in the model can also be defined here and used in the Action or FVKernels.

!listing /pbfhr/gFHR/steady/gFHR_pronghorn_ss.i block=FunctorMaterials

## Postprocessors

Nearing the end of the model, the [Postprocessors](https://mooseframework.inl.gov/syntax/Postprocessors/) block specifies calculations that should be made regarding the solution that may be used during picard iterations or for data analysis after convergence. There are many different types used in this model including `ElementExtremeValue`, `ParsedPostprocessor` which also gives the user a wide berth of possibilities to calculate specific values of interest, `ElementIntegralVariablePostprocessor`, and `SideAverageValue` to name a few. Here both postprocessors for the thermal-hydraulic solve are listed which operate on the pressure, velocity, and temperatures solved for in the numerical simulation, as well as values that were transferred in from Griffin like the `power_density`.

!listing /pbfhr/gFHR/steady/gFHR_pronghorn_ss.i block=Postprocessors

## Preconditioning

Next we declare the [Preconditioning](https://mooseframework.inl.gov/syntax/Preconditioning/) block which specifies what kind of preconditioning matrix the user wants to implement. Here the Single Matrix Preconditioner (SMP) is used with specific PETSc options selected.

!listing /pbfhr/gFHR/steady/gFHR_pronghorn_ss.i block=Preconditioning

## Executioner - Solving the Equations

The [Executioner](https://mooseframework.inl.gov/syntax/Executioner/index.html) block defines how the non-linear system will be solved. Since this is a transient problem,
we are using a [Transient](https://mooseframework.inl.gov/moose/source/executioners/Transient.html) executioner. Pronghorn makes use of automatic differentiation, more information
[here](https://mooseframework.inl.gov/magpie/automatic_differentiation/index.html), to compute an exact Jacobian,
so we make use of the Newton method to solve the non-linear system.

We then specify the solver tolerances. These may be loosened to obtain a faster solve. They should initially be set
fairly small to obtain a tight convergence, then relaxed to improve performance.

Finally we set the time parameters for the simulation. We choose a very large runtime. We use an adaptive time-stepper to increase the time step over the course of the simulation which uses a postprocessor to define what the new time step should be. Because we are using an implicit scheme, we can take very large time steps and still have a stable simulation.

!listing /pbfhr/gFHR/steady/gFHR_pronghorn_ss.i block=Executioner

## Outputs

Lastly we define the output forms for the model which will be filled with the information listed in the `Postprocessor` block and the `Variables` and `Auxiliary Variables` blocks.

We then define an [Exodus](https://mooseframework.inl.gov/source/outputs/Exodus.html) output. This will have the multi-dimensional distributions of the quantities Pronghorn
solved for: the fluid velocities, the pressure and the temperature fields. We also include the material properties
to help us understand the behavior of the core.

We also define a [CSV](https://mooseframework.inl.gov/source/outputs/CSV.html) output which will list all of the postprocessors for each time step.

!listing /pbfhr/gFHR/steady/gFHR_pronghorn_ss.i block=Outputs
