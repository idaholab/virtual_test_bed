# Simulations with a groove profile

Realistic surface wear profiles are inherently complex, and obtaining such data from the public domain can be challenging. In this study, these defects are idealized as grooves, as illustrated in the accompanying [groove].

!media msr/graphite_model/wear/7_groove.png
      id=groove
      style=width:50%
      caption= Schematic illustrating the wear profile idealized as a groove on the surface of the reflector block.

## Computational Model Description

[refmesh] shows the refined mesh for the reflector block. The mesh is finely refined at the center to capture the stress concentrations due to the groove.

!media msr/graphite_model/wear/8_refmesh.png
      id=refmesh
      style=width:40%
      caption= Refined mesh of a reflector block.

!listing msr/graphite_model/wear/groove/Groove_R0P025.i

The model setup adheres closely to the input file description provided in the [Baseline simulation with combined thermal and radiation effects](baseline.md). The additional steps involve the initialization of the groove and the configuration of the elasticity tensor, which are detailed below.

### Initialization of the groove profile

In structural analysis, a groove acts as a stress concentrator. Assigning appropriate elastic properties to the groove is crucial for accurately capturing this effect. In this model, the groove is not explicitly represented. Instead, near-zero elastic properties are assigned to the groove region. This approach ensures that the stress concentration effects are appropriately accounted for without the need for detailed groove geometry.

The following block defines a variable `eta` which is 1 within the groove and 0 elsewhere, with a smooth transition between these regions.

!listing msr/graphite_model/wear/groove/Groove_R0P025.i block=ICs

### Configuration of the elasticity tensor

The following blocks define the material properties and elasticity tensors based on the variable `eta`.

```
[h_void]
    type = SwitchingFunctionMaterial
    eta = eta
    h_order = HIGH
    function_name = h_void
    output_properties = 'h_void'
    outputs = exodus
[]

[h_mat]
  type = DerivativeParsedMaterial
  expression = '1-h_void'
  coupled_variables = 'eta'
  property_name = h_mat
  material_property_names = 'h_void'
  outputs = exodus
[]

  [elastic_tensor_matrix]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 10.3e9
    poissons_ratio = 0.14
    base_name = Cijkl_matrix
  []

  [elastic_tensor_void]
    type = ComputeIsotropicElasticityTensor
    youngs_modulus = 1e-3
    poissons_ratio = 1e-3
    base_name = Cijkl_void
  []

  [elasticity_tensor]
    type = CompositeElasticityTensor
    tensors = 'Cijkl_matrix Cijkl_void'
    weights = 'h_mat            h_void'
    coupled_variables = 'eta'
  []

```

The `h_void` block defines a switching function material for `eta`, producing the property `h_void`. The `h_mat` block calculates the complementary property `h_mat` as `1 - h_void`. The `elastic_tensor_matrix` block defines the elasticity tensor for the matrix material with a specified Young's modulus and Poisson's ratio. The `elastic_tensor_void` block defines the elasticity tensor for the void (groove) with very low elastic properties. Finally, the `elasticity_tensor` block creates a composite elasticity tensor by combining matrix and void properties, weighted by `h_mat` and `h_void`, respectively.

## Running the model

To run this model using the Grizzly executable, run the following command:

```
mpiexec -n 300 /path/to/app/grizzly-opt -i Groove_R0P025.i
```

*Note: HPC resources were used to perform this simulation*

The following Exodus results file will be produced: `Groove_R0P025_exodus.e`

The Exodus output file can be visualized with Paraview.
