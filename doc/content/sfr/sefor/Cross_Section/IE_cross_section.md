# SEFOR MC$^2$-3 Model for Core I-E

The multigroup cross-section generation using MC$^2$-3 and ENDF/B-VII.1 library followed a two-step procedure and produced output in ISOTXS format. In the first step, a series of transport calculations were carried out using simple 0-D [GP_b_0D] or 1-D cylindrical models [Fu_st_1D] to obtain energy self-shielded cross sections over a fine energy grid  (> 1,000 energy groups). The 1-D cylindrical model is also shown in [mc23_1D].

!listing sfr/sefor/Cross_Section/Core-I-E_450K_ENDF71_step1.inp
         start=Na_GP_b
         end=exe_isotxs_modify
         id=GP_b_0D
         caption=MC$^2$-3 input for 0-D model of SEFOR Core I-E bottom grid plate

!listing sfr/sefor/Cross_Section/Core-I-E_450K_ENDF71_step1.inp
         start=FA_6_Fuel_St
         end=exe_isotxs_modify
         id=Fu_st_1D
         caption=MC$^2$-3 input for 1-D model of SEFOR Core I-E standard fuel assembly

!media media/sefor/MC2-3-model.png
      style=display: block;margin-left:auto;margin-right:auto;width:60%;
      id=mc23_1D
      caption= Mesh model of SEFOR Core I-E fuel assemblies: (a) Standard Assembly (SA), (b) SA with a B$_4$C rod (AFA)

These detailed cross sections were then applied to an approximate RZ model of the full SEFOR reactor core [2DANT]. The TWODANT code was used to perform the neutron transport calculation within this RZ geometry [!citep](Alcouffe1984sefor).

!listing sfr/sefor/Cross_Section/Core-I-E_450K_ENDF71_step1.twodant.inp
         start=ngroup
         end=chi
         id=2DANT
         caption=TWODANT input for modeling SEFOR Core I-E

Fluxes from the transport calculations included both neutron leakage and spatial self-shielding effects. In the second step, the flux distributions from TWODANT were used within MC$^2$-3 to condense the fine-energy grid cross sections to the ANL 33-group structure as shown in [mc3_step2].

!listing sfr/sefor/Cross_Section/Core-I-E_450K_ENDF71_step2.inp
         start=$library
         end=exe_mcc3
         id=mc3_step2
         caption=MC$^2$-3 input for step 2 calculation

The ISOTXS cross section file was converted into the ISOXML format using the ISOXML utility in Griffin. Microscopic cross sections were generated for reactor core temperatures ranging from 350 °F to 750 °F, with increments of 50 °F for Core I-E. The model included 18 homogenized zones including the bottom grid plate, core top (Na_steel), downcomers (inside or outside the vessel DC_IV/DC_OV), radial reflectors and radial shields, as well as various homogenized fuel assembly regions.
