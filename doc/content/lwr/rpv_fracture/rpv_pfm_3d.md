# Light-Water Reactor Pressure Vessel Model: 3D Probabilistic Fracture Mechanics Model

*Contact: Ben Spencer, benjamin.spencer@inl.gov*

*Model was co-developed by Ben Spencer and Will Hoffman

*Model link: [Grizzly RPV PFM Model](https://github.com/idaholab/virtual_test_bed/tree/main/lwr/rpv_fracture/thermomechanical)*

## High Level Summary of Model

Probabilistic fracture mechanics (PFM) analyis assesses the probability of fracture at the location of any flaw in the population of flaws introduced in the RPV during the manufacturing process. PFM relies on the results of a thermomechanical model of the RPV that does not consider flaws to provide local stress and temperature conditions for each of the flaws considered.

This problem demonstrates the probabilistic fracture mechanics analyis of an RPV, modeled in 3D, containing a population of flaws. It uses the results of the [3D Thermomechanical Model](rpv_thermomechanical_3d.md) for this analysis.

## Computational Model Description

The model evaluates the conditional probability of fracture initiation (CPI) for a population of flaws in an RPV, using a 3D  model to represent the global thermomechanical response. In addition to any 3D effects that may be present in the thermomechanical response (which are minimal in this case because spatially uniform cooling is applied), the model also includes 3D aspects of the RPV configuration, including the layout of the various subregions that make up the RPV and the spatial distribution of fluence.

The layout of the subregions making up the RPV in this example is shown in [plates_and_welds].  The actual RPV is larger than the region represented here, but this subregion layout emcompasses the beltline region adjacent to the reactor core, which experiences the highest neutron flux and is typically the focus of RPV integrity analyses.

!media lwr/rpv_fracture/plates_and_welds.png
      id=plates_and_welds
      style=width:80%
      caption=Layout of plate and weld regions in the RPV modeled here

Files used by this model include:

- MOOSE input file
- CSV (comma-separated value) file defining the properties of the subregions that make up the RPV
- Data files defining the distributions of flaw densities
- CSV files generated as output from the global model described in [3D Thermomechanical Model](rpv_thermomechanical_3d.md), located in that model's directory

This document reviews the basic elements of the input file, listed in full here:

!listing /lwr/rpv_fracture/probabilistic_fracture/rpv_pfm_3d.i

## Input File

### `Mesh`

This model does not perform a finite element simulation, because that was done in the previous global thermomechanical simulation step. However, all MOOSE models require a mesh, even if it is not used, so a simple single-element mesh is defined here.

!listing /lwr/rpv_fracture/probabilistic_fracture/rpv_pfm_3d.i block=Mesh

### `Samplers`

This block is used to define the way in which the parameters defining each flaw in the population are defined. The `RPVFractureSampler` is a specialized `Sampler` developed specifically for RPV analysis.

A key parameter in this block is `num_rpvs`, which is set to a relatively low number here to make the model easy to run quickly. Larger numbers will give better-converged solutions, but will require more computational resources.

This sampler uses distributions of the flaw population defined in files using the VFLAW format [!cite](pnnl_flaw_code_2004). Separate files are used for the surface-breaking flaws, plates, and weld regions. Each of these files, which are text files, contain 1000 separate blocks of data defining distributions of flaws. While the flaw distribution blocks in general differ from each other, in this example these files are taken directly from the printouts in [!cite](pnnl_flaw_code_2004), which provide only the first distribution. These same distributions are then repeated 1000 times to match the required file formatting. Because they are based on public data, these files are named `plate_open_access.dat`, `surface_open_access.dat`, and `weld_open_access.dat` for the distributions of embedded flaws in plates, surface-breaking flaws, and embedded flaws in welds, respectively.

This block also requires that the vessel geometry and its units be defined, and requires the values for a number of parameters defining how concentrations of alloying elements are sampled. The file defining the properties of subregions shown in [plates_and_welds], which is `plates_and_welds.csv` is specified here.

!listing /lwr/rpv_fracture/probabilistic_fracture/rpv_pfm_3d.i block=Samplers

### `UserObjects`

Grizzly uses a modular structure for its PFM calculations [!cite](spencer_modular_2019), and utilizes a set of code objects that are specializations of each of the objects shown in [PFM]. Each of these objects is defined in the UserObjects section of the input. The set of objects used here is typical of those that would be used in a PFM analysis, but in many cases, there are options to substitute in other types of objects to perform various parts of the computation in different ways.

!media lwr/rpv_fracture/PFM.png
      id=PFM
      style=width:60%
      caption=Dependencies of UserObjects used in PFM calculations

The objects used here are summarized below:

- The [VesselGeometry](https://grizzly-dev.hpc.inl.gov/site/source/userobject/VesselGeometry.html) object defines the important dimensions of the RPV.
- The [FlawDataFromSampler](https://grizzly-dev.hpc.inl.gov/site/source/userobject/FlawDataFromSampler.html) object provides the data for the flaws to be evaluated from the `RPVFractureSampler` that was described above. Other types of FlawData objects can provide flaw information from other sources, such as CSV files.
- The [PolynomialCoefficientsFromFile](https://grizzly-dev.hpc.inl.gov/site/source/userobject/PolynomialCoefficientsFromFile.html) objects provide the polynomial coefficients that are used for computing the various stress components and temperatures in the clad and base blocks from the CSV files generated in the global thermomechanical analysis.
- The [FieldValueFromCoefficients](https://grizzly-dev.hpc.inl.gov/site/source/userobject/FieldValueFromCoefficients.html) object computes the temperature at the flaw locations from one of the polynomial coefficient objects described above.
- The [FluenceAttenuatedFromSurface](https://grizzly-dev.hpc.inl.gov/site/source/userobject/FluenceAttenuatedFromSurface.html) object computes a fluence attenuated from a value defined at the RPV inner surface. Other options are also available for defining the fluence, including from an Exodus file, which permits accurate transfer of data from neutron transport calculations.
- The [EmbrittlementEONY](https://grizzly-dev.hpc.inl.gov/site/source/userobject/EmbrittlementEONY.html) object computes the embrittlement at specific flaw locations using the EONY model.
- The [KIAxisAlignedROM](https://grizzly-dev.hpc.inl.gov/site/source/userobject/KIAxisAlignedROM.html) object computes mode-$I$ stress intensity factor using an influence coefficient method.
- The [FractureProbability](https://grizzly-dev.hpc.inl.gov/site/source/userobject/FractureProbability.html) object computes the fracture probability for individual flaws using the $K_I$, temperature, and embrittlement computed by the other objects described above.

!listing /lwr/rpv_fracture/probabilistic_fracture/rpv_pfm_3d.i block=UserObjects

### `Executioner`

The Executioner block simply defines the time stepping in this case, because no equation solution is performed. The start and end times must fall within those for the global thermomechanical model. If the time steps do not match those in the global thermomechanical model, they will be interpolated, but it is generally recommended for the timestepping in the PFM analysis to match that of the thermo/mechanical solution.

!listing /lwr/rpv_fracture/probabilistic_fracture/rpv_pfm_3d.i block=Executioner

### `Problem`

The `solve=false` parameter set here is used to instruct MOOSE to not solve an equation system. MOOSE still does, however, run the specified objects even when `solve=false` is set.

!listing /lwr/rpv_fracture/probabilistic_fracture/rpv_pfm_3d.i block=Problem

### `VectorPostprocessors`

The objects defined here are used to compute vectors of data useful for output. These include:

- [RPVFailureProbability](https://grizzly-dev.hpc.inl.gov/site/source/vectorpostprocessors/RPVFailureProbability.html), which computes CPI for each sampled RPV based on the CPI for the individual flaws within that RPV.
- [VectorPostprocessorRunningStatistics](https://grizzly-dev.hpc.inl.gov/site/source/vectorpostprocessors/VectorPostprocessorRunningStatistics.html), which computes the running statistics for the mean value and standard deviation of CPI over the course of the Monte Carlo iterations.
- [RPVFlawFailureData](https://grizzly-dev.hpc.inl.gov/site/source/vectorpostprocessors/RPVFlawFailureData.html), which gathers key data about each flaw with nonzero CPI, including its location, CPI, and $K_I$ and temperature at the point in time when it reached its maximum CPI.
- [RPVSamplerData](https://grizzly-dev.hpc.inl.gov/site/source/vectorpostprocessors/RPVSamplerData.html), which makes the sampled variables for each flaw available for output. Note that this block is not included in the set of active VectorPostprocessors because the resulting output can be very large. This is useful for debugging purposes.

!listing /lwr/rpv_fracture/probabilistic_fracture/rpv_pfm_3d.i block=VectorPostprocessors

### `Postprocessors`

The objects defined here provide scalar values of key model outcomes at each time step. These include:

- [VectorPostprocessorStatistics](https://grizzly-dev.hpc.inl.gov/site/source/postprocessors/VectorPostprocessorStatistics.html), which outputs the mean and standard deviation of CPI at a given time step.

!listing /lwr/rpv_fracture/probabilistic_fracture/rpv_pfm_3d.i block=Postprocessors

### `Outputs`

The blocks defined here are used to define outputs that are done at each time step, and at the initial and final times. The only quantities available for output from a PFM analysis are Postprocessors and VectorPostprocessors, both of which are commonly written to CSV files, so it is essential to define appropriate output blocks for this data. Some of the other blocks refer to these outputs with their `outputs` parameter.

!listing /lwr/rpv_fracture/probabilistic_fracture/rpv_pfm_3d.i block=Outputs

## Running the model

To run this model using the Grizzly executable, run the following command:

```
mpiexec -n 4 /path/to/app/grizzly-opt -i rpv_pfm_3d.i
```

This runs the model using 4 processors. It is recommended that the model be run using as many processors as are available on the machine to accelerate completion of the simulation because these simulations can require significant computation time, especially as the number of RPV realizations is increased.

This model generates the following output files:

- A CSV file with the Monte Carlo iteration convergence history: `rpv_pfm_3d_final_cpi_running_statistics_0035.csv`
- A CSV file with data on the flaws with nonzero CPI: `rpv_pfm_3d_final_flaw_failure_data_0035.csv`
- A CSV file with time histories of all postprocessors:  `rpv_pfm_3d_out.csv`

Plotting scripts are provided to process the data provided in these files. The `cpi_convergence.py` script can be run to generate the convergence history plot shown in [cpi_convergence]. It is evident that a larger number of RPV samples would need to be evaluated to obtain a fully converged solution. Depending on the model, this can require on the order of 100,000 RPV samples.

!media lwr/rpv_fracture/cpi_convergence.png
      id=cpi_convergence
      style=width:70%
      caption=Convergence history of CPI for this example

The `scatter_spatial.py` script can be run to generate the scatter plots showing the physical locations of all sampled flaws with nonzero CPI shown in [scatter_spatial_thetar] and [scatter_spatial_thetaz].

!media lwr/rpv_fracture/scatter_spatial_thetar.png
      id=scatter_spatial_thetar
      style=width:70%
      caption=Spatial distribution of flaws with nonzero CPI plotted in terms of flaw depth vs. azimuthal position

!media lwr/rpv_fracture/scatter_spatial_thetaz.png
      id=scatter_spatial_thetaz
      style=width:70%
      caption=Spatial distribution of flaws with nonzero CPI plotted in terms of flaw axial vs. azimuthal position

It can also be helpful to plot the values of $K_I$ vs. relative temperature (difference between the current temperature and reference nil-ductility temperature) at the point when the maximum CPI is reached. The plot generated in [scatter_temp_ki] was generated using the `scatter_temp_ki.py` script in this directory.

!media lwr/rpv_fracture/scatter_temp_ki.png
      id=scatter_temp_ki
      style=width:70%
      caption=Scatter plot of the $K_I$ at the time when CPI is a maximum plotted vs. the difference between the current temperature and the reference nil-ductility temperature
