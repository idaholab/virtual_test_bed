# ==============================================================================
# PBMR-400 steady-state phase 1 exercise 3, NEA/NSC/DOC(2013)10.
# SUBAPP1 MAIN1 thermal-hydraulics model, power supplied by NK MAIN0 app.
# FENIX input file
# ------------------------------------------------------------------------------
# Idaho Falls, Idaho National Laboratory, 02/03/2020
# Author(s): Dr. Paolo Balestra, Dr. Sebastian Schunert
# If using or referring to this model, please cite as explained in
# https://mooseframework.inl.gov/virtual_test_bed/citing.html
# ==============================================================================
# - ss1: Steady state simulation main app level 1
# - phth: ProngHorn for thermal hydraulics
# - lgcy: Legacy kernels
# - supmix: Mixed superficial variables
# - flow_path: Simulation of the flow path in the reactor
# ==============================================================================
# - The Model has been built based on [1], and some of the initial results
#   has been published in [2].
# ------------------------------------------------------------------------------
# [1] OECD/NEA, 'PBMR Coupled Neutronics/Thermal-hydraulics Transient Benchmark
#     - The PBMR-400 Core Design', NEA/NSC/DOC(2013)10, Technical Report, (2013)
# [2] P. Balestra and S. Schunert and R. Carlsen and A. Novak and M. DeHart and
#     R. Martineau, 'PBMR-400 Benchmark Solution of Exercise 1 and 2 Using
#     the MOOSE Based Applications: MAMMOTH, Pronghorn',
#     Proceedings of PHYSOR2020, (2020)
# ==============================================================================
# MODEL PARAMETERS
# ==============================================================================
# Problem Parameters -----------------------------------------------------------
heat_capacity_multiplier  = 1e-3  # Multiply the solid heat structures heat capacity for steady state to speed convergence / stabilize (//).

# Geometry ---------------------------------------------------------------------
geometric_tolerance          = 1e-3   # Geometric tolerance to generate the side-sets (m).
pebble_bed_top_height        = 15.35  # Y-coordinate of the top of the pebble bed (m).
inner_radius                 = 1.000  # X-coordinate of inner wall of the pebble bed (m).
outer_radius                 = 1.850  # X-coordinate of outer wall of the pebble bed (m).
global_emissivity            = 0.80   # All the materials has the same emissivity (//).
pebble_bed_porosity          = 0.39   # Pebble bed porosity (//).
fluid_channels_porosity      = 0.20   # 20% is assumed in regions where the He flows in graphite areas (//).
void_porosity                = 1.00   # Top void area porosity (//).
core_inlet_free_flow_area    = 5.8119 # Core inlet free (no pebbles) flow area (m2)
riser_free_flow_area         = 2.6928 # Riser free (no graphite) flow area (m2)
reactor_inlet_free_flow_area = 8.1870 # Reactor inlet free (no graphite) flow area (m2)
pebbles_diameter             = 0.06   # Diameter of the pebbles (m).

# Properties -------------------------------------------------------------------
reactor_total_mfr        = 192.70   # Total reactor He mass flow rate (kg/s).
reactor_total_power      = 400.0e6  # Total reactor Power (W).
reactor_inlet_T_fluid    = 773.15   # He temperature  at the inlet of the lower inlet plenum (K).
reactor_outlet_pressure  = 9e+6     # Pressure at the at the outlet of the outlet plenum (Pa)
core_inlet_superficial_rho_v    = ${fparse -reactor_total_mfr/core_inlet_free_flow_area}            # Inlet superficial mass flux in the  -y direction  (kg/m2s).
reactor_inlet_superficial_rho_u = ${fparse -reactor_total_mfr/reactor_inlet_free_flow_area}         # Inlet superficial  mass flux in the  -x direction  (kg/m2s).
riser_superficial_rho_v         = ${fparse reactor_total_mfr/riser_free_flow_area}                  # Inlet superficial  mass flux in the  -x direction  (kg/m2s).

[GlobalParams]
  pebble_diameter = ${pebbles_diameter}
  acceleration = ' 0.00 -9.81 0.00 ' # Gravity acceleration (m/s2).
  fp = fluid_properties_obj
[]

# ==============================================================================
# GEOMETRY AND MESH
# ==============================================================================

[Mesh]
  coord_type = RZ

  type = MeshGeneratorMesh
  block_id = ' 1 2 3 4 5 6 7 8 9 10 11 12 14 15 16 17 18 '
  block_name = ' pebble_bed
                 top_cavity
                 top_reflector
                 side_reflector
                 inner_reflector
                 bottom_reflector
                 top_plate
                 bottom_plate
                 he_gap01
                 core_barrel
                 he_gap02
                 rpv
                 inlet_flow_channel01
                 inlet_flow_channel02
                 inlet_flow_channel03
                 bottom_cone
                 flow_collector '

  [cartesian_mesh]
    type = CartesianMeshGenerator
    dim = 2

    dx = ' 0.1000 0.3100 0.3260 0.0695 0.1150 0.0795   0.1700 0.1700 0.1700 0.1700 0.1700   0.0795 0.1150 0.0695 0.1360 0.1860 0.1700 0.1440 0.1250 0.0500 0.1750 0.1800 '
    # ix = ' 1 3 3 1 1 1   2 2 2 2 2   1 1 1 1 2 4 1 2 1 2 2 '
    ix = ' 1 3 3 1 1 1   1 1 1 1 1   1 1 1 1 2 4 1 2 1 2 2 '
    # ix = ' 1 1 1 1 1 1   1 1 1 1 1   1 1 1 1 1 1 1 1 1 1 1 '
    # ix = ' 2 2 2 2 2 2   2 2 2 2 2   2 2 2 2 2 2 2 2 2 2 2 '

    dy = ' 0.35 0.50 0.50 0.50 0.50 0.50 0.50 0.50 0.50 0.50 0.50 0.50 0.50 0.50 0.50 0.50 0.50 0.50 0.50 0.50 0.50 0.50 0.50 0.50 0.50 0.50 0.50 0.50 0.50 0.50 0.50 0.50 0.50 0.50 0.50 0.35 '
    # iy = ' 4 5 5 5 5 5 5 5 5   5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5   5 5 5 5 4 '
    iy = ' 4 5 5 5 5 5 5 5 5   1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1   5 5 5 5 4 '
    # iy = ' 1 1 1 1 1 1 1 1 1   1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1   1 1 1 1 1 '
    # iy = ' 2 2 2 2 2 2 2 2 2   2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2   2 2 2 2 2 '
    subdomain_id = ' 8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  8  11 12
                     5  5  5  5  5  5  6  6  6  6  6  4  4  4  4  4  4  4  9  10 11 12
                     5  5  5  5  5  5  6  6  6  6  6  4  4  4  4  4  4  4  9  10 11 12
                     5  5  5  5  5  5  18 18 18 18 18 4  4  4  4  4  4  4  9  10 11 12
                     5  5  5  5  5  5  17 17 17 17 17 4  4  4  4  4  4  4  9  10 11 12
                     5  5  5  5  5  5  17 17 17 17 17 4  4  4  4  4  14 4  9  10 11 12
                     5  5  5  5  5  5  17 17 17 17 17 4  4  4  4  4  15 4  9  10 11 12
                     5  5  5  5  5  5  17 17 17 17 17 4  4  4  4  4  15 4  9  10 11 12
                     5  5  5  5  5  5  17 17 17 17 17 4  4  4  4  4  15 4  9  10 11 12
                     5  5  5  5  5  5  1  1  1  1  1  4  4  4  4  4  15 4  9  10 11 12
                     5  5  5  5  5  5  1  1  1  1  1  4  4  4  4  4  15 4  9  10 11 12
                     5  5  5  5  5  5  1  1  1  1  1  4  4  4  4  4  15 4  9  10 11 12
                     5  5  5  5  5  5  1  1  1  1  1  4  4  4  4  4  15 4  9  10 11 12
                     5  5  5  5  5  5  1  1  1  1  1  4  4  4  4  4  15 4  9  10 11 12
                     5  5  5  5  5  5  1  1  1  1  1  4  4  4  4  4  15 4  9  10 11 12
                     5  5  5  5  5  5  1  1  1  1  1  4  4  4  4  4  15 4  9  10 11 12
                     5  5  5  5  5  5  1  1  1  1  1  4  4  4  4  4  15 4  9  10 11 12
                     5  5  5  5  5  5  1  1  1  1  1  4  4  4  4  4  15 4  9  10 11 12
                     5  5  5  5  5  5  1  1  1  1  1  4  4  4  4  4  15 4  9  10 11 12
                     5  5  5  5  5  5  1  1  1  1  1  4  4  4  4  4  15 4  9  10 11 12
                     5  5  5  5  5  5  1  1  1  1  1  4  4  4  4  4  15 4  9  10 11 12
                     5  5  5  5  5  5  1  1  1  1  1  4  4  4  4  4  15 4  9  10 11 12
                     5  5  5  5  5  5  1  1  1  1  1  4  4  4  4  4  15 4  9  10 11 12
                     5  5  5  5  5  5  1  1  1  1  1  4  4  4  4  4  15 4  9  10 11 12
                     5  5  5  5  5  5  1  1  1  1  1  4  4  4  4  4  15 4  9  10 11 12
                     5  5  5  5  5  5  1  1  1  1  1  4  4  4  4  4  15 4  9  10 11 12
                     5  5  5  5  5  5  1  1  1  1  1  4  4  4  4  4  15 4  9  10 11 12
                     5  5  5  5  5  5  1  1  1  1  1  4  4  4  4  4  15 4  9  10 11 12
                     5  5  5  5  5  5  1  1  1  1  1  4  4  4  4  4  15 4  9  10 11 12
                     5  5  5  5  5  5  1  1  1  1  1  4  4  4  4  4  15 4  9  10 11 12
                     5  5  5  5  5  5  1  1  1  1  1  16 16 16 16 16 16 4  9  10 11 12
                     5  5  5  5  5  5  2  2  2  2  2  4  4  4  4  4  4  4  9  10 11 12
                     5  5  5  5  5  5  3  3  3  3  3  4  4  4  4  4  4  4  9  10 11 12
                     5  5  5  5  5  5  3  3  3  3  3  4  4  4  4  4  4  4  9  10 11 12
                     5  5  5  5  5  5  3  3  3  3  3  4  4  4  4  4  4  4  9  10 11 12
                     7  7  7  7  7  7  7  7  7  7  7  7  7  7  7  7  7  7  7  7  11 12 '
  []

  # Side sets for gap conductance model.
  [reflector_barrel_gap_inner]
    type = SideSetsBetweenSubdomainsGenerator
    primary_block = 4
    paired_block = 9
    input = cartesian_mesh
    new_boundary = reflector_barrel_gap_inner
  []
  [reflector_barrel_gap_outer]
    type = SideSetsBetweenSubdomainsGenerator
    primary_block = 10
    paired_block = 9
    input = reflector_barrel_gap_inner
    new_boundary = reflector_barrel_gap_outer
  []
  [barrel_rpv_gap_inner]
    type = SideSetsBetweenSubdomainsGenerator
    primary_block = ' 7 8 10 '
    paired_block = 11
    input = reflector_barrel_gap_outer
    new_boundary = barrel_rpv_gap_inner
  []
  [barrel_rpv_gap_outer]
    type = SideSetsBetweenSubdomainsGenerator
    primary_block = 12
    paired_block = 11
    input = barrel_rpv_gap_inner
    new_boundary = barrel_rpv_gap_outer
  []

  # Side sets for inflow and outflow conditions.
  [reactor_inlet]
    type = SideSetsAroundSubdomainGenerator
    block = ' 14 '
    fixed_normal = 1
    normal = ' 1 0 0 '
    input = barrel_rpv_gap_outer
    new_boundary = reactor_inlet
  []
  [reactor_outlet]
    type = SideSetsAroundSubdomainGenerator
    block = ' 18 '
    fixed_normal = 1
    normal = ' 1 0 0 '
    input = reactor_inlet
    new_boundary = reactor_outlet
  []
  [pebble_bed_top]
    type = SideSetsAroundSubdomainGenerator
    block = ' 1 '
    fixed_normal = 1
    normal = ' 0 1 0 '
    input = reactor_outlet
    new_boundary = pebble_bed_top
  []
  [pebble_bed_bottom]
    type = SideSetsAroundSubdomainGenerator
    block = ' 1 '
    fixed_normal = 1
    normal = ' 0 -1 0 '
    input = pebble_bed_top
    new_boundary = pebble_bed_bottom
  []

  # Side sets for wall boundaries.
  [core_top]
    type = ParsedGenerateSideset
    included_subdomains = ' 2 '
    combinatorial_geometry = '( abs(y - 15.850) < ${geometric_tolerance} &
                              x > ${fparse 1.000 - geometric_tolerance} &
                              x < ${fparse 1.850 + geometric_tolerance} )'
    input = pebble_bed_bottom
    new_sideset_name = core_top
  []
  [core_bottom]
    type = ParsedGenerateSideset
    included_subdomains = ' 18 '
    combinatorial_geometry  = '( abs(y - 1.350) < ${geometric_tolerance} &
                              x > ${fparse 1.000 - geometric_tolerance} &
                              x < ${fparse 1.850 + geometric_tolerance} )'
    input = core_top
    new_sideset_name = core_bottom
  []
  [core_inner]
    type = ParsedGenerateSideset
    included_subdomains = ' 1 2 17 18 '
    combinatorial_geometry = '( abs(x - 1.000) < ${geometric_tolerance} &
                              y > ${fparse 1.350 - geometric_tolerance} &
                              y < ${fparse 15.850 + geometric_tolerance} )'
    input = core_bottom
    new_sideset_name = core_inner
  []
  [core_outer]
    type = ParsedGenerateSideset
    included_subdomains = ' 1 2 17 '
    combinatorial_geometry = '( abs(x - 1.850) < ${geometric_tolerance} &
                              y > ${fparse 1.850 - geometric_tolerance} &
                              y < ${fparse 14.850 + geometric_tolerance} )|
                              ( abs(x - 1.850) < ${geometric_tolerance} &
                              y > ${fparse 15.350 - geometric_tolerance} &
                              y < ${fparse 15.850 + geometric_tolerance} )'
    input = core_inner
    new_sideset_name = core_outer
  []
  # [core_outer]
  #   type = ParsedGenerateSideset
  #   included_subdomains = ' 1 2 17 '
  #   combinatorial_geometry = '( abs(x - 1.850) < ${geometric_tolerance} &
  #                             y > ${fparse 1.850 + 0.25} &
  #                             y < ${fparse 14.850 + geometric_tolerance} )|
  #                             ( abs(x - 1.850) < ${geometric_tolerance} &
  #                             y > ${fparse 15.350 - geometric_tolerance} &
  #                             y < ${fparse 15.850 + geometric_tolerance} )'
  #   input = core_inner
  #   new_sideset_name = core_outer
  # []
  [reactor_inlet_horizontal_walls]
    type = ParsedGenerateSideset
    included_subdomains = ' 14 16 '
    combinatorial_geometry = '( abs(y - 2.350) < ${geometric_tolerance} &
                              x > ${fparse 2.436 - geometric_tolerance} &
                              x < ${fparse 2.606 + geometric_tolerance} )|
                              ( abs(y - 14.850) < ${geometric_tolerance} &
                              x > ${fparse 1.850 - geometric_tolerance} &
                              x < ${fparse 2.436 + geometric_tolerance} )|
                              ( abs(y - 15.350) < ${geometric_tolerance} &
                              x > ${fparse 1.850 - geometric_tolerance} &
                              x < ${fparse 2.606 + geometric_tolerance} )'
    input = core_outer
    new_sideset_name = reactor_inlet_horizontal_walls
  []
  [reactor_inlet_vertical_walls]
    type = ParsedGenerateSideset
    included_subdomains = ' 14 15 16 '
    combinatorial_geometry = '( abs(x - 2.436) < ${geometric_tolerance} &
                              y > ${fparse 2.350 - geometric_tolerance} &
                              y < ${fparse 14.850 + geometric_tolerance} )|
                              ( abs(x - 2.606) < ${geometric_tolerance} &
                              y > ${fparse 2.850 - geometric_tolerance} &
                              y < ${fparse 15.350 + geometric_tolerance} )'
    input = reactor_inlet_horizontal_walls
    new_sideset_name = reactor_inlet_vertical_walls
  []
  # [reactor_inlet_vertical_walls]
  #   type = ParsedGenerateSideset
  #   included_subdomains = ' 14 15 16 '
  #   combinatorial_geometry = '( abs(x - 2.436) < ${geometric_tolerance} &
  #                             y > ${fparse 2.350 - geometric_tolerance} &
  #                             y < ${fparse 14.850 + geometric_tolerance} )|
  #                             ( abs(x - 2.606) < ${geometric_tolerance} &
  #                             y > ${fparse 2.850 + 0.25} &
  #                             y < ${fparse 15.350 + geometric_tolerance} )'
  #   input = reactor_inlet_horizontal_walls
  #   new_sideset_name = reactor_inlet_vertical_walls
  # []
  [reactor_inlet_close]
    type = SideSetsBetweenSubdomainsGenerator
    primary_block = 16
    paired_block = 1
    input = reactor_inlet_vertical_walls
    new_boundary = reactor_inlet_close
  []
[]

[Problem]
  kernel_coverage_check = false
[]

# ==============================================================================
# VARIABLES AND KERNELS
# ==============================================================================
[Variables]
  [pressure]
    initial_condition = ${reactor_outlet_pressure}
    scaling = 1.0
    block = ' 1 2 14 15 16 17 18 '
  []
  [superficial_rho_u]
    scaling = 1.0
    block = ' 1 2 14 15 16 17 18 '
  []
  [superficial_rho_v]
    scaling = 1.0
    block = ' 1 2 14 15 16 17 18 '
  []
  [T_fluid]
    initial_condition = ${reactor_inlet_T_fluid}
    scaling = 1e-3
    block = ' 1 2 14 15 16 17 18 '
  []
  [T_solid]
    initial_condition = ${reactor_inlet_T_fluid}
    scaling = 1e-4
    block = ' 1 3 4 5 6 7 8 10 12 14 15 16 17 18 '
  []
[]

[Kernels]
  # Equation 0 (mass conservation).
  [mass_time]
    type = MassTimeDerivative
    variable = pressure
    porosity = porosity
    block = ' 1 2 14 15 16 17 18 '
  []
  [mass_space]
    type = PressurePoisson
    variable = pressure
    porosity = porosity
    block = ' 1 2 14 15 16 17 18 '
  []
  # [mass_stabilization]
  #   type = PressureEquationStab
  #   variable = pressure
  #   porosity = porosity
  #   block = ' 1 2 14 15 16 17 18 '
  # []

  # Equation 1 (x momentum conservation).
  [x_momentum_pressure]
    type = MomentumPressureGradient
    variable = superficial_rho_u
    component = 0
    divergence = false
    porosity = porosity
    block = ' 1 2 14 15 16 17 18 '
  []
  [x_momentum_friction_source]
    type = MomentumFrictionForce
    variable = superficial_rho_u
    component = 0
    block = ' 1 2 14 15 16 17 18 '
  []
  [x_momentum_gravity_source]
    type = MomentumGravityForce
    variable = superficial_rho_u
    component = 0
    porosity = porosity
    block = ' 1 2 14 15 16 17 18 '
  []

  # Equation 2 (y momentum conservation).
  [y_momentum_pressure]
    type = MomentumPressureGradient
    variable = superficial_rho_v
    component = 1
    divergence = false
    porosity = porosity
    block = ' 1 2 14 15 16 17 18 '
  []
  [y_momentum_friction_source]
    type = MomentumFrictionForce
    variable = superficial_rho_v
    component = 1
    block = ' 1 2 14 15 16 17 18 '
  []
  [y_momentum_gravity_source]
    type = MomentumGravityForce
    variable = superficial_rho_v
    component = 1
    porosity = porosity
    block = ' 1 2 14 15 16 17 18 '
  []

  # Equation 3 (fluid energy conservation).
  [fluid_energy_time]
    type = FluidEnergyTime
    variable = T_fluid
    porosity = porosity
    single_equation_SUPG = true
    block = ' 1 2 14 15 16 17 18 '
  []
  [fluid_energy_space]
    type = FluidEnergyAdvection
    variable = T_fluid
    porosity = porosity
    single_equation_SUPG = true
    block = ' 1 2 14 15 16 17 18 '
  []
  [fluid_energy_diffuson]
    type = FluidEnergyDiffusiveFlux
    variable = T_fluid
    porosity = porosity
    single_equation_SUPG = true
    block = ' 1 2 14 15 16 17 18 '
  []
  [fluid_energy_solid_fluid_source]
    type = FluidSolidConvection
    variable = T_fluid
    T_solid = T_solid
    single_equation_SUPG = true
    block = ' 1 14 15 16 17 18 '
  []

  # Equation 4 (solid energy conservation).
  [solid_energy_time]
    type = SolidEnergyTime
    variable = T_solid
    porosity = porosity
    block = ' 1 '
  []
  [solid_energy_diffusion]
    type = SolidEnergyDiffusion
    variable = T_solid
    block = ' 1 '
  []
  [solid_energy_fluid_convection]
    type = SolidFluidConvection
    variable = T_solid
    block = ' 1  '
  []
  [solid_energy_heatsrc]
    type = CoupledForce
    variable = T_solid
    v = power_density
    block = ' 1 '
  []

  # Equation 4b (solid energy conservation passive structures).
  [passive_structures_energy_time_derivative]
    type = ADHeatConductionTimeDerivative
    variable = T_solid
    specific_heat = 'cp_s'
    density_name = 'rho_s'
    block = ' 3 4 5 6 7 8 10 12 14 15 16 17 18 '
  []
  [passive_structures_energy_diffusion]
    type = ADHeatConduction
    variable = T_solid
    thermal_conductivity = 'k_s'
    block = ' 3 4 5 6 7 8 10 12 14 15 16 17 18 '
  []
[]

# ==============================================================================
# AUXVARIABLES AND AUXKERNELS
# ==============================================================================
[AuxVariables]
  [porosity]
    block = ' 1 2 14 15 16 17 18 '
  []
  [power_density]
    family = MONOMIAL
    order = CONSTANT
    block = ' 1 '
  []
  [normalized_power_density]
    family = MONOMIAL
    order = CONSTANT
    block = ' 1 '
  []
  [rho]
    block = ' 1 2 14 15 16 17 18 '
  []
  [vel_x]
    block = ' 1 2 14 15 16 17 18 '
  []
  [vel_y]
    block = ' 1 2 14 15 16 17 18 '
  []
  [alpha]
    family = MONOMIAL
    order = CONSTANT
    block = ' 1 14 15 16 17 18 '
  []
  [k_s]
    family = MONOMIAL
    order = CONSTANT
    block = ' 3 4 5 6 7 8 10 12 14 15 16 17 18 '
  []
  [kappa_s]
    family = MONOMIAL
    order = CONSTANT
    block = ' 1 '
  []
  [Re]
    family = MONOMIAL
    order = CONSTANT
    block = ' 1 2 14 15 16 17 18 '
  []
  [T_fuel]
    # family = MONOMIAL
    # order = CONSTANT
    initial_condition = 900.0
    block = ' 1 '
  []
  [T_mod]
    # family = MONOMIAL
    # order = CONSTANT
    initial_condition = 700.0
    block = ' 1 '
  []
[]

[AuxKernels]
  [power_density]
    type = ParsedAux
    variable = power_density
    args = normalized_power_density
    function = '${reactor_total_power} * normalized_power_density'
    block = ' 1 '
    execute_on = 'INITIAL LINEAR TIMESTEP_END'
  []
  [rho]
    type = FluidDensityAux
    variable = rho
    p = pressure
    T = T_fluid
    block = ' 1 2 14 15 16 17 18 '
  []
  [vel_x]
    type = ParsedAux
    variable = vel_x
    function = 'superficial_rho_u / porosity / rho'
    args = 'superficial_rho_u porosity rho'
    block = ' 1 2 14 15 16 17 18 '
  []
  [vel_y]
    type = ParsedAux
    variable = vel_y
    function = 'superficial_rho_v / porosity / rho'
    args = 'superficial_rho_v porosity rho'
    block = ' 1 2 14 15 16 17 18 '
  []
  [alpha]
    type = ADMaterialRealAux
    variable = alpha
    property = alpha
    block = ' 1 14 15 16 17 18 '
  []
  [k_s]
    type = ADMaterialRealAux
    variable = k_s
    property = k_s
    block = ' 3 4 5 6 7 8 10 12 14 15 16 17 18 '
  []
  [kappa_s]
    type = ADMaterialRealAux
    variable = kappa_s
    property = kappa_s
    block = ' 1 '
  []
  [Re]
    type = ADMaterialRealAux
    variable = Re
    property = Re
    block = ' 1 2 14 15 16 17 18 '
  []
[]

# ==============================================================================
# INITIAL CONDITIONS AND FUNCTIONS
# ==============================================================================
[ICs]
  # Porosity assignment.
  [pebble_bed_porosity_initialization]
    type = ConstantIC
    variable = porosity
    value = ${pebble_bed_porosity}
    block = ' 1 '
  []
  [top_cavity_porosity_initialization]
    type = ConstantIC
    variable = porosity
    value = ${void_porosity}
    block = ' 2 '
  []
  [partial_density_zones_porosity_initialization]
    type = ConstantIC
    variable = porosity
    value = ${fluid_channels_porosity}
    block = ' 14 15 16 17 18 '
  []

  # Pebble bed and cavity momentum initialization.
  [pebble_bed_momentum_initialization]
    type = FunctionIC
    variable = superficial_rho_v
    function = ${core_inlet_superficial_rho_v}
    block = ' 1 '
  []
  [top_cavity_momentum_initialization]
    type = FunctionIC
    variable = superficial_rho_v
    function = ${core_inlet_superficial_rho_v}
    block = ' 2 17 18'
  []

  [pd_momentum_initialization]
    type = FunctionIC
    variable = superficial_rho_v
    function = ${fparse riser_superficial_rho_v}
    block = ' 15 '
  []
  [pd_momentum_initialization2]
    type = FunctionIC
    variable = superficial_rho_u
    function = ${reactor_inlet_superficial_rho_u}
    block = ' 14 16  '
  []
  [pd_momentum_initialization3]
    type = FunctionIC
    variable = superficial_rho_u
    function = ${fparse - reactor_inlet_superficial_rho_u}
    block = ' 18 '
  []
  [pd_momentum_initialization4]
    type = FunctionIC
    variable = superficial_rho_u
    function = 1e-6
    block = ' 1 2 15 17 '
  []
[]

[Functions]
  [power_function]
    type = PiecewiseMulticonstant
    direction = ' left  left ' # Direction to look to find value for each interpolation dimension.
    data_file = '../shared/power.txt'
  []
[]

# ==============================================================================
# FLUID PROPERTIES, MATERIALS AND USER OBJECTS
# ==============================================================================
[FluidProperties]
  [fluid_properties_obj]
    type = HeliumFluidProperties
  []
[]

[Materials]
  # Non linear variables and stabilization.
  [non_linear_variables]
    type = MixedSuperficialVarMaterial
    pressure = pressure
    T_fluid = T_fluid
    superficial_rho_u = superficial_rho_u
    superficial_rho_v = superficial_rho_v
    porosity = porosity
    block = ' 1 2 14 15 16 17 18 '
  []
  [fluid_properties]
    type = PronghornFluidProps
    porosity = porosity
    block = ' 1 2 14 15 16 17 18 '
  []
  [scalar_tau_for_stabilization]
    type = ScalarTau
    block = ' 1 2 14 15 16 17 18 '
  []

  # Drag coefficients.
  [pebble_bed_drag_coefficient]
    type = KTADragCoefficients
    T_solid = T_solid
    porosity = porosity
    block = ' 1 '
  []
  [top_cavity_drag_coefficient]
    # type = FunctionIsotropicDragCoefficients
    type = FunctionSimpleIsotropicDragCoefficients
    W = 10.0
    # Darcy_coefficient = 0.0
    # Forchheimer_coefficient = 10.0
    block = ' 2 '
  []
  [partial_density_drag_coefficient]
    # type = FunctionIsotropicDragCoefficients
    type = FunctionSimpleIsotropicDragCoefficients
    W = 1.0
    # Darcy_coefficient = 0.0
    # Forchheimer_coefficient = 0.013
    block = ' 14 15 16 17 18 '
  []

  # Fluid effective conductivity.
  [pebble_bed_fluid_effective_conductivity]
    type = LinearPecletKappaFluid
    # wall_distance = bed_geometry
    # scaling_factor = 0.5
    porosity = porosity
    block = ' 1 '
  []
  # [pebble_bed_fluid_effective_conductivity]
  #   type = KappaFluid
  #   block = ' 1 '
  # []
  [partial_density_cavity_fluid_effective_conductivity]
    type = KappaFluid
    block = ' 2 14 15 16 17 18 '
  []

  # Heat exchange coefficients.
  [pebble_bed_alpha]
    type = KTAPebbleBedHTC
    T_solid = T_solid
    porosity = porosity
    bed_entrance = top
    wall_distance = bed_geometry
    block = ' 1 '
  []
  [partial_density_cavity_dummy_pebble_bed_alpha]
    type = ADGenericConstantMaterial
    prop_names = 'alpha'
    prop_values = '1e-10'
    block = ' 14 15 16 17 18 '
  []
  [gaps_dummy_htc]
    type = ADGenericConstantMaterial
    prop_names = 'dummy_htc'
    prop_values = '1e-10'
    block = ' 9 11 12 '
  []

  # Solid conduction properties.
  [pebble_bed_solid_effective_conductivity]
    type = PebbleBedKappaSolid
    T_solid = T_solid
    porosity = porosity
    solid_conduction = ZBS
    emissivity = ${global_emissivity}
    infinite_porosity = ${pebble_bed_porosity}
    Youngs_modulus = 9e+9
    Poisson_ratio = 0.1360
    lattice_parameters = interpolation
    coordination_number = You
    wall_distance = bed_geometry # Requested by solid_conduction = ZBS
    block = ' 1 '
  []
  # [pebble_bed_solid_effective_conductivity]
  #   type = ADGenericConstantMaterial
  #   prop_names = 'kappa_s'
  #   prop_values = '200.0'
  #   block = ' 1 '
  # []
  [pebble_bed_full_density_graphite]
    type = ADGenericConstantMaterial
    prop_names = ' rho_s cp_s k_s '
    prop_values = ' 1780.0 ${fparse 1697.0*heat_capacity_multiplier} 26.0'
    block = ' 1 '
  []
  [reflector_full_density_graphite]
    type = ADGenericConstantMaterial
    prop_names = ' rho_s cp_s k_s '
    prop_values = ' 1780.0 ${fparse 1697.0*heat_capacity_multiplier} 26.0 '
    block = ' 3 4 5 6 '
  []
  [channels_partial_density_graphite]
    type = ADGenericConstantMaterial
    prop_names = ' rho_s cp_s k_s '
    prop_values = ' 1424.0 ${fparse 1697.0*heat_capacity_multiplier} 20.8 '
    block = ' 14 15 16 17 18 '
  []
  [core_barrel_steel]
    type = ADGenericConstantMaterial
    prop_names = ' rho_s cp_s k_s '
    prop_values = ' 7800.0 ${fparse 540.0*heat_capacity_multiplier} 17.0 '
    block = ' 7 8 10 '
  []
  [rpv_steel]
    type = ADGenericConstantMaterial
    prop_names = ' rho_s cp_s k_s '
    prop_values = ' 7800.0 ${fparse 525.0*heat_capacity_multiplier} 38.0 '
    block = ' 12 '
  []
[]

[UserObjects]
  [bed_geometry]
    type = WallDistanceCylindricalBed
    top = ${pebble_bed_top_height}
    inner_radius = ${inner_radius}
    outer_radius = ${outer_radius}
  []
[]

# ==============================================================================
# BOUNDARY CONDITIONS
# ==============================================================================
[BCs]
  # Inlet flow.
  [pressure_inlet]
    type = MassSpecifiedMomentumBC
    variable = pressure
    specified_momentum = '${fparse 1.0*reactor_inlet_superficial_rho_u} 0.0'
    porosity = porosity
    superficial = true
    boundary = 'reactor_inlet'
  []
  [superficial_rho_u_inlet]
    type = FunctionDirichletBC
    variable = superficial_rho_u
    function = ${fparse 1.0*reactor_inlet_superficial_rho_u}
    boundary = 'reactor_inlet'
  []
  [superficial_rho_v_inlet]
    type = DirichletBC
    variable = superficial_rho_v
    value = 0.0
    boundary = 'reactor_inlet'
  []
  [T_fluid_inlet]
    type = DirichletBC
    variable = T_fluid
    value = ${reactor_inlet_T_fluid}
    boundary = 'reactor_inlet'
  []

  # Outlet flow.
  [pressure_outlet]
    type = FunctionDirichletBC
    variable = pressure
    function = ${reactor_outlet_pressure}
    boundary = 'reactor_outlet'
  []

  # Fluid solid walls.
  [superficial_rho_u_vertical_walls]
    type = DirichletBC
    variable = superficial_rho_u
    value = 0.0
    boundary = ' core_inner core_outer reactor_inlet_vertical_walls '
  []
  [superficial_rho_v_horizontal_walls]
    type = DirichletBC
    variable = superficial_rho_v
    value = 0.0
    boundary = ' core_top core_bottom reactor_inlet_horizontal_walls '
  []

  # Radial conduction/radiation trough the Air gap BCs.
  [T_solid_conduction]
    type = ThermalResistanceBC
    variable = T_solid
    emissivity = 1e-10
    htc = 'dummy_htc'
    thermal_conductivities = 0.03 # Stagnant Air.
    inner_radius = 3.2800
    conduction_thicknesses = 1.340
    T_ambient = 293.15
    boundary = right
  []
  [T_solid_radiation]
    type = InfiniteCylinderRadiativeBC
    variable = T_solid
    cylinder_emissivity = ${global_emissivity}
    boundary_emissivity = ${global_emissivity}
    boundary_radius = 3.280
    cylinder_radius = 4.620
    Tinfinity = 293.15
    boundary = right
  []
[]

[ThermalContact]
  [reflector_to_barrel]
    type = GapHeatTransfer
    variable = T_solid
    emissivity_primary = ${global_emissivity}
    emissivity_secondary = ${global_emissivity}
    gap_geometry_type = CYLINDER
    primary = reflector_barrel_gap_outer
    secondary = reflector_barrel_gap_inner
    gap_conductivity = 0.33 # Stagnant He.
  []
  [barrel_to_rpv]
    type = GapHeatTransfer
    variable = T_solid
    emissivity_primary = ${global_emissivity}
    emissivity_secondary = ${global_emissivity}
    gap_geometry_type = CYLINDER
    primary = barrel_rpv_gap_outer
    secondary = barrel_rpv_gap_inner
    gap_conductivity = 0.33 # Stagnant He.
  []
[]

# ==============================================================================
# EXECUTION PARAMETERS
# ==============================================================================
[Preconditioning]
  active = FSP

  [SMP]
    type = SMP
    full = true
    petsc_options_iname = ' -pc_type -pc_factor_mat_solver_type
                            -ksp_gmres_restart '
    petsc_options_value = ' lu superlu_dist 50 '
  []

  [FSP]
    type = FSP
    topsplit = ' ts '
    petsc_options_iname = ' -pc_type -pc_factor_mat_solver_type
                            -ksp_gmres_restart '
    petsc_options_value = ' lu superlu_dist 50 '

    [ts]
      splitting = ' p v Tf Ts '
      splitting_type = additive
    []

    [p]
      vars = pressure
      petsc_options_iname = ' -pc_type -ksp_type '
      petsc_options_value = ' hypre preonly '
    []

    [Ts]
      vars = T_solid
      petsc_options_iname = ' -pc_type -ksp_type '
      petsc_options_value = ' hypre preonly '
    []

    [v]
      vars = ' superficial_rho_u superficial_rho_v '
      petsc_options_iname = ' -pc_type -pc_factor_mat_solver_type -ksp_type '
      petsc_options_value = ' lu superlu_dist preonly '
    []

    [Tf]
      vars = T_fluid
      petsc_options_iname = ' -pc_type -pc_factor_mat_solver_type -ksp_type '
      petsc_options_value = ' lu superlu_dist preonly '
    []

  []

[]

[Executioner]
  type = Transient # Pseudo transient to reach steady state.
  solve_type = 'PJFNK'
  petsc_options = ' -snes_converged_reason '
  line_search = 'l2'

  # Problem time parameters.
  reset_dt = true
  start_time = 0.0

  end_time = 1e+6
  dtmin    = 1e-3
  dtmax    = 5e+4


  # Iterations parameters.
  l_max_its = 50
  l_tol     = 1e-4

  nl_max_its = 25
  nl_rel_tol = 1e-6
  nl_abs_tol = 1e-7

  # Automatic scaling
  # automatic_scaling = true
  # compute_scaling_once = false

  # Steady state detection.
  steady_state_detection = true
  steady_state_tolerance = 1e-10
  steady_state_start_time = 1e+3

  # Time step control.
  [TimeStepper]
    type = IterationAdaptiveDT
    dt                 = 1e-2
    cutback_factor     = 0.25
    growth_factor      = 4.00
    optimal_iterations = 25
  []
[]

# ==============================================================================
# MULTIAPPS AND TRANSFER
# ==============================================================================
[MultiApps]
  [pebble_triso]
    type = CentroidMultiApp
    input_files = 'oecd_pbmr400_ss2_mhtr_pebble_triso.i'
    output_in_position = true
    max_procs_per_app = 1
    block = ' 1 '
    execute_on = 'TIMESTEP_END FINAL'
  []
[]
[Transfers]
  [pebble_surface_temp]
    type = MultiAppVariableValueSamplePostprocessorTransfer
    to_multi_app = pebble_triso
    source_variable = T_solid
    postprocessor = pebble_surface_temp
  []
  [pebble_heat_source]
    type = MultiAppVariableValueSampleTransfer
    to_multi_app = pebble_triso
    source_variable = power_density
    variable = porous_media_power_density
  []
  [T_mod]
    type = MultiAppPostprocessorInterpolationTransfer
    from_multi_app = pebble_triso
    variable = T_mod
    num_points = 4
    postprocessor = moderator_average_temp
  []
  [T_fuel]
    type = MultiAppPostprocessorInterpolationTransfer
    from_multi_app = pebble_triso
    variable = T_fuel
    num_points = 4
    postprocessor = fuel_average_temp
  []
[]

# ==============================================================================
# POSTPROCESSORS DEBUG AND OUTPUTS
# ==============================================================================
[Debug]
  show_var_residual_norms = false
[]

[Postprocessors]
  [Tt_pow]
    type = ElementIntegralVariablePostprocessor
    variable = power_density
    block = ' 1 '
    execute_on = 'INITIAL TIMESTEP_END FINAL'
  []
  [Tt_normalized_pow]
    type = ElementIntegralVariablePostprocessor
    variable = normalized_power_density
    block = ' 1 '
    execute_on = 'INITIAL TIMESTEP_END FINAL'
  []
  [Tt_mfr_in]
    type = MassFlowrateSidePostprocessor
    porosity = porosity
    boundary = 'reactor_inlet'
    execute_on = 'INITIAL TIMESTEP_END FINAL'
  []
  [Tt_mfr_out]
    type = MassFlowrateSidePostprocessor
    porosity = porosity
    boundary = 'reactor_outlet'
    execute_on = 'INITIAL TIMESTEP_END FINAL'
  []
  [Tt_mfr_core_out]
    type = MassFlowrateSidePostprocessor
    porosity = porosity
    boundary = 'pebble_bed_bottom'
    execute_on = 'INITIAL TIMESTEP_END FINAL'
  []
  [T_fuel_avg]
    type = ElementAverageValue
    variable = T_fuel
    block = ' 1 '
    execute_on = 'INITIAL TIMESTEP_END FINAL'
  []
  [T_mod_avg]
    type = ElementAverageValue
    variable = T_mod
    block = ' 1 '
    execute_on = 'INITIAL TIMESTEP_END FINAL'
  []
  [T_solid_avg]
    type = ElementAverageValue
    variable = T_solid
    block = ' 1 '
    execute_on = 'INITIAL TIMESTEP_END FINAL'
  []
  [T_fluid_avg]
    type = ElementAverageValue
    variable = T_fluid
    block = ' 1 '
    execute_on = 'INITIAL TIMESTEP_END FINAL'
  []
  [time_step_pp]
    type = TimestepSize
    execute_on = 'INITIAL LINEAR NONLINEAR TIMESTEP_END FINAL'
  []
[]

[Outputs]
  file_base = oecd_pbmr400_ss1_phtn_flow_path
  print_linear_residuals = false
  exodus = true
  csv = true
  execute_on = 'INITIAL TIMESTEP_END FINAL'
  [Checkpoint]
    type = Checkpoint
    additional_execute_on = 'FINAL'
  []
[]
