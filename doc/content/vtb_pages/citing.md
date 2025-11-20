# Citing

If you make use of the Virtual Test Bed, please reference this paper as well as the relevant papers for the reactor models and the numerical codes.

```
@article{vtb2023,
author = {Guillaume L. Giudicelli and Abdalla Abou-Jaoude and April J. Novak and Ahmed Abdelhameed and Paolo Balestra and Lise Charlot and Jun Fang and Bo Feng and Thomas Folk and Ramiro Freile and Thomas Freyman and Derek Gaston and Logan Harbour and Thanh Hua and Wen Jiang and Nicolas Martin and Yinbin Miao and Jason Miller and Isaac Naupa and Dan O’Grady and David Reger and Emily Shemon and Nicolas Stauff and Mauricio Tano and Stefano Terlizzi and Samuel Walker and Cody Permann},
title = {The Virtual Test Bed (VTB) Repository: A Library of Reference Reactor Models Using NEAMS Tools},
journal = {Nuclear Science and Engineering},
volume = {0},
number = {0},
pages = {1-17},
year  = {2023},
publisher = {Taylor & Francis},
doi = {10.1080/00295639.2022.2142440},
URL = {https://doi.org/10.1080/00295639.2022.2142440}
}
Giudicelli et al., "The Virtual Test Bed (VTB) Repository A Library of Reference Reactor Models Using NEAMS Tools", Journal of Nuclear Science and Engineering, 0-0, pp 1-17, (2023)
```

## Reactor models

If you make use of models in the repository to build models for a published study, please reference
the following:

### Molten Salt Reactor style=font-size:125%

- Molten Salt Fast Reactor (MSFR) core multiphysics

```
@article{aboujaoude2021,
         title = {A Workflow Leveraging MOOSE Transient Multiphysics Simulations to Evaluate the Impact of Thermophysical Property Uncertainties on Molten-Salt Reactors},
         author = {A. Abou-Jaoude and S. Harper and G. Giudicelli and P. Balestra and S. Schunert and N.Martin and A. Lindsay and M. Tano},
         journal = {Annals of Nuclear Energy},
         volume = {163},
         pages = {108546},
         doi = {https://doi.org/10.1016/j.anucene.2021.108546},
         url = {https://www.sciencedirect.com/science/article/pii/S0306454921004229},
         year = 2021
        }
A. Abou-Jaoude, S. Harper, G. Giudicelli, P. Balestra, S. Schunert, N.Martin, A. Lindsay and M. Tano, "A Workflow Leveraging MOOSE Transient Multiphysics Simulations to Evaluate the Impact of Thermophysical Property Uncertainties on Molten-Salt Reactors", Annals of Nuclear Energy 163, 108546, (2021)
```

- MSFR Plant multiphysics analysis (MSFR Pronghorn-Griffin-SAM model)

```
@InProceedings{Tano_MSR_2022,
               title={Coupled Griffin-Pronghorn-SAM Model of a Molten Salt Fast Reactor System Transient in the Virtual Test Bed},
               author={Mauricio E. Tano and Jun Fang and Guillaume Giudicelli and Abdalla Abou-Jaoude},
               year = {2022},
               booktitle = {Transactions of the American Nuclear Society},
               booksubtitle = {ANS Winter Meeting},
               doi = {doi.org/10.13182/T127-39636��}
               }
Mauricio E. Tano, Jun Fang, Guillaume Giudicelli and Abdalla Abou-Jaoude, "Coupled Griffin-Pronghorn-SAM Model of a Molten Salt Fast Reactor System Transient in the Virtual Test Bed", Transactions of the American Nuclear Society, Nov. 2022
```

- Molten Salt Fast Reactor (MSFR Nek5000 model)

```
@inproceedings{fang2021,
               title = {CFD Modeling of Molten Salt Fast Reactor Using Nek5000},
               author = {Jun Fang, Dillon R Shaver and Bo Feng},
               year = {2021},
               booktitle = {Transactions of the American Nuclear Society},
               booksubtitle = {Winter Meeting}
              }
Jun Fang, Dillon R Shaver and Bo Feng, "CFD Modeling of Molten Salt Fast Reactor Using Nek5000", Transactions of the American Nuclear Society (2021)
```

- Molten Salt Reactor Experiment (MSRE Multiphysics Model)

```
@inproceedings{jaradat2024,
          title = {{Verification and Validation Activities of Molten Salt Reactors Multiphysics Coupling Schemes at Idaho National Laboratory}},
          author = {Jaradat, Mustafa and Choi, Namjae and Tano Retamales, Mauricio Eduardo and Schunert, Sebastian and Abou Jaoude, Abdalla and Ortensi, Javier},
               booktitle = { International Conference on Physics of Reactors (PHYSOR 2024) },
          place = {United States},
          year = {2024},
          month = {4},
          url = {https://www.osti.gov/biblio/2341471}
}
Mustafa K.M. Jaradat, Namjae Choi, Mauricio E. Tano Retamales, Sebastian Schunert, Abdalla Abou Jaoude and Javier Ortensi, "Verification and Validation Activities of Molten Salt Reactors Multiphysics Coupling Schemes at Idaho National Laboratory", International Conference on Physics of Reactors (PHYSOR 2024), San Francisco, United States,
(2024)
```

```
@techreport{jaradat2023,
            title = {{Thermal Spectrum Molten Salt-Fueled Reactor Reference Plant Model}},
            author = {Mustafa Jaradat and Javier Ortensi},
            institution = {Idaho National Laboratory},
            number = {INL/RPT-23-72875},
            year = 2023
           }
Mustafa K.M. Jaradat and Javier Ortensi, "Thermal Spectrum Molten Salt-Fueled Reactor Reference Plant Model", Idaho National Laboratory, INL/RPT-23-72875 (2023)
```

- Molten Salt Reactor Experiment (MSRE SAM model)

```
@techreport{Hu2021,
            title = {FY21 SAM Developments for MSR Modeling.},
            author = {Hu R. and Hu G. and Gorman M. and Fang J. and Mui T. and O’Grady D. and Fei T. and Salko R.},
            institution = {Argonne National Laboratory},
            number = {ANL/NSE-21/74},
            year = 2021
           }
Hu R., Hu G., Gorman M., Fang J., Mui T., O’Grady D., Fei T. and Salko R., "FY21 SAM Developments for MSR Modeling.", Argonne National Laboratory, ANL/NSE-21/74 (2021)
```

- Generic MSR depletion

```
@InProceedings{Walker_ANS_2022,
               title={Implementation of Isotopic Removal Capability in Griffin for Multi-Region MSR Depletion Analysis}
               author={Samuel Walker and Olin Calvin and Mauricio E. Tano and Abdalla Abou Jaoude},
               year = {2022},
               booktitle = {Transactions of the American Nuclear Society},
               booksubtitle = {ANS Winter Meeting},
               doi = {doi.org/10.13182/T127-39645��}
}
Samuel Walker, Olin Calvin, Mauricio E. Tano and Abdalla Abou Jaoude, Implementation of Isotopic Removal Capability in Griffin for Multi-Region MSR Depletion Analysis,
Transition of the American Nuclear Society, 2022
```

- CNRS Multiphysics Benchmark Modeling using NEAMS tools

```
@article{jaradat2024verification,
  title={Verification of Griffin-Pronghorn-Coupled Multiphysics Code System Against CNRS Molten Salt Reactor Benchmark},
  author={Jaradat, Mustafa K and Choi, Namjae and Abou-Jaoude, Abdalla},
  journal={Nuclear Science and Engineering},
  pages={1--34},
  year={2024},
  publisher={Taylor \& Francis}
}
```

### Pebble bed fluoride-salt cooled high temperature reactor style=font-size:125%

- Core multiphysics analysis (PB-FHR Pronghorn-Griffin core model)

```
@article{giudicelli2021,
         title = {Coupled Multiphysics Multiscale Transient Simulations of The Mk1-Fhr Reactor Using Finite Volume Capabilities of The Moose Framework},
         author = {Guillaume Giudicelli and Alexander Lindsay and Paolo Balestra and Robert Carlsen and Javier Ortensi and Derek Gaston and Mark DeHart and Abdalla Abou-Jaoude and April J Novak},
         year = {2021},
         journal = {Proceedings of the International Conference of Mathematics and Computation for Nuclear Science and Engineering}
        }
Guillaume Giudicelli, Alexander Lindsay, Paolo Balestra, Robert Carlsen, Javier Ortensi, Derek Gaston, Mark DeHart, Abdalla Abou-Jaoude and April J Novak, "Coupled Multiphysics Multiscale Transient Simulations of The Mk1-Fhr Reactor Using Finite Volume Capabilities of The Moose Framework", Proceedings of the International Conference of Mathematics and Computation for Nuclear Science and Engineering, 2021
```

- Plant multiphysics analysis (Pronghorn-Griffin-SAM model)

```
@InProceedings{Giudicelli_ANS_2022,
               title={Coupled Multiphysics Primary Loop Simulations of the Mk1-FHR in the Virtual Test Bed},
               author={Guillaume Giudicelli and Cole Mueller and Daniel Nunez and Thanh Hua and Jun Fang and Abdalla Abou-Jaoude},
               year = {2022},
               booktitle = {Transactions of the American Nuclear Society},
               booksubtitle = {ANS Winter Meeting},
               doi = {doi.org/10.13182/T127-39765}
}
Guillaume Giudicelli, Cole Mueller, Daniel Nunez, Thanh Hua, Jun Fang and Abdalla Abou-Jaoude, "Coupled Multiphysics Primary Loop Simulations of the Mk1-FHR in the Virtual Test Bed", Transactions of the American Nuclear Society, 2022
```

- Pebble bed fluoride-salt cooled high temperature reactor reflector model

```
@inproceedings{novak2021,
               title = {Conjugate Heat Transfer Coupling of NekRS and MOOSE for Bypass Flow Modeling},
               author = {April J. Novak and Dillon Shaver and Bo Feng},
               year = {2021},
               booktitle = {Transactions of the American Nuclear Society},
               booksubtitle = {ANS Winter Meeting}
              }
April J. Novak, Dillon Shaver and Bo Feng, "Conjugate Heat Transfer Coupling of NekRS and MOOSE for Bypass Flow Modeling", Transactions of the American Nuclear Society (2021)
```

- Integrated Plant Analysis

```
@inproceedings{Ahmed2017,
               address = {Xi'an, China},
               author = {Ahmed K K and Scarlat R O and Hu R},
               booktitle = {17th International Topical Meeting on Nuclear Reactor Thermal Hydraulics
        	        (NURETH-17)},
               language = {English},
               publisher = {American Nuclear Society},
               title = {{Benchmark Simulation of Natural Circulation Cooling System
        	        with Salt Working Fluid Using SAM}},
               url = {https://www.osti.gov/biblio/1392061},
               year = {2017}
              }
Ahmed K. K., Scarlat R. O. and Hu R., "Benchmark Simulation of Natural Circulation Cooling System with Salt Working Fluid Using SAM", Transactions of the  American Nuclear Society (2017)
```

- Generic FHR (gFHR) multiphysics core model

```
@techreport{gFHR_report,
    author = "Ortensi, Javier and Mueller, Cole M. and Terlizzi, Stefano and Giudicelli, Guillaume and Schunert, Sebastian",
    title = "Fluoride-Cooled High-Temperature Pebble-Bed Reactor Reference Plant Model",
    institution = "Idaho National Laboratory",
    number = "INL/RPT-23-72727",
    year = "2023"
}
```

### Sodium Fast Reactor style=font-size:125%

- Versatile Test Reactor (VTR) assembly and core model

```
@article{MARTIN2022109066,
         title = {A multiphysics model of the versatile test reactor based on the MOOSE framework},
         journal = {Annals of Nuclear Energy},
         volume = {172},
         pages = {109066},
         year = {2022},
         issn = {0306-4549},
         doi = {https://doi.org/10.1016/j.anucene.2022.109066},
         url = {https://www.sciencedirect.com/science/article/pii/S0306454922001013},
         author = {Nicolas Martin and Ryan Stewart and Sam Bays}
        }
Nicolas Martin, Ryan Stewart and Sam Bays, "A multiphysics model of the versatile test reactor based on the MOOSE framework", Annals of Nuclear Energy, 172, 109066 (2022)
```

- Advanced Burner Test Reactor (ABTR) SAM model

```
@techreport{Hu2019,
            author = {Hu, G., Zhang, G., & Hu, R.},
            year = 2019,
            title = {{Reactivity Feedback Modeling in SAM.}},
            url = {https://doi.org/10.2172/1499041}
           }
Hu, G., Zhang, G., & Hu, R., "Reactivity Feedback Modeling in SAM", Argonne National Laboratory, ANL/NSE-19/1150747 (2019)
```

- Advanced Burner Test Reactor (ABTR) cross section generation and full-core model

```
@techreport{lee2023improved,
            author = {Lee, C., Jung, Y.S., Kumar, S., Choi, N., Hanophy, J., & Wang, Y.},
            year = 2023,
            title = {{Improved Fast Reactor Capability of Griffin in FY23.}}
           }
Lee, C., Jung, Y.S., Kumar, S., Choi, N., Hanophy, J., & Wang, Y., "Improved Fast Reactor Capability of Griffin in FY23", Idaho National Laboratory; Argonne National Laboratory, INL/RPT-23-74897; ANL/NSE-23/73 (2023)
```

- Sodium Fast Reactor (SFR) duct bowing IAEA benchmarks VP1 and VP3A

```
@techreport{moose_tm_assess_2021,
    author = "Wozniak, Nicholas and Shemon, Emily and Grudzinski, James and Spencer, Benjamin",
    title = "Assessment of {MOOSE}-{Based} {Tools} for {Calculating} {Radial} {Core} {Expansion}",
    url = "https://www.osti.gov/servlets/purl/1808314/",
    language = "en",
    number = "ANL/NSE-21/30, 1808314, 169472",
    urldate = "2022-03-16",
    month = "July",
    year = "2021",
    doi = "10.2172/1808314",
    pages = "ANL/NSE--21/30, 1808314, 169472",
    institution = "Argonne National Laboratory"
}
Wozniak, Nicholas and Shemon, Emily and Grudzinski, James and Spencer, Benjamin, "Assessment of MOOSE-based tools for Calculating Radial Core Expansion",
Technical Report ANL/NSE--21/30, 1808314, 169472, 2021
```

- Subchannel ORNL-19 and Toshiba-37 demonstrations

```
@techreport{
    title = {{Development of a Subchannel Capability for Liquid-Metal Fast Reactors in Pronghorn}},
    author = {Mauricio Tano and Sebastian Schunert and Vasileios Kyriakopoulos and Aydin Karahan and April Novak},
    number = {pending},
    institution = {Idaho National Laboratory},
    year = {2022}
    }
Mauricio Tano and Sebastian Schunert and Vasileios Kyriakopoulos and Aydin Karahan and April Novak, "Development of a Subchannel Capability for Liquid-Metal Fast Reactors in Pronghorn", Technical Report, 2022
```

- Subchannel THORS

!alert note title=No official citation
Please contact the [model POC](sfr/subchannel/thors/thors.md) to obtain the item to cite.

- Subchannel EBR-II validation

```
@article{tano2024validation,
    author = "Tano, Mauricio and Kyriakopoulos, Vasileios and McCay, James and Arment, Tyrell",
    title = "Validation of Pronghorn’s subchannel code using EBR-II shutdown heat removal tests: SHRT-17 and SHRT-45R",
    journal = "Nuclear Engineering and Design",
    volume = "416",
    pages = "112783",
    year = "2024",
    publisher = "Elsevier"
}
```


### High Temperature Gas Cooled Reactor style=font-size:125%

- Modular High Temperature Gas Reactor (MHTGR) SAM model

```
@techreport{Vegendla2019,
            author = {Vegendla Prasad and Hu Rui and Zou Ling},
            number = {ANL-19/35},
            mendeley-tags = {ANL-19/35},
            institution = {Argonne National Laboratory},
            title = {{Multi-Scale Modeling of Thermal-Fluid Phenomena Related to Loss of
              Forced Circulation Transient in HTGRs}},
            year = {2019}
           }
Vegendla Prasad, Hu Rui and Zou Ling, "Multi-Scale Modeling of Thermal-Fluid Phenomena Related to Loss of Forced Circulation Transient in HTGRs", Argonne National Laboratory, ANL-19/35 (2019)
```

- Modular High Temperature Gas Reactor (MHTGR) Griffin model

```
@techreport{mhtgr_inl,
  author = {Ortensi J. and Strydom G.},
  institution = {Idaho National Lab},
  number = {INL/LTD-17-43099-Revision-0},
  title = {OECD/NEA Coupled Neutronic/Thermal-Fluids Benchmark of the MHTGR-350 MW Core Design: Results for Phase-I Excercise I},
  year = {2020},
}
Ortensi J. and Strydom G, "OECD/NEA Coupled Neutronic/Thermal-Fluids Benchmark of the MHTGR-350 MW Core Design: Results for Phase-I Excercise I",
Technical Report INL/LTD-17-43099-Revision-0, 2020
```

- High Temperature Engineering Test Reactor (HTTR) Multiphysics Model

```
@article{LABOURE2023109838,
         title = {Improved multiphysics model of the High Temperature Engineering Test Reactor for the simulation of loss-of-forced-cooling experiments},
         journal = {Annals of Nuclear Energy},
         volume = {189},
         pages = {109838},
         year = {2023},
         issn = {0306-4549},
         doi = {https://doi.org/10.1016/j.anucene.2023.109838},
         url = {https://www.sciencedirect.com/science/article/pii/S0306454923001573},
         author = {Vincent Labouré and Javier Ortensi and Nicolas Martin and Paolo Balestra and Derek Gaston and Yinbin Miao and Gerhard Strydom},
}
Vincent Labouré, Javier Ortensi, Nicolas Martin, Paolo Balestra, Derek Gaston, Yinbin Miao, Gerhard Strydom, "Improved multiphysics model of the High Temperature Engineering Test Reactor for the simulation of loss-of-forced-cooling experiments", Annals of Nuclear Energy, Volume 189, 2023, 109838, ISSN 0306-4549, https://doi.org/10.1016/j.anucene.2023.109838.
```

- PBMR-400 numerical benchmark

```
@article{balestra2021,
         title = {PBMR-400 benchmark solution of exercise 1 and 2 using the moose based applications: MAMMOTH, Pronghorn},
         author = {Paolo Balestra and Sebastian Schunert and Robert W Carlsen and April J Novak and Mark D DeHart and Richard C Martineau},
         year = {2021},
         journal = {EPJ Web of Conferences},
         pages = {247}
       }
Paolo Balestra, Sebastian Schunert, Robert W Carlsen, April J Novak, Mark D DeHart and Richard C Martineau, "PBMR-400 benchmark solution of exercise 1 and 2 using the moose based applications: MAMMOTH, Pronghorn", 247 (2021)
```

- Assembly Cardinal model

```
@InProceedings{novak_2021b,
               title       = {{Coupled Monte Carlo Transport and Thermal-Hydraulics Modeling of a Prismatic Gas Reactor Fuel Assembly Using Cardinal}},
               author     = {A.J. Novak and D. Andrs and P. Shriwise and D. Shaver and P.K. Romano and E. Merzari and P. Keutelian},
               booktitle  = {{Proceedings of Physor}},
               year       = 2022
              }
A.J. Novak, D. Andrs, P. Shriwise, D. Shaver, P.K. Romano, E. Merzari and P. Keutelian, "Coupled Monte Carlo Transport and Thermal-Hydraulics Modeling of a Prismatic Gas Reactor Fuel Assembly Using Cardinal", Proceedings of Physics of Nuclear Reactors, (2022)
```

- HTR-10 Griffin Benchmarks

```
@techreport{HTR-10Benchmark,
    author = {J.~Ortensi and S.~Schunert and Y.~Wang and V.~Laboure and F.~Gleicher and R.~Martineau},
    Title = {{Benchmark Analysis of the HTR-10 with the MAMMOTH Reactor Physics Application.}},
    Institution = {Idaho National Laboratory},
    Number = {INL/EXT-18-45453},
    Year = {2018},
}
J. Ortensi and S. Schunert and Y. Wang and V. Laboure and F. Gleicher and R. Martineau, "Benchmark Analysis of the HTR-10 with the MAMMOTH Reactor Physics Application", Idaho National Laboratory, Technical Report INL/EXT-18-45453, (2018)
```

- TRISO fuel depletion model

```
@article{bison_triso_model,
    author = "Jiang, Wen and Hales, Jason D. and Spencer, Benjamin W. and Collin, Blaise P. and Slaughter, Andrew E. and Novascone, Stephen R. and Toptan, Aysenur and Gamble, Kyle A. and Gardner, Russell",
    title = "TRISO particle fuel performance and failure analysis with BISON",
    journal = "Journal of Nuclear Materials",
    volume = "548",
    pages = "152795",
    year = "2021"
}
Jiang, Wen and Hales, Jason D. and Spencer, Benjamin W. and Collin, Blaise P. and Slaughter, Andrew E. and Novascone, Stephen R. and Toptan, Aysenur and Gamble, Kyle A. and Gardner, Russell, "TRISO particle fuel performance and failure analysis with BISON", Journal of Nuclear Materials, 548-152795, 2021
```

- Dispersed UO2 LEU pulse model

```
@article{doi:10.1080/00295639.2018.1528802,
    author = "Zabriskie, Adam and Schunert, Sebastian and Schwen, Daniel and Ortensi, Javier and Baker, Benjamin and Wang, Yaqi and Laboure, Vincent and DeHart, Mark and Marcum, Wade",
    title = "A Coupled Multiscale Approach to TREAT LEU Feedback Modeling Using a Binary-Collision Monte-Carlo–Informed Heat Source",
    journal = "Nuclear Science and Engineering",
    volume = "193",
    number = "4",
    pages = "368-387",
    year = "2019",
    publisher = "Taylor \& Francis",
    doi = "10.1080/00295639.2018.1528802",
    URL = "https://doi.org/10.1080/00295639.2018.1528802",
    eprint = "https://doi.org/10.1080/00295639.2018.1528802"
}
Zabriskie, Adam and Schunert, Sebastian and Schwen, Daniel and Ortensi, Javier and Baker, Benjamin and Wang, Yaqi and Laboure, Vincent and DeHart, Mark and Marcum, Wade, "Coupled Multiscale Approach to TREAT LEU Feedback Modeling Using a Binary-Collision Monte-Carlo–Informed Heat Source", Journal of Nuclear Science and Engineering, vol 193-4, pp. 368-387, 2019
```

- SAM Generic Pebble Bed HTGR model

```
@techreport{osti_1884970,
    title = {Modeling of a Generic Pebble Bed High-temperature Gas-cooled Reactor (PB-HTGR) with SAM},
    author = {Ooi, Zhiee Jhia and Zou, Ling and Hua, Thanh and Fang, Jun and Hu, Rui},
    doi = {10.2172/1884970},
    url = {https://www.osti.gov/biblio/1884970}, journal = {},
    place = {United States},
    year = {2022},
    number = {ANL/NSE-22/59177957},
    month = {9}
}
Ooi, Zhiee Jhia and Zou, Ling and Hua, Thanh and Fang, Jun and Hu, Rui, "Modeling of a Generic Pebble Bed High-temperature Gas-cooled Reactor (PB-HTGR) with SAM",
Technical Report ANL/NSE-22/59177957, 2022
```

- 2D Ring Model for the High Temperature Test Facility (HTTF)

```
@article{Ooi04052023,
    author = {Zhiee Jhia Ooi and Thanh Hua and Ling Zou and Rui Hu},
    title = {Simulation of the High Temperature Test Facility (HTTF) Core Using the 2D Ring Model with SAM},
    journal = {Nuclear Science and Engineering},
    volume = {197},
    number = {5},
    pages = {840--867},
    year = {2023},
    publisher = {Taylor \& Francis},
    doi = {10.1080/00295639.2022.2106726},
    URL = {https://doi.org/10.1080/00295639.2022.2106726}
}
```

- HTTF transient core model - Porous media

```
Modeling the Oregon State University's High Temperature Test Facility via a Porous Media Approach
Ismail Bouarich (INL), Lise Charlot (INL), Mauricio E. Tano Retamales (INL)
Transactions | Volume 132 | Number 1 | June 2025 | Pages 1230-1233
```

- 67 pebbles conjugate heat transfer model

```
Large Eddy Simulation of a 67-Pebble Bed Experiment
David Reger (Penn State), Elia Merzari (Penn State), Haomin Yuan (ANL), Yassin Hassan (TAMU), Stephen King (TAMU), Khoi Ngo (TAMU), Sebastian Schunert (INL), Paolo Balestra (INL)
Proceedings | Advances in Thermal Hydraulics (ATH 2022) | Anaheim, CA, June 12-16, 2022 | Pages 278-291
```

- HTTF Lower Plenum Nek5000 CFD

```
@inproceedings{Fang2023nureth2,
    address = {Washington D.C.},
    author = {Fang, Jun and Hua, Thanh and Ooi, Zhiee Jhia and Zou, Ling},
    booktitle = {Proceedings of 20th International Topical Meeting on Nuclear Reactor Thermal Hydraulics (NURETH-20)},
    publisher = {American Nuclear Society},
    title = {{CFD Simulations of Flow Mixing Phenomenon in a Gas-Cooled Reactor Outlet Plenum}},
    year = {2023}
}
Fang, Jun and Hua, Thanh and Ooi, Zhiee Jhia and Zou, Ling, "CFD Simulations of Flow Mixing Phenomenon in a Gas-Cooled Reactor Outlet Plenum",
NURETH-2023
```

- HTTR Steady state model

```
INL/RPT-22-68891
FY22 Status Report on the ART-GCR CMVB and CNWG International Collaborations
September 2022
M3AT-22IN0603011
Vincent Laboure, Matilda Aberg Lindell, Javier Ortensi, Gerhard Strydom, and Paolo Balestra
```

- General Pebble Bed Reactor with Stochastic Analyses

```
@article{Prince2024,
    title = {Sensitivity analysis, surrogate modeling, and optimization of pebble-bed reactors considering normal and accident conditions},
    journal = {Nuclear Engineering and Design},
    volume = {428},
    pages = {113466},
    year = {2024},
    issn = {0029-5493},
    doi = {https://doi.org/10.1016/j.nucengdes.2024.113466},
    url = {https://www.sciencedirect.com/science/article/pii/S0029549324005661},
    author = {Zachary M. Prince and Paolo Balestra and Javier Ortensi and Sebastian Schunert and Olin Calvin and Joshua T. Hanophy and Kun Mo and Gerhard Strydom},
    keywords = {Pebble bed reactor, Equilibrium core, Depressurized loss of forced cooling, MOOSE, Sensitivity analysis, Surrogate modeling, Optimization}
}
```

- Griffin Open Xe-100 model

```
@article{Stewart2022,
  title = {Generation of localized reactor point kinetics parameters using coupled neutronic and thermal fluid models for pebble-bed reactor transient analysis},
  journal = {Annals of Nuclear Energy},
  volume = {174},
  pages = {109143},
  year = {2022},
  issn = {0306-4549},
  doi = {https://doi.org/10.1016/j.anucene.2022.109143},
  url = {https://www.sciencedirect.com/science/article/pii/S0306454922001785#s0065},
  author = {R. Stewart and P. Balestra and D. Reger and E. Merzari},
  keywords = {Pebble-bed reactor, Multiphysics transient, Local reactivity coefficients, Point kinetics parameters},
}
```


### Lead-cooled Fast Reactors style=font-size:125%

- LFR Griffin Benchmark

```
@techreport{HCFReport,
    author = "Shemon, Emily and Yu, Yiqi and Park, Hansol and Brennan, Colin",
    address = "Lemont, IL",
    number = "ANL/NSE-21/42",
    institution = "Argonne National Laboratory",
    title = "{Assessment of Fast Reactor Hot Channel Factor Calculation Capability in Griffin and NekRS}",
    year = "2021"
}
Shemon, Emily and Yu, Yiqi and Park, Hansol and Brennan, Colin, "Assessment of Fast Reactor Hot Channel Factor Calculation Capability in Griffin and NekRS",
Technical Report ANL/NSE-21/42, 2021
```

- 7-pin Cardinal model

```
@article{Novak03102023,
    author = {A. J. Novak and P. Shriwise and P. K. Romano and R. Rahaman and E. Merzari and D. Gaston},
    title = {Coupled Monte Carlo Transport and Conjugate Heat Transfer for Wire-Wrapped Bundles Within the MOOSE Framework},
    journal = {Nuclear Science and Engineering},
    volume = {197},
    number = {10},
    pages = {2561--2584},
    year = {2023},
    publisher = {Taylor \& Francis},
    doi = {10.1080/00295639.2022.2158715},
    URL = {https://doi.org/10.1080/00295639.2022.2158715}
}
```

### Micro Reactor style=font-size:125%

- Heat Pipe Micro Reactor (MRAD)

```
@article{Stauff2021,
        title = {Preliminary Applications of NEAMS Codes for Multiphysics Modeling of a Heat Pipe Microreactor},
        author = {Nicolas E. Stauff and Kun Mo and Yan Cao and Justin W. Thomas and Yinbin Miao and Changho Lee and Christopher Matthews and Bo Feng},
        year = {2021},
        journal = {Proceedings of the American Nuclear Society Annual 2021 Meeting}
       }
Nicolas E. Stauff, Kun Mo, Yan Cao, Justin W. Thomas, Yinbin Miao, Changho Lee, Christopher Matthews and Bo Feng, "Preliminary Applications of NEAMS Codes for Multiphysics Modeling of a Heat Pipe Microreactor", Transactions of the American Nuclear Society, (2021)
```

-



- SNAP 8 NTP Reactor core model

```
@inproceedings{s8er_naupa2022,
    author = "Naupa, Isaac and Garcia, Samuel and Terlizzi, Stefano and Kotlyar, Dan and Lindley., Ben",
    title = "Validation of SNAP8 Criticality Configuration Experiments using NEAMS Tools.",
    booktitle = "Proceedings of Mathematics and Computation for Nuclear Science and Engineering",
    place = "United States",
    year = "2022",
    month = "1"
}
Naupa, Isaac and Garcia, Samuel and Terlizzi, Stefano and Kotlyar, Dan and Lindley., Ben,
"Validation of SNAP8 Criticality Configuration Experiments using NEAMS Tools.", Proceedings of Mathematics and Computation for Nuclear Science and Engineering,
2022
```

- Gas Cooled Micro Reactor

```
@InProceedings{Ahmed_ANS_2022,
    author = "Abdelhameed, Ahmed Amin and Cao, Yan and Nunez, Daniel and Miao, Yinbin and Mo, Kun and Lee, Changho and Shemon, Emily and Stauff, Nicolas E.",
    title = "High-Fidelity Multiphysics Modeling of Load Following for 3-D Gas-Cooled Microreactor Assembly using NEAMS Codes",
    booktitle = "{Proceedings of the American Nuclear Society}",
    year = "2022"
}
Abdelhameed, Ahmed Amin and Cao, Yan and Nunez, Daniel and Miao, Yinbin and Mo, Kun and Lee, Changho and Shemon, Emily and Stauff, Nicolas E., "High-Fidelity Multiphysics Modeling of Load Following for 3-D Gas-Cooled Microreactor Assembly using NEAMS Codes", Proceedings of the American Nuclear Society, November 2022
```

- Control drum rotation

```
@article{Prince2023Neutron,
  title = {Neutron Transport Methods for Multiphysics Heterogeneous Reactor Core Simulation in Griffin},
  author = {Zachary Prince and Joshua Hanophy and Vincent Labour\'e and Yaqi Wang and Logan Harbour and Namjae Choi},
  year = {2023},
  journal = {Submitted to Annals of Nuclear Energy}
}
Zachary Prince, Joshua Hanophy, Vincent Labouré, Yaqi Wang, Logan Harbour, and Namjae Choi, "Neutron transport methods for multiphysics heterogeneous reactor core simulation in Griffin", submitted to Annals of Nuclear Energy, 2023.
```

- Heat Pipe Micro Reactor with Hydrogen Redistribution (HPMR_H2)

```
@article{terlizzi_empire,
  title = {Asymptotic hydrogen redistribution analysis in yttrium-hydride-moderated heat-pipe-cooled microreactors using DireWolf},
  journal = {Annals of Nuclear Energy},
  volume = {186},
  pages = {109735},
  year = {2023},
  issn = {0306-4549},
  doi = {https://doi.org/10.1016/j.anucene.2023.109735},
  url = {https://www.sciencedirect.com/science/article/pii/S0306454923000543},
  author = {Stefano Terlizzi and Vincent Labour\'e}
}
Stefano Terlizzi and Vincent Labouré, "Asymptotic hydrogen redistribution analysis in yttrium-hydride-moderated heat-pipe-cooled microreactors using DireWolf", Annals of Nuclear Energy, Volume 186, 2023, 109735,	ISSN 0306-4549,	https://doi.org/10.1016/j.anucene.2023.109735
```

- Natural Convection CFD Modeling of a Microreactor Air Jacket

```
@inproceedings{jacket_chaube,
    author = {Anshuman Chaube and April J. Novak and Dillon R. Shaver and Caleb S. Brooks},
    title = {{Natural Convection CFD Modeling of a Microreactor Air Jacket}},
    booktitle = {Transactions of the American Nuclear Society},
    publisher = {American Nuclear Society},
    address = {Washington D.C.},
    year = {2023}
}
Anshuman Chaube and April J. Novak and Dillon R. Shaver and Caleb S. Brooks, "Natural Convection CFD Modeling of a Microreactor Air Jacket",
Transactions of the American Nuclear Society, 2023
```

### Light Water Reactors

!alert note title=No official citation
Please contact the [model POC](rpv_fracture/index.md) to obtain the item to cite.


### Research Reactors

- ATR Butterfly Valve simulation

```
@article{YANKURA2025111671,
title = {Butterfly valve performance factors using the multiphysics object oriented simulation environment},
journal = {Annals of Nuclear Energy},
volume = {224},
pages = {111671},
year = {2025},
issn = {0306-4549},
doi = {https://doi.org/10.1016/j.anucene.2025.111671},
url = {https://www.sciencedirect.com/science/article/pii/S0306454925004888},
author = {Daniel Yankura and Matthew Anderson},
keywords = {Computational fluid dynamics, MOOSE framework}
}
```

- AGN 3D mesh

!alert note title=No official citation
Please contact the [model POC](research_reactors/agn/index.md) to obtain the item to cite.


### Magnetic confinement fusion

- Divertor monoblock tritium

```
@article{Shimada2024114438,
   author = {Masashi Shimada and Pierre-Clément A. Simon and Casey T. Icenhour and Gyanender Singh},
   doi = {10.1016/J.FUSENGDES.2024.114438},
   issn = {0920-3796},
   journal = {Fusion Engineering and Design},
   month = {6},
   pages = {114438},
   publisher = {North-Holland},
   title = {Toward a high-fidelity tritium transport modeling for retention and permeation experiments},
   volume = {203},
   url = {https://linkinghub.elsevier.com/retrieve/pii/S0920379624002916},
   year = {2024}
}
```

## Software / codes

The references for various features of MOOSE may be found on this
[page](https://mooseframework.inl.gov/citing.html).
If you make use of the following NEAMS software, please reference the following:

MOOSE and MOOSE modules: Please refer to the [MOOSE citing page](https://mooseframework.inl.gov/citing.html).


Bison

```
@article{doi:10.1080/00295450.2020.1836940,
         author = {Richard L. Williamson and Jason D. Hales and Stephen R. Novascone and Giovanni Pastore and Kyle A. Gamble and Benjamin W. Spencer and Wen Jiang and Stephanie A. Pitts and Albert Casagranda and Daniel Schwen and Adam X. Zabriskie and Aysenur Toptan and Russell Gardner and Christoper Matthews and Wenfeng Liu and Hailong Chen},
         title = {BISON: A Flexible Code for Advanced Simulation of the Performance of Multiple Nuclear Fuel Forms},
         journal = {Nuclear Technology},
         volume = {207},
         number = {7},
         pages = {1-27},
         year  = {2021},
         publisher = {Taylor & Francis},
         doi = {10.1080/00295450.2020.1836940},
         URL = {https://doi.org/10.1080/00295450.2020.1836940},
        }
Richard L. Williamson, Jason D. Hales, Stephen R. Novascone, Giovanni Pastore, Kyle A. Gamble, Benjamin W. Spencer, Wen Jiang, Stephanie A. Pitts, Albert Casagranda, Daniel Schwen, Adam X. Zabriskie, Aysenur Toptan, Russell Gardner, Christoper Matthews, Wenfeng Liu and Hailong Chen, "BISON: A Flexible Code for Advanced Simulation of the Performance of Multiple Nuclear Fuel Forms", Nuclear Technology (2021)
```

Griffin

```
@techreport{Griffin2020,
            title = "Griffin User Manual",
            institution = "Idaho National Laboratory",
            author = {Mark DeHart and Fredrick N. Gleicher and Vincent Laboure and Javier Ortensi and Zachary Prince and Sebastian Schunert and Yaqi Wang},
            number = {INL/EXT-19-54247},
            year = 2020
           }
Mark DeHart, Fredrick N. Gleicher, Vincent Laboure, Javier Ortensi, Zachary Prince, Sebastian Schunert and Yaqi Wang, "Griffin User Manual", Idaho National Laboratory, INL/EXT-19-54247, 2020
```

Nek5000

```
@Misc{nek5000-web-page,
      Author = "Paul F. Fischer and James W. Lottes and Stefan G. Kerkemeier",
      Title  = "{nek5000 Open source spectral element {CFD} solver}",
      Note   = "http://nek5000.mcs.anl.gov",
      Year   = "2008"
     }
Paul F. Fischer, James W. Lottes and Stefan G. Kerkemeier, "Nek5000 Open source spectral element CFD solver", http://nek5000.mcs.anl.gov (2008)
```

NekRS

```
@misc{fischer2021nekrs,
      title={NekRS, a GPU-Accelerated Spectral Element Navier-Stokes Solver},
      author={Paul Fischer and Stefan Kerkemeier and Misun Min and Yu-Hsiang Lan and Malachi Phillips and Thilina Rathnayake and Elia Merzari and Ananias Tomboulides and Ali Karakus and Noel Chalmers and Tim Warburton},
      year={2021},
      eprint={2104.05829},
      archivePrefix={arXiv},
      primaryClass={cs.PF}
     }
Paul Fischer, Stefan Kerkemeier, Misun Min, Yu-Hsiang Lan, Malachi Phillips, Thilina Rathnayake, Elia Merzari, Ananias Tomboulides, Ali Karakus, Noel Chalmers and Tim Warburton, "NekRS, a GPU-Accelerated Spectral Element Navier-Stokes Solver" (2021)
```

Cardinal

```
@article{cardinal2021NT,
         title = {{Cardinal}: A Lower Length-Scale Multiphysics Simulator for Pebble-Bed Reactors},
         author = {E. Merzari and H. Yuan and M. Min and D. Shaver and R. Rahaman and P. Shriwise and P. Romano and A. Talamo and Y. Lan and D. Gaston and R. Martineau and P. Fischer and Y. Hassan},
         year = {2021},
         journal = {{Nuclear Technology}},
         DOI = {https://doi.org/10.1080/00295450.2020.1824471},
         url = {https://www.tandfonline.com/doi/full/10.1080/00295450.2020.1824471}
}
E. Merzari, H. Yuan, M. Min, D. Shaver, R. Rahaman, P. Shriwise, P. Romano, A. Talamo, Y. Lan, D. Gaston, R. Martineau, P. Fischer and Y. Hassan, "Cardinal : A Lower Length-Scale Multiphysics Simulator for Pebble-Bed Reactors", Nuclear Technology (2021)
```

Grizzly / Blackbear

```
@article{spencer_grizzly_2021,
	author = {Benjamin W. Spencer and William M. Hoffman and Sudipta Biswas and Wen Jiang and Alain Giorla and Marie A. Backman},
	doi = {10.1080/00295450.2020.1868278},
	journal = {Nuclear Technology},
	month = apr,
	number = {7},
	pages = {981--1003},
	publisher = {Informa {UK} Limited},
	title = {Grizzly and {BlackBear}: Structural Component Aging Simulation Codes},
	volume = {207},
	year = {2021}
}
```

Pronghorn

```
@article{pronghorn2020NT,
         title = {{Pronghorn}: A Multidimensional Coarse-Mesh Application for Advanced Reactor Thermal Hydraulics},
         author = {A.J. Novak and R.W. Carlsen and S. Schunert and P. Balestra and D. Reger and R.N. Slaybaugh and R.C. Martineau},
         year = {2021},
         journal = {{Nuclear Technology}},
         doi = {https://doi.org/10.1080/00295450.2020.1825307},
         url = {https://www.tandfonline.com/doi/full/10.1080/00295450.2020.1825307},
         keywords = {Pronghorn, pebble bed reactor, MOOSE}
        }
A.J. Novak, R.W. Carlsen, S. Schunert, P. Balestra, D. Reger, R.N. Slaybaugh and R.C. Martineau, "Pronghorn: A Multidimensional Coarse-Mesh Application for Advanced Reactor Thermal Hydraulics", Nuclear Technology (2021)
```

SAM

```
@techreport{SAM2017,
            title = "SAM Theory Manual",
            institution = {Argonne National Laboratory},
            author = {R. Hu},
            number = {ANL/NE-17/4},
            year = 2017
           }
R. Hu, "SAM Theory Manual", Argonne National Laboratory, ANL/NE-17/4 (2017)
```

RELAP-7

```
@techreport{RELAP7,
            title = "RELAP-7 Theory Manual",
            institution = {Idaho National Laboratory},
            author = {R.A. Berry and L. Zou and H. Zhao and H. Zhang and J.W. Peterson and R.C. Martineau and S.Y. Kadioglu and D. Andrs},
            number = {INL/EXT-14-31366},
            year = 2014
           }
R.A. Berry and L. Zou and H. Zhao and H. Zhang and J.W. Peterson and R.C. Martineau and S.Y. Kadioglu and D. Andrs, "RELAP-7 Theory Manual", Technical Report
INL/EXT-14-31366, 2014
```

Sockeye

```
@article{hansel2021sockeye,
         author = {Joshua E. Hansel and Ray A. Berry and David Andrs and Matthias S. Kunick and Richard C. Martineau},
         title = {Sockeye: A One-Dimensional, Two-Phase, Compressible Flow Heat Pipe Application},
         journal = {Nuclear Technology},
         volume = {207},
         number = {7},
         pages = {1096-1117},
         year  = {2021},
         publisher = {Taylor & Francis},
         doi = {10.1080/00295450.2020.1861879},
         URL = {https://doi.org/10.1080/00295450.2020.1861879},
         eprint = {https://doi.org/10.1080/00295450.2020.1861879}
}
Joshua E. Hansel, Ray A. Berry, David Andrs, Matthias S. Kunick and Richard C. Martineau, "Sockeye: A One-Dimensional, Two-Phase, Compressible Flow Heat Pipe Application", Nuclear Technology, 207-7, 1096-1117 (2021)
```
