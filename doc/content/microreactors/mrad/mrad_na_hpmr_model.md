# Na-HPMR Multiphysics Model

*Contact: Yinbin Miao (ymiao.at.anl.gov), Ahmed Abdelhameed (aabdelhameed.at.anl.gov)*

*Model link: [HPMR Model](https://github.com/idaholab/virtual_test_bed/tree/devel/microreactors/mrad)*

## Inheritance from K-HPMR Model

!alert note title=Acknowledgement
This model is a sodium heat pipe variant of the K-HPMR model. For majority of the model description, please refer to the [K-HPMR Multiphysics Model](mrad/mrad_model.md).

The motive for developing a sodium (Na) working fluid variant of the HPMR design is to better utilize the mechanistic heat pipe model (i.e., liquid-conductance vapor-flow (LCVF) model, also known as the "vapor-only" model) in Sockeye [!citep](hansel2024liquid) to enable advanced modeling features such as the start up transient. In the meantime, the majority of the HPMR design parameters are kept the same as the K-HPMR design. The Na-HPMR design is identical to the K-HPMR design except for the heat pipe working fluid. To better fit the operating temperature range of sodium, the design temperature is increased by 100 K.

## Model Update for Na-HPMR

Aside from the increased design operating temperature, the main modifications made to generate the Na-HPMR variant are related to the switch of the heat pipe working fluid from potassium to sodium and the adoption of the Sockeye LCVF heat pipe model. Additionally, the cross-section is also updated to match the replacement of the potassium working fluid with sodium. On the other hand, the Griffin and BISON models are directly inherited from the [K-HPMR model](mrad/mrad_model.md).

### Cross-Section Generation Using Serpent Code

Similar to the K-HPMR model, the first step involves generating homogenized multi-group cross sections using **Serpent-2**. The Serpent-2 model for the Na-HPMR is similar to that of the K-HPMR, except that sodium is employed as the working fluid in the heat pipes instead of potassium (K). An **11-group energy structure** is employed, with parameters defined over grids of:

1. **Fuel temperature** (5 values)
2. **Temperature of the moderator, reflector, monolith, and heat pipe** (5 values)
3. **Hydrogen content** (7 values)
4. **Control drum rotation**  (1 value: control drums out)

The results obtained from Serpent-2 are consistent with expected reactor physics:  

- Increasing the hydrogen content within the tabulated range (from YH$_{0.5}$ to YH$_2$) yields a higher $k_{eff}$ value, due to enhanced moderation.  
- Increasing the fuel temperature consistently reduces $k_{eff}$, reflecting the negative reactivity feedback from Doppler broadening.  

This multi-grid cross-section library enables analysis of thermal reactivity feedback effects as well as the impacts of hydrogen redistribution within the moderator. At present, simulations are being carried out for the **control rod–out** configuration.  

Finally, the generated cross sections are converted into an **XML-file format** for compatibility with **Griffin**.


### Sockeye Model

For each heat pipe in the 1/6 HP-MR core, a Sockeye grandchild application is used to calculate its thermal performance.

Instead of the effective thermal conductance model used in the K-HPMR model, the LCVF heat pipe model is adopted in the Na-HPMR model. As the name implies, the advanced heat pipe model uses a mechanistic flow model to predict the heat transfer performance of the heat pipe kernel.

!listing /mrad/steady_Na/HPMR_sockeye_ss.i max-height = 10000

## Steady-State Case Simulation

In the current Na-HPMR multiphysics model, only the steady-state case is simulated. Transient simulations are planned to be implemented in the near future.