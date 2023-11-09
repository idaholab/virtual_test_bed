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

With Thermochimica wrapped within MOOSE, the ability to perform various thermochemical analyses of MSRs with other multiphysics analyses now exists. The first example to illustrate this coupling is modeling spatially resolved thermochemical solution of the MSFR at steady-state operation. Here the input file `thermo.i` which calls Thermochimica within MOOSE is shown below and discussed.

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
