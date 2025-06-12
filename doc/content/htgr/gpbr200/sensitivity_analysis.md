# GPBR200 Design-Space Sensitivity Analysis

*Contact: Zachary M. Prince, zachary.prince@inl.gov*

*Model link: [GPBR200 Sensitivity Analysis](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/gpbr200/sensitivity_analysis)*

The MOOSE stochastic tools module (STM) contains utilities and capabilities
useful for stochastic simulation of MOOSE-based models [!citep](Slaughter2023). In this exposition, a
sensitivity analysis is performed on the GPBR200 equilibrium core model using
the STM. This is a analog to the sensitivity analysis performed in Section 3 of
[!cite](prince2024Sensitivity). This analysis has four objectives:

1. Identify design parameters and QoIs ([stm_base_sampling.i](gpbr200/sensitivity_analysis/stm_base_sampling.i))
2. Perform qualitative sensitivity analysis ([stm_grid_study.i](gpbr200/sensitivity_analysis/stm_grid_study.i))
3. Produce a training dataset ([stm_lhs_sampling.i](gpbr200/sensitivity_analysis/stm_lhs_sampling.i))
4. Compute global sensitivities ([stm_poly_chaos.i](gpbr200/sensitivity_analysis/stm_poly_chaos.i))

## Parameters and QoIs

Six parameters in the GPBR200 model were chosen to define the design-space and
five quantities of interest (QoIs) were chosen for the analysis. The parameters
are defined in [!ref](tab:gpbr200_sa_params) with a lower and upper bound
describing their uniform probability distribution, as well as their nominal
value for comparison. The QoIs are defined in [!ref](tab:gpbr200_sa_qois) with
their nominal values, which are the values as a result of evaluating the model
at the parameters' nominal values.

!table id=tab:gpbr200_sa_params caption=Design space for the GPBR200 model.
| Parameter      | Nominal Value | Lower Bound | Upper Bound | Unit        |
| :------------- | ------------: | ----------: | ----------: | :---------- |
| Kernel radius  | 0.2125        | 0.15        | 0.3         | mm          |
| Filling factor | 9.34          | 5           | 15          | %           |
| Enrichment     | 15.5          | 5           | 20          | wt%         |
| Feed rate      | 1.5           | 1           | 3           | pebbles/min |
| Burnup limit   | 147.6         | 131.2       | 164.0       | MWd/kg      |
| Total power    | 200           | 180         | 220         | MW          |

!table id=tab:gpbr200_sa_qois caption=Quantities of interest for the GPBR200 model.
| QoI                  | Nominal Value | Unit |
| :------------------- | ------------: | :--- |
| Eigenvalue           | 1.00129       | ---  |
| Max fuel temperature | 1281          | K    |
| Max RPV temperature  | 508.5         | K    |
| Max pebble power     | 2.67          | kW   |
| Peaking factor       | 2.012         | ---  |

## Modified GPBR200 Model

The fully-coupled GPBR200 equilibrium-core input is largely unchanged from that
described in the [previous step](gpbr200/pebble_surrogate_modeling.md). The
primary difference in the inclusion of postprocessors defining the QoIs and the
removal of `Outputs`.

!listing gpbr200/sensitivity_analysis/gpbr200_ss_gfnk_reactor.i
    block=Postprocessors

The other, more minor, modification is in the thermal hydraulics input, where
`dt_min` and `error_on_dtmin` are specified. This insures that the stochastic
simulation doesn't stall on a difficult-to-converge configuration and simply
marks the sample as "uncoverged".

!listing gpbr200/sensitivity_analysis/gpbr200_ss_phth_reactor.i
    diff=gpbr200/pebble_surrogate_modeling/gpbr200_ss_phth_reactor.i
    block=Executioner

## Base Sampling Input

This input defines most of the objects necessary for sampling the GPBR200 model
and gathering the QoIs. First, input file variables are specified defining the upper and
lower bounds of the design-space parameters.

The parameter bounds and nominal values are defined in the relevant input files
of the model:

!listing gpbr200/sensitivity_analysis/stm_base_sampling.i
    start=Kernel radius
    end=[StochasticTools]


The STM utilizes the `MultiApps` system to perform the sampling, namely with
`SamplerFullSolveMultiApp`. In this block, the GPBR200 input is specified; along
with the sampler defining the parameter values of all the configurations to be
sampled (this object will be defined in the next two sections). The `mode` and
`min_procs_per_app` parameters specify the method in which the multiapps are
distributed, i.e. only one app per four processors available are instantiated at
time; this minimizes the number of HPC nodes the execution needs to allocate.
The `ignore_solve_not_converge` parameter allows the sampling to continue even
if one of the sample's solve fails to converge.

!listing gpbr200/sensitivity_analysis/stm_base_sampling.i
    block=MultiApps

Next, a `Controls` object is specified, which takes the configurations defined
by the sampler and applies them as command-line arguments when instantiating the
sub-applications.

!listing gpbr200/sensitivity_analysis/stm_base_sampling.i
    block=Controls

Next, a `StochasticMatrix` reporter is specified, which serves as a storage
object that contains all the parameters and resulting QoIs for each
configuration. This eventually gets outputted as a CSV file.

!listing gpbr200/sensitivity_analysis/stm_base_sampling.i
    block=Reporters

Finally, a `Transfers` object is specified for extracting the postprocessors
from the sub-applications and filling in the `storage` reporter.

!listing gpbr200/sensitivity_analysis/stm_base_sampling.i
    block=Transfers

## 1D Grid Study

The goal of this input is to perform a qualitative analysis on how each
parameter impacts each quantity of interest individually. The method utilizes a
`Cartesian1D` sampler to sample each parameter at 12 equidistant points between
their upper and lower bound, while keeping all other parameters the same. The
resulting number of samples is $12\text{ points per parameter} \times 6\text{
parameters} = 72$.

!listing gpbr200/sensitivity_analysis/stm_grid_study.i
    start=!include

Running this input requires the use of a `blue_crab-opt` executable. Each sample
takes an average of 10 min to complete on 4 processors.
[!ref](fig:gpbr200_grid_study) shows the dependency each parameter has on each
QoI. Note that the parameters are scaled based on nominal values and lower and
upper bounds.

!media gpbr200/gpbr200_sensitivity_analysis_grid.png
    caption=Quantities of interest versus design parameters from performing one-dimensional grid sampling.
    id=fig:gpbr200_grid_study

## Random Sampling

The purpose of this next input is essentially to generate a lot of data. This
data will be used in the next section to perform global sensitivity analysis.
This is done by specifying a `LatinHypercube` sampler, which evaluates the
parameter `Distributions`' quantile to generate 10,000 random configurations of
the model.

!listing gpbr200/sensitivity_analysis/stm_lhs_sampling.i
    start=!include

This input takes, by far, the most time and computing resources of any input
involving this model. The average run-time for each sample is 13 min; as a
result, running this input on 448 processors (four nodes on INL's Bitterroot
HPC) took about 24 hours. [!ref](fig:gpbr200_lhs_sampling) shows the resulting
discrete probability distributions for each QoI.

!media gpbr200/gpbr200_sensitivity_analysis_lhs.png
    caption=Discrete probability density functions of quantities of interest from Latin hypercube sampling.
    id=fig:gpbr200_lhs_sampling

## Global Sensitivity Analysis

The final aspect of this demonstrative model is to use the data from previous
section and evaluate Sobol indices using a polynomial chaos expansion (PCE)
methodology. PCE is a surrogate modeling technique that has convenient feature
for computing Sobol indices, for more details see Section 3.4 in
[!cite](prince2024Sensitivity). The first part of this input involves loading
the CSV data from the sampling run; the parameter data is loaded into a
`CSVSampler` and the rest is loading into a `CSVReaderVectorPostprocessor`. Note
that this data was processed with the following python commands to remove
unconverged samples.

```python
>>> import pandas as pd
>>> df = pd.read_csv("stm_lhs_sampling_out_storage_0001.csv")
>>> df = df.loc[df["data:converged"] == True]
>>> df.to_csv("stm_lhs_sampling_processed.csv", index=False)
```

!listing gpbr200/sensitivity_analysis/stm_poly_chaos.i
    block=Samplers VectorPostprocessors

Next, `Trainers` are defined to train a fourth-order polynomial chaos expansion
for each QoI using ordinary least-squares. Note the distributions from the
sampling phase are required in order to select the optimal expansion bases.

!listing gpbr200/sensitivity_analysis/stm_poly_chaos.i
    block=GlobalParams Trainers

Next, `Surrogates` for each QoI's PCE is specified.

!listing gpbr200/sensitivity_analysis/stm_poly_chaos.i
    block=Surrogates

These `Surrogates` are used by a `PolynomialChaosReporter` to evaluate the
first, second, and total Sobol indices.

!listing gpbr200/sensitivity_analysis/stm_poly_chaos.i
    block=Reporters

Finally, the indices computed in the reporter are outputted via a JSON file.

!listing gpbr200/sensitivity_analysis/stm_poly_chaos.i
    block=Outputs

This input can be run with any MOOSE executable that contains the STM, including
`moose-opt`, `griffin-opt`, and `blue_crab-opt`. The run-time is essentially
instantaneous on a single processor. [!ref](fig:gpbr200_sobol_total) shows the
resulting total Sobol indices for each parameter-QoI pair.

!media gpbr200/gpbr200_sobol_total.png
    caption=Total Sobol indices for each parameter and QoI calculated from polynomial chaos surrogate.
    id=fig:gpbr200_sobol_total
