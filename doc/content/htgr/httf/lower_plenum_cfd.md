# Nek5000/RS CFD Modeling of HTTF Lower Plenum Flow Mixing Phenomenon

*Contact: Jun Fang, fangj.at.anl.gov*

*Model link: [HTTF Lower Plenum CFD Model](https://github.com/idaholab/virtual_test_bed/tree/devel/htgr/httf/lower_plenum_mixing)*

!tag name=Nek5000 CFD Modeling of HTTF Lower Plenum Flow Mixing Phenomenon
     description=CFD simulation of the plenum using unsteady RANS
     image=https://mooseframework.inl.gov/virtual_test_bed/media/httf/lower_plenum_cfd/httf_mesh.png
     pairs=reactor_type:HTGR
                       reactor:HTTF
                       geometry:plenum
                       simulation_type:CFD
                       transient:steady_state
                       v&v:demonstration
                       codes_used:Nek5000
                       computing_needs:HPC
                       open_source:true
                       fiscal_year:2023
                       sponsor:NEAMS
                       institution:ANL

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

### Nek5000 case setups style=font-size:125%

The reader can find the Nek5000 case files and the associated HTTF lower plenum mesh files (through github LFS) in VTB repository. The mesh information is contained in two files: +httf.re2+ (grid coordinates, sideset ids, etc.) and +httf.co2+ (mesh cell connectivity).
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


### Nek5000 simulation results style=font-size:125%

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

The boundary conditions of the nekRS study are taken from the corresponding system modeling of HTTF primary loop using RELAP5-3D conducted by Canadian Nuclear Laboratories [!citep](Podila2022). The reference lower plenum pressure is 211.9 kPa, and the helium gas has a density of 0.1950 kg/m$^3$ with a reference temperature of 895.7 K.
[he_condition] summarizes the key thermophysical properties of helium flow used in the NekRS simulations.  The 234 inlet channels are divided into 32 groups here as shown in [new_grouping]
based on the radial locations and polar angles, and each group with specific mass flow rate and temperature. Inlet channels within a certain group are assumed to have the same inflow velocity corresponding to the specific mass flow rate.
Details of the inlet boundary conditions are listed in [inlet_bc].
[new_bc] visually illustrates the boundary conditions that are enumerated in [inlet_bc].

!media httf/lower_plenum_cfd/new_grouping.png
       style=width:60%
       id=new_grouping
       caption=The grouping of lower plenum inlet channels.

!table id=he_condition caption=Helium thermo-physical properties and flow conditions.
| $-$ | Value | Unit  |
| :- | :- | :- |
| Reference pressure | 211.9 | $kPa$ |
| Reference temperature | 895.7 | $K$ |
| Helium density | 0.1075 | $kg/m^3$ |
| Helium heat capacity | 5.193×10$^3$ | $J/kg-K$ |
| Helium viscosity | 4.274×10$^{-5}$ | $Pa-s$ |
| Helium thermal conductivity | 0.3323 | $W/m-K$ |
| Helium Prandtl number | 0.67 | $-$ |
| Hot duct diameter | 0.2984 | $m$ |
| Mean flow velocity at Reynolds number at hot duct | 41.48 | $m/s$ |
| Reynolds number at hot duct | 3.1137×10$^4$ | $-$ |

All wall surfaces are assumed to have no-slip velocity boundary condition and adiabatic thermal boundary condition. And a natural pressure condition is given to the outlet face of hot duct. The CFD simulations were carried out in a dimensionless manner. The reference velocity is the mean flow velocity at hot duct, which is 41.48 m/s. Normalization of temperature is accomplished by referencing it to the maximum inlet temperature of 984.34 K at CG0 group and the minimum inlet temperature of 810.05 K at the outer bypass group. Subsequently, during the post-processing stage, it is straightforward to convert the computational fluid dynamics (CFD) outcomes back into dimensional values, enabling additional analyses to be conducted.

!table id=inlet_bc caption=Inlet boundary conditions for the HTTF lower plenum simulations.
| Zone ID | Velocity ($m/s$) | Temperature ($K$)  |
| :- | :- | :- |
| CG0 | 30.389 | 984.34 |
| CG-1A | 23.513 | 924.658 |
| CG-2A | 25.709 | 889.08 |
| CG-3A | 26.618 | 944.901 |
| CG-4A | 26.405 | 926.654 |
| CG-5A | 21.83 | 866.424 |
| CG-1B | 23.513 | 925.415 |
| CG-2B | 25.69 | 890.425 |
| CG-3B | 26.61 | 947.609 |
| CG-4B | 26.446 | 932.229 |
| CG-5B | 21.828 | 867.567 |
| CG-1C | 23.511 | 924.788 |
| CG-2C | 25.702 | 889.276 |
| CG-3C | 26.608 | 945.155 |
| CG-4C | 26.394 | 926.902 |
| CG-5C | 21.825 | 866.606 |
| CG-1D | 23.52 | 922.995 |
| CG-2D | 25.794 | 886.395 |
| CG-3D | 26.772 | 941.098 |
| CG-4D | 26.586 | 922.794 |
| CG-5D | 21.91 | 863.558 |
| CG-1E | 23.517 | 920.054 |
| CG-2E | 25.9 | 881.331 |
| CG-3E | 27.101 | 932.826 |
| CG-4E | 27.129 | 913.384 |
| CG-5E | 22.303 | 856.71 |
| CG-1F | 23.521 | 922.956 |
| CG-2F | 25.796 | 886.341 |
| CG-3F | 26.775 | 941.027 |
| CG-4F | 26.589 | 922.725 |
| CG-5F | 21.911 | 863.508 |
| Outer bypass | 20.669 | 810.051 |

!media httf/lower_plenum_cfd/new_inlet_bc.png
       style=width:75%
       id=new_bc
       caption=Boundary conditions: (a) prescribed inlet velocity and no-slip wall condition; (b) prescribed inlet temperature and adiabatic walls.

### NekRS case setups style=font-size:125%

Readers can access the nekRS case files and the corresponding mesh files in the VTB repository via GitHub Large File Storage (LFS). The mesh data is contained in two files: +httf.re2+ (which includes grid coordinates and sideset ids) and +httf.co2+ (containing mesh cell connectivity information).
Regarding the nekRS case files, there are four basic files:

- +httf.udf+ serves as the primary nekRS kernel file and encompasses algorithms executed on the hosts. It's responsible for configuring RANS model settings, collecting time-averaged statistics, and determining the frequency of calls to +userchk+, which is defined in the +usr+ file.
- +httf.oudf+ is a supplementary file housing kernel functions for devices and also plays a role in specifying boundary conditions.
- +httf.usr+ is a legacy file inherited from Nek5000 and can be utilized to establish initial conditions and define post-processing capabilities.
- +httf.par+  is employed to input simulation parameters, including material properties, time step size, and Reynolds number.

There are also supportive scripts in the case folder. +linearize_bad_elements.f+ and +BAD_ELEMENTS+ are used to fix the mesh cells that potentially have negative Jacobian values from the quadratic tet-to-hex conversion.
Data file +InletProf.dat+ contains the fully developed turbulence solutions of a circular pipe, which is used to customize the profiles of velocity, TKE and tau at HTTF inlet channels.

Now let's dive into the most important case file +httf.usr+. The sideset ids contained in the mesh file are first translated into CFD boundary condition settings in +usrdat2+ block

!listing htgr/httf/lower_plenum_mixing/nekrs_case/httf.usr start=subroutine usrdat2() end=subroutine usrdat3 include-end=False

The fixes to the negative Jacobian errors in mesh file is called in +usrdat+

!listing htgr/httf/lower_plenum_mixing/nekrs_case/httf.usr start=subroutine usrdat end=subroutine usrdat2() include-end=False

As for the implementation of inlet boundary conditions, a set of data arrays is created in +usr+ and passed over to the +udf+ and +oudf+.
At the +usr+ file side, the main subroutine is +getinlet+. It assembles the non-dimensionalized inlet velocity, temperature,
k and $\tau$ into the following arrays

!listing htgr/httf/lower_plenum_mixing/nekrs_case/httf.usr start=real uin,vin,win,tin end=t3in(lx1,ly1,lz1,lelv) include-end=True

The corresponding information is transfered to +httf.udf+ at

!listing htgr/httf/lower_plenum_mixing/nekrs_case/httf.udf start=RANSktau::setup end=void UDF_ExecuteStep include-start=False include-end=False

And then the velocity and passive scalar (temperature, k and $\tau$) boundary conditions are applied in +httf.oudf+ at

!listing htgr/httf/lower_plenum_mixing/nekrs_case/httf.oudf start=void velocityDirichletConditions end=  include-end=False

The following code snippet in +httf.udf+ controls the frequency that +usrchk+ is called during the simulations, which is once in every 1,000 steps in the current case.

```language=bash
  if ((tstep%1000)==0){
    nek::ocopyToNek(time, tstep);
    nek::userchk();
  }
```

Time averaged statitics is collected using the following lines in +httf.udf+

```language=bash
  6 #include "plugins/tavg.hpp"

 45   tavg::setup(nrs);

 73   tavg::run(time);

 85   if (nrs->isOutputStep) {
 86     tavg::outfld();
 87   }

```

### NekRS simulation results style=font-size:125%

A total simulation time of 12 non-dimensional units is achieved. Due to the nature of unsteady RANS turbulence model, only a quasi-steady state can be reached. Velocity fluctuations are observed when helium flow enters the lower plenum and passes through the LP posts.
The subsequent post-processing focuses primarily on the time-averaged solutions.
For that purpose, an analysis involving time-averaging is carried out on simulation results spanning from 6.0 to 12.0 time units.
[new_U] and [new_T] portray the more uniform profiles of the time-averaged velocity and temperature distributions, respectively. Through the elimination of instantaneous fluctuations, the time-averaged outcomes reveal notably symmetric patterns in both the velocity and temperature fields. Also, [new_U] illustrates the symmetrical horizontal jets emerging through the openings between the lower plenum posts as the helium flow enters the hot duct. Notably, flow recirculations become evident within the wake regions behind these posts.

!media httf/lower_plenum_cfd/new_averaged_U.png
       style=width:75%
       id=new_U
       caption=Time averaged velocity distribution in the lower plenum at y = -0.1 (top view).

!media httf/lower_plenum_cfd/new_averaged_T.png
       style=width:75%
       id=new_T
       caption=Time averaged temperature fields at y = -0.1 and z = 0.

In addition to the horizontal perspective, a vertical viewpoint offers a clearer insight into the injection of helium flow originating from the inlet channels. As evidenced by [new_T] and [slice_T], the presence of helium jets is quite conspicuous within the lower plenum, characterized by notably higher velocity and temperature values. Moreover, the inflow jets exhibit greater prominence in regions farther from the hot duct, owing to the diminished local horizontal flow. Conversely, areas nearer to the hot duct showcase more pronounced disturbances in the inflow jets due to the stronger local horizontal flow. Consequently, in [slice_T], the jets positioned away from the hot duct achieve deeper penetration, while those in close proximity to the hot duct experience quicker diffusion. The presence of hot streaking is further confirmed within the lower plenum, particularly in areas distant from the hot duct. The streams of elevated temperature directly impact the lower plenum posts and floor in this specific region, resulting in uneven thermal stresses. In general, the lower section of the lower plenum encounters higher temperatures, notably at the juncture between the lower plenum and the hot duct, as visually depicted in [slice_T]. [floor_T] offers an improved perspective of the temperature distribution on the lower plenum floor, enabling the identification of the hotspot.

!media httf/lower_plenum_cfd/new_T_slice_view.png
       style=width:75%
       id=slice_T
       caption=Jetting of helium flow from the inlet channels.

!media httf/lower_plenum_cfd/new_T_LPfloor.png
       style=width:75%
       id=floor_T
       caption=Time averaged temperature distribution on the lower plenum floor.

### NekRS run Script style=font-size:125%

To submit a nekRS simulation job on common leadership class facilities, dedicated job submission scripts are provided in [nekRS repository](https://github.com/Nek5000/nekRS/tree/master/scripts) for supercomputers, such as Summit-OLCF, Polaris-ALCF, etc. Taking Polaris as an example, to submit the nekRS job, simply do

```language=bash
./nrsqsub_polaris httf 50 06:00:00
```
