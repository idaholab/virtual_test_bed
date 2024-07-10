# Simplified KRUSTY Monte Carlo Model

KRUSTY is a small-sized fast neutron reactor which features three U-7.65Mo fuel cylinders stacked on top of each other with a hole at the center for placing source boxes or control stack. These fuel cylinders, with their axial BeO reflectors, top axial shield plates, and radial stainless steel (SS) shield blocks, hang down from the top of the testing facility. The radial BeO reflectors and the bottom SS shielding plates sit on a movable platen. The reactor core reaches criticality by pushing the movable platen up to allow radial reflectors to cover the fuel disk and reduce neutron leakage from the core.

!media media/KRUSTY/sim_mcnp6_model.jpg
      style=display: block;margin-left:auto;margin-right:auto;width:60%;
      id=sim_mcnp_model
      caption= New/VTB simplified MCNP6 model (a) Y-Z view (b) X-Z view

[sim_mcnp_model] (a) and (b) are drawings of the facility using the simplified MCNP6 model based on the models in the ICSBEP benchmark in which four out of the eight locations for heat pipes were filled. Some of the key geometry parameters such as the radius and height of the fuel, reflector, and shield regions are marked in [mcnp_geom] and are listed in [geo_params]. Detailed geometry dimensions of each region can be found in the attached input for the MOOSE Reactor module.

!media media/KRUSTY/mcnp6_key_geom.jpg
      style=display: block;margin-left:auto;margin-right:auto;width:60%;
      id=mcnp_geom
      caption= Key geometry parameters of VTB simplified MCNP6 model with 4 heat pipe locations filled (a) Y-Z view (b) X-Z view

The simplified MCNP6 model was obtained for this VTB model through the following:
1. Homogenizing the radial shield region and removing the horizontal wand plug.
2. Homogenizing the different radial reflector blocks.
3. Closing air gaps and holes for plugs below the lower reflectors.

The eigenvalue from the simplified MCNP6 model is listed in [tab_keff] and is compared with that obtained from the ICSBEP benchmark model. The results show that using ENDF/B-VIII.0, the simplified MCNP6 model is close to the detailed ICSBEP model with a slightly larger $k_{eff}$ of about 34 pcm. An equivalent Serpent model of the simplified MCNP6 model was created for providing reference solutions and generating multigroup cross sections for the Griffin neutronic model. Its $k_{eff}$ agreed with the result from the MCNP6 model as shown in [tab_keff]. With all heat pipe locations filled and the use of the ENDF/B-VII.0 library, the reference $k_{eff}$ for the Griffin neutronic calculation is 1.00592±3 pcm.

!table id=geo_params caption=Key Geometry Parameters of ANL Simplified Model
| Label | Value (cm) | Label | Value (cm) | Label | Value (cm) | Label | Value (cm) |
| - | - | - | - | - | - | - | - |
| $r_1$ | 7.1406 | $r_2$ | 19.0500 | $r_3$ | 50.9600 | $r_7$ | 1.9939 |
| $r_8$ | 2.6000 | $r_9$ | 3.1750 | $r_{10}$ | 3.6000 | $r_{11}$ | 4.1000 |
| $r_{12}$ | 4.4517 | $r_{13}$ | 5.2859 | $r_{14}$ | 5.4991 | $r_{15}$ | 6.0325 |
| $r_{16}$ | 6.3500 | $r_{17}$ | 7.0491 | $r_{18}$ | 7.1406 | $H_0$ | 84.1414 |
| $H_1$ | 28.6043 | $H_2$ | 25.0012 |   |   |   |   |

!table id=tab_keff caption=Calculated $k_{eff}$ from KRUSTY Monte Carlo Models
| Model | Model Detail | $k_{eff}$ |
| - | - | - |
| ICSBEP MCNP6 | (ENDF/B-VIII.0) | 1.00042 ± 2 pcm |
| MCNP6 | (ENDF/B-VIII.0) | 1.00076 ± 1 pcm |
| Serpent | (ENDF/B-VIII.0) | 1.00081 ± 3 pcm |
| Serpent | (ENDF/B-VII.0) | 1.00592 ± 3 pcm |
