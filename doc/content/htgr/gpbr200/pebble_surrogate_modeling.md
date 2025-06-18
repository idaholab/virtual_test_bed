# GPBR200 Pebble Surrogate Modeling

*Contact: Zachary M. Prince, zachary.prince@inl.gov*

*Model link: [GPBR200 Pebble Surrogate](https://github.com/idaholab/virtual_test_bed/tree/main/htgr/gpbr200/pebble_surrogate_modeling)*

## Motivation

In the [fully coupled GPBR200 model](gpbr200/coupling.md), the pebble heat
conduction multi-scale simulation takes up a significant portion of the run-time
and vast majority of memory. When the model is utilized for stochastic analysis,
this memory usage puts a significant damper on the potential parallelism of the
sampling. This is because only a small number of instances of the model would be
able to run simultaneously on a single compute node. For example, the
fully-coupled simulation requires approximately 75 GB and a single node on the
Sawtooth HPC at INL has 160GB per node; so only two samples can be run on each
node, despite having 48 available processors.

One solution to this memory constraint is to represent the pebble heat
conduction with a small, fast-evaluating surrogate to the finite element model.
There are four independent parameters to the pebble model: kernel radius,
filling factor, power density, and pebble surface temperature. The first two are
design parameters used in the
[sensitivity analysis demonstration](gpbr200/sensitivity_analysis.md); the second
two are values computed by the neutronics and thermal hydraulics applications.
The quantities of interest from the pebble model are the average fuel and
moderator temperatures. Two surrogates for each of these quantities can thus be
represented in the following form:

!equation id=eq:gpbr200_surrogate
\begin{aligned}
T_{\mathrm{fuel}} &\approx \hat{f}_{\mathrm{fuel}}(\text{kernel radius}, \text{filling factor}, \text{power density}, T_{\mathrm{surf}}), \\
T_{\mathrm{mod}} &\approx \hat{f}_{\mathrm{mod}}(\text{kernel radius}, \text{filling factor}, \text{power density}, T_{\mathrm{surf}}),
\end{aligned}

where $\hat{f}$ is a generic functional form of the surrogate.

The MOOSE stochastic tools module (STM) provides the `Surrogate` system, which
allows training and evaluation of such surrogates [!citep](Slaughter2023). The remainder of this
exposition will detail how use the STM to produce training data from the pebble
heat conduction model, train a simple (but effective) surrogate model, and how
to utilize the surrogate in the multiphysics simulation.

## Sampling

In this input, the `ParameterStudy` syntax from the STM is used to randomly
sample various configurations of the input parameters of the pebble model and
gather the fuel and moderator temperatures. For this exposition, 10,000 samples
were specified. Each sample takes approximately 150 ms to run, so executing this
input with 24 processors takes about one minute.

!listing gpbr200/pebble_surrogate_modeling/stm_pebble_sampling.i

The result is a CSV file with the parameter and temperature values for each
sample. A histogram of the temperatures is shown in [!ref](fig:gpbr200_pebble_sampling).

!media gpbr200/gpbr200_pebble_sampling.png
    caption=Probability density of fuel and moderator temperature from sampling
            pebble heat conduction model with 10,000 samples.
    id=fig:gpbr200_pebble_sampling

## Surrogate Training

In this input, the data produced in the previous section is used to train STM
surrogates. The `PolynomialRegression` surrogate was chosen for its simplicity
and robustness.

First, the data is loaded from the CSV file into a `Sampler` and
`VectorPostprocessor`.

!listing gpbr200/pebble_surrogate_modeling/stm_pebble_surrogate.i
    block=Samplers VectorPostprocessors

Next, `Trainers` and `Surrogates` are defined, which utilize the sampling and
vector-postprocessor data to produce the metadata necessary for generating the
surrogate. For `PolynomialRegression` this involves an ordinary least-squares
solve to evaluate coefficients of a multi-variate monomial. The `max_degree`
parameter specifies the degree of the monomial produced; a 4 dimensional basis
with a degree of 4 results in 70 coefficients. The `cv_type` parameter triggers
a cross validation calculation, giving a score on how well the surrogate fits
the provided training data.

!listing gpbr200/pebble_surrogate_modeling/stm_pebble_surrogate.i
    block=GlobalParams
          Trainers/pr4_Tfuel_train
          Trainers/pr4_Tmod_train
          Surrogates/pr4_Tfuel
          Surrogates/pr4_Tmod

A `CrossValidationScores` reporter is defined in order to output the result of
the cross validation calculation. In this example, four surrogates are trained
with various degrees. [!ref](tab:gpbr200_pebble_surrogate_cv) lists these
scores; a smaller number means a smaller difference from the training data.

!listing gpbr200/pebble_surrogate_modeling/stm_pebble_surrogate.i
    block=Reporters

!table caption=K-fold cross validation scores for various pebble heat conduction surrogates id=tab:gpbr200_pebble_surrogate_cv
| Monomial Degree | Number of Coefficients | $T_{\mathrm{fuel}}$ Score | $T_{\mathrm{fuel}}$ Score |
| --------------- | ---------------------- | :------------------------ | :------------------------ |
| 1               | 5                      | 47.9                      | 32.9                      |
| 2               | 15                     | 17.7                      | 11.8                      |
| 4               | 70                     | 6.90                      | 4.68                      |
| 6               | 210                    | 3.43                      | 2.32                      |

Finally, the surrogate metadata is outputted via a `SurrogateTrainerOutput` object. This produces folders in the working directory which can be loaded in the future by the surrogate object for evaluation.

!listing gpbr200/pebble_surrogate_modeling/stm_pebble_surrogate.i
    block=Outputs

## Surrogate Evaluation

This section presents the modifications to the main application input from the [coupled model](gpbr200/coupling.md) that replaces the pebble heat conduction multi-app with the trained surrogate models. The replacement is somewhat straight-forward: surrogates are loaded from the metadata previous produced and the `SurrogateModelArrayAuxKernel` evaluates the surrogates to populate the fuel and moderator temperature variables.

!listing gpbr200/pebble_surrogate_modeling/gpbr200_ss_gfnk_reactor.i
    diff=gpbr200/coupling/gpbr200_ss_gfnk_reactor.i
    block=MultiApps Transfers

!listing gpbr200/pebble_surrogate_modeling/gpbr200_ss_gfnk_reactor.i
    block=Surrogates AuxKernels/Tfuel_aux AuxKernels/Tmod_aux

The resulting eigenvalue from running this input is 1.00129, which is 0.4 pcm greater than the multi-app version. The approximate memory this simulation required is 4.8 GB, compared to the previous 75 GB. Furthermore, [!ref](tab:gpbr200_pebble_surrogate_rt) shows the improvement in runtime compared to the multi-app simulation.

!table caption=Run times for GPBR200 multiphysics simulation using pebble surrogates with varying number of processors id=tab:gpbr200_pebble_surrogate_rt
| Processors | Surrogate Version (min) | Multi-App Version (min) |
| ---------- | ----------------------- | ----------------------- |
| 1          | 18                      | ---                     |
| 2          | 12                      | ---                     |
| 4          | 9                       | 40                      |
| 8          | 6                       | 26                      |
| 16         | 4                       | 7                       |
| 32         | 3                       | 4                       |

