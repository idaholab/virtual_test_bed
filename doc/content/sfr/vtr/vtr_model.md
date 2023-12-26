# Versatile Test Reactor (VTR)

*Contact: Nicolas Martin, nicolas.martin.at.inl.gov*

*Model link: [VTR Model](https://github.com/idaholab/virtual_test_bed/tree/devel/sfr/vtr)*

!tag name=Versatile Test Reactor Core model pairs=reactor_type:SFR
                       reactor:VTR
                       geometry:core
                       simulation_type:core_multiphysics
                       transient:steady_state
                       codes_used:BlueCrab;Griffin;BISON;SAM
                       computing_needs:Workstation
                       input_features:multiapps
                       fiscal_year:2022

## VTR core description

The VTR conceptual design presented in the works by [!citep](heidet2020)[!citep](heidet2022)[!citep](nelson_vtr) is used for this study.
This VTR design is a 300-MW thermal, ternary-metallic fueled (U-20Pu-10Zr), low-pressure,
high-temperature, fast-neutron flux $\left(>10^{15} \frac{n}{cm^2 \cdot s} \right)$,
liquid sodium-cooled test reactor.
The VTR is designed with an orificing strategy to yield lower nominal peak cladding
temperatures in each orifice group by controlling the flow rate in each assembly.
The reference VTR core, shown in [vtr_radial], contains 66 fuel assemblies,
six primary control rods, three secondary control rods, 114 radial reflectors, 114 radial
shield reflectors, and 10 test locations.
Of the 10 test locations, five are fixed due to the required penetrations in the cover
heads (instrumented), and five are free to move anywhere in the core (non-instrumented).
The number of non-instrumented test locations can be easily increased or decreased depending
on testing demand, but this may lead to slightly different core performance characteristics
(e.g., flux) due to the different core layouts.
Although the test assemblies will contain a wide variety of materials, they are modeled as
assembly ducts that are only filled with sodium and axial reflectors to have a consistent
core layout for subsequent analyses [!citep](heidet2020).
The axial configurations of the five different types of assemblies (fuel, control rod, test, reflector, shield)
present in the reference VTR are shown in [fuel_assemblies].
The cold dimensions of the driver fuel assemblies and the control rod assemblies are provided in
[fuel_dimensions] and [cr_dimensions], respectively.

In addition to these characteristics, the VTR is being designed to have a cycle length of 100 effective full
power days (EFPD) before it has to be refueled.
During refueling, the VTR will follow a discrete refueling scheme in that there is no fuel reshuffling,
rather the fuel assemblies will be replaced with a fresh fuel assembly depending on its batch number.
The number of cycles the fuel assembly stays in the core is dictated by the desired average fuel discharge
burnup of 50 GWD/t (i.e., the fuel assemblies are discharged with an average burnup as close as possible to
the targeted batch-average burnup of 50 GWD/t).
This means fuel assemblies at the core periphery will remain in the core longer than those at the core center.
This is all done in an effort to avoid unnecessary fuel handling operations that would complicate the design
and increase operational costs.
The discrete fuel management scheme is shown in [fuel_loading], where the 12 central most fuel
assemblies (in Row 1--3) remain in the core for three cycles, the next 18 fuel assemblies (in Row 4) remain
in the core for four cycles, the following 12 fuel assemblies (in Row 5) remain in the core for five cycles,
and the remaining 24 assemblies (in Row 6) remain in the core for six cycles [!citep](heidet2020).
In [fuel_loading], the first number in each assembly corresponds to the the number
of cycles that the assembly will remain in the core and the second number corresponds to when that assembly will be replaced.
For example, the designation "6-4" indicates that this assembly will remain in the core for six cycles and
is replaced every fourth cycle out of six.
This fuel management scheme will result in the equilibrium core to having a periodicity of 60 cycles,
meaning that the core configuration and performance will be identical every 60 cycles with small variations in between.

!media vtr/vtr_core.png
       style=width:75%;margin-left:auto;margin-right:auto
       id=vtr_radial
       caption=Radial configuration of the VTR core layout, taken from [!citep](heidet2020).

!media vtr/vtr_assemblies.png
       style=width:50%;margin-left:auto;margin-right:auto
       id=fuel_assemblies
       caption=Axial configuration of the VTR fuel assemblies.

!table id=fuel_dimensions caption=Driver Fuel Assembly Dimensions, taken from [!citep](shemon2020).
| Parameter             | Cold Dimension | Unit |
|          -            |       -        |  -   |
| Assembly Pitch        | 12             | cm   |
| Duct flat-to-flat     | 11.7           | cm   |
| Duct thickness        | 0.3            | cm   |
| Number of rods        | 217            | -    |
| P/D                   | 1.18           | -    |
| Cladding outer radius | 0.3125         | cm   |
| Cladding thickness    | 0.0435         | cm   |
| Sodium bond thickness | 0.0360         | cm   |
| Fuel slug radius      | 0.2330         | cm   |
| Wire Wrap             | yes            | -    |
| Active fuel length    | 80             | cm   |

!table id=cr_dimensions caption=Control Rod Dimensions, taken from [!citep](shemon2020).
| Parameter                        | Cold Dimension | Unit |
|            -                     |       -        |  -   |
| Assembly Pitch                   | 12             | cm   |
| Inter-assembly gap               | 0.3            | cm   |
| Outer duct outside flat-to-flat  |         11.7   | cm   |
| Outer duct inside flat-to-flat   |         11.1   | cm   |
| Outer duct thickness             |         0.3    | cm   |
| Inner duct sodium gap thickness  |         0.3    | cm   |
| Inner duct outside flat-to-flat  |         10.5   | cm   |
| Inner duct inside flat-to-flat   |         9.9    | cm   |
| Number of rods                   |         37     | -    |
| P/D.                             |       1.02231  | -    |
| Cladding outer radius            |       0.7398   | cm   |
| Cladding thickness               |       0.0825   | cm   |
| Helium bond thickness            |       0.0514   | cm   |
| B4C absorber radius              |       0.6060   | cm   |
| Wire wrap                        |       yes      | -    |

!media vtr/vtr_fuel_loading.png
       style=width:50%;margin-left:auto;margin-right:auto
       id=fuel_loading
       caption=Fuel Management Strategy, taken from [!citep](heidet2020).


## VTR model description

This VTB model provides a conceptual design to the proposed VTR.
Reactor core analyses of the VTR, or more generally SFRs, require the modeling of multiple physics systems, such as:

- Neutron flux distribution throughout the core, obtained by solving the neutron transport equation.

- Coolant temperature and density distribution, obtained by solving the thermal-hydraulic equation
 system for the flowing sodium.

- Fuel temperature distribution, obtained by solving the heat conduction equation in the fuel rods.

- Due to the large temperature gradients occurring in SFR cores, thermal expansion plays a significant role and
 needs to be accounted for by computational models.

The VTR model captures the predominant feedback mechanisms and consists of 4 independent application inputs:

1. A 3D Griffin neutronics model, whose main purpose is to compute the 3D neutron flux / power given the local field temperatures and mechanical deformations due to thermal expansion.

2. A 2D axisymmetric BISON model of the fuel rod which predicts the thermal response given a power density, as well as the thermal expansion occurring in the fuel/clad materials. The predicted quantities (fuel temperature, axial expansion in the fuel) are then passed back to the neutronics model. One BISON input is instantiated per fuel assembly.

3. A tensor mechanic input of the core support plate, predicting the stress-strain relationships given the inlet sodium temperature. The displacements are passed to the neutronics model to account for the radial displacements in the core geometry. Since the core support plate expansion is tied to the inlet temperature (fixed in this analysis), this model is only called once at the beginning of the simulation.

4. A SAM 1D channel input, whose purpose is to compute the coolant channel temperature / density profile and pressure drop, given the orifice strategy selected which dictates the input mass flow rate and outlet pressure and the wall temperature coming from the BISON thermal model. The coolant density and heat transfer coefficient is passed back to BISON to be used in a convective heat flux boundary condition. The coolant density is also passed back to the neutronics model for updating the cross sections. One SAM input is instantiated per coolant channel. The coupling scheme with the variables exchanged between solvers is given in [vtr_scheme].

!media vtr/vtr_scheme.png
       style=width:75%;margin-left:auto;margin-right:auto
       id=vtr_scheme
       caption=The coupling scheme used for the SFR model.

# Griffin Neutronics Model

## Griffin Calculation Scheme

The Griffin neutronics computational model relies on the two-step approach:

1. Cross section spatial homogenization and group condensation using the flux solution from a high-order transport calculation. Typically, for advanced reactors, a 3D continuous-energy Monte Carlo transport calculation is employed to generate the multigroup cross sections and reference fluxes for the second step.

2. Low-order transport solution, using the multigroup cross sections generated at Step 1, with an optional equivalence step that recaptures the homogenization error as well as the remaining spatial/angular/energy discretization errors. In this model, the Continuous Finite Element Method (CFEM) multigroup diffusion approximation with SPH equivalence is employed [!citep](LaboureSPH2019).

This section details the equations in place in the Griffin neutronics model.
The multi-group diffusion equation.

\begin{equation}\label{eq:diffusion}
\begin{split}
  -\nabla \cdot \left(D^{\rm ref}_g(\mathbf{r})\nabla \phi_g(\mathbf{r})\right) +
    \Sigma^{\rm ref}_{rem,g}(\mathbf{r})\phi_g(\mathbf{r})
  = & \\
  \dfrac{\chi_g^{\rm ref}(\mathbf{r})}{k_{\rm eff}}\sum_{g'=1}^G\nu\Sigma^{ref}_{f,g'}(\mathbf{r})\phi_g'(\mathbf{r}) +
    \sum_{g'\neq g}^G \Sigma_{s,g'\rightarrow g}(\mathbf{r})\phi_{g'}(\mathbf{r}) &
\end{split}
\end{equation}

with the following reflective (Neumann) and vacuum (Robin) boundary conditions, defined respectively by:

\begin{equation}
    \nabla \phi_g (\mathbf{r}) \cdot \overrightarrow{n}_b =0, \ \mathbf{r} \in \partial \mathcal{D}_r
\end{equation}

\begin{equation}
    \dfrac{\phi_g(\mathbf{r})}{4}+\dfrac{1}{2}D^{\rm ref}_g \nabla \phi_g (\mathbf{r}) \cdot \overrightarrow{n}_b=0, \ \mathbf{r} \in \partial \mathcal{D}_v
\end{equation}

In the above equations, $G$ is the number of energy groups, $\phi_g$ is the scalar flux, $D^{\rm ref}_g$ is the diffusion coefficient,
and $\Sigma_{rem,g}^{\rm ref}$, $\Sigma_{f,g'}^{\rm ref}$ and $\Sigma_{s,g'\rightarrow g}^{\rm ref}$ are the macroscopic
removal, fission, and scattering cross sections, respectively.
$\overrightarrow{n}_b$ is the outward normal unit vector on the boundary
$\partial \mathcal{D} = \partial \mathcal{D}_r \cup \partial \mathcal{D}_v$.

In general, [eq:diffusion] does not reproduce the reference reaction rates and multiplication factor $k_{\rm eff}$.
SPH factors are introduced to correct the multigroup cross sections for each reaction (removal, fission, scattering)
in each *equivalence region*, $m\in \left[1,\dots, M\right]$ and energy group $g$ in such a way that the reaction rates
from the reference calculation and from the low-order, diffusion equation are equal:
\begin{equation}
    \Sigma_{m,g}=\mu_{m,g}\Sigma_{m,g}^{ref}
\end{equation}

For each equivalence region $m$ and energy group $g$, the reaction rates can be defined as:

\begin{equation}
    \tau_{m,g} = \mu_{m,g}\Sigma_{m,g}^{ref}\phi_{m,g} = \Sigma_{m,g}^{\rm ref}\phi_{m,g}^{\rm ref} = \tau^{\rm ref}_{m,g}
\end{equation}

The SPH-corrected neutron diffusion equation is then written as:

\begin{equation}\label{eq:diffusion_sph}
\begin{split}
  -\nabla \cdot \left(\mu_{m,g}D^{\rm ref}_{m,g}(\mathbf{r})\nabla \phi_g(\mathbf{r})\right) +
    \mu_{m,g}\Sigma^{\rm ref}_{rem,g}(\mathbf{r})\phi_g(\mathbf{r})
  = & \\
  \dfrac{\chi_g(\mathbf{r})}{k_{\rm eff}}\sum_{g'=1}^G\mu_{m,g'}\nu\Sigma^{ref}_{f,m,g'}(\mathbf{r})\phi_{g'}(\mathbf{r}) +
    \sum_{g'\neq g}^G \mu_{m,g'}\Sigma_{s,g'\rightarrow g}^{\rm ref}(\mathbf{r})\phi_{g'}(\mathbf{r}) &
\end{split}
\end{equation}

These reference fluxes $\phi_{m,g}^{\rm ref}$ and cross-section sets $\Sigma_{m,g}^{\rm ref}$ are generated by Serpent for
different combinations of perturbations for the selected cross-section variables (burnup, fuel temperature, etc.), which
are also referred to as parameters. The combinations of these parameters define statepoints.

## Cross-Section Model id=cross-section_model

There exists an intermediate step in the two step method that allows for the cross section evaluation at an arbitrary state point.
This is typically considered as a cross-section parametrization, which depends on the type of analysis to perform and reactor type.
As a general rule, the state variables need to capture the important feedback mechanisms (i.e., the ones that lead to
significant changes in cross sections, and thus in reactivity).
Then, once these state parameters are identified, it is equally important to cover the full range of variation of each parameter,
to avoid extrapolating the cross sections outside of the points used to build the model.
The Griffin cross-section model also requires the grid to be full, meaning that the total number of statepoints increases exponentially with the dimensions (or number of points) used per parameter $p_i$ ($N_{grid} = N_{p_1}\times\dots N_{p_i}\times\dots N_{p_N}$).

This study's purpose is to perform only steady-state analyses, thus the parameter selection is primarily dictated by
the verification of the reactivity coefficients.
The selected reactivity coefficients that require careful selection of the cross-section parametrization are the
fuel temperature (Doppler), the coolant density/temperature, and the control rod insertion fraction.
Other parameters that capture changes in reactivity due to mechanical deformation, such as axial or radial expansion,
are covered directly by the mesh deformation capability of Griffin.
The cross-section parametrization can be written using a functional formulation:

\begin{equation}
    \Sigma_{m,g}(\mathbf{r}) = f(T_{fuel},T_{cool},CR)
\end{equation}

where $f$ is approximated by a piece-wise linear function that uses the local parameter values at each element of the mesh coming from the other physics models.

The grid selected for each parameter is:

- $T_{fuel}=[600,900,1800]$ $K$.

- $T_{cool}=[595,698,801]$ $K$

- $CR=[0,0.25,0.5,0.75,1.]$

The maximum fuel temperature was selected to coincide with the value used for generating a Doppler coefficient (1800 K).
No changes in density were applied when varying the fuel temperature during the cross-section generation process.
It is justified since the BISON model documented in [#bison_thermal] will provide the change in fuel temperature.
Changes in the fuel density (e.g., due to thermal expansion) will be accounted for by the mesh deformation capability of
Griffin and will be presented later.

The change in coolant temperature is actually capturing the change in coolant density, and the cross sections were
generated in Serpent by using the sodium density $\rho(T)$ corresponding to each temperature.
The temperatures selected correspond to a $\pm$ 3% change in sodium density,
which was arbitrarily selected to cover the perturbation range used for the sodium density coefficient (+1%).
Using the sodium density correlation, a $\pm$ 3% change in density corresponds to $\mp$ 103 K.
Both parameters could be then used in Griffin (either temperature or density, since density
is a bijective function of the temperature), as long as consistent data is passed from the thermal hydraulic model.
Note that the Serpent model includes an axial variation in coolant density/temperature,
corresponding for the nominal case to 623 K at the bottom inlet and bottom reflector region,
698 K in the active core region, and 773 K in the top region.
The temperature axial profile is uniformly increased or decreased by a value corresponding to $T_{cool}^{region}\pm 103$ K for the perturbed cases.

The control rod insertion fraction is selected to preserve the control rod worth.
For now, only the primary control rod system is modeled, but it is possible to extend it to model the secondary control rod system as well.

The SPH factors are then computed by Griffin at the selected statepoints and saved in the cross-section library.
The resulting data set consisting of multigroup data (cross sections, kinetics parameters, and SPH factors) can be
then used in a multiphysics simulation where the local conditions (fuel temperature, etc.) are provided by the thermal physics models.

The energy mesh applied is specifically optimized for generating cross sections for fast spectrum reactors with a Monte Carlo code,
and it was originally proposed in [!cite](li_cai_2014) by collapsing the ECCO 33 energy groups into six.
The boundaries are provided in [6groups].

!table id=6groups caption=Energy mesh used for the multigroup cross-section condensation.
| Group | Lower Boundary (MeV) | Upper Boundary (MeV) |
|  -    |          -           |          -           |
|  0    | 2.2313               | 20.0                 |
|  1    | 0.49787              | 2.2313               |
|  2    | 4.0868e-2            | 0.49787              |
|  3    | 9.1188e-3            | 4.0868e-2            |
|  4    | 3.354626e-3          | 9.1188e-3            |
|  5    | 1.00e-11             | 3.354626e-3          |


The spatial mesh used in Griffin is generated with CUBIT [!cite](cubit) and shown in [griffin_mesh_radial] and [griffin_mesh_axial].
As for the Serpent VTR model, each driver fuel assembly is split uniformly in five axial layers.
Each axial layer has a separate set of cross sections coming from the Serpent calculation.
Only beginning of equilibrium cycle (BOEC) results are presented in this study,
but this research can be easily extended to include end of equilibrium cycle results or any given burnup value.

!media vtr/griffin_mesh_radial.png
       style=width:50%;margin-left:auto;margin-right:auto
       id=griffin_mesh_radial
       caption=Griffin Mesh (radial).

!media vtr/griffin_mesh_axial.png
       style=width:50%;margin-left:auto;margin-right:auto
       id=griffin_mesh_axial
       caption=Griffin Mesh (axial).

As mentioned above, the changes in dimensions, due for instance to eigenstrains, are not modeled through
a cross-section parametrization, such as a variation in lattice pitch or other change requiring additional
3D Monte Carlo calculations.
Rather, the changes occurring in the finite element mesh lead to a change in the associated volumes
relative to the non-deformed mesh that is automatically detected by Griffin and used to modify the
corresponding cross sections.
Using Lagrangian notations, the displacement vector $\mathbf{u}(\mathbf{r},t)$ and its associated
gradient $\nabla\mathbf{u}(\mathbf{r},t)$ are related to the strains via strain-displacement relations
(more details will be given on the mechanical equations used in [#bison_mecha]).
Once the displacements are obtained, the changes in material densities can be computed via

\begin{equation}
    \rho^{displaced}(\mathbf{r},t) = \dfrac{\rho^{nominal}(\mathbf{r},t)}{{\rm det}(\nabla \mathbf{u}(\mathbf{r},t)+\mathbf{I})}
\end{equation}

Each macroscopic cross section is then corrected to account for the changes in the mesh dimension:

\begin{equation}
    \Sigma_{r,g} (\mathbf{r},t) \leftarrow \dfrac{ \rho^{displaced}(\mathbf{r},t) }{ \rho^{nominal}(\mathbf{r},t) }\Sigma_{r,g}(\mathbf{r},t)
\end{equation}

where $r$ stands for the reaction type (absorption, fission, scattering, removal).
This model is fairly unique and has the advantage of significantly simplifying the coupling of Griffin with tensor mechanics problems.
It however assumes that the density perturbations do not affect the spectrum significantly and thus that the
microscopic cross sections are not changed.
This assumption will be verified in [vtr_results.md] by comparing the Griffin results against explicit
mesh-deformed Serpent calculations.

## Description of the BISON Thermo-Mechanical Model id=bison

For each fuel assembly, a representative fuel rod is modeled using the BISON code.
A 2D axisymmetric representation of the rod geometry is used, as depicted in [bison_geometry].
The purpose of this model is multiple for this analysis.
First, it captures changes in fuel temperature due to changes in power density and thus is tightly coupled to the neutronics model,
as a change in fuel temperature will change the multigroup cross sections, which will change the power density, and so forth.
It also models the axial thermal expansion of the fuel rod resulting from an increase in the fuel temperature.
The axial expansion of the fuel is also tightly coupled to the neutronics model, primarily via a geometrical effect
(increased fuel rod dimensions, thus increased neutron leakage) and to a lesser extent,
with a density effect (less fissile material per volume), which will change the power density, thus the fuel temperature,
and therefore the axial expansion itself.
These feedback mechanisms are usually ignored in most SFR computational schemes where only a loose coupling strategy is applied.
The BISON model also provides the wall (outer clad) temperature profile for use in the coolant channel calculation,
which passes back the bulk coolant temperature and heat transfer coefficient that are applied as a Robin boundary condition in BISON.
Thus, the thermo-mechanical model is tightly coupled with the thermal-hydraulic model.
Second, the BISON model will provide estimates for key safety limits, such as peak centerline temperature and peak cladding temperature.
In this study, these quantities are based on average power density levels and do not account for variations in rod-to-rod power level,
which can be easily performed as a next step.

Coupling both the heat conduction and the momentum conservation PDEs into a single solve (fully coupled approach) was
found to be difficult from a numerical standpoint and often resulted in solve failures.
A more robust approach was to dissociate the thermal feedback from the mechanical one.
For each fuel assembly, two BISON inputs were created, sharing the exact same geometry but upon which different physics are solved:

1. One input solving only the heat conduction problem across the fuel rod
2. One input modeling the mechanical expansion in the fuel and clad as a function of the temperature.

!media vtr/bison_geometry.png
       style=width:50%;margin-left:auto;margin-right:auto
       id=bison_geometry
       caption=BISON 2D RZ geometry with aspect ratio modified.

!media vtr/vtr_bison_mesh.png
       style=width:50%;margin-left:auto;margin-right:auto
       id=vtr_bison_mesh
       caption=BISON spatial mesh.

### BISON Thermal Model id=bison_thermal

The steady-state heat conduction equation solved is:

\begin{equation}
    -\nabla\cdot k(r,z) \nabla T(r,z) = P^{het}(r,z)
    \label{eq:thcond}
\end{equation}

with the following Neumann boundary condition for $r=0$:

\begin{equation}
    \dfrac{\partial T(r,z)}{\partial r}|_{r=0}=0
\end{equation}

and a Robin boundary condition on the outside clad surface of radius $R$:

\begin{equation}
  -k\nabla T(r,z)|_{r=R}= H_w (T-T_{\infty})
\end{equation}

with $H_w$ as the convective heat transfer coefficient and $T_{\infty}$ as the bulk coolant temperature,
which are computed by SAM (see [#sam] for the correlations used).
The power density for the fuel rod $P^{het}$ corresponds to the average power density per rod for each assembly.
It is obtained by normalizing the power density computed by Griffin on the homogenized fuel assembly so as to preserve
the power between both volumes:

\begin{equation}
    N_{rods}\int_0^R\int_0^L P^{het}(r,z)2\pi r drdz = \int\int\int_{V_{hom}}P^{hom}(x,y,z)dxdydz
\end{equation}

where:

- $N_{rods}$: number of rods per assembly
- $P^{hom}$: power density in $W/m^3$ calculated in Griffin for the 3D homogeneous fuel assembly, whose corresponding volume is $S^{hom}_{hex} L$
- $P^{het}$: power density in $W/m^3$ to be used in BISON for the 2D RZ heterogeneous fuel pin, whose corresponding volume is $S^{het}_{rod}=\pi R^2 L$
- $R$: slug outer radius ($m$)
- $L$: slug length ($m$).

In practice, the power density in BISON is the power density from Griffin scaled up by a normalization factor
$\dfrac{S^{hom}_{hex}}{S^{het}_{rod}}$:

\begin{equation}
    P^{het}(r,z) = \dfrac{S^{hom}_{hex}}{S^{het}_{rod}}P^{hom}(x,y,z)
\end{equation}

Currently, the model assumes that all the fission power is locally deposited in the fuel rod.
The material properties utilized by this model are the thermal conductivity and the heat capacity for the metallic fuel and the HT9 cladding.
BISON incorporates these properties internally, and for the ternary UPuZr metallic fuel, different correlations are available.
For this study, the fresh fuel thermal conductivity from [!cite](billone) is used,
with the Savage model for the fuel heat capacity [!cite](savage).
The cladding material properties are based on [!cite](hofman).

### BISON Mechanical Model id=bison_mecha

The BISON mechanical model solves the steady-state form of the conservation of momentum for solid mechanics
on the same 2D axisymmetric mesh as the thermal model:

\begin{equation}
    \nabla \cdot \sigma(\mathbf{u}(r,z)) = 0
\end{equation}

Where $\sigma$ is the nominal stress tensor, $\mathbf{u}(r,z)$ is the displacement, and with the following boundary conditions:

\begin{equation}
  \mathbf{u}(r,z)|_{z=0}=0
\end{equation}

\begin{equation}
  \mathbf{u}(r,z)|_{r=0}=0
\end{equation}

We rely on the *infinitesimal strain theory*, which linearly relates the stress and displacement tensors.
The displacement is assumed to be much smaller than any relevant dimensions so that its geometry and
the constitutive properties of the material (such as density and stiffness) at each point of space can
be assumed to be unchanged by the deformation.
The nominal stress tensor $\sigma$ is directly related to the symmetric strain tensor $\epsilon$ and
the thermal expansion for isotropic materials:

\begin{equation}
    \sigma(r,z)= \lambda \mathrm{tr}(\epsilon)\mathbf{I} + 2\mu\epsilon -(3\lambda+2\mu)\alpha(T-T_0)\mathbf{I}
\end{equation}

where $\lambda$ and $\mu$ are Lame constants, which depend on Young's modulus $E$ and Poisson's ratio $\eta$:

\begin{equation}
    \lambda = \dfrac{\nu E}{(1+\eta)(1-2\eta)}
\end{equation}

\begin{equation}
    \mu = \dfrac{E}{2(1+\eta)}
\end{equation}

$\alpha$ is the thermal expansion coefficient, $T_0$ the strain-free temperature,
$\mathrm{tr}$ represents a trace operation on a tensor, and $\mathbf{I}$ is the identity tensor.
The strain tensor is evaluated from the displacement with the strain-displacement equations:

\begin{equation}
    \epsilon = \dfrac{1}{2}(\nabla \mathbf{u}(r,z) + \nabla^{\rm T} \mathbf{u}(r,z))
\end{equation}

The temperature $T$ is an input, transferred from the BISON thermal model.

The mechanical properties used in this model consist of the Young's modulus and Poisson's ratio that are required
to build the elasticity tensor, as well as the thermal expansion eigenstrains.
As for the thermal material properties, BISON incorporates these models internally.
Correlations used for Young's modulus and Poisson's ratio for the ternary metallic fuel are based on [!cite](hofman),
while the thermal expansion eigenstrain is taken from [!cite](geelhood).
The HT9 cladding Young's modulus and Poisson's ratio are based on correlations from [!cite](lanl_handbook).
The HT9 thermal expansion coefficient is provided in [!cite](leibowitz).

## Description of the SAM Thermal-Hydraulic Model id=sam

A single channel model is used for this analysis, for which the inlet temperature and outlet pressure are imposed as boundary conditions.
The mass flow rate and sodium velocity are dependent upon the orifice type.
Currently, orifices are only defined for the active core region, as shown in [orifice_map].
SAM relies on a 1D single-phase flow model.
The governing equations are documented in Section 2.1 of the SAM theory manual [!cite](SAMTheoryManual).
The wall surface temperature $T_{wall}$, provided by the BISON calculation, is used in the conjugate heat transfer model at the clad surface.
The convective heat flux is then:

\begin{equation}
    q^{''}=h(T_{wall}-T_{cool})
\end{equation}

where $h$ and $T_{cool}$ are the heat transfer coefficient and the bulk coolant temperature, respectively.

There are two closure models required, one for the determination of the (forced) convective heat transfer coefficient
and one for the wall friction.
By default, SAM uses the Calamai/Kazimi-Carelli correlation for estimating the convective heat transfer coefficient
for bundle geometries with sodium as a fluid, see Section 5.1.2.2 of [!cite](SAMTheoryManual) for a complete description.
For the wall friction, the simplified version of Cheng-Todreas correlation is applied for wire-wrapped rod bundles
(see Section 5.2.2 of [!cite](SAMTheoryManual).

!media vtr/orifice_map.png
       style=width:50%;margin-left:auto;margin-right:auto
       id=orifice_map
       caption=Orifice map

## Description of the Core Support Plate Model id=sec:core_plate

A 3D model of the core support plate is built using the MOOSE tensor mechanics module.
The equations given in [#bison_mecha] apply to this model as well.
The mesh used for the core support plate is given in [core_plate_radial] and [core_plate_axial].
The core support plate is assumed to be fixed at its center (0,0,0), as well at the bottom plane (y=0),
and expand freely in the radial directions, as well as in the upward direction.
Only the radial displacements are connected to the neutronics model in the multiphysics scheme,
so the thermal expansion of the core support plates leads to an increase in fuel assembly pitch, but not a shift in core height.

!media vtr/core_plate_radial.png
       style=width:50%;margin-left:auto;margin-right:auto
       id=core_plate_radial
       caption=Core support plate radial mesh.

!media vtr/core_plate_axial.png
       style=width:50%;margin-left:auto;margin-right:auto
       id=core_plate_axial
       caption=Core support plate axial mesh.

The BISON internal mechanical properties for stainless steel 316 are used.
The Poisson's ratio is held constant ($\nu = 0.31$).
The Young's modulus in Pa is computed using:

\begin{equation}
    E = 2.15946\times 10^{11} - 7.07727\times 10^7 T
\end{equation}

The thermal expansion coefficient is based on data extracted from [!cite](asme2010).

# How to run the model

The neutronics-only model can be ran with Griffin.

Run it via:

 `griffin-opt -i griffin_only.i`

The multi-physics model relies on the BlueCrab app, which incorporates the different required applications (Griffin, BISON, SAM).

Run it via:

 `mpirun -n 48 blue_crab-opt -i griffin_multiphysics.i`

## Acknowledgments

This model is adapted from [!citep](vtr_martin) and prepared for the VTB by Thomas Folk.

!bibtex bibliography
