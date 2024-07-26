# Fuel Performance Models

!alert note title=Acknowledgement
The modeling approach introduced here was developed based on the baseline [!ac](SFR) metallic fuel performance models in BISON, which are described in details in [!citep](Matthews2023Metal).

## Geometry and Mesh

The 2D-RZ meshes for the X447 pins are generated with the intrinsic rodlet meshing capability in BISON's [`FIPDRodletMeshGenerator`](https://mooseframework.inl.gov/bison/source/meshgenerators/FIPDRodletMeshGenerator.html). The mesh generator directly reads the pin design parameter CSV file and generates the mesh along with a series of `MeshMetaData` to help ensure consistent use of pin geometry data throughout the simulations. Lower-dimensional elements are then added to the fuel and cladding contact surface sidesets with [`LowerDBlockFromSidesetGenerator`](https://mooseframework.inl.gov/bison/source/meshgenerators/LowerDBlockFromSidesetGenerator.html), which is automated by the corresponding `Contact` Action used in this model. These additional side elements serve as contact surfaces for the Lagrange multiplier variables parameterizing mortar contact.

## Material and Behavioral Models

The following material and behavioral models for the +U-10Zr fuel+ are used in this VTB model. Note that [`Automatic differentiation`](https://mooseframework.inl.gov/automatic_differentiation/index.html) is used in this model, as indicated by the "AD" prefix.

| Fuel Performance Behavior | BISON Model | Description |
| :- | - | :- |
| Elasticity | [`ADUPuZrElasticityTensor`](https://mooseframework.inl.gov/bison/source/materials/solid_mechanics/UPuZrElasticityTensor.html) | Isotropic elastic mechanical properties for [!ac](SFR) metallic fuels |
| Creep Deformation | [`ADUPuZrCreepUpdate`](https://mooseframework.inl.gov/bison/source/materials/solid_mechanics/UPuZrCreepUpdate.html) | Creep correlation of [!ac](SFR) metallic fuels |
| Fission Gas Swelling | [`ADSimpleFissionGasViscoplasticityStressUpdate`](https://mooseframework.inl.gov/bison/source/materials/solid_mechanics/SimpleFissionGasViscoplasticityStressUpdate.html) | Calculates the change in volume due to gaseous fission product production in [!ac](SFR) metallic fuels |
| Solid Fission Product Swelling | [`ADBurnupDependentEigenstrain`](https://mooseframework.inl.gov/bison/source/materials/solid_mechanics/BurnupDependentEigenstrain.html) | Calculates the change in volume due to solid fission product production in [!ac](SFR) metallic fuels |
| Fission Density Rate | [`ADUPuZrFissionRate`](https://mooseframework.inl.gov/bison/source/materials/UPuZrFissionRate.html) | Computes fission density rate based on linear power, axial power profile, fuel geometry, and Pu/Zr concentrations |
| Burnup | [`ADUPuZrBurnup`](https://mooseframework.inl.gov/bison/source/materials/UPuZrBurnup.html) | Computes the burnup for [!ac](SFR) metallic fuels |
| Specific Heat/Thermal Conductivity | [`ADUPuZrThermal`](https://mooseframework.inl.gov/bison/source/materials/UPuZrThermal.html) | Calculates the thermal conductivity and specific heat for [!ac](SFR) metallic fuels |
| Thermal Expansion | [`ADUPuZrThermalExpansionEigenstrain`](https://mooseframework.inl.gov/bison/source/materials/solid_mechanics/UPuZrThermalExpansionEigenstrain.html) | Computes an eigenstrain due to thermal expansion for [!ac](SFR) metallic fuels using a function that describes the mean thermal expansion as a function of temperature |
| Fission Gas Release | [`ADSimpleFissionGasViscoplasticityStressUpdate`](https://mooseframework.inl.gov/bison/source/materials/solid_mechanics/SimpleFissionGasViscoplasticityStressUpdate.html) | Fission gas release model for [!ac](SFR) metallic fuels is handled by the fission gas swelling model |
| Hot Pressing | [`ADUPuZrHotPressingStressUpdate`](https://mooseframework.inl.gov/bison/source/materials/solid_mechanics/UPuZrHotPressingStressUpdate.html) | Computes the inelastic strain of UPuZr metallic fuel due to hot pressing |
| Sodium Logging | [`ADUPuZrSodiumLogging`](https://mooseframework.inl.gov/bison/source/materials/UPuZrSodiumLogging.html) | Computes the local fractional amount of sodium logging that can be used to evaluate thermal conductivity recovery |

The following material and behavioral models for the +HT9 cladding+ were used in this VTB model:

| Cladding Performance Behavior | BISON Model | Description |
| :- | - | :- |
| Elasticity | [`ADHT9ElasticityTensor`](https://mooseframework.inl.gov/bison/source/materials/solid_mechanics/HT9ElasticityTensor.html) | Elastic mechanical properties for HT9 |
| Creep Deformation | [`ADHT9CreepUpdate`](https://mooseframework.inl.gov/bison/source/materials/solid_mechanics/HT9CreepUpdate.html) | Irradiation creep and thermal creep (including primary, secondary and tertiary stages) correlation of HT9 |
| Volumetric Swelling | Neglected | +Volumetric Swelling+ of HT9 is neglected. As a tempered martensitic steel, HT9 does not swell as prominent as its austenitic stainless steel counterparts (i.e., 316SS and D9). |
| Thermal Expansion | [`ADComputeThermalExpansionEigenstrain`](https://mooseframework.inl.gov/bison/source/materials/ComputeThermalExpansionEigenstrain.html) | Thermal expansion model with constant instantaneous thermal expansion coefficient |
| Specific Heat/Thermal Conductivity | [`ADHT9Thermal`](https://mooseframework.inl.gov/bison/source/materials/HT9Thermal.html) | Calculates the thermal conductivity and specific heat for HT9 cladding |
| Cladding Damage | [`HT9FailureClad`](https://mooseframework.inl.gov/bison/source/materials/HT9FailureClad.html) | Cladding damage model for HT9 cladding based on the steady-state [!ac](CDF) model to facilitate failure determination |
| [!ac](FCCI) | [`ADMetallicFuelWastage`](https://mooseframework.inl.gov/bison/source/materials/MetallicFuelWastage.html) | Calculates the [!ac](FCCI) wastage thickness that is used to reduce effective cladding thickness |
| [!ac](CCCI) | [`ADMetallicFuelCoolantWastage`](https://mooseframework.inl.gov/bison/source/materials/MetallicFuelCoolantWastage.html) | Calculates the [!ac](CCCI) wastage thickness that is used to reduce effective cladding thickness |

As briefly mentioned above, some advanced MOOSE features, such as [`Automatic Differentiation`](https://mooseframework.inl.gov/automatic_differentiation/index.html) and mortar contact model, are employed by this VTB model. The mortar contact method was implemented for contact between the inner radial surface of the cladding and outer radial surfaces of the fuel. Both normal and tangential mechanical contact are modeled, with tangential contact including considerations of friction between the contact surfaces, parameterized by a friction coefficient, $\mu$. A value of $\mu$=0.1 was determined to as it leads to axial fuel growth values consistent with [!ac](PIE) observation.

Additionally, [`MetallicFuelWastageDegradationFunction`](https://mooseframework.inl.gov/bison/source/functions/MetallicFuelWastageDegradationFunction.html) is used to generate axial-dependent functions based on the [!ac](FCCI)/[!ac](CCCI) wastage thickness profiles recorded by corresponding `VectorPostprocessor`s. Such functions are directly used by cladding mechanical properties to artificially soften the cladding strength.

!style halign=right
[Go to +Next Section: Simulation Results+](/dp11_results.md)
