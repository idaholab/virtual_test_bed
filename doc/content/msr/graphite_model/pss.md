# Parellel subset simulations

The [Parallel Subset Simulation (PSS)](https://mooseframework.inl.gov/source/samplers/ParallelSubsetSimulation.html) framework is employed to efficiently estimate the failure probabilities of graphite components in molten salt reactors (MSRs). Given the complexity and rarity of failure events, direct Monte Carlo methods would be computationally prohibitive. PSS breaks down the overall failure probability into intermediate steps, narrowing the sampling space towards rare-event regions. This approach allows for a targeted and efficient exploration of the failure domain, identifying critical input parameters that significantly affect stress values. Ultimately, PSS helps in understanding the conditions under which structural integrity could be compromised, facilitating more informed and risk-aware decision-making. In this study, eight input parameters are varied within user-specified bounds. The distribution of inputs corresponding to a user-defined failure metric, with the maximum principal stress set to 15 MPa, is obtained.

## Computational Model Description

This section outlines the setup and execution of a Parallel Subset Simulation (PSS) framework using a 2D MSRE (Molten Salt Reactor Experiment) geometry. The framework utilizes two input files: the main PSS input file and the finite element simulation input file. The PSS input file generates combinations of input parameters and passes them to the simulation file, which performs the finite element analysis to determine the maximum stress corresponding to a user-defined infiltration amount. The PSS input file then retrieves the simulation results, such as the maximum stress, for further analysis. It is important to note that the finite element simulation input file adheres to a setup analogous to the one described in the [3D stress analysis](stress_analysis.md), but is specifically configured for 2D simulations. Consequently, the detailed discussion of the finite element setup is omitted here for brevity. 

Files used by this model include:

- MOOSE input files: `pss.i` and `Baseline_Input.i`
- Exodus reference solution file for initializing the infiltration amount
- Mesh input file
- A python code for postprocessing
- HPC job file to submit the simulation

This document reviews the important elements of the input file (`pss.i`), listed in full here:

!listing msr/graphite_model/infiltration/parellel_subset_sampling_2D/pss.i


### `StochasticTools`

This block configures the overall stochastic analysis and settings.

!listing msr/graphite_model/infiltration/parellel_subset_sampling_2D/pss.i block=StochasticTools


### `Distributions`

This block defines the distributions for the input parameters. Each parameter is modeled using a uniform distribution within specified bounds. 

!listing msr/graphite_model/infiltration/parellel_subset_sampling_2D/pss.i block=Distributions

### `Samplers`

This block defines the sampler methods used for the stochastic analysis. The `ParallelSubsetSimulation` method is employed to sample the defined distributions. This method allows for efficient sampling by dividing the simulations into subsets and running them in parallel, which enhances computational efficiency and ensures robust statistical analysis.

!listing msr/graphite_model/infiltration/parellel_subset_sampling_2D/pss.i block=Samplers

### `MultiApps`

This block manages the execution of sub-applications within the main simulation. The `SamplerFullSolveMultiApp` type is used to run the sub-applications. This setup allows for the main application to control and coordinate the execution of multiple sub-applications, ensuring that the stochastic sampling is effectively integrated into the overall simulation process.

!listing msr/graphite_model/infiltration/parellel_subset_sampling_2D/pss.i block=MultiApps

### `Transfers`

This block facilitates the transfer of data between the main and sub-applications. 

!listing msr/graphite_model/infiltration/parellel_subset_sampling_2D/pss.i block=Transfers

### `Controls`

This block passes inputs to the simulation based on the sampler output. 

!listing msr/graphite_model/infiltration/parellel_subset_sampling_2D/pss.i block=Controls

### `Reporters`

This block defines the reporters used in the simulation. The `StochasticReporter` collects the results, while the `AdaptiveMonteCarloDecision` guides the input selection towards rare events.

!listing msr/graphite_model/infiltration/parellel_subset_sampling_2D/pss.i block=Reporters

## Running the model

This analysis requires HPC resources. To run this model using the MOOSE combined module executable, run the job file in a HPC system:

```
#!/bin/bash
#PBS -N PSS
#PBS -l select=25:ncpus=48:mpiprocs=40
#PBS -l walltime=05:00:00
#PBS -P nrc

# Change to the directory from which the job was submitted
cd $PBS_O_WORKDIR

# Load the necessary modules
module purge
module load use.moose moose-dev

mpiexec -n 1000 path_to_combined-opt -i pss.i | tee progress_log.txt 
```

*Note: Please note that this HPC system utilizes a PBS scheduling system. Therefore, the job script is based on PBS commands. If you need to use SLURM, ensure to adjust the script accordingly.*


The following output files will be produced:

- The JSON results file: `pss_out.json`

This is analyzed using the following python file:

!listing msr/graphite_model/infiltration/parellel_subset_sampling_2D/PSSPlots_Histograms.py

This Python script reads a JSON output file and generates histograms of input variables corresponding to failure, defined by a maximum stress exceeding 15 MPa. It compares these histograms to those from random Monte Carlo samples for each input variable. Additionally, the script provides the minimum and maximum ranges of input values associated with this failure.
