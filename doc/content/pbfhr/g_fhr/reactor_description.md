# Description of the generic fluoride-cooled high-temperature reactor (gFHR)

*Contact: Dr. Mustafa Jaradat (INL), Mustafa.Jaradat\@inl.gov*

*Sponsor: Dr. Steve Bajorek (NRC)*

*Model summarized, documented, and uploaded by Dr. Mustafa Jaradat and Dr. Samuel Walker*

*Model link: [Griffin-Pronghorn Steady-State Model](https://github.com/idaholab/virtual_test_bed/tree/devel/pbfhr/gFHR/steady_state)*

The gFHR is a pre-conceptual design of a fluoride salt cooled high temperature reactor based on material publish by Kairos Power [!citep](gFHR). The geometry is shown in [gFHR_geometry].

!media gFHR/gFHR_geometry.png
  caption= gFHR conceptual design from [!citep](gFHR_report).
  id=gFHR_geometry
  style=width:100%;margin-left:auto;margin-right:auto

The main gFHR reactor specifications are shown in [reactor_specifications]. This design relies on a multipass strategy in which the pebbles are discharged at the top of the active core and then reintroduced uniformly at the bottom of the core. The pebbles are buoyant and float toward the top of the core. The pebbles undergo an average of eight passes before they are discharged. The recirculation, evaluation, and disposal tasks are performed by the pebble handling and storage system (PHSS). During the evaluation task, the PHSS determines if the pebble has achieved the desired design burnup, at which point it is either discharged or recirculated back to the bottom of the core. Note that the average residence time in the original journal article [!citep](gFHR) was approximated between 490 and 550 effective full power days (EFPD).

!table id=reactor_specifications caption=gFHR Reactor Specifications [!citep](gFHR_report).
| Parameter                           | Value                           |
| :---------------------------------- | :------------------------------ |
| Core power                          | 280 MWth                        |
| Core inlet temperature              | 823.15 K                        |
| Core outlet pressure                | 2e5 Pa                          |
| Pebble bed radius                   | 1.2 m                           |
| Pebble bed height                   | 3.0947 m                        |
| Number of pebbles                   | 250,190                         |
| Pebble types                        | One pebble type (3.4g IHM)      |
| Pebble packing fraction (average)   | 0.6                             |
| Average number of passes            | 8                               |
| Average pebble residence time       | 522 days                        |
| Reflector outer radius              | 1.8 m                           |
| Barrel outer radius                 | 1.82 m                          |
| Downcomer outer radius              | 1.87 m                          |
| Vessel outer radius                 | 1.91 m                          |
| Reflector graphite density          | 1,740.0 kg/m$^3$                |
| SS 316H density (barrel and vessel) | 8,000.0 kg/m$^3$                |

This benchmark uses a single pebble design or type. The pebble specifications are shown in [pebble_table]. The pebble includes a spherical lower density center graphite core for buoyancy, followed by a spherical shell that contains the TRISO particles and an outer spherical graphite shell.

!table id=pebble_table caption=Pebble Specifications [!citep](gFHR_report).
| Parameter                       | Value                           |
| :------------------------------ | :------------------------------ |
| Pebble core radius              | 1.380 cm                        |
| Fuel layer radius               | 1.8 cm                          |
| Shell layer radius              | 2.0 cm                          |
| Number of particles per pebbles | 11,660                          |
| Pebble core graphite density    | 1,410.0 kg/m$^3$                |
| Fuel layer matrix density       | 1,740.0 kg/m$^3$                |
| Shell layer graphite density    | 1,740.0 kg/m$^3$                |

The TRISO design specifications are included in [triso_table]. These specifications are based on the oxycarbide fuel testing from the Advanced Gas Reactor development and qualification program (AGR) AGR-2 irradiation campaign [!citep](Epri_report) with the carbon content set to the upper limit of the AGR testing envelope.

!table id=triso_table caption=TRISO Specifications [!citep](gFHR_report).
| Parameter                       | Value                           |
| :------------------------------ | :------------------------------ |
| Fuel kernel radius              | 0.0212 cm                       |
| Buffer outer radius             | 0.03125 cm                      |
| IPyC outer radius               | 0.03525 cm                      |
| SiC outer radius                | 0.03875 cm                      |
| OPyC outer radius               | 0.04275 cm                      |
| Fuel type                       | UC$_0$$_.$$_5$O$_1$$_.$$_5$     |
| Fuel enrichment                 | 19.55%                          |
| Fuel kernel density             | 10,500.0 kg/m$^3$               |
| Buffer graphite density         | 1,050.0 kg/m$^3$                |
| IPyC, OPyC graphite density     | 1,900.0 kg/m$^3$                |
| SiC density                     | 3,180.0 kg/m$^3$                |
| Matrix graphite density         | 1,740.0 kg/m$^3$                |
