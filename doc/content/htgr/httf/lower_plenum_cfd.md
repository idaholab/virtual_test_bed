# Nek5000/RS CFD Modeling of HTTF Lower Plenum Flow Mixing Phenomenon

*Contact: Jun Fang, fangj.at.anl.gov*

*Model link: [HTTF Lower Plenum CFD Model](https://github.com/idaholab/virtual_test_bed/tree/devel/htgr/httf/lower_plenum_mixing)*

## Overview

Accurate modeling and simulation capabilities are becoming increasingly important to speed up the development and deployment of advanced nuclear reactor technologies, such as high temperature gas-cooled reactors. Among the identified safety-relevant phenomena for the gas-cooled reactors (GCR), the outlet plenum flow distribution was ranked to be of high importance with a low knowledge level in the phenomenon identification and ranking table (PIRT) [!citep](Ball2008).
The heated coolant (e.g., helium) flows downward through the GCR core region and enters the outlet/lower plenum through narrow channels, which causes the jetting of the gas flow. The jets have a non-uniform temperature and risk yielding high cycling thermal stresses in the lower plenum, negative pressure gradients opposing the flow ingress, and hot streaking.
These phenomena cannot be accurately captured by 1-D system codes; instead, the modeling requires using higher fidelity CFD codes that can predict the temperature fluctuations in the HTTF lower plenum. In this study, a detailed CFD model is established for the lower plenum of scaled, electrically-heated GCR test facility (i.e., High Temperature Test Facility, or HTTF) at Oregon State University. 
Specifically, the flow mixing phenomenon in HTTF lower plenum is simulated with spectral element CFD software, +Nek5000+ and its GPU-oriented variant +nekRS+.
The turbulence effects are modeled by the two-equation $k-\tau$ URANS model. 
Two sets of boundary conditions are studied in the Nek5000 and nekRS simulations, respectively. 
The velocity and temperature fields are examined to understand the thermal-fluid physics happening during the lower plenum mixing. As part of the HTTF international benchmark campaign, the simulation results generated from this study will be used for code-to-code and code-to-data comparisons in the near future, which would lay a solid foundation for the use of CFD in GCR research and development.

!alert note
This documentation assumes that the reader has basic knowledge of Nek5000, and is able to run
the example cases provided in the [Nek5000 tutorial](https://nek5000.github.io/NekDoc/index.html).
The specific Nek5000 version used here is v19.0. Although Nek5000 input files are not tested regularly
in the Moose CI test suite, Nek5000 does offer reliable backward compatibility.
No foreseeable compatibility issues are expected. In rare situations where there is indeed a compatibility
issue, please reach out to the Nek5000 developer team
via [Nek5000 Google Group](https://groups.google.com/g/nek5000). Meanwhile, nekRS code is still under active
development, and there is only a beta version of [nekRS online tutorial](https://nekrsdoc.readthedocs.io/en/latest/index.html).


## Geometry and Meshing

The HTTF lower plenum (i.e., core outlet plenum) geometry is illustrated in [lp_geom], which  contains 163 ceramic cylindrical posts on which the core structure stands.
It is enclosed by lower side reflectors, lower plenum floor and lower plenum roof. The height of the lower plenum is 22.2 $cm$. Helium gas enters the lower plenum through core coolant channels and exits through the horizontal hot duct. There are 234 inlet channels with the same diameter of 1 $in$ (i.e., 2.54 $cm$).
A cylindrical hot duct is connected to the lower plenum, which functions as the outlet channel.  Rakes are installed in the hot duct to house measurement instruments in the experiments.

!media httf/lower_plenum_cfd/httf_LP_geometry.png
       style=width:50%
       id=lp_geom
       caption=Overview of the HTTF lower plenum geometry.

Nek5000/RS requires a pure hexahedral mesh to perform the calculations. Due to the domain complexity, it is challenging to create an unstructured mesh with only hexahedral cells.
A two-step approach is adopted in the meshing practice. We first used the commercial software, ANSYS Mesh, to generate an unstructured computational mesh consisting of tetrahedra cells (in the bulk) and wedge cells (in the boundary layer region), and then converted it into a pure hexahedra mesh using a native quadratic tet-to-hex utility.
To ensure the accuracy of wall-resolved RANS calculations, the first layer of grid points off the wall is kept at a distance of $y^+ < 1.0$.
As shown in [lp_mesh], the resulting mesh has 2.60 million cells, and the total degrees of freedom is approximately 72.86 million in Nek5000 simulations with a polynomial order of 3. Note that the polynomial order is kept relatively low to limit the computational costs. It can be readily increased for higher-fidelity simulations, such as a Large Eddy Simulation (LES), given necessary computing hours.

!media httf/lower_plenum_cfd/httf_mesh.png
       style=width:60%
       id=lp_mesh
       caption=The hexahedral mesh of HTTF lower plenum from the tet-to-hex conversion.

## Nek5000 Investigation

### Boundary conditions style=font-size:125%

The boundary conditions adopted in the Nek5000 simulations are taken from the corresponding system modeling of HTTF system using RELAP5-3D [!citep](Halsted2022).
The 234 inlet channels are divided into five rings as shown in [lp_bcs] based on the radial locations, and each ring with specific mass flow rate and temperature.
Inside the lower plenum (LP), the floor, roof, posts and side reflector walls all have distinct temperature values. The LP roof has the highest temperature while the side walls sees the lowest.
Details of the thermal boundary conditions are listed in [lp_bcs_table].
Inlet channels within a specific ring are assumed to have fixed inflow velocity according to the mass flow rate, and the no-slip condition is imposed to all wall surfaces. A natural pressure condition is given to the outlet face of hot duct.

!media httf/lower_plenum_cfd/httf_inlet_bc.png
       style=width:80%
       id=lp_bcs
       caption=Inlet boundary conditions of the five inlet rings/groups: temperature (left) and velocity (right).


!table id=lp_bcs_table caption=Boundary conditions specified for the HTTF lower plenum CFD simulations.
|  Boundary | BC Type | Value  |
| :- | :- | :- |
| Melting temperature | $T_{melt}$ | $K$ |
|  Ring 1    | $\dot{m}$, $T$ | 0.651 $g/s$, 562.2 $K$ |
|  Ring 2    | $\dot{m}$, $T$ | 4.919 $g/s$, 561.8 $K$ |
|  Ring 3    | $\dot{m}$, $T$ | 7.423 $g/s$, 541.3 $K$ |
|  Ring 4    | $\dot{m}$, $T$ | 7.704 $g/s$, 512.0 $K$ |
|  Ring 5    | $\dot{m}$, $T$ | 2.337 $g/s$, 471.6 $K$ |
|  LP Roof   | $T$ | 543.48 $K$  |
|  LP Floor  | $T$ | 494.65 $K$  |
|  Side Reflectors   | $T$ | 452.37 $K$  |
|  LP Posts  | $T$ | 526.39 $K$ |
|  Hot duct  | $T$ | 496.64 $K$ |
|  Rakes and all other walls   | Adiabatic | N/A  |

The mean LP pressure is 100.5 $kPa$, with which the helium gas has a density of 0.1004 $kg/m^3$. A non-dimensionalization process is performed for the Nek5000 calculations. The reference velocity is 3.47 $m/s$ that is the highest inlet velocity observed for Ring 3 inlet channels. The temperature difference with respect to the side reflector wall temperature (452.37 $K$) is normalized by $\Delta T = 562.20-452.37 = 109.83 (K)$, where the maximum temperature is from Ring 1 inlet channels. During the post-processing, the CFD results can be easily converted back to dimensional quantities for further analyses.

### Nek5000 sase setups style=font-size:125%

The reader can find the Nek5000 case files and the associated HTTF lower plenum files (through github LFS) in VTB repository. The mesh information is contained in two files: +httf.re2+ (grid coordinates, sideset ids, etc.) and +httf.co2+ (mesh cell connectivity).
As for the Nek5000 case files, there are +SIZE+, +httf.par+, +httf.usr+, and two auxiliary files +limits.f+ and +utilities.f+ that hosts various post-processing functions, such as solution monitoring, planar averaging, and so forth.
+SIZE+ is the metafile to specify primary discretization parameters.
+httf.usr+ is the script where users specify the boundary conditions, turbulence modeling approach and post-processing.
+httf.par+ is to provide the simulation input parameters, such as material properties, time step size, Reynolds number.

Now let's dive into the most important case file +httf.usr+. The sideset ids contained in the mesh file are first translated into CFD boundary condition settings in +usrdat2+ block

!listing htgr/httf/lower_plenum_mixing/httf.usr start=subroutine usrdat2() end=subroutine usrdat3() include-end=False

The $k-\tau$ URANS model is specified in the following code block

!listing htgr/httf/lower_plenum_mixing/httf.usr start=subroutine usrdat3() end=subroutine turb_in(wd,tke,tau) include-end=False

The specific inlet temperature and mass flow rates are implemented in +userbc+ with the non-dimensionalized values

!listing htgr/httf/lower_plenum_mixing/httf.usr start=if(id_face.eq.3) end=endif include-end=True


### Nek5000 results style=font-size:125%

The aforementioned CFD cases were carried out on the Sawtooth supercomputer located at Idaho National Laboratory. A typical simulation job would use 64 compute nodes with 48 parallel processes per node.
A characteristics based time-stepping has been used in the simulations to avoid the limitations imposed by the Courant-Friedrichs-Lewy
(CFL) number due to the explicit treatment of the non-linear convection
term. This treatment is necessary due to the existence of small local mesh cells created during the unstructured meshing and tet-to-hex conversion.
A maximum CFL number of 1.75 has been reached which corresponds to an average time step size of $2.5\times 10^{-5}$.
A total non-dimensional simulation time of 5.6 is achieved.
Due to the nature of the unsteady RANS turbulence model, only a quasi-steady state can be reached. Velocity fluctuations are observed when helium flow enters the lower plenum and passes through the LP posts.

Snapshots of velocity and temperature fields from quasi-steady state are shown in [lp_vel] and [lp_temp]
at the lower plenum plane ($y=-0.1 m$). Significant fluctuations are observed for both velocity and temperature.

!media httf/lower_plenum_cfd/unsteady_vel.png
       style=width:60%
       id=lp_vel
       caption=The quasi-steady-state velocity field (non-dimensional) in the lower plenum.

!media httf/lower_plenum_cfd/T_at_time_5.6.png
       style=width:60%
       id=lp_temp
       caption=The quasi-steady-state temperature field (non-dimensional) in the lower plenum.

In addition to the instantaneous solutions, a time averaging analysis is also conducted for simulation results from 3.8 to 5.6 time units.
[Uavg] and [Tavg] illustrate the smooth profiles of time averaged velocity and temperature field respectively.
Large velocity difference is noticed due to the geometric constraints in lower plenum. On the contrary, the temperature has a more uniform distribution for the most part of lower plenum.
To better understand the modeling uncertainties of numerical simulations in the related applications, the Nek5000 calculations will be compared with other CFD software's predictions. This comparative analysis will provide insights into the accuracy and reliability of the simulation results and help identify potential sources of error in the modeling process. By examining the differences and similarities between the results obtained from different software, researchers and engineers can improve the modeling techniques and optimize the simulation settings to achieve better agreement with experimental data. Such a comprehensive analysis will help to enhance the credibility and usefulness of numerical simulations for various engineering applications.

!media httf/lower_plenum_cfd/Uavg.png
       style=width:60%
       id=Uavg
       caption=Time-averaged velocity field (non-dimensional) in the lower plenum.

!media httf/lower_plenum_cfd/Tavg.png
       style=width:60%
       id=Tavg
       caption=Time-averaged temperature field (non-dimensional) in the lower plenum.

### Nek5000 run Script style=font-size:125%

To submit a Nek5000 simulation job on Sawtooth, the following batch script is used. The user can adjust the number of nodes, and number of processes per node, as well as the simulation time for any specific cases.

```language=bash
#!/bin/bash
#PBS -N httf
#PBS -l select=64:ncpus=48:mpiprocs=48
#PBS -l walltime=01:00:00
#PBS -j oe
#PBS -P neams
#PBS -o httf.out
cd $PBS_O_WORKDIR
export OMP_NUM_THREADS=1
echo  httf > SESSION.NAME
echo `pwd`'/' >> SESSION.NAME
rm -rf *.sch
rm -rf ioinfo
module purge
module load intel-mpi/2018.5.288-intel-19.0.5-alnu
mpirun ./nek5000 > logfile
```

## NekRS Investigation

We initiated our simulation efforts using the Nek5000 solver. However, we opted to transition to NekRS due to its remarkable enhancement in computational efficiency.
In the era of Exascale computing, there's a notable shift towards accelerated computing using Graphics Processing Units (GPUs) among leadership class supercomputers. To fully harness this new heterogeneous computing hardware, NekRS emerges as an exascale-ready thermal-fluids solver for incompressible and low-Mach number flows. Like its predecessor, Nek5000, it is based on the spectral element method and is scalable to $10^5$ processors and beyond. The principal differences between Nek5000 and NekRS are that the former is based on F77/C, coupled with MPI and fast matrix-matrix product routines for performance, while the latter is based on C++ coupled with MPI and OCCA kernels for GPU support. The Open Concurrent Compute Abstraction provides backends for CUDA, HIP, OpenCL, and DPC++, for performance portability across all the major GPU vendors. We note that, at 80% parallel efficiency, which corresponds to 2–3 million points per MPI rank, NekRS is running at 0.1 to 0.3 seconds of wall clock time per timestep, which is nearly a 3x improvement over production runs of Nek5000 at a similar 80% strong-scale limit on CPU-based platforms.

### Boundary conditions style=font-size:125%

The boundary conditions of the nekRS study are taken from the corresponding system modeling of HTTF primary loop using RELAP5-3D conducted by Canadian Nuclear Laboratories. The reference lower plenum pressure is 211.9 kPa, and the helium gas has a density of 0.1950 kg/m3 with a reference temperature of 895.7 K. 
Table 3 summarizes the key thermophysical properties of helium flow used in the NekRS simulations.  The 234 inlet channels are divided into 32 groups here as shown in [new_grouping] 
based on the radial locations and polar angles, and each group with specific mass flow rate and temperature. Inlet channels within a certain group are assumed to have the same inflow velocity corresponding to the specific mass flow rate. 
Details of the inlet boundary conditions are listed in Table 4.
Figure 11 visually illustrates the boundary conditions that are enumerated in Table 4. 
All wall surfaces are assumed to have no-slip velocity boundary condition and adiabatic thermal boundary condition. And a natural pressure condition is given to the outlet face of hot duct. The CFD simulations were carried out in a dimensionless manner. The reference velocity is the mean flow velocity at hot duct, which is 41.48 m/s. Normalization of temperature is accomplished by referencing it to the maximum inlet temperature of 984.34 K at CG0 group and the minimum inlet temperature of 810.05 K at the outer bypass group. Subsequently, during the post-processing stage, it is straightforward to convert the computational fluid dynamics (CFD) outcomes back into dimensional values, enabling additional analyses to be conducted.

!media httf/lower_plenum_cfd/new_grouping.png
       style=width:60%
       id=new_grouping
       caption=The grouping of lower plenum inlet channels.


!table id=new_bc caption=Helium thermo-physical properties and flow conditions.
| $-$ | Value | Unit  |
| :- | :- | :- |
| Reference pressure | 211.9 | $kPa$ |
| Reference temperature | 895.7 | $K$ |
| Helium density | 0.1075 | $kg/m^3$ |
| Helium heat capacity | 5.193×103 | $J/kg-K$ |
| Helium viscosity | 4.274×10-5 | $Pa-s$ |
| Helium thermal conductivity | 0.3323 | $W/m-K$ |
| Helium Prandtl number | 0.67 | $-$ |
| Hot duct diameter | 0.2984 | $m$ |
| Mean flow velocity at Reynolds number at hot duct | 41.48 | $m/s$ |
| Reynolds number at hot duct | 3.1137×104 | $-$ |


The mean LP pressure is 100.5 $kPa$, with which the helium gas has a density of 0.1004 $kg/m^3$. A non-dimensionalization process is performed for the Nek5000 calculations. The reference velocity is 3.47 $m/s$ that is the highest inlet velocity observed for Ring 3 inlet channels. The temperature difference with respect to the side reflector wall temperature (452.37 $K$) is normalized by $\Delta T = 562.20-452.37 = 109.83 (K)$, where the maximum temperature is from Ring 1 inlet channels. During the post-processing, the CFD results can be easily converted back to dimensional quantities for further analyses.