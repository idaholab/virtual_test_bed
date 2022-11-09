# MSR Depletion Model

*Contact: Samuel Walker, Samuel.Walker@inl.gov*

The MSR depletion model is an implementation and verification of Griffin's isotope removal capability for two multi-region MSR depletion cases.
This model consists of two regions. The first is the primary loop, which includes the reactor core, primary heat exchanger, and pump all homogenized into a single region, and the second is the off-gas system.
The model approximates an MSR core as a fast spectrum, cube-geometry, infinite, homogenous medium, molten chloride salt reactor using High-Assay Low-Enriched Uranium (HALEU) UCl$_3$ fuel.
The important parameters for this model are given in [parameters].
This model is used for isotope depletion cases with and without removal to the off-gas system, and is also the starting point for analyzing what type of insoluble material may be removed into the off gas during burnup [!citep](walker2022).

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
Method and results section. This section will discuss how to run the model and describe the input files for the *depletion with no isotopic removal* and *depletion with isotopic removal* models. 

## Obtaining and Running the Griffin Model

Since this isotopic depletion capability with removal is undergoing active development incorporating new changes,
this capability is only currently available on an experimental branch of griffin. For those that have source code
access to griffin, the method of acquiring this branch is to fetch the most recent branches. A new branch named
"experimental" will appear. Checkout this branch to run the following input files. There are also additional tests
of this capability listed in radiation_transport/test/tests/off_gas. 

!alert note
Please note this capability is under active development. A more complete multiphysics capability incorporating spatial
resolution, chemistry, and species transport will be accomplished in FY23 which will supersede this initial capability.

## *Depletion with no isotopic removal* Model

The complete input file for the *Depletion with no isotopic removal* model is
shown below.

!listing msr/msr_generic/depletion/norem1G.i

In the following sections, we will discuss each of
the input blocks.


### Mesh and Problem

In this section, we will cover the mesh and problem inputs.
The full input blocks can be found below.

!listing msr/msr_generic/depletion/norem1G.i
         block=Mesh

!listing msr/msr_generic/depletion/norem1G.i
         block=Problem

Here a very simple mesh is generated using the [!style color=orange](GeneratedIDMeshGenerator) 
which is not currently used explicitly for this problem. Additionally, a simple problem statement
is also specified. The reason for this, is because the majority of this model is actually a
[!style color=orange](VectorPostProcessor) which will be discussed shortly.

### AuxVariables, AuxKernels, and Functions

AuxVariables are variables that can be derived from the
solution variables (i.e., scalar flux). An AuxKernel is a
procedure that uses the solution variable to compute
the AuxVariable (i.e., reaction rate).

There are two AuxVariables that are defined in this model:
the burnup measured in time and the neutron flux.

!listing msr/msr_generic/depletion/norem1G.i
         block=AuxVariables

The AuxKernels are locally defined with the names
`[constant]` and `[SetBurnup]`, and are of
the [!style color=orange](ConstantAux) and [!style color=orange](FunctionAux) type respectively.
The AuxVariable that the kernel acts on is defined with
[!style color=red](AuxVariable) defined previously. 
Lastly, we tell it to [!style color=red](execute_on) the end of a time step.

!listing msr/msr_generic/depletion/norem1G.i
         block=AuxKernels

Since we are using a [!style color=orange](FunctionAux) we will still need to define this function in another block. 

!listing msr/msr_generic/depletion/norem1G.i
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

!listing msr/msr_generic/depletion/norem1G.i
         block=Materials

### Executioner and Outputs

The `[Executioner]` block tells the solver what type of problem
it needs to solve.
Here, we select [!style color=orange](Transient) as the executioner
type which will solve the depletion problem for the isotopic evolution
of the system given the time steps laid out in the `[TimeStepper]`.

!listing msr/msr_generic/depletion/norem1G.i
         block=Executioner

Additionally, the output block sets the output files from the simulation.
Two of the most common options include the exodus and csv file.
In this case only a csv output file is currently possible where the csv file 
stores a summary of the solution.

!listing msr/msr_generic/depletion/norem1G.i
         block=Outputs

### Vector Post-processors

The last blocks are for post-processors, debug options, and outputs.
A post-processor can be thought of as a function to derive a variable
of interest from the solution. In this case, the constant flux at each
burnup step defined earlier are used in the [!style color=orange](BatemanVPP)
listed in this block which accomplishes the primary task of this model.

Since we are solving an isotopic depletion problem, an isotopic cross section library
[!style color=red](isoxml_mglib_file) and a decay table [!style color=red](isoxml_dtlib_file).
Additionally, the initial isotopic concentration of the fuel-salt needs to be specified in atoms/b-cm in
[!style color=red](isotope_atomic_densities). For isotopic removal, there is also a 
[!style color=red](isotope_fixed_removal_rates) option for specific isotopes that can be extracted to the off-gas
system. Lastly, there are various options on how to solve the Bateman equation included in the block as well.

!listing msr/msr_generic/depletion/norem1G.i
         block=VectorPostprocessors


## *Depletion with Isotopic Removal* Model

The complete input file for the *Depletion with Isotopic Removal* model is
shown below.

!listing msr/msr_generic/depletion/rem1G.i

The input file for the *Depletion with Isotopic Removal* model is exactly the same as the
*Depletion with no Isotopic Removal* model with one key exception. Here the 
[!style color=red](isotope_fixed_removal_rates) in the [!style color=orange](BatemanVPP) 
are specified and non-zero for the isotopes in question. 

