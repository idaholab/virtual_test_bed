# MSFR Nek5000 CFD modeling

*Contact: Jun Fang, fangj.at.anl.gov*

Computational Fluid Dynamics (CFD) plays an unique role in the research and development (R&D) of 
Molten Salt Fast Reactor (MSFR). As a great complement to experiments, it offers a cost effective 
way to study the complex thermal fluid physics expected in the MSFR system. 

For certain advanced nuclear reactor concepts (e.g., MSFR) where the related experimental data is 
very scarce or not available, CFD also provides much needed reference to develop and calibrate
reactor design tools. 
In this VTB documentation, you will find examples for a series of CFD simulations developed to model
the coolant flow in MSFR core cavity. 
The related models range from relatively low-cost 2-D Reynolds-Averaged Navier Stokes (RANS) 
simulations to more accurate 3-D Large Eddy Simulations (LES). 
The NEAMS signature CFD code, [Nek5000](https://github.com/Nek5000/Nek5000) is used here for the 
corresponding CFD calculations. 
Nek5000 is an open source CFD code based on the spectral element method (SEM) with
a long history of application in reactor thermal-hydraulics
research [!citep](Merzari2017).

Though the various CFD modeling approaches and case studies, one primary motivation is to seek 
an in-depth understanding of how the internal velocity distribution can be influenced by 
the MSFR core cavity shape, the Reynolds number, turbulence modeling options and the inlet 
boundary conditions.
In the following sections, we will go through all the components one would expect in a
typical CFD investigation, and provide detailed descriptions about the numerical methods, case setups,
key results and discoveries. 

!alert note
This documentation assumes that reader has basic knowledge of Nek5000, and is able to run 
the example cases provided in [Nek5000 tutorial](https://nek5000.github.io/NekDoc/index.html)


## CFD solver and turbulence modeling

Nek5000 is based on the Spectrum Element Method (SEM), which combines the accuracy of 
spectral methods with the domain flexibility of the finite element method.
In Nek5000 calculations, the domain is discretized into $E$ curvilinear hexahedral
elements, in which the solution is represented as a tensor product of $N^{th}$-order
Lagrange polynomials based on the Gauss-Lobatto-Legendre (GLL) nodal points,
leading to a total number of grid points $n=EN^3$.
Nek5000 was designed from the outset of distributed-memory platforms. It is highly
parallel and has been previously applied to a wide range of problems to gain
unprecedented insight into the physics of turbulence in complex flows.
The time-stepping scheme of Nek5000 is semi-implicit: the diffusion terms of the
Navier-Stocks equations are treated implicitly by using a $k^{th}$-order
backward difference formula ($BDFk$), while nonlinear terms are approximated
by a $k^{th}$-order extrapolation ($EXTk$).
Nek5000 was originally developed for simulating turbulent flows with very high
fidelity, i.e. DNS and LES. More recently, the RANS capability has been implemented
in the form of the regularized $k-\omega$ models and the $k-\tau$
model [!citep](Tomboulides2018, Fang2021).
Both LES and DNS require proper resolution of turbulent length scales, which can
be very expensive computationally. Considering the problem size involved in MSFR
core flow simulations, the RANS model would be a more practical option, especially with 
high Reynolds numbers.
A spectrum of CFD models have been developed for MSFR core, which ranges from fast-running 
2-D axisymmetric RANS cases, 3-D partial core RANS model, and a more accurate full-core LES model 
at moderate Reynolds number. 
This model suite provides a variety of examples for anyone who is interested in using Nek5000 for
MSFR related CFD simulations with different fidelities and computational costs.

The incompressible formulation of Nek5000 is used in the current study
which assumes a Newtonian fluid with constant properties. The corresponding
continuity, momentum and energy equations are listed below:

\begin{equation}
    \frac{\partial u_i}{\partial x_i}  =  0
\end{equation}

\begin{equation}
 \frac{\partial u_i}{\partial t} + \frac{\partial }{\partial x_j}(u_i u_j) =  -
\frac{1}{\rho}\frac{\partial p}{\partial x_i} +
\frac{\partial }{\partial x_j}\left[\nu( \frac{\partial u_i}{\partial x_j} +
\frac{\partial u_j}{\partial x_i})\right]
\end{equation}

\begin{equation}
 \frac{\partial T}{\partial t} + u_j \frac{\partial T}{\partial x_j} =
\frac{\partial }{\partial x_j} \left( \frac{\nu}{Pr} \frac{\partial T}{\partial x_j} \right) +
\frac{q}{\rho C_p}
\end{equation}

where $u$ is the velocity, $p$ is the pressure, $T$ is the temperature, $\rho$
is the fluid density, $\nu$ stands for the kinematic viscosity, $Pr$ is the
Prandtl number, $q$ is the heat generation in the fluid while $c_p$ is the heat capacity.

To model the highly turbulent flows, the RANS models have been
recently implemented in Nek5000, including the $k-\omega$ model and its
variation, the  $k-\tau$ model. The equations for $k$ and $\tau$ are derived
from the $k-\omega$ equations [!citep](Tomboulides2018) by using the definition
$\tau=1/\omega$. The corresponding transport equations are as follows

\begin{equation}
    \frac{\partial (\rho k)}{\partial t} + \nabla\cdot(\rho k \bf{v}) =  \nabla\cdot\left[(\mu+\frac{\mu_t}{\sigma_k})\nabla \text{k}\right] + \text{P} - \rho \beta^{*}\frac{\text{k}}{\tau}
\end{equation}

\begin{equation}
 \frac{\partial (\rho \tau)}{\partial t} + \nabla\cdot(\rho\tau \bf{v}) =  \nabla\cdot\left[(\mu+\frac{\mu_t}{\sigma_\omega })\nabla \tau \right] - \gamma \frac{\tau}{\text{k}} \text{P} + \rho \beta-\text{2}\frac{\mu}{\tau}\left(\nabla\tau\cdot\nabla\tau\right)
\end{equation}

In contrast to the original form of the $k-\omega$ model, in which the $\omega$
equation contains terms that become singular close to  wall boundaries, all terms
in the right-hand side of the $k$ and $\tau$ equations reach a finite  limit
at walls and do not need to be treated  asymptotically; that is, they
do not require regularization for numerical implementation. 
As a result, the $k-\tau$ model is noticed to be more robust. 
The $k-\tau$ model in Nek5000 has been benchmarked extensively across a variety
of canonical cases including channel flow and the backward facing step, and it
has been also applied to fuel rod bundle geometry. Interested readers
can refer to the recent publication [!citep](Fang2021) for more details regarding
the $k-\tau$ application and validation in fuel rod bundles.  

Both LES and RANS approaches play unique roles here. The LES approach is utilized to produce high-fidelity reference data to reveal 3-D system behavior in MSFR core. It uses the stabilizing filter of Fischer and Mullen [!citep](Fischer2001). The solution at each time step is explicitly filtered and the filtering operator $F_\alpha$ is defined as

\begin{equation}
    F_\alpha  = \alpha I_{N-1} + (1-\alpha)I
\end{equation}

where $I$ is the identity operator and $I_N$ is the interpolation operator at the $N+1$ GLL nodes. This filter preserves the desirable spectral convergence of SEM as the mesh resolution increases. In addition, a characteristics based time-stepping [!citep](Maday1990) has been used in the LES
runs to avoid the limitations imposed by the Courant-Friedrichs-Lewy (CFL) number due to the explicit treatment of the non-linear convection term.

## Model setups

The specific reactor model considered herein is based upon the MSFR design created under the Euratom EVOL project [!citep](rouch2014). 
The reference MSFR is a 3000 MW fast-spectrum reactor with three different circuits: the fuel circuit, 
the intermediate circuit and the power conversion circuit. In the fuel circuit, 
there are 16 groups of pumps and heat exchangers around the core. 
The flow conditions and thermophysical properties of the primary/fuel salt are derived from [!cite](rouch2014) 
and listed in [msfr_conditions].
The core has a height of 1.6 m along the centerline, and a height of 2.65 m in the peripheral region. 
The reactor radius ranges from 1.05 to 1.53 m. The peripheral wall is a curved surface resulting in the entire core 
resembling the shape of a stout hourglass. 
Leveraging the existing MSFR studies published in the literature, the +Geometry II+ investigated by [!cite](rouch2014) 
is selected as the reference geometry for our CFD simulations. 

!table id=msfr_conditions caption=Reference flow conditions and thermo-physical properties of fuel salt in the primary circuit.
| Parameter | Value | Unit |
| :- | :- | :- |
| Parameter | Value | Unit |
| Mass flow rate    | 18932.2 | $[kg/s]$  |
| Mean core temperature    | 675 | $[^\circ C]$  |
| Salt density (T=675$^\circ C$)    | 4147.29 | $[kg/m^3]$  |
| Salt heat capacity (T=675$^\circ C$)    | 1524.86 | $[J/(kg \bullet K)]$  |
| Salt viscosity (T=675$^\circ C$)    | 0.011266 | $[Pa \bullet s]$  |
| Salt thermal conductivity (T=675$^\circ C$)  | 1.007645 | $[W/(K \bullet	 m)]$  |
| Minimum core radius  | 1.054 | $[m]$  |
| Mean flow velocity at minimum core radius   | 1.308 | $[m/s]$  |
| Estimated Reynolds number   | $1.02\times10^6$ | $[-]$  |
| Estimated Prandtl number   | 17.05 | $[-]$  |
| Estimated Peclet number   | $1.73\times10^7$ | $[-]$  |


A 2-D axisymmetric core model is first created for Nek5000 RANS simulations. 
The geometric model /and mesh are generated using the open-source meshing software, [GMSH](https://gmsh.info/). 
Note that the ex-core components in the primary loop, such as the pumps and heat exchangers, are not modeled in this work. 
Future work may consider modeling these components via porous medium models or coupling to a system level tool, such as SAM, especially for the primary heat exchanger. 
The entire model consists of the core cavity region and the inlet and outlet channels. Our scoping study shows that the curved cavity walls and the bent inlet/outlet elbows are essential in producing a relatively uniform velocity distribution inside the core cavity. Moreover, the inlet channel is extruded accordingly to have a more developed inflow condition when the molten salt enters the core, while the extrusion of outlet helps prevent the backflow issue. 
A parabolic velocity profile is specified at the inlet face and the natural pressure boundary condition is given to the outlet face. The no-slip condition is applied to all the wall surfaces. 
A pure hexahedral mesh is generated with 3,700 elements (as shown in [2d_mesh]). 
In addition, to facilitate the axisymmetric solver in Nek5000, the core centerline is rotated and aligned along the x-axis as shown in the [2d_mesh]. 
The molten salt flow enters the core from the bottom channel (left) and exits from the top (right). 
A series of 2-D axisymmetric RANS cases are simulated at multiple Reynolds numbers of $2\times10^4$, $4\times10^4$, $1\times10^5$, $4\times10^5$, and $1\times10^6$.

!media msr/msfr/nek/2d_mesh.png
    style=width:80%
    id=2d_mesh
    caption=Computational mesh of the 2-D axisymmetric MSFR core model.

In addition to the 2-D RANS models, significant efforts have been invested in generating a more representative 3-D full-core models to better predict the related thermal-fluid phenomena in the /MSFR core cavity (as shown in [3d_mesh]). 
According to the proposed MSFR designs by the Euratom EVOL project, sixteen external loops are considered in the 3-D model around the MSFR core. 
The core height, diameter, inlet/outlet widths are all kept the same as those used in the 2-D axisymmetric model.
Similar extrusion treatment is applied to the inlet and outlet faces to help the 3-D CFD model better converge. 
As mentioned earlier, the 3-D full core model is simulated with the LES approach to allow for more accurate turbulence modeling compared to the 2-D RANS models. Since a full-fledged full core LES will require considerable amount of computing power, a demonstrative full core LES case with the coarsened mesh and relatively low-polynomial order is conducted with Nek5000, which is used to prove the feasibility of a high-fidelity CFD model of the 3-D MSFR full-core. 

!media msr/msfr/nek/3D_full_core_mesh.png
    style=width:60%
    id=3d_mesh
    caption=The mesh of the 3-D MSFR full core model.

Due to the high computational costs associated with the full-core MSFR model, selected partial-core wedge models are also created accounting for 1/16 of the full core region. The related 3-D simulations are much less demanding computationally.  
As shown in [wedge_mesh], three types of wedge domains are studied to better understand how the CFD results can be influenced by the inflow boundary conditions. They are labeled as  WA, WB and WC, respectively. 
Geometry WA contains one set of inlet and outlet channels that match the  dimensions in the full core model. The side faces are assigned the symmetry boundary condition for the core region and the no-slip condition for the inlet/outlet. 
Geometry WB also includes one set of inlet and outlet channels, but they are adjusted to be a 3-D equivalent of the 2-D axisymmetic case setup. The symmetry boundary condition is applied to side faces of both core and inlet/outlet channel. 
Lastly, geometry WC includes two half sets of inlet and outlet channels where the inlet/outlet mid-planes are aligned with core side faces. The symmetry boundary condition is specified to side faces as in geometry WB.

!media msr/msfr/nek/wedge_meshes.png
    style=width:80%
    id=wedge_mesh
    caption=Computational meshes of 3 types of MSFR wedge model: top views (top) and side views (bottom).


## Nek5000 Case setups

In this section, we are going through the Nek5000 case setups. A more detailed [Nek5000 tutorial](https://nek5000.github.io/NekDoc/index.html) is available online. Readers are encouraged to read through the online tutorial first if new to Nek.
For a typical Nek5000 case, the user file +*.usr+ is where users can customize the case settings, such as model selection, boundary and initial conditions, and post-processing. And the user file is arranged into invidual code blocks. 
The 2-D axisymmetric and 3-D wedge cases are solved with the $k-\tau$ RANS model. 
To turn on the $k-\tau$ model, one can switch the model flag to 4 in the code block +usrdat3+ in the +*.usr+ file. 
An example is given below.

```language=fortran
      subroutine usrdat3()

c      implicit none

      include 'SIZE'
      include 'TOTAL'

      real wd(lx1,ly1,lz1,lelv)
      common /walldist/ wd

      logical ifcoefs

C     initialize the RANS model
      ifld_k = 3 !address of tke
      ifld_t = 4 !address of tau
      ifcoefs = .false.

C     Supported models:
c     id_m = 0 !regularized high-Re k-omega (no wall functions)
c     id_m = 1 !regularized low-Re k-omega
c     id_m = 2 !regularized high-Re k-omega SST (no wall functions)
c     id_m = 3 !regularized low-Re k-omega SST
      id_m = 4 !standard k-tau

C     Wall distance function:
c     id_w = 0 ! user specified
c     id_w = 1 ! cheap_dist (path to wall, may work better for periodic boundaries)
      id_w = 2 ! distf (coordinate difference, provides smoother function)

      call rans_init(ifld_k,ifld_t,ifcoefs,coefs,id_w,wd,id_m)

      return
      end

```


In addition, the user also needs to update the conductivity and diffusivity accounting for the contributions from RANS model. 
The following code snippet should be added in the code block +uservp+

```language=fortran

      Pr_t=coeffs(1)
      mu_t=rans_mut(ix,iy,iz,e)

      utrans = cpfld(ifield,2)
      if(ifield.eq.1) then
        udiff = cpfld(ifield,1)+mu_t
      elseif(ifield.eq.2) then !temperature
        udiff = cpfld(ifield,1)+mu_t*cpfld(ifield,2)/(Pr_t*cpfld(1,2))
      elseif(ifield.eq.3) then !tke
        udiff = cpfld(1,1)+rans_mutsk(ix,iy,iz,e)
      elseif(ifield.eq.4) then !tau
        udiff = cpfld(1,1)+rans_mutso(ix,iy,iz,e)
      endif

```


And the snippet below should be added to the block +userq+

```language=fortran

      if(ifield.eq.3) then
        qvol = rans_kSrc(ix,iy,iz,e)
        avol = rans_kDiag(ix,iy,iz,e)
      elseif(ifield.eq.4) then
        qvol = rans_omgSrc(ix,iy,iz,e)
        avol = rans_omgDiag(ix,iy,iz,e)
      endif

```


For a mesh produced by GMSH, the Nek5000 relies on the physical group ids
to specify the boundary conditions. There are 4 groups in the current case,
which covers the boundary edges of domain inlet(1), outlet(2), wall(3), and the
axisymmetric axis(4). The following code snippet showcases how the
boundary condition tags are given to the model entities.

```language=fortran
do iel=1,nelt
do ifc=1,2*ndim
   id_face = boundaryID(ifc,iel)
   if (id_face.eq.1) then         ! inlet
       cbc(ifc,iel,1) = 'v  '
   elseif (id_face.eq.2) then     ! outlet
       cbc(ifc,iel,1) = 'O  '
   elseif (id_face.eq.3) then     ! wall
       cbc(ifc,iel,1) = 'W  '
   elseif (id_face.eq.4) then     ! centerline (axisymmetric)
       cbc(ifc,iel,1) = 'A  '
   endif
enddo
enddo

do i=2,ldimt1
do e=1,nelt
do f=1,ldim*2
  cbc(f,e,i)=cbc(f,e,1)
  if(cbc(f,e,1).eq.'W  ') cbc(f,e,i)='t  '
  if(cbc(f,e,1).eq.'v  ') cbc(f,e,i)='t  '
enddo
enddo
enddo

```


Due to the large size of mesh files used by 3-D cases, original GMSH scripts are provided for 3-D Nek cases intead of the related mesh files.
The user can generate the mesh file using GMSH, and then convert it into Nek supported format (+*.re2+) using the Nek utility +gmsh2nek+. 

!alert note
When generating the mesh in GMSH using the model script, user should make sure a 2nd order mesh is generated by clicking +Set order 2+ in GMSH GUI. When exporting the mesh, please select +Version 2+ and uncheck "Save all elements". Rename the resulting mesh file if necessary so it has the +*.msh+ extension. 


As for the initial conditions, one can either utilize the trivial fields of zero
for velocity and scalars, or load the existing solutions by providing the path
to the restart file in the +par+ file. In the case of user-specified initial
conditions, one can update the +useric+ block in the user file.

```language=fortran
      subroutine useric(ix,iy,iz,eg) ! set up initial conditions
      implicit none
      include 'SIZE'
      include 'TOTAL'
      include 'NEKUSE'

      integer ix,iy,iz,e,eg

      e = gllel(eg)

      ux   = 0.0
      uy   = 0.0
      uz   = 0.0
      temp = 0.0

      return
      end

```


The specific boundary condition can be provided in the +userbc+ block. 
Since the settings of domain outlet, no-slip wall, and the
axisymmetric axis can be handled in a default manner, the `userbc()` only
contains the specifications of inlet boundary. A constant velocity is
given at the inlet, and the direction of inlet
velocity is parallel to the inlet channel.
Note that a `turb_in` function is used to compute the proper bc values
for $k$ and $\tau$ variables on the inlet boundary.

```language=fortran
subroutine userbc(ix,iy,iz,iside,eg) ! set up boundary conditions
implicit none
include 'SIZE'
include 'TOTAL'
include 'NEKUSE'
c
real wd
common /walldist/ wd(lx1,ly1,lz1,lelv)

integer ix,iy,iz,iside,e,eg
real tke_tmp,tau_tmp
e = gllel(eg)

ux   = 0.38981288981
uy   =-1.32536382536
uz   = 0.0
temp = 0.0

call turb_in(wd(ix,iy,iz,e),tke_tmp,tau_tmp)
if(ifield.eq.3) temp = tke_tmp
if(ifield.eq.4) temp = tau_tmp

return
end

```

It is recommended to use non-dimensional parameters for Nek5000 simulations.
As a result, a set of dimensionless input parameters are provided in the
current case. One of key parameters is the Reynolds number ($UL/\nu$),
which indicates the level of turbulence intensity in the system. All the key
input parameters are given in the +par+ file, and a code snippet of the velocity
solving is as follows

```language=bash
[VELOCITY]
density = 1.0
viscosity = -5.0E+04
residualTol = 1e-8
residualPROJ = yes

```

The LES case setups are relatively simpler, and one only need to provide the filter settings in +par+ file. 
An example can be found below

```language=bash
[GENERAL]
#startFrom = run13_avg/msfr0.f00001
stopAt = numSteps
numSteps = 0
dt = 1.0e-04
writeInterval = 20000
timeStepper = BDF2
filtering = explicit
filterWeight = 0.05
filterModes = 2
dealiasing = yes
extrapolation = OIFS
targetCFL = 4.0

```

Users are encouraged to check out the case files (particularly +usr+ and +par+ files) that are provided in the VTB repository
to get a better idea how the RANS and LES cases are established. 

# MSFR CFD Results

The 2-D axisymmetric RANS cases were simulated at multiple Reynolds numbers up to the reference operation condition ($Re = 10^6$) defined based on the length and flow velocity at minimum core diameter. 
For the wall-resolved unsteady RANS simulations, the first layer of grid points off the wall is kept at an average distance of $y^+ < 1.0$.  
After a quick initial transient phase, all the simulations reach a steady state. 
Taking the case of $Re = 10^6$ as an example, the corresponding steady-state solutions of non-dimensional velocity and turbulent kinetic energy (TKE) fields are shown in [2d_solution]. 
Higher velocity magnitudes are observed close to inlet and outlet elbows due to the specific geometric designs. Although a large percentage of the bulk flow at  minimum core diameter sees a stable upward flow, lower velocity regions are noticed close to bottom and top along the centerline. It might be an indicator that a 2-D axisymmetric setup is not best suited to predict MSFR core flow distribution, or it is possible that further core geometry optimization is needed. 
As for the TKE field, the regions of large TKE value correspond to where the flow is forced to change direction, indicating strong local flow mixing. 

!media msr/msfr/nek/SS_RANS_1M.png
       style=width:80%
       id=2d_solution
       caption=Steady-state solutions from the 2-D MSFR RANS simulation at Re = $10^6$: (a) velocity, (b) turbulent kinetic energy.


A closer look at the velocity field along the core centerline is shown in [2d_arrow] where velocity vectors are scaled by the local velocity magnitude. 
It is noticed that internal re-circulations are present near the core bottom (left side of the plot) and top (right side). 
In general, such re-circulations are not desired, and will affect the heat removal performance from the central core region. 

!media msr/msfr/nek/flow_arrows.png
       style=width:80%
       id=2d_arrow
       caption=Local velocity field close to core centerline with arrows indicating  velocity direction and magnitude.


The series of 2-D RANS simulations conducted at various Reynolds numbers is also useful to understand the dependency of salt flow distribution on Reynolds number (or the salt mass flow rate). 
The study can provide a guideline to coarse-mesh CFD or system codes in modeling MSFR transient scenarios, such as the reactor startup.  
[vel_dist] illustrates the axial velocity profiles at the minimum core diameter with different Reynolds numbers. 
In general, the velocity magnitude is low at the centerline ($r = 0$), and it increases steadily in the radial direction up to $r = 0.5$. When $r > 0.5$, the velocity profile seems to oscillate, and does not exhibit a common trend over different Reynolds numbers. Once a peak is reached, the velocity magnitude would drop monotonically to zero at the peripheral wall. 
It is noted that with a low Reynolds number (e.g., $Re = 2\times10^4$), the axial velocity could even have a reversed direction at the centerline. 

!media msr/msfr/nek/vel_profiles.png
       style=width:50%
       id=vel_dist
       caption=Radial distribution of axial velocity at different Reynolds numbers.


Meanwhile, the full-core LES case is performed on a mesh of 660,000 elements at a polynomial order of 5. The corresponding Reynolds number is about 20,000. A turbulent outflow treatment is applied at the outflow faces to avoid the backflow. As shown in [3d_vel], strong turbulence is being developed at the core bottom where the molten salt is injected into the core cavity. 
The regions of large velocity fluctuation correspond well to the high TKE spots revealed by [2d_solution]b. 
The LES case was simulated for 20 convective time units (CTU), where one CTU is defined as the time required for the mean flow to move a distance of one core radius (i.e., CTU$=R/U$). 
The instantaneous LES solutions are averaged over a period of 10 CTUs (from 10 to 20) to obtain the time-averaged flow field. 
A comparison of axial velocity field from 2-D axisymmetric RANS calculations and 3-D full-core LES simulations is illustrated in [vel_compare]. 
The most noticeable difference is the prediction of velocity field along the  core centerline. The 2-D RANS model significantly underpredicts the axial velocity magnitude in the related regions, indicating that the two-equation $k-\tau$ or $k-\omega$ model may have a limitation in accurately modeling the turbulence in the MSFR core cavity (at least with a 2-D axisymmetric setup). 
Other RANS turbulence models will be also considered in the subsequent studies to find out the best modeling strategy balancing accuracy and computational costs. 
The difference is also noted for the velocity field close to bottom inlet. A modest separation is observed in the LES results which does not show up in the RANS solution. This is likely attributed to axisymmetric assumption in the 2-D case setup. 
Note that the core mass flow rate is fixed in both 2-D RANS and 3-D LES cases, and it is expected for the inlet velocity to be higher in the 3-D case due to the reduced total inlet area.  
The presented LES simulation is likely a bit under-resolved due to the limited computational resources available for this work. Having said that, it is clear that a 3-D MSFR full core LES is feasible and can help reveal possible limitations of RANS modeling. 

!media msr/msfr/nek/3D_full_core_vel.png
       style=width:60%
       id=3d_vel
       caption=A volumetric rendering snapshot of instantaneous velocity field from MSFR full-core LES model at $Re = 2\times10^4$.


!media msr/msfr/nek/LES_vs_URANS.png
       style=width:60%
       id=vel_compare
       caption=Comparison of the RANS (a) and time-averaged LES (b) results of axial velocity field.


In between the fast yet less accurate 2-D simulations and the accurate but computationally demanding 3-D full-core simulations, the CFD simulations of a wedge domain can potentially achieve a good balance of efficiency and accuracy. 
As shown in [wedge_mesh], three wedge domains are considered in this work. The corresponding RANS solutions are presented in [vel_wedge] for cases WA, WB and WC. 
Note that the inlet channel in both cases WA and WC is a rectangular duct which is the same as in the 3-D full-core model. 
Meanwhile, the case WB is a 3-D equivalent of the 2-D axisymetric domain through a $22.5^\circ$ circumferential rotation. The inlet channel of case WB is a partial ring (as illustrated in [wedge_mesh]). 
As shown in [compare_wedge], it is no surprise that the case WB almost reproduces the results of the corresponding 2-D axisymmetric case. 
Compared to case WB, both case WA and WC show higher velocity magnitude close to the core centerline. Additionally, both cases WA and WC capture the modest flow separation region close to the curved wall near the inlet. 
It indicates that a proper representation of the inlet duct is important for the prediction of internal flow distribution. In other words, the axisymmetric assumption may have negative impact on the overall prediction quality. 
Due to the increase of flow area from the inlet channel to the core region, the URANS solutions from cases WA and WC exhibit some level of fluctuations. 
The fluctuations are more prominent in case WA because of the additional change in boundary condition from no-slip condition on inlet side face to the symmetry condition on core side face. 
As a result, only a quasi steady state can be reached in simulations of WA and WC. Overall, results from case WA and WC agree with each other except that WA results appear to be more oscillatory.

!media msr/msfr/nek/wedge_sol.png
       style=width:80%
       id=vel_wedge
       caption=Velocity field from the 3-D RANS simulations of the wedge domains at $Re = 2\times10^4$.


!media msr/msfr/nek/wedge_vel_profiles.png
       style=width:60%
       id=compare_wedge
       caption=Radial distribution of axial velocity from the 2-D axisymmetric and 3-D wedge cases at $Re = 2\times10^4$.
