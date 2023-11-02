# Molten Salt Reactor Experiment (MSRE) Multiphysics Model

*Contact: Mauricio Tano, mauricio.tanoretamales\@inl.gov*

*Model summarized, documented, and uploaded by Andres Fierro*

This model of the MSRE utilizes MOOSE to create a 2D, RZ (cylindrical coordinates) mesh of the MSRE, Griffin to perform neutronics and resulting normalized power source [!citep](Javi23), and Pronghorn to perform medium-fidelity, coarse mesh thermal-hydraulics analysis of the core, upper plenum, pump, downcomer, and lower plenum [!citep](mau23). The parts of the MSRE loop are represented in [MSRE_pgh_mesh_blocks]. The model is an axisymmetric model with the left vertical axis being the axis of symmetry.

The fuel salt flows down the `Downcomer`, through the `Lower Plenum` and up into the `Core`, is collected at the `Upper Plenum` and finally is recycled through the `Pump`. Here a porous medium approach is used to model flow conditions in the core with a vertical porosity of 0.22283. No rugosity is assumed when computing the friction factor. An anisotropic friction source coefficient keeps the flow approximately 1-Dimensional.

!media msr/msre/MSRE_pgh_mesh_blocks.png
       style=width:80%;margin-left:auto;margin-right:auto
       id=MSRE_pgh_mesh_blocks
       caption=Subdomain (left) and mesh (right) of the multiphysics model.

## Computational Model Descriptions

The Griffin and Pronghorn input file adopts a block structured syntax. This section covers the important blocks in the input files.

## Neutronics Model

 Here Griffin is the main app detailed in the neutronics input file listed below which calls the sub app Pronghorn which is detailed in the thermal hydraulics section that is discussed later.

!listing msr/msre/multiphysics_core_model/steady_state/neu.i

#### Problem Parameters

The beginning of the input file lists the problem parameters the user can edit including the model's physical properties and initial conditions.

#### Global Parameters

Next, Global Parameters are defined in the `Global Parameters` block which give the macroscopic cross sections for the MSRE.

!listing msr/msre/multiphysics_core_model/steady_state/neu.i block=GlobalParams

#### Transport Systems

Next, the `Transport System` block determines what sort of neutronic solve Griffin will perform. Here the eigenvalue of the MSRE system is computed and corresponding boundary conditions are set --- reflecting boundary for the RZ symmetric core and vacuum boundaries elsewhere.

Additionally, the type of transport equation is selected. In this case the a simplified Diffusion equation is sufficient for fast multiphysics coupling. Additionally, options for the jacobian and fission source auxiliary variable are selected here.

!listing msr/msre/multiphysics_core_model/steady_state/neu.i block=TransportSystems

#### Mesh

The `Mesh` block can either generate a mesh using the MOOSE meshing capabiility or reads in a previously generated mesh. Here, the Mesh block reads in a MOOSE generated mesh and specifies that the model is RZ.

!listing msr/msre/multiphysics_core_model/steady_state/neu.i block=Mesh

#### Aux Variables

The `AuxVariables` block is specificed next. Through the ```Auxiliary Variables```, developers can define external variables that are solved or used in the primary simulation. The variable types, functions, and scaling factors are explained in detail [here](https://mooseframework.inl.gov/syntax/AuxVariables/index.html). Aux variables can be set explicitly in this block, or passed from other apps to perform multiphysics coupling.

In this case, the velocity, fuel salt and solid temperatures, and delayed neutron precursor group distributions will be informed by the sub app Pronghorn, whereas the fission rate will be calculated by Griffin and passed to the sub app Pronghorn.

!listing msr/msre/multiphysics_core_model/steady_state/neu.i block=AuxVariables

#### Aux Kernels

Correspondingly, the `AuxKernels` block specifies Kernels which act on the auxiliary variables. Here an array of delayed neutron precursors concentration is built to be read in by Griffin. Additionally, the fuel salt nuclide constituent concentrations are updated due to fuel salt density changes.

!listing msr/msre/multiphysics_core_model/steady_state/neu.i block=AuxKernels

#### User Objects

Next, the `UserOjbects` block specifies User Objects that can be used by other moose applications. Here both the transport solutions and aux variable solutions are stored in their corresponding user objects.

!listing msr/msre/multiphysics_core_model/steady_state/neu.i block=UserObjects

#### Power Density

The `PowerDensity` block specifies how the Power Density is calculated in Griffin. Here the total power is used to scale the power density calculated during the eigenvalue solution.

!listing msr/msre/multiphysics_core_model/steady_state/neu.i block=PowerDensity

#### Materials

The `Materials` block specifies what materials will be used in the neutronic calculation, and defines the corresponding material IDs from the macroscopic cross section library.

Here the nuclide densities are updated through the Aux Kernel operations, and transfered to the Materials block via the `auxvar_solution_s1` user object.

!listing msr/msre/multiphysics_core_model/steady_state/neu.i block=Materials

#### Postprocessors

The `Postprocessors` block allows for the user to calculate additional items of interest and have them included in the output.

Here the max and average temperatures for both the fuel and moderator, as well as reaction rates and neutron leakage are calculated in this block.

!listing msr/msre/multiphysics_core_model/steady_state/neu.i block=Postprocessors

#### Executioner

The `Executioner` block sets up how the neutronics solve is performed. Here the eigenvalue solve is selected, and the numerical method of solving it --- the Preconditioned Jacobian Free Newton Krylov - Matrix Only (PJFNKMO) --- is specified.

Additionally, PETSc options and tolerances for internal convergence and Picard iterations for multiphysics convergence are selected.

!listing msr/msre/multiphysics_core_model/steady_state/neu.i block=Executioner

#### Multi Apps

Finally, the `MultiApps` block sets up any sub apps that will be used in a multiphysics coupling. Here we just have one multi app which is the Pronghorn solve of the thermal hydraulics and delayed neutron precursor group distributions.

!listing msr/msre/multiphysics_core_model/steady_state/neu.i block=MultiApps

#### Transfers

Correspondingly, the `Transfers` block determines how the main and sub apps will communicate with each other. These transfers send auxiliary variables to and from different apps. Here the `power_density` and `fission_source` calculated by Griffin is sent to the sub-app Pronghorn to inform the thermal hydraulic solution.

In return, Pronghorn sends the delayed neutron precursor group distributions `c1-c6`, the solid and liquid temperatures, and the velocities to Griffin to determine the steady state multiphysics solution of the reactor.

!listing msr/msre/multiphysics_core_model/steady_state/neu.i block=Transfers

#### Outputs

Lastly, the `Outputs` block specifies what type of output (e.g. exodus and CSV) will be created during the simulation.

!listing msr/msre/multiphysics_core_model/steady_state/neu.i block=Outputs

## Thermal Hydraulics Model

 Next, Pronghorn (AKA Moose Navier Stokes Module) is the sub app detailed in the neutronics input file listed below which performs the thermal hydraulic calculations of the core and primary loop.

!listing msr/msre/multiphysics_core_model/steady_state/th.i

#### Problem Parameters

The physical properties are defined first. The core porosity is defined at a ratio of 0.222831, calculated as the quotient of flow area by total core area. The porosity for the rest of the components is set to 1, full fluid region, but is editable by the user.

!listing msr/msre/multiphysics_core_model/steady_state/th.i start=# Properties end=mfr

<!-- Double Check this Section Mauricio - I'm lookign at mfr which is 0.07571 for m3/s? Instead of 191.19 kg/s? And the pump force is still 98.2 kN or with the functor that's changed? -->

The following section focuses on the operational parameters. The mass flow rate was defined at 191.19 kilograms per second, with a core outlet pressure approximately atmospheric at 101.325 kiloPascals. The salt core inlet temperature is defined to be 908.15 Kelvin (K) with an ambient room temperature defined to be 300K. Finally, this section defines the pump force scaling for the centrifugal pump functor to obtain a pump force of 98.2 kiloNewton (kN).

!listing msr/msre/multiphysics_core_model/steady_state/th.i start=mfr end=# Hydraulic diameter

Next, the hydraulic diameters of the flow channels are set respectively. The fluid blocks are defined to indicate the fluid regions.

!listing msr/msre/multiphysics_core_model/steady_state/th.i start=# Hydraulic diameter end=lambda1

The end of the first section defines the delayed neutron group properties, both their production rate due to fission and decay rate. It also define the turbulent Schmidt number and the initial temperature of the fuel salt.

!listing msr/msre/multiphysics_core_model/steady_state/th.i start=lambda1 end=[GlobalParams]

#### Global Parameters

Next, Global Parameters are defined in the `Global Parameters` block.

!listing msr/msre/multiphysics_core_model/steady_state/th.i start=[GlobalParams] end=#


#### Mesh

This block defines the geometry of the core, as shown in [MSRE_pgh_mesh_blocks]. This block reads in the same mesh that was generated using MOOSE which is identical for both Griffin and Pronghorn.

!listing msr/msre/multiphysics_core_model/steady_state/th.i start=[Mesh] end=[Problem]

#### Modules

This block defines the Module that will be used in this problem - specifically the Navier Stokes Finite Volume action.

The ```Navier Stokes Finite Volume``` action is used to define fluid properties, compute the "weakly-compressible" flow, and set up boundary conditions.

Here, the action operates on the fluid blocks which are defined at the top of the header and are substituted using the `$` sign. Recall that the `$` sign refers to variable substitutions. "Weakly-compressible" with porous_medium_treatment is selected for this model and the energy equation is also included.

Scaling factors can be tuned to increase convergence speed if needed. Numerical schemes can also be selected for solving the Navier Stokes equations with different methods of pressure and velocity interpolation.

Porosity, friction, and turbulence treatment can be modified here using various correlations and models. Fluid properties are also set here and can be modified.

The action also incorporates external physics like a volumetric heat source due to the power_density calculated by Griffin. Lastly boundary conditions are set to constrain the different Navier Stokes equations.

blocks The action allows users to simply modify the equations that are solved, choose numerical schemes, define the porosity and friction treatment, define fluid properties, couple with other physics for energy deposition, and set boundary conditions.

The scalar equations for delayed neutron precursor groups are not included here in the action since they are defined externally elsewhere in the input file

!listing msr/msre/multiphysics_core_model/steady_state/th.i start=[Modules] end=[FluidProperties]


#### Fluid Properties

This block contains parameters applied to all the core components. The `fluid_properties_obj` refers to the primary salt F-Li-Be (FLiBe), already defined within MOOSE.

!listing msr/msre/multiphysics_core_model/steady_state/th.i start=[FluidProperties] end=[Variables]


Fluid properties are further defined within the ```Navier Stokes Finite Volume``` action and the Materials block.

!listing msr/msre/multiphysics_core_model/steady_state/th.i start=# fluid properties end=# Energy source-sink language=cpp

!listing msr/msre/multiphysics_core_model/steady_state/th.i start=## Fluid end=## Drag language=cpp

#### Variables

This block contains the variables that are explicitly solved for in this model. These include the velocity, pressure, temperature, and six delayed neutron precursor groups.

!listing msr/msre/multiphysics_core_model/steady_state/th.i start=[Variables] end=[FVKernels]

#### Finite Volume Kernels

Furthermore, corresponding to the variables are the finite volume kernels which operate on these variables. Most of the kernels are set implicitly within the Navier Stokes action. However Kernel tweaking is possible and here the pump, delayed neutron precursor group advection equations, and solid heat conduction are explicitly set.

!listing msr/msre/multiphysics_core_model/steady_state/th.i start=[FVKernels] end=[FVInterfaceKernels]

#### Finite Volume Interface Kernels

Additionally, finite volume interface Kernels can be deployed to account for specific interfacial modeling at boundaries. Here an explicit heat transfer correlation is implimented at the `core_downcomer_boundary`.

!listing msr/msre/multiphysics_core_model/steady_state/th.i start=[FVInterfaceKernels] end=[Functions]

#### Functions

The next block looks at setting functions which are then used in functors or initial conditions in the model. Functions give users added flexibility to edit the model and use it for their own needs.

!listing msr/msre/multiphysics_core_model/steady_state/th.i start=[Functions] end=[AuxVariables]

#### Aux Variables

Through the ```Auxiliary Variables```, developers can define the variable type for porosity, power density, and the fission sources, along with their domain. The variable types, functions, and scaling factors are explained in detail [here](https://mooseframework.inl.gov/syntax/AuxVariables/index.html). Aux variables can be set explicitly in this block, or passed from other apps to perform multiphysics coupling.

The porosity variable is a constant field defined in the fluid blocks across the domain.
The fluid blocks are defined at the top of the header and are substituted using the `$` sign. Recall that the `$` sign refers to variable substitutions.

The power density is a constant field defined in the core and plena blocks. The initial conditions for both the power density and the fission source are a cosine guess, defined below. These initial condition guesses are then udpated with the Griffin solution that is passed to Pronghorn.

!listing msr/msre/multiphysics_core_model/steady_state/th.i start=[AuxVariables] end=[AuxKernels]

#### Aux Kernels

Correspondingly, the ```Auxiliary Kernels``` operate on the ```Auxiliary Variables```. Here the porosity and density auxiliary variable are incorporated into the automatic differentiation process through the ```ADFunctorElementalAux```

!listing msr/msre/multiphysics_core_model/steady_state/th.i start=[AuxKernels] end=[Postprocessors]

#### Postprocessors

The postprocessor block allows for the user to calculate additional items of interest and have them included in the output. These can be useful to check assumptions that the user makes when setting up the model to ensure the model is performing as the user intends.

Here the inlet and outlet pressures and temperatures are determined as well as the volumetric flow rate and area in the downcomer.

!listing msr/msre/multiphysics_core_model/steady_state/th.i start=[Postprocessors] end=[Materials]

#### Materials

The Materials block allows for users to set various material parameters and correlations for the model. Here the porosity, hydraulic diameter, fluid properties, drag correlations and porosity delayed neutron precursor distributions are set.

!listing msr/msre/multiphysics_core_model/steady_state/th.i start=[Materials] end=[Debug]

#### Materials

The Materials block allows for users to set various material parameters and correlations for the model. Here the porosity, hydraulic diameter, fluid properties, drag correlations and porosity delayed neutron precursor distributions are set.

!listing msr/msre/multiphysics_core_model/steady_state/th.i start=[Materials] end=[Debug]

#### Executioner

Finally, the Executioner block determines how the model is run. The type of solve, method, PETSc options and convergence tolerances are set in this block. Additionally the time stepping method, end time, and steady state detection options are defined in this block.

!listing msr/msre/multiphysics_core_model/steady_state/th.i start=[Executioner] end=[Output]

#### Outpuut

Lastly, the Output block specifies what type of output (e.g. exodus and CSV) will be created and what items should be printed during the simulation.

!listing msr/msre/multiphysics_core_model/steady_state/th.i start=[Outputs] end=[[]]
