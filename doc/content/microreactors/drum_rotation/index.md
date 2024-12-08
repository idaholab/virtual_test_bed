# Micro Reactor Drum Rotation

*Contact: Zachary Prince, zachmprince\@gmail.com, Vincent Labour&#233;, vincent.laboure\@inl.gov*

*Model link: [Micro Reactor Drum Rotation Model](https://github.com/idaholab/virtual_test_bed/tree/main/microreactors/drum_rotation)*

!tag name=Micro Reactor Drum Rotation model
     description=This 2D model of an Empire-like reactor core studies the insertion then removal of reactivity from a control drum rotation
     image=https://mooseframework.inl.gov/virtual_test_bed/media/drum_rotation/empire_2d_CD_coarse_in.png
     pairs=reactor_type:microreactor
                       reactor:Empire
                       geometry:core
                       simulation_type:neutronics;multiphysics
                       input_features:reactor_meshing;multiapps;solution_vector_restart
                       transient:steady_state;reactivity_insertion
                       v&v:demonstration
                       codes_used:Griffin;MOOSE_HeatTransfer
                       computing_needs:Workstation
                       open_source:partial
                       fiscal_year:2024
                       sponsor:NEAMS
                       institution:INL

## Reactor Description

This reactor model is based on the prototypical micro reactor presented in [!cite](Terlizzi2023Asymptotic). The design is based on the Empire reactor [!citep](matthews2021coupled) with modifications made to ensure a negative overall temperature reactivity coefficient, necessary to simulate realistic transients. This 2 MWth core consists of 18 hexagonal assemblies arranged in two rings and surrounded by 12 control drums contained within a radial reflector. Each assembly is composed of 96 fuel pins, 60 moderator pins, and 61 heat pipes. Detailed dimensions and material composition can be found in [!cite](Terlizzi2023Asymptotic).

This model has been simplified to a 2D geometry that leverages symmetry to reduce the domain to a 1/12th of the full core. Furthermore, the heat pipes are simulated using a convective boundary conditions, as opposed to using Sockeye to calculate the actual heat removal. [!cite](Prince2023Neutron) presents the 3D version of this model.

The purpose of this exposition is to show how to perform a multiphysics transient simulation involving control drum rotation using Griffin. Initially, the drum is positioned halfway at 90 degrees. The drum is then rotated outward (inserting reactivity) at 20 degrees per second for two seconds, then rotated inward (removing reactivity) at 20 degrees per second for three seconds. Thus, the total transient duration is five seconds. Due to the symmetry imposed on the model, rotating this drum is equivalent to rotating all the drums in the core.

## Model Description

### Mesh

Two different meshes were created for this model: a fine-mesh representing the exact geometry and a coarse-mesh for CMFD.

#### Fine Mesh

The following creates a mesh of the entire core:

!listing microreactors/drum_rotation/empire_2d_CD_fine.i
  block=FUEL_pin MOD_pin HPIPE_pin AIRHOLE_CELL REFL_CELL Assembly_1 AIRHOLE REFL cd_0 Core
  caption=Mesh blocks for full-core fine mesh
  id=lst:fine_full_core

Then the mesh is "sliced" to produce a 1/12th geometry and scaled to meters:

!listing microreactors/drum_rotation/empire_2d_CD_fine.i
  block=half twelfth trim scale
  caption=Mesh blocks trimming full-core fine mesh to 1/12th geometry and scaling to meters
  id=lst:fine_trim

However, performing the transient with the mesh so far causes a significant cusping effect [!citep](Yamamoto2004Simple) in the calculated power and reactivity, even when using the cusping treatment described in [!cite](Schunert2019Control). Investigations indicate that the cusping effect is due to the discretization when the cross sections of the absorbing material and the non-absorbing material are significantly different. It is possible to mitigate the cusping effect by increasing the spatial expansion order in the drum region locally. However, for this model, the mesh in the drum region was refined such that drum's front would align with element edges at every time step. We plan on addressing this cusping issue in future work since this refinement limits the flexibility of time step sizes and unnecessarily increases the number of elements.

The mesh for the drum is created separately with the following input:

!listing microreactors/drum_rotation/drum.i
  caption=Input file generating fine-mesh for control drum
  id=lst:fine_drum

This drum mesh is then loaded in by the main mesh input, stitched into the previous control drum assembly, and inserted into current 1/12th model (replacing the previous assembly):

!listing microreactors/drum_rotation/empire_2d_CD_fine.i
  block=drum drum_insert drum_scale drum_rotate drum_move drum_blocks drum_boundary drum_remove stitch
  caption=Mesh blocks inserting pregenerated control drum in 1/12th fine mesh
  id=lst:fine_drum_insert

Finally, side sets are added to the mesh so that boundary conditions can be properly applied:

!listing microreactors/drum_rotation/empire_2d_CD_fine.i
  block=bottom_boundary topleft_boundary right_boundary
  caption=Adding boundaries to the fine mesh
  id=lst:fine_boundaries

The resulting mesh is shown in [!ref](fig:fine_mesh).

!media drum_rotation/empire_2d_CD_fine_in.png
  caption=Fine mesh used for control drum rotation transient
  id=fig:fine_mesh

A list of all the blocks is shown in [!ref](tab:blocks).

!table caption=Description of blocks in geometry id=tab:blocks
| Region | Block IDs |
| - | - |
| Fuel | 1 2 |
| Moderator | 3 4 5 |
| Heat Pipes | 6 7 |
| Monolith | 8 |
| Reflector | 10 11 14 15 |
| Control Drum | 13 |
| Air | 20 21 22 |

#### Coarse Mesh

The coarse mesh used for CMFD does not resolve pins, instead it creates quad4 meshes for each hexagonal assembly:

!listing microreactors/drum_rotation/empire_2d_CD_coarse.i
  block=F1_1 F1_2 Core_CM
  caption=Mesh blocks for full-core coarse mesh
  id=lst:coarse_full_core

Same as the fine mesh, this full core mesh is trimmed to a 1/12th geometry and scaled to meters:

!listing microreactors/drum_rotation/empire_2d_CD_coarse.i
  block=half_CM twelfth_CM trim_CM scale_CM
  caption=Mesh blocks trimming full-core coarse mesh to 1/12th geometry and scaling to meters
  id=lst:coarse_trim

The resulting coarse mesh is shown in [!ref](fig:coarse_mesh).

!media drum_rotation/empire_2d_CD_fine_in.png
  caption=Coarse mesh used for control drum rotation transient
  id=fig:coarse_mesh

### Materials

#### Cross Sections

Serpent (v. 2.1.32) was used to generate the multigroup cross sections for the SiMBA problem. The ENDF/B-VIII.0 continuous energy library was utilized to leverage the $YH_x$ scattering libraries, which was then converted into an 11-group structure to perform the calculations.
The cross sections were parametrized with respect to three variables: (1) fuel temperature; (2) moderator, monolith, heat pipe, and reflector temperature; and (3) control drum angle. The grid points selected can be seen in the multigroup cross-section library file:

!listing microreactors/drum_rotation/empire_core_modified_11G_CD.xml
  start=<Tabulation>
  end=<CD>
  include-end=True
  caption=Cross section tabulation grid
  id=lst:xs_grid

The cross sections are then loaded and applied to neutronics materials, namely `CoupledFeedbackNeutronicsMaterial`. Auxiliary variables are also added that represent the grid variables.

!listing microreactors/drum_rotation/neutronics_eigenvalue.i
  block=AuxVariables GlobalParams Materials
  caption=Neutronics materials
  id=lst:xs_mat

Note the exception for the material type in the drum region. Here, we use `CoupledFeedbackRoddedNeutronicsMaterial`, which is material specifically for dealing with control drum and rod movement. The position of the drum is controlled by the `front_position_function` parameter, which accepts the name of a MOOSE `Function` dependent on time. Typically, three functions are defined: (1) the offset between what the actual position and what the user defines as the position, (2) a user-defined position as a function of time, and (3) combining the offset and position. For the steady-state input, is function is constant:

!listing microreactors/drum_rotation/neutronics_eigenvalue.i
  block=Functions AuxKernels
  caption=Defining control drum position
  id=lst:drum_fun

It is often useful debug the offset by creating a simplified input that has drum position outputted to exodus. This can be done using the following debug option:

!listing microreactors/drum_rotation/neutronics_eigenvalue.i
  block=Debug
  caption=Debug option for outputting drum position
  id=lst:drum_debug

#### Thermal Properties

The following lists the thermal properties used for this model:

!table caption=Thermal properties id=tab:thermal_prop
| Region | Density (kg/m$^3$) | Conductivity (W/m-K) | Specific Heat Capacity (J/kg-K) |
| - | - | - | - |
| Fuel | 14,300 | 19 | 300 |
| Moderator | 4,300 | 20 | 300 |
| Monolith | 1,800 | 70 | 1,830 |
| Reflector | 1,853.76 | 200 | 1,825 |
| Absorber | 2,520 | 20 | 1,000 |

These properties are applied using `HeatConductionMaterial` and `Density`:

!listing microreactors/drum_rotation/thermal_ss.i
  block=Materials
  caption=Thermal materials
  id=lst:thermal_mat

Since the materials in the drum region change based on the position of the control drum, `GenericFunctionMaterial` is used to manually set these properties. Based on the position (provided by a post-processor values), these functions define whether a supplied (x,y) location is outside or inside the absorber region and output the appropriate property value:

!listing microreactors/drum_rotation/thermal_ss.i
  block=Functions
  caption=Functions for thermal properties in drum region
  id=lst:thermal_drum

### Physics

#### Neutronics Physics

For this model, DFEM-SN discretization is used for the neutronics. The angular quadrature uses Gauss-Chebyshev collocation with one polar angle and three azimuthal. There are six delayed neutron precursors (evident from multigroup cross-section library) and first-order scattering. The physics for the neutronics is setup using the `TransportSystems` syntax in Griffin:

!listing microreactors/drum_rotation/neutronics_eigenvalue.i
  block=TransportSystems
  caption=Defining the physics in the neutronics input
  id=lst:transport_systems

The initial power for this model is 2 MWth. Due to the 1/12th 2D geometry, this power equations to 83 kW/m in the simulation. The `PowerDensity` syntax in griffin adds an auxiliary variable for the computed power density field:

!listing microreactors/drum_rotation/neutronics_eigenvalue.i
  block=PowerDensity
  caption=Power density evaluation
  id=lst:power_density

#### Thermal Physics

The heat conduction problem is only solved on the solid portions of the domain, i.e. excluding heat pipes, air, and moderator gaps. As such the system variable is restricted to these blocks, which requires removing some default checks in the problem:

!listing microreactors/drum_rotation/thermal_ss.i
  block=Variables Problem
  caption=Block restricted variable in thermal input
  id=lst:thermal_vars

The volumetric kernels are quite simple, including heat conduction in the solid regions and a source applied in the fuel region from the power density:

!listing microreactors/drum_rotation/thermal_ss.i
  block=Kernels
  caption=Thermal input volumetric kernels
  id=lst:thermal_kernels

In order to capture the heat transfer into the heat pipes and between the moderator gaps, a few side sets are added to the mesh:

!listing microreactors/drum_rotation/thermal_ss.i
  block=Mesh
  caption=Side sets added to thermal mesh for boundary and gap heat transfer
  id=lst:thermal_mesh

The convective heat transfer into the heat pipes is applied as a boundary condition, while the moderator gaps use `GapHeatTransfer`:

!listing microreactors/drum_rotation/thermal_ss.i
  block=BCs AuxVariables ThermalContact
  caption=Side-set heat transfer
  id=lst:thermal_bcs

### Coupling

The coupling between the neutronics and thermal inputs utilize the `MultiApps` and `Transfers` systems. For this model, the neutronics serves as the main application. For steady-state, the thermal sub-application is defined as a `FullSolveMultiApp`:

!listing microreactors/drum_rotation/neutronics_eigenvalue.i
  block=MultiApps
  caption=Steady-state multiapp block
  id=ls:ss_multiapp


Power density and drum position are transferred to the sub-application and temperatures are retrieved. Power density simply uses a `MultiAppCopyTransfer`, which directly copies the degrees of freedom of the variable from the main application to the sub-application. The drum position is computed as a post-processor, where the data is transferred via `MultiAppReporterTransfer`. Since the cross sections are tabulated with separate temperatures for fuel and non-fuel. However, these variables must be defined everywhere in order to evaluate the cross sections. To do this, we use `MultiAppGeneralFieldNearestLocationTransfer` that is block restricted on the sub-application side. This transfer will then do a direct degree a freedom transfer for `Tfuel` in the fuel region and extrapolate from the nearest node in the non-fuel region. The same goes for `Tmod` in the non-fuel vs. fuel regions.

!listing microreactors/drum_rotation/neutronics_eigenvalue.i
  block=Transfers
  caption=Variable transfers
  id=lst:transfers

### Solvers

Griffin utilizes a customized executioner for DFEM-SN systems known as `SweepUpdate`. See this [Griffin tutorial](https://griffin-docs.hpc.inl.gov/latest/tutorials/C5G7_feedback.html) for more details on the methodology.

!listing microreactors/drum_rotation/neutronics_eigenvalue.i
  block=Mesh Executioner
  caption=Griffin executioner for steady-state DFEM-SN with CMFD
  id=lst:sweep_update

The thermal application simply uses the traditional `Steady` executioner, which specifies using AMG to speed up convergence.

!listing microreactors/drum_rotation/thermal_ss.i
  block=Executioner
  caption=Executioner for steady-state thermal problem
  id=lst:steady

### Transient

#### Initial Conditions

For this model, the initial condition comes from the steady-state solution. This solution is written to a file and loaded in the transient simulation using `SolutionVectorFile` and `TransportSolutionVectorFile`. The steady-state solution is written by adding the user-objects to the steady-state inputs, with the important parameter specification: `execute_on = FINAL`.

!listing microreactors/drum_rotation/neutronics_eigenvalue.i
  block=UserObjects
  caption=Writing steady-state neutronics solution to a file
  id=lst:neutronics_write

!listing microreactors/drum_rotation/thermal_ss.i
  block=UserObjects
  caption=Writing steady-state thermal solution to a file
  id=lst:thermal_write

The files are loaded with the same objects (must also be the same name) with parameters: `writing = false` and `execute_on = INITIAL`.

!listing microreactors/drum_rotation/neutronics_transient.i
  block=UserObjects
  caption=Loading steady-state neutronics solution from file
  id=lst:neutronics_load

!listing microreactors/drum_rotation/thermal_transient.i
  block=UserObjects
  caption=Loading steady-state thermal solution from file
  id=lst:thermal_load

#### Adjoint Problem

In order to compute point-kinetics parameters, like dynamic reactivity and mean generation time, Griffin requires the computation of an adjoint solution. This is done by running the adjoint version of the steady-state neutronics input. There adjoint input is basically the same as the forward input, with a couple key difference. First, the problem is de-coupled, so there are `MultiApps` or `Transfers` and the thermal solution is loaded from forward solution file. Second, `TransportSystems` must have the parameter `for_adjoint = true` set.

!listing microreactors/drum_rotation/neutronics_adjoint.i
  block=UserObjects TransportSystems
  caption=Neutronics adjoint problem
  id=lst:adjoint

#### Neutronics Transient

The transient input for neutronics is largely identical to the steady-state version. The following presents the key differences. First, `equation_type = transient` in the `TransportSystems` block must be set. Second, function describing the control drum position now depends on time. Third, the multi-app for the thermal sub-application is now a `TransientMultiApp`.

!listing microreactors/drum_rotation/neutronics_transient.i
  block=TransportSystems Functions MultiApps
  caption=Changes for neutronics transient input
  id=lst:neutronics_transient

Finally, the executioner is changed to `IQSSweepUpdate`, which utilized the improved quasi-static method (IQS). The algorithm this executioner implements is described in detail in [!cite](Prince2023Neutron). The `pke_param_csv = true` parameter triggers an output of point kinetics parameters and `output_micro_csv = true` outputs the detailed power profile of the transient.

!listing microreactors/drum_rotation/neutronics_transient.i
  block=Executioner
  caption=Neutronics solver using IQS
  id=lst:iqs

#### Thermal Transient

Again, the transient input of the thermal model is largely the same as the steady-state input. First, the time derivative is added to the volumetric kernels. Second, the executioner type is changed to `Transient`. Note that the time stepping scheme is not included in this input, since it will be defined by the main neutronics application.

!listing microreactors/drum_rotation/thermal_transient.i
  block=Kernels Executioner
  caption=Changes for thermal transient input
  id=lst:thermal_transient

### Running Model

This model can be run using a Griffin executable, or any application built with Griffin (BlueCRAB, Direwolf, etc.). The simulations scale decently well, so either a workstation or HPC can be used. The following presents the commands used to run the model and produce results. They must be executed in this order and with the same number of processors. Run times are presented at various processor counts, which were obtained by running the simulations on the INL Sawtooth cluster.

First is building the meshes, which must be run in this order, which produces `drum_in.e`, `empire_2d_CD_fine_in.e`, and `empire_2d_CD_coarse_in.e`:

!listing
griffin-opt -i drum.i --mesh-only
griffin-opt -i empire_2d_CD_fine.i --mesh-only
griffin-opt -i empire_2d_CD_coarse.i --mesh-only

Second is the coupled steady-state calculation, which produces `neutronics_eigenvalue_out.e` and `neutronics_eigenvalue_out_bison0.e`:

!listing
mpiexec -n <n> griffin-opt -i neutronics_eigenvalue.i

!table caption=Run times for steady-state simulation on various processors id=tab:rt_eigenvalue
| Processors (`<n>`) | Run-time (s) |
| - | - |
| 4 | 572 |
| 8 | 324 |
| 16 | 184 |
| 32 | 122 |
| 48 | 94 |

Third is the adjoint neutronics calculation:

!listing
mpiexec -n <n> griffin-opt -i neutronics_adjoint.i

!table caption=Run times for adjoint simulation on various processors id=tab:rt_adjoint
| Processors (`<n>`) | Run-time (s) |
| - | - |
| 4 | 96 |
| 8 | 57 |
| 16 | 34 |
| 32 | 22 |
| 48 | 17 |

Finally, the coupled transient can be run, which produces several output files which can be postprocessed:

- `neutronics_transient_out.e`: Contains neutronics-evaluated quantities like power density and scalar flux shape. Note that the scalar flux shape must be scaled by the power scaling factor and IQS amplitude to retrieve the actual flux.
- `neutronics_transient_out_bison0.e`: Contains thermal-evaluated quantities such as the temperature field.
- `neutronics_transient_out.csv`: Contains global neutronics-evaluated quantities, like power.
- `neutronics_transient_out_bison0.csv`: Contains global thermal-evaluated quantities, like average and max temperatures.
- `neutronics_transient_out_pke_params.csv`: Contains point-kinetics parameters, like reactivity.
- `neutronics_transient_out_micro_power.csv`: Contains the flux amplitude, which can be used obtain a detailed temporal profile of the power.

!listing
mpiexec -n <n> griffin-opt -i neutronics_transient.i

!table caption=Run times for adjoint simulation on various processors id=tab:rt_transient
| Processors (`<n>`) | Run-time (min) |
| - | - |
| 4 | 405 |
| 8 | 216 |
| 16 | 121 |
| 32 | 75 |
| 48 | 59 |

## Results

The initial temperature and power profile are shown in [!ref](fig:power_temperature). The full transient profile of power, average and maximum temperatures, and reactivity are shown in [!ref](fig:CD_time_shape). These plots show that during the first second, the transient is purely kinetics driven as reactivity from rotating the control drum is inserted into the core. Maximum power is reached around 1.25 seconds. The core temperatures rise significantly at this point, causing the power to drop due to the negative temperature feedback in the fuel, even while the drum is still rotating outward. The power drops exponentially as the drums are rotated back inward, causing the temperatures to flatten and eventually drop due to heat removal. The spatial profile of the power density and temperature during the transient are shown in [!ref](fig:CD_all).

!media drum_rotation/eigenvalue.png
  caption=Initial power and temperature profile
  id=fig:power_temperature

!media drum_rotation/transient.png
  caption=Values of selected quantities over simulated transient for control drum rotation.
  id=fig:CD_time_shape

!media drum_rotation/transient.mp4
  caption=Power density and temperature fields over transient
  id=fig:CD_all
