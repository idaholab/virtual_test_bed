# Molten Salt Fast Reactor (MSFR) SAM Model

*Contact: Jun Fang, fangj.at.anl.gov; Mauricio Tano, mauricio.tanoretamales.at.inl.gov*

*Model link: [Standalone SAM Model](https://github.com/idaholab/virtual_test_bed/tree/main/msr/msfr/plant/standalone_sam_model)*

!tag name=Molten Salt Fast Reactor SAM Model
     description=Model of the Euratom EVOL MSFR using SAM with 1D thermal hydraulics and point kinetics
     image=https://mooseframework.inl.gov/virtual_test_bed/media/msr/msfr/plant/MSFR_SAM_1D.png
     pairs=reactor_type:MSR
                       reactor:MSFR
                       geometry:primary_loop
                       simulation_type:thermal_hydraulics
                       codes_used:SAM
                       transient:steady_state;ULOF
                       input_features:checkpoint_restart
                       computing_needs:Workstation
                       fiscal_year:2021
                       institution:ANL
                       sponsor:NEAMS

## MSFR Overview

The specific reactor model considered here is based upon the MSFR design developed under the Euratom EVOL project [!citep](rouch2014).
The reference MSFR is a 3000 MW fast-spectrum reactor with three different circuits: the fuel circuit, the intermediate circuit, and the power conversion circuit.
Based upon the design specifications of EVOL MSFR, representative 1-D system models were established for the MSFR concept covering both the fuel/primary and intermediate circuits, whereas the only the heat exchanger of the energy conversion unit is modeled.
The ex-core loops in the primary and intermediate circuits are lumped together, and only one loop is considered in both circuits.


### Fuel loop style=font-size:125%

In the SAM simulation, the core is modeled as a pipe of length $2.65 \, m$ and hydraulic diameter of $2.1 \, m$.
In the fuel circuit, there are 16 sets of pumps and heat exchangers around the core.
The heat exchangers are treated via one equivalent lumped heat exchanger, whereas all pumps are similarly modeled as one equivalent pump.
The fuel salt in the fuel loop is LiF-ThF$_4$ (0.78-0.22).
The corresponding thermophysical properties are listed in [fuel_salt_properties], based on which dedicated Equations of States (EOS) have been created in SAM input file to model the fuel salt.
The pump power is set so that the total mass flow rate in the fuel circuit is $18,000 \, \frac{kg}{s}$, and the initial core inlet temperature is $950 \, K$.

!table id=fuel_salt_properties caption=Thermophysical properties of the fuel salt.
|   |   | Unit  | LiF-ThF$_4$ (78%-22%) |
| :- | :- | :- | :- |
| Density | $\rho$ | $kg/m^3$  | $4983.56-0.882\bullet T$ |
| Dynamic viscosity | $\mu$ | $mPa\bullet s$ | $\rho \left( 5.54\times 10^{-5} e^{4340/T} \right)$ |
| Thermal conductivity | $k$ | $W/(m\bullet K)$ | $0.928 + 8.397 \times 10^{-5} \bullet T$ |
| Specific heat capacity | $c_p$ | $J/(kg\bullet K)$ | $-1111 + 2.78 \times T$ |


### Intermediate loop style=font-size:125%

The intermediate circuit is thermally coupled to the primary circuit through the primary heat exchanger.
The primary heat exchanger model adopts a shell-and-tube design, which has a height of $2.4 \, m$.
The primary heat exchanger parameters, such as the flow areas, hydraulic diameters, heat transfer area density, are tailored to meet the specific heat removal rate (i.e., $3000 \, MW$ in the current work).
The coolant salt selected for the intermediate circuit is LiF-BeF$_2$, of which the related thermophysical properties are provided in [intermediate_salt_properties].
The primary heat exchanger is made of Hastelloy® N alloy with the thermophysical properties listed in [hastelloy_properties].
A set of EOS was generated to the model the coolant salt in the SAM input file.
The intermediate-to-secondary heat exchanger has a height of $3.2 \, m$.
Meanwhile, the energy conversion circuit is Helium based Joule-Brayton cycle, and the MOOSE built-in Helium EOS is used.

!table id=intermediate_salt_properties caption=Thermophysical properties of the intermediate circuit salt.
|   |   | Unit  | LiF-BeF$_2$ (66%-34%) |
| :- | :- | :- | :- |
| Density | $\rho$ | $kg/m^3$  | $2146.3-0.4884\bullet T$ |
| Dynamic viscosity | $\mu$ | $mPa\bullet s$ | $0.116 e^{3755/T}$ |
| Thermal conductivity | $k$ | $W/(m\bullet K)$ | $1.1$ |
| Specific heat capacity | $c_p$ | $J/(kg\bullet K)$ | $2390$ |

!table id=hastelloy_properties caption=Properties of Hastelloy® N alloy.
|   |   | Unit  | Hastelloy® N |
| :- | :- | :- | :- |
| Density | $\rho$ | $kg/m^3$  | $8860$ |
| Thermal conductivity | $k$ | $W/(m\bullet K)$ | $23.6$ |
| Specific heat capacity | $c_p$ | $J/(kg\bullet K)$ | $578$ |

### Energy conversion loop style=font-size:125%

The energy conversion system is modeled as the boundary condition to the secondary/cold side of intermediate-to-secondary heat exchanger.
The helium enters the secondary side of intermediate heat exchanger at a temperature of $673.15 \, K$ and at an inflow velocity of $66.65 \, \frac{m}{s}$, and at a corresponding pressure of $75 \, bar$.

## SAM 1D Model

### Steady state modeling style=font-size:125%

The power of the core in the SAM 1D-model can be obtained from multiple approaches. For example, with the overlapping domain coupling scheme, the 1-D SAM model can get a power distribution from the coupled [Griffin-Pronghorn model](msfr/griffin_pgh_model.md).
As for the standalone SAM 1-D model, a point kinetic equation (PKE) model is employed to model the neutronics and returns the power profile.
Here we consider six delayed neutron precursor groups. The corresponding decay constants and fractions are listed in Table 4-4 based on Griffin calculations. The total reactivity feedback considered is $-4.664 \, pcm/K$.

!table id=dnp_groups caption=Delayed neutron precursor groups used in SAM PKE modeling of MSFR.
| DNP Group $i$  | $\beta_i$  | $\lambda_i (s^{-1})$  |
| :- | :- | :- |
| 1 | 8.42817E-05 | 1.33104E-02 |
| 2 | 6.84616E-04 | 3.05427E-02 |
| 3 | 4.79796E-04 | 1.15179E-01 |
| 4 | 1.03883E-03 | 3.01152E-01 |
| 5 | 5.49185E-04 | 8.79376E-01 |
| 6 | 1.84087E-04 | 2.91303E+00 |

The 1-D MSFR system model is simulated until reaching a steady state, and the steady-state temperature distribution is illustrated in [msfr_sam].
As expected, the fuel salt is heated inside the core, and transfers heat to the coolant in intermediate circuit through the primary heat exchanger.
The heat is then transferred to the energy conversion circuit via the intermediate-to-secondary heat exchanger.
The actual mass flow rates are $18,086 \, \frac{kg}{s}$, $16,847 \, \frac{kg}{s}$, and $2,571 \, \frac{kg}{s}$ for the three circuits, respectively.
The core inlet temperature is $951.68 \, K$ and the outlet temperature is $1050.92 \, K$.
A fuel temperature rise of $99.23 \, K$ is obtained along the core, which matches well with the design specification of $100 \, K$.
The temperature rise of the secondary-side coolant salt is about $74.25 \, K$ after flowing through the primary heat exchanger, while the temperature rise of helium flow is about $224.52 \, K$ after flowing out of the intermediate heat exchanger.

!media msr/msfr/plant/MSFR_SAM_1D.png
       style=width:60%
       id=msfr_sam
       caption=The steady-state temperature distribution in the 1-D MSRE primary loop (+Pump1+ and +HX1+ are primary pump and heat exchanger while +Pump2+ and +HX2+ are intermediate pump and heat exchanger).


### Transient modeling style=font-size:125%

Two transient scenarios are considered here for the standalone 1-D MSFR SAM model:

- $50 \%$ pump head loss for the primary pump in $40 \, s$,
- Total pump trip of the primary pump in $60 \, s$.

The transient cases were restarted from the steady-state solutions, and the pump head change is initiated at $t = 120 \, s$. The neutronics response is modeled by the Point Kinetics Equations (PKE).
As shown in [msfr_mass], right after the change in primary pump head, the fuel mass flow rate started to decrease. For the transient case of $50 \%$ pump head loss, a new steady state was reached at $70 \%$ the original mass flow rate.
As for the case of total pump trip, the fuel mass flow rate drops significantly and the new converged mass flow rate is only $12 \%$ the original value. Under the new steady-state after the pump trip, natural circulation becomes the dominant mechanism to drive the fuel circulation of primary circuit.

!media msr/msfr/plant/sam_msfr_mass_flow.jpg
       style=width:60%
       id=msfr_mass
       caption=Evolution of fuel mass flow rates during the investigated transient scenarios.

Meanwhile, due to slower mass flow rate, the fuel is heated for longer period of time inside the core. As a result, the core outlet temperature started to rise after the pump head drop as shown in [core_temp]. For the case of $50 \%$ pump head loss, the core outlet temperature is observed to be $20 \, K$ higher than that with normal operating condition.
While with the total pump trip, the core outlet temperature can be $163 \, K$ higher. Due to the negative temperature feedback coefficient, the reactor power decreases as the core temperature rises.
As shown in [reactor_power], the reactor power drops about $3.3 \%$ when the primary pump loses half of its capacity, and about $53 \%$ when the primary pump stops working. This well demonstrates the passive safety of MSFR design.  The corresponding temperature rise along the core is $136 \, K$ for $50 \%$ pump head loss scenario and $424 \, K$ for the pump trip case.

!media msr/msfr/plant/sam_msfr_outlet_temp.jpg
       style=width:80%
       id=core_temp
       caption=Evolution of core inlet and outlet temperatures during the investigated transient scenarios: (a) 50% pump head loss, (b) pump trip.

!media msr/msfr/plant/sam_msfr_reactor_power.jpg
       style=width:80%
       id=reactor_power
       caption=Evolution of reactor power during the investigated transient scenarios: (a) 50% pump head loss, (b) pump trip.

## Input Description

The SAM input file adopts a block structured syntax, and each block contains the detailed settings of specific SAM components.
In this section, we will go through all the important blocks in the input file and explain the key model specifications.

### GlobalParams style=font-size:125%

This block contains the global parameters that are applied to all SAM components, such as the initial pressure, velocity, and temperature and the scaling for the solid temperature variables.
A snippet is illustrated below:

```language=bash

  global_init_P = 1e5 # Initial pressure
  global_init_V = 0.01 # Initial velocity
  global_init_T = 898.15 # Initial temperature
  Tsolid_sf     = 1e-3 # Scaling factor for solid temperature variable

```

### EOS (Equations of State) style=font-size:125%

This block specifies the material properties, such as the thermophysical properties.
These ones include the fuel salt, intermediate loop salt, and pressurized helium in the secondary loop.

SAM supports both constants and user-defined functions for the thermophysical parameters in the EOS.
The properties of common materials are implemented in the SAM repository, and can be readily used by
simply referring to the material IDs, such as the air, or molten salt FLiBe.

!listing msr/msfr/plant/standalone_sam_model/msfr_1d_ss.i  block=EOS language=cpp

### Components style=font-size:125%

This is the most important block that defines all the reactor components represented in the MSRE primary loop, such as the core, the heat exchanger, the pump, and all the connecting pipes.
The Table below lists all the reactor components considered

!table id=msre_components caption=The reactor components represented in MSRE primary loop.
| Loop | Component | ID | Description  |
| :- | :- | :- | :- |
| Primary Loop | Core | MSFR_core | The MSFR core |
| Primary Loop  | Pipe 1 | pipe1 | Pipe from reactor core to primary heat excahnger |
| Primary Loop | Pipe 2 | pipe2 | Outlet pipe from the reactor core |
| Primary Loop | Pump 1 | pump | Primary loop pump |
| Primary Loop | HX1 | IHX1 | Primary-to-intermediate heat exchanger |
| Primary Loop | HX1 Primary Pipe | IHX1:primary_pipe | Pipe on the primary side of HX1 |
| Primary Loop | Pipe 3 | pipe3 | Pipe from HX1 output to reactor core inlet |
| Intermediate Loop | HX1 Secondary Pipe | IHX1:secondary_pipe | Pipe on the secondary side of HX1 |
| Intermediate Loop | Pipe 4 | pipe4 | Outlet pipe from HX1 on the secondary side |
| Primary Loop | Pump 2 | pump2 | Intermediate loop pump |
| Intermediate Loop | HX2 | IHX2 | Intermediate-to-secondary heat exchanger |
| Intermediate Loop | Pipe 5 | pipe5 | Admission pipe into HX2 |
| Intermediate Loop | HX2 Primary Pipe | IHX2:primary_pipe | Pipe on the primary side of HX2 |
| Intermediate Loop | Pipe 6 | pipe6 | Outlet pipe from HX2 on the primary side |
| Intermediate Loop | Pipe 7 | pipe7 | Pipe connecting pipe 6 and pipe 8 |
| Intermediate Loop | Pipe 8 | pipe8 | Admission pipe into HX1 on the secondary side |
| Secondary Loop | HX2 Secondary Pipe | IHX2:secondary_pipe | Pipe on the secondary side of HX2 |


As for the counterflow, primary-to-intermediate shell-and-tube heat exchanger, both sides are modeled with 1-D channel components.
The heat is exchanged through the 1-D wall coupling the shell and tube sides.
A similar model is used for the secondary heat exchanger, except that pressurized Helium is used in the secondary side instead of salt.

!listing msr/msfr/plant/standalone_sam_model/msfr_1d_ss.i  block=IHX1 language=cpp

!listing msr/msfr/plant/standalone_sam_model/msfr_1d_ss.i  block=IHX2 language=cpp

The primary pump is placed between between the outlet to the core and the primary heat exchanger.
The input parameters for the primary and intermediate circuits pumps are specified here below:

!listing msr/msfr/plant/standalone_sam_model/msfr_1d_ss.i  block=pump language=cpp

!listing msr/msfr/plant/standalone_sam_model/msfr_1d_ss.i  block=pump2 language=cpp


The detailed instructions of these SAM components can be found in the SAM user manual, which are not repeated here for brevity.

### Postprocessors style=font-size:125%

The Postprocessors block is used to monitor the SAM solutions during the simulations, and quantities of interest can
be printed out in the log file. For example, to check out the core outlet temperature, one can add the following snippet:

!listing msr/msfr/plant/standalone_sam_model/msfr_1d_ss.i block=Core_T_out language=cpp

### Preconditioning style=font-size:125%

This block describes the preconditioner used by the solver.
New user can leave this block unchanged.

!listing msr/msfr/plant/standalone_sam_model/msfr_1d_ss.i block=Preconditioning

### Executioner style=font-size:125%

This block describes the calculation process flow. The user can specify the start time, end time, time step size for the simulation. Other inputs in this block include PETSc solver options, convergence tolerance, quadrature for elements, etc., which can be left unchanged.

!listing msr/msfr/plant/standalone_sam_model/msfr_1d_ss.i block=Executioner

### Modeling the transient conditions style=font-size:125%

Based upon the steady-state solutions, the transient simulations can be initiated by adjusting the primary pump head. A user defined function as shown below is used to linearly reduce the pump head from $100 \%$ to $50 \%$ in $40 \, s$. Similar implementation is also applied in the pump trip modeling.
Once the primary pump head changes, the MSFR SAM system model would start responding accordingly, and eventually new steady states are established with $50 \%$ or $0 \%$ original pump head.

!listing msr/msfr/plant/standalone_sam_model/msfr_1d_transient_01.i block=head_func

!listing msr/msfr/plant/standalone_sam_model/msfr_1d_transient_01.i block=pump

## Run Command

To run the related SAM system models, one can use the command below.

```language=bash

sam-opt -i msfr_1d_ss.i

```

!alert note
The steady-state model has to be simulated before the transient modeling because the input files of transient models will use the checkpoint file from steady-state calculation as the initial condition.
