# Neutronic and Multiphysics Steady State Results


## Griffin Neutronic Results

The execution line for running the Griffin neutronic model is similar to the line shown in [griffin_exec_cmd]. In this demonstration case, Griffin was parallel to 640 CPUs on an HPC cluster. The first line in the [ax_power_griffin] is to load the correct MOOSE environment as well as the Griffin application for running the job.

Results from running the Griffin input are shown in [res_comp] and [ax_power_griffin]. The k-effs of the KRUSTY neutronic model are compared with the Serpent reference result when fuel temperature was at 300 K or at 800 K while the temperatures for other regions remained at 300 K. [res_comp] shows that good agreements were obtained among the Griffin neutronic model and the Monte Carlo reference model. In addition, the fuel Doppler reactivity calculated by both models also agree reasonably well. For KRUSTY, the dominated reactivity feedback is from the core thermal expansion. The small discrepancies in the calculated reactivity feedback from fuel Doppler will not play significant contributions to the power transient.

The axial power densities within the fuel region were tallied with both the Griffin neutronic model and the Serpent reference model when fuel and structure temperatures were all at 300 K. [ax_power_griffin] demonstrated excellent agreements of the Griffin calculations to the reference results in most of the core region. Griffin slightly overestimated the power production in the outermost layer (“$r_7$”); however, this layer is very thin and its thickness is only about 2.1 mm as described [before](Simplified_KRUSTY_Monte_Carlo_Model.md).

!table id=res_comp caption=Comparison of the Griffin neutronic results with Monte Carlo reference result using the hybrid cross sections
|   | Serpent Reference |   | Griffin + hybrid XS |   |
| - | - | - | - | - |
|                | Tf = 300 K        | Tf = 800 K      | Tf = 300 K           | Tf = 800 K      |
| $k_{eff}$          | 1.00592           | 1.00523         | 1.007535             | 1.006908        |
| $\Delta k_{eff}$ (pcm) ($k_{eff,Serp}$–$k_{eff,Griffin}$) |   |   | -161.5          | -167.8          |
| $\Delta k_{eff}$ (pcm) ($k_{eff,800K}$–$k_{eff,300K}$) | 69.0 |   | 62.7 |   |

!listing id=griffin_exec_cmd caption=Griffin execution command
module load use.moose moose-apps griffin
mpirun -n 640 griffin-opt -i krusty_ANL40_endf70_hybrid_SN35_NA3_coarse_CMFD_pd.i

!media media/KRUSTY/axial_power_griffin.png
      style=display: block;margin-left:auto;margin-right:auto;width:60%;
      id=ax_power_griffin
      caption= Calculated fission power deposition in the KRUSTY radial regions ($r_1$: inner first ring of annulus, $r_7$: outermost ring) using the Griffin model and Serpent generated cross section and compared with reference results (solid line: reference result, dash line: Griffin results)

## Steady-State Multiphysics Simulation Result for the 15 ₵ Reactivity Insertion

Two sets of steady-state Multiphysics simulations are performed with the hybrid XS to estimate the height that the axial reflector is moved into the core to introduce 15₵ external reactivity. The displacement field that originates from axial reflector movement calculated by BISON is visualized in [reactivity_insert]. As shown in this figure, applying the 1.48 mm shift boundary condition to the bottom of the axial reflector assembly leads to a uniform shift of the structure as expected. The keff values before and after applying the axial reflector shift were calculated to be 1.00701 and 1.00802 using the Multiphysics coupled model. That leads to an increase of $\Delta k_{eff}$ by about 100.5 pcm which is about 14.5 ₵ with Serpent calculated β-eff of 690 pcm. [ax_power_mp] shows the axial power distribution within the fuel disk. The upward shift of the axial reflector also slightly moves the power peaking upward within KRUSTY fuel region.

!media media/KRUSTY/reactivity_insertion.png
      style=display: block;margin-left:auto;margin-right:auto;width:60%;
      id=reactivity_insert
      caption= Displacement field caused by axial reflector movement to insert reactivity

!media media/KRUSTY/axial_power_multi.png
      style=display: block;margin-left:auto;margin-right:auto;width:60%;
      id=ax_power_mp
      caption= The change in power peaking factor before and after the reactivity insertion caused by axial reflector shifting
