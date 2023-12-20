# HPMR-H$_2$ Reactor Model

*Contact: Stefano Terlizzi, stefano.terlizzi\@inl.gov, Vincent Labour&#233;, vincent.laboure\@inl.gov*

*Model link: [Direwolf Steady State Model](https://github.com/idaholab/virtual_test_bed/tree/devel/microreactors/hpmr_h2/steady)*

!tag name=HPMR_H2 Direwolf Steady State Model pairs=reactor_type:microreactor
                       reactor:HPMR_H2
                       geometry:core
                       simulation_type:core_multiphysics
                       input_features:multiapps
                       code_used:DireWolf
                       computing_needs:HPC
                       fiscal_year:2024

## Mesh

The reactor module in MOOSE [!citep](MOOSEReactorModule) was used to generate three different meshes for: (a) the Discontinuous Finite Element (DFEM) discrete ordinates (SN) neutronic solver shown in [hpmr_h2_mesh] (a), one for the Bison model, shown in [hpmr_h2_mesh] (b), and one for the Coarse Mesh Finite Difference (CMFD) acceleration mesh. displayed in [hpmr_h2_mesh] (c). A one-twelfth radially reflected geometry was built by exploiting the problem symmetry to minimize the number of degrees of freedom and increase the speed of calculations [!citep](Terlizzi2023).

!media hpmr_h2/hpmr_h2_mesh2.jpeg
    caption= (a) DFEM-SN mesh, (b) Bison mesh, and (c) CMFD mesh [!citep](Terlizzi2023).
    id=hpmr_h2_mesh
    style=width:60%; margin-left:auto; margin-right:auto



## Cross Sections

Serpent (v. 2.1.32) was used to generate the multigroup cross sections for the HPMR-H$_2$ problem. The ENDF/B-VIII.0 continuous energy library was utilized to leverage the $YH_x$ scattering libraries, which was then converted into an 11-group structure to perform the calculations. The conversion is performed via ISOXML (which is contained within Griffin) by reading the Serpent tallies and converting them into a multigroup XS library readable by Griffin. The group upper boundaries are reported in the [table-floating1].

!table id=table-floating1 caption=Energy group (upper) boundries for the 11-group structure used in the Griffin model [!citep](Terlizzi2023).
| Group | Energy (MeV) | Group | Energy (MeV) |
| ----- | ------------ | ----- | ------------ |
| 1     | 4.00E+01     | 7     | 9.88E-06     |
| 2     | 8.21E-01     | 8     | 4.00E-06     |
| 3     | 1.83E-01     | 9     | 1.00E-06     |
| 4     | 4.90E-02     | 10    | 3.20E-07     |
| 5     | 4.54E-04     | 11    | 6.70E-08     |
| 6     | 4.81E-05     |       |              |

The boundaries were set to capture the main resonances, and the thermal peak in the spectra is shown in [hpmr_h2_spectrum] [!citep](Terlizzi2023).

!media hpmr_h2/hpmr_h2_spectrum.jpeg
    caption= Spectrum per unit lethargy for the first ring of assemblies, second ring of assemblies, full reactor, and group boundaries (dotted vertical gray lines) [!citep](Terlizzi2023).
    id=hpmr_h2_spectrum
    style=width:80%;margin-left:auto; margin-right:auto

The cross sections were parametrized with respect to four variables: (1) fuel temperature, $T_f$; (2) moderator, monolith, and HP temperature, $T_m$; (3)
reflector temperature, $T_r$; and (4) the hydrogen-yttrium stoichiometric ratio, $c_H$. The choice of capturing the change in hydrogen content by
tabulating the cross sections based on the local value of the stoichiometric ratio was based on the analysis performed in [!citep](PhysorANL). The state
points at which the multigroup cross sections were computed are as follows in [table-floating2] [!citep](Terlizzi2023):

!table id=table-floating2 caption=State points at which the multigroup cross sections were computed [!citep](Terlizzi2023).
| Variable | 1   | 2    | 3    |
| -------- | --- | ---- | ---- |
| $T_f$, K | 800 | 1000 | 1200 |
| $T_m$, K | 800 | 1000 | 1200 |
| $T_r$, K | 800 | 1000 |  N/A |
| $c_H$    | 1.7 | 1.8  | 1.9  |

## Griffin Input for Neutronics

Griffin is the parent application for this simulation and is the input associated to the neutronic simulation. The Griffin model uses the discontinuous finite element method (DFEM-SN) accelerated through the coarse mesh finite difference (CMFD) acceleration to solve the multigroup neutron transport equation [!citep](Wang2021perimp). This is visible from the transport system block where the type of problem to be solved and the angular and energy approximation used are specified.

!listing microreactors/hpmr/steady/neutronics_eigenvalue.i block=TransportSystems language=cpp

The fixed point logics based upon the effective multiplication factor convergence within 1 pcm is enforced through "fixed_point_solve_outer = true" and the imposition of the multiplication factor as a custom postprocessor in the executioner block.

!listing microreactors/hpmr/steady/neutronics_eigenvalue.i block=Executioner language=cpp

The full input is reported below for the sake of completeness.

!listing microreactors/hpmr/steady/neutronics_eigenvalue.i language=cpp

## Bison Input for Heat Conduction and Hydrogen Redistribution

The Bison input is used to solve the heat conduction problem in the solid and the hydrogen redistribution in the moderator. The hydrogen redistribution problem is  modeled through the following equation for the hydrogen stoichiometric ratio, $c_H$ [!citep](Empire):

\begin{equation}
  \frac{\partial {c_H}}{\partial t} = \nabla \cdot [-D(\nabla {c_H} + \frac{Q {c_H}}{R T^2} \nabla T)],
\end{equation}

where D is the diffusion coefficient of hydrogen in $YH_x$, R is the gas constant, T is the temperature, and Q is the heat of transport . In the Bison input, the diffusion coefficient is set to one in order to accelerate the convergence for the steady-state calculations given than the asymptotic hydrogen distribution does not depend on the diffusion coefficient [!citep](Terlizzi2023). The Bison model is coupled to 101 heat pipes (HP) sub-applications that model the flow of sodium within the reactor. The 101 instances of HPs are generated in the correct position through the MultiApps system from the single heat pipe input described in the following section. The coupling between Bison and Sockeye is performed through convective boundary conditions.

The full input is reported below for the sake of completeness.

!listing microreactors/hpmr/steady/thermal_ss.i language=cpp

The Sockeye input contains the model for a single heat pipe. The latter uses the VOFM to model the 1D sodium flow within the core region of the HP and a 2D heat conduction model in the annulus and wick region.  The full input is reported below for the sake of completeness.

!listing microreactors/hpmr/steady/heatpipe_vapor_only.i language=cpp


## Multiphysics Coupling

[hpmr_h2_mpmap] shows the computational workflow for the coupled simulation. The left box includes the preliminary operations—namely, the mesh preparation and cross-section tabulations performed with Serpent (v. 2.1.32).

!media hpmr_h2/hpmr_h2_mpmap.jpeg
    caption= Integrated computational workflow [!citep](Terlizzi2023).
    id=hpmr_h2_mpmap
    style=width:80%; margin-left:auto; margin-right:auto

Griffin is run to simulate the neutron transport in the core. The power density, $P_d$, computed from the neutron flux, is then transferred to Bison that is utilized to solve for the temperature in the reflector, $T_r$, moderator, $T_m$, and fuel, $T_f$, and the hydrogen-yttrium stoichiometric ratio in the yttrium hydride, here denoted as $c_H$. Bison is coupled to 101 single heat pipes sub-applications that are used to compute the equivalent heat transfer coefficient, $h_{eq}$, and the secondary-side temperature, $T_{secondary}^i$, to obtain the thermal fluids' response. The updated temperature field and the hydrogen-yttrium stoichiometric ratio are then fed back into Griffin, where the macroscopic cross sections are updated based on the new operating conditions,


## Running the Model

To run the input on the INL HPC, an interactive node can be requested, e.g., using:

```language=CPP
qsub -I -l walltime=1:00:00  -l select=4:ncpus=48:mpiprocs=48 -P project
```

where 'project' should be replaced with the relevant project name (see [here](https://hpcweb.hpc.inl.gov/home/pbs) for a list of project names).

Then, load the following modules:

```language=CPP
module load use.moose moose-apps direwolf
```

Finally, to run the input, make sure you are in the correct directory, then use the run command below. The input being ran will be the neutronics file.

```language=CPP
mpirun -np 192 dire_wolf-opt -i neutronics_eigenvalue.i
```

With these commands, the run should take 20-25 minutes. The input can be also run with the BlueCRAB executable as long as it contains Sockeye using:

```language=CPP
mpirun -np 192 blue_crab-opt -i neutronics_eigenvalue.i
```


!bibtex bibliography
