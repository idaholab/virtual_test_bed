# MSFR Griffin-Pronghorn Results

The Griffin-Pronghorn model predicts the following steady-state velocity and
temperature fields in the MSFR:

!media media/msfr/msfr_steady_v.png
       style=width:60%

!media media/msfr/msfr_steady_T.png
       style=width:60%

Note that the uniform eddy viscosity model leads to significant diffusion
throughout the reactor and, thus, relatively smooth temperature and velocity
fields with no flow separation. Also note that the highest temperature is found
at the top of the core and in the low-flow region along the centerline. The
salt here will be in direct contact with the core structure and may challenge
the temperature limitations of the structural material.

The Griffin-Pronghorn model also provides the steady-state distributions of the
delayed neutron precursors. The distributions of 3 (of the 6) groups are shown
below. For this plot, the concentrations have been normalized so that the
maximum value for each group is unity.

!media media/msfr/msfr_steady_c136.png
       style=width:100%

Group 6 has the shortest half-life (240 ms), and its behavior is dominated by
radioactive decay rather than advection. Consequently, its distribution
closely matches the fission distribution, with a distinct peak in the middle of
the core. Groups 3 and 1 have longer half-lives (6 and 52 s, respectively), so
they are more readily advected and diffused by the fluid. In fact, the
distribution of the slowest decaying group, group 1, is nearly uniform
throughout the salt.
