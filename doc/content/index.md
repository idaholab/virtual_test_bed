!config navigation breadcrumbs=False scrollspy=False

!style! halign=center color=var(--nric-blue) fontweight=500 style=font-family:Josefin Sans style=font-size:300%
VIRTUAL TEST BED
!style-end!

!row!
!col! small=4 medium=4 large=4

The Virtual Test Bed (VTB) is an [open repository](https://github.com/idaholab/virtual_test_bed) containing a wide variety of [documented models](vtb_pages/models.md) supporting nuclear energy applications, primarily based on advanced reactor designs. The VTB is sponsored by the [National Reactor Innovation Center (NRIC)](https://nric.inl.gov/) and supports its mission by facilitating the application of advanced modeling & simulation (M&S) tools toward efforts to accelerate the deployment of innovative reactor concepts. A [variety of tools](vtb_pages/codes.md) are represented in these models, primarily those developed under the [Nuclear Energy Advanced Modeling and Simulation (NEAMS) program](https://neams.inl.gov/). Models employing NEAMS codes are continuously tested and maintained so that they always run with current code versions.

!col-end!

!col! small=8 medium=8 large=8 style=padding-left:2rem

!style! class=nric-media-box style=background-color:var(--nric-dark-teal);padding:15px;border-radius:12px
!slideshow! interval=5
!slide! drum_rotation/eigenvalue.png caption=Initial power and temperature profiles in microreactor control drum rotation simulation.
Model: [microreactors/drum_rotation/index.md]
!slide-end!

!slide! msr/msre/MSRE_pgh_fields.png caption=Steady-state fuel salt temperature, velocity, and power density in the Molten Salt Reactor Experiment (MSRE).
Model: [msr/msre/multiphysics_rz_model/index.md]
!slide-end!

!slide! vtr/sflux_g0_cold_hot.png caption=Normalized fast flux at core mid-plane in the Versatile Test Reactor (VTR).
Model: [sfr/vtr/index.md]
!slide-end!

!slide! htgr/assembly_fluid_temp.png caption=Fluid and solid temperatures predicted for a prismatic HTGR assembly.
Model: [htgr/assembly/index.md]
!slide-end!
!slideshow-end!
!style-end!

!col-end!

!row-end!

