# Wear analysis

*Contact: V Prithivirajan, veerappan.prithivirajan@inl.gov*

*Model link: [Models for wear effects on graphite behavior](https://github.com/idaholab/virtual_test_bed/tree/main/msr/graphite_model/wear)*

Wear of graphite components used in MSRs can occur due to abrasion and erosion mechanisms. In
the pebble-bed MSRs design, graphite fuel pebbles can rub against each other and reactor structures due to
coolant circulation and pebble cycling, which can result in material loss and surface defects. Additionally,
wear might occur due to the circulation of dust/particulates carried by molten salt from other areas of the
reactor.
The severity of wear is influenced by various factors, including temperature, environment, and the presence
of lubricants. For instance, tribological studies have shown that wear and friction are more pronounced at
lower temperatures and in dry conditions. Conversely, higher temperature environments with molten salt,
such as FLiBe, significantly reduce friction and wear rates, highlighting the protective role of the salt. A
detailed review could be found in reference ([!citep](Prithivi2024)).

The impact of wear extends beyond material loss, as it can introduce surface defects that act as stress concentrators, potentially leading to structural failure. These defects, formed over the component’s lifetime, can compromise the integrity and performance of graphite components in MSRs. In this section, workflows and input files are provided to perform wear analysis with idealized pit and groove profiles.

In pebble-bed MSRs, the graphite reflector is composed of numerous modular blocks. This study primarily focuses on the blocks forming the inner surface of the reflector, where the pebbles slide over them. These blocks are assembled using interlocking mechanisms such as keys or dowels. A schematic of an individual reflector block is shown in [block].

!media msr/graphite_model/wear/4_block.png
      id=block
      style=width:50%
      caption= (a) A top section view of the side reflector, and (b) a schematic of a single reflector block with geometrical parameters.

[Baseline simulation with combined thermal and radiation effects](baseline.md)

[Simulation with a pit profile](pit_profile.md)

[Simulation with a groove profile](groove_profile.md)












