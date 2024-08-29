# ==============================================================================
# Model description
# ------------------------------------------------------------------------------
# CNRS Benchmark model Created & modifed by Dr. Mustafa Jaradat and Dr. Namjae Choi
# November 22, 2022
# Step 0.1: Velocity field
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

Sc_t =  2.0e8

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

[Modules]
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
    
    # passive scalar -- solved in the multiapp because is much faster
    add_scalar_equation                 = true
    passive_scalar_names                = 'dnp0 dnp1 dnp2 dnp3 
                                           dnp4 dnp5 dnp6 dnp7'
    passive_scalar_schmidt_number       = '${Sc_t} ${Sc_t} ${Sc_t} ${Sc_t} 
                                          ${Sc_t} ${Sc_t} ${Sc_t} ${Sc_t}'
    passive_scalar_coupled_source       = 'fission_source dnp0; fission_source dnp1; 
                                           fission_source dnp2; fission_source dnp3; 
                                           fission_source dnp4; fission_source dnp5;
                                           fission_source dnp6; fission_source dnp7;'
    passive_scalar_coupled_source_coeff = '${beta0} ${fparse -lambda0}; ${beta1} ${fparse -lambda1};
                                           ${beta2} ${fparse -lambda2}; ${beta3} ${fparse -lambda3}; 
                                           ${beta4} ${fparse -lambda4}; ${beta5} ${fparse -lambda5};
                                           ${beta6} ${fparse -lambda6}; ${beta7} ${fparse -lambda7};'
    passive_scalar_advection_interpolation = 'upwind'
    passive_scalar_inlet_types          = 'fixed-value fixed-value fixed-value fixed-value
                                           fixed-value fixed-value fixed-value fixed-value'
    passive_scalar_inlet_function       = '1.0; 1.0; 1.0; 1.0;
                                           1.0; 1.0; 1.0; 1.0;'
  []
[]

[AuxVariables]
  [fission_source]
    type = MooseVariableFVReal
  []
[]

[Materials]
  [functor_constants]
    type = ADGenericFunctorMaterial
    prop_names = 'k rho mu'
    prop_values = '${k} ${rho} ${mu}'
  []
  [cp]
    type = ADGenericFunctorMaterial
    prop_names = 'cp dcp_dt'
    prop_values = '${cp} 0'
  []
[]

[Debug]
  show_var_residual_norms = True
[]

[Postprocessors]
  [Tfuel_avg]
    type = ElementAverageValue
    variable = T_fluid
  []
[]

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

[Outputs]
  exodus = true
[]

