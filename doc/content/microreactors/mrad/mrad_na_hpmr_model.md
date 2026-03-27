# Na-HPMR Multiphysics Model

*Contact: Yinbin Miao (ymiao.at.anl.gov)*

*Primary Contributors: Yinbin Miao, Yan Cao, Ahmed Abdelhameed*

*Model link: [HPMR Model](https://github.com/idaholab/virtual_test_bed/tree/devel/microreactors/mrad)*

## Inheritance from K-HPMR Model

!alert note title=Acknowledgement
This model is a sodium heat pipe variant of the K-HPMR model. For majority of the model description, please refer to the [K-HPMR Multiphysics Model](mrad/mrad_model.md).

The motive for developing a sodium (Na) working fluid variant of the HPMR design is to better utilize the mechanistic heat pipe model (i.e., liquid-conductance vapor-flow (LCVF) model, also known as the "vapor-only" model) in Sockeye [!citep](hansel2024liquid) to enable advanced modeling features such as the start up transient. In the meantime, the majority of the HPMR design parameters are kept the same as the K-HPMR design. The Na-HPMR design is identical to the K-HPMR design except for the heat pipe working fluid. To better fit the operating temperature range of sodium, the design temperature is increased by 100 K.

## Model Update for Na-HPMR

Aside from the increased design operating temperature, the main modifications made to generate the Na-HPMR variant are related to the switch of the heat pipe working fluid from potassium to sodium and the adoption of the Sockeye LCVF heat pipe model. Additionally, the cross-section is also updated to match the replacement of the potassium working fluid with sodium. On the other hand, the Griffin and BISON models are directly inherited from the [K-HPMR model](mrad/mrad_model.md).

### Cross-Section Generation Using Serpent Code

Similar to the K-HPMR model, the first step involves generating homogenized multi-group cross sections using `Serpent-2`. The Serpent-2 model for the Na-HPMR is similar to that of the K-HPMR, except that sodium is employed as the working fluid in the heat pipes instead of potassium (K). An `11-group energy structure` is employed, with parameters defined over grids of:

1. `Fuel temperature` (5 values)
2. `Temperature of the moderator, reflector, monolith, and heat pipe` (5 values)
3. `Hydrogen content` (7 values)
4. `Control drum rotation`  (1 value: control drums out)

The results obtained from Serpent-2 are consistent with expected reactor physics:

- Increasing the hydrogen content within the tabulated range (from YH$_{0.5}$ to YH$_2$) yields a higher $k_{eff}$ value, due to enhanced moderation.
- Increasing the fuel temperature consistently reduces $k_{eff}$, reflecting the negative reactivity feedback from Doppler broadening.

This multi-grid cross-section library enables analysis of thermal reactivity feedback effects as well as the impacts of hydrogen redistribution within the moderator. At present, simulations are being carried out for the `control rod–out` configuration.

Finally, the generated cross sections are converted into an `XML-file format` for compatibility with `Griffin`.


### Sockeye Model

For each heat pipe in the 1/6 HP-MR core, a Sockeye grandchild application is used to calculate its thermal performance.

Instead of the effective thermal conductance model used in the K-HPMR model, the LCVF heat pipe model is adopted in the Na-HPMR model. As the name implies, the advanced heat pipe model uses a mechanistic flow model to predict the heat transfer performance of the heat pipe kernel.

!listing /mrad/steady_Na/HPMR_sockeye_ss.i max-height = 10000

## Steady-State Case Simulation

The steady-state simulation of this Na-HPMR is performed to establish the baseline performance of the microreactor design. This also serves as the initial conditions or reference status for the following transient simulations.

## Transient Simulation

Two types of transient simulations are constructed for the Na-HPMR model: the former is the loading following transient simulation, which is similar to the load following transient simulation performed for the K-HPMR configuration; the latter is the startup transient simulation, which mainly demonstrate the Sockeye LCVF heat pipe model's capability in modeling the heat pipe startup process in a full-core multiphysics scheme.

### Load Following Transient Simulation

The load following transient simulation for the Na-HPMR is performed using the same approach as the counterpart simulation for the K-HPMR. The transient is initiated by a significant reduction in the heat removal capability of the secondary coolant loop through alterning the condensor envelope surface boundary condition in the Sockeye model. The heat transfer coefficient (HTC) of that convective boundary condition is reduced by 99.99% (i.e., from 10$^6$ W/m$^2$-K to 100 W/m$^2$-K) to mimic the loss of heat removal capability in the secondary coolant loop. The transient simulation is performed for 2,000 seconds.

### Startup Transient Simulation

The startup transient simulation is conducted using a different and simplified approach compared to the load following transient simulation. The reactivity startup of the microreactor is achieved by precise control of the control drum rotation to compensate the reactivity feedback from the increasing temperature to maintain a designated power ramping profile. Such a startup procedure would be expensive to perform if a high-fidelity neutronics modeling approach is used. Alternatively, the startup neutronics can be modeled using point kinetics with a much lower computational cost. However, as the focus of the startup transient simulation is to demonstrate the capability of the Sockeye model in a multiphysics scheme instead of the neutronics behavior during startup, it is not essential to include a low-fidelity neutronics model such as point kinetics in the model. Instead, the startup transient simulation is performed by directly controlling the power ramping profile in the BISON model, while the Griffin model is bypassed. A linear power ramping profile which reaches the nominal power within 3,600 seconds is used for the startup transient simulation. The temperature evolution in different reactor components and the activation of the heat pipes are the focus of the analysis. It is also worth noting that the startup transient involved here is not a frozen startup. Instead, the initial temperature is set at 700 K, which is lower than the activation temperature of the sodium work fluid but high than the melting point of sodium.

To establish this initial state, the external boundary temperature at the condenser was reduced from 900 K to 700 K. To maintain a steady state condenser temperature of ~900 K at full power despite the 700 K external boundary, the heat transfer coefficient was adjusted to 152 W/m²K. This configuration holds the condenser near 900 K at approximately 1800 W per heat pipe (the design power level). While this simplified boundary condition effectively captures the desired startup temperature behavior, a coupled, high-fidelity secondary system model will be integrated in the near future for more realistic simulations.