# Steady state simulation results

!alert note
Under construction. These results were obtained with the previous iteration of the model, which did not model the outer reflector. We will update them shortly.

We report here the steady state results of this coupled multiphysics simulation.

The power distribution peaks near the outer graphite reflector in the axial center of the core, the fluid temperature distribution peaks near the outlet, roughly near the middle of the active cylindrical shell. The solid phase temperature peaks in a similar location, while the UO$_2$ phase in TRISO peaks closer to the maximum of the power distribution. This shows the importance of multidimensional simulations to evaluate fuel performance during a transient, as 1D models cannot resolve both the axial and radial characteristics of each profile. The reader should note that the real Mk1 PB-FHR geometry features a large flow channel near the defueling chute, which would naturally lead to more cross-flow towards the outside of the core.

!alert note
The pressure drop is larger than computed in [!citep](novak2021), and further investigation should reconcile the two models. It is likely that the absence of bypass flow in the FV model, plus the use of purely axial inlet and outlet boundary conditions, is the cause of the discrepancy.

!row!
!col small=12 medium=6 large=6
!media media/pbfhr/steady/power_steady.png
       style=width:46%
       caption=Power distribution

!col small=12 medium=6 large=6
!media media/pbfhr/steady/TUO2.png
      style=width:30%
      caption=UO$_2$ temperature
!row-end!

!row!
!col small=12 medium=6 large=6
!media media/pbfhr/steady/solid_temp.png
       style=width:46%
       caption=Solid phase temperature

!col small=12 medium=6 large=6
!media media/pbfhr/steady/salt_temp.png
      style=width:30%
      caption=Salt temperature
!row-end!

!row!
!col small=12 medium=6 large=6
!media media/pbfhr/steady/pressure.png
       style=width:46%
       caption=Pressure

!col small=12 medium=6 large=6
!media media/pbfhr/steady/velocity.png
      style=width:30%
      caption=Superficial velocity
!row-end!
