# LEU Fuel Pulse Results

*Contact: Adam Zabriskie, Adam.Zabriskie@inl.gov*

## Results

Each of the input files outputs a .csv (CSV) and a .e (ExodusII) file containing various calculated values for power, temperature, power density, and so on.
These results are from the macroscale simulation outputs.

The power and energy of the 4.56 % $\Delta$k/k pulse over time are shown in [power] and [energy], respectively.

!media /htgr/pulse/power_time_evolution.png
       style=width:70%
       id=power
       caption=Pulse Power Over Time

!media /htgr/pulse/energy_time_evolution.png
       style=width:70%
       id=energy
       caption=Pulse Energy Over Time

The pulse's power peaks at over 12 GW around 0.325 seconds into the simulation, and its energy peaks at over 17 GW by the end of the simulation at 0.54 seconds.

The fuel grain and moderator shell average temperatures are shown in [fg] and [modshell], respectively.

!media /htgr/pulse/fg_temp.png
       style=width:70%
       id=fg
       caption=Fuel Grain Temperature Time Evolution

!media /htgr/pulse/ms_temp.png
       style=width:70%
       id=modshell
       caption=Moderator Shell Temperature Time Evolution

For a more detailed discussion of the results, see [!citep](zabriskie2019).