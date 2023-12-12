# TRISO Failure Analysis Model Description

This heat pipe microreactor (HP-MR) Tri-structural ISOtropic (TRISO) fuel particle statistical failure model reflects the work described in [!citep](stauff2023multiphysics), which leverages the advanced multiphysics modeling of the HP-MR performed by the NEAMS Micro-Reactor Application Drivers area [!citep](Stauff2021) with the significant improvements made to the TRISO modeling capabilities in BISON. This analysis uses the MOOSE [Stochastic Tools module](https://mooseframework.inl.gov/modules/stochastic_tools/) and MultiApp functionality to conduct a Monte Carlo sampling scheme for several one-dimensional TRISO particles, accounting for microscopic particle-to-particle variations in geometry and material properties, such as layer thicknesses and bond strengths, respectively, that arise during TRISO fabrication. These fuel particle simulations rely on fuel temperature, power density, and hydrostatic stress boundary conditions retrieved from multiphysics simulations of the HP-MR. The HP-MR model currently available on VTB considers thermal physics only, and does not calculate tensor mechanics. Therefore, for this TRISO failure modeling demonstration, this multiphysics unit-cell HP-MR problem is included, with the HP-MR MultiApps multiphysics hierarchy, illustrated in Figure 3 of the [HP-MR Multiphysics Model Description](https://mooseframework.inl.gov/virtual_test_bed/microreactors/mrad/mrad_model.html), extended to include an additional BISON sub-app for the calculation of unit-cell tensor mechanics. An expansion of this analysis with the full HP-MR core is planned for future work.

## TRISO Particle Description

The HP-MR TRISO fuel particle is a spherical fuel particle composed of five concentric material layers: a central uranium oxycarbide (UCO) fuel kernel with 19.95 at% enrichment, a graphite buffer, and protective layers of inner pyrolytic carbon (IPyC), silicon carbide (SiC) and outer pyrolytic carbon (OPyC). The central fuel kernel has a nominal radius of 212.5 $\mathrm{\mu}$m. The buffer, IPyC, SiC, and OPyC layers have widths of 100 $\mathrm{\mu}$m, 40 $\mathrm{\mu}$m, 35 $\mathrm{\mu}$m, and 40 $\mathrm{\mu}$m, respectively. The average fast neutron flux within the particle is set to $7.664 \times 10^{15} \frac{n}{m^2 s}$. The oxygen-uranium and carbon-uranium stoichiometric ratios in the UCO are 1.5 and 0.4, respectively. Further details of the HP-MR TRISO are provided in the [model description](model_description.link). TRISO particle simulations are conducted for 10-year steady-state HP-MR operation without consideration of transients.

## HP-MR Unit-Cell Description

The HP-MR unit-cell is a simplification of the [full-core model](https://mooseframework.inl.gov/virtual_test_bed/microreactors/mrad/reactor_description.html), reduced to a single, central heat pipe rated to remove 1.8 kW, surrounded by three fuel pins and three moderator pins with reflective boundary conditions aong the unit-cell edge. The heat pipe, fuel pins, and moderator pins are all embedded in a graphite monolith. The active region of the unit cell is 160 cm, capped with 20-cm upper and lower axial reflectors made of beryllium metal. The fuel pins are TRISO fuel compacts, packed in graphite with 40% packing fraction. The apothem of the unit cell is 1.992 cm. The radial and axial layout of the unit-cell HP-MR is shown in the following figures:

!media media/mrad/hpmr_triso/hpmr_unit_cell.png
       style=width:60%
       caption=HP-MR Unit-Cell Radial Layout
       id=radial_layout

!media media/mrad/hpmr_triso/hpmr_unit_cell_ax.png
       style=display: block;margin-left:auto;margin-right:auto;width:25%;
       caption=HP-MR Unit-Cell Axial Layout
       id=axial_layout


