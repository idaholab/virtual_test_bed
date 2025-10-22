# Thermal Fluid and Thermal Conduction Model

## Thermal Fluids Model

The thermal-hydraulics model for Pronghorn is based on ongoing NEAMS work [!citep](schunert2022improvements) [!citep](schunert2021deployment) with some additional improvements. The Pronghorn model uses the weakly compressible finite volume formulation for discretizing the fluid mass, fluid momentum, fluid energy, and solid energy conservation equations. The model includes a riser and bypass flow channels, and the fueling chute as an open flow region.


The cold fluid from the circulators enters the core via the vertical risers in the reflector region. The flow then enters the cold plenum, where the flow is diverted into the cavity, upper reflector, and control and shutdown system bypass channels. From the upper cavity, the fluid enters the active core region, then the lower reflector, and finally the outlet plenum.


The radiative heat transfer at the outer boundary of the reactor vessel has a small impact on steady-state calculations and a larger impact during the loss of forced cooling (DLOFC) transients. Also, during the loss of flow transient, fluid inflow and outflow boundary conditions are not changed to wall boundary conditions, which leads to a significant change in the helium leaving the core due to thermal expansion, which tends to increase temperature estimates.

The model for the thermal fluid calculations can be found in ```htgr/htr-pm-2/htr-pm-flow-fv-ss.i```.
A depiction of the geometry and materials in the Pronghorn thermal-hydraulic model and the fluid flow parth is shown in [thermo-fluid-model].

!media htrpm_coremultiphysics/htr-pm-domain.png
  style=width:50%
  id=thermo-fluid-model

The boundary condition for the Pronghorn model of the HTR-PM include:
* Inlet helium flow rate of 96.0 kg/s.
* The inlet fluid temperature is set to 523.15 K.
* The outlet fluid pressure is set to $7\times 106{6}$ Pa.
* Inlet velocity, outlet pressure, slip-wall, and symmetry boundary conditions are used for the fluid mass, momentum, and energy equations.
* All walls are assumed to be adiabatic for the fluid energy equation, and conjugate heat transfer is treated as a volumetric phenomenon.
* The solid energy equations have adiabatic boundary conditions except for the outside of the pressure vessel
* Radiative and convective boundary conditions were applied between the pressure vessel and isothermal cylindrical reactor cavity cooling system (RCCS) panel with an inner diameter of 4 m, a temperature of $T_{\infty}=300$ K, a heat transfer coefficient of 5 W/m$^{2}$.K, and a surface emissivities are assumed to be 0.8. 

The model input starts by defining geometric parameters for the problem.
Then, global parameters is defined in ```GlobalParams``` and the mesh is defined in the ```Mesh``` block

!listing htgr/htr-pm/core-multiphysics/updated_equilibrium_core/htr-pm-flow-fv-ss.i block=GlobalParams

!listing htgr/htr-pm/core-multiphysics/updated_equilibrium_core/htr-pm-flow-fv-ss.i block=Mesh

The model is solved in R-Z coordinates as is demonstrated in the ```Problem``` block

!listing htgr/htr-pm/core-multiphysics/updated_equilibrium_core/htr-pm-flow-fv-ss.i block=Problem

The definition of the pronghorn Navier-Stokes equation for the solution of the weakly-compressible fluid, and the properties of the fluid go into ```Modules``` block.

!listing htgr/htr-pm/core-multiphysics/updated_equilibrium_core/htr-pm-flow-fv-ss.i block=Modules

Material properties are defined in the ```Materials``` block

!listing htgr/htr-pm/core-multiphysics/updated_equilibrium_core/htr-pm-flow-fv-ss.i block=Materials

The characteristics of the execution of the problem are defined in ```Executioner``` block

!listing htgr/htr-pm/core-multiphysics/updated_equilibrium_core/htr-pm-flow-fv-ss.i block=Executioner

And control of output is defined in ```Outputs``` block

!listing htgr/htr-pm/core-multiphysics/updated_equilibrium_core/htr-pm-flow-fv-ss.i block=Outputs


## Pebble Conduction Model:

The pebble heat conduction model solves the 1D spherical conduction problem assuming a thermal equilibrium approximation in pebble simulations during transient calculations.
Several sources of heat transfer nonuniformity around the pebble were ignored: the coolant flow orientation, pebble-to-pebble contact, pebble-to-reflector contact, and radiation.
A Dirichlet boundary condition is set at the TRISO surface to obtain the fuel temperature, and a Neumann boundary condition would improve energy conservation.

The model of the pebble conduction is found in ```/htgr/htr-pm-2/pebble_triso.i```.
In this model, the mesh is defined as follows

!listing htgr/htr-pm/core-multiphysics/updated_equilibrium_core/pebble_triso.i block=Mesh

The model also defines pebble and TRISO temperatures as follows

!listing htgr/htr-pm/core-multiphysics/updated_equilibrium_core/pebble_triso.i block=Variables

Materials are defined in ```Materials``` block

!listing htgr/htr-pm/core-multiphysics/updated_equilibrium_core/pebble_triso.i block=Materials

materials thermal conductivity and burnup are defined in ```Functions``` block:

!listing htgr/htr-pm/core-multiphysics/updated_equilibrium_core/pebble_triso.i block=Functions

These properties are linked to a type of object in the ```UserObject``` block as follows 

!listing htgr/htr-pm/core-multiphysics/updated_equilibrium_core/pebble_triso.i block=UserObjects

The boundary condition is applied in the ```BCs``` block

!listing htgr/htr-pm/core-multiphysics/updated_equilibrium_core/pebble_triso.i block=BCs

Finally, the characteristics of the execution process are provided in

!listing htgr/htr-pm/core-multiphysics/updated_equilibrium_core/pebble_triso.i block=Executioner
