# Running the Input File

SAM can be run in Linux, Unix, and MacOS.  Due to its dependence on MOOSE, SAM
is not compatible with Windows. SAM can be run from the shell prompt as shown
below

```language=bash

/projects/SAM/sam-opt -i pbr.i

```

# Results

There are three types of output files:

1. +pbr_csv.csv+: this is a `csv` file that writes the user-specified scalar and vector variables to a comma-separated-values file. The data can be imported to Excel for further processing or in Python using the `csv` module, Pandas, or other methods.

2. +pbr_out_cp+: this is a sub-folder that save snapshots of the simulation data including all meshes, solutions. Users can restart the run from where it ended using the file in the checkpoint folder.

3. +pbr_out.displaced.e+: this is a `ExodusII` file that has all mesh and solution data. Users can use Paraview to open this .e file to visualize, plot, and analyze the data.

# Steady-state

The steady-state simulation results are presented in this section. A qualitative
comparison of the reflector temperature distribution between the SAM and
Griffin/Pronghorn simulations is presented in [Treflector]. Note that the
temperature distribution in the pebble bed core is not shown here and will be
discussed later because the heat structures in each of SAM’s `PBCoreChannel`
appear as a one-dimensional line. Overall, a good agreement is observed between
SAM’s and Griffin/Pronghorn’s results where the temperature distributions appear
to be similar with the upper half of the core being at a lower temperature
compared to the bottom half. The bottom reflectors located under the pebble bed
core appear to be the hottest, with a peak temperature of roughly 1100 K in both
cases. Furthermore, most of the outer reflectors appear to be in a relatively
low temperature compared to the bottom reflectors. This indicates that during
steady-state normal operation, only a small amount of heat is conducted radially
from the core to the outer reflectors as forced convection is the primary heat
removal mechanism in the core.

!media generic-pbr/Treflector.png
        style=width:50%
        id=Treflector
        caption=Comparison of the reflector temperature distribution between the SAM and Griffin/Pronghorn simulation[!citep](Stewart2021).

The radial distributions of the maximum, minimum, and mean fuel and kernel
temperatures in the pebble bed from SAM are shown in [T_solid_radial]. Note
that 'fuel' denotes the overall matrix temperature of the pebbles. The
temperature decreases from the innermost to the outermost core channels,
following the radial distribution of the power prescribed to the core channels.
Additionally, the close proximity of the outer channels to the reflectors allows
heat from these channels to escape to the reflectors, further lowering their
temperatures. As expected, the kernel temperature is consistently higher than t
he fuel/matrix temperature.

!media generic-pbr/T_solid_radial.svg
        style=width:50%
        id=T_solid_radial
        caption=Radial distributions of fuel and kernel temperatures in the pebble bed from SAM.

The solid and fluid axial temperature profiles in the pebble bed core from SAM
and Griffin/Pronghorn are compared in [T_solid_mean_axial] and
[T_channel_axial_combined], respectively. Note that SAM’s results are represented
by the solid lines while Griffin/Pronghorn’s results are represented by the
dashed lines. The overall trends between the two sets of simulations are largely
similar. For the solid temperature, a good agreement is observed between SAM and
Griffin/Pronghorn in the upper half of the core. However, in the bottom half,
SAM predicts a slightly higher solid temperature in the two innermost core
channels, namely 'F-1' and 'F-2'. Both models predict a small increase of
temperature in the fuel chute, likely due to reduced heat transfer from the fuel
pebbles to the surrounding reflectors. The fluid temperature profiles from SAM
and Griffin/Pronghorn show good agreement where they have similar trend as the
solid temperatures. Lastly, SAM predicts an average coolant outlet temperature
of 1020 K, which is 4 K lower than Griffin/Pronghorn’s prediction of 1024 K
[!citep](Stewart2021).

!media generic-pbr/T_solid_mean_axial_combined.svg
        style=width:50%
        id=T_solid_mean_axial
        caption=Comparison of the steady-state solid temperature axial profiles between SAM and Griffin/Pronghorn.

!media generic-pbr/T_channel_axial_combined.svg
        style=width:50%
        id=T_channel_axial_combined
        caption=Comparison of the steady-state coolant temperature axial profiles between SAM and Griffin/Pronghorn.

# Transient

For the transient analysis, a load-following case with a varying inlet mass flow
rate is selected, similar to the 100-40- 100 load following exercise of PBMR-400
[!citep](PBMR2013). This case is chosen for this work because it tests not only
the thermal hydraulics modeling of SAM but also its neutronics modeling with the
point kinetics equations. The six-group formulation of the PKE is used here with
parameters such as the delayed neutron fraction, precursor decay constant, and
the local reactivity coefficients obtained from the Griffin/Pronghorn simulation
[!citep](Stewart2021).

Temperature reactivity feedbacks are modeled in the pebble bed core and the
surrounding reflectors. Note that coolant density and fuel axial expansion
feedbacks are not included here. The reactivity coefficients are divided into
three groups, namely the coefficients for the fuel, moderator, and reflector
regions. The fuel and moderator coefficients contribute primarily to the reactivity
feedback in the pebble bed core with a small amount of contribution from the
reflector coefficients near the outer edge of the pebble bed core. Meanwhile,
the reflector coefficients are responsible for the reactivity feedback in the
reflector regions. The reactivity feedback of the fuels is determined based on
the fuel kernel temperature, which in SAM is calculated using the model by TINTE
[!citep](TINTE2010) while the reactivity feedbacks for the reflectors and
moderators are calculated with the solid temperature. Given the difference in
the temperature used for calculating the reactivity feedback in the pebble bed
core, the heat structures in the pebble bed core are divided into three layers
of fuel, moderator, and reflector where each layer is prescribed with a reactivity
coefficient according to its type. Such distinction is not necessary in the
reflector region surrounding the pebble bed core because the reactivity feedback
in this region depends almost entirely on the reflector coefficients.

As shown in [mflow], the inlet flow rate is reduced from the nominal value of
78.6 kg/s (100%) to 19.65 kg/s (25%) over the course of 15 minutes. The flow rate
is kept at 25% for 30 minutes before it is ramped back up to 100% over 15 minutes.

!media generic-pbr/mflow.svg
        style=width:50%
        id=mflow
        caption=Coolant mass flow rate for the load-following transient simulation.

The reactivities and reactor power predicted by SAM and Griffin/Pronghorn
[!citep](Stewart2021) during transient are shown in [total_reactivity] and
[reactor_power], respectively. Note that the SAM results are represented by the
solid lines while the Griffin/Pronghorn results are the dashed lines. Despite
some differences in both sets of predictions, their overall trends agree relatively
well. When flow rate is decreased, the reduction in heat removal from the fuel
causes the overall core temperature to rise, leading to negative total reactivity,
which in turn decreases the reactor power. As the flow rate is held constant at 25%,
the change of temperature decreases and causes the reactivity to be near zero.
Conversely, when the flow rate is increased, the overall core temperature decreases
suddenly due to improved heat removal. The reactivity shows a sharp increase and
becomes positive, raising the reactor power, before gradually decreasing back to
zero as the temperature stabilizes.

!media generic-pbr/breakdown_reactivity_kernel.svg
        style=width:50%
        id=total_reactivity
        caption=Reactivities predicted by SAM in the load-following transient simulation.

!media generic-pbr/reactor_power_kernel.svg
        style=width:50%
        id=reactor_power
        caption=Total reactor power predicted by SAM in the load-following transient simulation.

During transient, the power decreases linearly from the nominal value of 200 MW
to roughly 55 MW as flow rate is decreased. The power maintains at this level
for the next 30 minutes as the flow rate is held constant before rising back to
the nominal value as the flow rate is ramped back up. The power predicted by SAM
is consistently lower than Griffin/Pronghorn's prediction by approximately 2 MW,
which is likely caused by the difference in the reactivities predicted by both
simulations.

The mean fuel and kernel temperatures, moderator temperature, and reflector
temperature are shown in [Tfuel_avg], [Tmoderator_avg], and [Treflector_avg],
respectively. During the initial ramp down, despite the increasing fuel temperature,
the kernel temperature decreases due to the reduction of reactor power as shown in
[reactor_power]. As the fuel (Doppler) reactivity feedback is calculated with the
kernel temperature, a decrease in the kernel temperature causes the fuel
reactivity to increase. At the same time, the moderator temperature increases and
leads to a decrease of reactivity. On the other hand, given that the reflector
reactivity coefficients are primarily positive, an increase in the reflector
temperature causes the reflector reactivity to increase. It is also observed
that the total reactivity is dominated by the moderator reactivity. During the
constant flow rate stage, the kernel, moderator, and reflector temperatures are
relatively constant with each experiencing minor changes. As a result, the
respective reactivities remain largely constant and produce a total reactivity
of approximately zero. Lastly, during the ramp up stage, the fuel and kernel
temperatures increase which then cause the reactivity of the fuel to decrease.
Conversely, the increased coolant flow reduces the moderator temperature and leads
to an increase of moderator reactivity. The reflector temperature also decreases
in this stage, resulting in a decrease of reflector reactivity. Overall, the total
reactivity shows a sharp initial increase before dropping gradually as the flow rate
is increased back to the nominal level. During the course of the transient, the
total reactivity is shown to be primarily influenced by the reactivity feedback
of the moderator.  

The mean fuel and kernel temperatures, moderator temperature, and reflector
temperature predicted by SAM are shown in [Tfuel_avg], [Tmoderator_avg], and
[Treflector_avg], respectively. Note that the SAM results shown here are the
volume-averaged temperature of a particular component. Volume-averaging is
necessary to ensure that the mean temperatures are not skewed by the number of
sections of a component. For instance, due to its complex geometry, the lower
reflector region is comprised of a greater number of sections compared to the
side reflector which has a comparatively simpler geometry. Thus, without
volume-averaging, the mean temperature will be skewed towards the lower reflector
region.

For the SAM prediction, during the initial ramp down, despite the increasing
fuel temperature, the kernel temperature decreases due to the reduction of
reactor power as shown in [reactor_power]. As the fuel (Doppler) reactivity
feedback is calculated with the kernel temperature, a decrease in the kernel
temperature causes the fuel reactivity to increase. At the same time, the
moderator temperature increases and leads to a decrease of reactivity. On the
other hand, given that the reflector reactivity coefficients are primarily
positive, an increase in the reflector temperature causes the reflector reactivity
to increase. It is also observed that the total reactivity is dominated by
the moderator reactivity. During the constant flow rate stage, the kernel,
moderator, and reflector temperatures are relatively unchanged with each
experiencing minor changes. As a result, the respective reactivities remain
largely constant and produce a total reactivity of approximately zero.

Lastly, during the ramp up stage, the fuel and kernel temperatures increase and
cause the reactivity of the fuel to decrease. Conversely, the increased coolant
flow reduces the moderator temperature and leads to an increase of moderator
reactivity. The reflector temperature also decreases in this stage, resulting
in a decrease of reflector reactivity. The resultant total reactivity shows a
sharp initial increase before dropping gradually as the flow rate is increased
back to the nominal level.

!media generic-pbr/Tfuel_vol_avg_SAM.svg
        style=width:50%
        id=Tfuel_avg
        caption=Average fuel and kernel temperatures predicted by SAM in the load-following transient simulation.

!media generic-pbr/Tmoderator_vol_avg_SAM.svg
        style=width:50%
        id=Tmoderator_avg
        caption=Average moderator temperature predicted by SAM in the load-following transient simulation.

!media generic-pbr/Treflector_mean_SAM.svg
        style=width:50%
        id=Treflector_avg
        caption=Average reflector temperature predicted by SAM in the load-following transient simulation.

The average coolant temperature at the outlet is shown in [Tout_avg]. The
overall trend of the outlet temperature matches the the trends of the fuel and
moderator temperatures. The coolant temperature increases as the flow rate is
reduced. On the other hand, when the flow rate is held constant at 25% of its
nominal value, the outlet temperature shows a small decrease of roughly 5 K over
a span of 30 minutes. Lastly, when flow rate is increased back to the nominal
value, the outlet temperature decreases rapidly before stabilizing at roughly
the same value as the temperature at the start of the transient.

!media generic-pbr/Tout_mean_SAM.svg
        style=width:50%
        id=Tout_avg
        caption=Average coolant temperature at the outlet predicted by SAM in the load-following transient simulation.

Given that the SAM and Griffin/Pronghorn models are
essentially two different approaches, some differences inevitably exist between
the steady-state temperatures predicted by both models. Furthermore, these
differences could be further exaggerated during transient. Hence,a direct comparison
of temperatures between the two sets of results could be misleading. As a result,
it is more insightful to compare the evolution of temperature of different regions
in the reactor during transient. To achieve that, the temperature changes of the
fuel, moderator, and reflector are shown in [delta_T_fuel], [delta_T_moderator],
and [delta_T_reflector], respectively. Note that the temperature change is
defined as the difference between the temperature at the start of transient and
the temperature at time *t* during transient. It should be pointed out that a
positive value represents a drop in temperature while a negative value represents
an increase in temperature with respect to the temperature at the start of transient.

As shown in [delta_T_fuel], the change in fuel temperature predicted by
Griffin/Pronghorn and SAM are relatively similar during the flow ramp down phase,
with the prediction from SAM showing a larger increase of temperature due to a
reduction in heat removal by the coolant. However, during the constant-flow phase,
the SAM prediction shows a decrease of temperature ranging from 1-4 K while the
Griffin/Pronghorn prediction is relatively uniform with only a small increase of
temperature of roughly 1-2 K. The difference in trends could be attributed to the
difference in power generated by the core where the SAM prediction experiences a
drop of roughly 500 kW of core power over the same period, thus leading to a small
decrease in fuel temperature. Finally, in the ramp up phase, the differences from
both models start to converge and eventually arrive at a reasonably good agreement
once the mass flow rate is returned to the nominal level. It should also be pointed
out that similar 'spikes' are observed in both sets of results at the termination
of flow ramp down (15 min) and the initiation of flow ramp up (45 min).

!media generic-pbr/delta_T_fuel.svg
        style=width:50%
        id=delta_T_fuel
        caption=Comparison of the fuel temperature change predicted by SAM and Griffin/Pronghorn.

The comparison of the change in moderator temperature is shown in
[delta_T_moderator] where the predictions from both models are observed to have
a good overall agreement. In the flow ramp down phase, the increase of moderator
temperature predicted by SAM and Griffin/Pronghorn are almost the same with that
by SAM being consistently greater by roughly 1 K. In the constant-flow phase,
the temperature change predicted by SAM and Griffin/Pronghorn start to diverge
as the reactor power predicted by SAM experiences a small decrease. However,
the difference diminishes when the flow is ramped up to its nominal value,
which is similar to the behavior of the fuel temperature discussed previously.
Finally, the change of reflector temperature is shown in [delta_T_reflector].
It is seen that the predictions from both models agree well with each other in
terms of the overall trend and magnitude, with the only difference being the
prediction by Griffin/Pronghorn showing a smoother change over time compared to
SAM's prediction.

!media generic-pbr/delta_T_moderator.svg
        style=width:50%
        id=delta_T_moderator
        caption=Comparison of the moderator temperature change predicted by SAM and Griffin/Pronghorn.

!media generic-pbr/delta_T_reflector.svg
        style=width:50%
        id=delta_T_reflector
        caption=Comparison of the reflector temperature change predicted by SAM and Griffin/Pronghorn.

# Acknowledgements

This work is supported by U.S. DOE Office of Nuclear Energy’s Nuclear Energy
Advanced Modeling and Simulation (NEAMS) program. The submitted manuscript has
been created by UChicago Argonne LLC, Operator of Argonne National Laboratory
(“Argonne”). Argonne, a U.S. Department of Energy Office of Science laboratory,
is operated under Contract No. DE-AC02-06CH11357. The authors would like to
acknowledge the support and assistance from Dr. Ryan Stewart and Dr. Paolo
Balestra of Idaho National Laboratory in the completion of this work.
