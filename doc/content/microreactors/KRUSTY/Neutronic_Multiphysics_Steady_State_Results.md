# Neutronic and Multiphysics Steady State Results


## a) Griffin Neutronic Results

The execution line for running the Griffin neutronic model is similar to the line shown in Figure 15. In this demonstration case, Griffin was parallel to 640 CPUs on an HPC cluster. The first line in the figure is to load the correct MOOSE environment as well as the Griffin application for running the job.

Results from running the Griffin input are shown in Table V and Figure 16. The k-effs of the KRUSTY neutronic model are compared with the Serpent reference result when fuel temperature was at 300 K or at 800 K while the temperatures for other regions remained at 300 K. Table V shows that good agreements were obtained among the Griffin neutronic model and the Monte Carlo reference model. In addition, the fuel Doppler reactivity calculated by both models also agree reasonably well. For KRUSTY, the dominated reactivity feedback is from the core thermal expansion. The small discrepancies in the calculated reactivity feedback from fuel Doppler will not play significant contributions to the power transient.

The axial power densities within the fuel region were tallied with both the Griffin neutronic model and the Serpent reference model when fuel and structure temperatures were all at 300 K. Figure 16 demonstrated excellent agreements of the Griffin calculations to the reference results in most of the core region. Griffin slightly overestimated the power production in the outermost layer (“r7”); however, this layer is very thin and its thickness is only about 2.1 mm as listed in Table I.

**Table V Comparison of the Griffin neutronic results with Monte Carlo reference result using the hybrid cross sections.**

|                | Serpent Reference |                 | Griffin + hybrid XS |                 |
|----------------|-------------------|-----------------|----------------------|-----------------|
|                | Tf = 300 K        | Tf = 800 K      | Tf = 300 K           | Tf = 800 K      |
| k-eff          | 1.00592           | 1.00523         | 1.007535             | 1.006908        |
| Δk-eff (pcm)   | (k-effSerp– k-effGriffin) | ----       | ---                  | -161.5          | -167.8          |
| Delta keff (pcm) | (k-eff800K– k-eff300K) | 69.0        | 62.7                 |                 |



!media media/KRUSTY/Fig_15.jpg
      style=display: block;margin-left:auto;margin-right:auto;width:60%;
      id=Fig_15
      caption= Griffin execution command




!media media/KRUSTY/Fig_16.jpg
      style=display: block;margin-left:auto;margin-right:auto;width:60%;
      id=Fig_16
      caption= Calculated fission power deposition in the KRUSTY radial regions (r1: inner first ring of annulus, r7: outermost ring) using the Griffin model and Serpent generated cross section and compared with reference results (solid line: reference result, dash line: Griffin results)



## b) Steady-State Multiphysics Simulation Result for the 15 ₵ Reactivity Insertion

Two sets of steady-state Multiphysics simulations are performed with the hybrid XS to estimate the height that the axial reflector is moved into the core to introduce 15₵ external reactivity. The displacement field that originates from axial reflector movement calculated by BISON is visualized in Figure 17. As shown in this figure, applying the 1.48 mm shift boundary condition to the bottom of the axial reflector assembly leads to a uniform shift of the structure as expected. The keff values before and after applying the axial reflector shift were calculated to be 1.007013 and 1.008018 using the Multiphysics coupled model. That leads to an increase of Δkeff by about 100.5 pcm which is about 14.5 ₵ with Serpent calculated β-eff of 690 pcm. Figure 18 shows the axial power distribution within the fuel disk. The upward shift of the axial reflector also slightly moves the power peaking upward within KRUSTY fuel region.



!media media/KRUSTY/Fig_17.jpg
      style=display: block;margin-left:auto;margin-right:auto;width:60%;
      id=Fig_17
      caption= Displacement field caused by axial reflector movement to insert reactivity



!media media/KRUSTY/Fig_18.jpg
      style=display: block;margin-left:auto;margin-right:auto;width:60%;
      id=Fig_18
      caption= The change in power peaking factor before and after the reactivity insertion caused by axial reflector shifting
