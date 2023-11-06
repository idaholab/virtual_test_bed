# Molten Salt Reactor Experiment (MSRE) Multiphysics Model

*Contact: Mauricio Tano, mauricio.tanoretamales\@inl.gov*

*Model summarized, documented, and uploaded by Andres Fierro*

*Model link: [Griffin-Pronghorn Transient Model](https://github.com/idaholab/virtual_test_bed/tree/devel/msr/msre/multiphysics_core_model/transient)*

!tag name=MSRE Griffin-Pronghorn Transient Model pairs=reactor_type:MSR
                       reactor:MSRE
                       geometry:core
                       simulation_type:core_multiphysics
                       input_features:multiapps
                       code_used:BlueCrab
                       computing_needs:Workstation
                       fiscal_year:2023

This Transient model builds off of the existing Steady state model. Here only the difference will be highlighted to perform the transient analysis.

## Neutronics Transient Model

<!-- Double Check this Section Mauricio - Could write a short description how you "fake" the control rod movement and where this is done in the code?-->

#### User Objects

In order to start our transient, we need to load in the `UserOjbects` from the steady state solution. Both the `transport_solution_s1` and `auxvar_solution_s1` are loaded from the steady state files.

!listing msr/msre/multiphysics_core_model/transient/neu.i block=UserObjects

#### Executioner

Here the `Executioner` block sets is set to Transient, and the numerical method is changed from PJFNKMO to PJFNK. Additionally, the `TimeStepper` is used to determine how the neutronics solution steps through time during the transient.

!listing msr/msre/multiphysics_core_model/transient/neu.i block=Executioner

Here we add the time derivative to the multi-group diffusion equation, and to the delayed neutron precursor group equations to arrive at the following:

\begin{equation} \label{eq:time_eigen}
\frac{1}{v_g} \frac{\partial \phi_g(\mathbf{r}, t)}{\partial t} -\nabla \cdot D_g(\mathbf{r}, t) \nabla \phi_g(\mathbf{r}, t) + \Sigma_{rg} \phi_g(\mathbf{r}, t) = \frac{1 - \beta_0}{k_{\text{eff}}^{\text{st}}} \chi_{p,g} \sum_{g'=1}^G (\nu\Sigma_{f})_{g'} \phi{g'}(\mathbf{r}, t) + \sum_{g' \neq g}^G \Sigma_{sg'} \phi_{g'}(\mathbf{r}, t) + \chi_{d,g} \sum_{i=1}^m \lambda_i c_i(\mathbf{r}, t),
\end{equation}

\begin{equation} \label{eq:time_prec}
\frac{\partial c_i(\mathbf{r}, t)}{\partial t} + \nabla \cdot (\mathbf{u} c_i(\mathbf{r}, t)) - \nabla \cdot H_i \nabla c_i(\mathbf{r}, t) - \nabla \cdot \frac{\nu_t}{Sc_t} \nabla c_i(\mathbf{r}, t) = \frac{\beta_0}{k_{\text{eff}}^{\text{st}}} \chi_{p,g} \sum_{g'=1}^G (\nu\Sigma_{f})_{g'} \phi{g'}(\mathbf{r}, t) - \lambda_i c_i(\mathbf{r}, t),
\end{equation}

where $t$ is time, $k_{\text{eff}}^{\text{st}}$ is the steady-state eigenvalue coming from a previous steady-state solve, and $v_g$ is the neutron speed for group $g$. For most practical cases, except for prompt critical reactivity insertions, the term $\frac{1}{v_g} \frac{\partial \phi_g(\mathbf{r}, t)}{\partial t}$ can be neglected. This model is complemented by the solution of thermal-hydraulcis, which determines the advection field for neutron precursors and the temperature field for cross section interpolation.

#### Multi Apps

Finally, the `MultiApps` block is altered to a `TransientMultiApp` solution.

!listing msr/msre/multiphysics_core_model/transient/neu.i block=MultiApps

## Thermal Hydraulics Transient Model

#### Mesh

Here the Mesh block loads in a restart file to correctly initialize the transient.

!listing msr/msre/multiphysics_core_model/transient/th.i start=[Mesh] end=[Problem]

#### Variables

Similarly, this block initializes these variables from the restart file with the `initial_from_file_var` option.

!listing msr/msre/multiphysics_core_model/transient/th.i start=[Variables] end=[FVKernels]

#### Aux Variables

Here too, the Aux Variables are also re-initialized from the restart file.

!listing msr/msre/multiphysics_core_model/transient/th.i start=[AuxVariables] end=[AuxKernels]

#### Executioner

Finally, the Executioner block is altered to run a `Transient` simulation. Additionally, the `TimeStepper` options determine how the thermal hydraulic simulation will run and when the simulation ends.

!listing msr/msre/multiphysics_core_model/transient/th.i start=[Executioner] end=[Outputs]
