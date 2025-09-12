# ==============================================================================
# Model description
# ------------------------------------------------------------------------------
# CNRS Benchmark model Created & modifed by Dr. Mustafa Jaradat and Dr. Namjae Choi
# November 22, 2022
# Step 2.1: Time dependent coupling
# ==============================================================================
#   Tiberga, et al., 2020. Results from a multi-physics numerical benchmark for codes
#   dedicated to molten salt fast reactors. Ann. Nucl. Energy 142(2020)107428.
#   URL:http://www.sciencedirect.com/science/article/pii/S0306454920301262
# ==============================================================================

alpha = 2.0e-4
rho   = 2.0e+3
cp    = 3.075e+3
k     = 1.0e-3
mu    = 5.0e+1

# Sc_t =  2.0e8
Ulid = 0.5

lambda0 = 1.24667E-02
lambda1 = 2.82917E-02
lambda2 = 4.25244E-02
lambda3 = 1.33042E-01
lambda4 = 2.92467E-01
lambda5 = 6.66488E-01
lambda6 = 1.63478E+00
lambda7 = 3.55460E+00

beta0   =  2.33102e-4
beta1   =  1.03262e-3
beta2   =  6.81878e-4
beta3   =  1.37726e-3
beta4   =  2.14493e-3
beta5   =  6.40917e-4
beta6   =  6.05805e-4
beta7   =  1.66016e-4

frequency = 0.125

[Mesh]
  [fmg]
    type = FileMeshGenerator
    file = '../s14/cnrs_s14_griffin_neutronics_out_ns_flow0.e'
    use_for_exodus_restart = true
  []
[]


[Physics]
  [NavierStokes]
    [Flow]
      [all]
        compressibility = 'incompressible'
        density = ${rho}
        dynamic_viscosity = 'mu'

        # Restart parameters
        initialize_variables_from_mesh_file = true

        # Boussinesq parameters
        boussinesq_approximation = true
        gravity = '0 -9.81 0'
        thermal_expansion = ${alpha}
        ref_temperature = 900

        # Initial conditions
        initial_velocity = '${Ulid} 0 0'
        initial_pressure = 1e5

        # Boundary conditions
        # Note: we could do a no-slip with a wall velocity, same
        inlet_boundaries = 'top'
        momentum_inlet_types = 'fixed-velocity'
        momentum_inlet_functors = '${Ulid} 0'

        wall_boundaries = 'left right bottom'
        momentum_wall_types = 'noslip noslip noslip'

        # Pressure pin
        pin_pressure = true
        pinned_pressure_type = average
        pinned_pressure_value = 1e5

        # Numerical Scheme
        momentum_advection_interpolation = 'upwind'
        mass_advection_interpolation = 'upwind'
      []
    []
    [FluidHeatTransfer]
      [all]
        initial_temperature = 900

        # Restart parameters
        initialize_variables_from_mesh_file = true

        # Material properties
        thermal_conductivity = 'k'
        specific_heat = 'cp'

        # Boundary conditions
        energy_inlet_types = 'fixed-temperature'
        energy_inlet_functors = 900
        energy_wall_types = 'heatflux heatflux heatflux'
        energy_wall_functors = '0 0 0'

        # Heat source
        external_heat_source = power_density

        ambient_convection_alpha = 1.0e+6
        ambient_temperature = 900.0

        # Numerical Scheme
        energy_advection_interpolation = 'upwind'
        energy_two_term_bc_expansion = true
        energy_scaling = 1e-3
      []
    []
    [ScalarTransport]
      [scalars]
        # Restart parameters
        initialize_variables_from_mesh_file = true

        passive_scalar_names                = 'dnp0 dnp1 dnp2 dnp3
                                              dnp4 dnp5 dnp6 dnp7'
        passive_scalar_coupled_source       = 'fission_source dnp0; fission_source dnp1;
                                              fission_source dnp2; fission_source dnp3;
                                              fission_source dnp4; fission_source dnp5;
                                              fission_source dnp6; fission_source dnp7'
        passive_scalar_coupled_source_coeff = '${beta0} ${fparse -lambda0}; ${beta1} ${fparse -lambda1};
                                              ${beta2} ${fparse -lambda2}; ${beta3} ${fparse -lambda3};
                                              ${beta4} ${fparse -lambda4}; ${beta5} ${fparse -lambda5};
                                              ${beta6} ${fparse -lambda6}; ${beta7} ${fparse -lambda7}'
        passive_scalar_inlet_types          = 'fixed-value fixed-value fixed-value fixed-value
                                              fixed-value fixed-value fixed-value fixed-value'
        passive_scalar_inlet_functors       = '1.0; 1.0; 1.0; 1.0;
                                              1.0; 1.0; 1.0; 1.0'

        # Numerical parameters
        system_names= 's1 s2 s3 s4 s5 s6 s7 s8'
        passive_scalar_advection_interpolation = 'upwind'
      []
    []
  []
[]

[Problem]
  nl_sys_names = 'nl0 s1 s2 s3 s4 s5 s6 s7 s8'
[]

[AuxVariables]
  [power_density]
    type = MooseVariableFVReal
    initial_from_file_var = power_density
    initial_from_file_timestep = LATEST
  []
  [fission_source]
    type = MooseVariableFVReal
    initial_from_file_var = fission_source
    initial_from_file_timestep = LATEST
  []
[]

[Functions]
  [alpha_val]
     type = ParsedFunction
     expression = '1.0e+6*(1.0 + 0.1*sin(2.0*pi*${frequency}*t))' #  'alpha_0*(1.0 + a*sin(fq*t))'
  []
[]

[FunctorMaterials]
  [functor_constants]
    type = ADGenericFunctorMaterial
    prop_names = 'k rho mu'
    prop_values = '${k} ${rho} ${mu}'
  []
  [cp]
    type = ADGenericFunctorMaterial
    prop_names = 'cp'
    prop_values = '${cp}'
  []
  [alpha_t]
    type = ADGenericFunctorMaterial
    prop_names =  'alpha_t'
    prop_values = alpha_val
    block = '1'
  []
[]

[Debug]
  show_var_residual_norms = False
[]

[Postprocessors]
  [dt]
    type = TimestepSize
  []
  [Tfuel_avg]
    type = ElementAverageValue
    variable = T_fluid
  []
[]

[Executioner]
  type = Transient
  start_time = 0.0
  dt = ${fparse max(0.005, 0.05*0.0125/frequency)}
  end_time = ${fparse 10/frequency}
  #[TimeStepper]
  #  type = IterationAdaptiveDT
  #  dt = 0.1
  #  growth_factor = 2
  #[]
  solve_type = 'NEWTON'
  petsc_options_iname = '-pc_type -pc_factor_shift_type -pc_factor_mat_solver_package'
  petsc_options_value = 'lu NONZERO superlu_dist'
  line_search = l2#'none'
  nl_rel_tol = 1e-6
  nl_abs_tol = 2e-8
  nl_max_its = 200
  l_max_its = 200
  automatic_scaling = true
[]

[Outputs]
  exodus = false
  csv = true
  print_linear_converged_reason = false
  print_linear_residuals = false
  print_nonlinear_converged_reason = false
[]

