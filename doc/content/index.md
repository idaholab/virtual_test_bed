!config navigation breadcrumbs=False scrollspy=False

!style! class=vtb-home halign=center color=var(--nric-blue) fontweight=500 style=font-family:Josefin Sans style=font-size:300%
VIRTUAL TEST BED
!style-end!

!style! halign=center style=font-size:150%;font-weight:500;margin-bottom:1.5rem
Open, documented, and tested models to accelerate advanced reactor modeling & simulation.
!style-end!

!row!
!col! small=6 medium=6 large=6

The Virtual Test Bed (VTB) is an [open repository](https://github.com/idaholab/virtual_test_bed) containing a wide variety of [documented models](vtb_pages/models.md) supporting nuclear energy applications, primarily based on advanced reactor designs.
The VTB is sponsored by the [National Reactor Innovation Center (NRIC)](https://nric.inl.gov/) and supports its mission by facilitating the application of advanced modeling & simulation (M&S) tools toward efforts to accelerate the deployment of innovative reactor concepts. A [variety of tools](vtb_pages/codes.md) are represented in these models, primarily those developed under the [Nuclear Energy Advanced Modeling and Simulation (NEAMS) program](https://neams.inl.gov/).

- [!style class=vtb-item-title](Open-source). All files are available (free of charge) on [GitHub](https://github.com/idaholab/virtual_test_bed).
- [!style class=vtb-item-title](Broad coverage):

  - [77](vtb_pages/models.md) Documented models
  - [9](vtb_pages/models.md) Reactor types
  - [29](vtb_pages/codes.md) Codes and tools
- [!style class=vtb-item-title](Always current). [NEAMS](https://neams.inl.gov/)-code models are continuously updated and tested.
- [!style class=vtb-item-title](Multiphysics). Coupled neutronics, thermal hydraulics, thermo-mechanics, and more.
- [!style class=vtb-item-title](User-friendly). Find models with the [Model Filter](https://mooseframework.inl.gov/virtual_test_bed/resources/filter/index.html) or use the [AI assistant](vtb_pages/vtb_assistant.md).
- [!style class=vtb-item-title](Community-driven). [Contribute](vtb_pages/contributing.md) your own model.

!style! class=vtb-button
[Get started](vtb_pages/getting_started.md)
!style-end!

!col-end!

!col! small=6 medium=6 large=6

!style! class=nric-media-box
!slideshow! interval=5 side_arrows=False
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

!style! class=vtb-logos
!media logos/NRIC.png
       link=https://nric.inl.gov/
       alt=National Reactor Innovation Center (NRIC)

!media logos/INL_black.png
       dark_src=media/logos/INL_white.png
       link=https://inl.gov/
       alt=Idaho National Laboratory (INL)

!media logos/ANL_black.png
       dark_src=media/logos/ANL_white.png
       link=https://www.anl.gov/
       alt=Argonne National Laboratory (ANL)
!style-end!
