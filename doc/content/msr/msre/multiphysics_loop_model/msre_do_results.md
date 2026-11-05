# MSRE Multiphysics Primary Loop Model — Steady-State Results

*Contact: Travis Mui, tmui\@anl.gov; Ramiro Freile, ramiro.freile\@inl.gov*

This page presents results from the 10 MW steady-state simulation of the
Griffin-Pronghorn-SAM-Saline domain overlapping model.
For a description of the model physics and input files, see [Model Description](msre_do_model.md).

## 10 MW Steady-State Results

The steady-state simulation couples Griffin (eigenvalue), Pronghorn (2D RZ core TH and DNPs),
and SAM (1D primary loop) with Saline properties for the fuel salt.
Global parameters are compared to MSRE design data [!citep](robertson10msre) in [MSRE_ss_params].

!table id=MSRE_ss_params caption=Predicted vs. reference steady-state operating parameters at 10 MW.
| Parameter               | Reference [!citep](robertson10msre) | Predicted |
| :---------------------- | :---------------------------------- | :-------- |
| Mass flow rate          | ~165 kg/s                           | ~165 kg/s |
| Core $\Delta p$         | ~62 kPa                             | 63.5 kPa  |
| Core $\Delta T$         | ~27.8 K                             | 27.8 K    |
| Fuel recirculation time | ~25 s                               | ~25 s     |

### Velocity Field

[MSRE_ss_vel] shows the velocity magnitude in the SAM primary loop and the Pronghorn core.
The pump head is tuned to achieve the nominal mass flow rate of 165 kg/s.
Inside the reactor vessel, salt enters through the downcomer, bends and mixes in the lower
plenum, ascends through the core and bypass, and exits through the upper plenum to the riser.
The predominantly axial flow in the core results from the anisotropic friction model,
consistent with the MSRE's graphite-channel geometry.
A deceleration is observed at the heat exchanger shell inlet due to area expansion.
The predicted recirculation time of ~25 s matches the experimental value.

!media msr/msre/multiphysics_loop_model/MSRE_SS_vel.png
       style=width:75%;margin-left:auto;margin-right:auto
       id=MSRE_ss_vel
       caption=Domain-overlapped velocity magnitude in Pronghorn (core) and SAM (primary loop). Streamlines are shown in the Pronghorn domain.

### Pressure Field

[MSRE_ss_pres] shows the pressure distribution throughout the primary loop.
Pressure increases across the pump and in the heat exchanger shell (flow area expansion).
The predicted core pressure drop (downcomer inlet to riser outlet) is 63.5 kPa,
within 2.4% of the 62 kPa reference value.

!media msr/msre/multiphysics_loop_model/MSRE_SS_pres.png
       style=width:75%;margin-left:auto;margin-right:auto
       id=MSRE_ss_pres
       caption=Domain-overlapped pressure field in Pronghorn (core) and SAM (primary loop).

### Temperature Field and Power Distribution

[MSRE_ss_temp] shows the temperature distribution alongside the Griffin power density.
The core temperature rise of 27.8 K between inlet and outlet matches the design value.
Temperature remains approximately constant through the primary piping until the heat exchanger,
where the salt exits at ~896 K.

!media msr/msre/multiphysics_loop_model/MSRE_SS_temp.png
       style=width:75%;margin-left:auto;margin-right:auto
       id=MSRE_ss_temp
       caption=Domain-overlapped temperature field in Pronghorn (core) and SAM (primary loop).

!media msr/msre/multiphysics_loop_model/MSRE_SS_power.png
       style=width:30%;margin-left:auto;margin-right:auto
       id=MSRE_ss_power
       caption=Griffin power density distribution in the MSRE core at 10 MW.

### Delayed Neutron Precursor Distributions

The DO coupling transports all six DNP groups between Pronghorn and SAM.
At each coupling interface SAM receives the flow-averaged DNP concentration from Pronghorn,
advects and decays the precursors through the 1D loop, and returns inlet concentrations to the
core downcomer.

The distributions for the longest-lived group (Group 1), an intermediate group (Group 3), and
the shortest-lived group (Group 6) are shown below.
Group 1 is well-mixed throughout the full primary loop; Group 6 is strongly peaked at the
fission source and decays almost entirely within the core.

!media msr/msre/multiphysics_loop_model/MSRE_SS_c1.png
       style=width:75%;margin-left:auto;margin-right:auto
       id=MSRE_ss_dnp1
       caption=Steady-state DNP Group 1 (longest-lived) distribution in the Pronghorn core and SAM primary loop.

!media msr/msre/multiphysics_loop_model/MSRE_SS_c3.png
       style=width:75%;margin-left:auto;margin-right:auto
       id=MSRE_ss_dnp3
       caption=Steady-state DNP Group 3 distribution.

!media msr/msre/multiphysics_loop_model/MSRE_SS_c6.png
       style=width:75%;margin-left:auto;margin-right:auto
       id=MSRE_ss_dnp6
       caption=Steady-state DNP Group 6 (shortest-lived) distribution.
