# MSFR Nek5000 CFD Results

The steady-state solutions of velocity and turbulent kinetic energy (TKE) field 
in the MSFR core from the 2-D axisymmetric RANS case are shown
below. 

!media msfr_nek_2D_U.jpg
       style=width:80%
       id=msfr_vel
       caption=The steady-state velocity field from the 2-D MSFR RANS simulation.

!media msfr_nek_2D_TKE.jpg
       style=width:80%
       id=msfr_tke
       caption=The steady-state TKE field from the 2-D MSFR RANS simulation.

It is noticed that the velocity magnitude is higher in the peripheral 
region compared to core center, which is related to the velocity 
boundary condition given at the inlet. As for the TKE field, 
the regions of high  TKE value indicate strong local flow mixing. 
A velocity field with arrows is shown in [msfr_vel_vector] to illustrate 
the velocity directions and magnitudes of specific locations inside the core. 


!media msfr_nek_2D_U_Arrows.jpg
       style=width:80%
       id=msfr_vel_vector
       caption=The steady-state velocity field with arrows indicating local
       velocity directions. 

!alert note
It has been noticed that the flow field solutions are sensitive to the
inlet boundary conditions. The results shown above are the steady-state
solutions with a constant inlet velocity, which is not necessarily the case
in the actual MSFR. Additional studies are being conducted to reproduce the 
realistic inlet BC, which will help further improve the results. 