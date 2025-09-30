# Infiltration effects on graphite behavior

*Contact: V Prithivirajan, veerappan.prithivirajan@inl.gov*

*Model was co-developed by V Prithivirajan and Ben Spencer*

*Model link: [Models for Infiltration effects on graphite behavior](https://github.com/idaholab/virtual_test_bed/tree/main/msr/graphite_model/infiltration)*

Molten salt infiltration into graphite occurs when the molten salt permeates the interconnected pore structure of the graphite. This phenomenon is driven by factors such as pressure differential, pore characteristics,
and the physical properties of the salt, including viscosity and the interfacial energies between the graphite, salt, and the atmosphere within the graphite pore. A higher pressure differential is required for the molten salt
to infiltrate into smaller pores. Using ultra-fine grades of graphite can significantly reduce the percentage of infiltration. However, the infiltration of molten salt into graphite can have significant implications for the
structural integrity of graphite components, particularly in fuel-salt-based reactor designs like the Molten Salt Reactor Experiment (MSRE). Infiltrated molten salt can act as a heat source due to the fission process,
potentially compromising the structural integrity of the graphite. Given the limited experimental data available for such scenarios, modeling and simulation tools are essential to understand the conditions under which
structural integrity could be affected. A more detailed review is provided in the technical report ([!citep](Prithivi2024)).

The primary objective of this analysis is to address the structural integrity challenges posed by molten salt infiltration in graphite components used in MSRs. The models focus on evaluating stress induced by internal heat sources from molten salt infiltration, assessing the impact of local hot spots, and determining the distribution of inputs corresponding to an user-defined failure metric (such as maximum principal stress) using the parallel subset simulation (PSS) framework. Ultimately, the goal is to develop a comprehensive framework for assessing graphite behavior in MSRs, applicable to new designs or graphite grades.

In this section, the workflow and input files to perform the above-mentioned studies are provided. The first step involves setting up a diffusion equation-based computational model to obtain physically realistic infiltration profiles. Subsequently, a reference solution file is created, collating infiltration profiles at different steps to streamline the process. Following this, the methodology for performing 3D stress analysis using the reference input file is presented. This is followed by procedures for conducting hot spot analysis. Finally, the PSS framework is detailed. While hot spots and PSS are provided for 2D analysis, they are easily extendable to 3D.

This study uses the graphite moderator geometry ([Geo]) from the Molten Salt Reactor Experiment (MSRE) due to the availability of comprehensive and publicly accessible data. 

!media msr/graphite_model/infiltration/1_geo.png
      id=Geo
      style=width:80%
      caption= Schematic of the graphite stringer assembly in the Molten Salt Reactor Experiment (MSRE): (a) Full assembly, (b) Cross-section showing graphite moderator and coolant channels, and (c) Cross-section of the unit cell of the moderator, used as input for simulations.

[Creation of infiltration profiles](infiltration_profile.md)

[Creation of a reference solution file](reference_solution_file.md)

[3D stress analysis](stress_analysis.md)

[Failure Analysis](pss.md)

[Hotspot analysis](hotspot.md)




