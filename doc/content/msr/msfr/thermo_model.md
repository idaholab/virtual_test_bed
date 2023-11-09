# MSFR Griffin-Pronghorn-Thermochimica Model

*Contact: Samuel Walker, samuel.walker@inl.gov*

*Model link: [Thermochimica Steady-State Model](https://github.com/idaholab/virtual_test_bed/tree/devel/msr/msfr/thermochemistry)*

!tag name=MSFR Griffin-Pronghorn-Thermochimica Steady State Model pairs=reactor_type:MSR
                       reactor:MSFR
                       geometry:core
                       simulation_type:core_multiphysics
                       input_features:multiapps
                       code_used:BlueCrab
                       computing_needs:Workstation
                       fiscal_year:2023

Recent efforts funded by the Nuclear Energy Advanced Modeling and Simulation (NEAMS) program have worked to wrap the Gibbs Energy Minimizer Thermochimica [!citep](Thermochimica) within the MOOSE framework [!citep](FrameworkM3).

## MOOSE Wrapped Thermochimica

The Gibbs Energy Minimizer Thermochimica has now been incorporated into the [Chemical Reactions Module](https://mooseframework.inl.gov/modules/chemical_reactions/index.html) of MOOSE as a [UserObject](https://mooseframework.inl.gov/source/userobjects/ThermochimicaNodalData.html).

The purpose of Thermochimica is to determine the thermochemical equilibrium of a system by minimizing the internal Gibbs Energy of the system through the use of the CALculation of PHase Diagrams (CALPHAD) method with the Molten Salt Thermal Properties Database - Thermochemical (MSTDB-TC) [!citep](MSTDB).

Here MSTDB-TC V2.0 for fluoride salts was used in this modeling effort. To avoid the possible situation where the system is undetermined in the Modified Quasi-chemical Model (MQM) used by Thermochimica for Molten Salts as explained in [!citep](ChemPotInterp), the noble gas fission products (i.e., Kr, Xe, Ne) were added to the MSTDB-TC V2.0. This ensures that the presence of an ideal gas phase is correctly predicted due to fission gas generation with the explicit assumption that these noble gas elements do not interact with the molten fluoride phase. Therefore, when a chemical equilibrium is predicted by Thermochimica that contains multiple phases (ideal gas, molten salt fluoride liquid, or solid alloys) it is sufficiently determined.

## Spatially Resolved Thermochemical Model

With Thermochimica wrapped within MOOSE, the ability to perform various thermochemical analyses of MSRs with other multiphysics analyses now exists. The new multiphysics framework is shown in [neams_framework]. Here various physics calculations and reactor characteristics are modeled and passed between Griffin, Pronghorn, and Thermochimica within the MOOSE multiphysics framework.

!media msr/msfr/thermochemistry/neamsframework.png
       style=width:70%;margin:auto
       id=neams_framework
       caption=NEAMS based multiphysics framework for MSR analysis [!citep](FrameworkM3).


The first example to illustrate this coupling is modeling spatially resolved thermochemical solution of the MSFR at steady-state operation (i.e., Griffin+Pronghorn+Thermochimica). Here the input file `thermo.i` which calls Thermochimica within MOOSE is shown below and discussed. Additionally, the ability to perform Depletion-driven, spatially-resolved thermochemistry is also discussed.

!listing msr/msfr/thermochemistry/thermo.i

#### Mesh

First the `Mesh` block is discussed. Here the mesh is loaded from a restart file `steady/restart/run_ns_coupled_restart`. This allows for the Griffin+Pronghorn steady-state computational domain and thermal hydraulic solution (i.e. Pressure and Temperature) to be loaded in for use in this follow on or sub application.

!listing msr/msfr/thermochemistry/thermo.i block=Mesh

#### GlobalParams

The `GlobalParams` block is used to set up the general information required for the problem that will be used throughout the input file. Here the elements used in the thermochemical solution are listed which include the base fuel salt elements (i.e. F, Li, U, Th) corrosion elements (i.e., Ni) and fission/activation product elements (i.e. Nd, Ce, La, Cs, Xe, I, Kr, Ne).

!listing msr/msfr/thermochemistry/thermo.i block=GlobalParams

Then `output_phases` are selected. The option to select `All` is present, however this will likely generate several empty phases that exist in the MSTDB database but are not stable in the solution. This may be helpful for a first run to determine the names of phases that are present. Here the `MSFL`, `gas_ideal`, `Ni_Solid_FCC(s)`, and `U_solid-A(s)` phases are chosen although U_solid-A(s) will not be present since the amount of uranium fuel present given the temperature and pressure is completely dissolved in the fuel salt as anticipated.

Next `output_species` can be selected which specifies the species within the phases that should be returned to the user. Here various ion pairs in the MSFL phase are selected, along with some key radionuclide species in the ideal_gas phase.

Next the `output_element_potentials` produces the chemical potentials of all elements in the solution so the fluorine or iodine potential can be visualized throughout the reactor given the temperature, pressure, and element field.

Lastly, if a stable ideal_gas phase is not present, the `output_vapor_pressures` can also be selected which will determine the vapor pressures of elements in the liquid MSFL phase given there is a liquid-gas interface present.

It should be noted that this block creates AuxVariables of these inputs and ouputs defined here and can be manipulated and exported to an exodus file for viewing.

#### Chemical Composition

Next, the `ChemicalComposition` block is used to set up the Thermochimica calculation and is described in more detail [here](https://mooseframework.inl.gov/source/actions/ChemicalCompositionAction.html). First the modified MSTDB V2.0 with noble gas data file is specified, and the temperature, pressure, and mass unites as chosen.

!listing msr/msfr/thermochemistry/thermo.i block=ChemicalComposition

Next, the auxiliary variables of the temperature and pressure are specified as `tfuel_nod` and `pressure_nod` respetively. It should be noted that the element Auxiliary variables were already declared in the `GlobalParams` block. Lastly, a `reinitilization_type` is specified to use cached Thermochimica solutions to speed up calculations.

#### Auxiliary Variables

The `AuxiliaryVariables` block is used to set up any additional auxiliary variables that are needed for the calculation. Here we set up the temperature `tfuel` and pressure `pressure` of the fuel salt. These are `CONSTANT Monomials` corresponding to MOOSE Finite Volume variables which are initialized by the `initial_from_file_var` command from the exodus restart file defined in the `Mesh` block.

!listing msr/msfr/thermochemistry/thermo.i block=AuxVariables

Currently, the implementation of Thermochimica in MOOSE computes nodal values, so these finite volume variables must be converted to nodal variables which are the `tfuel_nod` and `pressure_nod` variables respectively. These variables are then used in the `ChemicalComposition` block.

#### Auxiliary Kernels

Correspondingly, the `AuxiliaryKernels` block sets up functors which will operate on the auxiliary variables. In this case, since a conversion from the finite volume variables to nodal variables is required, the `ProjectionAux` is used to perform this transformation. This is executed on `Initial` so that the nodal version of the variables are ready for the Thermochimica calculation.

!listing msr/msfr/thermochemistry/thermo.i block=AuxKernels

#### Initial Conditions

Next, the `Initial Conditions` block sets up the initial conditions for various Auxiliary variables. In this case, the element variables are set through a `FunctionIC` which calculates a homogenous molar distribution from a depletion calculation and will be discussed shortly.

!listing msr/msfr/thermochemistry/thermo.i block=ICs

#### Problem

The `Problem` block is used here to tell MOOSE that a finite element solve is not required, since a MOOSE-wrapped application via `UserObject` is being used instead. Additionally, the `allow_initial_conditions_with_restart` argument is used to allow for reading in the temperature and pressure variables from the multiphysics restart file.

!listing msr/msfr/thermochemistry/thermo.i block=Problem

#### Postprocessors

Next, the largest block of the input, the `Postprocessors` block is used to calculate the homogenous element distributions from a previous depletion calculation in a CSV file. Additionally, various total elements or species of interest can be calculated here.

Here each nuclide density in $[atoms/(b-cm)]$ is read from a `VectorPostProcessor` named `reader` (discussed in the `VectorPostprocessors` block) at a specific burnup index. In order to visualize the depletion-driven, spatially-resolved thermochemical effect, the user can replace the `index = 0` value with a later index point to model how the solution changes throughout depletion.

Admittedly, this is a clunky method of passing information, and current efforts are streamlining nuclide, element, and species accounting for MSR analyses within the MOOSE framework. This will allow for a more user friendly interface between online Griffin-depletion coupling with Thermochimica + Pronghorn for depletion-driven, spatially-resolved thermochemistry modeling and simulation. Therefore, this model will likely be updated in the near term future with a more efficient streamlined version.

!listing msr/msfr/thermochemistry/thermo.i block=Postprocessors

#### Functions

Next, the `Functions` block sums the nuclide densities and then converts to molar densities for the Thermochimica calculation. These homogenous and constant functions are then used to initialize the Element distributions in the `ICs` block.

It should be noted that this is assuming the fuel salt is a homogenous well mixed solution. More detailed models could be used to incorporate the feedback of density changes due to temperature from the thermal hydraulics model, and explicit nuclide species tracking due to mass transfer throughout the loop. Nuclide distributions can be correspondingly summed into element distributions while retaining the spatial distribution calculated by the thermal hydraulics model. Future models uploaded to the VTB will incorporate these more detailed aspects of chemical species tracking in MSRs.

!listing msr/msfr/thermochemistry/thermo.i block=Functions

#### Vector Postprocessors

Lastly, the `Vector Postprocessors` block is used to read in the CSV file previously calculated by Griffin-depletion `run_dep_out_in-core_number_densities.csv`. This is executed with a `force_preic` since this "Vector Postprocessor" should be run even before initial coniditions are executed to correctly perform the summation and conversion of nuclide densities to element molar densities. The user could provide any CSV file generated from other micro depletion calculations here instead.

!listing msr/msfr/thermochemistry/thermo.i block=VectorPostprocessors
