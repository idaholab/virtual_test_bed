# Effect of Partial Blockages in Simulated LMFBR Fuel Assemblies

*Contact: Vasileios Kyriakopoulos, vasileios.kyriakopoulos.at.inl.gov*

*Model link: [THORS edge blockage Subchannel Model](https://github.com/idaholab/virtual_test_bed/tree/devel/sfr/subchannel/THORS)*

!tag name=Effect of Partial Blockages in Simulated LMFBR Fuel Assemblies
     description=Study of the partial blockage in sodium fast reactor assemblies using a subchannel discretization of the thermal hydraulics. The new flow distribution is computed and analyzed
     image=https://mooseframework.inl.gov/virtual_test_bed/media/subchannel/thors/thors2.png
     pairs=reactor_type:SFR
                       geometry:assembly
                       simulation_type:thermal_hydraulics
                       transient:steady_state
                       V_and_V:validation
                       codes_used:SCM
                       computing_needs:Workstation
                       fiscal_year:2024
                       sponsor:NEAMS
                       institution:INL

Information on the THORS facility and experiments can be found in the following sources: [!citep](fontana1973effect),[!citep](han1977blockages),
[!citep](jeong2005modeling). The SCM model's geometry and subchannel/rod index notation is shown in [fig:hex_index].

!media subchannel/thors/hex-index.png
    style=width:60%;margin-bottom:2%;margin:auto;
    id=fig:hex_index
    caption= SCM model cross-section of THORS bundle and index notation \\ (white: fuel pin index; black: subchannel index; red: gap index).

## Edge blockage of 14 channels in 19-pin sodium-cooled bundles

THORS bundle 5B has the same fuel configuration as bundle 2B, except that 0.0711-cm-diam wire-wrap spacers are used to separate the peripheral pins from the duct wall. The half-size spacers are used to reduce the flow in the peripheral flow channels and to cause a flatter radial temperature profile across the bundle. It also means that the flat-to-flat distance is reduced appropiately. The pins have a heated length of $45.7 cm$. A 3175-cm-thick stainless steel blockage plate is located $10.2 cm$  above the start of the heated zone to block $14$ edge and internal channels along the duct wall. The test section layout is shown in Fig [fig:thors2]. The experimental parameters for the chosen case are presented in [parameters2]. SCM modeled the THORS bundle 5B blockage with a $90$% area reduction on the affected subchannels and a local form loss coefficient of $5$. $C_T$ was set to $2$ as in the previous case. The SCM model's geometry and subchannel/pin index notation is shown in [fig:hex_index].

!media subchannel/thors/thors2.png
    style=width:60%;margin-bottom:2%;margin:auto;
    id=fig:thors2
    caption= THORS bundle 5B cross section.

!table id=parameters2 caption=Design and operational parameters for THORS 14-channel edge blockage benchmark.
| Experiment Parameter (unit) | Value |
| :- | :- |
| Number of pins (---) | $19$ |
| Rod pitch (cm) | $0.726$ |
| Rod diameter (cm) | $0.5842$ |
| Wire wrap diameter (cm) | $0.1422$ |
| Wire wrap axial pitch (cm) | $30.5$ |
| Flat-to-flat duct distance (cm) | $3.241$ |
| Inlet length (cm) | $40.64$ |
| Heated length (cm) | $45.72$ |
| Outlet length (cm) | $15.24$  |
| Blockage location (cm) | $95.96$ |
| Outlet pressure (Pa) | $2.0 \times 10^{5}$ |
| Inlet temperature (K) | $596.75/541.55$ |
| Inlet velocity (m/s) | $6.93/0.48$ |
| Power profile (---) | Uniform |
| Power (kW) | $145/52.8$ |

## Results for edge blockage

The case presented here is the high-flow case (FFM Series 6, Test 12, Run 101). The thermocouples are located in the middle of the exit region. There is a subchannel index correspondence between Figure [fig:thors2] and the SCM model shown in Figure [fig:hex_index] as follows: 34(39), 33(38), 18(20), 9(19), 3(4), 0(1), 12(11), and 25(30), where the number outside the parentheses refers to the SCM model, and the number inside the parentheses refers to the experimental convention. SCM calculations, along with the experimental measurements, are shown in Figure [fig:FFM-5B_high]. The code calculations exhibit generally good agreement with the experimental measurements. The least agreement occurs at the edge subchannels ($34, 33$), which is likely due to the model not accurately replicating the flow area there. SCM uses an assembly-wide constant wire diameter, while in the experimental assembly, the wires at the edge subchannels had half the diameter.

!media subchannel/thors/FFM-5B_high.png
    style=width:60%;margin-bottom:2%;margin:auto;
    id=fig:FFM-5B_high
    caption= Exit temperature profile for high flow case ($C_T = 2$).

The second case presented here is the low flow case (FFM Series 6, Test 12, Run 109).
The thermocouples are located at the middle of the exit region, same as before.
SCM calculation along with the experimental measurements is shown in Figure [fig:FFM-5B_low].
The code calculations exhibits good agreement with the experimental measurements with the
worst result being for the inner subchannels.

!media subchannel/thors/FFM-5B_low.png
    style=width:60%;margin-bottom:2%;margin:auto;
    id=fig:FFM-5B_low
    caption= Exit temperature profile for low flow case ($C_T = 2$).

## Subchannel Input

The input file to run the edge blockage case is presented below:

!listing sfr/subchannel/THORS/FFM-5B.i language=cpp

## Running the simulation

SCM is a MOOSE module. The user can run the input files by compiling their copy of SCM in MOOSE.
```

