# Experiment Introduction

## [!ac](IFR) X447/A Experiment

X447/A was designed to test the high-temperature performance of HT9 cladding and its compatibility with binary U-10Zr fuel [!citep](Pahl1993X447). The experiment utilized MK-D61 inner blanket driver type subassembly hardware. The coolant was orificed in this experiment to intentionally raise peak HT9 cladding temperature beyond 650 $^{\circ}$C. MK-D61 hardware adopted in X447/A usually contained 61 fuel pins (see [x447_overview]).

!media media/ebr2_x447_dp11/fig_x447.png
       id=x447_overview
       caption=Schematic showing the U-10Zr/HT9 pins locations in X447/A subassembly (data available in [!cite](Carmack2012X447)).
       style=width:60%

However, as EBR-II enforced a subassembly mean coolant outlet temperature of 544 $^{\circ}$C, 12 solid dummy fuel pins were included to reduce the subassembly total power. Then 19 HT9 clad and 30 D9 clad U-10Zr fuel pins were irradiated in the subassembly X447 to a burnup around 4.7 at.%. Then four HT9 clad pins were replaced with fresh fuel pins before the irradiation experiment continued as subassembly X447A to achieve an ultimate burnup of approximately 10 at.%. In the [!ac](IFR) X447/A experiment, all the HT9 clad pins were located in the inner region of the subassemblies to be exposed to high cladding temperature, while the D9 clad pins were located in the peripheral region along with dummy pins. In the presence of adjacent dummy pins, all the D9 clad pins experienced much lower irradiation temperatures and thus had no issues surviving throughout the experiment. At the end, among the 15 HT9 clad and U-10Zr fueled pins irradiated to approximately 10 at.% burnup, the cladding of two pins (DP70 and DP75) were found to have breached during the steady-state high-temperature irradiation. The cladding failure occurred near the top of the fuel slugs, corresponding to the peak cladding temperature locations. More importantly, severe [!ac](FCCI) wastage formation and prominent [!ac](CCCI) wastage formation were observed in those HT9 clad pins irradiated to ∼10 at.% burnup at elevated temperatures. In some cases, over one-third of the cladding thickness was consumed by [!ac](FCCI) wastage formation. Thus, the HT9 cladding failures observed in X447/A were determined to originate from a combined effect of [!ac](FCCI) wastage-induced cladding degradation and thermally-activated creep rupture caused by internal plenum pressure buildup. The X447/A experiment was a valuable experiment for [!ac](FCCI)/[!ac](CCCI) study because the wastage formation effects were prominent. In general, this experiment was important for HT9 cladding as it defined the operating condition envelope of applying HT9 cladding in a [!ac](SFR). Therefore, only the HT9 clad pins in X447/A experiment were investigated in this evaluation effort. In particular, four pins with most [!ac](PIE) data available (i.e., DP04, DP11, DP70, and DP75) are the focus here, as highlighted in [x447_overview]. These four pins are usually regarded as the pins that are most worth investigating within the [!ac](IFR) X447/A experiment [!citep](Nam1998X447).

## Fuel Pin DP11

As mentioned above, Pin DP11, irradiated in [!ac](IFR) X447/A experiment, is one of the four pins of interest in this study. Three of these four pins (i.e., DP04, DP11, and DP70) were the only three pins located in the central subassembly region that consists of 7 pins throughout the experiment, resulting in higher cladding temperatures compared to those near the peripheral region. Although Pin DP75 was located off the central subassembly area, the subassembly orientation during the X447A irradiation made this pin to experience relative higher linear power and consequent high cladding temperature. Among these four pins, Pins DP70 and DP75 experienced cladding breaches near the end of irradiation, while Pins DP04 and DP11 maintained their cladding integrity throughout the ∼10 at.% burnup. Given that pin breaching is a stochastic process, Pins DP04 and DP11 are considered the sibling unbreached pins of DP70 and DP75. This is particularly important, as post-irradiation examination (PIE) techniques are limited for breached pins due to compromised structural integrity and contamination concerns. Consequently, Pins DP04 and DP11 have the most comprehensive PIE data among all X447 pins. More importantly, as these two pins, especially Pin DP11, have been extensively studied and analyzed, all essential data for their fuel performance analysis is available in open literature. Therefore, Pin DP11 was selected as the focus of this VTB case, while the simulation of the other X447 pins and statistical analyses are covered by BISON's X447 assessment case.

### Pin Design Parameters

Like all the experimental fuel pins irradiated in the [!ac](IFR) X447/A experiment, Pin DP11 is a U-10Zr fuel clad by HT9 adopting the typical pin design used in EBR-II, as shown in [pin_des]. All these design parameters are also available in [!ac](FIPD).

!table id=pin_des caption=Key nominal design parameters of Pin DP11 (data available in [!cite](Nam1998X447))
| Item | Unit | Value | Comments |
| :- | :- | :- | :- |
| Fuel Slug OD | inch | 0.173 |   |
| Fuel Slug ID | inch | n/a | Plain fuel design free of central hole |
| Cladding OD | inch | 0.230 |   |
| Cladding Wall Thickness | inch | 0.015 |   |
| Fuel Slug Height | inch | 13.5 | Typical EBR-II fuel height |
| Fuel-Cladding Gap Width | inch | 0.0135 | 75% smeared density |
| Fuel-Cladding Bond | n/a | sodium |   |
| Sodium Fill Above Fuel | inch | 0.25 |   |
| Initial Plenum Gas | n/a | 75He-25Ar |   |
| Plenum-to-Fuel Volume Ratio | n/a | 1.40 | 7.5 cm$^3$ plenum volume at 25$^{\circ}$C |

### Operating Conditions and Irradiation History

Pin DP11 is one of the 15 U-10Zr/HT9 pins that were irradiated throughout the [!ac](IFR) X447/A experiment to reach ~10 at.% burnup. Per the experiment design, the pin was designed to maintain at a nominal linear power of 11 kW/ft with a peak cladding temperature exceeding 650 $^{\circ}$C and a fast neutron flux of 1.79$\times$10$^{15}$ n/cm$^2$/s. The total irradiation time was 619 [!ac](EFPD). Meanwhile, [!ac](FIPD) provides a comprehensive set of data for Pin DP11 with more details, which will be discussed in [next section](/dp11_data_integration.md).

### Relevant PIE Data

After the [!ac](IFR) X447/A experiment was conducted, a series of [!ac](PIE) efforts were made on Pin DP11 and its siblings to help understand the high-temperature fuel performance with a focus the fuel failure mechanisms. The [!ac](PIE) methods employed include [!ac](NRAD), gamma scan, fission gas analysis, contact/laser profilometry, metallography of sectioned fuel, etc. These data have been qualified, digitized (if applicable), and maintained in [!ac](FIPD).

!style halign=right
[Go to +Next Section: BISON-FIPD Integration+](/dp11_data_integration.md)