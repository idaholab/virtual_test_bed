## Steady-state results

The temperature and cross flow in the bypass are shown in [T_bypass] and [Cross_flow]. The power extracted by the flow in the bypass is about 2MW, and the maximum outlet temperature in the bypass is about 1370K. [Cross_flow] shows the flow redistribution at the core inlet because of the different flow resistance between the subchannels. [T_core] shows the resulting temperatures in the moderator and fuel.

!media media/gcmr/bypass_flow/T_bypass.png
      style=display: block;margin-left:auto;margin-right:auto;width:60%;
      id=T_bypass
      caption= Helium temperature in the bypass

!media media/gcmr/bypass_flow/Cross_flow.png
      style=display: block;margin-left:auto;margin-right:auto;width:60%;
      id=Cross_flow
      caption= Cross flow in the bypass

!media media/gcmr/bypass_flow/T_core.png
      style=display: block;margin-left:auto;margin-right:auto;width:60%;
      id=T_core
      caption= Temperature distribution in the core

## Run Commands

This simulation is run using Pronghorn by running the command below.
The Subchannel submodule of Pronghorn must be compiled with Pronghorn to run this input.

!listing
mpiexec -np number_of_cores /path/to/pronghorn-opt -i core.i

