# MSFR Nek5000 CFD modeling

*Contact: Jun Fang, fangj.at.anl.gov*

Computational Fluid Dynamics (CFD) plays an unique role in the research and development (R&D) of 
Molten Salt Fast Reactor (MSFR). As a great complement to expriments, it offers a cost effective 
way to study the complex thermal fluid physics expected in the MSFR system. 
For certain advanced nuclear reactor concepts (e.g., MSFR) where the related experimental data is 
not available or very scarce, CFD also provides much needed reference to develop and calibrate
reactor design tools. 
In this VTB documentation, you will find examples of a series of CFD simulations developed to model
the coolant flow in MSFR core cavity. 
The related models range from relatively low-cost 2-D Reynolds-Averaged Navier Stokes (RANS) 
simulations to more accurate 3-D Large Eddy Simulations (LES). 
The NEAMS signature CFD code, [Nek5000](https://github.com/Nek5000/Nek5000) is used here for the 
corresponding CFD calculations. 
Nek5000 is an open source CFD code based on the spectral element method (SEM) with
a long history of application in reactor thermal-hydraulics
research [!citep](Merzari2017).
Though the various CFD modeling appraoches and case studies, one primary motivation is to seek 
an in-depth understanding of how the internal velocity distribution can be influenced by 
the MSFR core cavity shape, the Reynolds number, turbulence modeling options and the inlet 
boundary conditions.
In the following sections, we will go through all the components one would expect in a
typical CFD investigation, and provide detailed descrptions about the numerical methods, case steups,
key results and discoveries. 

!alert note
This documentation assumes that reader has the basic knowledge of Nek5000, and is able to run 
the example cases provided in [Nek5000 tutorial](https://nek5000.github.io/NekDoc/index.html)


## CFD solver and turbulence modeling

Nek5000 is based on the Spectrum Element Methold (SEM), which combines the accuracy of 
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
core flow simulations, the RANS model would be the most practical option .
A 2-D axisymmetric MSFR core model is documented herein, which will hopefully
serve as an useful example for anyone who is interested in using Nek5000 for
MSFR related fluid problems.

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
The $k-\tau$ model in Nek5000 has been benchmarked extensively across a variety
of canonical cases including channel flow and the backward facing step, and it
has been also applied to fuel rod bundle geometry. Interested readers
can refer to the recent publication [!citep](Fang2021) for more details regarding
the $k-\tau$ application and validation in fuel rod bundles.  

## Geometric model and the meshing

A 2-D axisymmetric core model is first studied with the Nek5000 RANS solver.
Based on the core dimensions listed in the
[description of the reactor](msfr/reactor_description.md),
a 2-D geometric model is generated using the open source meshing software,
[GMSH](https://gmsh.info/).  The entire model include the core region
and part of the inlet and outlet channels. A pure hexahedral mesh is produced
with 2,700 elements (as shown in [msfr_mesh]). In addition,
to facilitate the axisymmetric solver in Nek5000, the core centerline is assigned
along the x direction. The molten salt flow comes from the bottom channel (low x side)
and exits from the other side.

!media msfr_nek_mesh.jpg
    style=width:80%
    id=msfr_mesh
    caption=The computational grid of 2-D MSFR core.


## Nek5000 Case setups

In this section, we are going through the detailed setup of the Nek5000 case.
The 2-D axisymmetric core case will be solved with the
$k-\tau$ RANS model. To turn on the $k-\tau$ model, one can specify the model flag
to 4 in the Nek user file. An example is given below.

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

As for the initial conditions, one can either utilize the trivial fields of zero
for velocity and scalars, or load the existing solutions by providing the path
to the restart file in the `par` file. In the case of user-specified initial
conditions, one can update the `useric` function in the user file.

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

The specific values of boundary condition can be provided in the `userbc()`
funciton. Since the settings of domain outlet, no-slip wall, and the
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
input parameters are given in the `par` file, and a code snippet of the velocity
solving is as follows

```language=bash
[VELOCITY]
density = 1.0
viscosity = -5.0E+04
residualTol = 1e-8
residualPROJ = yes

```

# MSFR Nek5000 CFD Results

The steady-state solutions of velocity and turbulent kinetic energy (TKE) field 
in the MSFR core from the 2-D axisymmetric RANS case are shown
below. 

!media msfr_nek_2D_U.jpg
       style=width:80%
       id=msfr_vel
       caption=The steady-state velocity field from the 2-D MSFR RANS simulation.

!media msfr_nek_2D_TKE.jpg
       style=width:80%
       id=msfr_tke
       caption=The steady-state TKE field from the 2-D MSFR RANS simulation.

It is noticed that the velocity magnitude is higher in the peripheral 
region compared to core center, which is related to the velocity 
boundary condition given at the inlet. As for the TKE field, 
the regions of high  TKE value indicate strong local flow mixing. 
A velocity field with arrows is shown in [msfr_vel_vector] to illustrate 
the velocity directions and magnitudes of specific locations inside the core. 


!media msfr_nek_2D_U_Arrows.jpg
       style=width:80%
       id=msfr_vel_vector
       caption=The steady-state velocity field with arrows indicating local
       velocity directions. 

!alert note
It has been noticed that the flow field solutions are sensitive to the
inlet boundary conditions. The results shown above are the steady-state
solutions with a constant inlet velocity, which is not necessarily the case
in the actual MSFR. Additional studies are being conducted to reproduce the 
realistic inlet BC, which will help further improve the results. 