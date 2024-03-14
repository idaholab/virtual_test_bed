# MSFR Spatially-resolved thermochemistry model Results

The results of the MSFR Griffin-Pronghorn-Thermochimica model showcase what has been coined 'Depletion driven thermochemistry' [!citep](Frontiers). This process details the effect that neutronic fuel depletion has on altering the thermochemistry of the fuel salt. Typically this process is slightly oxidizing where the fission products generated are less thermodynamically stable in the fuel salt as opposed to the original uranium fuel, and the chemical fluorine or redox potenial of the fuel salt increases [!citep](Frontiers). This increases corrosion rates in a molten salt reactor and must be actively controlled [!citep](Zhang2018).

## Thermochimica Inputs

In order for Thermochimica to minimze the internal Gibbs Energy of this system to determine the thermochemical equilibrium if the fuel salt, it needs the temperature, pressure, and element fields in the fuel salt. Here the steady-state values for the temperature and pressure fields in the MSFR calculated by Griffin+Pronghorn are utilized from the following restart file `msfr/steady/restart/run_ns_coupled_restart.e` shown in [MSFR_temperature] and [MSFR_pressure] respectively.

!row!
!media msr/msfr/thermochemistry/fuel_salt_temperature.png
       style=width:50%;float:left;padding-top:2.5%;padding-right:5%
       id=MSFR_temperature
       caption=Multiphysics (Griffin + Pronghorn) steady-state temperature $[K]$ solution.

!media msr/msfr/thermochemistry/fuel_salt_pressure.png
       style=width:39%;float:left;padding-top:2.5%
       id=MSFR_pressure
       caption=Multiphysics (Griffin + Pronghorn) steady-state pressure $[Pa]$ solution.
!row-end!

## Spatially-Resolved Thermochemistry Results

The Thermochimica results are shown in [MSFR_reduced]. Here the fluorine potential is well reduced with the inital fuel salt of the MSFR. Therefore, soluble fission product elements like cesium and iodine are well dissolved in the fluoride salt, and their volatility is extremely low as seen in the right panel of [MSFR_reduced].

!media msr/msfr/thermochemistry/before_depletion.png
       style=width:90%;margin:auto
       id=MSFR_reduced
       caption=(left) Fluoride (F-) potential $[J/mol]$ and (right) corresponding iodine in stable gas phase $[mol]$ with fresh fuel salt - i.e. reducing.

## Depletion-driven, Spatially-Resolved Thermochemistry Results

This situation changes however after some time due to fuel salt depletion as seen in [MSFR_oxidized]. Here the fluorine potential has greatly increased due to the consumption of Uranium fuel and the generation of less thermodynamically stable fission products (i.e. noble gases and noble metals). Accordingly, the volatilization of iodine has increased by a minimum of four orders of magnitude as seen in the right of [MSFR_oxidized]. Therefore, iodine gas will begin to be extracted to the off-gas system along with the noble gases.

!media msr/msfr/thermochemistry/after_depletion.png
       style=width:90%;margin:auto
       id=MSFR_oxidized
       caption=(left) Fluoride (F-) potential $[J/mol]$ and (right) corresponding iodine in stable gas phase $[mol]$ at 2.07 MWd/Kg-U burup without chemistry control - i.e. oxidizing.

These results showcase the importance of chemistry control for both corrosion and source term mitigation in MSR systems.
