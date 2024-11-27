# Light-Water Reactor Pressure Vessel Model: 3D Thermomechanical Model

*Contact: Ben Spencer, benjamin.spencer@inl.gov*

*Model was co-developed by Ben Spencer and Will Hoffman

*Model link: [Grizzly RPV PFM Model](https://github.com/idaholab/virtual_test_bed/tree/main/lwr/rpv_fracture)*

## High Level Summary of Model

The core of a light water reactor (LWR) is contained within a reactor pressure vessel (RPV), which is the key component of the primary pressure-containing system in such reactors. Ensuring the integrity of the RPV during a variety of operating conditions is essential for the safe operation of a LWR. A major failure mode of concern for RPVs is the propagation of brittle fracture, initiating at flaws introduced during the manufacturing process. RPVs are generally at the highest risk of such failures during off-normal transient events, such as rapid cooling during reactor re-flooding due to a loss of coolant accident, which could result in a phenomenon known as pressurized thermal shock (PTS). Susceptibility to fracture during PTS conditions increases with age of the RPV because long-term irradiation makes the steel from which RPVs are constructed more brittle.

One of the key quantitities of interest in evaluating the resilience of an RPV under PTS conditions is the conditional probability of fracture initiation (CPI), which is evaluated by using a Monte Carlo method to assess the probability of fracture for each flaw in a set of randomly sampled, physically realistic flaw populations. This process is known as probabilistic fracture mechanics (PFM). There are a number of simulation tools available for this purpose, which follow similar procedures [!cite](qian_procedures_2013). There are two major stages to a PFM simulation. In the first stage, the thermomechanical response of the RPV to a postulated transient event is computed, without considering the effects of flaws. In the second stage, random realizations of potential flaw populations are generated and fracture mechanics calculations are performed on each flaw in those populations to compute an overall CPI for the RPV.

Grizzly is a MOOSE-based simulation code for simulating nuclear reactor component integrity, and includes capabilities for RPV PFM, as described in [!cite](spencer_modular_2019).  Grizzly's PFM algoritms are largely based on those of FAVPRO [!cite](favpro_v1.0_2024), which represents the thermomechanical response of the RPV in 1D. One of the major benefits of Grizzly is that it permits the RPV to be represented in 1D, 2D, or 3D, as shown in [GlobalRPV]. This allows for dimensionality appropriate for the problem of interest to be used, and allows Grizzly to address the effects of spatially non-uniform behavior, such as the accelerated cooling that can occur in the vicinity of an inlet in a pressurized water reactor (PWR) [!cite](spencer_grizzly_2021).

The first stage of RPV simulations in Grizzly is an analysis of the global thermal/mechanical response under the transient of interest. This example demonstrates the process of setting up and running models for the thermomechanical response of an RPV. A three-dimensional (3D) model is employed in this case to demonstrate the most general case. However, similar models can be used to represent the RPV in 1D or 2D, as shown in [GlobalRPV].  The results of this simulation are used as inputs for a [PFM simulation](rpv_pfm_3d.md), which is the second stage of this example.

!media lwr/rpv_fracture/GlobalRPV.png
      id=GlobalRPV
      style=width:60%
      caption=1D, 2D, and 3D Grizzly models of the global RPV response.


## Computational Model Description

This model uses quarter symmetry to represent the coupled thermal/mecahnical response of an RPV subjected to transient loading.  The geometry and loading conditions are representative of those that would be observed in an actual PWR RPV.  [rpv_mesh] shows the mesh of this quarter-symmetry model, which includes an inlet and outlet, and represents the entire RPV quadrant.

!media lwr/rpv_fracture/rpv_mesh.png
      id=rpv_mesh
      style=width:40%
      caption=3D Mesh of RPV used for this case, shown from the interior (left) and exterior (right)

Files used by this model include:

- MOOSE input file
- Exodus mesh file
- CSV (comma-separated value) file defining the time history of the pressure
- CSV file defining the time history of the coolant temperature
- CSV file defining the time history of the heat transfer coefficient

This document reviews the basic elements of the input file, listed in full here:

!listing /lwr/rpv_fracture/thermomechanical/rpv_thermomechanical_3d.i

### `GlobalParams`

This block contains parameters that are applied automatically in any context where they are applicable in the rest of the model. A few important things are defined here:

- The `ORDER` and `FAMILY` parameters are used to define the interpolation order and type of interpolation, and are used for multiple types of variables.  The parameters here give 1st order variables, which are appropriate for the linear eight-noded hexahedral elements used in the mesh.
- The `displacements` parameter defines the set of displacement variables, which is used in multiple mechanics models.

!listing /lwr/rpv_fracture/thermomechanical/rpv_thermomechanical_3d.i block=GlobalParams

### `Mesh`

This block defines the finite element mesh that will be used. In this case, the mesh is read from a file in the Exodus (.e) format. The mesh for this particular problem was created using Cubit.

!listing /lwr/rpv_fracture/thermomechanical/rpv_thermomechanical_3d.i block=Mesh

### `Problem`

This block is used to defined parameters for the [ReferenceResidualProblem](https://mooseframework.inl.gov/source/problems/ReferenceResidualProblem), which is defined to override the standard MOOSE convergence checks and ensure that the individual variables are converged relative to meaningful values. All parameters in this block in this example are specifically related to controlling those convergence checks.

!listing /lwr/rpv_fracture/thermomechanical/rpv_thermomechanical_3d.i block=Problem

### `Variables`

This block defines the field variables that will be solved for in the nonlinear equation system. In this model, the only variable defined in this step is the temperature.

- The temperature (`temp`) is set to have an initial condition equal to the coolant temperature during operation (in Kelvin).

The model also solves for the mechnical displacement fields, but these are set up automatically via the `Physics/SolidMechanics/QuasiStatic` block.

!listing /lwr/rpv_fracture/thermomechanical/rpv_thermomechanical_3d.i block=Variables

### `AuxVariables`

This block defines AuxVariables (i.e., auxiliary variables), which are field variables that are not part of the system of equations being solved. In this case, these are all for output of stress components. It should be noted that output for some of the stress component outputs is handled automatically in the `Physics/SolidMechanics/QuasiStatic` block, but the AuxVariables are manually created because special options are used to preserve the discontinuity in the stress between the base metal and cladding.

!listing /lwr/rpv_fracture/thermomechanical/rpv_thermomechanical_3d.i block=AuxVariables

### `Physics/SolidMechanics/QuasiStatic`

This block automates the process of setting up multiple objects related to solution of a mechanics problem. The objects set up by this block include the `Variables` and `Kernels` for the displacement solution, the `Material` that computes the strain, and objects associated with outputing stresses. In addition to simplifying the input, this ensures that a consistent set of options are selected for the desired formulation.

!listing /lwr/rpv_fracture/thermomechanical/rpv_thermomechanical_3d.i block=Physics/SolidMechanics/QuasiStatic

### `Kernels`

This block defines the terms in the partial differential equations for the physics being modeled. In this case, the temperature and displacements are being solved for, but only blocks applicable for the temperature variable appear here because those applicable to the mechanics solution are set up automatically by the `Physics/SolidMechanics/QuasiStatic` block.

!listing /lwr/rpv_fracture/thermomechanical/rpv_thermomechanical_3d.i block=Kernels

### `AuxKernels`

This block defines the models that compute the values stored in the AuxVariables that were previously defined. In this case, these are objects that extract components of the stress tensor and make them available as field variables.

!listing /lwr/rpv_fracture/thermomechanical/rpv_thermomechanical_3d.i block=AuxKernels

### `Functions`

This block defines functions, which are used to define various properties that can be a function of time and space, or a function of a variable like temperature.
These are all used elsewhere in the model, and are referred to by their names. Several types of functions are used here:

- A function called `time_steps` is used to define the time step size as a function of the solution time.
- Three functions are used to define the time history of the coolant pressure, coolant temperature, and heat transfer coefficient. These are all read in from external CSV files.  These functions were designed to loosely resemble a scenario in which a coolant valve is opened and closed during operation. Thus the transient begins with a rapid depressurization and cool down, followed by a period of repressurization and temperature increase. This transient was created as a demonstration only and does not represent actual expected reactor conditions.
- Functions are used to define the coefficient of thermal expansion, thermal conductivity, and specific heat of the steels used for the base metal and cladding. These functions are defined in terms of temperature and are used by material models that refer to them.

!listing /lwr/rpv_fracture/thermomechanical/rpv_thermomechanical_3d.i block=Functions

### `BCs`

As previously stated, this model uses quarter symmetry to minimize computational resources. Dirichlet boundary conditions fixing the x and y displacements on the appropriate symmetry planes are imposed. To prevent rigid-body translation, the z displacement is fixed at the bottom node of the model, which coincides with the axis of rotation.

The pressure and temperature boundary conditions are also applied in this block. The applied pressure acts on the displacement variables defined in the `Global Parameters` block, and a convective flux boundary condition acts on the temperature variable. These both rely on functions defined in the `Functions` block and are applied to the inner surface of the RPV.

!listing /lwr/rpv_fracture/thermomechanical/rpv_thermomechanical_3d.i block=BCs

### `Materials`

This block is used to define the thermal and mechanical properties for the base and cladding material. The thermal models use temperature-dependent functions for the thermal conductivity and specific heat, using functions defined in the `Functions` block.

The mechanical properties are also temperature-dependent. The temperature-dependent Young's modulus is defined using a generic material model that defines a property as a function of a variable, using a piecewise linear interpolation defined within the material block. The temperature-dependent thermal expansion is defined using a model that refers to a function defined in the `Functions` block.

!listing /lwr/rpv_fracture/thermomechanical/rpv_thermomechanical_3d.i block=Materials

### `Preconditioning`

This block is used to request that a full matrix with all coupling terms between variables be constructed. This provides a more efficient solution of this particular problem.

!listing /lwr/rpv_fracture/thermomechanical/rpv_thermomechanical_3d.i block=Preconditioning

### `Dampers`

This block is used to limit the change in the temperature solution during each nonlinear iteration, which improves the robustness of the solution by keeping the temperature within acceptable limits. Using a damper can result in a higher number of iterations in some steps when there are significant changes to the solution, but the robustness benefits outweigh the additional computational expense from the additional iterations.

!listing /lwr/rpv_fracture/thermomechanical/rpv_thermomechanical_3d.i block=Dampers

### `Executioner`

The parameters in this block control the solution strategy used, convergence tolerances, start and end time, and the use of a predictor, which accelerates convergence when loading is mostly monotonic in nature.

!listing /lwr/rpv_fracture/thermomechanical/rpv_thermomechanical_3d.i block=Executioner

### `LineSamplers`

This block defines a MOOSE Action that automates the process of setting up the line samplers, which sample values along lines through the cladding and base metal and fit those values to polynomial coefficients. These are used in the PFM simulation, which computes stress intensity factors for flaws at a variety of locations. For a 3D RPV model such as this, a grid of lines is set up spanning the region specified by the axial and azimuthal start and end points. Sampling is done along each line through the thickness of the RPV. The PFM calculation interpolates between those values.

!listing /lwr/rpv_fracture/thermomechanical/rpv_thermomechanical_3d.i block=LineSamplers

### `Outputs`

This block defines the types of output that are generated. It is essential to ask for CSV output in order to obtain the line samples, which are used in a subsequent PFM analysis. The Exodus output is primarily used for inspection of the results.

!listing /lwr/rpv_fracture/thermomechanical/rpv_thermomechanical_3d.i block=Outputs

## Running the model

To run this model using the Grizzly executable, run the following command:

```
mpiexec -n 16 /path/to/app/grizzly-opt -i rpv_thermomechanical_3d.i
```

This model is large and will take hours to run. The use of multiple processors is highly recommended for a model of this size, and the number of processors is specifed using the `-n` option in the `mpiexec` command. Using 36 processors it takes approximately 5 hours to run to completion. The following output files will be produced:

- The Exodus results file: `rpv_thermomechanical_3d_out.e`
- A set of CSV files with time histories of the stress coefficients for use in PFM analysis. These have names starting with `rpv_thermomechanical_3d_out_coefs_`.

The Exodus output file can be visualized with Paraview.
