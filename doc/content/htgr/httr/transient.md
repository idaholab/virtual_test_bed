# High Temperature Engineering Test Reactor (HTTR) Transient Multiphysics Model Description

*Contact: Robby Kile, Robert.Kile@inl.gov*

*Model link: [HTTR Transient Multiphysics](https://github.com/idaholab/virtual_test_bed/tree/devel/htgr/httr/lofc_transient)*

!tag name=High Temperature Engineering Test Reactor Transient Multiphysics Model
     description=Loss-of-forced-cooling simulation of HTTR coupling point kinetics, full-core porous-media thermal hydraulics, and heterogeneous fuel heat transfer
     image=https://mooseframework.inl.gov/virtual_test_bed/media/htgr/httr/transient/TransientCodePath.png
     pairs=reactor_type:HTGR
           reactor:HTTR
           geometry:core;fuel_pin
           V_and_V:demonstration
           simulation_type:multiphysics
           input_features:multiapps;transfers
           transient:loss_of_forced_cooling
           codes_used:Griffin;Pronghorn;BISON
           computing_needs:Workstation
           fiscal_year:2026
           sponsor:NEAMS
           institution:INL

This steady-state and transient multiphysics model of the HTTR includes neutronics, homogenized full-core thermal hydraulics, and heterogeneous single-rod heat transfer. For background on the reactor, see the [HTTR description](httr_reactor_description.md).

## Coupled Multiphysics Model

The model combines point kinetics, xenon/iodine tracking, spatial power mapping, homogenized porous-media thermal hydraulics, and rod-scale fuel heat transfer. These capabilities are coupled hierarchically using the MOOSE MultiApp and Transfer systems: [Griffin](#grif) solves point kinetics, [Proxy](#proxy) maps power, [Pronghorn](#prong) solves thermal hydraulics, and distributed [BISON](#bison) simulations solve fuel heat transfer. Physical fields are transferred between simulations in the A–D sequence shown below. The fuel-performance application runs multiple times per timestep to sample conditions throughout the fuel region.

!media media/htgr/httr/transient/TransientCodePath.png
    style=width:100%
    id=F1
    caption=Workflow of the transient model's multiphysics coupling. A, B, C, and D represent outputs from `A01b_Griffin.i`, `B01_Proxy.i`, `C01_Pronghorn.i`, and `D01_Bison.i`, respectively. Here, $h$ represents the heat-transfer coefficient and $q_{rod}$ represents power per rod.

The point-kinetics-equation (PKE) solver calculates the reactor power and transfers it through the application hierarchy shown in [Figure 1](#F1). An intermediate 3D mesh application, [Proxy](#proxy), applies fixed spatial profiles to map the global PKE power onto the full-core thermal-hydraulics mesh. The fuel-performance application receives temperatures, power per rod, and heat-transfer coefficients; it computes fuel and graphite-sleeve temperatures that feed back into the point-kinetics reactivity calculation.

## PKE Neutronics Solver (Griffin) id=grif

The NEAMS code Griffin [!cite](Griffin2020) computes the neutronics using spatially independent point-kinetics equations. The Griffin solve is the main application and coordinates the coupled calculation.

### Mesh

Because the PKEs are spatially independent, they do not require a physical mesh. The Xe-135/I-135 depletion capability does require a mesh, however, so the Griffin inputs contain a dummy mesh.

!listing htgr/httr/lofc_transient/case/A01b_Griffin.i block=Mesh

### Neutronics

The `PKE` block defines a neutron-amplitude equation and six delayed-neutron precursor groups. Initial values come from the steady-state initialization input, `A01a_Griffin_initial.i`, as described in [Running the Simulation](#rts).

The amplitude equation is

\begin{equation}
\frac{dn}{dt} = \frac{\rho - \beta}{\Lambda} n + \sum_{i=1}^{6} \lambda_i C_i + S
\end{equation}

where $n$ is the neutron amplitude, $\rho$ is the total reactivity, $\beta$ is the total delayed neutron fraction, $\Lambda$ is the mean generation time, $\lambda_i$ and $C_i$ are the decay constant and concentration of delayed neutron precursor group $i$, and $S$ is an external source term.

The delayed neutron precursor concentrations are governed by

\begin{equation}
\frac{dC_i}{dt} = \frac{\beta_i}{\Lambda} n - \lambda_i C_i \qquad i = 1, \dots, 6
\end{equation}

where $\beta_i$ is the delayed neutron fraction of group $i$.

!listing htgr/httr/lofc_transient/case/A01b_Griffin.i block=PKE

### Reactivity Feedback

Reactivity in the amplitude equation is supplied by the `reactivity_total` function and consists of several components:

!listing htgr/httr/lofc_transient/case/A01b_Griffin.i block=Functions/reactivity_total

This function is the parsed function that contributes to the amplitude equation of the PKE. In the function, 'beta' is the effective delayed neutron fraction, a constant listed at the top of the input file under 'beta_eff'. 'rho0' is a baseline reactivity constant tuned to make the power, 'n', sit at steady state; it is itself comprised of the source compensation offset 'rho_star', a negative number sized to cancel the fixed source term in the PKE at nominal power, and 'xenon_worth', a constant defined at the top of the code.

Below are the functions called in the reactivity function.

!listing htgr/httr/lofc_transient/case/A01b_Griffin.i start=[Functions] end=[reactivity_total]

'xenon_reactivity' is a negative feedback proportional to the concentration of Xenon relative to its initial value:

\begin{equation}
\rho_{xe} = -w_{xe} \frac{N_{Xe135}(t)}{N_{Xe135}(0)}
\end{equation}

where $w_{xe}$ is the xenon worth and $N_{Xe135}$ is the Xe-135 atomic density.

'fuel_feedback' and 'modr_feedback' are negative reactivity feedbacks computed from the local temperature, following a linear form:

\begin{equation}
\rho_{fuel} = \alpha_{fuel} \left( T_{fuel} - T_{fuel,ref} \right)
\end{equation}

\begin{equation}
\rho_{modr} = \alpha_{modr} \left( T_{modr} - T_{modr,ref} \right)
\end{equation}

where $\alpha_{fuel}$ and $\alpha_{modr}$ are the fuel and moderator temperature coefficients of reactivity.

### Xenon-Iodine Tracking

The fission product Te-135 decays with a 19-second half-life into I-135, which then decays with a 6.57-hour half-life into Xe-135. Xe-135 is removed through neutron absorption and radioactive decay with a 9.14-hour half-life. These xenon/iodine dynamics are tracked by a depletion calculation coupled to the transient flux history.

The 'Mat_1' block retrieves isolated Xe-135/I-135 dynamics from two libraries, one cross section library ([XS](#xsdt)) and one decay library ([DT](#xsdt)), and concentrations evolve using 'DepletionNeutronicsMaterial', driven by the point kinetics derived flux 'flux_g0'. The Xenon concentration is then fed back to the PKE amplitude equation as a feedback term.

!listing htgr/httr/lofc_transient/case/A01b_Griffin.i block=Materials/Mat_1

## 3D Mesh PKE Coupling (Proxy) id=proxy

The PKE solver computes only global values, while the downstream solvers resolve spatial behavior. The Proxy application maps the global values onto a 3D reactor mesh so that transferred quantities retain spatial information.

### Mesh

The 'Mesh' block within B01_Proxy loads a coarse mesh. The file mesh generator, 'fmg', loads a pre-generated mesh from file. 'extrude' takes the 2D mesh and extrudes it into the third dimension, partitioning blocks into equal parts, each the height of a fuel rod.

!listing htgr/httr/lofc_transient/case/B01_Proxy.i block=Mesh

!media media/htgr/httr/transient/ProxySlice.png
    style=width:40%
    id=F2
    caption=Radial cut of the 3D homogenized coarse mesh loaded in `B01_Proxy.i`.


### Transfers

This mapping layer relies largely on data transfers. The 3D mesh PKE coupler receives information from both its parent, the [Griffin](#grif) neutronics solver, and its child, the [Pronghorn](#prong) thermal-hydraulics solver. It receives total power from the parent and average moderator, fuel-block, and fuel-rod temperatures from the child. The coupler maps the global power onto the portion of the mesh representing core rings 1–3, as described in [Coupling to the Fuel](#couple2fuel), and transfers that distribution to its child. Temperature data pass from the thermal-hydraulics solver to the PKE solver without modification.

!listing htgr/httr/lofc_transient/case/A01b_Griffin.i block=Transfers

!listing htgr/httr/lofc_transient/case/B01_Proxy.i block=Transfers

## Core Coarse Mesh Thermal Hydraulics (Pronghorn) id=prong

NEAMS code Pronghorn, [!cite](pronghorn_navier_stokes), uses the power data and its location to model the associated thermal hydraulics. HTTR is cooled using helium channels throughout the core, the porous-media RZ mesh generation averages porosities to approximate the core to save on computation and still properly solve thermal hydraulics using heat conduction.

### Mesh

The thermal-hydraulics mesh represents the reactor vessel as a porous medium and is built in the `Mesh` block using `CartesianMeshGenerator`. Block IDs identify the ring, axial layer, and region (fuel, reflector, plena, side reflector, vessel, cavity inlet, and seal/key blocks). Sideset generators define the boundaries needed by the finite-volume boundary conditions (FVBCs) and pressure-form losses at subdomain interfaces.

!media media/htgr/httr/transient/VisualGuidePronghorn.png
    style=width:100%
    id=F3
    caption=The path traced by the mesh created by `C01_Pronghorn.i` when revolved around the y axis. The mesh is mirrored and rotated counterclockwise 90 degrees. Color is only present to make the mesh distinct from its traced rotation. Since the reactor vessel is not a perfect cylinder, the mesh is not truly axisymmetric.

This mesh is constructed inside the input file rather than loaded separately. In this mesh, 'subdomain_id' references each block ID as seen in the block_name and block_id at the start of the mesh block, and every number in the 18 by 10 grid each maps to one of those. A row represents the change in y, a column the change in x. Knowing '95' represents the void seen in the mesh above helps to orient the mesh with the id grid properly.

!listing htgr/httr/lofc_transient/case/C01_Pronghorn.i start=[Mesh] end=[plen_Up_Side]

The rest of the mesh block transforms the geometry with sidesets so later portions of code can call particular parts of the geometry. There are only two exceptions, the first being the deletion of block 95 in 'delete_voidspace', which allows an initial rectangular generation and subsequent deletion to transform the mesh to the correct reactor vessel shape. The second non-sideset block in the mesh declares the coordinate type as RZ in 'coord_type'. A given sideset transformation follows one of these two formats in this code:

```language=CPP
  [psr_right]                                       # The name of the mesh generator
  type = SideSetsAroundSubdomainGenerator           # The generation type
    input = psr_left                                # The boundary is applied to the output of this mesh generator
  block = 9                                         # The block(s) is becoming a boundary
  normal = '1 0 0'                                  # The face of the block to become a boundary (in normal, x,y,z, coordinates)
  new_boundary = psr_right                          # The name of the new boundary
[]

[LP_floor]                                          # The name of the mesh generator
    type = SideSetsBetweenSubdomainsGenerator       # The generation type
    input = psr_right                               # The boundary is applied to the output of this mesh generator
    primary_block = 8                               # Primary block(s) that touch paired block(s) will have the boundary applied at the connection
    paired_block = 9                                # Primary block(s) that touch paired block(s) will have the boundary applied at the connection
    new_boundary = LP_floor                         # The name of the new boundary
    normal = '0 1 0'    (added for example)         # Disambiguates the direction of shared face points to become boundaries if multiple exist
[]
```

Relevant sidesets are discussed where they are used; the complete mesh block is shown below.

!listing htgr/httr/lofc_transient/case/C01_Pronghorn.i block=Mesh

### Heat Transfer

Heat transfer simulations in this model utilize the NEAMS codes Pronghorn and BISON, [!cite](BISON), though BISON will be discussed in the [next section](#bison). C01_Pronghorn uses a 2D RZ porous-media mesh that receives radial power distributions to return ring average fuel and moderator temperatures. This model resolves fluid temperature with a homogenized core solve through Pronghorn. A single volumetric convection term is applied between the solid and fluid temperatures:

(1) $q^{'''} = \tilde{h}_{\text{wall}}(\textit{T}_{\text{solid}}-\textit{T}_{\text{fluid}})$,

where $\tilde{h}_{\text{wall}}$ is the block-dependent local wall heat transfer coefficient, computed from a Dittus-Boelter correlation (in units of W/K/m$^3$), and $\textit{T}_{\text{fluid}}$ is the fluid temperature calculated in the same porous-media model. This term is applied within the fuel, replaceable reflectors, seal/key, and control rod regions to remove heat generated in the fuel and transfer it to the coolant.

### Finite Volume Boundary Conditions (FVBCs)

Boundary conditions are applied to the solid temperature variable, 'T_solid' in units of K. One of the finite volume boundary conditions calls 'core_bottom', one of the produced meshes defined in the 'Mesh' block above. The other three use the boundary 'right', a boundary automatically generated by 'CartesianMeshGenerator' at the most positive in x face of the mesh. These boundary positions are highlighted in the figure below.


!media media/htgr/httr/transient/PronghornBCs.png
    style=width:100%
    id=F4
    caption=Boundary conditions 1, 2, 3, and 4, explained below, and are outlined in pink on the coarse mesh loaded in `C01_Pronghorn.i`. The mesh is mirrored and rotated counterclockwise 90 degrees.

The 'Corebot_rad' block imposes a radiative boundary condition at the bottom of the core, radiating heat outward to an ambient 'Tinfinity'. This BC is applied at 1 in [Figure 4](#F4).

!listing htgr/httr/lofc_transient/case/C01_Pronghorn.i block=FVBCs/Corebot_rad

'vesselRadiate' imposes a radiative boundary condition from the outer vessel wall to the cavity wall, radiating heat to the concentric cylindrical cavity at temperature 'Tinfinity'. The cavity wall is a fixed distance from the vessel wall, and is not meshed. This BC is applied at 2 in [Figure 4](#F4).

!listing htgr/httr/lofc_transient/case/C01_Pronghorn.i block=FVBCs/vesselRadiate

`vessel_convect` imposes a convective boundary condition on the outer vessel wall, transferring heat outward to a fixed bulk temperature, `T_bulk`. This BC is applied at location 3 in [Figure 4](#F4).

!listing htgr/httr/lofc_transient/case/C01_Pronghorn.i block=FVBCs/vessel_convect

'vessel_conduct' models conduction through the stagnant helium gap between the vessel outer wall and the cavity wall, using a thermal resistance formulation. This BC is applied at 4 in [Figure 4](#F4).

!listing htgr/httr/lofc_transient/case/C01_Pronghorn.i block=FVBCs/vessel_conduct

### Physics

Momentum and fluid energy transport are handled here rather than in explicit kernels, and also make use of the sideset blocks defined in the 'Mesh' block.

#### Flow

'Flow' sets up the porous-media flow solve as weakly-compressible, and calls functors for density and viscosity. Initial velocity and pressure guesses are given, along with the gravity vector and blocks to be governed by the physics. Porosity is supplied through a functor, and the Bernoulli treatment governs how pressure behaves across porosity interfaces. Discrete pressure drops are applied at a list of sidesets, each paired with its own loss coefficient. Inlet, wall, and outlet boundaries are each assigned their type and associated value, fixed velocity at the inlet, slip or symmetry at the walls, and fixed pressure at the outlet. 'Symmetry' is the boundary assigned to the reactor center, and 'fluid_sym' is the set of blocks at the center. The friction is modeled using combined Darcy and Forchheimer terms, each governed by its own functor, with a correction enabled for consistency at porosity jumps. The interpolation schemes for pressure and advection are set, and hydraulic separator sidesets are listed to keep flow in different rings from mixing pressure across ring interfaces. To solve porous-media flow these equations are used:

!equation
\epsilon\frac{\partial \rho}{\partial t} + \nabla \cdot \rho\vec{v}_D = 0

!equation
\frac{\partial \rho \mathbf{v}_D}{\partial t} + \nabla \cdot \left(\frac{\rho}{\epsilon}\mathbf{v}_D \otimes \mathbf{v}_D\right) = \nabla \cdot \left(\mu \nabla \frac{\mathbf{v}_D}{\epsilon}\right) - \epsilon\nabla p + \epsilon(\mathbf{F}_g + \mathbf{F}_f)

In these equations, $\rho$ is the density, $\mu$ is the dynamic viscosity, $\epsilon$ is the porosity, $\mathbf{v}_D$ is the superficial velocity. $p$ is the pressure, $\mathbf{F}_g$ is the gravity term, and $\mathbf{F}_f$ is the friction term.

!listing htgr/httr/lofc_transient/case/C01_Pronghorn.i block=Physics/NavierStokes/Flow

#### Fluid Heat Transfer

'FluidHeatTransfer' links itself to the flow physics to take the volume and pressure solution, then calls functors for thermal conductivity and specific heat. Fluid temperature is established as the item to be solved for, temperature of the inlet helium flow is set, and all walls are given a boundary condition and associated flux. The blocks causing ambient convection heat transfer are listed, the functor governing that exchange is defined, as is the advection scheme. To solve for flow in a porous medium, the solver uses the equation:

!equation
\frac{\partial \epsilon \rho h}{\partial t} + \nabla \cdot (\rho h \mathbf{v}_D) - \nabla \cdot (k_f \nabla T_f) - Q + \alpha(T_f - T_{ambient}) = 0

In this equation, $h$ is the fluid enthalpy, specific heat is $c_p$, $\rho$ is the fluid density, $\epsilon$ is the porosity, $T_f$ is the fluid temperature, $\mathbf{v}_D$ is the advecting superficial velocity, $k_f$ is the fluid effective thermal conductivity. $Q$ is the source term (energy deposited directly in the fluid), $\alpha$ is the ambient convection volumetric heat transfer coefficient, and $T_{ambient}$ is the ambient temperature. 'solve_for_enthalpy' can be toggled on or off in this block.

!listing htgr/httr/lofc_transient/case/C01_Pronghorn.i block=Physics/NavierStokes/FluidHeatTransfer

### FVKernels

The finite volume kernels, 'FVKernels', are blocks that define the governing equations for the solid energy fields.
'energy_storage' adds the time derivative term of the solid energy equation.

!listing htgr/httr/lofc_transient/case/C01_Pronghorn.i block=FVKernels/energy_storage

'solidConduct' defines anisotropic heat conduction through the solid blocks in the mesh, using a direction dependent conductivity tensor, 'ks', to account for coolant channel holes running axially through the fuel and reflector blocks.

!listing htgr/httr/lofc_transient/case/C01_Pronghorn.i block=FVKernels/solidConduct

'heat_source' deposits the fission power density into the fuel blocks.

!listing htgr/httr/lofc_transient/case/C01_Pronghorn.i block=FVKernels/heat_source

'convection' removes heat from the solid to the fluid by convection, using a block dependent wall heat transfer coefficient, 'wall_htc'.

!listing htgr/httr/lofc_transient/case/C01_Pronghorn.i block=FVKernels/convection

### Materials

'FunctorMaterials' is responsible for defining all physical and material properties necessary for flow and energy kernels. Density, viscosity, thermal conductivity, wall heat transfer coefficients, and porosity are all defined in this block.

'porosity_material' assigns a porosity value (void fraction 0-1) in each region, set by block to approximate the open flow area in each homogenized region.

!listing htgr/httr/lofc_transient/case/C01_Pronghorn.i block=FunctorMaterials/porosity_material

There are several blocks that contain mentions of 'HTC' in 'FunctorMaterials'. Each such mention in this section is computing wall heat transfer coefficients per region using a Dittus-Boelter correlation, with a region specific constant 'C' capturing the geometry dependent Nusselt number correlation. Below is one such example. 'block' specifies the region(s), and 'C' is defined using the equation of said region(s).

!listing htgr/httr/lofc_transient/case/C01_Pronghorn.i block=FunctorMaterials/htc_ring1_fuel

Solid thermal conductivity is defined per material type as a function of solid temperature (K) using 'ADParsedfunctorMaterial'.

IG110 graphite for example:

!listing htgr/httr/lofc_transient/case/C01_Pronghorn.i block=FunctorMaterials/IG110_ks

Solid specific heat and density ('cp_s' in J/kg/K and 'rho_s' in kg/m$^3$) are similarly defined on a per material basis, either as a temperature dependent expression or a constant.

Continuing with IG110 as the example, the specific heat and density are listed below:

!listing htgr/httr/lofc_transient/case/C01_Pronghorn.i block=FunctorMaterials/IG110_cp

!listing htgr/httr/lofc_transient/case/C01_Pronghorn.i block=FunctorMaterials/IG110_rho

Helium is specified as the fluid through the block 'FluidProperties', so temperature, pressure, specific heat, Reynolds number, porosity, Prandtl number, and further fluid quantities compute with helium relationships when called.

!listing htgr/httr/lofc_transient/case/C01_Pronghorn.i block=FluidProperties

Fluid properties are supplied by 'heProps' through use of a helium equation of state and characteristic length and porosity of the region.

!listing htgr/httr/lofc_transient/case/C01_Pronghorn.i block=FunctorMaterials/heProps

Drag coefficients for the porous media momentum equation are defined per region using 'FunctorChurchillDragCoefficients', with multipliers tuned by block to reproduce expected flow resistances. One such tuned set of blocks is below. The 'multipliers' represent how many times the flow resistance of the fuel channels a listed region has in any given direction (x, y, z). Thanks to flow blocking caps, the blocks below have 800 times the resistance in the y direction.

!listing htgr/httr/lofc_transient/case/C01_Pronghorn.i block=FunctorMaterials/drag_ring1_4

### Coupling to Fuel Performance via Transfers id=couple2fuel

The thermal hydraulics solver sends information to its parent and child. Pieces of information sent to the child are the helium temperatures, wall temperatures, the average heat transfer coefficients of the fuel rod blocks, and the power per rod. The thermal hydraulics solver segregates the information by which ring in the reactor it refers to. All information is then transferred as a scalar set of values to the fuel performance evaluation code. The below image contains three rings, the closest to center, ring 1, being the topmost row of fuel elements, two cells tall in the colors pink, brown, pink, purple from left to right. The second and third rings are similarly two cells tall each, and below this. The fuel is contained in the brown, white, and yellow portions of the rings.

!media media/htgr/httr/transient/Rings123Shown.png
    style=width:100%
    id=F5
    caption=Rings 1, 2, and 3, outlined on the coarse mesh loaded in `C01_Pronghorn.i`. The mesh is mirrored and rotated counterclockwise 90 degrees.

Once the fuel performance evaluation code completes its solve, the average temperatures of the fuel rod and sleeve are returned. The outgoing and incoming transfers are seen in the 'Transfers' block below.

!listing htgr/httr/lofc_transient/case/C01_Pronghorn.i block=Transfers

## Fuel Rod Performance Evaluator (BISON) id=bison

NEAMS code BISON, [!cite](BISON), is the code used to evaluate fuel performance of the rods. It calculates thermal conductivity of fuel and graphite, power and power density, as well as averages of gap conductance, heat transfer coefficients, and various location temperatures. The temperatures are the most important output, being sent to the other codes to repeat the calculation cycle. All other outputs are not reused. These calculations are done on a per rod basis to gather relevant data for each.

### Mesh

The 'Mesh' block loads a mesh, pin_mesh_in.e, in RZ (axisymmetric) geometry, representing fourteen fuel compacts, their sleeve, and the surrounding moderator block as three concentric regions. This collection is the fuel rod.

!listing htgr/httr/lofc_transient/case/D01_Bison.i block=Mesh

The mesh loaded was generated with 'compact_mesh.i', which does the sideset generation, much like the thermal hydraulics solver, to establish boundaries and give names to geometry. The exact same dy by dx grid formatting seen in the thermal hydraulics code is used, and a similar trick to generate the mesh with a rectangle and delete void is done here as well. This time, the voidspace is block 3. Each sideset will be discussed as it is used in later boundaries.

!listing htgr/httr/lofc_transient/supporting_files/compact_mesh.i

!media media/htgr/httr/transient/VisualGuideBison.png
    style=width:100%
    id=F6
    caption=The 2D heterogeneous mesh in RZ geometry loaded in `D01_Bison.i`. Similar to the mesh of the thermal hydraulics code, extruding about the edge yields the true dimensions of the fuel rod. The fuel block, graphite sleeve, and moderator block are blue, red, and green respectively.

### Thermal Contact

The 'ThermalContact' block resolves conduction and radiation across three unmeshed areas in generation, between the tops of the sleeve and fuel compacts, between the side of the sleeve and fuel compacts, and between the outer side of the sleeve and the inner side of the moderator. All three gaps use a gap conductivity value (W/m/K) corresponding to the temperature and pressure of helium at the relevant location, as well as an emissivity value of 0.8 for both contact surfaces.

!media media/htgr/httr/transient/BisonTCs.png
  style=width:100%
  id=F7
    caption=Shown is one of the five fuel pins from the `D01_Bison.i` mesh; composed of a fuel block, in grey, a graphite sleeve, in red, and a graphite moderator block, in green. Areas 1, 2, and 3 contain the thermal contact boundaries and will be described in this section.

!listing htgr/httr/lofc_transient/case/D01_Bison.i block=ThermalContact/gap_top

!media media/htgr/httr/transient/BisonTC1.png
    style=width:50%
    id=F8
    caption=A close up of the fuel rod mesh, Area 1 as seen in [Figure 6](#F6), showing the gap between the 'sleeve_top' (the section of the graphite sleeve to the right, in red) and the 'fuel_top' (the section of the fuel compacts to the left, in grey), where heat transfer takes place; the boundaries are shown as pink lines.

!listing htgr/httr/lofc_transient/case/D01_Bison.i block=ThermalContact/gap_side

!media media/htgr/httr/transient/BisonTC2.png
    style=width:70%
    id=F9
    caption=A close up of the fuel rod mesh, Area 2 as seen in [Figure 6](#F6), showing the 'sleeve_inner' (the section of the graphite sleeve at the top, in red) and the 'fuel_side' (the section of the fuel compacts at the bottom, in grey), which contains a very slight gap in which heat transfer takes place. The boundaries are shown as pink lines.

!listing htgr/httr/lofc_transient/case/D01_Bison.i block=ThermalContact/cooling_channel

!media media/htgr/httr/transient/BisonTC3.png
    style=width:100%
    id=F10
    caption=A close up of the fuel rod mesh, Area 3 as seen in [Figure 6](#F6), showing the gap between the 'sleeve_outer' (the outer wall of the graphite sleeve, in red) and the 'block_inner' (the inner wall of the graphite block, in green) where heat transfer takes place. The boundaries are shown as pink lines.

### Boundary Conditions (BCs)

Four boundary conditions are applied at the locations shown below.

!media media/htgr/httr/transient/BisonBCs.png
    style=width:100%
    id=F11
    caption=Shown is one of the five fuel pins from the `D01_Bison.i` mesh; composed of a fuel block, in grey, a graphite sleeve, in red, and a graphite moderator block, in green. Areas 1, 2, 3, and 4 contain the boundary conditions described in this section.

A zero heat flux Neumann boundary condition is imposed on the bottom of the graphite sleeve to represent the axial symmetry of the modeled section. This is done with the equation:

!equation
\frac{\partial u}{\partial n} = h \quad \in \partial\Omega_N

In this equation, $u$ is the solved variable, 'temp', $h$ is the constant flux value, 'value = 0.0', and $\partial\Omega_N$ is the set of boundary subsets where the condition is applied, in this case 'neumann' and 'sleeve_bot'.

!listing htgr/httr/lofc_transient/case/D01_Bison.i block=BCs/Neumann

!media media/htgr/httr/transient/BisonBC1.png
    style=width:100%
    id=F12
    caption=A close up of the fuel rod mesh, Area 1 as seen in [Figure 11](#F11), showing the placement of the Neumann boundary. The Neumann boundary establishes zero flux along this surface, as it is the center of the RZ mesh, and therefore when extruded, a solid object. The boundary is shown as a pink line. This Boundary is mirrored and is also present on the bottom of the fuel rod at the axis of rotation, as seen on the left side of [Figure 11](#F11).

The next three boundaries are applied with the equation:

!equation
q'' = Hw(T - T_{inf})

This equation uses $q''$ as the convective heat flux, $Hw$ as the convective heat transfer coefficient, $T$ as the solved temperature, and $T_{inf}$ as the far-field temperature, convective heat transfer with the coolant is imposed at the inner and outer walls of the cooling channel. In
'convective_inner', the heat transfer coefficient 'Hw_inner' (in W/K/m$^2$) is applied at the inner cooling channel wall.

!listing htgr/httr/lofc_transient/case/D01_Bison.i block=BCs/convective_inner

!media media/htgr/httr/transient/BisonBC2.png
    style=width:100%
    id=F13
    caption=A close up of the fuel rod mesh, Area 2 as seen in [Figure 11](#F11) showing the 'sleeve_outer' (the section of the graphite sleeve at the top, in red) where the boundary is applied. The boundary is shown as a pink line.

'convective_outer' specifies a similar heat transfer coefficient at the inner wall of the graphite block.

!listing htgr/httr/lofc_transient/case/D01_Bison.i block=BCs/convective_outer

!media media/htgr/httr/transient/BisonBC3.png
    style=width:100%
    id=F14
    caption=A close up of the fuel rod mesh, Area 3 as seen in [Figure 11](#F11) showing 'block_inner' (the section of the graphite block at the top, in green) where the boundary is applied. The boundary is shown as a pink line.

'outside_bc' weakly imposes the moderator temperature on the outermost radial wall of the graphite block, using a very high heat transfer coefficient. This makes the wall temperature effectively 'Tmod'.

!listing htgr/httr/lofc_transient/case/D01_Bison.i block=BCs/outside_bc

!media media/htgr/httr/transient/BisonBC4.png
    style=width:100%
    id=F15
    caption=A close up of the fuel rod mesh, Area 4 as seen in [Figure 11](#F11) showing the 'block_outer' (the section of the graphite block at the top, in green) where the boundary is applied. The boundary is shown as a pink line.

Both wall heat-transfer coefficients and `Tfluid` are computed by the coupled thermal-hydraulics solve and transferred into the BISON application to define the inner and outer convective BCs.

### Kernels

The 'Kernels' block defines a transient heat conduction equation. 'heat' defines conductive heat transfer through the fuel, sleeve, and moderator, 'heat_ie' adds the time derivative term of the energy equation, and 'heat_source' deposits volumetric power into the fuel rod, scaled from the rod averaged power received from the coupled power mapping calculation.

!listing htgr/httr/lofc_transient/case/D01_Bison.i block=Kernels

## Transient vs. Steady State

This model runs a steady state to initialize the transient, so the steady-state and transient input files differ in several ways. The largest change across all files is the removal of initial conditions (ICs); each transient file restarts from the already-resolved steady state, so ICs are unnecessary. Additionally, all transient files except Bison switch the executioner from IterationAdaptiveDT to FunctionDT paired with a shared timestep function, so that every app in the multiapp hierarchy advances on the same schedule and transfers stay synchronized. The fuel performance evaluation code, as a child application rather than a parent, only needs to resolve internally between the steps its parent gives it, so its timestepper is left unchanged.

### PKE Neutronics Solver (Griffin)

The steady-state file ramps up timestep size as it progresses; the transient file starts from a much larger timestep, since it begins from the already-converged steady state rather than from scratch. Fuel and moderator temperatures are constants in the steady-state reactivity feedback, replaced by live coupled feedback, 'T_fuelCompact_avg', and 'T_mod_avg', in the transient. All postprocessors in the transient file have 'force_preaux' set to true, moving their execution before AuxKernels so dependent AuxKernels don't read stale values. The transient file also adds postprocessors that play no part in steady state, decay power and power step.

### 3D Mesh PKE Coupling (Proxy)

The transient file for the 3D mesh PKE coupling adds a console output block that limits postprocessor/scalar output to the final interval of each timestep, purely for performance.

### Thermal Hydraulic Mesh Generator and Solver (Pronghorn)

In the transient, constant boundary temperature and inlet conditions are turned into time-dependent functions. This enables the Loss of Forced Cooling (LOFC) event: ramping the inlet mass flow rate to zero over time isn't possible with constants. The 'scaling = 1.0e-3' parameter present in the 'energy_storage' block of the steady-state file is absent in the transient file. This factor increases changes in temperature and time, which speeds up steady state convergence, but would decrease transient temperature accuracy. As a result, this factor is removed from the transient input.

### Fuel Rod Performance Evaluator (BISON)

No changes are seen here beyond the general pattern: it restarts from the steady state, drops its initial conditions, and extends the simulation time to match the full transient window.

## Transient vs. Null Transient

A null transient can be achieved with very few modifications when starting from the transient. In 'C02_Pronghorn.i', locate the 'Functions' block, and simply edit the piecewise function in 'mfr_fun' to hold steady at a constant. An example to set a null transient is below.

```language=CPP
 [Functions]
  [mfr_fun]
    type = PiecewiseLinear
    x = '-1000'
    y = '${mdot}'
  []
```

The unaltered block is below. '${mdot}' is a constant inlet mass flow rate defined at the top of the code, in this case 11.5582. In the transient, this flow rate ramps down to 0, a complete loss of forced coolant, as the accident name implies. The -1000 in the x value seen below is used in the transient to begin from the steady state scenario to ensure proper modeling.

!listing htgr/httr/lofc_transient/case/C02_Pronghorn.i block=Functions/mfr_fun

## Files

### Cross-Section and Decay-Library Files id=xsdt

The Xenon decay transmutation and cross section benchmark libraries, `XE135_Benchmark_DT.xml` and `XE135_Benchmark_XS.xml`, are located in the [supporting files directory](https://github.com/idaholab/virtual_test_bed/tree/devel/htgr/httr/lofc_transient/supporting_files).

### Mesh Files

The tracked proxy mesh, `ProxyMesh.e`, is located in the [supporting-files directory](https://github.com/idaholab/virtual_test_bed/tree/devel/htgr/httr/lofc_transient/supporting_files). The fuel-pin mesh, `compact_mesh_in.e`, is generated locally from `compact_mesh.i` and is intentionally not tracked.

### Input Files

Nine of the ten simulation input files are located in the [case directory](https://github.com/idaholab/virtual_test_bed/tree/devel/htgr/httr/lofc_transient/case).

The remaining input file, `compact_mesh.i`, generates the fuel-pin mesh and is located in the [supporting files directory](https://github.com/idaholab/virtual_test_bed/tree/devel/htgr/httr/lofc_transient/supporting_files).

#### Steady-State Model Input Files

The steady-state inputs are `A01a_Griffin_initial.i`, `A01b_Griffin.i`, `B01_Proxy.i`, `C01_Pronghorn.i`, `compact_mesh.i`, and `D01_Bison.i`.

#### Transient Model Input Files

The transient inputs are `A02b_Griffin.i`, `B02_Proxy.i`, `C02_Pronghorn.i`, and `D02_Bison.i`.

## Running the Simulation id=rts

To apply for access to Bluecrab and access to INL High Performance Computing, please visit [NCRC](https://ncrcaims.inl.gov/).
These inputs can be run on your local machine or on a computing cluster, depending on your level of access to the simulation
software and the computing power available to you.

### Idaho National Laboratory HPC

With at least level 1 access to BlueCrab, load the application module and first generate the fuel-pin mesh:

```language=CPP
module load use.moose moose-apps bluecrab

cd htgr/httr/lofc_transient/supporting_files
blue_crab-opt -i compact_mesh.i --mesh-only compact_mesh_in.e
cd ../case
```

Next, run the Griffin initialization calculation:

```language=CPP

mpirun -n 6 blue_crab-opt -i A01a_Griffin_initial.i
```

After this input finishes, inspect `results/A01a.csv`. Compare its steady-state values with those defined at the top of `A01b_Griffin.i` and update any values that do not match. After completing this initialization, run the coupled steady-state input:

```language=CPP
mpirun -n 6 blue_crab-opt -i A01b_Griffin.i
```

After the steady-state calculation finishes, inspect `results/A01b.csv`. Compare its steady-state values with those defined at the top of `A02b_Griffin.i` and update any values that do not match. Then run the transient. The transient takes approximately 90 minutes on 56 cores, so account for the required computational resources.

```language=CPP
mpirun -n 56 blue_crab-opt -i A02b_Griffin.i
```

### Local Device

With level 2 access to the binaries, install BlueCrab through Conda and activate its environment:

```language=CPP
conda activate bluecrab
```

Use the same mesh-generation, initialization, steady-state, and transient commands shown above. Because of the transient's computational requirements, running it on a local workstation is not recommended.

## Results

Running the transient produces `results/A02b.csv`, which contains the quantities requested by the `Outputs` blocks in `A02b_Griffin.i`. The coupled applications also generate `LOFC2.csv`, `proxy.csv`, and `A02b_Griffin_out_Mat_1_number_densities.csv`. Selected results from the unmodified inputs are shown below.

!media media/htgr/httr/transient/Results.png
    style=width:70%
    id=F16
    caption=Five plots were generated using data from the loss-of-forced-cooling transient run with `A02b_Griffin.i`. Graph 1 is scaled by the amount of uranium in HTTR. The I:Xe ratio is unchanged.

The simulation captures a rapid and permanent loss of forced coolant flow and the subsequent approximately 18-hour response. Inlet and outlet mass-flow rates ramp to zero within roughly 125 s (Graph 4). Total power drops from approximately $10^7$ W to a quasi-steady $10^5$ W within seconds, while fission power drops to roughly 1 W (Graph 5). The difference is decay heat: fission has essentially stopped, but fission-product decay continues to produce heat.

Over the next approximately 40,000 s, I-135 decays into Xe-135, causing the Xe-135 concentration to peak around 20,000–25,000 s before falling as the iodine inventory is depleted (Graph 1). This buildup and decay drives the xenon-reactivity curve, which reaches its minimum as the Xe-135 concentration peaks and then recovers as Xe-135 is removed (Graph 2). Fuel and fuel-block temperatures decrease over the same period; the moderator temperature changes more gradually (Graph 3).

Around 40,000–45,000 s, enough Xe-135 has been removed for positive reactivity to return, and fission power begins increasing from approximately 1 W (Graph 5). Reactivity rises (Graph 2), temperatures begin increasing again (Graph 3), and the core approaches a new natural-circulation state.

## Relevance of the Model

This model supports analysis of loss-of-forced-cooling events, an important design-basis accident scenario for high-temperature gas-cooled reactors. Simulation can help engineers evaluate the reactor response and assess safety measures without modifying or testing an operating reactor.

## Citing and Credits

If using or modifying this model, please cite:

1.
Epiney, A., Strydom, G., Kile, R., Tano Retamales, M., Yoon, S., Mueller, C., Gutowska, I., Zou, L., Hua, T., & Fang, J. (2022). Overview of HTTF Modeling and Benchmark Efforts for Code Validation for Gas-Cooled Reactor Applications. In Proc. 4th Int. Conf. Generation IV Small Reactors (G4SR-4) (pp. 3-6)

2.
Vincent Labouré, Javier Ortensi, Nicolas Martin, Paolo Balestra, Derek Gaston, Yinbin Miao, Gerhard Strydom, "Improved multiphysics model of the High Temperature Engineering Test Reactor for the simulation of loss-of-forced-cooling experiments", Annals of Nuclear Energy, Volume 189, 2023, 109838, ISSN 0306-4549, https://doi.org/10.1016/j.anucene.2023.109838. (https://www.sciencedirect.com/science/article/pii/S0306454923001573)

3.
Vincent M Laboure, Matilda A Lindell, Javier Ortensi, Gerhard Strydom and Paolo Balestra, "FY22 Status Report on the ART-GCR CMVB and CNWG International Collaborations." INL/RPT-22-68891-Rev000 Web. doi:10.2172/1893099.

4.
Yusuke Fujiwara, Minoru Goto, Kazuhiko Iigaki, Tatsuo Iyoku, Hai Quan Ho, Taiki Kawamoto, Makoto Kondo, Kazuhiko Kunitomi, Keisuke Morita, Satoru Nagasumi, Shigeaki Nakagawa, Tetsuo Nishihara, Naoki Nojiri, Masato Ono, Akio Saikusa, Nariaki Sakaba, Taiju Shibata, Yosuke Shimazaki, Atsushi Shimizu, Masayuki Shinozaki, Junya Sumita, Yukio Tachibana, Shoji Takada, Daisuke Tochio, Takahiro Uesaka, Shohei Ueta, "2 - Design of High Temperature Engineering Test Reactor (HTTR)", High Temperature Gas-Cooled Reactors, Volume 5, 2021, Pages 17-177, ISBN 978-0-12-821031-4, https://doi.org/10.1016/B978-0-12-821031-4.00002-6. (https://www.sciencedirect.com/science/article/pii/B9780128210314000026)

Documentation written by Ben Pillsbury.

