# Phase 0 Model: Steady State Single Physics

*Contact: Mustafa Jaradat, Mustafa.Jaradat@inl.gov*

*Model summarized and documented by Khaldoon Al-Dawood

*Model link: [Griffin-Pronghorn Steady-State Model](https://github.com/idaholab/virtual_test_bed/tree/devel/msr/cnrs/s01)*

!tag name=CNRS Griffin-Pronghorn Steady State Model pairs=reactor_type:MSR
                       reactor:MSRE
                       geometry:core
                       simulation_type:multiphysics
                       transient:steady_state
                       input_features:multiapps
                       codes_used:BlueCrab;Griffin;Pronghorn
                       computing_needs:Workstation
                       fiscal_year:2024
                       institution:INL
                       sponsor:NEAMS;NRIC

This exercise is comprized of three stady state single physics steps.
The inputs provided in this step will be gradually improved as the complexity of 
the steps will improve.
In the following is a description of each stepa of Phase 0 in addition to explanation
of the input files.

## Step 0.1:

The purpose of this exercise is to calculate the steady state velocity field given a
fixed lid velocity.
This problem is solved using pronghorn software which uses the Navier-Stokes module 
in MOOSE.
The conservation of mass principle is expressed as

$\nabla.\vec{u} = 0$

where $\vec{u}$ is the velocity vector.

The mass conservation equation is automatically called in MOOSE upon calling 

!listing msr/cnrs/s01/cnrs_s01_ns_flow.i block=Module

```
[Module]
  [NavierstokesFV]
  compressibility = 'incompressible'
  ...
```

The conservation of momentum is expressed in

$\frac{\partial \vec{u}}{\partial t} + \vec{u}.\nabla \vec{u} = -\frac{1}{\rho_\circ} \nabla p + \mu\nabla^2\vec{u} + \vec{g}\left(1-\alpha\left(T-T_\circ\right)\right)$

where $p$ is pressure, $\mu$ is the viscosity, $\vec{g}$ is the gravity vector, $T$ is the temperature, and $\alpha$ is the thermal expansion coefficient.

Finally, the conservation of energy is expressed as

$\rho_\circ c_p \frac{\partial T}{\partial t} + \rho_\circ \vec{u}.\nabla T = \kappa_f \nabla^2T + q^{\prime \prime \prime}$

The model starts by defining some fluid properties as follows

```
alpha = 2.0e-4
rho   = 2.0e+3
cp    = 3.075e+3
k     = 1.0e-3
mu    = 5.0e+1
```

The problem has a simple geometry.
Thus the mesh description is as simple as follows

```
[Mesh]
  type = MeshGeneratorMesh
  block_id = '1'
  block_name = 'cavity'
  [cartesian_mesh]
    type = CartesianMeshGenerator
    dim = 2
    dx = '1.0 1.0'
    ix = '100 100'
    dy = '1.0 1.0'
    iy = '100 100'
    subdomain_id = ' 1 1
                     1 1'
  []
[]
```

The modeling of the momentum and energy equation and the setup are presented to the NavierStokesFV block as follows

```
[Module]
  [NavierStokesFV]
    compressibility = 'incompressible'
    add_energy_equation = true
    boussinesq_approximation = true

    density = ${rho}
    dynamic_viscosity = 'mu'
    thermal_conductivity = 'k'
    specific_heat = 'cp'
    thermal_expansion = ${alpha}

    # Boussinesq parameters
    gravity = '0 -9.81 0'

    # Initial conditions
    initial_velocity = '0.5 0 0'
    initial_temperature = 900
    initial_pressure = 1e5
    ref_temperature = 900
    
    # Boundary conditions
    inlet_boundaries = 'top'
    momentum_inlet_types = 'fixed-velocity'
    momentum_inlet_function = '0.5 0'
    energy_inlet_types = 'fixed-temperature'
    energy_inlet_function = 900

    wall_boundaries = 'left right bottom'
    momentum_wall_types = 'noslip noslip noslip'
    energy_wall_types = 'heatflux heatflux heatflux'
    energy_wall_function = '0 0 0'

    pin_pressure = true
    pinned_pressure_type = average
    pinned_pressure_value = 1e5

    # Numerical Scheme
    energy_advection_interpolation = 'upwind'
    momentum_advection_interpolation = 'upwind'
    mass_advection_interpolation = 'upwind'
    
    energy_two_term_bc_expansion = true
    energy_scaling = 1e-3
  []
[]
```
This block defines lots of characteristics of the fluid modeling including the 
utilization of energy equation, boundary conditions, numerical scheme, and so on.

Fluid properties to support the modeling process can be defined in the ```Material``` block.
As in the following, the ```Materials``` block uses defined material properties
provided in the beginning of the input file as described above.

```
[Materials]
  [functor_constants]
    type = ADGenericFunctorMaterial
    prop_names = 'k rho mu'
    prop_values = '${k} ${rho} ${mu}'
  []
  [cp]
    type = ADGenericFunctorMaterial
    # prop_names = 'cp dcp_dt'
    # prop_values = '${cp} 0'
    prop_names = 'cp'
    prop_values = '${cp}'
  []
[]
```

To obtain the steady state solution, the problem is solved as a transient that is 
run for a long time to aciheve the steady state conditions.
This detail is specified in the ```Executioner``` block as presented in
the following block of input file

```
[Executioner]
  type = Transient
  start_time = 0.0
  end_time = 10000
  [TimeStepper]
    type = IterationAdaptiveDT
    dt = 0.1  # chosen to obtain convergence with first coupled iteration
    growth_factor = 2
  []
  steady_state_detection  = true
  steady_state_tolerance  = 1e-8
  steady_state_start_time = 10
  solve_type = 'NEWTON'
  petsc_options_iname = '-pc_type -pc_factor_shift_type'
  petsc_options_value = 'lu NONZERO'
  line_search = 'none'
  nl_rel_tol = 1e-7
  nl_abs_tol = 2e-7
  nl_max_its = 200
  l_max_its = 200
  automatic_scaling = true
[]
```

## Step 0.2:

This exercise models a steady state neutronic solution using griffin.
The problem gemetry remains the same as step 0.1.
The mesh is defined in a similar fashion to the earlier presentation.

```
[Mesh]
  type = MeshGeneratorMesh
  block_id = '1'
  block_name = 'cavity'
  [cartesian_mesh]
    type = CartesianMeshGenerator
    dim = 2
    dx = '1.0 1.0'
    ix = '100 100'
    dy = '1.0 1.0'
    iy = '100 100'
    subdomain_id = ' 1 1
                     1 1'
  []
  [assign_material_id]
    type = SubdomainExtraElementIDGenerator
    input = cartesian_mesh
    extra_element_id_names = 'material_id'
    subdomains = '1'
    extra_element_ids = '1'
  []
[]
```

The input calculates the uses the fuel temperature to adjust the fuel density
according to the expression

$\text{Fuel Density Fraction} = 1.0 - 0.0002\times (T_\text{fuel}-900)$

Although this adjustment of density is not useful in this step, it will be useful in the next step of the benchmark
where the obtained temperature distribution is used to adjust the fuel salt density.

The eigenvalue solution of the multigroup neutron diffusion equation is implemented
with six energy groups and 8 delayed neutron precursor groups are used.
The neutronic solution instructinos are defined in the ```TransportSystems``` block
as in the following

```
[TransportSystems]
  particle = neutron
  equation_type = eigenvalue
  G = 6
  VacuumBoundary = 'left bottom right top'
  [diff]
    scheme = CFEM-Diffusion
    n_delay_groups = 8
    family = LAGRANGE
    order = FIRST
    assemble_scattering_jacobian = true
    assemble_fission_jacobian = true
  []
[]
```

Characteristics that guide running the simulation such as the type of solver
and the tolerences are defined in the ```Executioner``` block

```
[Executioner]
  type = Eigenvalue
  solve_type = PJFNK
  petsc_options_iname = '-pc_type -pc_factor_shift_type'
  petsc_options_value = 'lu NONZERO'
  free_power_iterations = 2
  line_search = none #l2
  l_max_its = 200
  l_tol = 1e-3
  nl_max_its = 200
  nl_rel_tol = 1e-6
  nl_abs_tol = 1e-8
[]
```

## Step 0.3

In this exercise, the velicity field solution obtained in Phase 0.1 and the power 
distribution obtained in Phase 0.2 are used to perform a steady state temperature distribution.
This requires a Navier-Stokes solve to obtain the velocity field and a neutronic
solve to obtain the power density distribution.
The main input in this step is referred defines an input that performs the linking between 
the neutronic solve and the Navier-Stokes solve.
The main file defines a set ov variables as follows

```
[Variables]
  [vel_x]
    type = INSFVVelocityVariable
  []
  [vel_y]
    type = INSFVVelocityVariable
  []
  [pressure]
    type = INSFVPressureVariable
  []
  [T_fluid]
    type = INSFVEnergyVariable
    initial_condition = 900.0
  []
  [lambda]
    family = SCALAR
    order = FIRST
  []
[]
```
The main input also requests auxiliary variables to be the constant velocity at 
the cavity lid and the power density distribution which is obtained using a neutronic
solve 

```
[AuxVariables]
  [U]
    order = CONSTANT
    family = MONOMIAL
    fv = true
  []
  [power_density]
    type = MooseVariableFVReal
  []
[]
```

The main input also defines the problem boundary conditions as follows

```
[FVBCs]
  [top_x]
    type = INSFVNoSlipWallBC
    variable = vel_x
    boundary = 'top'
    function = 'lid_function'
  []

  [no_slip_x]
    type = INSFVNoSlipWallBC
    variable = vel_x
    boundary = 'left right bottom'
    function = 0
  []

  [no_slip_y]
    type = INSFVNoSlipWallBC
    variable = vel_y
    boundary = 'left right top bottom'
    function = 0
  []

  [T_hot]
    type = FVDirichletBC
    variable = T_fluid
    boundary = 'bottom'
    value = 1
  []

  [T_cold]
    type = FVDirichletBC
    variable = T_fluid
    boundary = 'top'
    value = 0
  []
[]
```

The input also defines a ```MultiApps``` block calling two other inputs.
One used to perform the 

```
[MultiApps]
  [ns_flow]
    type = FullSolveMultiApp
    input_files = cnrs_s01_ns_flow.i
    execute_on = 'initial'
  []
  [griffin_neut]
    type = FullSolveMultiApp
    input_files = cnrs_s02_griffin_neutronics.i
    execute_on = 'timestep_end'
  []
[]
```

Where ```ns_flow``` is the input for the Navier-Stokes solve and ```griffin_neut```
is the input for the neutronic solve.
The data transfer between the neutronic solve and the Navier-Stokes solve is defined 
as 

```
[Transfers]
  [x_vel]
    type = MultiAppCopyTransfer
    from_multi_app = ns_flow
    source_variable = 'vel_x'
    variable = 'vel_x'
    execute_on = 'initial'
  []
  [y_vel]
    type = MultiAppCopyTransfer
    from_multi_app = ns_flow
    source_variable = 'vel_y'
    variable = 'vel_y'
    execute_on = 'initial'
  []
  [pres]
    type = MultiAppCopyTransfer
    from_multi_app = ns_flow
    source_variable = 'pressure'
    variable = 'pressure'
    execute_on = 'initial'
  []
  [power_dens]
    type = MultiAppCopyTransfer
    from_multi_app = griffin_neut
    source_variable = 'power_density'
    variable = 'power_density'
    execute_on = 'timestep_end'
  []
  [temp]
    type = MultiAppCopyTransfer
    to_multi_app = griffin_neut
    source_variable = 'T_fluid'
    variable = 'tfuel'
    execute_on = 'timestep_end'
  []
[]
```

notice that the Navier-Stokes solve is expected to provide the velocity field.
The neutronic solve is expected to provide the power density distribution and takes
the fuel temperature distribution as an input.
Note that the fuel temperature is used to adjust the density but it is not used to
update the cross section.

The characteristics of the coupled solve are specified in the ```Executioner```
block as follows

```
[Executioner]
  type = Steady
  solve_type = 'NEWTON'
  #line_search = 'none'
  petsc_options_iname = '-pc_type -pc_factor_shift_type'
  petsc_options_value = 'lu NONZERO'
  nl_rel_tol = 1e-12
  fixed_point_min_its = 2
  fixed_point_max_its = 50
  fixed_point_rel_tol = 1e-5
  fixed_point_abs_tol = 1e-6
[]
```

The neutronic solution input is similar to the one described in Step 0.2.
