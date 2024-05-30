# Simplified KRUSTY Monte Carlo Model


KRUSTY is a small-sized fast neutron reactor which features three U-7.65Mo fuel cylinders stacked on top of each other with a hole at the center for placing source boxes or control stack. These fuel cylinders, with their axial BeO reflectors, top axial shield plates, and radial stainless steel (SS) shield blocks, hang down from the top of the testing facility. The radial BeO reflectors and the bottom SS shielding plates sit on a movable platen. The reactor core reaches criticality by pushing the movable platen up to allow radial reflectors to cover the fuel disk and reduce neutron leakage from the core.

Figure 1 (a) and (b) are drawings of the facility using the simplified MCNP6 model based on the models in the ICSBEP benchmark in which four out of the eight locations for heat pipes were filled. Some of the key geometry parameters such as the radius and height of the fuel, reflector, and shield regions are marked in Figure 2 and are listed in Table I. Detailed geometry dimensions of each region can be found in the attached input for the MOOSE Reactor module.

The simplified MCNP6 model was obtained for this VTB model through the following:
1. Homogenizing the radial shield region and removing the horizontal wand plug.
2. Homogenizing the different radial reflector blocks.
3. Closing air gaps and holes for plugs below the lower reflectors.

The eigenvalue from the simplified MCNP6 model is listed in Table II and is compared with that obtained from the ICSBEP benchmark model. The results show that using ENDF/B-VIII.0, the simplified MCNP6 model is close to the detailed ICSBEP model with a slightly larger k-eff of about 34 pcm. An equivalent Serpent model of the simplified MCNP6 model was created for providing reference solutions and generating multigroup cross sections for the Griffin neutronic model. Its k-eff agreed with the result from the MCNP6 model as shown in Table II. With all heat pipe locations filled and the use of the ENDF/B-VII.0 library, the reference k-eff for the Griffin neutronic calculation is 1.00590±3 pcm.

 **Table I. Key Geometry Parameters of ANL Simplified Model**

| Label | Value (cm) | Label | Value (cm) | Label | Value (cm) | Label | Value (cm) |
|-------|------------|-------|------------|-------|------------|-------|------------|
| r1    | 7.1406     | r2    | 19.0500    | r3    | 50.9600    | r7    | 1.9939     |
| r8    | 2.6000     | r9    | 3.1750     | r10   | 3.6000     | r11   | 4.1000     |
| r12   | 4.4517     | r13   | 5.2859     | r14   | 5.4991     | r15   | 6.0325     |
| r16   | 6.3500     | r17   | 7.0491     | r18   | 7.1406     | H0    | 84.1414    |
| H1    | 28.6043    | H2    | 25.0012    |       |            |       |            |


**Table II. Calculated k-eff from KRUSTY Monte Carlo Models**

| Model                | k-eff                      |
|----------------------|----------------------------|
| ICSBEP MCNP6         | 1.00042 ± 2 pcm            |
| (ENDF/B-VIII.0)      |                            |
| MCNP6                | 1.00076 ± 1 pcm            |
| (ENDF/B-VIII.0)      |                            |
| Serpent              | 1.00081 ± 3 pcm            |
| (ENDF/B-VIII.0)      |                            |
| Serpent              | 1.00590 ± 3 pcm            |
| (ENDF/B-VII.0)       |                            |



!media media/KRUSTY/Fig_1.jpg
      style=display: block;margin-left:auto;margin-right:auto;width:60%;
      id=Fig_1
      caption= New/VTB simplified MCNP6 model (a) Y-Z view (b) X-Z view



!media media/KRUSTY/Fig_2.jpg
      style=display: block;margin-left:auto;margin-right:auto;width:60%;
      id=Fig_2
      caption= Key geometry parameters of VTB simplified MCNP6 model with 4 heat pipe locations filled (a) Y-Z view (b) X-Z view
