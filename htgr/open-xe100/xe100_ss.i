# ==============================================================================
# Model description
# ------------------------------------------------------------------------------
# Idaho Falls, INL, April 21, 2021 12:05 PM
# Author(s): Dr. Paolo Balestra & Dr. Ryan Stewart
# ==============================================================================
# - xe100: reference plant design based on 200MW XE100 Open Source Plant.
# - ss1: Steady state simulation sub app level 1.
# ==============================================================================
# - The Model has been built based on [1].
# ------------------------------------------------------------------------------
# [1] R. Stewart, P. Balestra, D. Reger, and E. Merzari.
#     Generation of localized reactor point kinetics parameters using coupled
#     neutronic and thermal fluid models for pebble-bed reactor transient analysis.
#     Annals of Nuclear Energy, 174:109143, 2022.
#     URL: https://www.sciencedirect.com/science/article/pii/S0306454922001785#s0065
#     doi: https://doi.org/10.1016/j.anucene.2022.109143.
# ==============================================================================

# ==============================================================================
# MODEL PARAMETERS
# ==============================================================================

# Block subdivision ------------------------------------------------------------
fuel_blocks  = '  1   2   3   4   5
                  6   7   8   9   10
                  11  12  13  14  15
                  16  17  18  19  20
                  21  22  23  24  25
                  26  27  28  29  30
                  31  32  33  34  35
                  36  37  38  39  40
                  41  42  43  44  45
                  46  47  48  49  50
                  51  52  53  54  55
                  56  57  58  59  60
                  61 '

ref_blocks   = '  63  64  65
                  66  67  68  69  70
                  71  72  73  74  75
                  76  77  78  79  80
                  81  82  83  84  85
                  86  87  88  89  90
                  91  92  93  94  95
                  96  97  98  99  100
                  101 102 103 104 105
                  106 107 108 109 110
                  111 112 113 114 115
                  116 117 118 119 120
                  121 122 123 124 125
                  126 127 128 129 130
                  131 132 133 134 135
                  136 137 138 139 140
                  141 142 143 144 145
                  146 147 148 149 150
                  151 152 153 154 155
                  156 157 158 159 160
                  161 162 163 164 165
                  166
                  '

cavity_blocks = ' 62 '

# Power & Temperature ----------------------------------------------------------
total_power = 200.0e+6 # Total reactor Power (W)
initial_temperature = 900.0 # (K)

# ==============================================================================
# GLOBAL PARAMETERS
# ==============================================================================

[GlobalParams]
  library_file = 'xs/xe100_sp_sph_cavity.xml'
  library_name = htgr_exp
  is_meter = true
[]

# ==============================================================================
# GEOMETRY AND MESH
# ==============================================================================

[Mesh]

  coord_type = 'RZ'
  rz_coord_axis = 'Y'

  [cartesian_mesh]
    type = CartesianMeshGenerator
    dim = 2

    # Total Height: 893 cm
    # Total Radius: 240 cm
    dx = '   0.36 0.21 0.21 0.21 0.21 0.25 0.25 0.25 0.25 '
    ix = '   2    2    2    2    2    2    2    2    2   '

    dy = ' 0.25 0.25 0.135 0.135 0.135 0.135 0.36 0.7791 0.7791 0.7791 0.7791 0.7791 0.7791 0.7791 0.7791 0.7791 0.7791 0.7791 0.55 0.25 0.25'
    iy = ' 2    2    2     2     2     2     2    2      2      2     2      2       2      2      2      2      2      2      2    2    2'

    # The core is reverse: 1,2,3,4,5 are the bottom most layer of fuel
    # First region is the lower reflector
    # Second region is the cone, where fuel is discharged
    # Third region is the fuel region
    # Fourth region is the upper reflector
    subdomain_id = '
                    157 158 159 160 161    63  64  65  66
                    162 163 164 165 166    67  68  69  70

                    61   71  71  71  71    71  72  73  74
                    61   61  75  75  75    75  76  77  78
                    61   61  61  79  79    79  80  81  82
                    61   61  61  61  83    83  84  85  86

                    1    2    3   4   5    87  88  89  90
                    6    7    8   9  10    91  92  93  94
                    11  12   13  14  15    95  96  97  98
                    16  17   18  19  20    99 100 101 102
                    21  22   23  24  25   103 104 105 106
                    26  27   28  29  30   107 108 109 110
                    31  32   33  34  35   111 112 113 114
                    36  37   38  39  40   115 116 117 118
                    41  42   43  44  45   119 120 121 122
                    46  47   48  49  50   123 124 125 126
                    51  52   53  54  55   127 128 129 130
                    56  57   58  59  60   131 132 133 134
                    62  62   62  62  62   135 136 137 138

                    147 148 149 150 151   139 140 141 142
                    152 153 154 155 156   143 144 145 146
                    '
  []

  [cartesian_mesh_ids]
    type = ExtraElementIDCopyGenerator
    input = cartesian_mesh
    source_extra_element_id = 'subdomain_id'
    target_extra_element_ids = 'material_id'
  []
[]

# ==============================================================================
# AUXVARIABLES
# ==============================================================================

[AuxVariables]
  [Tfuel]
    family = MONOMIAL
    order = CONSTANT
    initial_condition = ${initial_temperature}
    block = '${fuel_blocks}'
  []
  [Tmod]
    family = MONOMIAL
    order = CONSTANT
    initial_condition = ${initial_temperature}
    block = '${fuel_blocks}'
  []
  [Tref]
    family = MONOMIAL
    order = CONSTANT
    initial_condition = ${initial_temperature}
    block = '${ref_blocks}'
  []
[]

# ==============================================================================
# MATERIALS
# ==============================================================================

[Materials]
  [fuel_blocks]
    type = CoupledFeedbackMatIDNeutronicsMaterial
    grid_names = 'Tfuel Tmod'
    grid_variables = 'Tfuel Tmod'
    plus = true
    isotopes = 'pseudo'
    densities = '1.0'
    block = '${fuel_blocks}'
  []
  [ref_blocks]
    type = CoupledFeedbackMatIDNeutronicsMaterial
    grid_names = 'Tref'
    grid_variables = 'Tref'
    plus = true
    isotopes = 'pseudo'
    densities = '1.0'
    block = '${ref_blocks}'
  []
  [cavity_blocks]
    type = CoupledFeedbackMatIDNeutronicsMaterial
    grid_names = ''
    grid_variables = ''
    plus = true
    isotopes = 'pseudo'
    densities = '1.0'
    block = '${cavity_blocks}'
  []
[]

# ==============================================================================
# USER OBJECTS
# ==============================================================================

[PowerDensity]
  power = ${total_power}
  power_density_variable = inst_power_density
  integrated_power_postprocessor = total_power
  family = MONOMIAL
  order = CONSTANT
[]

# User objects to write data to a binary file for the transient runs
[UserObjects]
  [ss1_gfnk_transport_sol]
    type = TransportSolutionVectorFile
    transport_system = diff
    writing = true
    execute_on = 'FINAL'
  []
  [ss1_gfnk_inst_power_density]
    type = SolutionVectorFile
    var = inst_power_density
    writing = true
    execute_on = 'FINAL'
  []
  [ss0_gfnk_Tfuel]
    type = SolutionVectorFile
    var = Tfuel
    writing = true
    execute_on = 'FINAL'
  []
  [ss1_gfnk_sflux_g0]
    type = SolutionVectorFile
    var = sflux_g0
    writing = true
    execute_on = 'FINAL'
  []
  [ss1_gfnk_sflux_g1]
    type = SolutionVectorFile
    var = sflux_g1
    writing = true
    execute_on = 'FINAL'
  []
  [ss1_gfnk_sflux_g2]
    type = SolutionVectorFile
    var = sflux_g2
    writing = true
    execute_on = 'FINAL'
  []
  [ss1_gfnk_sflux_g3]
    type = SolutionVectorFile
    var = sflux_g3
    writing = true
    execute_on = 'FINAL'
  []
[]

# ==============================================================================
# EXECUTION PARAMETERS
# ==============================================================================

[TransportSystems]
  particle = neutron
  equation_type = eigenvalue

  G = 4

  ReflectingBoundary = 'left'
  VacuumBoundary = 'right top bottom'

  [diff]
    scheme = CFEM-Diffusion
    n_delay_groups = 6
    assemble_scattering_jacobian = true
    assemble_fission_jacobian = true
    family = LAGRANGE
    order = FIRST
  []
[]

[Executioner]
  type = Eigenvalue

  solve_type = 'PJFNKMO'
  petsc_options_iname = '-pc_type -pc_hypre_type -ksp_gmres_restart'
  petsc_options_value = 'hypre boomeramg 50'
  line_search = none

  # Linear/nonlinear iterations.
  l_max_its = 50
  l_tol = 1e-3

  nl_max_its = 50
  nl_rel_tol = 1e-7
  nl_abs_tol = 1e-8

  # Power iterations.
  free_power_iterations = 4

  [Quadrature]
    order = FOURTH
  []
[]

# ==============================================================================
# POSTPROCESSORS AND OUTPUTS
# ==============================================================================

[Postprocessors]
  [avg_fuel_temp]
    type = ElementAverageValue
    variable = Tfuel
    block = '${fuel_blocks}'
  []
  [avg_mod_temp]
    type = ElementAverageValue
    variable = Tmod
    block = '${fuel_blocks}'
  []
  [avg_ref_temp]
    type = ElementAverageValue
    variable = Tref
    block = '${ref_blocks}'
  []
[]

[Outputs]
  file_base = ss
  print_linear_residuals = false
  print_linear_converged_reason = false
  print_nonlinear_converged_reason = false
  csv = true
[]
