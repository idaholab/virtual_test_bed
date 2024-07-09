# Seismic analysis of a base-isolated nuclear power plant building

This model was adopted from the list of examples on the [MASTODON](https://mooseframework.inl.gov/mastodon/examples/index.html) website.

!alert note title=Units of this model
GN, GPa, m, and sec

## Part 2: NPP building analysis

Now that the seismic response with just the basemat is shown to be reasonable, the modeling and response of the seismically isolated building is presented in this section.

### Modeling

The finite-element mesh of the building, developed in Cubit is presented in [Figure 3](npp_building_pt1.md#fig:building_iso) in [Part 1](npp_building_pt1.md). The building is founded on the basemat and the isolation system presented in [Figure 2](npp_building_pt1.md#fig:iso_plan) in [Part 1](npp_building_pt1.md). The figures below show the plan view and an isometric view of the internal components of the building. The building is a one-story shear wall structure with buttresses on all four sides and the roof. It houses four steam generators (shown in purple and modeled as solid cylinders for simplicity) supported by individual concrete bases (in yellow), and head-supported reactor vessel is suspended by an internal concrete slab. The reactor vessel is contained in a concrete cylindrical housing that can be seen in red the figures below. The reactor vessel contains molten salt with properties that are assumed to be the same as water. The reactor vessel, as seen from the bottom without its housing or the internal walls, is shown in [fig:rv_bot] below.

!row!

!col! small=12 medium=6 large=6
!media media/seismic_analysis/building2.png
       style=width:100%;margin-right:0px;float:center;
       id=fig:building_int_iso
       caption=Isometric view of the internal components of the NPP building.
!col-end!

!col! small=12 medium=6 large=6
!media media/seismic_analysis/building3.png
      style=width:100%
      id=fig:building_int_plan
      caption=Plan view of the internal components of the NPP building.
!col-end!

!row-end!

!media media/seismic_analysis/rv_bot.png
      style=width:50%
      id=fig:rv_bot
      caption=Head-supported reactor vessel as seen from the bottom.

All the materials in the building are modeled using a linear elastic material and 3D 8-noded HEX elements, except for the FP isolators, which are modeled using two noded link elements with the FP isolator material model see [theory manual](https://mooseframework.inl.gov/mastodon/manuals/theory/index.html) and [user manual](https://mooseframework.inl.gov/mastodon/manuals/user/index.html) for more information. The reactor vessel is modeled as a thin cylindrical vessel using continuum elements. The fluid inside the reactor vessel is modeled using a linear elastic material with a very small shear modulus to reproduce fluid-like behavior. A more comprehensive, fluid-structure interaction (FSI) approach is also possible in MASTODON to model the fluid. More information on FSI modeling in MOOSE and MASTODON is provided [here](https://mooseframework.inl.gov/modules/fsi/index.html). Further information on the building model is also provided in [!citet](inl-ext-20-59608).

In this demonstration, the building is subjected to ground motions in X, Y, and Z directions at the base of the isolation system. These ground motions are presented in [Figure 1](npp_building_pt1.md#fig:inp_motion_xyz), and their spectral accelerations are shown in [Figure 6](npp_building_pt1.md#fig:inp_sa_x), [Figure 8](npp_building_pt1.md#fig:inp_sa_y), and [Figure 10](npp_building_pt1.md#fig:inp_sa_z_), all from [Part 1](npp_building_pt1.md). Pressure, temperature, and velocity dependencies of the isolators are switched on, as described in method 2 of [Part 1](npp_building_pt1.md) of this model. The first three timesteps of the analysis involve a static gravity analysis as described in the note above.

The input file for the simulation of Part 2 is listed below.

!listing seismic_analysis/building_basemat_with_isolators_new.i

### Outputs

The output locations and responses for Part 2 include the same as those of [Part 1](npp_building_pt1.md) (an isolator at the center of the isolation system and the center of the basemat). In addition to these responses, the acceleration response at the roof, at the center of the reactor head, and the base of one of the steam generators is shown below.

The figures below present the isolator shear responses in XZ and YZ directions calculated in the same manner described in [Part 1](npp_building_pt1.md).

!row!

!col! small=12 medium=6 large=6
!media media/seismic_analysis/building_fb_XZ.png
       style=width:100%
       id=fig:bu_fb_xz
       caption=Shear force-displacement history in the XZ direction for an isolator at the center of the isolation system.
!col-end!

!col! small=12 medium=6 large=6
!media media/seismic_analysis/building_fb_YZ.png
      style=width:100%
      id=fig:bu_fb_yz
      caption=Shear force-displacement history in the YZ direction for an isolator at the center of the isolation system.
!col-end!

!row-end!

The figure below present the building responses for the same input ground motions shown in [Part 1](npp_building_pt1.md). The first row presents the spectral accelerations in all three directions at a node located at the center of the basemat of the building (same node as [Part 1](npp_building_pt1.md)). The second, third, and fourth rows present these responses calculated at the center of the roof of the building, center of the reactor head, and at the base of one of the steam generators, respectively.

!row!

!col! small=12 medium=4 large=4
!media media/seismic_analysis/bm_sa_x.png
       style=width:100%
       id=fig:bm_sa_x
       caption=5% damped acceleration response spectra in X direction (basemat center)
!col-end!

!col! small=12 medium=4 large=4
!media media/seismic_analysis/bm_sa_y.png
       style=width:100%
       id=fig:bm_sa_y
       caption=5% damped acceleration response spectra in Y direction (basemat center)
!col-end!

!col! small=12 medium=4 large=4
!media media/seismic_analysis/bm_sa_z.png
       style=width:100%
       id=fig:bm_sa_z
       caption=5% damped acceleration response spectra in Z direction (basemat center)
!col-end!

!row-end!

!row!

!col! small=12 medium=4 large=4
!media media/seismic_analysis/broof_sa_x.png
       style=width:100%
       id=fig:broof_sa_x
       caption=5% damped acceleration response spectra in X direction (center of the building roof)
!col-end!

!col! small=12 medium=4 large=4
!media media/seismic_analysis/broof_sa_y.png
       style=width:100%
       id=fig:broof_sa_y
       caption=5% damped acceleration response spectra in Y direction (center of the building roof)
!col-end!

!col! small=12 medium=4 large=4
!media media/seismic_analysis/broof_sa_z.png
       style=width:100%
       id=fig:broof_sa_z
       caption=5% damped acceleration response spectra in Z direction (center of the building roof)
!col-end!

!row-end!

!row!

!col! small=12 medium=4 large=4
!media media/seismic_analysis/rv_bot_sa_x.png
       style=width:100%
       id=fig:rv_bot_sa_x
       caption=5% damped acceleration response spectra in X direction (center of reactor vessel head)
!col-end!

!col! small=12 medium=4 large=4
!media media/seismic_analysis/rv_bot_sa_y.png
       style=width:100%
       id=fig:rv_bot_sa_y
       caption=5% damped acceleration response spectra in Y direction (center of reactor vessel head)
!col-end!

!col! small=12 medium=4 large=4
!media media/seismic_analysis/rv_bot_sa_z.png
       style=width:100%
       id=fig:rv_bot_sa_z
       caption=5% damped acceleration response spectra in Z direction (center of reactor vessel head)
!col-end!

!row-end!

!row!

!col! small=12 medium=4 large=4
!media media/seismic_analysis/sg_bot_sa_x.png
       style=width:100%
       id=fig:sg_bot_sa_x
       caption=5% damped acceleration response spectra in X direction (base of one of the steam generators)
!col-end!

!col! small=12 medium=4 large=4
!media media/seismic_analysis/sg_bot_sa_y.png
       style=width:100%
       id=fig:sg_bot_sa_y
       caption=5% damped acceleration response spectra in Y direction (base of one of the steam generators)
!col-end!

!col! small=12 medium=4 large=4
!media media/seismic_analysis/sg_bot_sa_z.png
       style=width:100%
       id=fig:sg_bot_sa_z
       caption=5% damped acceleration response spectra in Z direction (base of one of the steam generators)
!col-end!

!row-end!
