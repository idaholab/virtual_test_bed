# Molten Salt Reactor Experiment (MSRE) Description

*Contact: Mauricio Tano, mauricio.tanoretamales.at.inl.gov*

*Model summarized, documented, and uploaded by Andres Fierro*

<!-- Edits by Andres Fierro -->

The MSRE was a graphite moderated flowing salt type reactor with a design maximum operating power of 10 MW(th) developed by Oak Ridge National Laboratory [!citep](Robertson1965).
The reactor ran for more than 13,000 hours at full power before its final shut down in 1969.  The general layout of the experiment is shown in [MSRE_core_ref].

!media msr/msre/MSRE_core_ref.png
        style=width:55%; float:left;padding-top:2.5%;padding-right:5%
        id=MSRE_core_ref
        caption=Schematic design of MSRE loops [!citep](osti_1617123).

The fuel salt was a fluoride based ionic liquid containing lithium, beryllium, zirconium and uranium fuel.
The coolant salt was a mixture of lithium fluoride and beryllium fluoride.
The reactor consisted of two flow loops: a primary loop and a secondary loop.
The primary loop connected the reactor vessel to a fuel salt centrifugal pump and the shell side of the shell-and-tube heat exchanger.
The secondary loop connected the tube-side of the shell-and-tube heat exchanger to a coolant salt centrifugal pump and the tube side of an air-cooled radiator.
Two axial blowers supplied cooling air to the radiator. Piping, drain tanks and “freeze valves” made up the remaining components of the heat transport circuits.
The heat generated in the core was transferred to the secondary loop through the heat exchanger and ultimately rejected to the atmosphere through the radiator.

The three main features of this experiment are:

- The core circulation system, where the molten salt fuel flows through rounded-rectangular channels in the vertical graphite moderator stringers

- The centrifugal pump that provided continuous circulation, facilitated heat transfer and the removal of fission products

- The two-loop heat exchanger system with an approximately 25-second fuel loop circulation time in the reactor.

We note that the MSRE was a thermal reactor with a highly negative reactivity temperature coefficient. The vertical graphite stringers are shown in [MSRE_core_ref_2].


!table id=MSRE_rxtr_specs caption=MSRE Reactor Specifications
| Parameter  | Value  |
|:-----------|:---------|
| Core Power | 10 MW$_{th}$ (MegaWatt Thermal)|
| Core height  | 1.63 m |
| Core diameter  | 1.39 m |
| Fuel Salt | LiF-BeF$_2$-ZrF$_4$-UF$_4$ |
| Fuel salt molar mass | 65.0%-29.1%-5.0%-0.9% |
| Fuel salt enrichment | 33.0% |
| Channels in graphite moderator | 3.05 cm ✕ 1.016 cm |
| Channels' rounded corners radii | 0.508 cm |
| Vertical graphite stringers  | 5.08 cm ✕ 5.08 cm |


!media msr/msre/MSRE_core_ref_2.png
        style=width:45%;margin-left:auto;margin-right:auto
        id=MSRE_core_ref_2
        caption=Picture of MSRE core graphite stringers  [!citep](osti_1617123)


## Material Properties and MSRE Setup

The fuel salt in the MSRE primary loop was LiF-BeF4-ZrF4-UF4 according to the design specifications of the MSRE [!citep](Beall1964,Cantor1968),
of which the thermophysical properties are listed in [fuel_salt_properties].

!table id=fuel_salt_properties caption=Thermophysical properties of the fuel salt
|   |   | Unit  | LiF-BeF$_4$-ZrF$_4$-UF$_4$  |
| :- | :- | :- | :- |
| Melting temperature | $T_{melt}$ | $K$ | $722.15$  |
| Density | $\rho$ | $kg/m^3$  | $2553.3-0.562\cdot T$ |
| Dynamic viscosity | $\mu$ | $Pa\cdot s$ | $8.4\times 10^{-5} exp(4340/T)$ |
| Thermal conductivity | $k$ | $W/(m\cdot K)$ | $1.0$ |
| Specific heat capacity | $c_p$ | $J/(kg\cdot K)$ | $2009.66$ |

A conventional, cross-baffled, shell-and-tube type heat exchanger was used in MSRE.
The fuel salt flows on the shell side while the coolant salt flows through the tube side.
The coolant salt in the heat changer is LiF-BeF$_2$ (0.66-0.34) [!citep](Guymon1973), of which the major thermophysical properties are summarized in [coolant_salt_properties].
Due to the space limitation in the reactor cell, a U-tube configuration is adopted, which results in a heat exchanger of roughly 2.5 m in length.
The shell diameter is 0.41 m while the tube has a diameter of 1.27 cm and a thickness of 1.07 mm. Given a triangular arrangement of the tubes, the hydraulic diameters are 2.09 cm (shell-side) and 1.06 cm (tube-side).
The construction material of heat exchanger is Hastelloy® N alloy with the properties listed in [steel_properties].
All the connecting pipes have a default diameter of 0.127 m. A centrifugal pump is utilized, and its head is adjusted to sustain the flow circulation. The downcomer and lower plenum to the MSRE core are modeled with SAM 1-D components.

!table id=coolant_salt_properties caption=Thermophysical properties of the coolant salt in heat exchanger.
|   |   | Unit  | LiF-BeF$_2$ (0.66-0.34)  |
| :- | :- | :- | :- |
| Melting temperature | $T_{melt}$ | $K$ | $728$  |
| Density | $\rho$ | $kg/m^3$  | $2146.3-0.488\cdot T$ |
| Dynamic viscosity | $\mu$ | $Pa\cdot s$ | $1.16\times 10^{-4} exp(3755/T)$ |
| Thermal conductivity | $k$ | $W/(m\cdot K)$ | $1.1$ |
| Specific heat capacity | $c_p$ | $J/(kg\cdot K)$ | $2390.0$ |

!table id=steel_properties caption=Thermophysical properties of Hastelloy® N alloy used in the heat exchanger.
|   |   | Unit  | Hastelloy® N alloy  |
| :- | :- | :- | :- |
| Density | $\rho$ | $kg/m^3$  | $8860$ |
| Thermal conductivity | $k$ | $W/(m\cdot K)$ | $23.6$ |
| Specific heat capacity | $c_p$ | $J/(kg\cdot K)$ | $578$ |
