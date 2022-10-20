# HTTF 3-D MultiApp Model Description

*Contact: Thomas Freyman - Thomas.Freyman@inl.gov  Lise Charlot - Lise.Charlot@inl.gov*

The MOOSE MultiApp system was used to model the PG-26 transient utilizing 3-D heat conduction within the core and 1-D
fluid flow for each coolant and bypass channel. Due to radial variations in the HTTF core, the 3-D model allowed for high fidelity 
analysis of ceramic core block and coolant temperatures during the transient which a 2-D radially averaged model might not capture. 
This also allowed for direct comparison between data recorded by thermocouples from the experiment and temperatures recorded at the 
same locations within the 3-D model. 

The MOOSE `heat_conduction` module operated as the main app while the RELAP-7
input files were solved as the sub apps. Below is a description of the methodology used to solve the 3-D heat conduction, 1-D
fluid flow, and the coupling of the two phenomena with the MultiApp system.

Note this model could be easily extended to include a larger 1-D model of the entire primary and secondary systems. This would allow 
system-level transient analysis of the entire HTTF while also obtaining high-fidelity temperature profiles within the HTTF core.



# Heat Conduction

The MOOSE `heat_conduction` module was used to solve heat conduction throughout the HTTF core, reflector, core barrel, RPV, and RCCS 
in 3-D. Shared surfaces between the core and reflector were merged within the mesh to allow for heat conduction across the boundary 
and differing materials. To facilitate heat transfer from the reflector to the core barrel, `GapHeatTransfer` was used. While the 
reflector and core barrel blocks both contain side sets in the same location, in reality there is a slight gap between the objects at 
the HTTF. The `GapHeatTransfer` block accurately models this configuration by calculating radiative heat transfer between the 
surfaces as well as conduction through the small amount of helium gas present in between them. Similarly, `GapHeatTransfer` 
is used to solve heat transfer between the outer surface of the core barrel, and the inner surface of the RPV, as well as the outer 
surface of the RPV and inner surface of the RCS. 

Boundary conditions were placed on heat conduction using various coolant temperatures solved in RELAP-7. Multiple 
`CoupledConvectiveHeatFluxBC` were used to place Robin boundary conditions on surfaces across the 3-D mesh allowing for a coupling 
of the convection-diffusion boundaries.

Individual electric heaters were not modeled in this analysis, instead the experimentally recorded power supplied by each 
heater bank was input into the model with a heat flux. Total heater bank output was divided by the number of heating 
elements in each bank, and then divided by the surface area of the core block each element was exposed to. This resulted in a heat 
flux supplied to the HTTF by each individual heater during the transient. A `ParsedFunction` was used to specify the axial length 
along the core heater channel the heat flux was present. To apply the heat flux `FunctionNeumannBC` was used as a boundary 
condition on the side sets representing each heater bank. In reality, some heat loss between the heating elements and the core 
occurred, however due to the compact nature of the system this was assumed to be negligible and was ignored. 



# Fluid Flow

## Fluid Properties and Closures

RELAP-7 contains fluid properties and built-in closures. These allow for compressible flow in both single and 
two-phase for a number of fluids typically used in nuclear applications. Specifically, `HeliumSBTLFluidProperties` with 
`Closures1PhaseHighTempGas` were used for all primary system RELAP-7 input files. For the single-phase water filled RCCS 
`IAPWS95LiquidFluidProperties` and `Closures1PhaseTRACE` were used. 

## Components

RELAP-7 was used to calculate 1-D fluid flow of the helium coolant in the HTTF core and water in the RCCS. A total of 7 
input files were created accounting for each type of coolant channel, bypass channel, the upcomer, and the RCCS. In the HTTF there 
are 3 sizes of coolant channels, denoted in this model as small, medium, and large, and 2 sizes of bypass channels denoted as small 
and large. The input files `small_coolant.i`, `medium_coolant.i`, `large_coolant.i`, `small_bypass.i`, and `large_bypass.i` function 
exactly the same with the only difference being the channel diameter. Each input file models a single coolant or bypass 
channel using `FlowChannel1Phase` within the `Components` structure. To initialize the flow channel an inlet was specified using 
`InletMassFlowRateTemperature1Phase`. As the name suggests this required an inlet temperature and mass flow rate. Both variables were 
supplied by a dummy value which was overwritten by the control logic (discussed later). Similarly, to terminate the flow channel, the 
component `Outlet1Phase` was used which required an outlet pressure the channel flows into. Like the inlet temperature, a dummy value 
was supplied for pressure which was overwritten by the control logic system (discussed later). 
`HeatTransferFromExternalAppTemperature1Phase` coupled the individual flow channels to the HTTF core and activated heat transfer 
between the two.

`upcomer.i` modeled the upcomer and `RCCS.i` modeled the RCCS water flow. These input files had the same `Components` structure as 
the coolant and bypass channels, except heat transfer was applied to their corresponding solid structures in the 3-D mesh, and 
each file used different flow areas, hydraulic diameters, and heated perimeters. Also, different variables were transferred between 
these sub apps and the main app than the coolant and bypass channels (discussed later). 

## Control Logic

Control Logic within RELAP-7 allowed for changing component parameters and setting conditions for given transients. 
Using `TimeFunctionComponentControl`, recorded primary pressure from the PG-26 transient was applied to the pressure variable in 
`Outlet1Phase`. For inlet temperature of the coolant and bypass channels, the outlet temperature of the upcomer was received from the 
`MultiApp` solve (discussed later) as a `Postprocessor`, converted to a `Function`, and then applied to the flow channel inlet by 
`ParsedFunctionControl` and `SetComponentRealValueControl`. Again, `ParsedFunctionControl` and `SetComponentRealValueControl` were 
used to apply the mass flow rate, however the `ParsedFunctionControl` was used to shutoff mass flow once the transient began. Similar 
to the outlet pressure, `TimeFunctionComponentControl` was used to apply the inlet conditions of the `upcomer.i` and `RCCS.i`.



# MultiApp Execution

## MultiApps

Within the `heat_conduction` main app, 3 sub apps were specified in the `MultiApps` block. The block titled `relap` was used to 
identify the input files for each type of coolant and bypass channel. These input files only solve for individual flow channels, 
however there are 558 channels total within the core. The `positions_file` parameter was used which specified a 
positions file for each input file. These `.txt` files contained the `x`, `y`, and `z` coordinates of every flow channel for the type 
defined by the corresponding input file. When the `MultiApps` execution was conducted, the sub app solved each single channel input 
file at every location in the mesh defined by the supplied `positions_file`.

The upcomer and RCCS were solved in the same manner as the coolant and bypass channels with a single entry in their supplied 
`positions_file`.

## Transfers

Within the `Transfers` block, all variables which were "shared" between the `heat_conduction` main app and RELAP-7 sub 
apps were defined. For example, the RELAP-7 sub apps required a flow channel wall temperature to solve the component 
`HeatTransferFromExternalAppTemperature1Phase`. The wall temperature was solved as part of the `heat_conduction` main app solve, so 
this solution value was sent to the RELAP-7 sub app in the block titled `Twall_to_relap`. In the same manner, to solve the 
heat conduction equation, the main app required a fluid temperature, `T`, and heat transfer coefficient, `Hw`, from the sub apps. 
These transfers were conducted in the blocks titled `tfluid_from_relap` and `Hw_channel_from_relap`. Separate `T` and `Hw` variables were 
transferred for the ucpomer and RCCS as they were purposefully kept separate from the coolant and bypass channel solves. 

Because the upcomer removes heat from the 3-D structures as it travels to the upper plenum, the outlet temperature of the upcomer had 
to be saved and transferred to the coolant and bypass channels to use as the inlet temperature. Since both the upcomer and channels 
are sub apps, the outlet temperature of the upcomer had to be recorded as a `Postprocessor` within the `upcomer.i` file. This value 
was then passed "upwards" to the main app with the block titled `upcomer_outlet_temp`. The block then stores the value in a separate 
`Postprocessor` in the main app. Finally, the transfer block `upcomer_to_relap` sends the newly formed main app `Postprocessor` to the 
`relap` sub app. To ensure this method works, `RCCS` is specified before `relap` in the `MultiApps`so it is solved first, and the 
variable can be passed properly.  