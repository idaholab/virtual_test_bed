# Creation of infiltration profiles

Given that the pore sizes in nuclear graphite material are several orders of magnitude smaller than the actual component, resolving the pore structure is impractical. Therefore, the graphite component is modeled as a continuum. Within this constraint, initializing the infiltration profile is not straightforward. To address this, a diffusion equation, similar to a porous flow model, is employed to establish a physically realistic infiltration profile before proceeding with the stress analysis.

## Computational Model Description

[Mesh] shows the mesh of the unit cell of the MSRE graphite stringer. 

!media msr/graphite_model/infiltration/2_mesh.png
      id=Mesh
      style=width:50%
      caption= Finite element mesh of the 2D unit cell of the graphite stringer.

Files used by this model include:

- MOOSE input file
- Exodus mesh file

This document reviews the basic elements of the input file, listed in full here:

!listing msr/graphite_model/infiltration/1_create_infiltration_profile/2D/2D_CreateInfiltrationProfile.i


### `Global Variables`

These are input parameters defined in the global scope, so they could be accessed by any object within the MOOSE input file. These streamline the workflows.

```
# The diffusion field profile is smooth and continuous, but for this problem
# we need a binary field (infiltrated vs. no infiltration), mimicking the physical behavior.
# The threshold value converts the continuous field to a binary field.

threshold = 0.8 

# vol_frac_threshold represents the infiltration volume fraction 
vol_frac_threshold=0.30

#Diffusivity constant
diffusivity = 1e-3
```

### `Mesh`

This block defines the finite element mesh that will be used. In this case, the mesh is read from a file in the Exodus (.e) format. The mesh for this particular problem was created using Cubit.

!listing msr/graphite_model/infiltration/1_create_infiltration_profile/2D/2D_CreateInfiltrationProfile.i block=Mesh

### `Variables`

This block defines the field variables that will be solved for in the nonlinear equation system. In this model, the only variable defined in this step.

!listing msr/graphite_model/infiltration/1_create_infiltration_profile/2D/2D_CreateInfiltrationProfile.i block=Variables

### `AuxVariables`

This block defines AuxVariables (i.e., auxiliary variables), which are field variables that are not part of the system of equations being solved. In this case, it is a binary variable, obtained by penalizing the diffused variable

!listing msr/graphite_model/infiltration/1_create_infiltration_profile/2D/2D_CreateInfiltrationProfile.i  block=AuxVariables


### `Kernels`

This block defines the terms in the partial differential equations for the physics being modeled. In this case, the transient diffusion equation consisting of the time derivative term and the Laplacian terms are defined.

!listing msr/graphite_model/infiltration/1_create_infiltration_profile/2D/2D_CreateInfiltrationProfile.i  block=Kernels

### `AuxKernels`

This block defines the models that compute the values stored in the AuxVariables that were previously defined. In this case, these are objects that binarizes the diffused variable.

!listing msr/graphite_model/infiltration/1_create_infiltration_profile/2D/2D_CreateInfiltrationProfile.i  block=AuxKernels

### `UserObjects`

This block defines the custom objects that perform specific tasks within the MOOSE framework. In this case, we use the Terminator userobject to stop the simulation after the infiltration amount reaches the user input, vol_frac_threshold.

!listing msr/graphite_model/infiltration/1_create_infiltration_profile/2D/2D_CreateInfiltrationProfile.i block=UserObjects

### `Postprocessors`

 This block is used to defined to calculate specific items of interest to the user. In this case, the infiltration amount is calculated and printed in the `Outputs` CSV file.

!listing msr/graphite_model/infiltration/1_create_infiltration_profile/2D/2D_CreateInfiltrationProfile.i  block=Postprocessors

### `BCs`

The boundary conditions are defined in this block. For this case, the salt-facing graphite channel is prescribed with a Dirichlet BC for the diffused variable to be unity. The rest of the surfaces will automatically be assigned as Neumann BCs, meaning the flux will be zero.

!listing msr/graphite_model/infiltration/1_create_infiltration_profile/2D/2D_CreateInfiltrationProfile.i  block=BCs

### `Executioner`

The parameters in this block control the solution strategy used, convergence tolerances, time increment and end time, and other relevant settings.

!listing msr/graphite_model/infiltration/1_create_infiltration_profile/2D/2D_CreateInfiltrationProfile.i block=Executioner

### `Outputs`

This block defines the types of output that are generated. The CSV output prints the amount of infiltration at various time steps. The Exodus output is primarily used for inspection of the results.

!listing msr/graphite_model/infiltration/1_create_infiltration_profile/2D/2D_CreateInfiltrationProfile.i block=Outputs

## Running the model

To run this model using the MOOSE executable with the combined module, use the following command:

```
mpiexec -n 8 /path/to/app/combined-opt -i 2D_CreateInfiltrationProfile.i
```

The following output files will be produced:

- The Exodus results file: `2D_CreateInfiltrationProfile_exodus.e`
- The CSV results file: `2D_CreateInfiltrationProfile_csv.csv`

The Exodus output file can be visualized with Paraview.

