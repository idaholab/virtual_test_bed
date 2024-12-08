# Gas-cooled Microreactor Air Jacket: Nek5000 CFD Simulation

*Contact: Anshuman Chaube (achaube.at.anl.gov), April Novak (anovak.at.anl.gov), Dillon Shaver (dshaver.at.anl.gov)*

*Model link: [Air Jacket CFD Model](https://github.com/idaholab/virtual_test_bed/tree/main/microreactors/gcmr/airjacket)*

!tag name=Gas-Cooled Microreactor Air Jacket
     description=CFD study of an air-jacket for passive cooling of a micro-reactor
     image=https://mooseframework.inl.gov/virtual_test_bed/media/airjacket/overview.png
     pairs=reactor_type:microreactor
           reactor:GCMR
           geometry:air_jacket
           simulation_type:CFD
           V_and_V:demonstration
           codes_used:Nek5000
           open_source:true
           computing_needs:HPC
           fiscal_year:2023
           institution:ANL
           sponsor:NRIC

## High Level Summary of Model

We have created a [!ac](CFD) model  of a
a gas-cooled microreactor air jacket cooling system
that passively removes decay heat. The complex geometry and
natural circulation-driven flow may be challenging to capture
with systems-level codes without calibration from experiments
or higher-fidelity thermal-fluid modelling. However,
[!ac](CFD) is particularly well-suited to
the task of modelling microreactor air jackets due to its ability
to capture the effect of the complicated geometry on the flow with
resolved boundary layers. We use Nek5000 to simulate flow
through an industry-inspired prototypical geometry and predict heat transfer and
flow characteristics. The boundary conditions given to us are representative
of a reactor design in early stages of development.
From these CFD simulations, it is possible
to evaluate available models for bulk heat and momentum
transfer that can be used in systems-level codes, and to develop
modifications to those models specific to the proposed design. Given limited initial data,
we can use CFD to fill in the gaps pertaining to systems-level quantities such as
the friction factor, Nusselt number, the average heat flux, bulk temperature, and mean outlet temperature.
The key idea here is to illustrate the utility of CFD in characterizing a newly developed
system with greater accuracy than
that achieved through systems-level codes and/or correlations-based analysis. We
also aim to highlight the iterative improvement of the mass flow rate (varied as the Reynolds number) based on
pressure and energy balance equations, which is the primary source of improvement over the results obtained using
generic correlations. These equations in the workflow described below
can be replaced by systems-levels tools or other software that can be used in conjunction with [!ac](CFD) in
designing a microreactor.

We describe the geometry, the model setup, the fundamental equations used, and the boundary conditions
of the CFD simulation. The results include the CFD solution as well as quantities of interest
pertaining to systems-level modeling.

For our [!ac](CFD) simulations, we have used Nek5000 [!citep](anl_nek5000_2019),
which has been extensively validated and verified and used for many nuclear engineering applications.
Nek5000 uses spectral element-based high-order spatial discretization, with second-
and third-order time-stepping schemes available.
It is highly scalable, and has capabilities for Direct Numerical Simulations, Large-Eddy Simulations, and unsteady [!ac](RANS) simulations.

### Prerequisites

!alert note
This tutorial assumes that you are familiar with the
[Nek5000 tutorial](https://nek5000.github.io/NekDoc/tutorials.html) and have a general awareness
of Nek5000's case structure, setup, and basic usage. You may ignore sections of the tutorial that
focus on Nek5000's internal meshing utilities such as
`genbox`, and instead use another meshing tool to generate a mesh in one of the two external
formats supported by Nek5000 -  an Exodus mesh (converted to Nek-supported `.re2` using the `exo2nek` utility),
or a Gmsh `.msh` mesh (converted to `.re2` using `gmsh2nek`). Also consider skimming through the
[RANS Tutorial](https://nek5000.github.io/NekDoc/tutorials/rans.html#)
and the [RANS example files](https://github.com/Nek5000/NekExamples/tree/master/RANSChannel)
to get better acquainted with the RANS models used in Nek5000.


## Model Description, Theory, and Setup

Prior to explaining the workings of the CFD model, this section explains the theory underpinning
our analysis. We discuss the advantages of using Nek5000 over conventional finite element CFD codes, followed by a look at the
equations and the workflow we utilize in this analysis.

### Nek5000 Theory

Nek5000 is a high-order CFD solver with its spatial discretization based on the Spectral Element Method(SEM) [!citep](fischer_chapter_2023).
The Nek5000 implementation of SEM uses high-order Legendre polynomials as basis functions
and Gauss Lobatto Legendre points as SEM nodes. This allows for excellent convergence, stability, and low numerical dispersion.
SEM offers key advantages over conventional finite-element solvers due to its ability to enable matrix-free forward operator evaluation
using 1D stiffness matrices applied in succession, as opposed to forming full 2D or 3D stiffness matrices as in conventional finite-element solvers.
This lowers floating-point operations and storage requirements for SEM significantly. For example, in 3D, the action of discrete operators can be
evaluated with $O(EN^6)$  work and using $O(EN^3)$ memory, which is respectively 2 and 1 order-of-magnitude lower than conventional finite elements
(where $E$ is the number of elements, and $N$ the number of unknowns in one dimension ).

This, however, limits the method to quadrilateral or hexahedral mesh elements, as 1D matrices need to be along clearly separable orthogonal axes for matrix-free
forward operator evaluation.
The trade off with using quad or hex elements is that care must be taken in meshing complex geometries to ensure elements conform well to non-linear features.
Additionally, SEM's computational advantages come into play when one uses high-order elements. For that reason, Nek5000 runs best with elements
of an order of at least 5, and ideally 7-11. Accordingly, if your prior experience is meshing for lower-order finite-elements,
consider making a coarser mesh than usual and run the simulation at a high polynomial order, otherwise you are likely to end up with an over-resolved mesh,
and any computational advantages of SEM will be nullified by the surplus degrees of freedom.

Nek5000 uses BDFk-EXTk solvers [!citep](deville_high-order_2002) that use extrapolation-based stabilization and implicit treatment of the advective term to provide
second- to third-order time-stepping.

The main equations solved are

\begin{equation}
\label{eq:mass}
\nabla\cdot\mathbf u=0
\end{equation}

\begin{equation}
\label{eq:momentum}
\rho_f\left(\frac{\partial\mathbf u}{\partial t}+\mathbf u\cdot\nabla\mathbf u\right)=-\nabla P+\nabla\cdot\tau+\rho\ \mathbf f
\end{equation}

\begin{equation}
\label{eq:energy}
\rho_f c_{p,f}\left(\frac{\partial T_f}{\partial t}+\mathbf u\cdot\nabla T_f\right)=\nabla\cdot\left(k_f\nabla T_f\right)+\dot{q}_f
\end{equation}

Nek5000 is able to adjust its solver tolerances automatically and solve the equations above directly,
working in what we refer to as the dimensional formulation.
However, we often set up Nek5000 cases in the non-dimensional form,
as Nek5000 solver tolerances are optimized for such a formulation.

The non-dimensionalised form of the Navier-Stokes equations is [!citep](deville_high-order_2002):

\begin{equation}
\label{eq:ins}
   \tilde{\nabla} \cdot \tilde{u} = 0 \\
    \frac{\partial \tilde{u}}{\partial \tilde{t}} + \tilde{u} \cdot \tilde{\nabla} \tilde{u} = - \tilde{\nabla} \tilde{p} + \frac{1}{Re} \tilde{\nabla}^2 \tilde{u} + \tilde{F} \\
    \frac{\partial \theta}{\partial \tilde{t}} + \tilde{u} \cdot \tilde{\nabla} \theta = \frac{1}{Pe} \tilde{\nabla}^2 \theta
\end{equation}

where the non-dimensional temperature $\theta$ is based on a user-defined $T_0$ and $\Delta T$:
\begin{equation} \label{eq:temp_theta}
\theta = \frac{T-T_0}{\Delta T}
\end{equation}

!alert note
When non-dimensionalizing, carefully consider the characteristic length-scale, characteristic velocity and reference temperatures
based on estimated temperature and velocity values.
Ideally, we want the maximum non-dimensional velocity and temperature to be as close to 1 as possible, and the
respective minimum values to be 0.

To keep the computational costs for this tutorial accessible to as wide of a target audience as possible,
we have used [!ac](RANS) to model turbulence. The [!ac](RANS) model used in our work is wall-resolved k-$\tau$ [!citep](kok_efficient_2000).
The advantages of $k-\tau$ over $k-\epsilon$ are similar to those of $k-\omega$, in that
it is superior to $k-\epsilon$ in resolving the effects of near-wall behavior and the effects of streamwise pressure gradient.
Additionally, it is more numerically stable than k-$\omega$ as $\tau = 1/\omega$, which simplifies wall boundary conditions to
homogeneous Dirichlet conditions and creates well-bounded
source terms for the $\tau$ scalar transport equation near the wall.

### Air Jacket Geometry

The air jacket is a natural circulation driven passive heat removal component of a generic high-temperature gas-cooled microreactor.
This "jacket" is the air gap between the reactor vessel and the shielding, as shown in [airjacket_overview] (right).
A wedge-shaped section of the fluid domain is shown in [airjacket_overview] (left).
The inner surface of the air gap is heated by the reactor vessel, whereas the outer surface is insulated.
The inlet at the bottom supplies air at 50$^\circ$C. The heated section, which is held at a constant temperature
of 420$^\circ$C, drives the flow by natural circulation, causing the air to rise through the heated section before exiting at the exhaust at the top.
The geometry that we have simulated is the 2D cross-section of a wedge-shaped slice of the air jacket.

!media airjacket/overview.png
       style=width:100%
       id=airjacket_overview
       caption=The microreactor core (right) and the air jacket geometry, meshed in 3D (left).

### Pressure balance in natural circulation

A typical natural convection problem involves a closed loop with a heat source (usually heat flux boundary condition) and a
heat sink. The problem here has an open loop that is representative of a nascent reactor design when the exact geometry is
in flux and the heat sink and source are not precisely defined. Instead of a heat flux boundary condition, we are given a
temperature Dirichlet condition which has a value equivalent to the maximum safe temperature of the hot wall, and we are asked to investigate the flow
characteristics, friction factor, and heat transfer coefficient at said limiting condition.

The exact inlet boundary condition or the mass flow rate, and the outlet temperature are not known. However, based
on the pressure balance expected for a natural convection problem, we can iteratively derive the mass flow rate, which can
then be used to evaluate other quantities of interest.

To create a relatively inexpensive CFD model that is accessible to a wide range of users, we have chosen wall-resolved RANS as our
turbulence model. The problem is essentially 2D in character, due to a lack of variation in CFD statistics in the azimuthal
direction of the cylindrical air jacket domain after Reynolds-averaging. Hence a 2D simulation is adequate for the purposes
of calculating flow and heat transfer characteristics for this geometry when using RANS. The problem is simulated in the axisymmetric
mode to capture the cylindrical nature of the 3D geometry in relation to the 2D. The details of the axisymmetric mode setup are in the next section of
the tutorial.

The effect of buoyancy is modeled using the simpler of two options available in Nek5000: the Boussinesq approximation, with air represented as
an ideal gas, instead of the alternative, which is a low-Mach treatment with either ideal or real gas behavior [!citep](anl_nek5000_2019). We are utilizing the simple gradient diffusion hypothesis to model the turbulent heat flux [!citep](hsieh_numerical_2004) with a turbulent Prandtl number of 0.85.

The density reduction as the air heats up in the air jacket creates the main buoyant pressure difference driving the natural circulation.
The average density of air in the air jacket can be calculated during the simulation using the ideal gas law as a function of the mean temperature.
Given temperature boundary conditions and dimensions, our main objective was to determine the friction factor and the Nusselt number ($Nu$). The pressure balance at the steady state is given by:

\begin{equation}
\label{eq:pbalance}
\Delta P_{int}= \Delta P_{ext}
\end{equation}

Assuming the inlet is at the ambient conditions, the external gravitational pressure drop is simply
\begin{equation}
    \Delta P_{ext} = \rho_0 g H
\end{equation}
The total internal pressure drop includes the mean internal gravitational pressure drop and minor losses (with form and friction losses modeled with an effective friction factor)
\begin{equation}
    \Delta P_{int}= \Delta P_{g}+\Delta P_f
\end{equation}
where the mean internal gravitational pressure drop (based on the mean weight of the air in the air jacket) and minor losses are modeled respectively as
\begin{equation}
\Delta P_g = \rho_m g H \label{eqn:dp_exp}
\end{equation}
\begin{equation}
\Delta P_f = \frac{1}{2} \frac{f}{D} H \rho_0 U_m ^2
\end{equation}
Combining these with the total pressure balance given by [eq:pbalance] yields
\begin{equation}
    \frac{1}{2} \frac{f}{D} H \rho_0 U_m ^2+\rho_m g H =\rho_0 g H
\end{equation}
\begin{equation}\label{eq:iterative_re}
    \frac{1}{2} \frac{f}{D} H \rho_0 U_m ^2 =\left(\rho_0 -\rho_m\right) g H
\end{equation}

Since the gravitational pressure drop is a hydrostatic quantity, we adopt "mean density" to imply volumetric mean (simple volumetric average) rather than bulk mean (velocity-weighted volumetric average).
The mean density is then evaluated using the Boussinesq model and the ideal gas approximation ($\beta_0 = 1/T_0)$.
The general relationship for density is then given by
\begin{equation}
    \rho - \rho_0 = -\rho_0\beta_0\left(T - T_0\right)
\end{equation}
Since this gives a linear relationship between density and temperature, we have
\begin{equation}
    \rho_0 -\rho_m = \rho_0\beta_0\left(T_m-T_{in}\right)
\end{equation}
The pressure balance then becomes
\begin{equation} \label{p_balance}
    \frac{1}{2} \frac{f}{D} H \rho_0 U_m ^2 =\rho_0\beta_0\left(T_m-T_{in}\right) g H
\end{equation}

The friction factor can be obtained using
\begin{equation} \label{eqn:fric_fac}
    f  =\frac{2Dg}{U_m ^2}\beta_0\left(T_m-T_0\right)
\end{equation}

### Initial guess for velocity and mean temperature

Given the geometry, the inlet temperature, and the hot wall temperature, there are two main unknowns that we need to estimate: $\bar{U}$: the mean
inlet velocity, which shall help us determine the Reynolds number of the simulation, and
$T_m$: the bulk temperature, that will help us understand the energy balance and define the Boussinesq acceleration term.

These two unknowns are coupled through pressure and energy balance equations. These equations involve the following quantities:
\begin{equation} \label{derived_qty}
T_{mean} = \frac{1}{2} (T_o + T_{in})
\end{equation}
\begin{equation}
\rho_{mean} = \frac{P_o M_{air}}{R T_{mean}}
\end{equation}
\begin{equation}
Re = \frac{\rho_{mean} \bar{U} D_h } {\mu}
\end{equation}
\begin{equation}
f_D = 0.3164 Re^{-0.25}
\end{equation}
\begin{equation}
h = \frac{k_f}{L} (0.023 Re^{0.8} Pr^{0.4}) \label{derived_qty_end}
\end{equation}
where $P_o$ is the atmospheric pressure, $M_{air}$ the molar mass of air (approx. 28 g mol$^{-1}$ [!citep](jones_air_1978)),
$R$ the gas constant, $f_D$ the Darcy friction factor, $Re$ the Reynolds number, and $Pr$ the Prandtl number.

Note that we are assuming ideal gas behaviour, and are also neglecting the pressure differences within the domain relative to atmospheric pressure.
The mean temperature is approximated as the mean of the inlet and outlet temperatures as an initial guess, and the outlet temperature is the independent unknown variable.
The correlations for the friction factor and heat transfer coefficient assume turbulent flow. You may find other correlations to be more appropriate for your case,
however the idea is to verify that the results obtained from the pressure and energy balance obtained later in this section are consistent with your assumptions
and correlations. In this case, we will find that assuming the flow is not laminar is appropriate. Also note that the main unknowns are still $\bar{U}$ and $T_m$ or $T_o$,
 with [derived_qty]-[derived_qty_end] being secondary equations that will feed into our main pressure and energy balance equations.

The pressure balance equation has already been discussed ([p_balance]). The energy balance is given by the balance between the convective heat transfer between the hot wall and the fluid bulk, and the heat advected into and out of the
air jacket:
\begin{equation}
q_{hot wall} = q_{advection}
\end{equation}
\begin{equation}
A_{hw} h(T_{hot} - T_{mean}) = \dot{m} C_p (T_o - T_{in})
\end{equation}
\begin{equation}
A_{hw} h(T_{hot} - T_{mean}) = \rho_{mean} \bar{U} A_c C_p (T_o - T_{in}) \label{q_balance}
\end{equation}
where $A_{hw}$ is the hot wall area, $T_{hot}$ the hot wall temperature, $A_c$  the cross section area of the channel.

The main equations to be solved for $\bar{U}$ and $T_o$ are [p_balance] and [q_balance]. These are non-linear, and can be easily solved with symbolic mathematics software or iterative solver
packages such as `scipy`.

!listing microreactors/gcmr/airjacket/re_estimate.py start= pqbalance( end=fsolve include-end=True

Approximations for $T_m$ (which require an approximate heat transfer coefficient $h$) and $f$ using conventional correlations (such as Dittus-Boelter and Blasius correlations, respectively) can be used for an initial guess, but as the simulation is run, values are calculated directly from the results. With these results, the correct $f$ and $Nu$ can be determined for a given $U_m$.

We have assumed uniform inlet ($T_{in}$) and hot-wall temperatures ($T_{wall}$) based on simple data from limiting conditions,
while all remaining walls have adiabatic boundary conditions applied to temperature due to insulating material.

The outlet was artificially extended by a few characteristic lengths and the Boussinesq acceleration term gradually ramped down
to allow for the highly biased jet in the upper plenum to redistribute and flow outwards at the outlet uniformly in order to avoid any eddies
that can cause numerical divergence-inducing backflow at the outlet. The gradual ramping down prevents any effect on the results upstream.
Wall resolution was ensured by monitoring $y^+$1 values at the first Gauss Lobatto Legendre point off the wall.

To capture the buoyant momentum source, we have applied the Boussinesq approximation. The Boussinesq term is a forcing term applied to the momentum Navier-Stokes
Equation ([eq:ins]), which in non-dimensional terms, is expressed as
\begin{equation}
\tilde{F} = \frac{ \beta_0 (T - T_0) g L}{U ^2} \hat{z} = Ri \: \theta
\end{equation}
where $Ri$ is the Richardson number, $T$ the dimensional local temperature, and $\theta$ the non-dimensional local temperature.

The average Nusselt Number is calculated as
\begin{equation}
Nu = \frac{hL}{k} = \frac{L}{k} \left( \frac{k (\nabla T |_{wall} \cdot \hat{n})}{T_w - T_b} \right) = \frac{\tilde{\nabla} \theta | _{wall} \cdot \hat{n}}{\theta _w - \theta _b}
\end{equation}
where $\tilde{\nabla}\theta | _{wall}$ is the average non-dimensional temperature gradient at the hot wall, $\theta_w$ the non-dimensional hot-wall temperature, and $\theta_b$ the non-dimensional fluid bulk temperature.

Once the simulation has attained a fully developed state, it is possible to compare the pressure drop calculated from the CFD simulation, say $\Delta P$,
and compare it to the expected pressure drop based on [eqn:dp_exp], that is, zero (as the external pressure is balanced by the internal pressure at steady state).
If the two pressure drops do not match, it is possible to iterate on the value
of the mass flow rate by adjusting characteristic velocityu $U_m$, or in other words, the Reynolds number ([eq:ins]) until we arrive at the expected
pressure drop, using the procedure described in [fig_iteration].

!media airjacket/iteration.png
       style=width:50%
       id=fig_iteration
       caption=The iterative algorithm that can be used to derive the correct pressure drop according to [eqn:dp_exp].

## Computational Model Description

The following section describes the input file and the model setup. Please note that the setup of the RANS model is identical
to the Nek5000 RANS Channel tutorial mentioned in the introduction, and is therefore not repeated here for the sake of brevity.

### Axisymmetric Mode Setup

In Nek5000, the axisymmetric mode requires the axis of symmetry to be the x-axis, which becomes the r-axis, while the y-axis becomes the vertical axis.
Furthermore, the entire mesh must lie above the x-axis/r-axis, as there can be no negative r values. Your mesh needs to be oriented accordingly
in your mesh generator. Mesh modifications can also be performed in Nek5000, in the `usr` file's `usrdat2` function. For the air jacket mesh ([airjacket_overview]),
the mesh needs to be rotated clockwise by 90 degrees to be aligned with the axis of symmetry. This is accomplished by the following code:

!listing microreactors/gcmr/airjacket/airjacket.usr start= rescale the domain end=enddo include-end=True

Once the mesh has the desired orientation, the axisymmetric mode can be turned on in the `par` file using the `axiSymmetry = yes` line in the `[PROBLEMTYPE]` block:

!listing microreactors/gcmr/airjacket/airjacket.par start=PROBLEMTYPE end=axiSymmetry include-end=True

### Boundary Conditions, Initial Conditions, Boussinesq approximation

Tying sidesets to a type of boundary condition can be accomplished through the `par` file. For each field, such as `VELOCITY`, sidesets
starting from 1 can be assigned a boundary type using the `boundaryTypeMap` key:

!listing microreactors/gcmr/airjacket/airjacket.par start=VELOCITY end=boundary include-end=True

A similar action can be accomplished in the `usr` file, in the `usrdat2` routine, by modifying the `cbc` array. This is recommended when
your sideset IDs have arbitrary numbers that do not start with `1`

!listing microreactors/gcmr/airjacket/airjacket.usr start=assign BC end=c      enddo include-end=True

The inlet boundary has a constant $u_x$, $u_y$, $k$, and $\tau$ boundary condition, and temperature is set to 0 based on our nondimensionalization.
The hot wall temperature is set to a constant value of 1 in nondimensional terms (420 $^\circ$C), that is implemented with a short, linear ramp near the base of
the hot wall to avoid sharp gradients that create problems with resolution of scalars. The walls have zero Dirichlet conditions for $k$ and $\tau$. The outlet
boundary condition is do-nothing, specified in the `par` file.  The boundary conditions are specified in the `usr` file in the `userbc` subroutine:

!listing microreactors/gcmr/airjacket/airjacket.usr start=subroutine userbc end=c---- include-end=False

The initial conditions are specified in `useric` as follows

!listing microreactors/gcmr/airjacket/airjacket.usr start=subroutine useric end=c---- include-end=False

Note that these initial conditions are overwritten if the simulation is restarted from another run's output, using the `startFrom` option
in the `par` file. A good initial condition is vital for stability and good convergence. Some tips for generating the initial condition for this
simulation include running with a coarse mesh, turning off the axisymmetric mode, and using the obtained data to restart the simulation using the
output obtained.

The Boussinesq approximation is applied as a forcing term in the `userf` routine. Note that the Richardson number is calculated in the
`userchk` subroutine, and transferred to `userf` using a `common` block, as shown below. Complicated calculations that require global
operations across all MPI ranks are best performed in `userchk`, as subroutines like `userbc`, `useric`, and `userf` are not called
by every MPI process by design, as mentioned in the Nek5000 documentation and template `.usr` file (`Nek5000/core/zero.usr`). The Boussinesq term is gradually
ramped down in the upper plenum, as we want the highly biased flow to redistribute and exit the domain cleanly, without causing
backflow at the outlet, which can cause the simulation to diverge.

!listing microreactors/gcmr/airjacket/airjacket.usr start=subroutine userf end=c---- include-end=False

### Meshing

When meshing, we performed h-refinement in our meshing software (Cubit) by adding elements to areas of transition between the channel and the plena, and other
regions where under-resolution was observed. Then the final mesh refinement was performed using p-refinement in Nek (using the `lx1` parameter in the `SIZE` file), as is typical
in spectral elements. Also of note are the boundary layers, which can have a relatively aggressive growth rate in spectral elements([boundary_layer]).

!media airjacket/boundary_layer.png
       style=width:100%
       id=boundary_layer
       caption=The boundary layers in the channel.

The mesh was created using Cubit and a `stp` file provided by the reactor designer. The file was exported to the Exodus format and
converted to the Nek-supported `.re2` using the utility `exo2nek`. If `Nek5000/bin` is added to the `$PATH`, `exo2nek` can be executed
directly from the command line. The tool guides the user through the mesh conversion process. In this case, we recommend skipping the element
right-handedness check for the mesh and proceeding with the mesh conversion process as suggested by the command line prompts.

Wall resolution can be verified by checking $y+$ values call the `print_yplimits` subroutine (provided in the `extract_yp.f` file)
in `userchk` at whatever frequency is desired.
The subroutine calculates $y+$ values and outputs a variety of relevant metrics, the most important being the ratio of wall points
with $y+ \leq 1$ to the total number of wall points, outputted as `ratio less than 1.0 is :` in the `logfile`. Ideally, this ratio
should be nearly 1.0. The $y+$ values can also be visualized using the output array from `print_yplimits` dumped into a Nek5000
output file using the `outpost` function.

### Statistics at runtime and postprocessing

To iterate on the Reynolds number until the correct pressure drop of zero is obtained
we need to calculate the pressure drop across the channel. We also need to calculate the Nusselt number, mean and outlet temperatures,
and monitor a variety of other quantities for convergence. Our averaging code can monitor simulations as they run, using lines printed
in the `logfile`. The basic idea behind our code is to construct masks or maps that identify the correct points or element faces based
on coordinate ranges. We want to do this once, at the beginning of the simulation in `usrdat2`, to not have to waste computational time
looking for the same elements at every time step (which is what would occur if the following code were placed in `userchk` instead of
`usrdat2`). We create element maps/masks, that store local element and face IDs based on the element's centroid being between a certain
coordinate range, and the face lying along a normal

!listing microreactors/gcmr/airjacket/airjacket.usr start=element map of lower plane end=test_emap include-end=True

The above code will store zeros in the `emap_lo` array, indicating the local element ID corresponding to that index of `emap_lo` belongs
to an element whose centroid does not lie in the specified range of x and y values. For elements that do lie within the specified coordinate
range, the corresponding value of `emap_lo` at the index corresponding to the local element ID stores the face that has a normal closest to the
normal specified. To verify the correct elements and faces have been selected, the `test_emap` function can be used. It will create a Nek output
file with the name `elo<casename>.nek5000`, which can be opened in Paraview. Look at the `x-velocity` field - the element map `emap_lo` will be
highlighted with values equal to 1.0 at each node on the face. The rest of the points will be zero.

Now that we have stored the element and face IDs that we need, we can average over faces using functions in the `aravg.f` file, that rely on Nek5000's
internal functions `facint_v` and `facint_a`, which require element and face IDs as arguments. This will allow us to calculate area averages across
the selected faces. Volumetric averages can be computed by constructing masks of nodes between a range of x and y values, using the following code

!listing microreactors/gcmr/airjacket/airjacket.usr start=create masks end=create_mask include-end=True

These element maps can be stored in a `common` block, so that they are accessible in `userchk` despite being created in `usrdat2`. To average any
of the Nek5000 solution arrays over these element maps, simply call the following functions from `aravg.f` in `userchk`, such as

!listing microreactors/gcmr/airjacket/airjacket.usr start=calculating averages end=tauinav include-end=True

Bulk averages can be calculated similarly using the point masks and the `bulkavg` function. Weighted scalar averages or area integrals can be
calculated using the `emap_scalar_avg` function. The variables can be saved, for example, using a common block, and the difference between
their values at successive time-steps printed to monitor convergence. Gradients for calculating the Nusselt number are obtained using Nek5000's
`gradm1` subroutine, and the gradients are averaged over the hot-wall to obtain a heat flux using Nek5000's `facint` function.

Using these postprocessing functions, we can monitor the pressure drop across the channel at runtime by calculating the average pressure at the top and
bottom of the channel, and iterating on the Reynolds number until the difference between the calculated pressure drop and the target pressure drop
is below the solver tolerance.

!listing microreactors/gcmr/airjacket/airjacket.usr start=pressure drop calculation end=dp include-end=True

### Input parameters

A list of miscellaneous input parameters is included in [input_parameters] for reproducibility.

!table id=input_parameters caption=Simulation input parameters.
| Parameter  | Value  | Unit  |
| :- | :- | :- |
| Inlet temperature | 323.15 | K |
| Hot wall temperature | 693.15 | K |
| Density | 1.10342 [!citep](lemmon_thermodynamic_2000) | kg m$^{-3}$ |
| Viscosity | 1.951 $\times$ 10$^{-5}$ [!citep](kestin_viscosity_1964) | Pa s |
| Thermal conductivity | 0.02766 [!citep](stephan_thermal_1985) | W m$^{-1}$ K$^{-1}$ |
| Specific Heat Capacity $c_p$ | 1007.4333 [!citep](lemmon_thermodynamic_2000) | J kg$^{-1}$ K$^{-1}$ |
| Prandtl Number | 0.710594 |  -  |
| Characteristic length | 40 | mm |
| $T_0$ ([eq:temp_theta]) | 323.15 | K |
| $\Delta T$ ([eq:temp_theta]) | 370.0 | K |
| Pressure solver tolerance | 10$^{-4}$ | - |
| Velocity solver tolerance | 10$^{-6}$ | - |
| $k$ solver tolerance | 10$^{-8}$ | - |
| $\tau$ solver tolerance | 10$^{-6}$ | - |


## Results

The velocity and temperature results obtained are shown in [fig_results_velo] and [fig_results_temp].
The flow enters the domain from the bottom left in the lower plenum, and accelerates in the hot channel due to a narrowing of the
cross-section and due to the Boussinesq acceleration term. The air leaves the heated channel and enters the
upper plenum in a state biased entirely towards the top of the plenum. The gradual ramping down of the
Boussinesq term in the upper plenum gradually redistributes this jet and allows it to exit the domain
without any backflow at the outlet, while causing no impact on the results upstream. The relatively
low Reynolds number in the hot channel (obtained both through correlations and our iterative analysis)
does not promote significant mixing in the channel itself.
For the purposes of visualization, the excess upper
plenum outlet region has been clipped by about 50% to remove the region that exists only for allowing the flow
to redistribute and exit the domain cleanly.

!media airjacket/velocity_dimensional.png
       style=width:100%
       id=fig_results_velo
       caption=The velocity solution.

!media airjacket/temperature_dimensional.png
       style=width:100%
       id=fig_results_temp
       caption=The temperature solution.

The quantities of interest calculated from steady state results are summarized in [tab_results].
Note that CFD also allows the estimation of certain data that cannot
be reliably estimated from correlations alone without significant approximations and simplifications.

!table id=tab_results caption=Summary of results.
| Parameter  | Correlation-based estimate  | CFD-based result  | Units |
| :- | :- | :- | :- |
| Reynolds Number | 3152.99 | 3580 | - |
| Friction Factor | 0.0409 | 0.028403 | - |
| Nusselt Number | 13.98 | 13.53 | - |
| Bulk temperature | - | 352.458 | K |
| Outlet temperature | - | 383.394 | K |
| Heat flux | - | 3.01 $\times$ 10$^3$ | W m$^{-2}$ |
| Heat removed per second | - | 2.072 $\times$ 10$^4$ | W |

## Run Command

To generate an `.ma2` file for your mesh (`.re2`), use `genmap`, as described in the Nek5000 tutorial.
Adjust the mesh resolution and other parameters in the `SIZE` file, and compile using `makenek <casename>`.
To run the case, execute

```language=bash
nekbmpi airjacket 144

```

which uses the script `nekbmpi` to internally call `mpiexec`. On some HPC systems, `srun` may be required
instead.
