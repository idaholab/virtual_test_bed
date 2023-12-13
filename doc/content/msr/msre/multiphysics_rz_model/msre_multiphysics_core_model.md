# Molten Salt Reactor Experiment (MSRE) Multiphysics Model

*Contact: Mauricio Tano, mauricio.tanoretamales\@inl.gov*

*Model summarized and documented by Andres Fierro, Dr. Samuel Walker, and Dr. Mauricio Tano*

*Model link: [Griffin-Pronghorn Steady-State Model](https://github.com/idaholab/virtual_test_bed/tree/devel/msr/msre/multiphysics_core_model/steady_state)*

!tag name=MSRE Griffin-Pronghorn Steady State Model pairs=reactor_type:MSR
                       reactor:MSRE
                       geometry:core
                       simulation_type:core_multiphysics
                       input_features:multiapps
                       code_used:BlueCrab
                       computing_needs:Workstation
                       fiscal_year:2023

This model of the MSRE utilizes MOOSE to create a 2D, RZ (cylindrical coordinates) mesh of the MSRE.
Griffin computes neutronics and resulting normalized power source [!citep](Javi23).
Pronghorn performs medium-fidelity, coarse mesh thermal-hydraulics analysis of the core, upper plenum, pump, downcomer, and lower plenum [!citep](mau23).
Griffin and Pronghorn are coupled via the `MultiApp` system.
The parts of the MSRE loop are represented in [MSRE_pgh_mesh_blocks].
The model is an axisymmetric model with the left vertical axis being the axis of symmetry.

The fuel salt flows down the `Downcomer`, through the `Lower Plenum`, and up into the `Core`; then, it is collected at the `Upper Plenum`, and, finally, it is circulated through the `Pump` into the loop again.
A porous medium approach is used to model flow conditions in the core with a vertical porosity of `0.22283`.
No rugosity is assumed when computing the friction factors.
An anisotropic friction source coefficient keeps the flow approximately 1-Dimensional at the core, to reproduce the fluid behaviors in the core channels.

!media msr/msre/MSRE_pgh_mesh_blocks.png
       style=width:80%;margin-left:auto;margin-right:auto
       id=MSRE_pgh_mesh_blocks
       caption=Subdomain (left) and mesh (right) of the multiphysics model.

## Neutronics Model

Griffin is the main tool used in the neutronics input file listed below.
Griffin calls the Pronghorn thermal-hydraulics sub-app which is detailed in the thermal hydraulics section that is discussed later.

!listing msr/msre/multiphysics_core_model/steady_state/neu.i

#### Problem Parameters

The beginning of the input file lists the problem parameters the user can edit including the model's physical properties and initial conditions.

#### Global Parameters

Next, Global Parameters are defined in the `Global Parameters` block which give the macroscopic cross section file path for the MSRE.

!listing msr/msre/multiphysics_core_model/steady_state/neu.i block=GlobalParams

#### Transport Systems

Next, the `Transport System` block determines what sort of neutronic solve Griffin will perform.
Here the methodology to compute the eigenvalue of the MSRE system is computed and corresponding boundary conditions are set --- reflecting boundary for the RZ symmetric core and vacuum boundaries elsewhere.

Additionally, the type of transport equation solve is selected.
In this case the a multigroup Diffusion equation is sufficient for fast multiphysics coupling.
Additionally, options for the Jacobian and fission source auxiliary variable are selected here.

!listing msr/msre/multiphysics_core_model/steady_state/neu.i block=TransportSystems

The steady-state, multi-group diffusion equation for the eigenvalue problem solved at steady-state is given as follows:

\begin{equation} \label{eq:eigen_multi}
-\nabla \cdot D_g(\mathbf{r}) \nabla \phi_g(\mathbf{r}) + \Sigma_{rg} \phi_g(\mathbf{r}) = \frac{1 - \beta_0}{k_{eff}} \chi_{p,g} \sum_{g'=1}^G (\nu\Sigma_{f})_{g'} \phi_{g'}(\mathbf{r}) + \sum_{g' \neq g}^G \Sigma_{sg'} \phi_{g'}(\mathbf{r}) + \chi_{d,g} \sum_{i=1}^m \lambda_i c_i(\mathbf{r}),
\end{equation}

where the symbols represent the following: $D_g$ diffusion coefficient for energy group $g$, $\phi_g(\mathbf{r})$ neutron scalar flux of energy group $g$ at position $\mathbf{r}$,
$\Sigma_{rg}$ removal cross-section from energy group $g$, $k_{eff}$ eigenvalue representing the effective multiplication factor of the reactor, $\chi_{p,g}$ prompt fission spectrum for neutrons born in energy group $g$, $\nu$ number of neutrons per fission, $\Sigma_{fg'}$ average fission cross-section of neutrons in energy group $g'$, $\Sigma_{sg'}$ differential scattering cross-section for neutrons scattering from energy group $g'$ to energy group $g$, $\beta_0$ delayed neutrons fraction, $\chi_{d,g}$ delayed fission spectrum for neutrons born in energy group $g$ due to decay of neutron precursors,  $\lambda_i$ decay constant for precursor group $i$, $c_i(\mathbf{r})$ concentration of neutron precursor group $i$, at position $\mathbf{r}$, and $G$ total number of energy groups.

#### Mesh

The `Mesh` block can either generate a mesh using the MOOSE meshing capabiility or reads in a previously generated mesh. Here, the Mesh block reads in a MOOSE generated mesh and specifies that the model is RZ.

!listing msr/msre/multiphysics_core_model/steady_state/neu.i block=Mesh

#### Aux Variables

The `AuxVariables` block is specificed next. Through the ```Auxiliary Variables```, developers can define external variables that are solved or used in the primary simulation. The variable types, computation, and scaling factors are explained in detail [here](https://mooseframework.inl.gov/syntax/AuxVariables/index.html). Auxiliary variables can be set explicitly in the ```AuxKernel``` section, or set from another app using Transfers to perform multiphysics coupling.

In this case, the velocity, fuel salt and solid structures temperatures, and delayed neutron precursor group distributions will be informed by the Pronghorn sub app, whereas the volumetric power and fission rate fields will be calculated by Griffin and passed to the Pronghorn sub app.

!listing msr/msre/multiphysics_core_model/steady_state/neu.i block=AuxVariables

#### Aux Kernels

Correspondingly, the `AuxKernels` block specifies Kernels which act on the auxiliary variables. Here an array of delayed neutron precursors concentration is built to be read in by Griffin. Additionally, the fuel salt nuclide constituent concentrations are updated due to fuel salt density changes.

!listing msr/msre/multiphysics_core_model/steady_state/neu.i block=AuxKernels

#### User Objects

Next, the `UserOjbects` block specifies User Objects that can be used by other MOOSE applications. Here both the transport solutions and aux variable solutions are stored in their corresponding user objects. This user object is necessary for restarting a transient simulation from a steady-state solution.

!listing msr/msre/multiphysics_core_model/steady_state/neu.i block=UserObjects

#### Power Density

The `PowerDensity` block specifies how the Power Density is calculated in Griffin. Here the total power is used to scale the power density calculated during the eigenvalue solution.

!listing msr/msre/multiphysics_core_model/steady_state/neu.i block=PowerDensity

#### Materials

The `Materials` block specifies what materials will be used in the neutronic calculation.
Each material links to the corresponding material IDs from the macroscopic ISOXML cross section library.

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

Next, Pronghorn (here mostly leveraging the MOOSE Navier Stokes Module) is the sub app detailed in the neutronics input file listed below which performs the thermal hydraulic calculations of the core and primary loop.
 Note, this application can be fully run with the open-source MOOSE Navier Stokes Module.

!listing msr/msre/multiphysics_core_model/steady_state/th.i

#### Problem Parameters

The physical properties are defined first. The core porosity is defined at a ratio of 0.222831, calculated as the quotient of flow area by total core area. The porosity for the rest of the components is set to 1, full fluid region, but is editable by the user. The thermophysical properties of the solid structures are also defined here.

!listing msr/msre/multiphysics_core_model/steady_state/th.i start=# Properties end=# Operational Parameters

The following section focuses on the operational parameters. The mass flow rate was defined at 191.19 kilograms per second, with a core outlet pressure approximately atmospheric at 101.325 kiloPascals.
The salt core inlet temperature is defined to be 908.15 Kelvin (K) with an ambient room temperature defined to be 300K.
Finally, this section defines the pump force scaling for the centrifugal pump functor to obtain a specific pump force of 1800.0 kiloNewton per meter cube (kN/m$^3$).
The pump force was adapted to produce a loop circulation time of ~25 seconds.

!listing msr/msre/multiphysics_core_model/steady_state/th.i start=# Operational Parameters end=# Thermal-Hydraulic diameters

Next, the hydraulic diameters of the flow channels are set respectively. The fluid blocks are defined to indicate the fluid regions.

!listing msr/msre/multiphysics_core_model/steady_state/th.i start=# Thermal-Hydraulic diameters end=# Delayed neutron

Then, first section defines the delayed neutron group properties, both their production rate due to fission and decay rate. It also define the turbulent Schmidt number and the initial temperature of the fuel salt.

!listing msr/msre/multiphysics_core_model/steady_state/th.i start=# Delayed neutron end=# Utils

The end of the first section defines the set of blocks where the fluid flow and solid heat conduction equations will be solved.

!listing msr/msre/multiphysics_core_model/steady_state/th.i start=# Utils end=# =

#### Global Parameters

Next, Global Parameters are defined in the `Global Parameters` block.
This section is used to define variables and methods that are required by many methods in the input file.

!listing msr/msre/multiphysics_core_model/steady_state/th.i start=[GlobalParams] end=#


#### Mesh

This block defines the geometry of the core, as shown in [MSRE_pgh_mesh_blocks]. This block reads in the same mesh that was generated using MOOSE which is identical for both Griffin and Pronghorn.

!listing msr/msre/multiphysics_core_model/steady_state/th.i start=[Mesh] end=[Problem]

#### Modules

This block defines the Module that will be used in this problem - specifically the Navier Stokes Finite Volume action.

The ```Navier Stokes Finite Volume``` action is used to define fluid properties, compute the "weakly-compressible" flow, and set up boundary conditions.

Here, the action operates on the fluid blocks which are defined at the top of the header and are substituted using the `$` sign. Recall that the `$` sign refers to variable substitutions. "Weakly-compressible" with porous_medium_treatment is selected for this model and the energy equation is also included.

Numerical schemes can be selected for solving the Navier Stokes equations with different methods of pressure and velocity interpolation.

Porosity, friction, and turbulence treatment can be modified here using various correlations and models. Fluid properties are also set here and can be modified.

The action also incorporates external physics like a volumetric heat source due to the power_density calculated by Griffin. Also, boundary conditions are set to constrain the different Navier Stokes equations.

The scalar equations for delayed neutron precursor groups are not included here in the action since they are defined externally elsewhere in the input file

Lastly, scaling factors can be tuned to increase convergence speed if needed.

The action allows users to simply modify the equations that are solved, choose numerical schemes, define the porosity and friction treatment, define fluid properties, couple with other physics for energy deposition, and set boundary conditions.

!listing msr/msre/multiphysics_core_model/steady_state/th.i start=[Modules] end=[FVKernels]

The porous flow equations for weakly-compressible flow read as follows:

\begin{equation} \label{eq:mass_cons}
\frac{\partial \gamma \rho}{\partial t} + \nabla \cdot (\rho \vec{v}) = 0  \quad \text{on } \Omega_f ,
\end{equation}

\begin{equation} \label{eq:mom_cons}
\frac{\partial  \rho \vec{v}}{\partial t} + \nabla \cdot \left(\gamma^{-1}  \rho \vec{v} \otimes \vec{v}\right) - \nabla \cdot \left[ (\mu_t + \rho \nu_t) (\nabla \vec{u} + \nabla \vec{u} ^ T) \right] = -\gamma \nabla p + \gamma \rho \vec{g} -  W \rho  \vec{v}_I + \vec{S} \quad \text{on } \Omega_f ,
\end{equation}

\begin{equation} \label{eq:liq_ene_cons}
\frac{\partial \gamma \rho e}{\partial t} + \nabla \cdot \left(  \rho H \vec{v}\right) - \nabla \cdot \left( \kappa_f \nabla T \right) - \nabla \cdot \left( \rho \alpha_t \nabla e \right) =  \dot{q_l}''' \quad \text{on } \Omega_f ,
\end{equation}

\begin{equation} \label{eq:sol_ene_cons}
(1 - \gamma) \rho_s c_{p,s} \frac{\partial T_s}{\partial t} - \nabla \cdot \left (\kappa_s \nabla T_s \right) - \alpha(T - T_s) = \dot{q_s}''' \quad \text{on } \Omega_s ,
\end{equation}

where $\vec{v}$ is the superficial velocity defined as $\vec{v} = \gamma \vec{v}_I$ and $\vec{v}_I$ is the interstitial or physical velocity, $\rho$ is the density, $p$ is the pressure, $e$ is the internal energy, $H$ is the enthalpy, $T$ is the fluid temperature, $T_s$ is the solid temperature, $\rho_s$ is the solid density, $c_{p,s}$ is the specific heat of the solid phase, $\vec{g}$ is the gravity vector, $W$ is the pressure drop coefficient, $\vec{S}$ is the momentum source that is used to model the pump, $\kappa_f$ is the effective thermal conductivity of the fluid, $\alpha_t$ is the turbulent heat diffusivity, $\kappa_s$ is the effective solid thermal conductivity, $\dot{q}_l'''$ is the heat source being deposited directly in liquid fuel (e.g., fission heat source), and $\dot{q}_s'''$ is the heat source in the solid (e.g., residual power production in structures). The effective thermal conductivities $\kappa_f$ and $\kappa_s$ are in general diagonal tensors.

The fluid domain $\Omega_f$ comprises porous regions with $0< \gamma < 1$ and free flow regions with $\gamma = 1$; in the free-flow region, $T_s$ is not solved and we have $\alpha=0$, $W=0$, and $\kappa_f=k_f$ (where $k_f$ is the thermal conductivity of the fluid). Similarly, $T_f$ is not solved in solid-only regions where $\gamma = 0$ and $\kappa_s = k_s$ with $k_s$ as the solid conductivity.

#### Fluid Properties

This block contains parameters applied to all the core components. The `fluid_properties_obj` refers to the primary salt F-Li-Be (FLiBe), already defined within MOOSE.

!listing msr/msre/multiphysics_core_model/steady_state/th.i start=[FluidProperties] end=[Modules]


Fluid properties are further defined within the ```Navier Stokes Finite Volume``` action and the Materials block.

!listing msr/msre/multiphysics_core_model/steady_state/th.i start=# fluid properties end=# Energy source-sink language=cpp

!listing msr/msre/multiphysics_core_model/steady_state/th.i start=# Setting up fluid properties end=# Setting up heat conduction language=cpp

#### Variables

This block contains the variables that are explicitly solved for in this model. These include the velocity, pressure, temperature, and six delayed neutron precursor groups.

!listing msr/msre/multiphysics_core_model/steady_state/th.i start=[Variables] end=# ===

#### Finite Volume Kernels

Furthermore, corresponding to the variables are the finite volume kernels which operate on these variables. Most of the kernels are set implicitly within the Navier Stokes action. However Kernel tweaking is possible and here the pump, delayed neutron precursor group advection equations, and solid heat conduction are explicitly set.

!listing msr/msre/multiphysics_core_model/steady_state/th.i start=[FVKernels] end=[FVInterfaceKernels]

Here the delayed neutron precursor distribution is modeled via an advection diffusion equation as follows:

\begin{equation} \label{eq:prec_eigen}
\nabla \cdot (\mathbf{u}(\mathbf{r}) c_i(\mathbf{r})) - \nabla \cdot H_i \nabla c_i(\mathbf{r}) - \nabla \cdot \frac{\nu_t}{Sc_t} \nabla c_i(\mathbf{r}) = \frac{\beta_0}{k_{eff}} \chi_{p,g} \sum_{g'=1}^G (\nu\Sigma_{f})_{g'} \phi_{g'}(\mathbf{r})- \lambda_i c_i(\mathbf{r}),
\end{equation}

where $\mathbf{u}(\mathbf{r})$ interstitial advection velocity vector at position $(\mathbf{r})$,
$H_i$ average molecular diffusion for neutron precursors of type $i$, $\nu_t$ turbulent kinematic viscosity, and $Sc_t$ the turbulent Schmidt number. There are as many equations of type [eq:prec_eigen] as the number of neutron precursor groups. Since we are adding these equations in manually, the `FVKernels` entered correspond to the associated terms in the equation for the six delayed neutron precursor groups.

#### Finite Volume Interface Kernels

Additionally, finite volume interface Kernels can be deployed to account for specific interfacial modeling at boundaries. Here an explicit heat transfer correlation is implimented at the `core_downcomer_boundary`.

!listing msr/msre/multiphysics_core_model/steady_state/th.i start=[FVInterfaceKernels] end=# =======

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

!listing msr/msre/multiphysics_core_model/steady_state/th.i start=[AuxKernels] end=# ==

#### Postprocessors

The postprocessor block allows for the user to calculate additional items of interest and have them included in the output. These can be useful to check assumptions that the user makes when setting up the model to ensure the model is performing as the user intends.

Here the inlet and outlet pressures and temperatures are determined as well as the volumetric flow rate and area in the downcomer.

!listing msr/msre/multiphysics_core_model/steady_state/th.i start=[Postprocessors] end=[Materials]

#### Materials

The Materials block allows for users to set various material parameters and correlations for the model. Here the porosity, hydraulic diameter, fluid properties, drag correlations and porosity delayed neutron precursor distributions are set.

!listing msr/msre/multiphysics_core_model/steady_state/th.i start=[Materials] end=# ==

#### Executioner

Finally, the Executioner block determines how the model is run. The type of solve, method, PETSc options and convergence tolerances are set in this block. Additionally the time stepping method, end time, and steady state detection options are defined in this block.

!listing msr/msre/multiphysics_core_model/steady_state/th.i start=[Debug] end=[Outputs]

#### Output

Lastly, the Output block specifies what type of output (e.g. exodus and CSV) will be created and what items should be printed during the simulation.

!listing msr/msre/multiphysics_core_model/steady_state/th.i start=[Outputs] end=[[]]
