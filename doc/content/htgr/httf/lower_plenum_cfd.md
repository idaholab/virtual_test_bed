# Nek5000 CFD Modeling of HTTF Lower Plenum Flow Mixing Phenomenon

*Contact: Jun Fang, fangj.at.anl.gov*

*Model link: [HTTF Lower Plenum CFD Model](https://github.com/idaholab/virtual_test_bed/tree/devel/htgr/httf/lower_plenum_mixing)*

!tag name='Nek5000 CFD Modeling of HTTF Lower Plenum Flow Mixing Phenomenon' pairs=reactor_type:HTGR
                       reactor:HTTF
                       geometry:plenum
                       simulation_type:component_CFD
                       code_used:Nek5000
                       computing_needs:HPC
                       open_source:true
                       fiscal_year:2023

## Overview

Accurate modeling and simulation capabilities are becoming increasingly important to speed up the development and deployment of advanced nuclear reactor technologies, such as high temperature gas-cooled reactors. Among the identified safety-relevant phenomena for the gas-cooled reactors (GCR), the outlet plenum flow distribution was ranked to be of high importance with a low knowledge level in the phenomenon identification and ranking table (PIRT) [!citep](Ball2008).
The heated coolant (e.g., helium) flows downward through the GCR core region and enters the outlet/lower plenum through narrow channels, which causes the jetting of the gas flow. The jets have a non-uniform temperature and risk yielding high cycling thermal stresses in the lower plenum, negative pressure gradients opposing the flow ingress, and hot streaking.
These phenomena cannot be accurately captured by 1-D system codes; instead, the modeling requires using higher fidelity CFD codes that can predict the temperature fluctuations in the HTTF lower plenum. In this study, a detailed CFD model is established for the lower plenum of scaled, electrically-heated GCR test facility (i.e., High Temperature Test Facility, or HTTF) at Oregon State University. Specifically, the flow mixing phenomenon in HTTF lower plenum is simulated with spectral element CFD software, Nek5000, with the turbulence modeled by the two-equation $k-\tau$ URANS model. The velocity and temperature fields are examined to understand the thermal-fluid physics happening during the lower plenum mixing. As part of the HTTF international benchmark campaign, the simulation results generated from this study will be used for code-to-code and code-to-data comparisons in the near future, which would lay a solid foundation for the use of CFD in GCR research and development.

!alert note
This documentation assumes that the reader has basic knowledge of Nek5000, and is able to run
the example cases provided in the [Nek5000 tutorial](https://nek5000.github.io/NekDoc/index.html).
The specific Nek5000 version used here is v19.0. Although Nek5000 input files are not tested regularly
in the Moose CI test suite, Nek5000 does offer reliable backward compatibility.
No foreseeable compatibility issues are expected. In rare situations where there is indeed a compatibility
issue, please reach out to the Nek5000 developer team
via [Nek5000 Google Group](https://groups.google.com/g/nek5000).


## Simulation Setups

The HTTF lower plenum (i.e., core outlet plenum) geometry is illustrated in [lp_geom], which  contains 163 ceramic cylindrical posts on which the core structure stands.
It is enclosed by lower side reflectors, lower plenum floor and lower plenum roof. The height of the lower plenum is 22.2 $cm$. Helium gas enters the lower plenum through core coolant channels and exits through the horizontal hot duct. There are 234 inlet channels with the same diameter of 1 $in$ (i.e., 2.54 $cm$).
A cylindrical hot duct is connected to the lower plenum, which functions as the outlet channel.  Rakes are installed in the hot duct to house measurement instruments in the experiments.

!media httf/lower_plenum_cfd/httf_LP_geometry.png
       style=width:50%
       id=lp_geom
       caption=Overview of the HTTF lower plenum geometry.

Nek5000 requires a pure hexahedral mesh to perform the calculations. Due to the domain complexity, it is challenging to create an unstructured mesh with only hexahedral cells.
A two-step approach is adopted in the meshing practice. We first used the commercial software, ANSYS Mesh, to generate an unstructured computational mesh consisting of tetrahedra cells (in the bulk) and wedge cells (in the boundary layer region), and then converted it into a pure hexahedra mesh using a native tet-to-hex Nek5000 utility.
To ensure the accuracy of wall-resolved RANS calculations, the first layer of grid points off the wall is kept at a distance of $y^+ < 1.0$.
As shown in [lp_mesh], the resulting mesh has 2.60 million cells, and the total degrees of freedom is approximately 72.86 million in Nek5000 simulations with a polynomial order of 3. Note that the polynomial order is kept relatively low to limit the computational costs. It can be readily increased for higher-fidelity simulations, such as a Large Eddy Simulation (LES), given necessary computing hours.

!media httf/lower_plenum_cfd/httf_mesh.png
       style=width:60%
       id=lp_mesh
       caption=The hexahedral mesh of HTTF lower plenum from the tet-to-hex conversion.

The boundary conditions of the current CFD cases are taken from the corresponding system modeling of HTTF system using RELAP5-3D [!citep](Halsted2022).

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

## Nek5000 Modelling

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


## Simulation Results

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

## Run Script

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
