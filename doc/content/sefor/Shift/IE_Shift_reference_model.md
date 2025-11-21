# Shift Reference Model for SEFOR Core I-E

The SEFOR core could accommodate maximumly 109 hexagon fuel assemblies. A standard fuel assembly contained six fuel rods arranged around a central structure rod and reinforced with six steel side rods. These fuel rods contained ~18.7% fissile plutonium (Pu239 and Pu241) and were held in their positions by a hex sleeve surrounding a central rod. In addition to the Standard fuel Assemblies (SA), several variants were used in SEFOR core configuration I-E, including substitutions for standard fuel rods by Guinea Pig (GP) rods with higher fissile Pu concentration of 25.0% or by B4C rods (AFA). A “Drywell” channel was located at the center of the core, which was mostly empty and housed experimental devices such as the Fast Reactivity Excursion Device (FRED) during transient tests. 

The input for developing the Shift reference model Core I-E is listed in [Shift_scale_input] and [Shift_omn_input]. The Shift simulation employed 500,000 neutron histories per cycle for a total of 500 cycles, of which 50 cycles were inactive. This calculation conditions produced a standard deviation in k-eff of approximately 4 pcm.

!listing sfr/sefor/Shift_Reference/Core_I-E_450K.inp
         id=Shift_scale_input         

!listing sfr/sefor/Shift_Reference/Core_I-E_450K_ENDF71.omn
         id=Shift_omn_input         

[Shift_model] (a) shows the horizontal cut view of a Shift model for Core I-E. The 10 radial reflector sectors were sandwiched between the outside radial shield and an inner homogenized cylindrical region representing part of the downcomer outside its reactor vessel (DC_OV). The center hexagonal lattice contains 109 fuel assemblies. The space between the fuel lattice and the DC_OV was a homogenized region representing the reactor downcomer within the reactor vessel (DC_IV). 

!media media/sefor/Core_IE_Shift_model.png
      style=display: block;margin-left:auto;margin-right:auto;width:60%;
      id=Shift_model
      caption= Shift Monte Carlo model of SEFOR Core I-E with (a) X-Y view (b) X-Z view

[Shift_FA_model] (a) to (d) depict the detail geometry of a normal SA, a SA with 1 GP rod and 1 B4C rod, a SA with 2 GP rods or a SA with 1 B$_4$C rod (AFA) used in Core I-E.

!media media/sefor/Core_IE_Shift_FA.png
      style=display: block;margin-left:auto;margin-right:auto;width:60%;
      id=Shift_FA_model
      caption= Shift Monte Carlo model of SEFOR Core I-E fuel assemblies: (a) Standard Assembly (SA), (b) SA with a GP rod and a B$_4$C rod, (c) SA with 2 GP rods, and (d) AFA

[Shift_model] (b) illustrates the unique segmented design of a standard SEFOR fuel rod in SEFOR. Each rod incorporated nickel reflectors at both ends, depleted UO2 insulation layers separating the MOX fuel into segments. To mitigate reactivity feedback from fuel axial expansion, all standard fuel rods including GP rods included a central spring to create an expansion gap. This design feature was essential for reducing reactivity feedback from fuel axial expansion and accurately measuring reactivity feedback from the fuel Doppler effect. Neutronic models (Shift and Griffin) used a VOID region to describe the spring region.  
