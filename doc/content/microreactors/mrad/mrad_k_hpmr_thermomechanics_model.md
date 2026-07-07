# K-HPMR Multiphysics Neutronics-Thermomechanics-Heat Pipe Model

*Contact: Soon Kyu Lee (soon.lee.at.anl.gov), Yinbin Miao (ymiao.at.anl.gov)*

*Model link: [HPMR Model](https://github.com/idaholab/virtual_test_bed/tree/main/microreactors/mrad)*

!tag name=MRAD Micro-Reactor Multiphysics Thermomechanical model
     description=A core multiphysics model coupling neutronics, thermomechanics, and heat pipe thermal performance for steady state and transient simulations
     image=https://mooseframework.inl.gov/virtual_test_bed/media/mrad/hpmr_mesh_proc.png
     pairs=reactor_type:microreactor
           reactor:HPMR
           geometry:core
           simulation_type:multiphysics
           V_and_V:demonstration
           input_features:multiapps;reactor_meshing;mixed_restart
           transient:steady_state;load_follow
           codes_used:BlueCrab;Griffin;BISON;Sockeye
           computing_needs:HPC
           fiscal_year:2026
           sponsor:NEAMS
           institution:ANL

## Inheritance from K-HPMR Model

!alert note title=Acknowledgement
This model is a thermomechanical extension of the K-HPMR multiphysics model. Please refer to the [K-HPMR Multiphysics Model](mrad/mrad_model.md) for additional description of the model.

The neutronics-thermomechanics-heat pipe model extends the multiphysics (neutronics-thermal-heat pipe) model described in the [K-HPMR Multiphysics Model](mrad/mrad_model.md) by incorporating solid mechanics into the BISON application (previously only solving for temperature). The HPMR model was originally developed in FY21 [!citep](Stauff2021Detailed), and the thermal-only multiphysics model referenced above was further developed, with a preliminary thermomechanical model implemented in FY24 [!citep](Miao2025) using simplified stress boundary conditions on the symmetry planes; see these references for additional details on the underlying thermal models. This treatment is enhanced here to correctly impose mirror (reflective) pressure boundary conditions, as described in the Stress Boundary Conditions section below. Thermally induced deformations of the reactor core materials are computed by BISON alongside the thermal solution, and the resulting displacement fields are transferred to Griffin to update the neutron transport calculation on the displaced mesh. This coupling allows the model to account for dimensional deformations in the fuel compacts, moderator, monolith, and reflector materials — and their consequent effect on reactivity — under realistic operating conditions.

The cross-section library, Griffin neutronics model, Sockeye heat pipe model, mesh generation workflow, and MultiApps hierarchy are all directly inherited from the K-HPMR model. This document focuses on the modifications and additions to the BISON model that are relevant to a thermomechanical extension.

## Model Update for Thermomechanics

The BISON application is extended to solve for four coupled fields across the 1/6 core: the temperature field `temp` and three displacement components `disp_x`, `disp_y`, and `disp_z`. To accommodate the solution of thermal and mechanical equations, BISON uses a `ReferenceResidualProblem` formulation that groups the displacement variables together and applies a reference residual vector to drive convergence, balancing the scale disparity between thermal and mechanical residuals.

### Thermal and Stress Boundary Conditions

#### Thermal Boundary Conditions

The thermal boundary conditions are unchanged from the K-HPMR thermal-only model. As in the thermal-only model, the heat conduction equation solved at each time step is the steady-state form, so each transient time step represents a sequence of quasi-static thermal states rather than a dynamic thermal response. A convective boundary condition is imposed on the outer peripheral, top, and bottom surfaces of the 1/6 core model using a constant heat transfer coefficient and an ambient temperature of 800 K. The heat pipe surfaces serve as the primary heat sink and are treated using a coupled convective heat flux boundary condition, where the heat pipe surface condition is applied at the heat pipe interface supplied by the Sockeye application.

#### Stress Boundary Conditions

Stress boundary conditions are imposed to reflect the geometric symmetry constraints of the 1/6 core model and to prevent rigid body motion of the mechanical solution. Three types of mechanical boundary conditions are applied to the displacement degrees of freedom.

The first set constrains the normal displacement to zero on the flat symmetry planes of the 1/6 core using Dirichlet boundary conditions. Specifically, `disp_x` is fixed to zero on the `side_y` boundary (the flat symmetry face aligned with the y-axis) and on the `centerline` boundary, while `disp_y` is fixed to zero on the `centerline` boundary alone. Axial displacement is fixed to zero on the reactor bottom surface (sideset 3000), preventing rigid-body motion in the z-direction while allowing free thermal expansion upward.

The second set handles the 60° angled symmetry plane of the 1/6 core (the `side_xy` boundary). Because this boundary is inclined rather than axis-aligned, a zero-normal-displacement condition cannot be imposed using a simple Dirichlet constraint on a single component to mirror the pressure boundary conditions. Instead, an `InclinedNoDisplacementBC` with a penalty parameter of $10^{10}$ is applied to all three displacement components on this boundary, enforcing that displacement normal to the inclined plane is zero.

!listing /microreactors/mrad/steady_K_SM/K-HPMR_BISON.i block=BCs language=text max-height=200px

### Solid Mechanics Models

The solid mechanics action is activated for all structurally active inner reactor material blocks: fuel compacts, graphite monolith, YH moderator, stainless steel moderator cladding, and the axial reflectors. The mechanical solution is quasistatic - the momentum balance neglects inertial effects, so the model captures thermally induced deformation but not dynamic or vibrational response. Material-specific thermal expansion eigenstrains are computed for each inner assembly block. For the fuel compact blocks, the `GraphiteMatrixThermalExpansionEigenstrain` model is used to capture the thermal expansion behavior of the TRISO-loaded graphite matrix. For the graphite monolith blocks, the `GraphiteGradeThermalExpansionEigenstrain` model is applied using grade G-348 properties, reflecting the distinct graphite grade used for the structural monolith relative to the fuel matrix. For the YH moderator blocks, a constant isotropic thermal expansion coefficient is assigned on the `ComputeThermalExpansionEigenstrain` model. The stainless steel moderator cladding uses the `SS316ThermalExpansionEigenstrain`, and the inner axial reflectors use the `BeOThermalExpansionEigenstrain` model.

Material-specific elasticity tensors are similarly assigned to each inner assembly block. The fuel and monolith blocks are treated with isotropic elasticity tensors using a Young's modulus of 10 GPa and a Poisson's ratio of 0.25. The SS316 moderator cladding uses the temperature-dependent `SS316ElasticityTensor` with the ORNL elastic constants model. The YH moderator uses an isotropic elasticity tensor with a Young's modulus of 20 GPa and a Poisson's ratio of 0.3. The inner BeO reflector blocks use the `BeOElasticityTensor`, which provides temperature-dependent elastic properties for beryllium oxide.

!listing /microreactors/mrad/steady_K_SM/K-HPMR_BISON.i block=Physics/SolidMechanics/QuasiStatic language=text max-height=200px

#### Displacement Diffusion for Outer and Heat Pipe Blocks

The outer blocks - consisting of the outer BeO reflectors, B4C poison blocks, central gas gap blocks, and outer shield — as well as the heat pipe placeholder blocks, are not assigned solid mechanics models to reduce computational cost, as regions of interest are near the fuel compacts. However, the displacement variables must remain defined and seamlessly connected across the entire mesh to avoid numerical artifacts at block interfaces, ensuring convergence in neutronic calculations. To achieve seamless mesh continuity, a `MatDiffusion` kernel with an isotropic diffusivity is applied to each of the three displacement components across the outer and heat pipe block regions. This smoothly propagates the displacement solution from the mechanically active inner assembly into the surrounding regions without introducing artificial mechanical stiffness, ensuring continuity of the displacement field across the full domain. 

!listing /microreactors/mrad/steady_K_SM/K-HPMR_BISON.i block=Kernels language=text max-height=200px

### Transfer of Displacement Data to Griffin

A key addition of the thermomechanical model relative to the thermal-only model is the transfer of computed displacement fields from BISON to Griffin, enabling the neutron transport calculation to be performed on the thermally deformed geometry. Within BISON, the displacement solution variables `disp_x`, `disp_y`, and `disp_z` are copied into auxiliary transfer variables `disp_x_trans` and `disp_y_trans` at each nonlinear iteration via `NormalizationAux` kernels. The base copy is executed on `NONLINEAR` rather than `TIMESTEP_END` to guarantee it runs before the subsequent inclined-boundary correction, since AuxKernels in the same execution group are not otherwise ordered relative to one another. A geometric correction is then applied at the end of each time step on the inclined `side_xy` symmetry boundary. Because the 1/6 core is bounded by a symmetry plane at 60° from the x-axis, the x-component of displacement on this plane must be corrected to be consistent with the `InclinedNoDisplacementBC` constraint.

In the Griffin application, `disp_x`, `disp_y`, and `disp_z` are declared as auxiliary variables and populated by `MultiAppGeneralFieldShapeEvaluationTransfer` objects receiving `disp_x_trans`, `disp_y_trans`, and `disp_z` from BISON. The DFEM-SN transport solver in Griffin is then configured with `use_displaced_mesh = true`, instructing it to evaluate the neutron transport equation on the mesh as deformed by the transferred displacement field. This captures the first-order effect of thermal expansion on $k_\text{eff}$ and the neutron flux distribution as material positions shift under the thermal loading.

!listing /microreactors/mrad/steady_K_SM/K-HPMR_GRIFFIN.i block=Transfers language=text max-height=200px

## Steady-State Case Simulation

The steady-state simulation establishes the nominal operating condition of the K-HPMR thermomechanical model, like the counterpart simulation of the thermal-only model, including the thermally deformed core geometry that results from full-power operation. This solution also provides the initial condition for subsequent transient analyses.

## Load Following Transient Simulation

The load following transient is driven by a sharp degradation in the secondary-loop heat removal system [!citep](stauff2022multiphysics,stauff2023multiphysics), implemented by modifying the condenser envelope boundary condition in the Sockeye model, reducing the convective heat transfer coefficient by 99.99%, thereby eliminating heat extraction from the secondary loop. The resulting rise in condenser temperature propagates through the coupled BISON thermomechanical model, elevating the core temperatures and reducing reactor power through negative reactivity feedback in Griffin. Beyond what was captured in thermal-only model, the thermomechanical model additionally tracks the evolution of core mechanical deformation as local temperature field fluctuates throughout the transient.
