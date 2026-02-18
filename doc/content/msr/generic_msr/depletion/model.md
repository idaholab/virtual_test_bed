# MSR Depletion Model

*Contact: Olin Calvin Olin.Calvin@inl.gov*

*Model link: [MSR Depletion Model](https://github.com/idaholab/virtual_test_bed/tree/main/msr/generic_msr/depletion)*

The MSR depletion model is an implementation and verification of Griffin's isotope removal capability for two multi-region MSR depletion cases.
This model consists of two regions. The first is the primary loop, which includes the reactor core, primary heat exchanger, and pump all
homogenized into a single region, and the second is the off-gas system.
The model approximates an MSR core as a fast spectrum, cube-geometry, infinite, homogenous medium, molten chloride salt reactor
using High-Assay Low-Enriched Uranium (HALEU) UCl$_3$ fuel.
The important parameters for this model are given in [parameters].
This model is used for isotope depletion cases with and without removal to the off-gas system, and is also the starting point for analyzing what
type of insoluble material may be removed into the off gas during burnup [!citep](walker2022).

!table id=parameters caption=Simple MSR Test Case Design Specifications
| Parameter | Value  |
| :- | :- |
| Salt Composition | $0.33$ UCl$_3$-$0.67$ NaCl |
| Salt Density | $3.13$ g/cm$^3$ |
| Enrichment | $19.75$% |
| Volume | $1.00 \times 10^6$ cm$^3$ |
| Temperature | $700$ $\degree$C |
| Power Density - Power | $200$ W/g - $321$ MW |
| 1G Flux | $8.3989 \times 10^{15}$ neutrons/(cm$^2$ $\cdot$ s) |
| Fission Rate | $9.89 \times 10^{12}$ fissions/(cm$^3$ $\cdot$ s) |
| K$_{eff}$ | $1.23 - 1.21$ |
| Spectrum | Fast |

# Griffin Model

Griffin is used to model the depletion of the MSR which solves the Bateman equations with removal discussed in the
Method and results section. This section will discuss how to run the model and describe the input files for the *depletion with no iodine removal* and *depletion with isotopic removal* models.

## Obtaining and Running the Griffin Model

## *Depletion with no iodine removal* Model

The complete input file for the *Depletion with no iodine removal* model is
shown below.

!listing msr/generic_msr/depletion/0D_No_Iodine_Removal_1G.i

In the following sections, we will discuss each of
the input blocks.


### Mesh and Problem

In this section, we will cover the mesh and problem inputs.
The full input blocks can be found below.

!listing msr/generic_msr/depletion/0D_No_Iodine_Removal_1G.i
         block=Mesh

!listing msr/generic_msr/depletion/0D_No_Iodine_Removal_1G.i
         block=Problem

Here a very simple mesh is generated using the [!style color=orange](GeneratedIDMeshGenerator)
which is not currently used explicitly for this problem. Additionally, a simple problem statement
is also specified. The reason for this, is because the majority of this model is actually a
[!style color=orange](VectorPostprocessor) which will be discussed shortly.

### AuxVariables, AuxKernels, and Functions

AuxVariables are variables that can be derived from the
solution variables (i.e., scalar flux). An AuxKernel is a
procedure that uses the solution variable to compute
the AuxVariable (i.e., reaction rate).

There are two AuxVariables that are defined in this model:
the burnup measured in time and the neutron flux.

!listing msr/generic_msr/depletion/0D_No_Iodine_Removal_1G.i
         block=AuxVariables

The AuxKernels are locally defined with the names
`[constant]` and `[SetBurnup]`, and are of
the [!style color=orange](ConstantAux) and [!style color=orange](FunctionAux) type respectively.
The AuxVariable that the kernel acts on is defined with
[!style color=red](AuxVariable) defined previously.
Lastly, we tell it to [!style color=red](execute_on) the end of a time step.

!listing msr/generic_msr/depletion/0D_No_Iodine_Removal_1G.i
         block=AuxKernels

Since we are using a [!style color=orange](FunctionAux) we will still need to define this function in another block.

!listing msr/generic_msr/depletion/0D_No_Iodine_Removal_1G.i
         block=Functions

Here we set the depletion time steps (given in seconds) that we would like to use via a
[!style color=orange](PiecewiseLinear) type of function.

### Materials

Material cross sections are specified with the multi-group
cross section library defined by [!style color=red](library_file)
In this example, we define one generic material `[Mat_1]`.
For this material we specify the type as a
[!style color=orange](CoupledFeedbackNeutronicsMaterial).

In this example, we have a generic pseudo mixture with a density that is
defined here in this block. Since we are performing isotopic depletion, the primary purpose
of this block is to set up the [!style color=red](grid_variables) = 'Burnup' and
[!style color=red](scalar_fluxes) = 'flux' and not to operate on the macroscopic cross sections
defined here.

!listing msr/generic_msr/depletion/0D_No_Iodine_Removal_1G.i
         block=Materials

### Executioner and Outputs

The `[Executioner]` block tells the solver what type of problem
it needs to solve.
Here, we select [!style color=orange](Transient) as the executioner
type which will solve the depletion problem for the isotopic evolution
of the system given the time steps laid out in the `[TimeStepper]`.

!listing msr/generic_msr/depletion/0D_No_Iodine_Removal_1G.i
         block=Executioner

The output of the nuclide concentrations is handled by the [!style color=orange](MSRDepletionNeutronicsMaterial).
It is directly output to a comma-separated value (CSV) file.

## *Depletion with Isotopic Removal* Model

The complete input file for the *Depletion with Isotopic Removal* model is
shown below.

!listing msr/generic_msr/depletion/0D_Iodine_Removal_1G.i

The input file for the *Depletion with Isotopic Removal* model is exactly the same as the
*Depletion with no iodine removal* model with one key exception. Here the
[!style color=red](multi_region_transfer_isotope_rates) in the [!style color=orange](BatemanVPP)
are specified and non-zero for the isotopes in question.
