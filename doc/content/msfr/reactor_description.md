# Molten Salt Fast Reactor (MSFR) Description

The VTB MSFR model is based off of the MSFR design created under the Euratom
EVOL (Evaluation and Viability of Liquid Fuel Fast Reactor Systems) and ROSATOM
MARS (Minor Actinides Recycling in Molten Salt) projects
[!citep](brovchenko2019). It is a fast-spectrum reactor that produces 3 GW of
thermal power using fuel dissolved in a LiF carrier salt.

Most parameters and material properties of the VTB MSFR are taken from
[!citep](brovchenko2019). That reference specifies a block-style geometry with
all 90-degree angles, but we instead use a geometry with curved surfaces that
more closely matches "Geometry II" from [!citep](rouch2014).

Here a simplified 2D axisymmetric model is used. The geometry is shown below:

!media media/msfr/msfr_geometry/msfr_diagram.svg
       style=width:50%

The model includes a core region, a pump, and a heat exchanger. An interior
reflector shields the pump and heat exchanger from the high neutron flux in the
core. (Note that some models of the MSFR include a fertile blanket in this
region, but that blanket is neglected here as a simplification.) The model also
includes an outer reflector surrounding all of the components.

The exact dimensions of the VTB MSFR model are shown below. Note that this model
is vertically symmetric except for the pump and heat exchanger.

!media media/msfr/msfr_geometry/msfr_dimensions.svg
       style=width:80%

Per [!citep](brovchenko2019), the composition of the fuel salt is 19.985%
ThF$_4$, 2.515% U$^{233}$F$_4$, and 77.5% LiF (by mole). The nominal inlet and
outlet salt temperatures are 650 and 750 $^\circ$C, respectively
[!citep](brovchenko2019). A nickel alloy is assumed is assumed for the inner and
outer reflectors.
