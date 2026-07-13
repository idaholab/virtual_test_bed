# LMCR Primary Loop nekRS LES Model

*Contact: Jun Fang, fangj.at.anl.gov*

*Model link: [LMCR nekRS LES Model](https://github.com/idaholab/virtual_test_bed/tree/mcre/msr/lotus/les)*

!tag name=LMCR Primary Loop nekRS LES Model
     description=High-fidelity large-eddy simulation model of the LMCR primary loop using nekRS
     image=https://github.com/idaholab/virtual_test_bed/tree/mcre/doc/content/media/msr/lotus/les/mean_Umag.png
     pairs=reactor_type:MSR
                       reactor:LMCR
                       geometry:primary_loop
                       simulation_type:CFD
                       codes_used:NekRS
                       open_source:fully
                       V_and_V:demonstration
                       computing_needs:HPC
                       fiscal_year:2024
                       sponsor:NEAMS
                       institution:ANL

!alert note
The CFD solver nekRS is not included in the VTB CI test suites yet. Users are encouraged to reach out to the nekRS developer team at Argonne by emailing the POC (Jun Fang at [fangj@anl.gov](mailto:fangj@anl.gov)). Additionally, a beta version of the nekRS tutorial is available at the [nekRS Documentation](https://nekrs.readthedocs.io/en/latest/index.html).

## Model Overview

The LOTUS Molten Chloride Reactor (LMCR) is an open-core, fast-spectrum, liquid-fueled molten salt reactor concept that circulates chloride fuel salt through the reactor vessel and primary loop. The fuel salt, represented here by a UCl$_3$-NaCl eutectic mixture, provides both the fissile material and the primary heat-transfer medium [!citep](MCRreport2022,M3mcr2023). The high-fidelity computational fluid dynamics (CFD) model documented on this page represents an MCRE-like LMCR primary-loop configuration in which the unmoderated core cavity is connected to a curved inlet pipe, outlet pipe, pump region, and heat-exchanger leg. The checked-in nekRS case name is `mcre`, so the run files retain that historical name even though this VTB page documents the LMCR primary-loop LES benchmark.

Because fission energy is deposited directly into the circulating fuel, the flow field controls more than pressure drop and heat removal. It also affects delayed neutron precursor residence time, spatial reactivity feedback, and the temperature field seen by lower-fidelity multiphysics models. The open core cavity does not contain internal structures that would homogenize the incoming jet. As a result, centrifugal acceleration from the upstream elbow drives the inlet stream toward the vessel wall, producing strongly three-dimensional recirculation, large coherent eddies, and persistent short-circuiting paths between the inlet and outlet.

This nekRS model is intended to generate high-resolution large-eddy simulation (LES) data for understanding the LMCR primary-loop hydrodynamics and for calibrating engineering-scale thermal-hydraulic tools such as Pronghorn. The current checked-in case solves the incompressible isothermal flow problem with the temperature equation disabled, so the documented fields focus on velocity magnitude and the vertical velocity component. Accordingly, this study is centered on the loop flow velocity distribution and its turbulence characteristics.

!alert note
The case files are stored in `msr/lotus/les`. The checked-in `mcre.par` file is a demonstration template. To speed up start-up and develop the turbulent state more quickly, begin runs with a lower polynomial order (for example $P=3$ or $P=5$) and a reduced Reynolds number. After the transient has developed, set the nondimensional viscosity to `1/10742.82` and restart at a higher polynomial order (for example $P=7$) to run the long averaging production calculation.

## System Specifications

[lotus_les_specs] summarizes the primary design and material properties used for the high-fidelity LES setup. The operating point corresponds to a low-power molten chloride fuel loop at 900 K.

!table id=lotus_les_specs caption=Representative LMCR operating conditions and fuel-salt properties for the nekRS LES model.
| Parameter | Value |
| :- | :- |
| Core power | 100.0 kW$_{th}$ |
| Operating temperature | 900 K |
| Rated mass flow rate | 25 kg/s |
| Fuel salt composition | UCl$_3$ (33.3 mol%) - NaCl (66.7 mol%) |
| $^{235}$U enrichment | 93.2 wt% |
| Density at 900 K | 3279.0 kg/m$^3$ |
| Specific heat at 900 K | 640.0 J/(kg K) |
| Thermal conductivity at 900 K | 0.38 W/(m K) |
| Dynamic viscosity at 900 K | $5.926 \times 10^{-3}$ Pa s |

The reference core diameter is $D = 0.5$ m. For the 25 kg/s operating point, the corresponding mean core flow speed is approximately 0.03883 m/s. The resulting core Reynolds number is

\begin{equation}
Re = \frac{\rho v D}{\mu}
   = \frac{3279 \cdot 0.03883 \cdot 0.5}{5.926 \times 10^{-3}}
   \approx 1.074 \times 10^4 .
\end{equation}

This Reynolds number is well above the laminar-to-turbulent transition range for internal flows and motivates the use of LES rather than a purely steady Reynolds-averaged Navier-Stokes (RANS) closure.

## CFD Solver and Numerical Method

The flow is simulated with [nekRS](https://github.com/Nek5000/nekRS), a GPU-oriented spectral-element CFD solver for incompressible and low-Mach-number flows [!citep](NekRS). Like Nek5000, nekRS represents the solution in high-order hexahedral spectral elements, but it is implemented in C++ with OCCA backends for performance portability on GPU and CPU systems. This makes nekRS well suited for high-fidelity LES of the strongly swirling LMCR primary-loop flow.

The LES model uses the incompressible, constant-property form of the Navier-Stokes equations:

\begin{equation}
\frac{\partial u_i}{\partial x_i} = 0,
\end{equation}

\begin{equation}
\frac{\partial u_i}{\partial t} + \frac{\partial}{\partial x_j}(u_i u_j)
= -\frac{1}{\rho}\frac{\partial p}{\partial x_i}
+ \frac{\partial}{\partial x_j}\left[\nu\left(\frac{\partial u_i}{\partial x_j}
+ \frac{\partial u_j}{\partial x_i}\right)\right] + f_i,
\end{equation}

where $u_i$ is velocity, $p$ is pressure, $\nu$ is kinematic viscosity, and $f_i$ is the user-defined momentum source used to drive the loop. The checked-in case disables the scalar temperature solve because this stage of the benchmark is focused on hydrodynamic mixing, residence-time behavior, and velocity-field statistics.

The high-fidelity workflow uses lower-order transients to develop a turbulent initial condition before restarting at higher polynomial order for the production averaging run. In the documented analysis, initial transients were developed with $P=5$, while the final LES statistics targeting $Re \approx 10{,}742$ used $P=7$ for improved turbulent-scale resolution. 

## Case Setup

### Input files style=font-size:125%

The nekRS case is named `mcre`. The main files are:

- `mcre.re2`: spectral-element mesh in nekRS/Nek5000 format.
- `mcre.co2`: curved-side high-order geometry information.
- `mcre.par`: nekRS runtime parameters, solver tolerances, time-step controls, and material properties.
- `mcre.usr`: Nek-style user routines used for geometry scaling, boundary tag reconstruction, PID control, and the momentum-source calculation.
- `mcre.udf`: nekRS C++ user-defined functions that register and copy the body-force field to the device.
- `planar.f`: helper routine used to compute a planar average of velocity for flow-control feedback.

The primary nekRS settings are shown below.

!listing msr/lotus/les/mcre.par

The checked-in parameter file uses the `tombo1` time stepper, a target-CFL adaptive time step with a maximum nondimensional time step of $10^{-2}$, checkpoint output every 1,000 steps, pressure residual tolerance of $10^{-4}$, and velocity residual tolerance of $10^{-6}$. The `hpfrt` regularization option is enabled to stabilize under-resolved high-order content during turbulent transients.

### Boundary conditions and geometry scaling style=font-size:125%

The case is nondimensionalized by the 0.5 m core diameter. This scaling is applied in `usrdat2`, where each mesh coordinate is multiplied by $1/0.5$. The same routine reconstructs wall boundary tags from the mesh boundary IDs so that all solid surfaces use no-slip wall conditions.

!listing msr/lotus/les/mcre.usr start=subroutine usrdat2 end=c-----------------------------------------------------------------------

The velocity boundary-type map in `mcre.par` is `W`, so the flow is not driven by imposed inlet/outlet velocity conditions. Instead, the primary loop is circulated by a body force in the vertical pipe section. This approach avoids prescribing an artificial inlet profile immediately upstream of the open core and allows the loop flow to respond naturally to the curved pipe, expansion into the vessel, and outlet geometry.

### Momentum-source flow control style=font-size:125%

A proportional-integral-derivative (PID) controller maintains the target mean core velocity. During `userchk`, the code computes a planar average of the vertical velocity, compares it against the target nondimensional velocity of 1.0, and updates the axial forcing term. The force is applied in a selected vertical-pipe region and is saved periodically to `pid_restart.dat` so restarted simulations retain the controller history. The relevant user routine is included in the `mcre.usr` listing below.

!listing msr/lotus/les/mcre.usr start=subroutine userchk end=c-----------------------------------------------------------------------

The force field is transferred from the Nek user routine to nekRS through `mcre.udf`. Every ten time steps, nekRS copies the current solution to the Nek side, calls `userchk`, copies the updated `forcx` array into device memory, and applies it as a user velocity source.

!listing msr/lotus/les/mcre.udf

### Flow diagnostic plane style=font-size:125%

The planar average used by the PID controller is evaluated by `planar.f`. The helper routine integrates a user-provided field over a narrow band around the requested plane and restricts the diagnostic to the core region.

!listing msr/lotus/les/planar.f

## LES Results

### Instantaneous velocity field style=font-size:125%

Instantaneous $P=7$ velocity fields show a highly unsteady, asymmetric flow. The curved inlet pipe deflects the incoming salt jet toward the vessel wall, after which the jet breaks down into energetic three-dimensional eddies in the open cavity. The turbulence is dominated by large coherent structures rather than by small, nearly isotropic eddies, which is important for reduced-order modeling because the global circulation pattern controls the residence time distribution.

!media msr/lotus/les/inst_Ux.png
       style=width:70%;margin-left:auto;margin-right:auto
       id=lotus_les_inst_ux
       caption=Instantaneous vertical velocity, $U_x$, from the nekRS LES. The incoming jet is deflected by upstream curvature and produces strong local fluctuations.

!media msr/lotus/les/inst_Umag.png
       style=width:70%;margin-left:auto;margin-right:auto
       id=lotus_les_inst_umag
       caption=Instantaneous velocity magnitude, $|U|$, showing energetic large-scale eddies in the open core cavity.

The strongest instantaneous velocities occur along the impingement side of the vessel, where the inlet momentum enters the larger core volume. This behavior has potential implications for local wall heat transfer, thermal striping, and structural vibration. It also demonstrates why a high-fidelity reference solution is valuable: a steady or overly diffusive turbulence model may smooth out the coherent jet path that governs loop-scale mixing.

### Time-averaged flow structure style=font-size:125%

The time-averaged LES field reveals persistent macroscopic flow asymmetry. A high-velocity stream remains concentrated near the outer wall and a broad, low-velocity recirculating region occupies the opposite side of the core. The mean vertical velocity further indicates a complex three-dimensional recirculation pattern, including downward flow in the bulk region that competes with the wall-bounded inlet-to-outlet pathway.

!media msr/lotus/les/mean_Ux.png
       style=width:70%;margin-left:auto;margin-right:auto
       id=lotus_les_mean_ux
       caption=Time-averaged vertical velocity, $\langle U_x \rangle$, showing the persistent asymmetric circulation pattern.

!media msr/lotus/les/mean_Umag.png
       style=width:70%;margin-left:auto;margin-right:auto
       id=lotus_les_mean_umag
       caption=Time-averaged velocity magnitude, $\langle |U| \rangle$, highlighting the high-speed wall stream and lower-speed recirculation zones.

Three features are especially important for reactor analysis:

1. **Flow short-circuiting:** A substantial fraction of the fuel salt follows a fast wall-adjacent route from inlet to outlet. This path can reduce the effective core residence time for part of the fluid inventory and alter delayed neutron precursor transport.
2. **Stagnation and dead zones:** The side of the core opposite the inlet jet contains large regions of low mean velocity. In a coupled thermal calculation, such zones may be susceptible to heat accumulation because local advective removal is weak.
3. **Three-dimensional recirculation:** The combination of strong inlet curvature, expansion into an open vessel, and outlet suction generates a mean flow that cannot be adequately represented by a one-dimensional loop model or by an axisymmetric approximation.

## Implications for Lower-Fidelity Model Calibration

The LES data provide a reference for calibrating RANS and coarse-mesh system models used in longer reactor transients. In particular, this high-fidelity model can support:

- tuning of turbulent viscosity or turbulent kinetic energy limiters in stagnation and reattachment regions;
- selection of mixing-length scales that preserve the observed large coherent structures rather than overdamping them;
- assessment of wall-function behavior in regions of jet impingement, curvature-driven separation, and recirculation;
- residence-time-distribution estimates for delayed neutron precursor transport in liquid-fueled MSR multiphysics simulations;
- evaluation of whether porous-resistance or momentum-source surrogates in lower-fidelity tools reproduce the LES mean flow split and short-circuiting path.

## Running the Case

A typical nekRS workflow is to compile the case, run a lower-cost transient to establish a turbulent state, and then restart at the production polynomial order for time averaging. The exact module names and executable paths depend on the target machine, but the following commands illustrate the expected sequence from the `msr/lotus/les` directory:

```language=bash
makenek mcre
nekrs --setup mcre --backend CUDA
nekrs --run mcre --backend CUDA
```

For CPU-only testing or debugging, replace the OCCA backend with the backend supported by the local nekRS installation. For production calculations, adjust `polynomialOrder`, `viscosity`, checkpoint cadence, and job size in `mcre.par` to match the target resolution and Reynolds number before launching the long averaging run.