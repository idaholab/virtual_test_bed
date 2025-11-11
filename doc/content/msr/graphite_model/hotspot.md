# Hotspot analysis

In the previous analysis, the effect of pores was accounted for in a homogenized manner by scaling the power density. Larger pores may arise due to manufacturing processes, and understanding how these larger, infiltrated pores, along with the infiltrated pore network, manifest into stress is crucial. This page provides a framework to set up simulations with hotspots, aiming to evaluate the critical size of a pore that could lead to high stress values.

## Computational Model Description

This section outlines the setup and execution of hotspot analysis using a 2D MSRE (Molten Salt Reactor Experiment) stringer geometry.

Files used by this model include:

- MOOSE input file
- Exodus reference solution file for initializing the infiltration amount
- Mesh input file

This document reviews the important elements of the input file, listed in full here:

!listing msr/graphite_model/infiltration/5_hotspot_analysis_2D/hotspotanalysis_2D.i

### Setting up the hotspot

The center and the radius of the hotspot are provided as inputs:

```
x0 = 0.0072
y0 = 0.0072

R = 1e-3
```

The hotspot is initialized through an auxiliary variable using a parsed function. The auxiliary variable `hotspot_var` is defined with constant order and monomial family. The parsed function `heatsource_hotspot_fn` calculates the distance from the center of the hotspot and assigns a power density value if the distance is within the hotspot radius. This function is then applied to the auxiliary variable through the hotspot `AuxKernel`. This setup ensures that the hotspot is correctly initialized and applied within the simulation.

!listing msr/graphite_model/infiltration/5_hotspot_analysis_2D/hotspotanalysis_2D.i block=hotspot_var hotspot heatsource_hotspot_fn

The heat generation from the hotspot is incorporated within the `Kernels` section using the `heat_source_hotspot` kernel. This kernel applies the parsed function `heatsource_hotspot_fn` to account for the localized heat generation due to the hotspot.

### Setting up the hotspot as a pore

In structural analysis, a pore acts as a significant stress concentrator. It is crucial to assign appropriate elastic properties to the pore to accurately capture this effect. In this model, we do not explicitly represent the pore. Instead, we assign near-zero elastic properties to the hotspot region. This approach ensures that the stress concentration effects are appropriately accounted for without the need for detailed pore geometry.

The following block defines a variable eta which is 1 within the pore/hotspot and 0 elsewhere, with a smooth transition between these regions.

!listing msr/graphite_model/infiltration/5_hotspot_analysis_2D/hotspotanalysis_2D.i block=ICs

The following blocks define the material properties and elasticity tensors based on the variable `eta`.

!listing msr/graphite_model/infiltration/5_hotspot_analysis_2D/hotspotanalysis_2D.i block=Materials

The `h_void` block defines a switching function material for `eta`, producing the property `h_void`. The `h_mat` block calculates the complementary property `h_mat` as `1 - h_void`. The `elastic_tensor_matrix` block defines the elasticity tensor for the matrix material with a specified Young's modulus and Poisson's ratio. The `elastic_tensor_void` block defines the elasticity tensor for the void with very low elastic properties. Finally, the `elasticity_tensor` block creates a composite elasticity tensor by combining matrix and void properties, weighted by `h_mat` and `h_void`, respectively.

## Running the model

To run this model using the MOOSE combined executable, run the following command:

```
mpiexec -n 8 /path/to/app/combined-opt -i hotspotanalysis_2D.i
```

The following output file will be produced:

- The Exodus results file: `hotspotanalysis_2D_out.e`

The Exodus output file can be visualized with Paraview.
