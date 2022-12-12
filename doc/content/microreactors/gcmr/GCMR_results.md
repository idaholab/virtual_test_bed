## Results - Dynamic Multiphysics simulation of flow blockage

Total flow blockage of one channel at the center of the GC-MR assembly was simulated by time-dependent Multiphysics coupling of Griffin, BISON and SAM. The simulated transient models a localized flow-blockage transient in only one channel. In such scenario, only the temperature near the blocked channel increases with a slight drop in reactor power. As shown in [Fig_4] and [Fig_5], the relaxation time is relatively small compared since all the other cooling channels are still functional after the transient occurs. It only takes ~400 seconds for the system to reach new equilibrium. The assembly power is predicted to drop by only ~10 kW, while the local maximum temperature increases by ~40 K. The system reaches a new equilibrium after ~500 sec. The 3-D power and temperature distributions after 500 sec are demonstrated in [Fig_6].

!media media/gcmr/Fig_4.png
      style=display: block;margin-left:auto;margin-right:auto;width:60%;
      id=Fig_4
      caption= Time evolution of maximum fuel temperature 

!media media/gcmr/Fig_5.png
      style=display: block;margin-left:auto;margin-right:auto;width:60%;
      id=Fig_5
      caption= Time evolution of assembly power

!media media/gcmr/Fig_6.png
      style=display: block;margin-left:auto;margin-right:auto;width:60%;
      id=Fig_6
      caption= The power density and temperature profiles at 500 s after the transient

## Run Commands

In this simulation the parent App is Griffin, thus the user only needs to run first the Parent App for steady-state as follows: 

!listing  
mpirun -np number_of_cores /path/to/griffin-opt -i Griffin_steady_state.i

Then, the user needs to run the Parent App for transient calculations as follows: 

!listing  
mpirun -np number_of_cores /path/to/griffin-opt -i Griffin_transient.i
