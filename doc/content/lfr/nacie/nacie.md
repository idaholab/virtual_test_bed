# Coupled SAM and MOOSE Subchannel model of NACIE ADP10 Test

*Contact: Gang Yang, gang.yang.at.anl.gov*

*Model link: [NACIE-UP ADP10 coupled model](https://github.com/idaholab/virtual_test_bed/tree/devel/lfr/nacie)*

!tag name=Coupled SAM and MOOSE Subchannel model of NACIE ADP10 Test
     description=Coupled system and subchannel simulation of the NACIE-UP ADP10 forced to natural circulation test with LBE coolant
     image=https://mooseframework.inl.gov/virtual_test_bed/media/lfr/nacie/nacie_loop.png
     pairs=reactor_type:LFR
                       reactor:NACIE-UP
                       geometry:primary_loop;assembly
                       simulation_type:thermal_hydraulics
                       V_and_V:validation
                       codes_used:SAM;MOOSE_Subchannel
                       computing_needs:Workstation
                       fiscal_year:2026
                       sponsor:FRP;NEAMS
                       institution:ANL

## Model Summary

This model simulates the Natural Circulation Experiment Upgraded (NACIE-UP) ADP10 test using the coupled System Analysis Module (SAM) and MOOSE Subchannel Module (SCM). The NACIE-UP facility is a lead-bismuth eutectic (LBE) loop at ENEA Brasimone. ADP10 begins in forced circulation with all 19 fuel-pin-simulator (FPS) rods heated uniformly at 30 kW. The gas-lift pump is then turned off and the loop transitions to natural circulation. The model uses a domain-overlapping coupling: SAM calculates the facility response and SCM resolves the FPS flow and temperature distributions [!citep](nacie_paper, di_piazza2025nacie, SAMTheoryManual, domain_overlap_huxford2023).

## Test and Facility Description

NACIE-UP is a rectangular LBE loop with two vertical pipes, which form the riser and downcomer, connected by two horizontal pipes. The primary loop includes the 19-pin wire-wrapped FPS in the lower riser, an argon gas-injection device, an expansion vessel, a thermal flow meter, and a heat exchanger in the upper downcomer. The heat exchanger transfers heat from the LBE to a pressurized water secondary loop [!citep](di_piazza2024nacieup).

!media lfr/nacie/nacie_facility.png
       style=width:38%;margin-bottom:2%;margin:auto;
       id=nacie-facility
       caption=Schematic of the NACIE-UP facility.

In ADP10, all 19 FPS pins are electrically heated at a nominal total power of 30 kW. The test begins in forced circulation with an argon flow rate of 10 Nl/min. At 1225 s, the argon flow decreases from 10 Nl/min to zero over 1 s. The secondary water conditions remain at a 170 C inlet temperature and a 10 m3/h volumetric flow rate throughout the test [!citep](di_piazza2024nacieup).

## Coupled Model

### SAM System Model

The NACIE-UP loop is modeled with 1-D/0-D components of SAM [!citep](nacie_paper). The FPS is modeled as one surrogate channel with a uniform heat source that preserves the 30 kW total FPS power. SAM represents the gas-injection system with a pump component. The pump head is maintained before 1225 s, then decreases linearly to zero between 1225 and 1245 s. This 20 s model assumption approximates the time for residual gas bubbles to rise to the expansion vessel after injection stops [!citep](moisseytsev2025nacie). The heat exchanger water inlet temperature and the thermal-flow-meter heat input are supplied to the model through the time-dependent `T_WATER_ADP10.csv` and `QTFM_ADP10.csv` functions. The input starts at -10000 s so that the modeled loop can approach its initial state before the transient calculation.

!media lfr/nacie/nacie_loop.png
       style=width:45%;margin-bottom:2%;margin:auto;
       id=nacie-loop
       caption=Schematic of SAM Model for NACIE Facility.

!listing lfr/nacie/nacie_adp10.i start=[FA_active] end=[] include-end=true language=moose

### MOOSE Subchannel Model

The SCM model represents the 19-pin hexagonal FPS with 42 subchannels: 24 interior, 12 edge, and 6 corner subchannels. The full 1.315 m FPS is represented with 263 axial cells. Its three regions are the 0.615 m region below the active region, the 0.600 m active region, and the 0.100 m region above the active region. Consistent with the ADP10 heat-balance calculation, 7.4%, 90.6%, and 2.0% of the total 30 kW are applied below, in, and above the active region, respectively. The power is distributed uniformly among the 19 pins using `uniform_19_pins.txt`, and the `axial_heat_rate` function applies this axial distribution [!citep](nacie_paper).

SCM uses `SCMTriAssemblyMeshGenerator` to construct the hexagonal bundle mesh and the built-in lead-bismuth eutectic fluid properties. The inlet temperature and mass flow rate calculated by SAM serve as the SCM boundary conditions. The subchannel calculation uses an implicit monolithic solve. Cheng-Todreas correlations are used for the subchannel friction factor and mixing.

!media lfr/nacie/nacie_scm.png
       style=width:65%;margin-bottom:2%;margin:auto;
       id=scm-numbering
       caption=SCM representation of the 19-pin FPS, showing the fuel pins (red) and the 42 subchannels.

!table id=fps-regions caption=Axial power distribution in the ADP10 SCM model.
| FPS region | Axial interval (m) | Power fraction | Power (kW) |
| :- | :- | :- | :- |
| Below active region | 0.000--0.615 | 0.07418 | 2.226 |
| Active region | 0.615--1.215 | 0.90569 | 27.171 |
| Above active region | 1.215--1.315 | 0.02013 | 0.604 |

!listing lfr/nacie/nacie_adp10_fps_subchannel.i block=TriSubChannelMesh language=moose

!listing lfr/nacie/nacie_adp10_fps_subchannel.i block=SubChannel language=moose

!listing lfr/nacie/nacie_adp10_fps_subchannel.i block=SCMClosures language=moose

!listing lfr/nacie/nacie_adp10_fps_subchannel.i block=Functions language=moose

### Domain-Overlapping Coupling

The complete FPS domain is solved by both applications. At each coupled time step, the SAM main app transfers the FPS inlet temperature, inlet mass flux, and outlet pressure to the single SCM sub-app. SCM returns its average pressure gradient to SAM. The transfers are disabled during the initial portion of initialization and enabled after -8000 s.

!media lfr/nacie/nacie_coupling.png
       style=width:75%;margin-bottom:2%;margin:auto;
       id=domain-overlap
       caption=Domain-overlapping coupling between the SCM FPS model and the SAM system model.

!listing lfr/nacie/nacie_adp10.i block=MultiApps language=moose

!listing lfr/nacie/nacie_adp10.i block=Transfers language=moose

## Steady-State Results

Before the gas-lift pump is turned off, the coupled solution establishes the ADP10 initial steady-state condition. The calculated subchannel temperatures are compared with the thermocouple measurements at three elevations in the FPS [!citep](nacie_paper).

!media lfr/nacie/steady_subchannel_temperature.png
       style=width:70%;margin-bottom:2%;margin:auto;
       id=steady-temperature
       caption=Calculated and measured ADP10 initial steady-state subchannel temperatures.

## Transient Results

At approximately 1225 s in the recorded test timeline, the modeled pump head begins to decrease and reaches zero at 1245 s. The FPS mass flow rate falls from its forced circulation value, followed by an oscillation that quickly dissipates, and then approaches the natural circulation flow. The calculated flow decrease is slightly faster than the measured response, which could be because the estimated 20 s pump-head-loss time is shorter than the actual value in the ADP10 test [!citep](nacie_paper).

!media lfr/nacie/fps_mass_flow.png
       style=width:60%;margin-bottom:2%;margin:auto;
       id=fps-mass-flow
       caption=FPS mass flow rate comparison during the ADP10 transient.

!media lfr/nacie/fps_outlet_temperature.png
       style=width:60%;margin-bottom:2%;margin:auto;
       id=fps-outlet-temperature
       caption=FPS active region outlet temperature during ADP10.

The subchannel temperatures are compared with the measured transient response at 0.3 m downstream of the FPS active region.

!media lfr/nacie/tc_fps06_transient.png
       style=width:60%;margin-bottom:2%;margin:auto;
       id=tc-fps06
       caption=ADP10 subchannel temperature at 0.3 m downstream of the FPS active region.

## Running the Model

Run the main-app input with an application that includes both SAM and MOOSE Subchannel:

```
combined-opt -i nacie_adp10.i -w
```

The main app launches exactly one SCM sub-app input, `nacie_adp10_fps_subchannel.i`. The sub-app must remain in the same directory as the main-app input together with `uniform_19_pins.txt`, `QTFM_ADP10.csv`, and `T_WATER_ADP10.csv`.

!listing lfr/nacie/nacie_adp10.i block=Executioner language=moose
