# Lotus Griffin-Pronghorn Model

*Contact: Mauricio Tano, mauricio.tanoretamales.at.inl.gov*

*Model summarized, documented, and uploaded by Rodrigo de Oliveira and Samuel Walker*

*Model link: [Griffin-Pronghorn Steady-State Lotus Model](https://github.com/idaholab/virtual_test_bed/tree/devel/msr/lotus/steady_state)*

!tag name=Lotus Griffin-Pronghorn Steady State Model pairs=reactor_type:MSR
                       reactor:generic-msr
                       geometry:core
                       simulation_type:core_multiphysics
                       input_features:multiapps
                       code_used:BlueCrab
                       computing_needs:HPC
                       fiscal_year:2024

This multiphysics problem is solved using the MultiApp system to separate the neutronics, thermal hydraulics, and delayed neutron precursors group problems. The corresponding computational domains for the neutronics and thermal hydraulics with delayed neutron precursor group distributions can bee seen in [LMCR_pgh_geometry] and [LMCR_pgh_thermal_hydraulics] respectively. Notice, this is a multiphysics problem, but not a multiscale problem since we are solving the problems at the same geometrical and time resolution. The only difference between the meshes, is that the thermal-hydraulic domain has an extra mixing plate to distribute the flow within the core.

!row!
!media msr/lotus/MCR_geometry.jpg
       style=width:50%;float:left;padding-top:2.5%;padding-right:5%
       id=LMCR_pgh_geometry
       caption=LMCR geometry for neutronics evaluation [!citep](M3mcr2023).

!media msr/lotus/mcr_thermal_hydraulics.png
       style=width:45%;float:left;padding-top:2.5%;padding-right:5%
       id=LMCR_pgh_thermal_hydraulics
       caption=Thermal-hydraulics blocks for LMCR thermal-hydraulics & DNP domain [!citep](M3mcr2023).
!row-end!


## Neutronics

Starting first with neutronics, Griffin solves the neutron transport problem via the Diffusion equation approximation. The Griffin input file will now be briefly discussed and the primary equations that are solved and how they relate to the input file will be shown. The input file to solve the 9 group neutron diffusion problem is shown below.

This is the main input file which calls the open source MOOSE Navier-Stokes input file `run_ns_initial.i` which is the sub-app for solving the Thermal Hydraulics solution of this model.

!listing msr/lotus/steady_state/run_neutronics_9_group.i

#### Mesh

Starting first with the mesh, this block defines the computational domain that the neutronics solve will operate on. Here, a cubit generated 3D mesh is imported as an exodus file. It is correspondingly manipulated to add in a reactor boundary condition, and is scaled to the correct size of the reactor.

!listing msr/lotus/steady_state/run_neutronics_9_group.i block=Mesh

#### Transport Systems

Next, the process of converting the basic conservation equations into MOOSE variables and kernels is automated with the `TransportSystems` block:

!listing msr/lotus/steady_state/run_neutronics_9_group.i block=TransportSystems

Details about neutron transport equations can be found in Griffin theory manual.

Here we are specifying an eigenvalue neutronics problem using 9 energy groups
(`G = 9`) solved via the diffusion approximation with a continuous finite
element discretization scheme (`scheme = CFEM-Diffusion`).

For brevity, the multi-group diffusion equation for the eigenvalue problem solved at steady-state is given as:

\begin{equation} \label{eq:eigen_multi}
-\nabla \cdot D_g(\mathbf{r}) \nabla \phi_g(\mathbf{r}) + \Sigma_{rg} \phi_g(\mathbf{r}) = \frac{1 - \beta_0}{k_{eff}} \chi_{p,g} \sum_{g'=1}^G (\nu\Sigma_{f})_{g'} \phi_{g'}(\mathbf{r}) + \sum_{g' \neq g}^G \Sigma_{sg'} \phi_{g'}(\mathbf{r}) + \chi_{d,g} \sum_{i=1}^m \lambda_i c_i(\mathbf{r}),
\end{equation}

where the symbols represent the following: $D_g$ diffusion coefficient for energy group $g$, $\phi_g(\mathbf{r})$ neutron scalar flux of energy group $g$ at position $\mathbf{r}$,
$\Sigma_{rg}$ removal cross-section from energy group $g$, $k_{eff}$ eigenvalue representing the effective multiplication factor of the reactor, $\chi_{p,g}$ prompt fission spectrum for neutrons born in energy group $g$, $\nu$ number of neutrons per fission, $\Sigma_{fg'}$ average fission cross-section of neutrons in energy group $g'$, $\Sigma_{sg'}$ differential scattering cross-section for neutrons scattering from energy group $g'$ to energy group $g$, $\beta_0$ delayed neutrons fraction, $\chi_{d,g}$ delayed fission spectrum for neutrons born in energy group $g$ due to decay of neutron precursors,  $\lambda_i$ decay constant for precursor group $i$, $c_i(\mathbf{r})$ concentration of neutron precursor group $i$, at position $\mathbf{r}$, and $G$ total number of energy groups.

Note the `external_dnp_variable = 'dnp'` parameter. This is a special option
needed for liquid-fueled MSRs which signals that the conservation equations for delayed neutron precursors (DNPs) will be handled "externally" from the default
Griffin implementation which assumes that the precursors do not have the turbulent treatment. DNP treatment will be discussed later in the thermal-hydraulics and DNP distribution input files.

The type of shape function `Lagrange` and order `FIRST` are defined here as well as the `fission_source_aux` which will be used by the sub-apps.

#### Power Density

Next, the `Power Density` is set for this specific reactor. Here the neutronics solution is normalized to the rated power of $25$kW.

!listing msr/lotus/steady_state/run_neutronics_9_group.i block=PowerDensity

The power density is evaluated with the normalized neutronics solution.
It provides the energy source in the fluid energy conservation equation.
Because the fluid energy equation is discretized with FV, we evaluate the power
density variable with a constant monomial function.

#### Auxiliary Variables

Moving on, the `AuxVariables` are now set which are specific variables that can be passed and read in from the other sub-apps for multiphysics calculations.

!listing msr/lotus/steady_state/run_neutronics_9_group.i block=AuxVariables

Here the `tfuel` and `trefl` are the temperature of the fuel salt and reflector, whereas `c1` - `c6` are the DNP distributions, and `dnp` is an array auxiliary with 6 component corresponding
to the 6 DNP groups used here. This array is then read into Griffin in the `external_dnp_variable = 'dnp'` parameter within the `Transport Systems` block.

#### Auxiliary Kernels

Correspondingly, the `AuxKernels` are functors which operate on the `AuxVariables`. Here the six separate DNP groups are compiled into the Aux Variable `dnp` to be used within Griffin.

!listing msr/lotus/steady_state/run_neutronics_9_group.i block=AuxKernels

#### Materials

The next critical need for any neutronics calculation is a set of multigroup cross sections. Generating cross sections is a topic that is left outside the
scope of this example. A set has been generated for the LMCR problem and stored
in the repository using Griffin's ISOXML format. These cross sections are included
by the blocks,

!listing msr/lotus/steady_state/run_neutronics_9_group.i block=Materials

`CoupledFeedbackNeutronicsMaterial` is able to use the temperature transferred
from the fluid system for evaluating multigroup cross sections based on a table lookup
on element quadrature points to bring in the feedback effect.

#### Executioner

Next, the `Executioner` block sets up the type of problem, and the numerical methods to solve the neutronics and multiphysics problems.

!listing msr/lotus/steady_state/run_neutronics_9_group.i block=Executioner

The calculation is driven by `Eigenvalue`, an executioner available in Griffin.
The PJFNKMO option for the `solve_type` parameter is able to
drive the eigenvalue calculation with the contribution of DNP
to the neutron transport equation as an external source scaled with $k$-effective.

Additionally, PETSc options and tolerances for the neutronics and multiphysics fixed point iteration coupling method are provided.

#### Post Processors

The `PostProcessors` block sets up various calculations of reactor parameters that may be of interest to the user. This can be helpful to ensure the model is implemented correctly. Here the average, maximum, and minimum of various variables (e.g., `power`, `fluxes`, and `DNPs`) can be computed.

!listing msr/lotus/steady_state/run_neutronics_9_group.i block=Postprocessors

#### Outputs

The `Outputs` block sets up the types of outputs the user would like to visualize or interpret the results. Here both an `exodus` and `csv` file are selected. Additionally, a `restart` file is generated so that transient solutions starting from steady-state can be computed.

!listing msr/lotus/steady_state/run_neutronics_9_group.i block=Outputs

#### MultiApps

Finally, the `MultiApps` block sets up the sub-app that will be driven by the main Griffin app. Here, the Griffin input is the main-application and includes a single sub-application with the open source MOOSE Navier-Stokes input `run_ns_initial.i`.

!listing msr/lotus/steady_state/run_neutronics_9_group.i block=MultiApps

#### Transfers

Correspondingly, the `Transfers` block sets up the Auxiliary Variables that will be passed to and from the thermal hydraulics sub app.

!listing msr/lotus/steady_state/run_neutronics_9_group.i block=Transfers

Here the `power_density`, and `fission_source`is transferred to the Navier-Stokes input file which operate as sources in the energy conservation and DNP advection equations respectively. Lastly, the DNP distributions for groups `c1` - `c6` and the temperature of the fuel `T` and the reflector `T_ref` are passed back to the neutronics solutution for multiphysics convergence.



## Thermal Hydraulics

The fluid system is solved by the subapp and it uses the `run_ns_initial.i`
input file shown below. (Here "ns" is an abbreviation for Navier-Stokes.)

The fluid system includes conservation equations for fluid mass, momentum, and
energy. Here a porous flow and weakly-compressible formulation are used to model molten salts and the pressure drop over the mixing plate at the entrance of the reactor core.

Additionally, the thermal hydraulics input file has another sub-app below it that calculates the delayed neutron precursor (DNP) group distributions in `run_prec_transport.i` which will be discussed shortly.

!listing msr/lotus/steady_state/run_ns_initial.i

#### Problem Parameters

The physical properties of the fuel salt and reflector (e.g., `density`, `viscosity`, `thermal conductivity`, and `heat capacity`) are defined first. Additionally, other parameters such as a friction force, pump force, porosity, and area are also set. Lastly, numerical interpolation schemes such as `upwind` and `rhie-chow` are also selected and a mixing length turbulence calibration informed from high-fidelity CFD is also set here.

!listing msr/lotus/steady_state/run_ns_initial.i start=# Material Properties end=[GlobalParams]

#### Global Parameters

Next, `Global Parameters` lists variables and parameters that will be used throughout the entire input file. Here the finite volume interpolation methods are set, and `superficial velocities`, `pressure`, `porosity`, `density`, `viscosity`, and the `mixing_length` model are defined for the entire input file. Some of these values are originally set in the `Problem Parameters` / header of the input and are referenced here using the ${} notation to be used implicitly for the rest of the input file.

!listing msr/lotus/steady_state/run_ns_initial.i block=GlobalParams

#### Mesh

This block defines the geometry of the thermal hydraulics computational domain, as shown in [LMCR_pgh_thermal_hydraulics]. This block reads in the same 3D mesh that was generated using CUBIT which is identical for both Griffin and Pronghorn.

Then several boundaries and the mixing plate subdomain are defined by editing the mesh to correctly define the boundary conditions and porosity modeling necessary in the thermal hydraulics model.

!listing msr/lotus/steady_state/run_ns_initial.i block=Mesh

#### User Objects

The model now turns to implementing the equations, variables, kernels, and boundary conditions that need to be specified to solve the thermal hydraulic problem. Rather than using a `Module` where the ```Navier-Stokes Finite Volume``` action is used to define the problem, this model opts to explicitly set up the problem for added flexibility.

!listing msr/lotus/steady_state/run_ns_initial.i block=UserObjects

Here the porous formulation of the incompressible Rhie Chow Interpolator user object is specified and acts on the fluid blocks defined.

#### Variables

Next, the variables that must be explicitly solved for in the thermal hydraulics model are defined. Here the `pressure`, `superficial velocities`, and `temperatures` are required.

!listing msr/lotus/steady_state/run_ns_initial.i block=Variables

#### Kernels

Correspondingly, the kernels are the functor or terms that manipulate the variables and form the conservation equations. Here the conservation of mass, momentum, and energy in the fuel salt and reflector are explicitly set.

!listing msr/lotus/steady_state/run_ns_initial.i block=Kernels

The porous flow equations for incompressible flow read as follows:

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

#### Finite Volume Interface Kernels

In addition to the Kernels that operate on the variables in the bulk domain, Interface Kernels operate at an interface. In this case the `convection` Interface Kernel is selected to account for heat transfer from the fuel salt to the reflector thorugh the vessel boundary.

!listing msr/lotus/steady_state/run_ns_initial.i block=FVInterfaceKernels

#### Finite Volume Boundary Conditions

Next, the `Finite Volume Boundary Conditions` must be set for the conservation equations. Here no slip boundary conditions for the velocities for the momentum equation, and various heat transfer boundary conditions for the energy equation are specified.

!listing msr/lotus/steady_state/run_ns_initial.i block=FVBCs

#### Auxiliary Variables

The `Auxiliary Variables` block defines variables of interest that can be operated on and transferred to sub-apps below or main-apps above. Here the `power_density` and `fission_source` is read in from the main-app neutronics solve, and `c1`-`c6` is read in from the precursor advection sub-app. Additionally, auxiliary variables that will be transferred to the precursor advection sub-app are also defined here as `a_u_var`, `a_v_var`, and `a_w_var` respectively.

!listing msr/lotus/steady_state/run_ns_initial.i block=AuxVariables

#### Auxiliary Kernels

Correspondingly, the `Auxiliary Kernels` operate on the `Auxiliary Variables`. In this case the auxiliary variables needed by the precursor advection sub-app are generated by copying the superficial velocities given by the thermal hydraulics solution.

!listing msr/lotus/steady_state/run_ns_initial.i block=AuxKernels

#### Functions

Next, various functions are defined to be used throughout the input file. Here heat transfer coefficients, reynolds numbers, power-density functions, and cosine guesses can all be generated and used for initial conditions, kernels, etc.

!listing msr/lotus/steady_state/run_ns_initial.i block=Functions

#### Materials

Next, the `Materials` block specifies material properties of interest in the fuel salt, reactor vessel, and reflector. Here, `viscosity`, `wall frictions`, and turbulent `mixing length` models can be implemented.

!listing msr/lotus/steady_state/run_ns_initial.i block=Materials

#### Executioner

The `Executioner` block defines how the problem will be run. Here the type of solution is a `Transient` and a `TimeStepper` function is defined. Additionally, the numerical tolerances for the solution are selected to control the level of convergence required.

!listing msr/lotus/steady_state/run_ns_initial.i block=Executioner

#### Outputs

After computing the solution, the `Outputs` block defines how the user would like to process the final solution data. Here a CSV file is generated containing all of the calculations performed in the `Postprocessors` block.

!listing msr/lotus/steady_state/run_ns_initial.i block=Outputs

#### Postprocessors

The `Postprocessors` block is used to defined to calculate specific items of interest to the user. In this case, velocities, volumetric flow rate, temperatures, pressure drop, heat losses, and DNP concentrations can be calculated and printed in the `Outputs` CSV file.

!listing msr/lotus/steady_state/run_ns_initial.i block=Postprocessors

#### MultiApps

Moving next to the `MultiApps` block, this block connects the present app with any sub-apps. In this case the `prec_transport` sub-app is defined using the `run_prec_transport.i` input file.

!listing msr/lotus/steady_state/run_ns_initial.i block=MultiApps

#### Transfers

Lastly, the `Transfers` block is specified to showcase how Auxiliary Variables should be shared between the current application and the sub-app. Here `power_density`, `fission_source`, and `superficial velocities`, are sent to the precursor transport sub-app, whereas `c1` - `c6` will be returned back to the current app after solving the DNP distributions.

Then the neutronics application above calls for `c1`-`c6` from the current application in it's `Transfers` block and uses these values to solve the multiphysics coupled neutronics eigenvalue problem.

!listing msr/lotus/steady_state/run_ns_initial.i block=Transfers

## Delayed Neutron Precursor Advection Equation

Here the distribution of delayed neutron precursors (DNPs) is solved for in another nested sub-app that the Thermal Hydraulics application calls. The `run_prec_transport.i` input for solving the conservation of DNPs is listed below.

This input file could be incorporated into the Thermal Hydraulics solve, but for clarity it has been separated out as a separate sub-app. Therefore the input file here is similar to the Thermal Hydraulics input file, and only unique differences will be highlighted.

!listing msr/lotus/steady_state/run_prec_transport.i

Here the delayed neutron precursor distribution is modeled via an advection diffusion equation as follows:

\begin{equation} \label{eq:prec_eigen}
\nabla \cdot (\mathbf{u}(\mathbf{r}) c_i(\mathbf{r})) - \nabla \cdot H_i \nabla c_i(\mathbf{r}) - \nabla \cdot \frac{\nu_t}{Sc_t} \nabla c_i(\mathbf{r}) = \frac{\beta_0}{k_{eff}} \chi_{p,g} \sum_{g'=1}^G (\nu\Sigma_{f})_{g'} \phi_{g'}(\mathbf{r})- \lambda_i c_i(\mathbf{r}),
\end{equation}

where $\mathbf{u}(\mathbf{r})$ advection velocity vector at position $(\mathbf{r})$,
$H_i$ average molecular diffusion for neutron precursors of type $i$, $\nu_t$ turbulent kinematic viscosity, and $Sc_t$ the turbulent Schmidt number. There are as many equations of type [eq:prec_eigen] as the number of neutron precursor groups.

#### Problem Parameters

Similar to the thermal hydraulics input file `run_ns_initial.i`, the physical properties of the problem are defined first. Uniquely, the decay constants $\lambda$ and production fractions $\beta$ are defined for the six DNP groups.

!listing msr/lotus/steady_state/run_prec_transport.i start=# Material Properties end=[GlobalParams]

#### User Objects

Since this is a sub-app nested underneath the thermal hydraulics application, the `rhie chow interpolator` user object is updated with the superficial velocity aux variables `a_u`, `a_v`, and `a_w` transferred from the Thermal Hydraulics solve.

!listing msr/lotus/steady_state/run_prec_transport.i block=UserObjects

#### Variables

The next difference is that the `c1` - `c6` groups are no longer `AuxVariables` but are the finite volume variables that this problem is explicitly solving for.

!listing msr/lotus/steady_state/run_prec_transport.i block=Variables

#### Auxiliary Variables

In order for this sub-app to take advantage of the transfers from applications above it, it must define the `Auxiliary Variables` that it will receive and send.

!listing msr/lotus/steady_state/run_prec_transport.i block=AuxVariables

Here the `power_density`, `fission_source`, `superficial velocities`, `pressure`, and `auxiliary velocities` are defined so they can be populated via transfers from the neutronics and thermal hydraulics applications above this sub-app.

#### Kernels

Correspondingly, the kernels are the functor or terms that manipulate the variables and form the conservation equations. Here the conservation of DNPs as seen in [eq:prec_eigen] is implemented by explicitly setting each term for each DNP group.

!listing msr/lotus/steady_state/run_prec_transport.i block=Kernels

It should be noted that the `fission_source` variable used as the source term for generating the DNPs was transfered from the Neutronics -> Thermal Hydraulics -> this precursor advection sub-app.

#### Finite Volume Boundary Conditions

Next, no-slip boundary conditions for the superficial velocities `u`, `v`, and `w` are defined at the boundaries.

!listing msr/lotus/steady_state/run_prec_transport.i block=FVBCs


#### Materials

Here, porosity and mixing length are incorporated as `Materials` into the model to correctly modify the DNP conservation equations depending on the fluid blocks porosity and turbulent mixing length.

!listing msr/lotus/steady_state/run_prec_transport.i block=Materials


