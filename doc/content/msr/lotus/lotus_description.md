# LOTUS Molten Chloride Reactor (LMCR) Description

*Contact: Mauricio Tano, mauricio.tanoretamales.at.inl.gov*

*Model summarized, documented, and uploaded by Rodrigo de Oliveira and Samuel Walker*

<!-- Edits by Samuel Walker -->

The LOTUS Molten Chloride Reactor (LMCR) is an open-source generic chloride fuel salt reactor [!citep](MCRreport2022). Although this open-source model is similar to the Molten Chloride Reactor Experiment (MCRE) scheduled to be built at Idaho National Laboratory, readers should note that these two reactors are not the same. The schematic design of LOTUS MCR is shown in [MCR_geometry_ref]. 

!media msr/lotus/MCR_geometry.jpg
        style=width:75%;margin-left:auto;margin-right:auto
        id=MCR_geometry_ref
        caption=Schematic design of LOTUS MCR [!citep](M3mcr2023).

The LOTUS MCR uses a chloride based ionic liquid containing sodium and uranium fuel. The reactor core and primary loop as seen in [MCR_geometry_ref] contain the reactor vessel marked in yellow, the reflector marked in blue, the piping marked in red, and the pump marked in green.

## LOTUS MCR Reactor Specifications

The tentative parameters of the LMCR are shown in [MCR_reac_specs]. 

!table id=MCR_reac_specs caption=LOTUS MCR Reactor Specifications
| Parameter  | Value  |
|:-----------|:---------|
| Core Power $[$kW$_{th}$$]$ | 25 | 
| Operating Temperature $[$K$]$   | 900 |
| Rated Mass Flow Rate $[$kg/s$]$ | 100 |
| Fuel Salt Composition $[$mol fraction$]$ | 1/3 UCl$_{3}$ - 2/3 NaCl |
| Fuel Salt Enrichment $[$wt %$]$ | 93.2 |
| Fuel Salt Density $[$kg/m$^{3}$$]$ | 4212.60 $-$ 1.0686 $\cdot$ T |
| Fuel Salt Specific Heat $[$J/(kg $\cdot$ K)$]$ | 8900.44 $-$ 13.7794 $\cdot$ T |
| Fuel Salt Thermal Conductivity $[$W/(m $\cdot$ K)$]$ | 5.68 $-$ 8.7832 ✕ 10$^{-3}$ $\cdot$ T | 
| Fuel Salt Dynamic Viscosity $[$Pa $\cdot$ s$]$ | 1.505 ✕ 10$^{-4}$ $\cdot$ $e$^{$\frac{2.666 \cdot 10^{4}}{8.314 \cdot T}$} | 
| Reactor Nominal Density $[$Kg/m$^{3}$$]$ | 3580.0 |
| Reflector Young Modulus $[$GPa$]$  | 300 |
| Reflector Poisson Ratio  | 0.36 |
| Reflector Thermal Expansion Coefficient $[$1/K$]$  | 10.5 ✕ 10$^{-6}$ |
| Reflector Yield Stress $[$MPa$]$  | 100 |
| Reflector Hardening Constant $[$MPa$]$  | 1.2 |

