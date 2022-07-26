# HTR-10 Griffin Neutronics Results

*Contact: Javier Ortensi, Javier.Ortensi@inl.gov*

This section is a short summary of the results section of [!citep](HTR-10Benchmark)
and looks at the various results carried out by Griffin for various HTR-10 calculations.
The two main input files are the *htr-10-critical.i* and the *htr-10-full.i* which are
documented in detail in the Griffin Neutronics Model Section.


## Running an Input File

If the user has access to Griffin built upon a working Moose Framework the following
command from the shell prompt will execute the input file.

```language=bash

/projects/griffin/griffin-opt -i htr-10-critical.i

```

Alternatively, if using an HPC and running in parallel a submission script or interactive session can be submitted
via PBS as seen here [Binary Access with INL-HPC](mooseframework.inl.gov/help/inl/hpc_binary.html).
In this case, an mpirun command must be included as seen below.

```language=bash

mpirun griffin-opt -i htr-10-critical.i

```


## *Initial Critical* Core Results

The first set of results for this model deal with the *htr-10-critical.i* input file
which is the initial criticality benchmark. [critical_eigen_values] summarizes the
results of Griffin using tensor diffusion coefficients (TDC) and super homogenization (SPH)
compared against MCNP and Serpent using ENDFB-VI and Serpent using ENDFB-VII.r1.
As can be seen in the table below, Griffin matches with the accepted Serpent solution very well.

!table id=critical_eigen_values caption=Eigenvalues computed with different codes for the initial critical configuration. (MCNP results obtained from [!citep](IRPhEP))
| Code  | $k_eff$  | uncertainty rel. error (pcm)  |
| :- | :- | :- | :- |
| MCNP (ENDFB-VI)  | 1.01190 | +/- 21 |
| Serpent (ENDFB-VI) | 1.01025 | +/- 5.1 |
| Serpent (ENDFB-VII.r1) | 1.00023 | +/- 2.3 |
| Griffin TDC-SPH-Diffusion | 1.00089 | 67.3 |

Additionally, the flux distribution in the critical core is plotted in [htr10_flux] below.
The effect of the upper cavity is clearly visible as the flux is almost flat within this region.
The thermal flux peaks in the bottom of the core are also visible.

!media /htr10/flux_critical_core.png
   style=width:80%
   id=htr10_flux
   caption=Flux distribution in the critical core (axial centerline) [!citep](HTR-10Benchmark).

## *Full Core* Results

For the *Full Core* case, there are a multitude of different cross section and equivalence
libraries that can be switched out in the *htr-10-full.i* in order to model the full htr-10
reactor at different temperatures and rod positions.
These results are compared against Serpent and results listed in literature.

### Effect of Temperature on Reactivity

The first *Full Core* benchmark problem is to compute the eigenvalues for the full core at
three different uniform core temperatures: 27, 120, and 250 degrees C (300, 393, and 523 degrees K respectively).
The three different equivalence and cross section libraries that these results require
come from the libraries 'htr-10-full-ARO','htr-10-393K', and 'htr-10-523K'.
These can be changed in the [Globalparams] block by changing the 'library_name'
to the appropriate library for the different temperatures.
The results for this study are shown in [full_eigen_values] below.

!table id=full_eigen_values caption=Eigenvalues at three temperatures computed with various codes for the *full core*. The Griffin computed eigenvalues are obtained with SPH corrected diffusion. (Non-INL calculations cited at [!citep](TECDOC))
| Code  | $k_eff$ (27 C)  | $k_eff$ (120 C) | $k_eff$ (250 C) |
| :- | :- | :- | :- |
| Serpent (INL)  | 1.12242 +/- 13 | 1.11068 +/- 20 | 1.09298 +/- 14 |
| Griffin (INL)  | 1.12242 | 1.11061 | 1.09249 |
| VSOP (China)  | 1.1358 | 1.1262 | 1.1111 |
| MCNP4 (China)  | 1.1381 | - | - |
| VSOP 2-D (Germany)  | 1.1468 | 1.1334 | 1.1160 |
| VSOP 3-D (Germany)  | 1.1368 | 1.1232 | 1.1054 |
| TRIPOLI4 (France)  | 1.1474 | - | - |
| VSOP_PBMSR (SA) | 1.1286 | 1.1196 | 1.1047 |

### Effect of Control Rod Configuration on Reactivity

The last *full core* problem looks at various control rod configurations and compares
the results from Griffin against Serpent.
The all rods out (ARO), all rods in (ARI) and one rod in (1RI) results for Diffusion
and SPH corrected Diffusion are compared against the Serpent results in [full_control_rods] below.
In order to obtain these results the user needs to update the 'library_name' in
the [GLobalParams] block to the appropriate libraries 'htr-10-full-ARO','htr-10-full-ARI',
and 'htr-10-full-1RI' respectively.

!table id=full_control_rods caption=Relative difference of Griffin computed eigenvalues (pcm) and reaction rates (%) with the Serpent solution for the *full core* with different rod configurations (ARO -all rods out, ARI - all rods in, and 1RI - one rod in) [!citep](HTR-10Benchmark)).
| Configuration | Eigenvalue - $k_eff$ | Eigenvalue - $\Delta$(pcm) | Absorption - RMS  | Absorption - Max  | Generation - RMS	 | Generation - Max  |
| :- | :- | :- | :- | :- | :- | :- |
| Diffusion  |  |  |  |  |  |  |
| ARO  | 1.15096 | 2542.7 | 20.6 | 136.19 | 6.6 | 13.3 |
| ARI  | 0.97094 | 1061.3 | 24.6 | 158.07 | 10.4 | 21.6 |
| 1RI  | 1.13118 | 2378.5 | 21.3 | 161.9 | 6.97 | 14.6 |
| SPH Corrected Diffusion  |  |  |  |  |  |  |
| ARO  | 1.12347 | 93.9 | 0.2 | 0.5 | 0.1 | 0.19 |
| ARI  | 0.96145 | 74.1 | 0.2 | 0.51 | 0.09 | 0.16 |
| 1RI  | 1.10622 | 119.4 | 0.2 | 0.54 | 0.1 | 0.22 |

From [full_control_rods] above, it's clear that the SPH Correct Diffusion method
makes all the difference when it comes to accuracy against Serpent.
With the SPH Correction, Griffin can match the eigenvalue and the Absorption and
Generation rates calculated by Serpent with maximum errors down to half a percent.

A three-dimensional rendering of the scalar flux in group 10 for the one rod in
case is provided in [1rodin] below. The depression of the flux around the inserted
control rod positioned just outside the core region is clearly visible.

!media /htr10/one_rod_in_volumetric_res2.png
      style=width:80%
      id=1rodin
      caption=Rendering of the scalar flux in group 10 (most thermal flux) for the one-rod in configuration. The depression of the flux around the inserted control rod positioned just outside the core is clearly visible [!citep](HTR-10Benchmark)).

Lastly, all three rod configurations can be examined in [rodcomparison] which is a
slice at z = 270 cm (core region) for 1RI, ARI, and ARO.
The line plots represent the flux along the light green line shown on the 1RI 2D plot
for each of the configurations.
The ARO and ARI have symmetric solutions whereas the 1RI has the asymmetric solution
due to only one region where the flux is depreciated due to the insertion of only one control rod.
The thermal peak at the reflector interface is present for the ARO configuration and still slightly
visible for the 1RI along the line out plot as well.


!media /htr10/comparison_core_level_slices_flux10.png
      style=width:80%
      id=rodcomparison
      caption=Rendering of the scalar fluxes in group 10 at z = 270 cm (lower core level) for all three rod configurations: one rod in (1RI), all rods in (ARI), and all rods out (ARO) along with traces of the scalar fluxes along a line intersecting the inserted control rod in the 1RI configuration [!citep](HTR-10Benchmark)).

## Acknowledgments

This results description section is summarized from [!citep](HTR-10Benchmark) and prepared for the VTB by Samuel Walker.
