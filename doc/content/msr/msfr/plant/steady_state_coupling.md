# Steady state Griffin-Pronghorn-SAM coupling

Griffin, Pronghorn, and SAM are coupled with a domain overlapping approach. 
The steady-state Griffin-Pronghorn coupled model is described at [Griffin-Pronghorn model](msfr/griffin_pgh_model.md).
The coupling scheme between the Griffin-Pronghorn and SAM models is shown in [msfr_coupling].

!media msr/msfr/plant/MSFR_coupling_domain_overlap.png
       style=width:90%
       id=msfr_coupling
       caption=Coupling scheme between the different physics solvers

The core power is computed by the Griffin-Pronghorn model.
This power is then applied to the core in SAM.
Then, the computed cold primary heat exchanger temperature in SAM is applied as the cold source temperature in the Pronghorn model.
The main blocks of the coupling are presented here below.

## MultiApp coupling Griffin-Pronghorn to SAM

Pronghorn is the main application, whereas SAM is the sub-application.
The ***MultiApp*** transferring data between Pronghorn and SAM is shown here below.
This is a ***TransientMultiApp*** with matched time steps between Pronghorn and SAM.

!listing msr/msfr/plant/steady/run_ns.i block=MultiApps


The two key transfers are shown in the following block.
They consist of ***MultiAppPostprocessorVectorTransfer*** in which values between
post-processors are communicated between both codes.

!listing msr/msfr/plant/steady/run_ns.i block=Transfers

## Post-processors transferred

Two sets of postprocessors are implemented to transfer data between Pronghorn and SAM.
To transfer power, an ***ElementIntegralVariablePostprocessor*** computes the total power
in Pronghorn (transferred previously from Griffin) and sends it to a ***Receiver*** postprocessor in SAM.

!listing msr/msfr/plant/steady/run_ns.i block=total_power

!listing msr/msfr/plant/steady/msfr_system_1d.i block=core_power


To transfer the heat exchanger cold temperature, an ***ElementAverageValue*** computes the heat exchanger cold temperature in SAM and sends it to a ***Receiver*** postprocessor in Pronghorn.

!listing msr/msfr/plant/steady/msfr_system_1d.i block=HX_cold_temp

!listing msr/msfr/plant/steady/run_ns.i block=heat_exchanger_T_ambient


