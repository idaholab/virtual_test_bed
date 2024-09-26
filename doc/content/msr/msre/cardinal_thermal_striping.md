# Cardinal Model of Thermal Striping Phenomenon in MSR Piping System

*Contact: Jun Fang, fangj.at.anl.gov*

*Model link: [Thermal Striping Cardinal Model](https://github.com/idaholab/virtual_test_bed/tree/main/msr/msre/pipe_cardinal)*

!tag name=MSR Piping System Cardinal Model
     description=Cardinal multiphysics model of thermal striping phenomenon using nekRS and MOOSE Solid Mechanics Module
     image=https://github.com/idaholab/virtual_test_bed/tree/main/doc/content/media/msr/msre/pipe_cardinal/CFD_T.png
     pairs=reactor_type:MSR
                       reactor:MSRE
                       geometry:pipe
                       codes_used:Cardinal;NekRS;MOOSE_Solid_Mechanics
                       computing_needs:HPC
                       gpu_enabled:true
                       input_features:multiapps
                       simulation_type:CFD;multiphysics
                       fiscal_year:2024
                       sponsor:NEAMS
                       institution:ANL

## Model Overview

This tutorial documents a demonstration study recently conducted to showcase the advanced NEAMS multiphysics capabilities for modeling the thermal striping phenomenon commonly observed in reactor pipeline systems. The study employed the state-of-the-art multiphysics simulation framework, +Cardinal+.
A T-junction geometry was selected as the computational domain, featuring two inlets with different temperatures and one outlet. The interaction between the hot and cold inflows is expected to cause strong mixing within the T-junction, leading to temperature oscillations on the pipe walls.
The multiphysics coupling involves using +NekRS+ to perform high-fidelity conjugate heat transfer (CHT) calculations, predicting temperature distributions in both the solid (pipe wall) and fluid regions. These solid temperatures are then passed to the +MOOSE Solid Mechanics Module+ for thermal stress analysis.
In this document, we provide a step-by-step guide to setting up the related nekRS and Cardinal cases, along with a brief discussion of the results obtained.

## nekRS Case Setups

The T-junction model is illustrated in [tjunc_vel], where strong mixing is anticipated as the inflows from the horizontal and vertical inlets converge at the joint. We selected molten salt LiF-BeF2 as the fluid due to its critical role as a coolant salt in the Molten Salt Reactor Experiment (MSRE) [!citep](Beall1964). The horizontal inflow temperature is 900 K, while the vertical inflow temperature is 1000 K, with both inlets having a fixed velocity of 20 cm/s. The fluid properties, including density, viscosity, and thermal conductivity, are assumed to be constant, and their values are listed in [salt_properties] for the conjugate heat transfer (CHT) calculations. The pipe shell is assumed to consist of Hastelloy N alloy, with its thermo-physical properties detailed in [steel_properties] [!citep](Fang2020).

!media msr/msre/pipe_cardinal/CFD_U.png
       style=width:80%
       id=tjunc_vel
       caption=Velocity distribution inside the T-junction pipes.

!table id=salt_properties caption=Fluid properties of the molten salt.
| Parameters  | Value  | Unit  |
| :- | :- | :- |
| Density | 1682.32 | $kg/m^3$  |
| Dynamic viscosity | 6.04E-03 | $Pa\bullet s$ |
| Thermal conductivity | 1.1 | $W/(m\bullet K)$ |
| Specific heat capacity | 2390 | $J/(kg\bullet K)$ |
| Inlet velocity | 0.2 | $m/s$ |
| Reynolds number | 2785.12 | $-$ |
| Prandtl number | 13.12 | $-$ |
| Peclet number | 36552.23 | $-$ |

!table id=steel_properties caption=Solid properties of Hastelloy N alloy.
| Parameters  | Value  | Unit  |
| :- | :- | :- |
| Density | 8860 | $kg/m^3$  |
| Thermal conductivity | 23.6 | $W/(m\bullet K)$ |
| Specific heat capacity | 578 | $J/(kg\bullet K)$ |
| Young's modulus | 171 | $GPa$ |
| Poisson's ratio | 0.31 | $-$ |
| Thermal expansion coefficient | 1.38E-05 | $1/K$ |

The discretization of the CFD model results in 365,568 mesh elements in the fluid region and 129,024 elements in the solid region. The fluid and solid regions share a conformal mesh at the coupling interface. Given the moderate Reynolds number of 2785.12 expected in the T-junction, the Large Eddy Simulation (LES) approach is employed in the NekRS spectral element simulations [!citep](NekRS). With a polynomial order of 5, the total degrees of freedom are approximately 62 million. The CFD results of the temperature distributions are presented in [tjunc_temp]. Due to the hot inflow, the shell of the vertical pipe heats up, particularly in the region near the vertical entrance. In the horizontal section, the cold molten salt dominates from the horizontal entrance to the joint, with strong temperature mixing observed downstream of the joint. The T-junction configuration causes the upper side of the pipe shell to experience consistently higher temperatures than the bottom side.

!media msr/msre/pipe_cardinal/CFD_T.png
       style=width:80%
       id=tjunc_temp
       caption=Velocity distribution inside the T-junction pipes.


### nekRS case files style=font-size:125%

Readers can access the nekRS case files and the corresponding mesh files in the VTB repository via GitHub Large File Storage (LFS). The mesh data is contained in two files: `tjunc.re2` (which includes grid coordinates and sideset ids) and `tjunc.co2` (containing mesh cell connectivity information).
Regarding the nekRS case files, there are four basic files:

- `tjunc.udf` serves as the primary nekRS kernel file and encompasses algorithms executed on the hosts (i.e., CPUs). It's responsible for configuring CFD models when needed, collecting time-averaged statistics, and determining the frequency of calls to `userchk`, which is defined in the +usr+ file.
- `tjunc.oudf` is a supplementary file housing kernel functions for devices (i.e., GPUs) and also plays an important role in specifying boundary conditions.
- `tjunc.usr` is a legacy file inherited from Nek5000 and can be utilized to set up boundary condition tag, specify initial conditions, and define post-processing capabilities.
- `tjunc.par`  is employed to input simulation parameters, including material properties, time step size, and Reynolds number, etc.

Now let's first explore the case file `tjunc.usr`. The sideset ids contained in the mesh file are  translated into nekRS boundary condition tags in +usrdat2+ block.
There are two inlets (boundary 1 - vertical, and boundary 2 - horizontal) and one outlet (boundary 3) for the fluid region, while the solid region, namely, the T-junction wall has two surfaces, an inner surface (no boundary ID required) in contact with the flowing molten salt and an outer surface (boundary 4), which is assumed to be adiabatic in this study.

!listing msr/msre/pipe_cardinal/tjunc.usr start=subroutine usrdat2 end=subroutine usrdat3 include-end=False

Next, let's examine the case file `tjunc.udf`. The `userq()` function is used to specify the heat source term for temperature calculations or any source terms for the transport equations of passive scalars. In this study, no volumetric heat source is considered for either the fluid or salt regions, so the corresponding source terms are set to zero.

!listing msr/msre/pipe_cardinal/tjunc.udf start=void userq end=void uservp include-end=False

The `uservp()` function defines the material properties for both the fluid and solid regions in conjugate heat transfer simulations. These properties are non-dimensionalized according to nekRS simulation conventions. Consequently, a dimensional conversion is required to transform the raw nekRS results back into dimensional quantities. This conversion is handled automatically by Cardinal, with users simply needing to provide the reference quantities in the input file `nek.i`, which will be discussed in the next section.

!listing msr/msre/pipe_cardinal/tjunc.udf start=void uservp end=void UDF_LoadKernels include-end=False

Given the moderate Reynolds number expected in the T-junction pipe, a LES simulation approach is adopted which can be readily configured in the simulation input file `tjunc.par` using the code snippet below. For more information on Nek5000/nekRS LES filtering, interested readers are referred to [Nek5000 tutorial](https://nek5000.github.io/NekDoc/problem_setup/filter.html).

```language=bash
regularization = hpfrt + nModes = 1 + scalingCoeff = 20
```

As part of the boundary condition configuration, a set of boundary tags is specified in the input parameter file to match the definitions provided in the `usrdat2` subroutine within the `tjunc.usr` file.

!listing msr/msre/pipe_cardinal/tjunc.par start=[VELOCITY] include-end=False

The specific boundary condition values, such as inflow velocities and temperatures, are provided in the case file `tjunc.oudf`. In this setup, the inflow velocity magnitude is set to 1.0 for both the horizontal and vertical inlets, while a non-dimensional temperature of 1.0 is assigned to the vertical inlet.

!listing msr/msre/pipe_cardinal/tjunc.oudf start=void velocityDirichletConditions(bcData *bc) end=@kernel void cliptOKL include-end=False


## Cardinal Case Setups

The demonstration model utilizes nekRS to perform conjugate heat transfer simulations and transfer the temperature solution in the solid region (specifically, the T-junction pipe wall) from +nekRS+ to the +MOOSE Solid Mechanics Module+ for thermal stress analysis. This multiphysics coupling approach involves two input files: `cardinal.i` and `nek.i`. In this setup, the MOOSE Solid Mechanics model defined in cardinal.i acts as the parent application, while the nekRS CFD model operates as the sub-application.
Let's first examine the input file `cardinal.i`. A solid region mesh has to be provided in Exodus format, with the mesh cells configured as Hex8 elements.
In this case, the CFD meshing software ANSYS ICEM was used to generate the mesh.

!listing msr/msre/pipe_cardinal/cardinal.i block=Mesh

A default configuration is used for the MOOSE Solid Mechanics calculations.

!listing msr/msre/pipe_cardinal/cardinal.i block=Physics

For the boundary conditions in the Solid Mechanics simulation, the inner surface of the pipe is assumed to remain fixed, while the outer surface is free to move and deform.

!listing msr/msre/pipe_cardinal/cardinal.i block=BCs

The solid material properties are specified in the block `[Materials]`, and the specific values can be found in [steel_properties]

!listing msr/msre/pipe_cardinal/cardinal.i block=Materials

The `[MultiApps]` block controls the coupling hierarchy, while the volume mapping of the temperature solution from the CFD mesh to the MOOSE mesh is configured in the `[Transfers]` block.

!listing msr/msre/pipe_cardinal/cardinal.i block=MultiApps

!listing msr/msre/pipe_cardinal/cardinal.i block=Transfers

The `nek.i` input file orchestrates the CFD simulation performed by nekRS. Its content is quite minimal, with the key settings being the reference values used for converting raw nekRS results into physical quantities of interest in dimensional units.

!listing msr/msre/pipe_cardinal/nek.i block=Problem


## Preliminary Results

Leveraging the high-fidelity temperature solutions predicted by NekRS, Cardinal maps these solutions onto an intermediate MOOSE mesh. These temperature solutions can then be utilized by any MOOSE application, such as the MOOSE Solid Mechanics Module, which uses the temperature information to perform subsequent thermal stress analysis. The temperature and thermal stresses experienced by the T-junction pipe shell are detailed in [tjunc_stress]. The thermal stress profiles correspond closely to the temperature distribution, with significant variations in thermal stresses observed at the vertical entrance region and the upper side of the horizontal pipe after the joint. Overall, this study demonstrates that Cardinal is well-suited for modeling the thermal striping phenomenon.

!media msr/msre/pipe_cardinal/thermal_stress.png
       style=width:80%
       id=tjunc_stress
       caption=Pipe shell temperature and thermal stress components from MOOSE Solid Mechanics.

## Run Command

This particular Cardinal case was executed using 8 GPUs on a local HPC cluster with the Slurm job scheduler. A job submission script, `gpuCardinal`, was created to submit the simulation to the HPC queue. The script's usage is straightforward, requiring the following input arguments:  `%job_name% %number_of_gpus% %runtime_hours% %runtime_minutes%`.

```language=bash
./gpuCardinal cardinal 8 02 00

```

The content of the `gpuCardinal` script is provided below, and users can modify it for use on other HPC platforms as needed.

!listing msr/msre/pipe_cardinal/gpuCardinal
