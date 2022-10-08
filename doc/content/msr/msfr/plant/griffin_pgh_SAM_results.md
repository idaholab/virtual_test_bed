## Evolution of the multiphysics fields during the transient

The evolution of the thermal-hydraulic fields and power predicted by the model
during the transient is shown in [results_1] and [results_2].
The reduction of pump head is shown by the dashed black line.
As the power in the pump reduces, the flow rate in the reactor reduces.
However, there is inertia associated with the flow, which causes the flow
to slowly decrease after the sudden drop in the pump head.
The power initially reduces due to the higher temperature as the flow stops.
Then, power increases due to the overcooled flow at the heat exchangers
entering the reactor and stabilizes back to a constant value.
Core inlet and outlet temperatures decrease towards a steady-state value.
A similar behavior is observed for the temperature at the heat exchangers.


!media media/msr/msfr/plant/transient_results_SAM.png
    style=width:90%
    id=results_1
    caption=Evolution of the pump head, power, and temperatures during the transient.

!media media/msr/msfr/plant/transient_results_pgh.png
    style=width:90%
    id=results_2
    caption=Evolution of key temperatures during the transient.


## Fields at the beginning and the end of the transient

The power density at the beginning and the end of the transient is shown in [pd_begin] and [pd_end], respectively.
The power density reduces its mean value but its shape is visibly unaffected.

!media media/msr/msfr/plant/power_density_beginning_transient.png
    style=width:60%
    id=pd_begin
    caption=Power density at the beginning of the transient.

!media media/msr/msfr/plant/power_density_end_transient.png
    style=width:60%
    id=pd_end
    caption=Shortest-lived precursor density at the end of the transient.

The velocity fields at the beginning and the end of the transient are shown in [vel_begin] and [vel_end], respectively.
Velocity reduces due the reduction in the pump head and a more homogeneous velocity field is obtained in the core at the end of the transient.

!media media/msr/msfr/plant/velocity_beginning_transient.png
    style=width:60%
    id=vel_begin
    caption=Velocity field magnitude at the beginning of the transient.

!media media/msr/msfr/plant/velocity_end_transient.png
    style=width:60%
    id=vel_end
    caption=Velocity field magnitude at the end of the transient.


The temperature fields at the beginning and the end of the transient are shown in [temp_begin] and [temp_end], respectively.
The temperature field slightly reduces at the end of the transient with an almost unaffected shape.

!media media/msr/msfr/plant/temperature_beginning_transient.png
    style=width:60%
    id=temp_begin
    caption=Temperature field at the beginning of the transient.

!media media/msr/msfr/plant/temperature_end_transient.png
    style=width:60%
    id=temp_end
    caption=Temperature field at the end of the transient.

The distributions of the precursor family concentration with the shortest lifetime at the beginning and the end of the transient are shown in [prec_begin] and [prec_end], respectively.
The mean value of the concentration reduces due to the reduction in the fission source and the shape of the distribution slightly homogenizes due to the reduction in the advective velocity.

!media media/msr/msfr/plant/precursor_density_beginning_transient.png
    style=width:60%
    id=prec_begin
    caption=Shortest-lived precursor density at the beginning of the transient.

!media media/msr/msfr/plant/precursor_density_end_transient.png
    style=width:60%
    id=prec_end
    caption=Power density at the end of the transient.