# TREAT-like LEU Pulse Results; DRAFT

*Contact: Adam Zabriskie, Adam.Zabriskie@inl.gov*

## Results

Each of the input files outputs a .csv (CSV) and a .e (ExodusII) file containing various calculated values for power, temperature, power density, and so on.
The main macroscale input file outputs a .csv and .e file for each timestep of the simulation.

The power and energy of the 4.56 % $\Delta$k/k pulse over time are shown in [power] and [energy], respectively.

!media /htgr/pulse/power_time_evolution.png
       style=width:75%
       id=power
       caption=Pulse Power Over Time

!media /htgr/pulse/energy_time_evolution.png
       style=width:75%
       id=energy
       caption=Pulse Energy Over Time

The pulse's power peaks at over 12 GW around 0.325 seconds into the simulation, and its energy peaks at over 17 GW by the end of the simulation at 0.54 seconds.

The fuel grain and moderator shell temperatures are shown in [fg] and [modshell], respectively.

!media /htgr/pulse/fg_temp.png
       style=width:75%
       id=fg
       caption=Fuel Grain Temperature Time Evolution

!media /htgr/pulse/ms_temp.png
       style=width:75%
       id=modshell
       caption=Moderator Shell Temperature Time Evolution
