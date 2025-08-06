# Creation of a reference solution file

Creating a reference solution file enables direct initialization of the required infiltration profile without the need to run a separate simulation. This page outlines a streamlined workflow to create a reference solution file, which can dynamically initialize the infiltration profile during stress analysis. The reference solution file is generated once for a given graphite geometry, enabling multiple simulations based on infiltration without redundancy.

To achieve this, two tasks are performed sequentially. First, ten infiltration profile simulations are conducted with varying infiltration levels, ranging from 10% to 100% in 10% increments. Then, the outputs from these simulations are combined into a single output file, which can be used to assign infiltration profiles for subsequent analyses.

## Parametric Study

To complete the first task, the same input file as mentioned in [creation of infiltration profiles](infiltration_profile.md) is used. The ten simulations are run simultaneously using the Parametric Study Object within the [MOOSE Stochastic Tools](https://mooseframework.inl.gov/modules/stochastic_tools/examples/parameter_study.html). The input file is shown below.

!listing msr/graphite_model/infiltration/create_reference_solution_file/Parametric_study.i

In these simulations, the `2D_CreateInfiltrationProfile.i` file is run ten times, varying the `vol_frac_threshold` parameter.

To run this model in parallel using the MOOSE combined module executable and start the ten simulations simultaneously, use the following command:

```
mpiexec -n 100 /path/to/app/combined-opt -i Parametric_Study.i
```

The following output files will be produced:

- Ten Exodus result files: `param_study_out_study_appXX_exodus.e`
- Ten CSV result files: `param_study_out_study_appXX_csv.csv`

*Note: XX corresponds to the simulation case varying from 01 to 10, representing various infiltration amounts from 10% to 100%, respectively.*

## Combining the output files

In this step, the simulation output files generated in the previous section are combined into a single output file to facilitate further analysis. The input file for this task is given below.

!listing msr/graphite_model/infiltration/create_reference_solution_file/CombinedExodus_AllResults.i

This is accomplished using the `SolutionUserObject` and `SolutionFunction` MOOSE objects. The SolutionUserObject reads data from external solution files, capturing the variable `diffused` at the latest time step. The SolutionFunction then makes this data available as functions within the current simulation. The `ParsedFunction` effectively combines outputs from these solution functions and stores the infiltration profile at specific time steps. For example, a 10% infiltration corresponds to a time step of 0.1. This approach facilitates easy interpolation for any arbitrary user-defined infiltration amount.

To run this model using the MOOSE combined module executable, use the following command:

```
mpiexec -n 10 /path/to/app/combined-opt -i CombinedExodus_AllResults.i
```

The following Exodus output file will be produced:`CombinedExodus_AllResults_out.e`.

