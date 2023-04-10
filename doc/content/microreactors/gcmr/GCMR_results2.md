## Results - Dynamic Multiphysics simulation of RIA

This simulation studies a postulated reactivity insertion accident (RIA) in the GC-MR assembly by assuming a rapid partial withdrawal of the control rod that induces 1.03$ positive reactivity insertion at the hot full power condition. A 3-D dynamic Multiphysics simulation was completed by coupling Griffin, BISON, SAM, where the Griffin transport solver DFEM-SN with CMFD acceleration was used. As shown in [Fig_7], initially, the power rapidly increases to a high peak while the fuel temperature starts to slowly increase with time as shown in [Fig_8]. After about 0.65 sec the negative thermal reactivity feedback of the system (mainly Doppler reactivity feedback) becomes dominant and starts to decrease the power. Although after ~0.65 sec the reactor power starts to decrease, the fuel temperature continues to increase because the power level is still above the nominal power. [Fig_9] shows the 3-D temperature distribution at time = 0.65 sec where the maximum temperature is 1344 K. The maximum fuel temperature at the end of the simulation is ~1615K. 

!media media/gcmr/Fig_7.png
      style=display: block;margin-left:auto;margin-right:auto;width:60%;
      id=Fig_7
      caption= The variation of the power during the RIA

!media media/gcmr/Fig_8.png
      style=display: block;margin-left:auto;margin-right:auto;width:60%;
      id=Fig_8
      caption= The variation of the power average fuel temperature during the RIA


!media media/gcmr/Fig_9.png
      style=display: block;margin-left:auto;margin-right:auto;width:60%;
      id=Fig_9
      caption= 3-D temperature distribution during RIA at time = 0.65 sec


The simulation was done with a constant inlet coolant temperature strategy and the results demonstrate limited variations of outlet temperature and coolant velocity at the outlet in each of the coolant channels. For example, in the coolant channel located at x= -0.034641, y= 0.06 the inlet and outlet coolant temperatures and velocities are plotted in [Fig_10] and [Fig_11], respectively. 

!media media/gcmr/Fig_10.png
      style=display: block;margin-left:auto;margin-right:auto;width:60%;
      id=Fig_10
      caption= Inlet and outlet coolant temperatures at coolant channel (x= -0.034641, y= 0.06) during RIA


!media media/gcmr/Fig_11.png
      style=display: block;margin-left:auto;margin-right:auto;width:60%;
      id=Fig_11
      caption= Inlet and outlet velocities at coolant channel (x= -0.034641, y= 0.06) during RIA



## Run Commands

In this simulation the parent app is Griffin, but the child apps are BISON and SAM, so we run the blue_crab code package:

!listing  
mpirun -np number_of_cores /path/to/blue_crab-opt -i Griffin_steady_state.i

Then, the user needs to run the Parent App for transient calculations as follows: 

!listing  
mpirun -np number_of_cores /path/to/blue_crab-opt -i Griffin_transient.i

