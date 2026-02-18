# Cardinal Model of a 7-Pin Lead-cooled Fast Reactor (LFR) Assembly

*Contact: Hansol Park, hansol.park@anl.gov*

*Model was co-developed by Yiqi Yu, Emily Shemon, and it was documented and uploaded by Jun Fang*

*Model link: [7-Pin Cardinal Model](https://github.com/idaholab/virtual_test_bed/tree/main/lfr/7pin_cardinal_demo)*

!tag name=Cardinal Model of a 7-Pin Lead-cooled Fast Reactor Assembly
     description=High fidelity model of conjugate heat transfer in a reduced 7-pin lead fast reactor assembly
     image=https://mooseframework.inl.gov/virtual_test_bed/media/lfr/cardinal_7pin/mesh.png
     pairs=reactor_type:LFR
                       geometry:assembly
                       simulation_type:neutronics
                       codes_used:Griffin;MCC3;NekRS
                       computing_needs:HPC
                       input_features:reactor_meshing;multiapps
                       V_and_V:demonstration
                       cross_sections:MC2
                       open_source:partially
                       fiscal_year:2023
                       institution:ANL
                       sponsor:NEAMS


This tutorial documents the development of a Cardinal multiphysics model aimed at predicting "hot channel factors" (HCF) in fast reactor designs [!citep](Shemon2018). The model utilizes Griffin [!citep](Lee2021), MOOSE [!citep](Lindsay2022), and NekRS [!citep](NekRS). HCFs are computed values that consider the impact of uncertainties in material properties, reactor geometry, and modeling approximations on predicted peak fuel, cladding, and coolant temperatures in the as-built reactor. Simplified geometry or physics in modeling approximations may lead to an overestimation of hot channel factors, resulting in unnecessarily conservative thermal design margins. Advanced modeling techniques could potentially reduce computed HCF values by addressing sources of modeling uncertainty, offering economic benefits for reactor vendors.

For high fidelity modeling, the reactor physics code Griffin [!citep](Lee2021) performs a fully heterogeneous fine-mesh transport calculation using the discontinuous finite element method with discrete
ordinates (DFEM-$S_N$) solver with Coarse Mesh Finite Difference (CMFD) acceleration, and the thermal hydraulics code NekRS [!citep](NekRS) performs the computational fluid dynamics (CFD) calculation.
These codes were individually assessed in prior work to ensure the necessary capabilities were in place [!citep](HCFReport).
This work describes initial efforts to couple the codes using the +MultiApp+ system of the MOOSE framework [!citep](Lindsay2022).
The open-source MOOSE-wrapper for NekRS, Cardinal [!citep](Novak2022), is used to bring NekRS into the MOOSE coupled ecosystem for fluid temperature calculations, and the open source MOOSE heat transfer (H.T.) module is leveraged to perform solid temperature calculations.

## Problem Specification

Due to the current lack of data on hot channel factors in lead-cooled fast reactors (LFR), a small 7-pin ducted LFR “mini-assembly” was developed as a proof-of-concept demonstration. The mini-assembly
is based on a 127-pin ducted LFR assembly prototype [!citep](HCFReport,WECLFR) and is shown in [setup].
The fuel rod geometry was adopted from the full assembly except there is no helium gap between the annular fuel and the cladding.
Pin pitch, duct thickness, and height of the active fuel rod were
adopted as-is. Cylindrical solid clad reflectors of length 20 cm and with the same diameter as the fuel rod are attached to the top and bottom of the fuel rod to mimic the realistic core configuration.
For simplicity, the lead coolant inlet velocity was reduced from the original value of 1 m/s to 11.86 cm/s to keep the flow in the laminar regime (Reynolds number of 780), which can significantly
reduce the runtime required for CFD. Accordingly, the total power was reduced by a factor of seven to bound the coolant temperature increase (~less than 300 K). However, we did not adjust the thermal conductivity of the solid materials, so the solid temperature range from fuel
centerline to outer cladding surface is lower than in the prototypical concept. The coolant density is represented as a linear function of temperature for the coolant density reactivity feedback effect
in neutronics calculation. MOOSE’s heat transfer module solves for solid temperature in all regions except the coolant.

!media lfr/cardinal_7pin/setup.png
       style=width:100%
       id=setup
       caption=Problem specification of seven pins with duct (no inter-assembly gap).

## Multiphysics Coupling

There are various numerical techniques to couple different physics. The Jacobian-Free Newton-Krylov (JFNK) method incorporates different physics variables in the system matrix and solves for all variables simultaneously. This is suitable for strongly coupled problems. However, this is not possible using the specific combination of three solvers in this work. Instead, the MOOSE +MultiApp+ system provides an alternative method using Picard iterations and the operator splitting
method.

### MOOSE MultiApp hierarchy style=font-size:125%

When performing multiphysics simulations using the MOOSE +MultiApp+ system [!citep](Lindsay2022), individual applications (physics solvers) are placed into a user-defined coupling hierarchy that determines
when each solver is called and when data transfers occur.
The “main” application sits at the top of the hierarchy and drives the simulation by calling “sub-applications” which sit below it. Subapplications can also drive their own sub-applications. The time step size of a sub-application cannot be bigger than that of the application above it.
This rule requires NekRS to be placed at the lowest level (because NekRS uses the smallest time step size, due to constraints on the Courant Friedrichs-Lewy (CFL) number).
Since NekRS and MOOSE H.T. solutions are tightly coupled through conjugate heat transfer, they are directly connected by H.T. calling NekRS as a subapplication.
The Griffin neutronics solve is placed at the top of the hierarchy since it does not need to be called as frequently as the H.T. solve.

The detailed coupling scheme is shown in  [its]. The conjugate heat transfer calculation between H.T. and NekRS is performed using the operator splitting method.
H.T. proceeds for one time step, and then the heat fluxes at the solid-fluid (clad-coolant and duct-coolant) interfaces are transferred
to NekRS for use as Neumann boundary conditions.
Then, multiple NekRS time steps are solved using the +sub_cycling+ option, and wall temperatures at the same interfaces are transferred back to H.T. for use as Dirichlet boundary conditions.
Picard iteration is essentially achieved “in time”, so that running a large number of time steps is equivalent to converging to a pseudo-steady state.
Note that the solid heat transfer solve does not have the time derivative term in the equation but is driven by the time dependent boundary condition in its +Transient+ executioner, while NekRS solves the time-dependent Navier-Stokes equations.

!media lfr/cardinal_7pin/iterations.png
       style=width:100%
       id=its
       caption=MOOSE +MultiApp+ hierarchy for multiphysics coupling: (A) and (B) are both candidate choices for multiphysics coupling in the DFEM-$S_N$/CMFD solver of Griffin.

The coupled MOOSE heat transfer and NekRS system is plugged under the +MultiApp+ system of Griffin. Griffin solves a steady state eigenvalue problem and performs a Picard iteration with its sub-apps.
The Griffin DFEM-$S_N$/CMFD solver has the option to call sub-applications either inside or outside the Richardson iteration loop (controlled by the +fixed_point_solve_outer+ parameter in the
+SweepUpdate+ executioner part of the input file).
The calling of HT/NekRS from inside and outside the Richardson iteration loop are shown in (A) and (B) in [its], respectively [!citep](Wang2021perimp).
In (A), temperature field is updated iteratively with the low order diffusion (CMFD) solution until temperature is converged, and once the temperature is converged, the high order transport (DFEM-$S_N$)
calculation is performed to update the closure term to be used in the diffusion calculation.
The whole simulation is terminated once the neutron angular flux solution is converged.
In (B), the neutronics and temperature calculations are separated; the temperature calculation is invoked every time the DFEM-$S_N$/CMFD solution is converged.
(B) was chosen in this work for the following reason. In (A), a partially converged power distribution is used to drive a fully converged CFD calculation for each neutronics Richardson iteration. This is computationally inefficient as CFD is very expensive and has to be performed with each Richardson iteration. In (B), the neutronics is
allowed to converge first (it is not highly dependent on temperature), which then drives the CFD calculation. (B) is more computationally efficient for weakly coupled problems and also ensures convergence of the temperature distribution.

### Data transfer style=font-size:125%

[transfer] shows the data transfer scheme between different physics solvers. For transferring volumetric heat source from Griffin to H.T., Griffin computes constant volumetric heat source per element and the value at the centroid of an element in the H.T. mesh is queried from the finite element solution in the Griffin mesh and used as a constant value over the element (see +MultiAppShapeEvaluationTransfer+ [!citep](Lindsay2022)).
The transferred heat source is normalized to preserve the original total power using MOOSE’s conservative transfer features.
For transferring the temperature field from H.T. to Griffin for Doppler and coolant density feedback, temperature values at the three closest nodes in the H.T. mesh to the target node in the Griffin mesh are
interpolated using inverse distance weighting (see +MultiAppGeometricInterpolationTransfer+ [!citep](Lindsay2022)).
Nearest points are searched only in the solid region for solid temperatures and in the fluid region for fluid temperatures.
Even though H.T. does not need the fluid domain for solving the heat
conduction equation, the H.T. problem contains a mesh for the fluid domain in order to receive the coolant temperature field transferred from Cardinal (on its way to Griffin) and compute its L2-norm for convergence check.
Note that Griffin does not need a fine mesh in the coolant region for
neutronics solution, and a fine coolant mesh in H.T. does not degrade computational efficiency except in memory-limited cases.

!media lfr/cardinal_7pin/transfer.png
       style=width:100%
       id=transfer
       caption=Data transfer scheme among Griffin, H.T., and Cardinal.

For the conjugate heat transfer, H.T. computes constant monomial heat flux per element at the cladding outer surfaces and the duct inner surface.
Note that the heat flux variable computed by H.T. is of an elemental type (monomial), while the variable automatically added by Cardinal on the mirror mesh of the NekRS native mesh, is using a nodal type (lagrange).
If there are multiple nearest centroids near parallel process boundaries or the nearest-nodes to the currently-considered centroids are not detected within the process boundary, parallel resolution between nearly equi-distant points may be inaccurate unless extensive searches are done over every process or a bounding box, for setting the search region in a heuristic, larger than the mesh discretization (the distance between the nodes and centroids that should be matched) is set in transfer.
Due to this issue, a new nodal type heat flux is used for transfer by converting the elemental type variable to the nodal type using +ProjectionAux+ before transfer.
For the transfer, +MultiAppGeneralFieldNearestLocationTransfer+ [!citep](Lindsay2022) is used separately for different interfaces (e.g. duct-coolant and clad-coolant) with spatial restrictions on source and target boundaries for the search.
To preserve the total energy, the total power produced in the fuel rods
and in the duct are separately transferred to Cardinal for normalization of the transferred heat flux at each interface by Cardinal.
The heat flux could have been preserved on a per-rod basis but we chose not to because heat flux distribution among different fuel pins was calculated fairly accurately.

The solid-fluid wall temperature is transferred from Cardinal to H.T. in the same manner as the transfer of the heat flux.

!alert note
Since the wall temperature is a part of the +AuxiliarySystem+ in H.T. which is not restored during the Picard iteration even with +keep_solution_during_restore = true+ (until [this is issue in MOOSE is resolved](https://github.com/idaholab/moose/issues/19078)) in
+FullSolveMultiApp+, it is backed up via Griffin using the same transfer from Cardinal to H.T.
Otherwise, the boundary condition in H.T. would be re-set per Picard iteration. The fluid temperature is transferred from Cardinal to H.T. in the same manner as the transfer from H.T. to Griffin.

### Doppler and Coolant Density Reactivity Feedbacks style=font-size:125%

For the Doppler feedback, 9-group cross sections of each material are tabulated at two to three temperatures and linearly interpolated at the target temperature of each spatial quadrature point in an element.
The detailed cross section generation procedure can be found in the [LFR Single Assembly Model](lfr/heterogeneous_single_assembly_3D/Griffin_standalone_LFR.md).
For the coolant density feedback, the +AuxVariable+ for the temperature dependent fluid density in [setup] is evaluated using the +ParsedAux AuxKernel+ that uses the coupled variable for the coolant temperature in its expression. This fluid density +AuxVariable+ is coupled to
+MultigroupTransportMaterial+ of Griffin for adjusting atomic density of the coolant material at each quadrature point in an element.

### Convergence tolerance style=font-size:125%

For the scheme (B) in [its], there are two convergence control parameters: the tolerances on the Richardson and Picard iterations.
The Richardson iteration exits once $\lVert \Psi^{(l)} - \Psi^{(l-1)} \rVert _2$ drops down below $\lVert \Psi^{(1)} - \Psi^{(0)} \rVert _2 \times 0.001$ (+richardson_rel_tol = 1E-3+) where $\Psi^{(l)}$ is the neutron angular flux field at $l^{th}$ Richardson iteration. $10^{-3}$ is a loose criterion but sufficient because the root-mean-square value of power distribution errors drops down below 0.01% at the relative Richardson error of $10^{-3}$ in a non-coupled calculation.
To exit the Picard iteration (end the whole simulation), the tolerance
on the relative difference of the L2-norm of temperature field values computed by H.T. between successive Picard iterations was set as $10^{-5}$.

### Computational strategy style=font-size:125%

The calculation procedure consists of two steps focused first on generating good initial conditions and then performing the full multiphysics run.
First, a NekRS standalone calculation was performed to provide reasonable initial temperature, velocity, and pressure conditions. For this calculation, a crude heat flux distribution was obtained from Griffin where the inlet temperature
condition was assigned uniformly to all regions. The dimensionless NekRS time step size of $10^{-3}$ (0.09106 ms, after dimensionalization) was used to keep the Courant number less than 0.3. The simulation was run for 9.106 s, which is 75% of the time required for the flow to pass through from inlet to outlet.

As the flow is developed, the fully coupled simulation can freeze the velocity to speed up the development of the temperature. During the coupled simulation, the dimensionless NekRS time step size was increased by +10x+ (0.9106 ms) since the velocity was frozen.
The H.T. solve was called every 50 NekRS time steps. Insufficiently frequent calls of H.T. cause instability in the solution (discussed in Results section). One hundred time steps were taken in H.T. per Picard iteration, so Griffin was called every 4.553 s, leading to the 5000:100:1 ratio of the number of NekRS, H.T., and Griffin
calculations.

## Griffin Input Model

This section decribes the input file for Griffin using the DFEM-$S_N$ solver with the CMFD acceleration.

### Input parameters style=font-size:125%

Defining input parameters in advance is beneficial to make the input tractable because the same value can be used in multiple places. Block IDs and material IDs to be assigned to block IDs and the total power are defined as input parameters to be used in the main input later.

!listing lfr/7pin_cardinal_demo/NT.i start=activefuelheight end=richardsonmaxits include-end=True

### Meshes for Griffin, heat transfer and Cardinal solvers style=font-size:125% id=mesh

The Griffin and H.T. meshes were generated with the MOOSE Reactor module [!citep](MOOSEReactorModule) which allows for mesh perturbation using the MOOSE Stochastic Tools in the future.
The Cardinal mesh is the mirror mesh of the NekRS native mesh and is built by Cardinal automatically by looping through the CFD mesh and copying elements into a lower-order representation.
Attention was paid to keeping the azimuthal division in the Griffin and H.T. meshes similar to that in the Cardinal mesh for better alignment of nodes on the cladding outer surfaces and duct inner surfaces among the different meshes.
Each duct side was divided into 18 segments in all meshes. H.T. has a finer mesh radially and axially than Griffin: 23 vs. 6 in a fuel rod, 10 vs. 2 in a duct, and 16 vs. 4 in a coolant in the radial direction and 48 vs. 24 in the axial direction.
In H.T., fine meshes in the fuel rod and the duct are needed for accurate
temperature and heat flux calculations. The finer meshes in the coolant region are used for better convergence metric of the coolant temperature, and those in the axial direction are used for better +NearestNode+ data transfer of heat flux and surface temperature between H.T. and Cardinal.
The Cardinal (NekRS) axial mesh is finer in the inlet region to accurately compute the entrance effect.
The overall mesh configurations for each individual physics solver can be found in [meshes].

!media lfr/cardinal_7pin/mesh.png
       style=width:100%
       id=meshes
       caption=Radial (top) and axial (bottom) meshes of Griffin, H.T., and Cardinal.

In the Griffin input file, we can load the mesh files produced by MOOSE Reactor module as follows

!listing lfr/7pin_cardinal_demo/NT.i block=Mesh

Please note that the Griffin mesh provided is already in Exodus format, created using the MOOSE mesh module and the input file +NTmesh.i+. Users can generate this mesh using +NTmesh.i+ with +griffin-opt+ or any other MOOSE application including the Reactor module:

```language=bash
griffin-opt -i NTmesh.i --mesh-only
```

The heat transfer mesh can be generated in the similar way using the input file +HCmesh.i+ provided.

```language=bash
griffin-opt -i HCmesh.i --mesh-only
```

### Executioner style=font-size:125%

The `SweepUpdate` executioner is used for the CMFD acceleration. `SweepUpdate` is a special Richardson executioner for performing source iteration with a transport sweeper. This source iteration can be accelerated by turning on `cmfd_acceleration` which invokes the CMFD solve where the low order diffusion equation is solved with a convection closure term to make the diffusion system and the transport system consistent.
`richardson_rel_tol` or `richardson_abs_tol` is the tolerance used to check the convergence of the Richardson iteration. `richardson_max_its` is the maximum number of iterations allowed for Richardson iterations. These parameters are controlled by the corresponding variables given in +Input parameters+.
If `richardson_postprocessor` is specified, its `PostProcessor` value is used as the convergence metric. Otherwise Griffin uses the L2 norm difference of the angular flux solution between successive Richardson iterations, which is added to `richardson_postprocessor` with the name of `flux_error` internally. `richardson_rel_tol` is the tolerance for the ratio of the `richardson_postprocessor` value of the current iteration to that of the first iteration.
`richardson_value` is for the console output purpose to show the history of `PostProcessor` values over Richardson iterations, and it is set to be `eigenvalue`.
`inner_solve_type` is about the way to perform the inner solve of the Richardson iteration. There are three options: `none`, `SI` and `GMRes`. `none` is just a direct transport operator inversion per residual evaluation, while scattering source is updated together for `SI` and `GMRes` per residual evaluation. The latter two options involve more number of transport sweeps per residual evaluation than `none`, leading to the reduction of the number of residual evaluations and possibly the total run time. For `GMRes`, the scattering source effect is accounted for at once by performing the GMRes iterations and `max_inner_its` is the maximum number of GMRes iterations. For `SI`, the scattering source effect is accounted for by performing source iterations and `max_inner_its` is the maximum number of source iterations.

`fixed_point_solve_outer` is configured to allow Griffin to invoke the Picard iteration between Griffin and its sub-app (H.T. and nekRS) calculations outside the Richardson iteration. This approach has been demonstrated to be more computationally efficient for weakly coupled problems in the multiphysics hierarchy. The convergence criterion is based on the temperature field with a relative tolerance `custom_rel_tol` of +1e-5+.

`coarse_element_id` is the name of the extra element integer ID assigned in the mesh file.
If the CMFD solve does not converge, one can try different options for `diffusion_eigen_solver_type` which is the eigenvalue solver for CMFD. There are four options: `power`, `arnoldi`, `krylovshur` and `newton`. `newton` is the default which is recommended to stick with. If `newton` does not converge a solution, either `krylovshur` is the second option to go with, or `cmfd_prec_type` can be changed to `lu` from its default value of `boomeramg` for a small problem. Also one can try `cmfd_closure_type=syw` or `cmfd_closure_type=pcmfd` as different ways, but it is recommended to stick with its default value of `traditional_cmfd`.

!listing lfr/7pin_cardinal_demo/NT.i start=[Executioner] end=[] include-end=True

### Power Density style=font-size:125%

Within this segment, the variable `power` represents the total power specified by the user, and `power_density_variable` is a mandatory `AuxVariable` name for power density. The evaluation of power density is conducted using the normalized neutronics solution.

!listing lfr/7pin_cardinal_demo/NT.i start=[PowerDensity] end=[] include-end=True

### Transport systems style=font-size:125%

For the transport system, `particle` is `neutron` and `equation_type` is `eigenvalue`. The number of energy groups is 9 given by `G` and `VacuumBoundary` and `ReflectingBoundary` are sideset names: top and bottom surfaces are vacuum and lateral surfaces are reflective.
In the sub-block of `[sn]`, the DFEM-SN scheme is specified. Between `monomial` and `L2-Lagrange` families of basis functions supported for discontinuous elements, the `monomial` type is selected with the first order.
The angular quadrature type (`AQtype`) is set to `Gauss-Chebyshev` for having a freedom to choose a different number of angles in the azimuthal direction and in the polar direction in 3D. The number of azimuthal angles (`NAzmthl`) and that of polar angles (`NPolar`) per octant are set to $3$ and $2$, respectively, from a sensitivity study. The anisotropic scattering order (`NA`) is set to 1. `using_array_variable=true` and `collapse_scattering=true` are recommended options for performance reason in general.

!listing lfr/7pin_cardinal_demo/NT.i start=[TransportSystems] end=[] include-end=True

### AuxVariables style=font-size:125%

The AuxVariables block is specified next. Through the Auxiliary Variables, developers can define external variables that are solved or used in the Griffin simulation. Specifically,  the additional variables defined include the solid temperature `solid_temp`, the fluid density `fluid_density`, the solid-fluid surface temperature `nek_surf_temp`, and the fluid bulk temperature `nek_bulk_temp` sourced from nekRS.

!listing lfr/7pin_cardinal_demo/NT.i start=[AuxVariables] end=[AuxKernels] include-end=False

### AuxKernels style=font-size:125%

The AuxKernels is set up to update the fluid density based on the fluid temperature obtained from NekRS.

!listing lfr/7pin_cardinal_demo/NT.i start=[AuxKernels] end=[GlobalParams] include-end=False

### GlobalParams style=font-size:125%

In `[GlobalParams]`, `is_meter=true` is to indicate that the mesh is in a unit of meter and `plus=true` to indicate that absorption, fission, and kappa fission cross sections are to be evaluated.

!listing lfr/7pin_cardinal_demo/NT.i start=[GlobalParams] end=[Compositions] include-end=False

### Compositions style=font-size:125%

The `[Compositions]` block is employed to define the compositions of the six materials considered in the Griffin model. `composition_ids` serves as `material_id` that has been already assigned in the mesh generation stage.

!listing lfr/7pin_cardinal_demo/NT.i start=[Compositions] end=[Materials] include-end=False

### Materials style=font-size:125% id=materials

The `[Materials]` block is constructed using `MicroNeutronicsMaterial`. This neutronics material loads a multigroup library with tabulated microscopic group cross sections of isotopes in ISOXML format. It evaluates macroscopic group cross sections with multiple material IDs based on the inputted isotope densities.
The main reason for using this material instead of `MixedNeutronicsMaterial` is that each library (library ID) in the library file is not generated for each material (material ID) in the Griffin transport calculation. Using `MicroNeutronicsMaterial`, different material IDs can be freely generated in the same library ID.

Library ID refers to the value of the attribute named `ID` of the `Multigroup_Cross_Section_Library` element in the isoxml file. One should make sure that isotope names in the composition of a `material_id` covered by each `MicroNeutronicsMaterial` exist under the `Multigroup_Cross_Section_Library` with the ID specified by `library_id` in the isoxml file. `grid_variables` is the coupled variable used for temperature interpolation of cross sections for the Doppler feedback. For the coolant density feedback, a domain is recognized as fluid by `fluid_density` and `reference_fluid_density` input parameters and the macroscopic cross section of the region is scaled by the ratio of the value of the coupled variable `fluid_density` to the reference density per element quadrature. One caveat is that `library_file` and `library_name` common for all `MicroNeutronicsMaterial`s should not be taken out to `[GlobalParams]` because the `[MultiApps]` block has the same input parameters meant for the dynamic library of sub-applications.

!listing lfr/7pin_cardinal_demo/NT.i start=[Materials] end=[MultiApps] include-end=False

### MultiApps and Transfers style=font-size:125%

`[MultiApps]` specifies how the Griffin model interacts with its sub-app +HC.i+, which is a MOOSE heat transfer model. Meanwhile, `[Transfers]` defines how the data is exchanged between Griffin model +NT.i+ and the sub-app +HC.i+ as illustrated in [transfer].

!listing lfr/7pin_cardinal_demo/NT.i start=[MultiApps] end=[UserObjects] include-end=False

### UserObjects and Postprocessors style=font-size:125%

Both `[Postprocessors]` and `[VectorPostprocessors]` can be used to compute quantities of interest from the solution to be included in output or used by other MOOSE applications. With `[UserObjects]`, the users can extract the layer averaged quantities of interested, such as the power density, solid temperature, etc.

!listing lfr/7pin_cardinal_demo/NT.i start=[UserObjects] end=[Outputs] include-end=False

### Outputs style=font-size:125%

Finally, the `[Outputs]` block sets the output files from the simulation. Two of the most common options include the exodus and csv file. The Exodus file can be viewed with the same software as the mesh, but now will show the solution and solution derived quantities such as the multi-group scalar flux and power distribution. The csv file stores a summary of the solution. Both are turned on for the Griffin model. The +perf_graph+ parameter is helpful to evaluate the computational run time.

!listing lfr/7pin_cardinal_demo/NT.i block=Outputs

## MOOSE heat transfer Input Model

The solid temperature is solved by the MOOSE heat transfer module here. We define a number of constants at the beginning of the file and set up the mesh from a file.

!listing lfr/7pin_cardinal_demo/HC.i start=half_pinpitch end=[Executioner] include-end=False

The main field to be solved for in the heat transfer model is temperature, which is defined in the `[Variables]`.
The governing equations and boundary conditions are specified accordingly in `[Kernels]` and `[BCs]`.

!listing lfr/7pin_cardinal_demo/HC.i start=[Variables] end=[Materials] include-end=False

The MOOSE heat transfer module will receive power from Griffin in the form of an AuxVariable, so we define a receiver variable for the fission power, as +heat_source+. The MOOSE heat transfer module will also receive a fluid wall temperature from Cardinal as another AuxVariable which we name +nek_surf_temp+. The fluid bulk temperature is also passed from Cardinal to HC for convergence check. Finally, the MOOSE heat transfer module will send the heat flux to Cardinal, so we add a variable named +heat_flux+ that we will use to compute the heat flux using the DiffusionFluxAux auxiliary kernel.

!listing lfr/7pin_cardinal_demo/HC.i block=AuxVariables

!listing lfr/7pin_cardinal_demo/HC.i block=AuxKernels

The coupling and data transfer are handled by blocks `[MultiApps]` and `[Transfers]`. The input file structures are very similar to those described in Griffin input model above, with the main difference is that MOOSE heat transfer Module now uses nekRS as the sub-app. Similarly, `[Postprocessors]` and `[VectorPostprocessors]` are employed to compute additional quantities of interest for solution monitoring and visualization.
Finally, we specify a Transient executioner. Because there are no time-dependent kernels in this input file, this is equivalent in practice to using a +Steady+ executioner.

!listing lfr/7pin_cardinal_demo/HC.i block=Executioner

## Cardinal Input Model

The coolant/fluid region is solved using Cardinal, which internally utilizes nekRS for the solution. The integration of nekRS as a MOOSE application is defined in the +nek.i+ file. In contrast to the comprehensive solid input files, the fluid input file is relatively minimal, as most of the nekRS problem setup is outlined in the nekRS input files needed for standalone application execution.

The `[Problem]` block describes all objects necessary for the actual physics solve; for the solid input file, the default of +FEProblem+ was implicitly assumed. However, to replace MOOSE finite element calculations with nekRS spectral element calculations, a Cardinal-specific +NekRSProblem+ class is used.
The nekRS computations were executed in a dimensionless manner, and a set of reference/characteristic scales is provided  in `[Problem]` for dimensional conversion. The variable +casename+ instructs Cardinal regarding the case setup files required by nekRS for conducting CFD simulations, such as +casename.udf+, +casename.usr+, and so on.
In this block, we also specify which transfers we want for NekRS, to send data between NekRS and MOOSE. The wall boundary heat flux will be sent into NekRS, while the temperature field will be extracted from NekRS. We specify `usrwrk_slot = 0` for the incoming heat flux, which means that it will be accessed on the device as `bc->usrwrk[bc->idM + 0 * bc->fieldOffset]`.

The class +NekRSMesh+, specific to Cardinal, is employed to generate a "mirror" of the surfaces within the nekRS mesh. This mirror is utilized for coupling boundary conditions. The +boundary+ parameter is employed to define all the boundary IDs, enabling conjugate heat transfer coupling between nekRS and the MOOSE heat transfer module. To revert to dimensional units, the entire mesh must be scaled by a factor of $L_{ref}$.

!listing lfr/7pin_cardinal_demo/nek.i start=[Problem] end=[Executioner] include-end=False

Following that, a +Transient+ executioner is defined. This executioner remains consistent with the one employed in the solid case, with the distinction that it now incorporates a Cardinal-specific time stepper called +NekTimeStepper+. This time stepper is designed to retrieve the time step from nekRS's .par file (to be introduced soon) and convert it to dimensional form if necessary. The specified output format is Exodus II. It is noteworthy that the output file captures only temperature and heat flux solutions on the surface mirror mesh. The overall solution across the entire nekRS domain is output in the conventional .fld field file format used in standalone nekRS calculations.

!listing lfr/7pin_cardinal_demo/nek.i block=Executioner

!listing lfr/7pin_cardinal_demo/nek.i block=Outputs

Similar to its application in the Griffin and heat transfer input files, the `[Postprocessors]` block in Cardinal serves to monitor crucial quantities of interest. These include the average temperature and heat fluxes on boundary faces, as well as the minimum and maximum temperatures. It is important to emphasize that specifying +field = unity+ is the same as calculating the area in the context of +NekSideIntegral+, equivalent to determining volume in the case of +NekVolumeIntegral+, and corresponds to computing the mass flow rate for +NekMassFluxWeightedSideIntegral+.

!listing lfr/7pin_cardinal_demo/nek.i block=Postprocessors

Note that +nek.i+ input file here only describes how nekRS is wrapped within the MOOSE framework; with the +7pin.re2+ mesh file, each nekRS simulation requires at least three additional files, that share the same case name +7pin+ but with different extensions. The additional nekRS files are:

- `7pin.par`: High-level settings for the solver, boundary
  condition mappings to sidesets, and the equations to solve.
- `7pin.udf`: User-defined C++ functions for on-line postprocessing and model setup
- `7pin.oudf`: User-defined [!ac](OCCA) kernels for boundary conditions and
  source terms

A detailed description of all of the available parameters, settings, and use cases
for these input files is available on the
[nekRS documentation website](https://nekrsdoc.readthedocs.io/en/latest/input_files.html).
The configuration file, +7pin.par+, contains several sections specifying settings for different aspects of simulations.
In the `[OCCA]` section, the backend OCCA device settings are defined, currently set to use CPU for nekRS simulations.
The `[GENERAL]` block outlines parameters such as time stepping, simulation end control, and polynomial order. Specifically, it sets a time step of 0.01 (non-dimensional) and specifies that a nekRS output file is written every 5000 time steps. However, the stopAt and numSteps fields are ignored because nekRS is run as a sub-application to MOOSE. Instead, the simulation termination is dictated by the steady state tolerance in the MOOSE main application.
Sections like `[VELOCITY]` and `[PRESSURE]` describe the solution methodologies for the pressure Poisson equation and velocity Helmholtz equations respectively. It is worth noting that the velocity field is not solved, as indicated by the setting `nrs->flow = 0` in the +7pin.udf+ file.
The `[TEMPERATURE]` block describes the solution of the temperature passive scalar equation. Parameters like rhoCp are set to unity due to the non-dimensional form of the solve, while conductivity is defined as the inverse of the Peclet number.
The +boundaryTypeMap+ is utilized to map boundary IDs to types of boundary conditions, enabling specification of boundary conditions for different parts of the simulation domain. And the specific boundary conditions involved here includes:

- `f`: user-defined flux
- `I`: insulated
- `t`: user-defined temperature

!listing lfr/7pin_cardinal_demo/7pin.par

!listing lfr/7pin_cardinal_demo/7pin.udf

The +usr+ file is a legacy from Nek5000 code, and we still use to specify the boundary conditons together with the par file in NekRS calculations. The geometry is rescaled by 1.0807535 so the characteristic length scale is 1.0. In addition, +usr+ file also calls user subroutines from file +utilities.usr+ for the purpose of solution monitoring.

!listing lfr/7pin_cardinal_demo/7pin.usr  start=subroutine usrdat2 end=subroutine usrdat3 include-end=False

The +oudf+ file contains the additional setup for the required boundary conditions. Note that we have `bc->flux = bc->usrwrk[bc->idM]` in `scalarNeumannConditions` block. This line allows NekRS to use the heat flux provided by the MOOSE heat transfer module at the surfaces of fuel rods and duct wall.

!listing lfr/7pin_cardinal_demo/7pin.oudf

## Results id=results

Energy conservation was checked to verify results of the coupled application. A mesh sensitivity
study on energy conservation with water and lead coolants was performed, but only the conclusion
is briefly introduced. The convergence history and other observations are also discussed.

### Energy conservation style=font-size:125%

As a basic verification step, the energy conservation was checked.
The coolant temperature rise should be consistent with the total power calculated by Griffin in the solid domain since the volumetric heat source in the coolant region is ignored.
[energy1] shows the comparison of the calculation value from a +Postprocessor+ in Cardinal to the reference value predicted by the energy equation. They agree very well within 0.01%, which means that the heating data is properly transferred and processed from Griffin to NekRS.
[energy2] supports the excellent agreement, in that the total heat flux integral on each of fuel rod outer surfaces and duct inner surface matches very well with the power in each region predicted by Griffin. This excellent agreement was achieved with the use of a very refined mesh and a zero-power entrance region for the fluid.

!table id=energy1 caption=Energy conservation result compared to bulk energy conservation.
| Total power in solid region | $\langle \dot{m} \rangle _{outlet}$  | $C_p$  | Reference $T_{rise}$* | Calculated $T_{rise}$*  | Rel. error  |
| :- | :- | :- | :- | :- | :- |
| 29.1049 $kW$ | 0.68091 $kg/s$ | 144.19 $J/kg/K$  | 296.44 $K$ | 296.40 $K$ | -0.01%  |

*The temperature rise $T_{rise} = (\langle \dot{m}T \rangle _{outlet} - \langle \dot{m}T \rangle _{inlet})/ \langle \dot{m} \rangle _{outlet}$

!table id=energy2 caption=Comparison of +Postprocessor+ values for power in Griffin and for heat flux integral in Cardinal.
| - | Fuel rods  | -  | = | Duct  | =  |
| :- | :- | :- | :- | :- | :- |
| Griffin | Cardinal | Rel. error  | Griffin | Cardinal | Rel. error  |
| 28.7757 $kW$ | 28.7757 $kW$ | 0.0001%  | 329.2 $W$ | 329.8 $W$ | 0.2%  |

### Conservation history style=font-size:125%

[convergence] illustrates the simulation history.
The NekRS standalone calculation to generate initial conditions occupies the first 9.016 seconds. Once the fully coupled calculation is initiated, the CMFD + DFEM-$S_N$ calculations continued until the relative Richardson error hit the tolerance of $10^{-3}$.
Then, H.T. + NekRS calculations were performed until the end time of H.T. was met. The L2-norm of the coolant temperature field was first calculated then, and the next set of CMFD + DFEM-$S_N$ calculations were performed, which dropped the relative Richardson errors down to $10^{-5}$.
After the next cycle of H.T. + NekRS calculations, the L2-norm of the coolant temperature field was updated and its relative difference to its previous value was computed. This process was repeated until the relative change of the L2-norm of the coolant temperature field dropped below $10^{-5}$.
Even though the relative Richardson error in Griffin jumped at each subsequent Picard iteration, the overall error as well as the eigenvalue difference decreased with increasing number of Picard iterations.

!media lfr/cardinal_7pin/convergence.png
       style=width:100%
       id=convergence
       caption=Convergence history of the whole simulation ($l_R$ - Richardson iteration index, $l_P$ - Picard iteration index.)

Scheme (A) in [its] resulted in false temperature convergence unless the Richardson tolerance was very carefully controlled. This false convergence arises due to the weak coupling nature of temperature and angular flux in this problem, where monitoring the angular flux convergence is not a good proxy for temperature convergence.
[power] shows that the power distribution is almost converged with less than 1% error in only one Picard iteration, despite the temperature not being converged. Although not shown, errors in power distribution kept decreasing after the first Picard iteration. This confirms that neutronics is weakly coupled to temperature in this problem, and that neutronics power distributions from early in the simulation will result in an accurate temperature profile.

!media lfr/cardinal_7pin/power.png
       style=width:80%
       id=power
       caption=Fast convergence of power distribution due to weak coupling.

One noteworthy observation was that infrequent data communication between H.T. and NekRS may result in solution oscillations.
[bugs] shows that when H.T. is called 10 times less frequently (500:1 rather than 50:1 NekRS:H.T.), a large unphysical fluctuation appears in the solution.
Although only the duct heat flux is shown, other solutions also deviate from expected results.
This observation is consistent with the fact that the operator splitting method is first order accurate in time, and such an observation would occur with other codes selected for the fluid solve and the solid solve (i.e this effect is not specific to Cardinal or MOOSE).

!media lfr/cardinal_7pin/bugs.png
       style=width:80%
       id=bugs
       caption=Unphysical pattern of solution (duct heat flux) caused by the infrequent data communication in the conjugate heat transfer with the operator splitting method.

### Verification of radial temperature profile and axial speed style=font-size:125%

The radial temperature profile was verified against an independent STAR-CCM+ calculation.
The 7-pin example has a smaller rod-duct gap rod-rod gap. This leads to very low axial speed in the corners of the duct as opposed to the space between the interior fuel rods, as shown in [comparison]a.
The slow coolant velocity results in hotter temperature near the corner as opposed to the bundle center (an atypical temperature distribution for fast reactor bundles).
An independent STARCCM+ calculation shown in [comparison]b confirmed the atypical temperature profile seen in [comparison]c.
As an experiment, forcing a radially uniform axial speed resulted in the more conventionally expected temperature distribution with hotter inner zone coolant as seen in [comparison]d.

!media lfr/cardinal_7pin/comparison.png
       style=width:100%
       id=comparison
       caption=Effect of the axial speed on radial temperature distribution.

## Summary and Future works

A multiphysics coupled code system with Griffin, MOOSE heat transfer, and NekRS (Cardinal), has been established using the MOOSE framework for the purpose of hot channel factor evaluation in LFR applications.
Griffin drives the coupled simulation using the multiphysics coupling scheme
of the DFEM-$S_N$/CMFD solver.
The Richardson iterations for the DFEM-$S_N$CMFD calculation are performed first, followed by the H.T. and NekRS coupled calculation that uses the operator
splitting method for the conjugate heat coupling, in the Picard iteration loop until the relative difference of the L2-norm of the coolant temperature field in successive Picard iterations drops down below $10^{-5}$.
Locating the Picard iteration loop outside the Richardson iteration loop needs to
be set in an input manually and is important to avoid false temperature convergence in weakly coupled problems.
Special care was taken to align the meshes of different physics solvers and use
the most appropriate MOOSE +Transfer+ to increase the accuracy of the data transfer.

The system has been verified for the simplified problem consisting of seven pins with a duct.
Global energy conservation was confirmed. The integral of heat fluxes on each solid-fluid interface matched the total power produced inside each solid volume, and the distribution was qualitatively correct.
Lessons learned are the need for more frequent data communication when the operator
splitting method is used, and the need to carefully check data interpolation between different meshes of different code systems.

Future works include the following.

- The 7-pin model will be extended to a whole assembly model.
- The MOOSE Stochastic Tools Module (STM) [!citep](Slaughter2023) will be employed to streamline HCF evaluation by sampling input parameters to be perturbed. To this objective, an effort is on-going to perturb native NekRS inputs from STM, use a MOOSE mesh generator to build NekRS mirror and native meshes, and enable multiple runs of NekRS in a single execution of the stochastic tool.

## Run Command


Execution of simulations for this Cardinal model may require HPC resources. Specifically, the simulations were conducted on the Idaho National Laboratory HPC cluster, Sawtooth, employing 144 processes. Details of the run script and the associated submission script are presented below.

!listing lfr/7pin_cardinal_demo/runjob_sawtooth.sh

```language=bash
qsub runjob_sawtooth.sh
```
