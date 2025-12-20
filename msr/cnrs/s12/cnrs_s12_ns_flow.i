# ==============================================================================
# Model description
# ------------------------------------------------------------------------------
# CNRS Benchmark model Created & modifed by Dr. Mustafa Jaradat and Dr. Namjae Choi
# November 22, 2022
# Step 1.2: Power coupling
# ==============================================================================
#   Tiberga, et al., 2020. Results from a multi-physics numerical benchmark for codes
#   dedicated to molten salt fast reactors. Ann. Nucl. Energy 142(2020)107428.
#   URL:http://www.sciencedirect.com/science/article/pii/S0306454920301262
# ==============================================================================

rho   = 2.0e+3
cp    = 3.075e+3
k     = 1.0e-3
mu    = 5.0e+1
geometric_tolerance = 1e-3
cavity_l = 2.0
lid_velocity = 0.5

# No turbulence model, hence unused
# Sc_t =  2.0e8

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

[AuxVariables]
  [U]
    order = CONSTANT
    family = MONOMIAL
    fv = true
    [AuxKernel]
      type = VectorMagnitudeAux
      x = vel_x
      y = vel_y
    []
  []
  [power_density]
    type = MooseVariableFVReal
  []
[]

[Physics]
  [NavierStokes]
    [Flow]
      [flow]
        compressibility = 'incompressible'

        density = ${rho}
        dynamic_viscosity = 'mu'

        # Boussinesq parameters
        boussinesq_approximation = false
        gravity = '0 -9.81 0'

        # Initial conditions
        initial_velocity = '0.5 0 0'
        initial_pressure = 1e5

        # Boundary conditions
        wall_boundaries = 'left right bottom top'
        momentum_wall_types = 'noslip noslip noslip noslip'
        momentum_wall_functors = '0 0; 0 0; 0 0; lid_function 0'

        pin_pressure = true
        pinned_pressure_type = average
        pinned_pressure_value = 1e5

        # Numerical Scheme
        momentum_advection_interpolation = 'upwind'
        mass_advection_interpolation = 'upwind'
      []
    []
    [FluidHeatTransfer]
      [energy]
        initial_temperature = 900
        thermal_conductivity = 'k'
        specific_heat = 'cp'

        # Boundary conditions
        energy_wall_types = 'heatflux heatflux fixed-temperature fixed-temperature'
        energy_wall_functors = '0 0 0 1'

        # Volumetric heat sources and sinks
        ambient_temperature = 900
        ambient_convection_alpha = 1e6
        external_heat_source = power_density

        # Numerical Scheme
        energy_advection_interpolation = 'upwind'
        energy_two_term_bc_expansion = true
        energy_scaling = 1e-3
      []
    []
    [ScalarTransport]
      [all]
        # passive scalar
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

        # Boundary conditions
        passive_scalar_inlet_types          = 'fixed-value fixed-value fixed-value fixed-value
                                              fixed-value fixed-value fixed-value fixed-value'
        passive_scalar_inlet_functors       = '1.0; 1.0; 1.0; 1.0;
                                              1.0; 1.0; 1.0; 1.0'

        # Numerical scheme
        passive_scalar_advection_interpolation = 'upwind'
        system_names = 's1 s2 s3 s4 s5 s6 s7 s8'

      []
    []
  []
[]

[Problem]
  nl_sys_names = 'nl0 s1 s2 s3 s4 s5 s6 s7 s8'
[]

[AuxVariables]
  [fission_source]
    type = MooseVariableFVReal
  []
[]

[FunctorMaterials]
  [functor_constants]
    type = ADGenericFunctorMaterial
    prop_names = 'cp k mu rho'
    prop_values = '${cp} ${k} ${mu} ${rho}'
  []
[]

[Functions]
  [lid_function]
    type = ParsedFunction
    expression = 'if (x > ${geometric_tolerance}, if (x < ${fparse cavity_l - geometric_tolerance}, ${lid_velocity}, 0.0), 0.0)'
  []
[]

[Executioner]
# Solving the steady-state versions of these equations
  type = Steady
  solve_type = 'NEWTON'
  #line_search = 'none'
  petsc_options_iname = '-pc_type -pc_factor_shift_type -pc_factor_mat_solver_package'
  petsc_options_value = 'lu NONZERO superlu_dist'
  nl_rel_tol = 1e-12
[]

[Outputs]
  exodus = true
[]

