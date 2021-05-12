# Pebble heat conduction simulation

The neutronics and thermal hydraulics simulation provide us with the power distribution and
the fluid and solid phase temperature on the macroscale. They do not resolve the individual pebbles,
and therefore cannot directly inform us on local effects such as temperature gradients within a pebble.
These are important to lead fuel performance studies, to verify that the pebbled-fuel remains within
design limitations in terms of temperature and burnup.

We use a multiscale approach to resolve the pebble conditions within the reactor. We sample pebble locations
over a coarse mesh using a `CentroidMultiApp`. There are two kinds of pebbles in the core: graphite pebbles in the
outer reflector and fueled pebbles in the active region of the core.
In the reflector, each sub-app is a 1D spherical heat conduction simulation.

!listing /pbfhr/steady/ss3_coarse_pebble_mesh.i block=MultiApps/graphite_pebble

!alert note
The `app_type` may be specified to use a smaller, faster application to run a simulation. For example, a
`HeatConductionApp` is faster to generate than a `PronghornApp`, itself faster than a `BlueCrabApp`. Depending
on how the computing environment is set up, the `library_path` may need to be specified to indicate where to load
this smaller application.

As is the case with the graphite pebbles, the fuel pebbles are treated using a sub-app; fuel pebbles are modeled with a 1-D multiscale heat conduction model.

!listing /pbfhr/steady/ss3_coarse_pebble_mesh.i block=MultiApps/fuel_pebble

`MultiAppVariableValueSamplePostprocessorTransfer` and `MultiAppVariableValueSampleTransfer` allow us to sample the temperature
of the solid phase and the power density at these locations and populate a postprocessor / a variable respectively in the
sub-app.

!listing /pbfhr/steady/ss3_coarse_pebble_mesh.i block=Transfers/fuel_matrix_heat_source Transfers/pebble_surface_temp_1

`MultiAppPostprocessorInterpolationTransfer` can interpolate from postprocessors in each of subapp at their
specified location into auxiliary variables in the macroscale simulation.
We use that to obtain the distribution throughout the core of the UO2, graphite matrix and outer shell temperatures.

This can help the reactor analyst examine the most challenging regions in terms of fuel
performance. They may also leverage the `Adaptivity` system to automatically refine the mesh, and therefore
spawn more pebble simulations, in the regions of interest. Finally, having access to the temperature of each
solid phase in the pebble allows for more accurate self-shielding calculations, for group cross section
generation.

!listing /pbfhr/steady/ss3_coarse_pebble_mesh.i block=Transfers/max_T_UO2 Transfers/average_T_UO2 Transfers/average_T_matrix Transfers/average_T_graphite Transfers/average_T_shell

## Reflector pebble heat conduction

Reflector pebbles are modeled as homogeneous graphite spherical pebbles. We represent them with
a 1D mesh in spherical coordinates.

!listing /pbfhr/steady/ss4_graphite_pebble.i block=Mesh Problem

The heat conduction equation with no source is described with a time derivative kernel
and a diffusion kernel, specialized as `HeatConduction` kernels in the heat conduction module.

!listing /pbfhr/steady/ss4_graphite_pebble.i block=Kernels

The center of this spherical pebble is naturally a zero flux symmetry boundary condition. The
temperature at the outer surface of the pebble is the temperature of the solid phase. This
temperature is received from the main-app in a `Receiver` postprocessor. It is then used by a
`PostprocessorDirichletBC` to set the boundary condition.

!listing /pbfhr/steady/ss4_graphite_pebble.i block=Postprocessors/pebble_surface_T BCs

!alert note
The pebble conduction simulations are led using a finite element discretization. While the kernels
also exist for the finite volume discretization, the finite element discretization will remain in
Bison simulations in future iterations of the model.

## Fueled pebble heat conduction multiscale simulation

The fueled pebble is modeled using a similar approach, except the sphere is not uniform.
Its center is a graphite core, surrounded by a fuel matrix then a graphite shell. We still represent
the pebble as a 1D spherical system, with each zone defined as a different subdomain.

!listing /pbfhr/steady/ss4_fuel_pebble.i block=Mesh/mesh Problem

We use a Heat Source Decomposition approach [!citep](Novak2021) to solve the multiscale heat conduction
problem with sources. The heat source is decomposed in its mean and fluctuation (of zero average) terms, corresponding to
the meso- and micro-scale. This approach is a decomposition of the heat conduction equations.

\begin{equation}
\dot{q} = <\dot{q}> + \hat{\dot{q}}
\end{equation}

The mesoscale equation is written in terms of the mesoscale temperature, which is a slowly varying
long-wavelength thermal solution of the problem with the average heat source and averaged (mixed)
thermal properties.

\begin{equation}
\rho_{meso} C_{p,meso} \dfrac{\partial T_{meso}}{\partial t} - \nabla \cdot (k_{meso} \nabla T_{meso}) - <\dot{q}> = 0
\end{equation}

The conduction equation on the microscale, the TRISO particles here, is similarly written,

\begin{equation}
\rho C_{p} \dfrac{\partial T_{micro}}{\partial t} - \nabla \cdot (k \nabla T_{micro}) - \hat{\dot{q}} = 0
\end{equation}

In the microscale, we use the actual material properties of the materials involved, since there is
no homogenization of the problem involved.
The solid phase temperature is then the superposition of the mesoscale and microscale solutions.

\begin{equation}
T(x) = T_{meso}(x) + \sum_i T_{micro,i}(x)
\end{equation}

where $x$ is the local coordinate and i is the index of the particles or microscale media.

In the fuel matrix, there is heat generation from the fission reactions. We solve the mesoscale conduction equation with the mean heat source.

!listing /pbfhr/steady/ss4_fuel_pebble.i block=Kernels/time Kernels/diffusion Kernels/heat_source

Since there is no fuel in the core and the shell, and we do not model non-fission heating, there is
no heat source in those subdomains.

!listing /pbfhr/steady/ss4_fuel_pebble.i block=Kernels/time2 Kernels/diffusion2

The fuel matrix temperature and the graphite temperatures match on their interfaces. We use an interface kernel to impose the equality conditions on both sides of the fuel matrix.

\begin{equation}
T(x_{left/right}) = T_{meso}(x_{left/right}) + T_{micro}(x_{outer}) = T_{graphite}(x_{left/right})
\end{equation}

where $x_{outer}$ is the outer boundary of the microscale domain, which will be detailed further in the next section. $T_{micro}(x_{outer})$ is obtained from the TRISO scale calculation.

!listing /pbfhr/steady/ss4_fuel_pebble.i block=InterfaceKernels

The material definitions, and the mixing of material properties from different components of a phase,
is covered in the [macroscale thermal-hydraulics simulation input](pbfhr/steady/pronghorn.md).

We solve the microscale equation in the fuel matrix with a separate simulation, using the
`MultiApp` system. We pass the heat source to the microscale simulation, and receive the outer
surface temperature of the microscale particle. The maximum and average temperatures reached in
the microscale simulations are also passed for postprocessing purposes.

!listing /pbfhr/steady/ss4_fuel_pebble.i block=MultiApps Transfers/particle_heat_source Transfers/particle_surface_temp

We cover the microscale equation treatment in the [fuel matrix microscale simulation](pbfhr/steady/triso.md).

!alert note
INL has recently developed a continuous tracking algorithm to assess
pebble depletion as they move through the core. This capability will complement
this model in the near future, as it is expended to study core depletion.
