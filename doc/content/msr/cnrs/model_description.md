# CNRS Model

*Contact: Mustafa Jaradat, Mustafa.Jaradat@inl.gov*

*Model summarized and documented by Khaldoon Al-Dawood

*Model link: [CNRS Model](https://github.com/idaholab/virtual_test_bed/tree/devel/msr/cnrs)*

!tag name=CNRS Griffin-Pronghorn Steady State Model pairs=reactor_type:MSR
                       reactor:CNRS
                       geometry:core
                       simulation_type:multiphysics
                       transient:steady_state
                       input_features:multiapps
                       codes_used:BlueCrab;Griffin;Pronghorn
                       computing_needs:Workstation
                       fiscal_year:2024
                       institution:INL
                       sponsor:NEAMS;NRIC

CNRS molten salt reactor (MSR) benchmark is a numerical benchmark created to establish a verification 
problem for couple-physics (i.e. neutronics and thermal-hydraulics) simulation. It was originally 
developed by French National Center for Scientific Research (CNRS) [!citep](aufiero2015serpent).
The problem is a 2x2 lid-driven cavity filled with molten salt fuel with homogeneous composition at 
900 K flowing at the top at upper surface of the cavity as shown in the picture. 
A visual demonstration of the benchmark geometry is shown in the following figure

!media media/msr/cnrs/cnrs-model.png
  style=width:50%
  caption=CNRS benchmark geometry.

Details for the fuel composition and delayed neutron parameters can also be 
found in [!citep](jaradat2024verification).
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

To demonstrate the different physics solution in this problem, the modeling of the
benchmark is performed in phases.
Following is a brief presentation of the phases

- Phase 0: Composed of three steps of steady state single physics problems

  - Step 0.1: Solves the steady state velocity field of the salt with $U_\text{lid} = 0.5$ m/s
  - Step 0.2: Solves the neutron criticality eigenvalue problem.
  - Step 0.3: Using velocity field obtained from Step 0.1 and the power profile obtained from
              Step 0.2, the temperature profile is calculated.

- Phase 1: Composed of four steady state multiphysics coupling tests (steps)

  - Step 1.1: Using the velocity field obtained in step 0.1, the drifting of delayed 
              neutron precursors distribution is obtained
  - Step 1.2: Using the velocity field obtained in step 0.1, the temperature feedback 
              is introduced to assess its impact on the reactivity and fission rate
  - Step 1.3: Perform fully coupled modeling of the system with a zero velocity 
              boundary condition at the cavity lid
  - Step 1.4: Using a combination of reactor powers and lid velocities, fully coupled 
              simulations are performed

- Phase 2: A single step multiphysics model of the CNRS.


# References

Aufiero, M. (2015). Serpent-OpenFOAM coupling for criticality accidents modelling--Definition of a benchamrk 
for MSRs multiphysics modelling. SERPENT and Multiphysics Workshop.

Jaradat, M. K., Choi, N., & Abou-Jaoude, A. (2024). Verification of Griffin-Pronghorn-Coupled Multiphysics 
Code System Against CNRS Molten Salt Reactor Benchmark. Nuclear Science and Engineering, 1-34.

