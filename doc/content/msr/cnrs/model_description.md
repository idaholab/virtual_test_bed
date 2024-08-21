# CNRS Model

CNRS molten salt reactor (MSR) benchmark is a numerical benchmark created to establish a verification 
problem for couple-physics (i.e. neutronics and thermal-hydraulics) simulation. It was originally 
developed by French National Center for Scientific Research (CNRS) Aufiero 2015.
The problem is a 2x2 lid-driven cavity filled with molten salt fuel with homogenous composition at 
900 K flowing at the top at upper surface of the cavity as shown in the picture. Details for the fuel 
composition and delayed neutron parameters can also be found in Jaradat et al. 2024.
No slip boundary conditions with a fluid velocity of zero are applied across the boundaries of the 
geometry, except for the upper surface where the fluid moves with a determined velocity $U_\text{lid}$.
The model implements adiabatic boundary conditions across the geometry walls.
A heat sink is introduced to the builk of the fluid to represent cooling process.
The heat sink is modeled using a newton heat law like model as in

$q^{\prime \prime \prime}=\gamma \left(T_0-T\right)$

Neutronically, the model is solved using a diffusion model.
Cross sections are generated only at 900 K.
The feedback from the thermal hydraulic solution is applied on the fuel salt density and Doppler effect
is neglected.
The change in fuel density is expressed by a linear model as

$\rho(T) = \rho(T_0)\left(1-\alpha(T-T_0)\right)$

The change in density is applied to the macroscopic cross section as

$\Sigma_x(T) = \Sigma_x(T_0) \frac{\rho(T)}{\rho(T_0)}$


# References
Aufiero, M. (2015). Serpent-OpenFOAM coupling for criticality accidents modelling--Definition of a benchamrk 
for MSRs multiphysics modelling. SERPENT and Multiphysics Workshop.

Jaradat, M. K., Choi, N., & Abou-Jaoude, A. (2024). Verification of Griffin-Pronghorn-Coupled Multiphysics 
Code System Against CNRS Molten Salt Reactor Benchmark. Nuclear Science and Engineering, 1-34.
