################################################################################
## NEAMS Micro-Reactor Application Driver                                     ##
## Heat Pipe Microreactor TRISO Failure Model                                 ##
## Statistical Model for Evaluating TRISO Failure in the Assembly             ##
## Stochastic Module Model for Sampling                                       ##
################################################################################

# Folder hosting the pressure data
folder_name = 'fuelsample'
end_time = 315576000

coord1 = 2.125e-4
coord2 = '${fparse 1e-4 + coord1}'
coord3 = '${fparse 0.4e-4 + coord2}'
coord4 = '${fparse 0.35e-4 + coord3}'
coord5 = '${fparse 0.4e-4 + coord4}'

[StochasticTools]
  auto_create_executioner = false
[]

[Distributions]
  [normal_kernel_r]
    type = TruncatedNormal
    mean = '${fparse coord1}'
    standard_deviation = 4.4e-6
    lower_bound = '${fparse coord1-4*4.4e-6}'
    upper_bound = '${fparse coord1+4*4.4e-6}'
  []
  [normal_buffer_t]
    type = TruncatedNormal
    mean = '${fparse coord2 - coord1}'
    standard_deviation = 8.4e-6
    lower_bound = '${fparse (coord2-coord1 )-4*8.4e-6}'
    upper_bound = '${fparse (coord2-coord1 )+4*8.4e-6}'
  []
  [normal_ipyc_t]
    type = TruncatedNormal
    mean = '${fparse coord3 - coord2}'
    standard_deviation = 2.5e-6
    lower_bound = '${fparse (coord3-coord2 )-4*2.5e-6}'
    upper_bound = '${fparse (coord3-coord2 )+4*2.5e-6}'
  []
  [normal_sic_t]
    type = TruncatedNormal
    mean = '${fparse coord4 - coord3}'
    standard_deviation = 1.2e-6
    lower_bound = '${fparse (coord4-coord3)-4*1.2e-6}'
    upper_bound = '${fparse (coord4-coord3)+4*1.2e-6}'
  []
  [normal_opyc_t]
    type = TruncatedNormal
    mean = '${fparse coord5 - coord4}'
    standard_deviation = 2.9e-6
    lower_bound = '${fparse (coord5-coord4)-4*2.9e-6}'
    upper_bound = '${fparse (coord5-coord4)+4*2.9e-6}'
  []
  [uniform]
    type = Uniform
  []
[]

[Samplers]
  [sample]
    type = MonteCarlo
    num_rows = 20000
    distributions = 'normal_kernel_r normal_buffer_t normal_ipyc_t normal_sic_t normal_opyc_t uniform uniform uniform'
    execute_on = 'PRE_MULTIAPP_SETUP'
  []
[]

[MultiApps]
  [particle1]
    type = SamplerFullSolveMultiApp
    mode = batch-reset
    input_files = triso_particle.i
    cli_args = 'particle_number=1;folder_name=${folder_name};end_time=${end_time}'
    sampler = sample
    execute_on = initial
  []
  [particle2]
    type = SamplerFullSolveMultiApp
    mode = batch-reset
    input_files = triso_particle.i
    cli_args = 'particle_number=2;folder_name=${folder_name};end_time=${end_time}'
    sampler = sample
    execute_on = initial
  []
  [particle3]
    type = SamplerFullSolveMultiApp
    mode = batch-reset
    input_files = triso_particle.i
    cli_args = 'particle_number=3;folder_name=${folder_name};end_time=${end_time}'
    sampler = sample
    execute_on = initial
  []
  [particle4]
    type = SamplerFullSolveMultiApp
    mode = batch-reset
    input_files = triso_particle.i
    cli_args = 'particle_number=4;folder_name=${folder_name};end_time=${end_time}'
    sampler = sample
    execute_on = initial
  []
  [particle5]
    type = SamplerFullSolveMultiApp
    mode = batch-reset
    input_files = triso_particle.i
    cli_args = 'particle_number=5;folder_name=${folder_name};end_time=${end_time}'
    sampler = sample
    execute_on = initial
  []
  [particle6]
    type = SamplerFullSolveMultiApp
    mode = batch-reset
    input_files = triso_particle.i
    cli_args = 'particle_number=6;folder_name=${folder_name};end_time=${end_time}'
    sampler = sample
    execute_on = initial
  []
  [particle7]
    type = SamplerFullSolveMultiApp
    mode = batch-reset
    input_files = triso_particle.i
    cli_args = 'particle_number=7;folder_name=${folder_name};end_time=${end_time}'
    sampler = sample
    execute_on = initial
  []
  [particle8]
    type = SamplerFullSolveMultiApp
    mode = batch-reset
    input_files = triso_particle.i
    cli_args = 'particle_number=8;folder_name=${folder_name};end_time=${end_time}'
    sampler = sample
    execute_on = initial
  []
  [particle9]
    type = SamplerFullSolveMultiApp
    mode = batch-reset
    input_files = triso_particle.i
    cli_args = 'particle_number=9;folder_name=${folder_name};end_time=${end_time}'
    sampler = sample
    execute_on = initial
  []
  [particle10]
    type = SamplerFullSolveMultiApp
    mode = batch-reset
    input_files = triso_particle.i
    cli_args = 'particle_number=10;folder_name=${folder_name};end_time=${end_time}'
    sampler = sample
    execute_on = initial
  []
  [particle11]
    type = SamplerFullSolveMultiApp
    mode = batch-reset
    input_files = triso_particle.i
    cli_args = 'particle_number=11;folder_name=${folder_name};end_time=${end_time}'
    sampler = sample
    execute_on = initial
  []
  [particle12]
    type = SamplerFullSolveMultiApp
    mode = batch-reset
    input_files = triso_particle.i
    cli_args = 'particle_number=12;folder_name=${folder_name};end_time=${end_time}'
    sampler = sample
    execute_on = initial
  []
  [particle13]
    type = SamplerFullSolveMultiApp
    mode = batch-reset
    input_files = triso_particle.i
    cli_args = 'particle_number=13;folder_name=${folder_name};end_time=${end_time}'
    sampler = sample
    execute_on = initial
  []
  [particle14]
    type = SamplerFullSolveMultiApp
    mode = batch-reset
    input_files = triso_particle.i
    cli_args = 'particle_number=14;folder_name=${folder_name};end_time=${end_time}'
    sampler = sample
    execute_on = initial
  []
  [particle15]
    type = SamplerFullSolveMultiApp
    mode = batch-reset
    input_files = triso_particle.i
    cli_args = 'particle_number=15;folder_name=${folder_name};end_time=${end_time}'
    sampler = sample
    execute_on = initial
  []
  [particle16]
    type = SamplerFullSolveMultiApp
    mode = batch-reset
    input_files = triso_particle.i
    cli_args = 'particle_number=16;folder_name=${folder_name};end_time=${end_time}'
    sampler = sample
    execute_on = initial
  []
  [particle17]
    type = SamplerFullSolveMultiApp
    mode = batch-reset
    input_files = triso_particle.i
    cli_args = 'particle_number=17;folder_name=${folder_name};end_time=${end_time}'
    sampler = sample
    execute_on = initial
  []
  [particle18]
    type = SamplerFullSolveMultiApp
    mode = batch-reset
    input_files = triso_particle.i
    cli_args = 'particle_number=18;folder_name=${folder_name};end_time=${end_time}'
    sampler = sample
    execute_on = initial
  []
  [particle19]
    type = SamplerFullSolveMultiApp
    mode = batch-reset
    input_files = triso_particle.i
    cli_args = 'particle_number=19;folder_name=${folder_name};end_time=${end_time}'
    sampler = sample
    execute_on = initial
  []
  [particle20]
    type = SamplerFullSolveMultiApp
    mode = batch-reset
    input_files = triso_particle.i
    cli_args = 'particle_number=20;folder_name=${folder_name};end_time=${end_time}'
    sampler = sample
    execute_on = initial
  []
  [particle21]
    type = SamplerFullSolveMultiApp
    mode = batch-reset
    input_files = triso_particle.i
    cli_args = 'particle_number=21;folder_name=${folder_name};end_time=${end_time}'
    sampler = sample
    execute_on = initial
  []
  [particle22]
    type = SamplerFullSolveMultiApp
    mode = batch-reset
    input_files = triso_particle.i
    cli_args = 'particle_number=22;folder_name=${folder_name};end_time=${end_time}'
    sampler = sample
    execute_on = initial
  []
  [particle23]
    type = SamplerFullSolveMultiApp
    mode = batch-reset
    input_files = triso_particle.i
    cli_args = 'particle_number=23;folder_name=${folder_name};end_time=${end_time}'
    sampler = sample
    execute_on = initial
  []
  [particle24]
    type = SamplerFullSolveMultiApp
    mode = batch-reset
    input_files = triso_particle.i
    cli_args = 'particle_number=24;folder_name=${folder_name};end_time=${end_time}'
    sampler = sample
    execute_on = initial
  []
  [particle25]
    type = SamplerFullSolveMultiApp
    mode = batch-reset
    input_files = triso_particle.i
    cli_args = 'particle_number=25;folder_name=${folder_name};end_time=${end_time}'
    sampler = sample
    execute_on = initial
  []
  [particle26]
    type = SamplerFullSolveMultiApp
    mode = batch-reset
    input_files = triso_particle.i
    cli_args = 'particle_number=26;folder_name=${folder_name};end_time=${end_time}'
    sampler = sample
    execute_on = initial
  []
  [particle27]
    type = SamplerFullSolveMultiApp
    mode = batch-reset
    input_files = triso_particle.i
    cli_args = 'particle_number=27;folder_name=${folder_name};end_time=${end_time}'
    sampler = sample
    execute_on = initial
  []
  [particle28]
    type = SamplerFullSolveMultiApp
    mode = batch-reset
    input_files = triso_particle.i
    cli_args = 'particle_number=28;folder_name=${folder_name};end_time=${end_time}'
    sampler = sample
    execute_on = initial
  []
  [particle29]
    type = SamplerFullSolveMultiApp
    mode = batch-reset
    input_files = triso_particle.i
    cli_args = 'particle_number=29;folder_name=${folder_name};end_time=${end_time}'
    sampler = sample
    execute_on = initial
  []
  [particle30]
    type = SamplerFullSolveMultiApp
    mode = batch-reset
    input_files = triso_particle.i
    cli_args = 'particle_number=30;folder_name=${folder_name};end_time=${end_time}'
    sampler = sample
    execute_on = initial
  []
  [particle31]
    type = SamplerFullSolveMultiApp
    mode = batch-reset
    input_files = triso_particle.i
    cli_args = 'particle_number=31;folder_name=${folder_name};end_time=${end_time}'
    sampler = sample
    execute_on = initial
  []
  [particle32]
    type = SamplerFullSolveMultiApp
    mode = batch-reset
    input_files = triso_particle.i
    cli_args = 'particle_number=32;folder_name=${folder_name};end_time=${end_time}'
    sampler = sample
    execute_on = initial
  []
[]

[Transfers]
  [failure_indicator_kernel_migration_particle1]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle1
    sampler = sample
    to_vector_postprocessor = particle1_failure_indicator_kernel_migration
    from_postprocessor = failure_indicator_kernel_migration
  []
  [kernel_migration_distance_particle1]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle1
    sampler = sample
    to_vector_postprocessor = particle1_kernel_migration_distance
    from_postprocessor = kernel_migration_distance
  []
  [pd_penetration_particle1]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle1
    sampler = sample
    to_vector_postprocessor = particle1_pd_penetration
    from_postprocessor = pd_penetration
  []
  [failure_indicator_pd_penetration_particle1]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle1
    sampler = sample
    to_vector_postprocessor = particle1_failure_indicator_pd_penetration
    from_postprocessor = failure_indicator_pd_penetration
  []
  [sic_failure_overall_particle1]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle1
    sampler = sample
    to_vector_postprocessor = particle1_sic_failure_overall
    from_postprocessor = sic_failure_overall
  []
  [ipyc_cracking_particle1]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle1
    sampler = sample
    to_vector_postprocessor = particle1_ipyc_cracking
    from_postprocessor = ipyc_cracking
  []
  [sic_failure_due_to_pressure_particle1]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle1
    sampler = sample
    to_vector_postprocessor = particle1_sic_failure_due_to_pressure
    from_postprocessor = sic_failure_due_to_pressure
  []
  [sic_failure_due_to_ipyc_cracking_particle1]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle1
    sampler = sample
    to_vector_postprocessor = particle1_sic_failure_due_to_ipyc_cracking
    from_postprocessor = sic_failure_due_to_ipyc_cracking
  []
  [max_fluence_particle1]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle1
    sampler = sample
    to_vector_postprocessor = particle1_max_fluence
    from_postprocessor = max_fluence
  []
  [fluence_at_failure_particle1]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle1
    sampler = sample
    to_vector_postprocessor = particle1_fluence_at_failure
    from_postprocessor = fluence_at_failure
  []
  [failure_indicator_kernel_migration_particle2]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle2
    sampler = sample
    to_vector_postprocessor = particle2_failure_indicator_kernel_migration
    from_postprocessor = failure_indicator_kernel_migration
  []
  [kernel_migration_distance_particle2]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle2
    sampler = sample
    to_vector_postprocessor = particle2_kernel_migration_distance
    from_postprocessor = kernel_migration_distance
  []
  [pd_penetration_particle2]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle2
    sampler = sample
    to_vector_postprocessor = particle2_pd_penetration
    from_postprocessor = pd_penetration
  []
  [failure_indicator_pd_penetration_particle2]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle2
    sampler = sample
    to_vector_postprocessor = particle2_failure_indicator_pd_penetration
    from_postprocessor = failure_indicator_pd_penetration
  []
  [sic_failure_overall_particle2]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle2
    sampler = sample
    to_vector_postprocessor = particle2_sic_failure_overall
    from_postprocessor = sic_failure_overall
  []
  [ipyc_cracking_particle2]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle2
    sampler = sample
    to_vector_postprocessor = particle2_ipyc_cracking
    from_postprocessor = ipyc_cracking
  []
  [sic_failure_due_to_pressure_particle2]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle2
    sampler = sample
    to_vector_postprocessor = particle2_sic_failure_due_to_pressure
    from_postprocessor = sic_failure_due_to_pressure
  []
  [sic_failure_due_to_ipyc_cracking_particle2]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle2
    sampler = sample
    to_vector_postprocessor = particle2_sic_failure_due_to_ipyc_cracking
    from_postprocessor = sic_failure_due_to_ipyc_cracking
  []
  [max_fluence_particle2]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle2
    sampler = sample
    to_vector_postprocessor = particle2_max_fluence
    from_postprocessor = max_fluence
  []
  [fluence_at_failure_particle2]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle2
    sampler = sample
    to_vector_postprocessor = particle2_fluence_at_failure
    from_postprocessor = fluence_at_failure
  []
  [failure_indicator_kernel_migration_particle3]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle3
    sampler = sample
    to_vector_postprocessor = particle3_failure_indicator_kernel_migration
    from_postprocessor = failure_indicator_kernel_migration
  []
  [kernel_migration_distance_particle3]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle3
    sampler = sample
    to_vector_postprocessor = particle3_kernel_migration_distance
    from_postprocessor = kernel_migration_distance
  []
  [pd_penetration_particle3]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle3
    sampler = sample
    to_vector_postprocessor = particle3_pd_penetration
    from_postprocessor = pd_penetration
  []
  [failure_indicator_pd_penetration_particle3]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle3
    sampler = sample
    to_vector_postprocessor = particle3_failure_indicator_pd_penetration
    from_postprocessor = failure_indicator_pd_penetration
  []
  [sic_failure_overall_particle3]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle3
    sampler = sample
    to_vector_postprocessor = particle3_sic_failure_overall
    from_postprocessor = sic_failure_overall
  []
  [ipyc_cracking_particle3]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle3
    sampler = sample
    to_vector_postprocessor = particle3_ipyc_cracking
    from_postprocessor = ipyc_cracking
  []
  [sic_failure_due_to_pressure_particle3]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle3
    sampler = sample
    to_vector_postprocessor = particle3_sic_failure_due_to_pressure
    from_postprocessor = sic_failure_due_to_pressure
  []
  [sic_failure_due_to_ipyc_cracking_particle3]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle3
    sampler = sample
    to_vector_postprocessor = particle3_sic_failure_due_to_ipyc_cracking
    from_postprocessor = sic_failure_due_to_ipyc_cracking
  []
  [max_fluence_particle3]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle3
    sampler = sample
    to_vector_postprocessor = particle3_max_fluence
    from_postprocessor = max_fluence
  []
  [fluence_at_failure_particle3]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle3
    sampler = sample
    to_vector_postprocessor = particle3_fluence_at_failure
    from_postprocessor = fluence_at_failure
  []
  [failure_indicator_kernel_migration_particle4]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle4
    sampler = sample
    to_vector_postprocessor = particle4_failure_indicator_kernel_migration
    from_postprocessor = failure_indicator_kernel_migration
  []
  [kernel_migration_distance_particle4]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle4
    sampler = sample
    to_vector_postprocessor = particle4_kernel_migration_distance
    from_postprocessor = kernel_migration_distance
  []
  [pd_penetration_particle4]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle4
    sampler = sample
    to_vector_postprocessor = particle4_pd_penetration
    from_postprocessor = pd_penetration
  []
  [failure_indicator_pd_penetration_particle4]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle4
    sampler = sample
    to_vector_postprocessor = particle4_failure_indicator_pd_penetration
    from_postprocessor = failure_indicator_pd_penetration
  []
  [sic_failure_overall_particle4]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle4
    sampler = sample
    to_vector_postprocessor = particle4_sic_failure_overall
    from_postprocessor = sic_failure_overall
  []
  [ipyc_cracking_particle4]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle4
    sampler = sample
    to_vector_postprocessor = particle4_ipyc_cracking
    from_postprocessor = ipyc_cracking
  []
  [sic_failure_due_to_pressure_particle4]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle4
    sampler = sample
    to_vector_postprocessor = particle4_sic_failure_due_to_pressure
    from_postprocessor = sic_failure_due_to_pressure
  []
  [sic_failure_due_to_ipyc_cracking_particle4]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle4
    sampler = sample
    to_vector_postprocessor = particle4_sic_failure_due_to_ipyc_cracking
    from_postprocessor = sic_failure_due_to_ipyc_cracking
  []
  [max_fluence_particle4]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle4
    sampler = sample
    to_vector_postprocessor = particle4_max_fluence
    from_postprocessor = max_fluence
  []
  [fluence_at_failure_particle4]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle4
    sampler = sample
    to_vector_postprocessor = particle4_fluence_at_failure
    from_postprocessor = fluence_at_failure
  []
  [failure_indicator_kernel_migration_particle5]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle5
    sampler = sample
    to_vector_postprocessor = particle5_failure_indicator_kernel_migration
    from_postprocessor = failure_indicator_kernel_migration
  []
  [kernel_migration_distance_particle5]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle5
    sampler = sample
    to_vector_postprocessor = particle5_kernel_migration_distance
    from_postprocessor = kernel_migration_distance
  []
  [pd_penetration_particle5]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle5
    sampler = sample
    to_vector_postprocessor = particle5_pd_penetration
    from_postprocessor = pd_penetration
  []
  [failure_indicator_pd_penetration_particle5]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle5
    sampler = sample
    to_vector_postprocessor = particle5_failure_indicator_pd_penetration
    from_postprocessor = failure_indicator_pd_penetration
  []
  [sic_failure_overall_particle5]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle5
    sampler = sample
    to_vector_postprocessor = particle5_sic_failure_overall
    from_postprocessor = sic_failure_overall
  []
  [ipyc_cracking_particle5]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle5
    sampler = sample
    to_vector_postprocessor = particle5_ipyc_cracking
    from_postprocessor = ipyc_cracking
  []
  [sic_failure_due_to_pressure_particle5]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle5
    sampler = sample
    to_vector_postprocessor = particle5_sic_failure_due_to_pressure
    from_postprocessor = sic_failure_due_to_pressure
  []
  [sic_failure_due_to_ipyc_cracking_particle5]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle5
    sampler = sample
    to_vector_postprocessor = particle5_sic_failure_due_to_ipyc_cracking
    from_postprocessor = sic_failure_due_to_ipyc_cracking
  []
  [max_fluence_particle5]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle5
    sampler = sample
    to_vector_postprocessor = particle5_max_fluence
    from_postprocessor = max_fluence
  []
  [fluence_at_failure_particle5]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle5
    sampler = sample
    to_vector_postprocessor = particle5_fluence_at_failure
    from_postprocessor = fluence_at_failure
  []
  [failure_indicator_kernel_migration_particle6]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle6
    sampler = sample
    to_vector_postprocessor = particle6_failure_indicator_kernel_migration
    from_postprocessor = failure_indicator_kernel_migration
  []
  [kernel_migration_distance_particle6]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle6
    sampler = sample
    to_vector_postprocessor = particle6_kernel_migration_distance
    from_postprocessor = kernel_migration_distance
  []
  [pd_penetration_particle6]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle6
    sampler = sample
    to_vector_postprocessor = particle6_pd_penetration
    from_postprocessor = pd_penetration
  []
  [failure_indicator_pd_penetration_particle6]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle6
    sampler = sample
    to_vector_postprocessor = particle6_failure_indicator_pd_penetration
    from_postprocessor = failure_indicator_pd_penetration
  []
  [sic_failure_overall_particle6]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle6
    sampler = sample
    to_vector_postprocessor = particle6_sic_failure_overall
    from_postprocessor = sic_failure_overall
  []
  [ipyc_cracking_particle6]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle6
    sampler = sample
    to_vector_postprocessor = particle6_ipyc_cracking
    from_postprocessor = ipyc_cracking
  []
  [sic_failure_due_to_pressure_particle6]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle6
    sampler = sample
    to_vector_postprocessor = particle6_sic_failure_due_to_pressure
    from_postprocessor = sic_failure_due_to_pressure
  []
  [sic_failure_due_to_ipyc_cracking_particle6]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle6
    sampler = sample
    to_vector_postprocessor = particle6_sic_failure_due_to_ipyc_cracking
    from_postprocessor = sic_failure_due_to_ipyc_cracking
  []
  [max_fluence_particle6]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle6
    sampler = sample
    to_vector_postprocessor = particle6_max_fluence
    from_postprocessor = max_fluence
  []
  [fluence_at_failure_particle6]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle6
    sampler = sample
    to_vector_postprocessor = particle6_fluence_at_failure
    from_postprocessor = fluence_at_failure
  []
  [failure_indicator_kernel_migration_particle7]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle7
    sampler = sample
    to_vector_postprocessor = particle7_failure_indicator_kernel_migration
    from_postprocessor = failure_indicator_kernel_migration
  []
  [kernel_migration_distance_particle7]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle7
    sampler = sample
    to_vector_postprocessor = particle7_kernel_migration_distance
    from_postprocessor = kernel_migration_distance
  []
  [pd_penetration_particle7]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle7
    sampler = sample
    to_vector_postprocessor = particle7_pd_penetration
    from_postprocessor = pd_penetration
  []
  [failure_indicator_pd_penetration_particle7]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle7
    sampler = sample
    to_vector_postprocessor = particle7_failure_indicator_pd_penetration
    from_postprocessor = failure_indicator_pd_penetration
  []
  [sic_failure_overall_particle7]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle7
    sampler = sample
    to_vector_postprocessor = particle7_sic_failure_overall
    from_postprocessor = sic_failure_overall
  []
  [ipyc_cracking_particle7]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle7
    sampler = sample
    to_vector_postprocessor = particle7_ipyc_cracking
    from_postprocessor = ipyc_cracking
  []
  [sic_failure_due_to_pressure_particle7]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle7
    sampler = sample
    to_vector_postprocessor = particle7_sic_failure_due_to_pressure
    from_postprocessor = sic_failure_due_to_pressure
  []
  [sic_failure_due_to_ipyc_cracking_particle7]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle7
    sampler = sample
    to_vector_postprocessor = particle7_sic_failure_due_to_ipyc_cracking
    from_postprocessor = sic_failure_due_to_ipyc_cracking
  []
  [max_fluence_particle7]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle7
    sampler = sample
    to_vector_postprocessor = particle7_max_fluence
    from_postprocessor = max_fluence
  []
  [fluence_at_failure_particle7]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle7
    sampler = sample
    to_vector_postprocessor = particle7_fluence_at_failure
    from_postprocessor = fluence_at_failure
  []
  [failure_indicator_kernel_migration_particle8]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle8
    sampler = sample
    to_vector_postprocessor = particle8_failure_indicator_kernel_migration
    from_postprocessor = failure_indicator_kernel_migration
  []
  [kernel_migration_distance_particle8]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle8
    sampler = sample
    to_vector_postprocessor = particle8_kernel_migration_distance
    from_postprocessor = kernel_migration_distance
  []
  [pd_penetration_particle8]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle8
    sampler = sample
    to_vector_postprocessor = particle8_pd_penetration
    from_postprocessor = pd_penetration
  []
  [failure_indicator_pd_penetration_particle8]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle8
    sampler = sample
    to_vector_postprocessor = particle8_failure_indicator_pd_penetration
    from_postprocessor = failure_indicator_pd_penetration
  []
  [sic_failure_overall_particle8]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle8
    sampler = sample
    to_vector_postprocessor = particle8_sic_failure_overall
    from_postprocessor = sic_failure_overall
  []
  [ipyc_cracking_particle8]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle8
    sampler = sample
    to_vector_postprocessor = particle8_ipyc_cracking
    from_postprocessor = ipyc_cracking
  []
  [sic_failure_due_to_pressure_particle8]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle8
    sampler = sample
    to_vector_postprocessor = particle8_sic_failure_due_to_pressure
    from_postprocessor = sic_failure_due_to_pressure
  []
  [sic_failure_due_to_ipyc_cracking_particle8]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle8
    sampler = sample
    to_vector_postprocessor = particle8_sic_failure_due_to_ipyc_cracking
    from_postprocessor = sic_failure_due_to_ipyc_cracking
  []
  [max_fluence_particle8]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle8
    sampler = sample
    to_vector_postprocessor = particle8_max_fluence
    from_postprocessor = max_fluence
  []
  [fluence_at_failure_particle8]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle8
    sampler = sample
    to_vector_postprocessor = particle8_fluence_at_failure
    from_postprocessor = fluence_at_failure
  []
  [failure_indicator_kernel_migration_particle9]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle9
    sampler = sample
    to_vector_postprocessor = particle9_failure_indicator_kernel_migration
    from_postprocessor = failure_indicator_kernel_migration
  []
  [kernel_migration_distance_particle9]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle9
    sampler = sample
    to_vector_postprocessor = particle9_kernel_migration_distance
    from_postprocessor = kernel_migration_distance
  []
  [pd_penetration_particle9]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle9
    sampler = sample
    to_vector_postprocessor = particle9_pd_penetration
    from_postprocessor = pd_penetration
  []
  [failure_indicator_pd_penetration_particle9]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle9
    sampler = sample
    to_vector_postprocessor = particle9_failure_indicator_pd_penetration
    from_postprocessor = failure_indicator_pd_penetration
  []
  [sic_failure_overall_particle9]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle9
    sampler = sample
    to_vector_postprocessor = particle9_sic_failure_overall
    from_postprocessor = sic_failure_overall
  []
  [ipyc_cracking_particle9]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle9
    sampler = sample
    to_vector_postprocessor = particle9_ipyc_cracking
    from_postprocessor = ipyc_cracking
  []
  [sic_failure_due_to_pressure_particle9]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle9
    sampler = sample
    to_vector_postprocessor = particle9_sic_failure_due_to_pressure
    from_postprocessor = sic_failure_due_to_pressure
  []
  [sic_failure_due_to_ipyc_cracking_particle9]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle9
    sampler = sample
    to_vector_postprocessor = particle9_sic_failure_due_to_ipyc_cracking
    from_postprocessor = sic_failure_due_to_ipyc_cracking
  []
  [max_fluence_particle9]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle9
    sampler = sample
    to_vector_postprocessor = particle9_max_fluence
    from_postprocessor = max_fluence
  []
  [fluence_at_failure_particle9]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle9
    sampler = sample
    to_vector_postprocessor = particle9_fluence_at_failure
    from_postprocessor = fluence_at_failure
  []
  [failure_indicator_kernel_migration_particle10]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle10
    sampler = sample
    to_vector_postprocessor = particle10_failure_indicator_kernel_migration
    from_postprocessor = failure_indicator_kernel_migration
  []
  [kernel_migration_distance_particle10]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle10
    sampler = sample
    to_vector_postprocessor = particle10_kernel_migration_distance
    from_postprocessor = kernel_migration_distance
  []
  [pd_penetration_particle10]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle10
    sampler = sample
    to_vector_postprocessor = particle10_pd_penetration
    from_postprocessor = pd_penetration
  []
  [failure_indicator_pd_penetration_particle10]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle10
    sampler = sample
    to_vector_postprocessor = particle10_failure_indicator_pd_penetration
    from_postprocessor = failure_indicator_pd_penetration
  []
  [sic_failure_overall_particle10]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle10
    sampler = sample
    to_vector_postprocessor = particle10_sic_failure_overall
    from_postprocessor = sic_failure_overall
  []
  [ipyc_cracking_particle10]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle10
    sampler = sample
    to_vector_postprocessor = particle10_ipyc_cracking
    from_postprocessor = ipyc_cracking
  []
  [sic_failure_due_to_pressure_particle10]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle10
    sampler = sample
    to_vector_postprocessor = particle10_sic_failure_due_to_pressure
    from_postprocessor = sic_failure_due_to_pressure
  []
  [sic_failure_due_to_ipyc_cracking_particle10]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle10
    sampler = sample
    to_vector_postprocessor = particle10_sic_failure_due_to_ipyc_cracking
    from_postprocessor = sic_failure_due_to_ipyc_cracking
  []
  [max_fluence_particle10]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle10
    sampler = sample
    to_vector_postprocessor = particle10_max_fluence
    from_postprocessor = max_fluence
  []
  [fluence_at_failure_particle10]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle10
    sampler = sample
    to_vector_postprocessor = particle10_fluence_at_failure
    from_postprocessor = fluence_at_failure
  []
  [failure_indicator_kernel_migration_particle11]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle11
    sampler = sample
    to_vector_postprocessor = particle11_failure_indicator_kernel_migration
    from_postprocessor = failure_indicator_kernel_migration
  []
  [kernel_migration_distance_particle11]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle11
    sampler = sample
    to_vector_postprocessor = particle11_kernel_migration_distance
    from_postprocessor = kernel_migration_distance
  []
  [pd_penetration_particle11]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle11
    sampler = sample
    to_vector_postprocessor = particle11_pd_penetration
    from_postprocessor = pd_penetration
  []
  [failure_indicator_pd_penetration_particle11]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle11
    sampler = sample
    to_vector_postprocessor = particle11_failure_indicator_pd_penetration
    from_postprocessor = failure_indicator_pd_penetration
  []
  [sic_failure_overall_particle11]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle11
    sampler = sample
    to_vector_postprocessor = particle11_sic_failure_overall
    from_postprocessor = sic_failure_overall
  []
  [ipyc_cracking_particle11]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle11
    sampler = sample
    to_vector_postprocessor = particle11_ipyc_cracking
    from_postprocessor = ipyc_cracking
  []
  [sic_failure_due_to_pressure_particle11]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle11
    sampler = sample
    to_vector_postprocessor = particle11_sic_failure_due_to_pressure
    from_postprocessor = sic_failure_due_to_pressure
  []
  [sic_failure_due_to_ipyc_cracking_particle11]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle11
    sampler = sample
    to_vector_postprocessor = particle11_sic_failure_due_to_ipyc_cracking
    from_postprocessor = sic_failure_due_to_ipyc_cracking
  []
  [max_fluence_particle11]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle11
    sampler = sample
    to_vector_postprocessor = particle11_max_fluence
    from_postprocessor = max_fluence
  []
  [fluence_at_failure_particle11]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle11
    sampler = sample
    to_vector_postprocessor = particle11_fluence_at_failure
    from_postprocessor = fluence_at_failure
  []
  [failure_indicator_kernel_migration_particle12]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle12
    sampler = sample
    to_vector_postprocessor = particle12_failure_indicator_kernel_migration
    from_postprocessor = failure_indicator_kernel_migration
  []
  [kernel_migration_distance_particle12]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle12
    sampler = sample
    to_vector_postprocessor = particle12_kernel_migration_distance
    from_postprocessor = kernel_migration_distance
  []
  [pd_penetration_particle12]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle12
    sampler = sample
    to_vector_postprocessor = particle12_pd_penetration
    from_postprocessor = pd_penetration
  []
  [failure_indicator_pd_penetration_particle12]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle12
    sampler = sample
    to_vector_postprocessor = particle12_failure_indicator_pd_penetration
    from_postprocessor = failure_indicator_pd_penetration
  []
  [sic_failure_overall_particle12]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle12
    sampler = sample
    to_vector_postprocessor = particle12_sic_failure_overall
    from_postprocessor = sic_failure_overall
  []
  [ipyc_cracking_particle12]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle12
    sampler = sample
    to_vector_postprocessor = particle12_ipyc_cracking
    from_postprocessor = ipyc_cracking
  []
  [sic_failure_due_to_pressure_particle12]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle12
    sampler = sample
    to_vector_postprocessor = particle12_sic_failure_due_to_pressure
    from_postprocessor = sic_failure_due_to_pressure
  []
  [sic_failure_due_to_ipyc_cracking_particle12]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle12
    sampler = sample
    to_vector_postprocessor = particle12_sic_failure_due_to_ipyc_cracking
    from_postprocessor = sic_failure_due_to_ipyc_cracking
  []
  [max_fluence_particle12]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle12
    sampler = sample
    to_vector_postprocessor = particle12_max_fluence
    from_postprocessor = max_fluence
  []
  [fluence_at_failure_particle12]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle12
    sampler = sample
    to_vector_postprocessor = particle12_fluence_at_failure
    from_postprocessor = fluence_at_failure
  []
  [failure_indicator_kernel_migration_particle13]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle13
    sampler = sample
    to_vector_postprocessor = particle13_failure_indicator_kernel_migration
    from_postprocessor = failure_indicator_kernel_migration
  []
  [kernel_migration_distance_particle13]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle13
    sampler = sample
    to_vector_postprocessor = particle13_kernel_migration_distance
    from_postprocessor = kernel_migration_distance
  []
  [pd_penetration_particle13]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle13
    sampler = sample
    to_vector_postprocessor = particle13_pd_penetration
    from_postprocessor = pd_penetration
  []
  [failure_indicator_pd_penetration_particle13]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle13
    sampler = sample
    to_vector_postprocessor = particle13_failure_indicator_pd_penetration
    from_postprocessor = failure_indicator_pd_penetration
  []
  [sic_failure_overall_particle13]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle13
    sampler = sample
    to_vector_postprocessor = particle13_sic_failure_overall
    from_postprocessor = sic_failure_overall
  []
  [ipyc_cracking_particle13]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle13
    sampler = sample
    to_vector_postprocessor = particle13_ipyc_cracking
    from_postprocessor = ipyc_cracking
  []
  [sic_failure_due_to_pressure_particle13]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle13
    sampler = sample
    to_vector_postprocessor = particle13_sic_failure_due_to_pressure
    from_postprocessor = sic_failure_due_to_pressure
  []
  [sic_failure_due_to_ipyc_cracking_particle13]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle13
    sampler = sample
    to_vector_postprocessor = particle13_sic_failure_due_to_ipyc_cracking
    from_postprocessor = sic_failure_due_to_ipyc_cracking
  []
  [max_fluence_particle13]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle13
    sampler = sample
    to_vector_postprocessor = particle13_max_fluence
    from_postprocessor = max_fluence
  []
  [fluence_at_failure_particle13]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle13
    sampler = sample
    to_vector_postprocessor = particle13_fluence_at_failure
    from_postprocessor = fluence_at_failure
  []
  [failure_indicator_kernel_migration_particle14]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle14
    sampler = sample
    to_vector_postprocessor = particle14_failure_indicator_kernel_migration
    from_postprocessor = failure_indicator_kernel_migration
  []
  [kernel_migration_distance_particle14]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle14
    sampler = sample
    to_vector_postprocessor = particle14_kernel_migration_distance
    from_postprocessor = kernel_migration_distance
  []
  [pd_penetration_particle14]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle14
    sampler = sample
    to_vector_postprocessor = particle14_pd_penetration
    from_postprocessor = pd_penetration
  []
  [failure_indicator_pd_penetration_particle14]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle14
    sampler = sample
    to_vector_postprocessor = particle14_failure_indicator_pd_penetration
    from_postprocessor = failure_indicator_pd_penetration
  []
  [sic_failure_overall_particle14]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle14
    sampler = sample
    to_vector_postprocessor = particle14_sic_failure_overall
    from_postprocessor = sic_failure_overall
  []
  [ipyc_cracking_particle14]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle14
    sampler = sample
    to_vector_postprocessor = particle14_ipyc_cracking
    from_postprocessor = ipyc_cracking
  []
  [sic_failure_due_to_pressure_particle14]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle14
    sampler = sample
    to_vector_postprocessor = particle14_sic_failure_due_to_pressure
    from_postprocessor = sic_failure_due_to_pressure
  []
  [sic_failure_due_to_ipyc_cracking_particle14]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle14
    sampler = sample
    to_vector_postprocessor = particle14_sic_failure_due_to_ipyc_cracking
    from_postprocessor = sic_failure_due_to_ipyc_cracking
  []
  [max_fluence_particle14]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle14
    sampler = sample
    to_vector_postprocessor = particle14_max_fluence
    from_postprocessor = max_fluence
  []
  [fluence_at_failure_particle14]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle14
    sampler = sample
    to_vector_postprocessor = particle14_fluence_at_failure
    from_postprocessor = fluence_at_failure
  []
  [failure_indicator_kernel_migration_particle15]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle15
    sampler = sample
    to_vector_postprocessor = particle15_failure_indicator_kernel_migration
    from_postprocessor = failure_indicator_kernel_migration
  []
  [kernel_migration_distance_particle15]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle15
    sampler = sample
    to_vector_postprocessor = particle15_kernel_migration_distance
    from_postprocessor = kernel_migration_distance
  []
  [pd_penetration_particle15]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle15
    sampler = sample
    to_vector_postprocessor = particle15_pd_penetration
    from_postprocessor = pd_penetration
  []
  [failure_indicator_pd_penetration_particle15]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle15
    sampler = sample
    to_vector_postprocessor = particle15_failure_indicator_pd_penetration
    from_postprocessor = failure_indicator_pd_penetration
  []
  [sic_failure_overall_particle15]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle15
    sampler = sample
    to_vector_postprocessor = particle15_sic_failure_overall
    from_postprocessor = sic_failure_overall
  []
  [ipyc_cracking_particle15]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle15
    sampler = sample
    to_vector_postprocessor = particle15_ipyc_cracking
    from_postprocessor = ipyc_cracking
  []
  [sic_failure_due_to_pressure_particle15]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle15
    sampler = sample
    to_vector_postprocessor = particle15_sic_failure_due_to_pressure
    from_postprocessor = sic_failure_due_to_pressure
  []
  [sic_failure_due_to_ipyc_cracking_particle15]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle15
    sampler = sample
    to_vector_postprocessor = particle15_sic_failure_due_to_ipyc_cracking
    from_postprocessor = sic_failure_due_to_ipyc_cracking
  []
  [max_fluence_particle15]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle15
    sampler = sample
    to_vector_postprocessor = particle15_max_fluence
    from_postprocessor = max_fluence
  []
  [fluence_at_failure_particle15]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle15
    sampler = sample
    to_vector_postprocessor = particle15_fluence_at_failure
    from_postprocessor = fluence_at_failure
  []
  [failure_indicator_kernel_migration_particle16]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle16
    sampler = sample
    to_vector_postprocessor = particle16_failure_indicator_kernel_migration
    from_postprocessor = failure_indicator_kernel_migration
  []
  [kernel_migration_distance_particle16]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle16
    sampler = sample
    to_vector_postprocessor = particle16_kernel_migration_distance
    from_postprocessor = kernel_migration_distance
  []
  [pd_penetration_particle16]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle16
    sampler = sample
    to_vector_postprocessor = particle16_pd_penetration
    from_postprocessor = pd_penetration
  []
  [failure_indicator_pd_penetration_particle16]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle16
    sampler = sample
    to_vector_postprocessor = particle16_failure_indicator_pd_penetration
    from_postprocessor = failure_indicator_pd_penetration
  []
  [sic_failure_overall_particle16]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle16
    sampler = sample
    to_vector_postprocessor = particle16_sic_failure_overall
    from_postprocessor = sic_failure_overall
  []
  [ipyc_cracking_particle16]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle16
    sampler = sample
    to_vector_postprocessor = particle16_ipyc_cracking
    from_postprocessor = ipyc_cracking
  []
  [sic_failure_due_to_pressure_particle16]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle16
    sampler = sample
    to_vector_postprocessor = particle16_sic_failure_due_to_pressure
    from_postprocessor = sic_failure_due_to_pressure
  []
  [sic_failure_due_to_ipyc_cracking_particle16]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle16
    sampler = sample
    to_vector_postprocessor = particle16_sic_failure_due_to_ipyc_cracking
    from_postprocessor = sic_failure_due_to_ipyc_cracking
  []
  [max_fluence_particle16]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle16
    sampler = sample
    to_vector_postprocessor = particle16_max_fluence
    from_postprocessor = max_fluence
  []
  [fluence_at_failure_particle16]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle16
    sampler = sample
    to_vector_postprocessor = particle16_fluence_at_failure
    from_postprocessor = fluence_at_failure
  []
  [failure_indicator_kernel_migration_particle17]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle17
    sampler = sample
    to_vector_postprocessor = particle17_failure_indicator_kernel_migration
    from_postprocessor = failure_indicator_kernel_migration
  []
  [kernel_migration_distance_particle17]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle17
    sampler = sample
    to_vector_postprocessor = particle17_kernel_migration_distance
    from_postprocessor = kernel_migration_distance
  []
  [pd_penetration_particle17]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle17
    sampler = sample
    to_vector_postprocessor = particle17_pd_penetration
    from_postprocessor = pd_penetration
  []
  [failure_indicator_pd_penetration_particle17]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle17
    sampler = sample
    to_vector_postprocessor = particle17_failure_indicator_pd_penetration
    from_postprocessor = failure_indicator_pd_penetration
  []
  [sic_failure_overall_particle17]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle17
    sampler = sample
    to_vector_postprocessor = particle17_sic_failure_overall
    from_postprocessor = sic_failure_overall
  []
  [ipyc_cracking_particle17]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle17
    sampler = sample
    to_vector_postprocessor = particle17_ipyc_cracking
    from_postprocessor = ipyc_cracking
  []
  [sic_failure_due_to_pressure_particle17]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle17
    sampler = sample
    to_vector_postprocessor = particle17_sic_failure_due_to_pressure
    from_postprocessor = sic_failure_due_to_pressure
  []
  [sic_failure_due_to_ipyc_cracking_particle17]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle17
    sampler = sample
    to_vector_postprocessor = particle17_sic_failure_due_to_ipyc_cracking
    from_postprocessor = sic_failure_due_to_ipyc_cracking
  []
  [max_fluence_particle17]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle17
    sampler = sample
    to_vector_postprocessor = particle17_max_fluence
    from_postprocessor = max_fluence
  []
  [fluence_at_failure_particle17]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle17
    sampler = sample
    to_vector_postprocessor = particle17_fluence_at_failure
    from_postprocessor = fluence_at_failure
  []
  [failure_indicator_kernel_migration_particle18]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle18
    sampler = sample
    to_vector_postprocessor = particle18_failure_indicator_kernel_migration
    from_postprocessor = failure_indicator_kernel_migration
  []
  [kernel_migration_distance_particle18]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle18
    sampler = sample
    to_vector_postprocessor = particle18_kernel_migration_distance
    from_postprocessor = kernel_migration_distance
  []
  [pd_penetration_particle18]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle18
    sampler = sample
    to_vector_postprocessor = particle18_pd_penetration
    from_postprocessor = pd_penetration
  []
  [failure_indicator_pd_penetration_particle18]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle18
    sampler = sample
    to_vector_postprocessor = particle18_failure_indicator_pd_penetration
    from_postprocessor = failure_indicator_pd_penetration
  []
  [sic_failure_overall_particle18]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle18
    sampler = sample
    to_vector_postprocessor = particle18_sic_failure_overall
    from_postprocessor = sic_failure_overall
  []
  [ipyc_cracking_particle18]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle18
    sampler = sample
    to_vector_postprocessor = particle18_ipyc_cracking
    from_postprocessor = ipyc_cracking
  []
  [sic_failure_due_to_pressure_particle18]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle18
    sampler = sample
    to_vector_postprocessor = particle18_sic_failure_due_to_pressure
    from_postprocessor = sic_failure_due_to_pressure
  []
  [sic_failure_due_to_ipyc_cracking_particle18]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle18
    sampler = sample
    to_vector_postprocessor = particle18_sic_failure_due_to_ipyc_cracking
    from_postprocessor = sic_failure_due_to_ipyc_cracking
  []
  [max_fluence_particle18]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle18
    sampler = sample
    to_vector_postprocessor = particle18_max_fluence
    from_postprocessor = max_fluence
  []
  [fluence_at_failure_particle18]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle18
    sampler = sample
    to_vector_postprocessor = particle18_fluence_at_failure
    from_postprocessor = fluence_at_failure
  []
  [failure_indicator_kernel_migration_particle19]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle19
    sampler = sample
    to_vector_postprocessor = particle19_failure_indicator_kernel_migration
    from_postprocessor = failure_indicator_kernel_migration
  []
  [kernel_migration_distance_particle19]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle19
    sampler = sample
    to_vector_postprocessor = particle19_kernel_migration_distance
    from_postprocessor = kernel_migration_distance
  []
  [pd_penetration_particle19]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle19
    sampler = sample
    to_vector_postprocessor = particle19_pd_penetration
    from_postprocessor = pd_penetration
  []
  [failure_indicator_pd_penetration_particle19]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle19
    sampler = sample
    to_vector_postprocessor = particle19_failure_indicator_pd_penetration
    from_postprocessor = failure_indicator_pd_penetration
  []
  [sic_failure_overall_particle19]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle19
    sampler = sample
    to_vector_postprocessor = particle19_sic_failure_overall
    from_postprocessor = sic_failure_overall
  []
  [ipyc_cracking_particle19]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle19
    sampler = sample
    to_vector_postprocessor = particle19_ipyc_cracking
    from_postprocessor = ipyc_cracking
  []
  [sic_failure_due_to_pressure_particle19]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle19
    sampler = sample
    to_vector_postprocessor = particle19_sic_failure_due_to_pressure
    from_postprocessor = sic_failure_due_to_pressure
  []
  [sic_failure_due_to_ipyc_cracking_particle19]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle19
    sampler = sample
    to_vector_postprocessor = particle19_sic_failure_due_to_ipyc_cracking
    from_postprocessor = sic_failure_due_to_ipyc_cracking
  []
  [max_fluence_particle19]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle19
    sampler = sample
    to_vector_postprocessor = particle19_max_fluence
    from_postprocessor = max_fluence
  []
  [fluence_at_failure_particle19]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle19
    sampler = sample
    to_vector_postprocessor = particle19_fluence_at_failure
    from_postprocessor = fluence_at_failure
  []
  [failure_indicator_kernel_migration_particle20]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle20
    sampler = sample
    to_vector_postprocessor = particle20_failure_indicator_kernel_migration
    from_postprocessor = failure_indicator_kernel_migration
  []
  [kernel_migration_distance_particle20]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle20
    sampler = sample
    to_vector_postprocessor = particle20_kernel_migration_distance
    from_postprocessor = kernel_migration_distance
  []
  [pd_penetration_particle20]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle20
    sampler = sample
    to_vector_postprocessor = particle20_pd_penetration
    from_postprocessor = pd_penetration
  []
  [failure_indicator_pd_penetration_particle20]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle20
    sampler = sample
    to_vector_postprocessor = particle20_failure_indicator_pd_penetration
    from_postprocessor = failure_indicator_pd_penetration
  []
  [sic_failure_overall_particle20]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle20
    sampler = sample
    to_vector_postprocessor = particle20_sic_failure_overall
    from_postprocessor = sic_failure_overall
  []
  [ipyc_cracking_particle20]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle20
    sampler = sample
    to_vector_postprocessor = particle20_ipyc_cracking
    from_postprocessor = ipyc_cracking
  []
  [sic_failure_due_to_pressure_particle20]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle20
    sampler = sample
    to_vector_postprocessor = particle20_sic_failure_due_to_pressure
    from_postprocessor = sic_failure_due_to_pressure
  []
  [sic_failure_due_to_ipyc_cracking_particle20]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle20
    sampler = sample
    to_vector_postprocessor = particle20_sic_failure_due_to_ipyc_cracking
    from_postprocessor = sic_failure_due_to_ipyc_cracking
  []
  [max_fluence_particle20]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle20
    sampler = sample
    to_vector_postprocessor = particle20_max_fluence
    from_postprocessor = max_fluence
  []
  [fluence_at_failure_particle20]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle20
    sampler = sample
    to_vector_postprocessor = particle20_fluence_at_failure
    from_postprocessor = fluence_at_failure
  []
  [failure_indicator_kernel_migration_particle21]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle21
    sampler = sample
    to_vector_postprocessor = particle21_failure_indicator_kernel_migration
    from_postprocessor = failure_indicator_kernel_migration
  []
  [kernel_migration_distance_particle21]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle21
    sampler = sample
    to_vector_postprocessor = particle21_kernel_migration_distance
    from_postprocessor = kernel_migration_distance
  []
  [pd_penetration_particle21]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle21
    sampler = sample
    to_vector_postprocessor = particle21_pd_penetration
    from_postprocessor = pd_penetration
  []
  [failure_indicator_pd_penetration_particle21]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle21
    sampler = sample
    to_vector_postprocessor = particle21_failure_indicator_pd_penetration
    from_postprocessor = failure_indicator_pd_penetration
  []
  [sic_failure_overall_particle21]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle21
    sampler = sample
    to_vector_postprocessor = particle21_sic_failure_overall
    from_postprocessor = sic_failure_overall
  []
  [ipyc_cracking_particle21]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle21
    sampler = sample
    to_vector_postprocessor = particle21_ipyc_cracking
    from_postprocessor = ipyc_cracking
  []
  [sic_failure_due_to_pressure_particle21]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle21
    sampler = sample
    to_vector_postprocessor = particle21_sic_failure_due_to_pressure
    from_postprocessor = sic_failure_due_to_pressure
  []
  [sic_failure_due_to_ipyc_cracking_particle21]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle21
    sampler = sample
    to_vector_postprocessor = particle21_sic_failure_due_to_ipyc_cracking
    from_postprocessor = sic_failure_due_to_ipyc_cracking
  []
  [max_fluence_particle21]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle21
    sampler = sample
    to_vector_postprocessor = particle21_max_fluence
    from_postprocessor = max_fluence
  []
  [fluence_at_failure_particle21]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle21
    sampler = sample
    to_vector_postprocessor = particle21_fluence_at_failure
    from_postprocessor = fluence_at_failure
  []
  [failure_indicator_kernel_migration_particle22]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle22
    sampler = sample
    to_vector_postprocessor = particle22_failure_indicator_kernel_migration
    from_postprocessor = failure_indicator_kernel_migration
  []
  [kernel_migration_distance_particle22]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle22
    sampler = sample
    to_vector_postprocessor = particle22_kernel_migration_distance
    from_postprocessor = kernel_migration_distance
  []
  [pd_penetration_particle22]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle22
    sampler = sample
    to_vector_postprocessor = particle22_pd_penetration
    from_postprocessor = pd_penetration
  []
  [failure_indicator_pd_penetration_particle22]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle22
    sampler = sample
    to_vector_postprocessor = particle22_failure_indicator_pd_penetration
    from_postprocessor = failure_indicator_pd_penetration
  []
  [sic_failure_overall_particle22]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle22
    sampler = sample
    to_vector_postprocessor = particle22_sic_failure_overall
    from_postprocessor = sic_failure_overall
  []
  [ipyc_cracking_particle22]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle22
    sampler = sample
    to_vector_postprocessor = particle22_ipyc_cracking
    from_postprocessor = ipyc_cracking
  []
  [sic_failure_due_to_pressure_particle22]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle22
    sampler = sample
    to_vector_postprocessor = particle22_sic_failure_due_to_pressure
    from_postprocessor = sic_failure_due_to_pressure
  []
  [sic_failure_due_to_ipyc_cracking_particle22]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle22
    sampler = sample
    to_vector_postprocessor = particle22_sic_failure_due_to_ipyc_cracking
    from_postprocessor = sic_failure_due_to_ipyc_cracking
  []
  [max_fluence_particle22]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle22
    sampler = sample
    to_vector_postprocessor = particle22_max_fluence
    from_postprocessor = max_fluence
  []
  [fluence_at_failure_particle22]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle22
    sampler = sample
    to_vector_postprocessor = particle22_fluence_at_failure
    from_postprocessor = fluence_at_failure
  []
  [failure_indicator_kernel_migration_particle23]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle23
    sampler = sample
    to_vector_postprocessor = particle23_failure_indicator_kernel_migration
    from_postprocessor = failure_indicator_kernel_migration
  []
  [kernel_migration_distance_particle23]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle23
    sampler = sample
    to_vector_postprocessor = particle23_kernel_migration_distance
    from_postprocessor = kernel_migration_distance
  []
  [pd_penetration_particle23]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle23
    sampler = sample
    to_vector_postprocessor = particle23_pd_penetration
    from_postprocessor = pd_penetration
  []
  [failure_indicator_pd_penetration_particle23]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle23
    sampler = sample
    to_vector_postprocessor = particle23_failure_indicator_pd_penetration
    from_postprocessor = failure_indicator_pd_penetration
  []
  [sic_failure_overall_particle23]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle23
    sampler = sample
    to_vector_postprocessor = particle23_sic_failure_overall
    from_postprocessor = sic_failure_overall
  []
  [ipyc_cracking_particle23]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle23
    sampler = sample
    to_vector_postprocessor = particle23_ipyc_cracking
    from_postprocessor = ipyc_cracking
  []
  [sic_failure_due_to_pressure_particle23]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle23
    sampler = sample
    to_vector_postprocessor = particle23_sic_failure_due_to_pressure
    from_postprocessor = sic_failure_due_to_pressure
  []
  [sic_failure_due_to_ipyc_cracking_particle23]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle23
    sampler = sample
    to_vector_postprocessor = particle23_sic_failure_due_to_ipyc_cracking
    from_postprocessor = sic_failure_due_to_ipyc_cracking
  []
  [max_fluence_particle23]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle23
    sampler = sample
    to_vector_postprocessor = particle23_max_fluence
    from_postprocessor = max_fluence
  []
  [fluence_at_failure_particle23]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle23
    sampler = sample
    to_vector_postprocessor = particle23_fluence_at_failure
    from_postprocessor = fluence_at_failure
  []
  [failure_indicator_kernel_migration_particle24]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle24
    sampler = sample
    to_vector_postprocessor = particle24_failure_indicator_kernel_migration
    from_postprocessor = failure_indicator_kernel_migration
  []
  [kernel_migration_distance_particle24]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle24
    sampler = sample
    to_vector_postprocessor = particle24_kernel_migration_distance
    from_postprocessor = kernel_migration_distance
  []
  [pd_penetration_particle24]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle24
    sampler = sample
    to_vector_postprocessor = particle24_pd_penetration
    from_postprocessor = pd_penetration
  []
  [failure_indicator_pd_penetration_particle24]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle24
    sampler = sample
    to_vector_postprocessor = particle24_failure_indicator_pd_penetration
    from_postprocessor = failure_indicator_pd_penetration
  []
  [sic_failure_overall_particle24]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle24
    sampler = sample
    to_vector_postprocessor = particle24_sic_failure_overall
    from_postprocessor = sic_failure_overall
  []
  [ipyc_cracking_particle24]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle24
    sampler = sample
    to_vector_postprocessor = particle24_ipyc_cracking
    from_postprocessor = ipyc_cracking
  []
  [sic_failure_due_to_pressure_particle24]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle24
    sampler = sample
    to_vector_postprocessor = particle24_sic_failure_due_to_pressure
    from_postprocessor = sic_failure_due_to_pressure
  []
  [sic_failure_due_to_ipyc_cracking_particle24]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle24
    sampler = sample
    to_vector_postprocessor = particle24_sic_failure_due_to_ipyc_cracking
    from_postprocessor = sic_failure_due_to_ipyc_cracking
  []
  [max_fluence_particle24]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle24
    sampler = sample
    to_vector_postprocessor = particle24_max_fluence
    from_postprocessor = max_fluence
  []
  [fluence_at_failure_particle24]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle24
    sampler = sample
    to_vector_postprocessor = particle24_fluence_at_failure
    from_postprocessor = fluence_at_failure
  []
  [failure_indicator_kernel_migration_particle25]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle25
    sampler = sample
    to_vector_postprocessor = particle25_failure_indicator_kernel_migration
    from_postprocessor = failure_indicator_kernel_migration
  []
  [kernel_migration_distance_particle25]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle25
    sampler = sample
    to_vector_postprocessor = particle25_kernel_migration_distance
    from_postprocessor = kernel_migration_distance
  []
  [pd_penetration_particle25]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle25
    sampler = sample
    to_vector_postprocessor = particle25_pd_penetration
    from_postprocessor = pd_penetration
  []
  [failure_indicator_pd_penetration_particle25]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle25
    sampler = sample
    to_vector_postprocessor = particle25_failure_indicator_pd_penetration
    from_postprocessor = failure_indicator_pd_penetration
  []
  [sic_failure_overall_particle25]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle25
    sampler = sample
    to_vector_postprocessor = particle25_sic_failure_overall
    from_postprocessor = sic_failure_overall
  []
  [ipyc_cracking_particle25]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle25
    sampler = sample
    to_vector_postprocessor = particle25_ipyc_cracking
    from_postprocessor = ipyc_cracking
  []
  [sic_failure_due_to_pressure_particle25]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle25
    sampler = sample
    to_vector_postprocessor = particle25_sic_failure_due_to_pressure
    from_postprocessor = sic_failure_due_to_pressure
  []
  [sic_failure_due_to_ipyc_cracking_particle25]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle25
    sampler = sample
    to_vector_postprocessor = particle25_sic_failure_due_to_ipyc_cracking
    from_postprocessor = sic_failure_due_to_ipyc_cracking
  []
  [max_fluence_particle25]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle25
    sampler = sample
    to_vector_postprocessor = particle25_max_fluence
    from_postprocessor = max_fluence
  []
  [fluence_at_failure_particle25]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle25
    sampler = sample
    to_vector_postprocessor = particle25_fluence_at_failure
    from_postprocessor = fluence_at_failure
  []
  [failure_indicator_kernel_migration_particle26]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle26
    sampler = sample
    to_vector_postprocessor = particle26_failure_indicator_kernel_migration
    from_postprocessor = failure_indicator_kernel_migration
  []
  [kernel_migration_distance_particle26]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle26
    sampler = sample
    to_vector_postprocessor = particle26_kernel_migration_distance
    from_postprocessor = kernel_migration_distance
  []
  [pd_penetration_particle26]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle26
    sampler = sample
    to_vector_postprocessor = particle26_pd_penetration
    from_postprocessor = pd_penetration
  []
  [failure_indicator_pd_penetration_particle26]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle26
    sampler = sample
    to_vector_postprocessor = particle26_failure_indicator_pd_penetration
    from_postprocessor = failure_indicator_pd_penetration
  []
  [sic_failure_overall_particle26]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle26
    sampler = sample
    to_vector_postprocessor = particle26_sic_failure_overall
    from_postprocessor = sic_failure_overall
  []
  [ipyc_cracking_particle26]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle26
    sampler = sample
    to_vector_postprocessor = particle26_ipyc_cracking
    from_postprocessor = ipyc_cracking
  []
  [sic_failure_due_to_pressure_particle26]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle26
    sampler = sample
    to_vector_postprocessor = particle26_sic_failure_due_to_pressure
    from_postprocessor = sic_failure_due_to_pressure
  []
  [sic_failure_due_to_ipyc_cracking_particle26]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle26
    sampler = sample
    to_vector_postprocessor = particle26_sic_failure_due_to_ipyc_cracking
    from_postprocessor = sic_failure_due_to_ipyc_cracking
  []
  [max_fluence_particle26]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle26
    sampler = sample
    to_vector_postprocessor = particle26_max_fluence
    from_postprocessor = max_fluence
  []
  [fluence_at_failure_particle26]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle26
    sampler = sample
    to_vector_postprocessor = particle26_fluence_at_failure
    from_postprocessor = fluence_at_failure
  []
  [failure_indicator_kernel_migration_particle27]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle27
    sampler = sample
    to_vector_postprocessor = particle27_failure_indicator_kernel_migration
    from_postprocessor = failure_indicator_kernel_migration
  []
  [kernel_migration_distance_particle27]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle27
    sampler = sample
    to_vector_postprocessor = particle27_kernel_migration_distance
    from_postprocessor = kernel_migration_distance
  []
  [pd_penetration_particle27]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle27
    sampler = sample
    to_vector_postprocessor = particle27_pd_penetration
    from_postprocessor = pd_penetration
  []
  [failure_indicator_pd_penetration_particle27]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle27
    sampler = sample
    to_vector_postprocessor = particle27_failure_indicator_pd_penetration
    from_postprocessor = failure_indicator_pd_penetration
  []
  [sic_failure_overall_particle27]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle27
    sampler = sample
    to_vector_postprocessor = particle27_sic_failure_overall
    from_postprocessor = sic_failure_overall
  []
  [ipyc_cracking_particle27]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle27
    sampler = sample
    to_vector_postprocessor = particle27_ipyc_cracking
    from_postprocessor = ipyc_cracking
  []
  [sic_failure_due_to_pressure_particle27]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle27
    sampler = sample
    to_vector_postprocessor = particle27_sic_failure_due_to_pressure
    from_postprocessor = sic_failure_due_to_pressure
  []
  [sic_failure_due_to_ipyc_cracking_particle27]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle27
    sampler = sample
    to_vector_postprocessor = particle27_sic_failure_due_to_ipyc_cracking
    from_postprocessor = sic_failure_due_to_ipyc_cracking
  []
  [max_fluence_particle27]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle27
    sampler = sample
    to_vector_postprocessor = particle27_max_fluence
    from_postprocessor = max_fluence
  []
  [fluence_at_failure_particle27]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle27
    sampler = sample
    to_vector_postprocessor = particle27_fluence_at_failure
    from_postprocessor = fluence_at_failure
  []
  [failure_indicator_kernel_migration_particle28]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle28
    sampler = sample
    to_vector_postprocessor = particle28_failure_indicator_kernel_migration
    from_postprocessor = failure_indicator_kernel_migration
  []
  [kernel_migration_distance_particle28]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle28
    sampler = sample
    to_vector_postprocessor = particle28_kernel_migration_distance
    from_postprocessor = kernel_migration_distance
  []
  [pd_penetration_particle28]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle28
    sampler = sample
    to_vector_postprocessor = particle28_pd_penetration
    from_postprocessor = pd_penetration
  []
  [failure_indicator_pd_penetration_particle28]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle28
    sampler = sample
    to_vector_postprocessor = particle28_failure_indicator_pd_penetration
    from_postprocessor = failure_indicator_pd_penetration
  []
  [sic_failure_overall_particle28]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle28
    sampler = sample
    to_vector_postprocessor = particle28_sic_failure_overall
    from_postprocessor = sic_failure_overall
  []
  [ipyc_cracking_particle28]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle28
    sampler = sample
    to_vector_postprocessor = particle28_ipyc_cracking
    from_postprocessor = ipyc_cracking
  []
  [sic_failure_due_to_pressure_particle28]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle28
    sampler = sample
    to_vector_postprocessor = particle28_sic_failure_due_to_pressure
    from_postprocessor = sic_failure_due_to_pressure
  []
  [sic_failure_due_to_ipyc_cracking_particle28]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle28
    sampler = sample
    to_vector_postprocessor = particle28_sic_failure_due_to_ipyc_cracking
    from_postprocessor = sic_failure_due_to_ipyc_cracking
  []
  [max_fluence_particle28]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle28
    sampler = sample
    to_vector_postprocessor = particle28_max_fluence
    from_postprocessor = max_fluence
  []
  [fluence_at_failure_particle28]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle28
    sampler = sample
    to_vector_postprocessor = particle28_fluence_at_failure
    from_postprocessor = fluence_at_failure
  []
  [failure_indicator_kernel_migration_particle29]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle29
    sampler = sample
    to_vector_postprocessor = particle29_failure_indicator_kernel_migration
    from_postprocessor = failure_indicator_kernel_migration
  []
  [kernel_migration_distance_particle29]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle29
    sampler = sample
    to_vector_postprocessor = particle29_kernel_migration_distance
    from_postprocessor = kernel_migration_distance
  []
  [pd_penetration_particle29]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle29
    sampler = sample
    to_vector_postprocessor = particle29_pd_penetration
    from_postprocessor = pd_penetration
  []
  [failure_indicator_pd_penetration_particle29]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle29
    sampler = sample
    to_vector_postprocessor = particle29_failure_indicator_pd_penetration
    from_postprocessor = failure_indicator_pd_penetration
  []
  [sic_failure_overall_particle29]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle29
    sampler = sample
    to_vector_postprocessor = particle29_sic_failure_overall
    from_postprocessor = sic_failure_overall
  []
  [ipyc_cracking_particle29]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle29
    sampler = sample
    to_vector_postprocessor = particle29_ipyc_cracking
    from_postprocessor = ipyc_cracking
  []
  [sic_failure_due_to_pressure_particle29]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle29
    sampler = sample
    to_vector_postprocessor = particle29_sic_failure_due_to_pressure
    from_postprocessor = sic_failure_due_to_pressure
  []
  [sic_failure_due_to_ipyc_cracking_particle29]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle29
    sampler = sample
    to_vector_postprocessor = particle29_sic_failure_due_to_ipyc_cracking
    from_postprocessor = sic_failure_due_to_ipyc_cracking
  []
  [max_fluence_particle29]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle29
    sampler = sample
    to_vector_postprocessor = particle29_max_fluence
    from_postprocessor = max_fluence
  []
  [fluence_at_failure_particle29]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle29
    sampler = sample
    to_vector_postprocessor = particle29_fluence_at_failure
    from_postprocessor = fluence_at_failure
  []
  [failure_indicator_kernel_migration_particle30]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle30
    sampler = sample
    to_vector_postprocessor = particle30_failure_indicator_kernel_migration
    from_postprocessor = failure_indicator_kernel_migration
  []
  [kernel_migration_distance_particle30]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle30
    sampler = sample
    to_vector_postprocessor = particle30_kernel_migration_distance
    from_postprocessor = kernel_migration_distance
  []
  [pd_penetration_particle30]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle30
    sampler = sample
    to_vector_postprocessor = particle30_pd_penetration
    from_postprocessor = pd_penetration
  []
  [failure_indicator_pd_penetration_particle30]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle30
    sampler = sample
    to_vector_postprocessor = particle30_failure_indicator_pd_penetration
    from_postprocessor = failure_indicator_pd_penetration
  []
  [sic_failure_overall_particle30]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle30
    sampler = sample
    to_vector_postprocessor = particle30_sic_failure_overall
    from_postprocessor = sic_failure_overall
  []
  [ipyc_cracking_particle30]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle30
    sampler = sample
    to_vector_postprocessor = particle30_ipyc_cracking
    from_postprocessor = ipyc_cracking
  []
  [sic_failure_due_to_pressure_particle30]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle30
    sampler = sample
    to_vector_postprocessor = particle30_sic_failure_due_to_pressure
    from_postprocessor = sic_failure_due_to_pressure
  []
  [sic_failure_due_to_ipyc_cracking_particle30]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle30
    sampler = sample
    to_vector_postprocessor = particle30_sic_failure_due_to_ipyc_cracking
    from_postprocessor = sic_failure_due_to_ipyc_cracking
  []
  [max_fluence_particle30]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle30
    sampler = sample
    to_vector_postprocessor = particle30_max_fluence
    from_postprocessor = max_fluence
  []
  [fluence_at_failure_particle30]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle30
    sampler = sample
    to_vector_postprocessor = particle30_fluence_at_failure
    from_postprocessor = fluence_at_failure
  []
  [failure_indicator_kernel_migration_particle31]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle31
    sampler = sample
    to_vector_postprocessor = particle31_failure_indicator_kernel_migration
    from_postprocessor = failure_indicator_kernel_migration
  []
  [kernel_migration_distance_particle31]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle31
    sampler = sample
    to_vector_postprocessor = particle31_kernel_migration_distance
    from_postprocessor = kernel_migration_distance
  []
  [pd_penetration_particle31]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle31
    sampler = sample
    to_vector_postprocessor = particle31_pd_penetration
    from_postprocessor = pd_penetration
  []
  [failure_indicator_pd_penetration_particle31]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle31
    sampler = sample
    to_vector_postprocessor = particle31_failure_indicator_pd_penetration
    from_postprocessor = failure_indicator_pd_penetration
  []
  [sic_failure_overall_particle31]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle31
    sampler = sample
    to_vector_postprocessor = particle31_sic_failure_overall
    from_postprocessor = sic_failure_overall
  []
  [ipyc_cracking_particle31]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle31
    sampler = sample
    to_vector_postprocessor = particle31_ipyc_cracking
    from_postprocessor = ipyc_cracking
  []
  [sic_failure_due_to_pressure_particle31]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle31
    sampler = sample
    to_vector_postprocessor = particle31_sic_failure_due_to_pressure
    from_postprocessor = sic_failure_due_to_pressure
  []
  [sic_failure_due_to_ipyc_cracking_particle31]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle31
    sampler = sample
    to_vector_postprocessor = particle31_sic_failure_due_to_ipyc_cracking
    from_postprocessor = sic_failure_due_to_ipyc_cracking
  []
  [max_fluence_particle31]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle31
    sampler = sample
    to_vector_postprocessor = particle31_max_fluence
    from_postprocessor = max_fluence
  []
  [fluence_at_failure_particle31]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle31
    sampler = sample
    to_vector_postprocessor = particle31_fluence_at_failure
    from_postprocessor = fluence_at_failure
  []
  [failure_indicator_kernel_migration_particle32]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle32
    sampler = sample
    to_vector_postprocessor = particle32_failure_indicator_kernel_migration
    from_postprocessor = failure_indicator_kernel_migration
  []
  [kernel_migration_distance_particle32]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle32
    sampler = sample
    to_vector_postprocessor = particle32_kernel_migration_distance
    from_postprocessor = kernel_migration_distance
  []
  [pd_penetration_particle32]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle32
    sampler = sample
    to_vector_postprocessor = particle32_pd_penetration
    from_postprocessor = pd_penetration
  []
  [failure_indicator_pd_penetration_particle32]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle32
    sampler = sample
    to_vector_postprocessor = particle32_failure_indicator_pd_penetration
    from_postprocessor = failure_indicator_pd_penetration
  []
  [sic_failure_overall_particle32]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle32
    sampler = sample
    to_vector_postprocessor = particle32_sic_failure_overall
    from_postprocessor = sic_failure_overall
  []
  [ipyc_cracking_particle32]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle32
    sampler = sample
    to_vector_postprocessor = particle32_ipyc_cracking
    from_postprocessor = ipyc_cracking
  []
  [sic_failure_due_to_pressure_particle32]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle32
    sampler = sample
    to_vector_postprocessor = particle32_sic_failure_due_to_pressure
    from_postprocessor = sic_failure_due_to_pressure
  []
  [sic_failure_due_to_ipyc_cracking_particle32]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle32
    sampler = sample
    to_vector_postprocessor = particle32_sic_failure_due_to_ipyc_cracking
    from_postprocessor = sic_failure_due_to_ipyc_cracking
  []
  [max_fluence_particle32]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle32
    sampler = sample
    to_vector_postprocessor = particle32_max_fluence
    from_postprocessor = max_fluence
  []
  [fluence_at_failure_particle32]
    type = SamplerPostprocessorTransfer
    from_multi_app = particle32
    sampler = sample
    to_vector_postprocessor = particle32_fluence_at_failure
    from_postprocessor = fluence_at_failure
  []
[]

[Controls]
  [particle1]
    type = MultiAppSamplerControl
    multi_app = particle1
    sampler = sample
    param_names = 'Mesh/gen/kernel_radius Mesh/gen/buffer_thickness Mesh/gen/IPyC_thickness Mesh/gen/SiC_thickness Mesh/gen/OPyC_thickness Postprocessors/failure_indicator_IPyC/quantile Postprocessors/failure_indicator_SiC_crackedIPyC/quantile Postprocessors/failure_indicator_SiC/quantile'
  []
  [particle2]
    type = MultiAppSamplerControl
    multi_app = particle2
    sampler = sample
    param_names = 'Mesh/gen/kernel_radius Mesh/gen/buffer_thickness Mesh/gen/IPyC_thickness Mesh/gen/SiC_thickness Mesh/gen/OPyC_thickness Postprocessors/failure_indicator_IPyC/quantile Postprocessors/failure_indicator_SiC_crackedIPyC/quantile Postprocessors/failure_indicator_SiC/quantile'
  []
  [particle3]
    type = MultiAppSamplerControl
    multi_app = particle3
    sampler = sample
    param_names = 'Mesh/gen/kernel_radius Mesh/gen/buffer_thickness Mesh/gen/IPyC_thickness Mesh/gen/SiC_thickness Mesh/gen/OPyC_thickness Postprocessors/failure_indicator_IPyC/quantile Postprocessors/failure_indicator_SiC_crackedIPyC/quantile Postprocessors/failure_indicator_SiC/quantile'
  []
  [particle4]
    type = MultiAppSamplerControl
    multi_app = particle4
    sampler = sample
    param_names = 'Mesh/gen/kernel_radius Mesh/gen/buffer_thickness Mesh/gen/IPyC_thickness Mesh/gen/SiC_thickness Mesh/gen/OPyC_thickness Postprocessors/failure_indicator_IPyC/quantile Postprocessors/failure_indicator_SiC_crackedIPyC/quantile Postprocessors/failure_indicator_SiC/quantile'
  []
  [particle5]
    type = MultiAppSamplerControl
    multi_app = particle5
    sampler = sample
    param_names = 'Mesh/gen/kernel_radius Mesh/gen/buffer_thickness Mesh/gen/IPyC_thickness Mesh/gen/SiC_thickness Mesh/gen/OPyC_thickness Postprocessors/failure_indicator_IPyC/quantile Postprocessors/failure_indicator_SiC_crackedIPyC/quantile Postprocessors/failure_indicator_SiC/quantile'
  []
  [particle6]
    type = MultiAppSamplerControl
    multi_app = particle6
    sampler = sample
    param_names = 'Mesh/gen/kernel_radius Mesh/gen/buffer_thickness Mesh/gen/IPyC_thickness Mesh/gen/SiC_thickness Mesh/gen/OPyC_thickness Postprocessors/failure_indicator_IPyC/quantile Postprocessors/failure_indicator_SiC_crackedIPyC/quantile Postprocessors/failure_indicator_SiC/quantile'
  []
  [particle7]
    type = MultiAppSamplerControl
    multi_app = particle7
    sampler = sample
    param_names = 'Mesh/gen/kernel_radius Mesh/gen/buffer_thickness Mesh/gen/IPyC_thickness Mesh/gen/SiC_thickness Mesh/gen/OPyC_thickness Postprocessors/failure_indicator_IPyC/quantile Postprocessors/failure_indicator_SiC_crackedIPyC/quantile Postprocessors/failure_indicator_SiC/quantile'
  []
  [particle8]
    type = MultiAppSamplerControl
    multi_app = particle8
    sampler = sample
    param_names = 'Mesh/gen/kernel_radius Mesh/gen/buffer_thickness Mesh/gen/IPyC_thickness Mesh/gen/SiC_thickness Mesh/gen/OPyC_thickness Postprocessors/failure_indicator_IPyC/quantile Postprocessors/failure_indicator_SiC_crackedIPyC/quantile Postprocessors/failure_indicator_SiC/quantile'
  []
  [particle9]
    type = MultiAppSamplerControl
    multi_app = particle9
    sampler = sample
    param_names = 'Mesh/gen/kernel_radius Mesh/gen/buffer_thickness Mesh/gen/IPyC_thickness Mesh/gen/SiC_thickness Mesh/gen/OPyC_thickness Postprocessors/failure_indicator_IPyC/quantile Postprocessors/failure_indicator_SiC_crackedIPyC/quantile Postprocessors/failure_indicator_SiC/quantile'
  []
  [particle10]
    type = MultiAppSamplerControl
    multi_app = particle10
    sampler = sample
    param_names = 'Mesh/gen/kernel_radius Mesh/gen/buffer_thickness Mesh/gen/IPyC_thickness Mesh/gen/SiC_thickness Mesh/gen/OPyC_thickness Postprocessors/failure_indicator_IPyC/quantile Postprocessors/failure_indicator_SiC_crackedIPyC/quantile Postprocessors/failure_indicator_SiC/quantile'
  []
  [particle11]
    type = MultiAppSamplerControl
    multi_app = particle11
    sampler = sample
    param_names = 'Mesh/gen/kernel_radius Mesh/gen/buffer_thickness Mesh/gen/IPyC_thickness Mesh/gen/SiC_thickness Mesh/gen/OPyC_thickness Postprocessors/failure_indicator_IPyC/quantile Postprocessors/failure_indicator_SiC_crackedIPyC/quantile Postprocessors/failure_indicator_SiC/quantile'
  []
  [particle12]
    type = MultiAppSamplerControl
    multi_app = particle12
    sampler = sample
    param_names = 'Mesh/gen/kernel_radius Mesh/gen/buffer_thickness Mesh/gen/IPyC_thickness Mesh/gen/SiC_thickness Mesh/gen/OPyC_thickness Postprocessors/failure_indicator_IPyC/quantile Postprocessors/failure_indicator_SiC_crackedIPyC/quantile Postprocessors/failure_indicator_SiC/quantile'
  []
  [particle13]
    type = MultiAppSamplerControl
    multi_app = particle13
    sampler = sample
    param_names = 'Mesh/gen/kernel_radius Mesh/gen/buffer_thickness Mesh/gen/IPyC_thickness Mesh/gen/SiC_thickness Mesh/gen/OPyC_thickness Postprocessors/failure_indicator_IPyC/quantile Postprocessors/failure_indicator_SiC_crackedIPyC/quantile Postprocessors/failure_indicator_SiC/quantile'
  []
  [particle14]
    type = MultiAppSamplerControl
    multi_app = particle14
    sampler = sample
    param_names = 'Mesh/gen/kernel_radius Mesh/gen/buffer_thickness Mesh/gen/IPyC_thickness Mesh/gen/SiC_thickness Mesh/gen/OPyC_thickness Postprocessors/failure_indicator_IPyC/quantile Postprocessors/failure_indicator_SiC_crackedIPyC/quantile Postprocessors/failure_indicator_SiC/quantile'
  []
  [particle15]
    type = MultiAppSamplerControl
    multi_app = particle15
    sampler = sample
    param_names = 'Mesh/gen/kernel_radius Mesh/gen/buffer_thickness Mesh/gen/IPyC_thickness Mesh/gen/SiC_thickness Mesh/gen/OPyC_thickness Postprocessors/failure_indicator_IPyC/quantile Postprocessors/failure_indicator_SiC_crackedIPyC/quantile Postprocessors/failure_indicator_SiC/quantile'
  []
  [particle16]
    type = MultiAppSamplerControl
    multi_app = particle16
    sampler = sample
    param_names = 'Mesh/gen/kernel_radius Mesh/gen/buffer_thickness Mesh/gen/IPyC_thickness Mesh/gen/SiC_thickness Mesh/gen/OPyC_thickness Postprocessors/failure_indicator_IPyC/quantile Postprocessors/failure_indicator_SiC_crackedIPyC/quantile Postprocessors/failure_indicator_SiC/quantile'
  []
  [particle17]
    type = MultiAppSamplerControl
    multi_app = particle17
    sampler = sample
    param_names = 'Mesh/gen/kernel_radius Mesh/gen/buffer_thickness Mesh/gen/IPyC_thickness Mesh/gen/SiC_thickness Mesh/gen/OPyC_thickness Postprocessors/failure_indicator_IPyC/quantile Postprocessors/failure_indicator_SiC_crackedIPyC/quantile Postprocessors/failure_indicator_SiC/quantile'
  []
  [particle18]
    type = MultiAppSamplerControl
    multi_app = particle18
    sampler = sample
    param_names = 'Mesh/gen/kernel_radius Mesh/gen/buffer_thickness Mesh/gen/IPyC_thickness Mesh/gen/SiC_thickness Mesh/gen/OPyC_thickness Postprocessors/failure_indicator_IPyC/quantile Postprocessors/failure_indicator_SiC_crackedIPyC/quantile Postprocessors/failure_indicator_SiC/quantile'
  []
  [particle19]
    type = MultiAppSamplerControl
    multi_app = particle19
    sampler = sample
    param_names = 'Mesh/gen/kernel_radius Mesh/gen/buffer_thickness Mesh/gen/IPyC_thickness Mesh/gen/SiC_thickness Mesh/gen/OPyC_thickness Postprocessors/failure_indicator_IPyC/quantile Postprocessors/failure_indicator_SiC_crackedIPyC/quantile Postprocessors/failure_indicator_SiC/quantile'
  []
  [particle20]
    type = MultiAppSamplerControl
    multi_app = particle20
    sampler = sample
    param_names = 'Mesh/gen/kernel_radius Mesh/gen/buffer_thickness Mesh/gen/IPyC_thickness Mesh/gen/SiC_thickness Mesh/gen/OPyC_thickness Postprocessors/failure_indicator_IPyC/quantile Postprocessors/failure_indicator_SiC_crackedIPyC/quantile Postprocessors/failure_indicator_SiC/quantile'
  []
  [particle21]
    type = MultiAppSamplerControl
    multi_app = particle21
    sampler = sample
    param_names = 'Mesh/gen/kernel_radius Mesh/gen/buffer_thickness Mesh/gen/IPyC_thickness Mesh/gen/SiC_thickness Mesh/gen/OPyC_thickness Postprocessors/failure_indicator_IPyC/quantile Postprocessors/failure_indicator_SiC_crackedIPyC/quantile Postprocessors/failure_indicator_SiC/quantile'
  []
  [particle22]
    type = MultiAppSamplerControl
    multi_app = particle22
    sampler = sample
    param_names = 'Mesh/gen/kernel_radius Mesh/gen/buffer_thickness Mesh/gen/IPyC_thickness Mesh/gen/SiC_thickness Mesh/gen/OPyC_thickness Postprocessors/failure_indicator_IPyC/quantile Postprocessors/failure_indicator_SiC_crackedIPyC/quantile Postprocessors/failure_indicator_SiC/quantile'
  []
  [particle23]
    type = MultiAppSamplerControl
    multi_app = particle23
    sampler = sample
    param_names = 'Mesh/gen/kernel_radius Mesh/gen/buffer_thickness Mesh/gen/IPyC_thickness Mesh/gen/SiC_thickness Mesh/gen/OPyC_thickness Postprocessors/failure_indicator_IPyC/quantile Postprocessors/failure_indicator_SiC_crackedIPyC/quantile Postprocessors/failure_indicator_SiC/quantile'
  []
  [particle24]
    type = MultiAppSamplerControl
    multi_app = particle24
    sampler = sample
    param_names = 'Mesh/gen/kernel_radius Mesh/gen/buffer_thickness Mesh/gen/IPyC_thickness Mesh/gen/SiC_thickness Mesh/gen/OPyC_thickness Postprocessors/failure_indicator_IPyC/quantile Postprocessors/failure_indicator_SiC_crackedIPyC/quantile Postprocessors/failure_indicator_SiC/quantile'
  []
  [particle25]
    type = MultiAppSamplerControl
    multi_app = particle25
    sampler = sample
    param_names = 'Mesh/gen/kernel_radius Mesh/gen/buffer_thickness Mesh/gen/IPyC_thickness Mesh/gen/SiC_thickness Mesh/gen/OPyC_thickness Postprocessors/failure_indicator_IPyC/quantile Postprocessors/failure_indicator_SiC_crackedIPyC/quantile Postprocessors/failure_indicator_SiC/quantile'
  []
  [particle26]
    type = MultiAppSamplerControl
    multi_app = particle26
    sampler = sample
    param_names = 'Mesh/gen/kernel_radius Mesh/gen/buffer_thickness Mesh/gen/IPyC_thickness Mesh/gen/SiC_thickness Mesh/gen/OPyC_thickness Postprocessors/failure_indicator_IPyC/quantile Postprocessors/failure_indicator_SiC_crackedIPyC/quantile Postprocessors/failure_indicator_SiC/quantile'
  []
  [particle27]
    type = MultiAppSamplerControl
    multi_app = particle27
    sampler = sample
    param_names = 'Mesh/gen/kernel_radius Mesh/gen/buffer_thickness Mesh/gen/IPyC_thickness Mesh/gen/SiC_thickness Mesh/gen/OPyC_thickness Postprocessors/failure_indicator_IPyC/quantile Postprocessors/failure_indicator_SiC_crackedIPyC/quantile Postprocessors/failure_indicator_SiC/quantile'
  []
  [particle28]
    type = MultiAppSamplerControl
    multi_app = particle28
    sampler = sample
    param_names = 'Mesh/gen/kernel_radius Mesh/gen/buffer_thickness Mesh/gen/IPyC_thickness Mesh/gen/SiC_thickness Mesh/gen/OPyC_thickness Postprocessors/failure_indicator_IPyC/quantile Postprocessors/failure_indicator_SiC_crackedIPyC/quantile Postprocessors/failure_indicator_SiC/quantile'
  []
  [particle29]
    type = MultiAppSamplerControl
    multi_app = particle29
    sampler = sample
    param_names = 'Mesh/gen/kernel_radius Mesh/gen/buffer_thickness Mesh/gen/IPyC_thickness Mesh/gen/SiC_thickness Mesh/gen/OPyC_thickness Postprocessors/failure_indicator_IPyC/quantile Postprocessors/failure_indicator_SiC_crackedIPyC/quantile Postprocessors/failure_indicator_SiC/quantile'
  []
  [particle30]
    type = MultiAppSamplerControl
    multi_app = particle30
    sampler = sample
    param_names = 'Mesh/gen/kernel_radius Mesh/gen/buffer_thickness Mesh/gen/IPyC_thickness Mesh/gen/SiC_thickness Mesh/gen/OPyC_thickness Postprocessors/failure_indicator_IPyC/quantile Postprocessors/failure_indicator_SiC_crackedIPyC/quantile Postprocessors/failure_indicator_SiC/quantile'
  []
  [particle31]
    type = MultiAppSamplerControl
    multi_app = particle31
    sampler = sample
    param_names = 'Mesh/gen/kernel_radius Mesh/gen/buffer_thickness Mesh/gen/IPyC_thickness Mesh/gen/SiC_thickness Mesh/gen/OPyC_thickness Postprocessors/failure_indicator_IPyC/quantile Postprocessors/failure_indicator_SiC_crackedIPyC/quantile Postprocessors/failure_indicator_SiC/quantile'
  []
  [particle32]
    type = MultiAppSamplerControl
    multi_app = particle32
    sampler = sample
    param_names = 'Mesh/gen/kernel_radius Mesh/gen/buffer_thickness Mesh/gen/IPyC_thickness Mesh/gen/SiC_thickness Mesh/gen/OPyC_thickness Postprocessors/failure_indicator_IPyC/quantile Postprocessors/failure_indicator_SiC_crackedIPyC/quantile Postprocessors/failure_indicator_SiC/quantile'
  []
[]

[VectorPostprocessors]
  [particle1_sic_failure_overall]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle1_out
  []
  [particle1_ipyc_cracking]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle1_out
  []
  [particle1_debonding]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle1_out
  []
  [particle1_sic_failure_due_to_pressure]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle1_out
  []
  [particle1_sic_failure_due_to_ipyc_cracking]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle1_out
  []
  [particle1_sampler_data]
    type = SamplerData
    sampler = sample
    execute_on = 'TIMESTEP_END'
    outputs = particle1_out
  []
  [particle1_max_fluence]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle1_out
  []
  [particle1_fluence_at_failure]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle1_out
  []
  [particle1_pd_penetration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle1_out
  []
  [particle1_failure_indicator_pd_penetration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle1_out
  []
  [particle1_kernel_migration_distance]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle1_out
  []
  [particle1_failure_indicator_kernel_migration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle1_out
  []
  [particle2_sic_failure_overall]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle2_out
  []
  [particle2_ipyc_cracking]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle2_out
  []
  [particle2_debonding]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle2_out
  []
  [particle2_sic_failure_due_to_pressure]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle2_out
  []
  [particle2_sic_failure_due_to_ipyc_cracking]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle2_out
  []
  [particle2_sampler_data]
    type = SamplerData
    sampler = sample
    execute_on = 'TIMESTEP_END'
    outputs = particle2_out
  []
  [particle2_max_fluence]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle2_out
  []
  [particle2_fluence_at_failure]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle2_out
  []
  [particle2_pd_penetration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle2_out
  []
  [particle2_failure_indicator_pd_penetration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle2_out
  []
  [particle2_kernel_migration_distance]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle2_out
  []
  [particle2_failure_indicator_kernel_migration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle2_out
  []
  [particle3_sic_failure_overall]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle3_out
  []
  [particle3_ipyc_cracking]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle3_out
  []
  [particle3_debonding]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle3_out
  []
  [particle3_sic_failure_due_to_pressure]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle3_out
  []
  [particle3_sic_failure_due_to_ipyc_cracking]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle3_out
  []
  [particle3_sampler_data]
    type = SamplerData
    sampler = sample
    execute_on = 'TIMESTEP_END'
    outputs = particle3_out
  []
  [particle3_max_fluence]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle3_out
  []
  [particle3_fluence_at_failure]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle3_out
  []
  [particle3_pd_penetration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle3_out
  []
  [particle3_failure_indicator_pd_penetration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle3_out
  []
  [particle3_kernel_migration_distance]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle3_out
  []
  [particle3_failure_indicator_kernel_migration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle3_out
  []
  [particle4_sic_failure_overall]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle4_out
  []
  [particle4_ipyc_cracking]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle4_out
  []
  [particle4_debonding]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle4_out
  []
  [particle4_sic_failure_due_to_pressure]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle4_out
  []
  [particle4_sic_failure_due_to_ipyc_cracking]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle4_out
  []
  [particle4_sampler_data]
    type = SamplerData
    sampler = sample
    execute_on = 'TIMESTEP_END'
    outputs = particle4_out
  []
  [particle4_max_fluence]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle4_out
  []
  [particle4_fluence_at_failure]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle4_out
  []
  [particle4_pd_penetration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle4_out
  []
  [particle4_failure_indicator_pd_penetration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle4_out
  []
  [particle4_kernel_migration_distance]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle4_out
  []
  [particle4_failure_indicator_kernel_migration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle4_out
  []
  [particle5_sic_failure_overall]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle5_out
  []
  [particle5_ipyc_cracking]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle5_out
  []
  [particle5_debonding]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle5_out
  []
  [particle5_sic_failure_due_to_pressure]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle5_out
  []
  [particle5_sic_failure_due_to_ipyc_cracking]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle5_out
  []
  [particle5_sampler_data]
    type = SamplerData
    sampler = sample
    execute_on = 'TIMESTEP_END'
    outputs = particle5_out
  []
  [particle5_max_fluence]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle5_out
  []
  [particle5_fluence_at_failure]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle5_out
  []
  [particle5_pd_penetration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle5_out
  []
  [particle5_failure_indicator_pd_penetration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle5_out
  []
  [particle5_kernel_migration_distance]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle5_out
  []
  [particle5_failure_indicator_kernel_migration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle5_out
  []
  [particle6_sic_failure_overall]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle6_out
  []
  [particle6_ipyc_cracking]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle6_out
  []
  [particle6_debonding]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle6_out
  []
  [particle6_sic_failure_due_to_pressure]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle6_out
  []
  [particle6_sic_failure_due_to_ipyc_cracking]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle6_out
  []
  [particle6_sampler_data]
    type = SamplerData
    sampler = sample
    execute_on = 'TIMESTEP_END'
    outputs = particle6_out
  []
  [particle6_max_fluence]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle6_out
  []
  [particle6_fluence_at_failure]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle6_out
  []
  [particle6_pd_penetration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle6_out
  []
  [particle6_failure_indicator_pd_penetration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle6_out
  []
  [particle6_kernel_migration_distance]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle6_out
  []
  [particle6_failure_indicator_kernel_migration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle6_out
  []
  [particle7_sic_failure_overall]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle7_out
  []
  [particle7_ipyc_cracking]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle7_out
  []
  [particle7_debonding]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle7_out
  []
  [particle7_sic_failure_due_to_pressure]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle7_out
  []
  [particle7_sic_failure_due_to_ipyc_cracking]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle7_out
  []
  [particle7_sampler_data]
    type = SamplerData
    sampler = sample
    execute_on = 'TIMESTEP_END'
    outputs = particle7_out
  []
  [particle7_max_fluence]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle7_out
  []
  [particle7_fluence_at_failure]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle7_out
  []
  [particle7_pd_penetration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle7_out
  []
  [particle7_failure_indicator_pd_penetration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle7_out
  []
  [particle7_kernel_migration_distance]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle7_out
  []
  [particle7_failure_indicator_kernel_migration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle7_out
  []
  [particle8_sic_failure_overall]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle8_out
  []
  [particle8_ipyc_cracking]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle8_out
  []
  [particle8_debonding]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle8_out
  []
  [particle8_sic_failure_due_to_pressure]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle8_out
  []
  [particle8_sic_failure_due_to_ipyc_cracking]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle8_out
  []
  [particle8_sampler_data]
    type = SamplerData
    sampler = sample
    execute_on = 'TIMESTEP_END'
    outputs = particle8_out
  []
  [particle8_max_fluence]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle8_out
  []
  [particle8_fluence_at_failure]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle8_out
  []
  [particle8_pd_penetration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle8_out
  []
  [particle8_failure_indicator_pd_penetration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle8_out
  []
  [particle8_kernel_migration_distance]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle8_out
  []
  [particle8_failure_indicator_kernel_migration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle8_out
  []
  [particle9_sic_failure_overall]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle9_out
  []
  [particle9_ipyc_cracking]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle9_out
  []
  [particle9_debonding]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle9_out
  []
  [particle9_sic_failure_due_to_pressure]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle9_out
  []
  [particle9_sic_failure_due_to_ipyc_cracking]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle9_out
  []
  [particle9_sampler_data]
    type = SamplerData
    sampler = sample
    execute_on = 'TIMESTEP_END'
    outputs = particle9_out
  []
  [particle9_max_fluence]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle9_out
  []
  [particle9_fluence_at_failure]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle9_out
  []
  [particle9_pd_penetration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle9_out
  []
  [particle9_failure_indicator_pd_penetration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle9_out
  []
  [particle9_kernel_migration_distance]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle9_out
  []
  [particle9_failure_indicator_kernel_migration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle9_out
  []
  [particle10_sic_failure_overall]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle10_out
  []
  [particle10_ipyc_cracking]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle10_out
  []
  [particle10_debonding]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle10_out
  []
  [particle10_sic_failure_due_to_pressure]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle10_out
  []
  [particle10_sic_failure_due_to_ipyc_cracking]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle10_out
  []
  [particle10_sampler_data]
    type = SamplerData
    sampler = sample
    execute_on = 'TIMESTEP_END'
    outputs = particle10_out
  []
  [particle10_max_fluence]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle10_out
  []
  [particle10_fluence_at_failure]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle10_out
  []
  [particle10_pd_penetration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle10_out
  []
  [particle10_failure_indicator_pd_penetration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle10_out
  []
  [particle10_kernel_migration_distance]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle10_out
  []
  [particle10_failure_indicator_kernel_migration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle10_out
  []
  [particle11_sic_failure_overall]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle11_out
  []
  [particle11_ipyc_cracking]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle11_out
  []
  [particle11_debonding]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle11_out
  []
  [particle11_sic_failure_due_to_pressure]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle11_out
  []
  [particle11_sic_failure_due_to_ipyc_cracking]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle11_out
  []
  [particle11_sampler_data]
    type = SamplerData
    sampler = sample
    execute_on = 'TIMESTEP_END'
    outputs = particle11_out
  []
  [particle11_max_fluence]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle11_out
  []
  [particle11_fluence_at_failure]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle11_out
  []
  [particle11_pd_penetration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle11_out
  []
  [particle11_failure_indicator_pd_penetration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle11_out
  []
  [particle11_kernel_migration_distance]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle11_out
  []
  [particle11_failure_indicator_kernel_migration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle11_out
  []
  [particle12_sic_failure_overall]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle12_out
  []
  [particle12_ipyc_cracking]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle12_out
  []
  [particle12_debonding]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle12_out
  []
  [particle12_sic_failure_due_to_pressure]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle12_out
  []
  [particle12_sic_failure_due_to_ipyc_cracking]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle12_out
  []
  [particle12_sampler_data]
    type = SamplerData
    sampler = sample
    execute_on = 'TIMESTEP_END'
    outputs = particle12_out
  []
  [particle12_max_fluence]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle12_out
  []
  [particle12_fluence_at_failure]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle12_out
  []
  [particle12_pd_penetration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle12_out
  []
  [particle12_failure_indicator_pd_penetration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle12_out
  []
  [particle12_kernel_migration_distance]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle12_out
  []
  [particle12_failure_indicator_kernel_migration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle12_out
  []
  [particle13_sic_failure_overall]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle13_out
  []
  [particle13_ipyc_cracking]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle13_out
  []
  [particle13_debonding]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle13_out
  []
  [particle13_sic_failure_due_to_pressure]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle13_out
  []
  [particle13_sic_failure_due_to_ipyc_cracking]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle13_out
  []
  [particle13_sampler_data]
    type = SamplerData
    sampler = sample
    execute_on = 'TIMESTEP_END'
    outputs = particle13_out
  []
  [particle13_max_fluence]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle13_out
  []
  [particle13_fluence_at_failure]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle13_out
  []
  [particle13_pd_penetration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle13_out
  []
  [particle13_failure_indicator_pd_penetration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle13_out
  []
  [particle13_kernel_migration_distance]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle13_out
  []
  [particle13_failure_indicator_kernel_migration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle13_out
  []
  [particle14_sic_failure_overall]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle14_out
  []
  [particle14_ipyc_cracking]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle14_out
  []
  [particle14_debonding]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle14_out
  []
  [particle14_sic_failure_due_to_pressure]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle14_out
  []
  [particle14_sic_failure_due_to_ipyc_cracking]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle14_out
  []
  [particle14_sampler_data]
    type = SamplerData
    sampler = sample
    execute_on = 'TIMESTEP_END'
    outputs = particle14_out
  []
  [particle14_max_fluence]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle14_out
  []
  [particle14_fluence_at_failure]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle14_out
  []
  [particle14_pd_penetration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle14_out
  []
  [particle14_failure_indicator_pd_penetration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle14_out
  []
  [particle14_kernel_migration_distance]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle14_out
  []
  [particle14_failure_indicator_kernel_migration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle14_out
  []
  [particle15_sic_failure_overall]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle15_out
  []
  [particle15_ipyc_cracking]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle15_out
  []
  [particle15_debonding]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle15_out
  []
  [particle15_sic_failure_due_to_pressure]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle15_out
  []
  [particle15_sic_failure_due_to_ipyc_cracking]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle15_out
  []
  [particle15_sampler_data]
    type = SamplerData
    sampler = sample
    execute_on = 'TIMESTEP_END'
    outputs = particle15_out
  []
  [particle15_max_fluence]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle15_out
  []
  [particle15_fluence_at_failure]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle15_out
  []
  [particle15_pd_penetration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle15_out
  []
  [particle15_failure_indicator_pd_penetration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle15_out
  []
  [particle15_kernel_migration_distance]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle15_out
  []
  [particle15_failure_indicator_kernel_migration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle15_out
  []
  [particle16_sic_failure_overall]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle16_out
  []
  [particle16_ipyc_cracking]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle16_out
  []
  [particle16_debonding]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle16_out
  []
  [particle16_sic_failure_due_to_pressure]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle16_out
  []
  [particle16_sic_failure_due_to_ipyc_cracking]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle16_out
  []
  [particle16_sampler_data]
    type = SamplerData
    sampler = sample
    execute_on = 'TIMESTEP_END'
    outputs = particle16_out
  []
  [particle16_max_fluence]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle16_out
  []
  [particle16_fluence_at_failure]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle16_out
  []
  [particle16_pd_penetration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle16_out
  []
  [particle16_failure_indicator_pd_penetration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle16_out
  []
  [particle16_kernel_migration_distance]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle16_out
  []
  [particle16_failure_indicator_kernel_migration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle16_out
  []
  [particle17_sic_failure_overall]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle17_out
  []
  [particle17_ipyc_cracking]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle17_out
  []
  [particle17_debonding]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle17_out
  []
  [particle17_sic_failure_due_to_pressure]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle17_out
  []
  [particle17_sic_failure_due_to_ipyc_cracking]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle17_out
  []
  [particle17_sampler_data]
    type = SamplerData
    sampler = sample
    execute_on = 'TIMESTEP_END'
    outputs = particle17_out
  []
  [particle17_max_fluence]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle17_out
  []
  [particle17_fluence_at_failure]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle17_out
  []
  [particle17_pd_penetration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle17_out
  []
  [particle17_failure_indicator_pd_penetration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle17_out
  []
  [particle17_kernel_migration_distance]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle17_out
  []
  [particle17_failure_indicator_kernel_migration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle17_out
  []
  [particle18_sic_failure_overall]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle18_out
  []
  [particle18_ipyc_cracking]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle18_out
  []
  [particle18_debonding]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle18_out
  []
  [particle18_sic_failure_due_to_pressure]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle18_out
  []
  [particle18_sic_failure_due_to_ipyc_cracking]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle18_out
  []
  [particle18_sampler_data]
    type = SamplerData
    sampler = sample
    execute_on = 'TIMESTEP_END'
    outputs = particle18_out
  []
  [particle18_max_fluence]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle18_out
  []
  [particle18_fluence_at_failure]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle18_out
  []
  [particle18_pd_penetration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle18_out
  []
  [particle18_failure_indicator_pd_penetration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle18_out
  []
  [particle18_kernel_migration_distance]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle18_out
  []
  [particle18_failure_indicator_kernel_migration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle18_out
  []
  [particle19_sic_failure_overall]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle19_out
  []
  [particle19_ipyc_cracking]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle19_out
  []
  [particle19_debonding]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle19_out
  []
  [particle19_sic_failure_due_to_pressure]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle19_out
  []
  [particle19_sic_failure_due_to_ipyc_cracking]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle19_out
  []
  [particle19_sampler_data]
    type = SamplerData
    sampler = sample
    execute_on = 'TIMESTEP_END'
    outputs = particle19_out
  []
  [particle19_max_fluence]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle19_out
  []
  [particle19_fluence_at_failure]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle19_out
  []
  [particle19_pd_penetration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle19_out
  []
  [particle19_failure_indicator_pd_penetration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle19_out
  []
  [particle19_kernel_migration_distance]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle19_out
  []
  [particle19_failure_indicator_kernel_migration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle19_out
  []
  [particle20_sic_failure_overall]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle20_out
  []
  [particle20_ipyc_cracking]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle20_out
  []
  [particle20_debonding]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle20_out
  []
  [particle20_sic_failure_due_to_pressure]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle20_out
  []
  [particle20_sic_failure_due_to_ipyc_cracking]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle20_out
  []
  [particle20_sampler_data]
    type = SamplerData
    sampler = sample
    execute_on = 'TIMESTEP_END'
    outputs = particle20_out
  []
  [particle20_max_fluence]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle20_out
  []
  [particle20_fluence_at_failure]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle20_out
  []
  [particle20_pd_penetration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle20_out
  []
  [particle20_failure_indicator_pd_penetration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle20_out
  []
  [particle20_kernel_migration_distance]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle20_out
  []
  [particle20_failure_indicator_kernel_migration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle20_out
  []
  [particle21_sic_failure_overall]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle21_out
  []
  [particle21_ipyc_cracking]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle21_out
  []
  [particle21_debonding]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle21_out
  []
  [particle21_sic_failure_due_to_pressure]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle21_out
  []
  [particle21_sic_failure_due_to_ipyc_cracking]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle21_out
  []
  [particle21_sampler_data]
    type = SamplerData
    sampler = sample
    execute_on = 'TIMESTEP_END'
    outputs = particle21_out
  []
  [particle21_max_fluence]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle21_out
  []
  [particle21_fluence_at_failure]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle21_out
  []
  [particle21_pd_penetration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle21_out
  []
  [particle21_failure_indicator_pd_penetration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle21_out
  []
  [particle21_kernel_migration_distance]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle21_out
  []
  [particle21_failure_indicator_kernel_migration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle21_out
  []
  [particle22_sic_failure_overall]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle22_out
  []
  [particle22_ipyc_cracking]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle22_out
  []
  [particle22_debonding]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle22_out
  []
  [particle22_sic_failure_due_to_pressure]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle22_out
  []
  [particle22_sic_failure_due_to_ipyc_cracking]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle22_out
  []
  [particle22_sampler_data]
    type = SamplerData
    sampler = sample
    execute_on = 'TIMESTEP_END'
    outputs = particle22_out
  []
  [particle22_max_fluence]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle22_out
  []
  [particle22_fluence_at_failure]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle22_out
  []
  [particle22_pd_penetration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle22_out
  []
  [particle22_failure_indicator_pd_penetration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle22_out
  []
  [particle22_kernel_migration_distance]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle22_out
  []
  [particle22_failure_indicator_kernel_migration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle22_out
  []
  [particle23_sic_failure_overall]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle23_out
  []
  [particle23_ipyc_cracking]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle23_out
  []
  [particle23_debonding]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle23_out
  []
  [particle23_sic_failure_due_to_pressure]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle23_out
  []
  [particle23_sic_failure_due_to_ipyc_cracking]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle23_out
  []
  [particle23_sampler_data]
    type = SamplerData
    sampler = sample
    execute_on = 'TIMESTEP_END'
    outputs = particle23_out
  []
  [particle23_max_fluence]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle23_out
  []
  [particle23_fluence_at_failure]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle23_out
  []
  [particle23_pd_penetration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle23_out
  []
  [particle23_failure_indicator_pd_penetration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle23_out
  []
  [particle23_kernel_migration_distance]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle23_out
  []
  [particle23_failure_indicator_kernel_migration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle23_out
  []
  [particle24_sic_failure_overall]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle24_out
  []
  [particle24_ipyc_cracking]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle24_out
  []
  [particle24_debonding]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle24_out
  []
  [particle24_sic_failure_due_to_pressure]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle24_out
  []
  [particle24_sic_failure_due_to_ipyc_cracking]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle24_out
  []
  [particle24_sampler_data]
    type = SamplerData
    sampler = sample
    execute_on = 'TIMESTEP_END'
    outputs = particle24_out
  []
  [particle24_max_fluence]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle24_out
  []
  [particle24_fluence_at_failure]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle24_out
  []
  [particle24_pd_penetration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle24_out
  []
  [particle24_failure_indicator_pd_penetration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle24_out
  []
  [particle24_kernel_migration_distance]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle24_out
  []
  [particle24_failure_indicator_kernel_migration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle24_out
  []
  [particle25_sic_failure_overall]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle25_out
  []
  [particle25_ipyc_cracking]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle25_out
  []
  [particle25_debonding]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle25_out
  []
  [particle25_sic_failure_due_to_pressure]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle25_out
  []
  [particle25_sic_failure_due_to_ipyc_cracking]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle25_out
  []
  [particle25_sampler_data]
    type = SamplerData
    sampler = sample
    execute_on = 'TIMESTEP_END'
    outputs = particle25_out
  []
  [particle25_max_fluence]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle25_out
  []
  [particle25_fluence_at_failure]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle25_out
  []
  [particle25_pd_penetration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle25_out
  []
  [particle25_failure_indicator_pd_penetration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle25_out
  []
  [particle25_kernel_migration_distance]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle25_out
  []
  [particle25_failure_indicator_kernel_migration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle25_out
  []
  [particle26_sic_failure_overall]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle26_out
  []
  [particle26_ipyc_cracking]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle26_out
  []
  [particle26_debonding]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle26_out
  []
  [particle26_sic_failure_due_to_pressure]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle26_out
  []
  [particle26_sic_failure_due_to_ipyc_cracking]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle26_out
  []
  [particle26_sampler_data]
    type = SamplerData
    sampler = sample
    execute_on = 'TIMESTEP_END'
    outputs = particle26_out
  []
  [particle26_max_fluence]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle26_out
  []
  [particle26_fluence_at_failure]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle26_out
  []
  [particle26_pd_penetration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle26_out
  []
  [particle26_failure_indicator_pd_penetration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle26_out
  []
  [particle26_kernel_migration_distance]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle26_out
  []
  [particle26_failure_indicator_kernel_migration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle26_out
  []
  [particle27_sic_failure_overall]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle27_out
  []
  [particle27_ipyc_cracking]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle27_out
  []
  [particle27_debonding]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle27_out
  []
  [particle27_sic_failure_due_to_pressure]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle27_out
  []
  [particle27_sic_failure_due_to_ipyc_cracking]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle27_out
  []
  [particle27_sampler_data]
    type = SamplerData
    sampler = sample
    execute_on = 'TIMESTEP_END'
    outputs = particle27_out
  []
  [particle27_max_fluence]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle27_out
  []
  [particle27_fluence_at_failure]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle27_out
  []
  [particle27_pd_penetration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle27_out
  []
  [particle27_failure_indicator_pd_penetration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle27_out
  []
  [particle27_kernel_migration_distance]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle27_out
  []
  [particle27_failure_indicator_kernel_migration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle27_out
  []
  [particle28_sic_failure_overall]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle28_out
  []
  [particle28_ipyc_cracking]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle28_out
  []
  [particle28_debonding]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle28_out
  []
  [particle28_sic_failure_due_to_pressure]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle28_out
  []
  [particle28_sic_failure_due_to_ipyc_cracking]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle28_out
  []
  [particle28_sampler_data]
    type = SamplerData
    sampler = sample
    execute_on = 'TIMESTEP_END'
    outputs = particle28_out
  []
  [particle28_max_fluence]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle28_out
  []
  [particle28_fluence_at_failure]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle28_out
  []
  [particle28_pd_penetration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle28_out
  []
  [particle28_failure_indicator_pd_penetration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle28_out
  []
  [particle28_kernel_migration_distance]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle28_out
  []
  [particle28_failure_indicator_kernel_migration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle28_out
  []
  [particle29_sic_failure_overall]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle29_out
  []
  [particle29_ipyc_cracking]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle29_out
  []
  [particle29_debonding]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle29_out
  []
  [particle29_sic_failure_due_to_pressure]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle29_out
  []
  [particle29_sic_failure_due_to_ipyc_cracking]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle29_out
  []
  [particle29_sampler_data]
    type = SamplerData
    sampler = sample
    execute_on = 'TIMESTEP_END'
    outputs = particle29_out
  []
  [particle29_max_fluence]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle29_out
  []
  [particle29_fluence_at_failure]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle29_out
  []
  [particle29_pd_penetration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle29_out
  []
  [particle29_failure_indicator_pd_penetration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle29_out
  []
  [particle29_kernel_migration_distance]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle29_out
  []
  [particle29_failure_indicator_kernel_migration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle29_out
  []
  [particle30_sic_failure_overall]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle30_out
  []
  [particle30_ipyc_cracking]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle30_out
  []
  [particle30_debonding]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle30_out
  []
  [particle30_sic_failure_due_to_pressure]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle30_out
  []
  [particle30_sic_failure_due_to_ipyc_cracking]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle30_out
  []
  [particle30_sampler_data]
    type = SamplerData
    sampler = sample
    execute_on = 'TIMESTEP_END'
    outputs = particle30_out
  []
  [particle30_max_fluence]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle30_out
  []
  [particle30_fluence_at_failure]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle30_out
  []
  [particle30_pd_penetration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle30_out
  []
  [particle30_failure_indicator_pd_penetration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle30_out
  []
  [particle30_kernel_migration_distance]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle30_out
  []
  [particle30_failure_indicator_kernel_migration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle30_out
  []
  [particle31_sic_failure_overall]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle31_out
  []
  [particle31_ipyc_cracking]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle31_out
  []
  [particle31_debonding]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle31_out
  []
  [particle31_sic_failure_due_to_pressure]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle31_out
  []
  [particle31_sic_failure_due_to_ipyc_cracking]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle31_out
  []
  [particle31_sampler_data]
    type = SamplerData
    sampler = sample
    execute_on = 'TIMESTEP_END'
    outputs = particle31_out
  []
  [particle31_max_fluence]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle31_out
  []
  [particle31_fluence_at_failure]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle31_out
  []
  [particle31_pd_penetration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle31_out
  []
  [particle31_failure_indicator_pd_penetration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle31_out
  []
  [particle31_kernel_migration_distance]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle31_out
  []
  [particle31_failure_indicator_kernel_migration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle31_out
  []
  [particle32_sic_failure_overall]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle32_out
  []
  [particle32_ipyc_cracking]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle32_out
  []
  [particle32_debonding]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle32_out
  []
  [particle32_sic_failure_due_to_pressure]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle32_out
  []
  [particle32_sic_failure_due_to_ipyc_cracking]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle32_out
  []
  [particle32_sampler_data]
    type = SamplerData
    sampler = sample
    execute_on = 'TIMESTEP_END'
    outputs = particle32_out
  []
  [particle32_max_fluence]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle32_out
  []
  [particle32_fluence_at_failure]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle32_out
  []
  [particle32_pd_penetration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle32_out
  []
  [particle32_failure_indicator_pd_penetration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle32_out
  []
  [particle32_kernel_migration_distance]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle32_out
  []
  [particle32_failure_indicator_kernel_migration]
    type = StochasticResults
    execute_on = 'TIMESTEP_END'
    outputs = particle32_out
  []
[]

[Executioner]
  type = Steady
[]

[Outputs]
  exodus = false
  print_linear_converged_reason = false
  print_nonlinear_converged_reason = false
  [particle1_out]
    type = CSV
    file_base = results/particle1/
    execute_on = 'TIMESTEP_END'
  []
  [particle2_out]
    type = CSV
    file_base = results/particle2/
    execute_on = 'TIMESTEP_END'
  []
  [particle3_out]
    type = CSV
    file_base = results/particle3/
    execute_on = 'TIMESTEP_END'
  []
  [particle4_out]
    type = CSV
    file_base = results/particle4/
    execute_on = 'TIMESTEP_END'
  []
  [particle5_out]
    type = CSV
    file_base = results/particle5/
    execute_on = 'TIMESTEP_END'
  []
  [particle6_out]
    type = CSV
    file_base = results/particle6/
    execute_on = 'TIMESTEP_END'
  []
  [particle7_out]
    type = CSV
    file_base = results/particle7/
    execute_on = 'TIMESTEP_END'
  []
  [particle8_out]
    type = CSV
    file_base = results/particle8/
    execute_on = 'TIMESTEP_END'
  []
  [particle9_out]
    type = CSV
    file_base = results/particle9/
    execute_on = 'TIMESTEP_END'
  []
  [particle10_out]
    type = CSV
    file_base = results/particle10/
    execute_on = 'TIMESTEP_END'
  []
  [particle11_out]
    type = CSV
    file_base = results/particle11/
    execute_on = 'TIMESTEP_END'
  []
  [particle12_out]
    type = CSV
    file_base = results/particle12/
    execute_on = 'TIMESTEP_END'
  []
  [particle13_out]
    type = CSV
    file_base = results/particle13/
    execute_on = 'TIMESTEP_END'
  []
  [particle14_out]
    type = CSV
    file_base = results/particle14/
    execute_on = 'TIMESTEP_END'
  []
  [particle15_out]
    type = CSV
    file_base = results/particle15/
    execute_on = 'TIMESTEP_END'
  []
  [particle16_out]
    type = CSV
    file_base = results/particle16/
    execute_on = 'TIMESTEP_END'
  []
  [particle17_out]
    type = CSV
    file_base = results/particle17/
    execute_on = 'TIMESTEP_END'
  []
  [particle18_out]
    type = CSV
    file_base = results/particle18/
    execute_on = 'TIMESTEP_END'
  []
  [particle19_out]
    type = CSV
    file_base = results/particle19/
    execute_on = 'TIMESTEP_END'
  []
  [particle20_out]
    type = CSV
    file_base = results/particle20/
    execute_on = 'TIMESTEP_END'
  []
  [particle21_out]
    type = CSV
    file_base = results/particle21/
    execute_on = 'TIMESTEP_END'
  []
  [particle22_out]
    type = CSV
    file_base = results/particle22/
    execute_on = 'TIMESTEP_END'
  []
  [particle23_out]
    type = CSV
    file_base = results/particle23/
    execute_on = 'TIMESTEP_END'
  []
  [particle24_out]
    type = CSV
    file_base = results/particle24/
    execute_on = 'TIMESTEP_END'
  []
  [particle25_out]
    type = CSV
    file_base = results/particle25/
    execute_on = 'TIMESTEP_END'
  []
  [particle26_out]
    type = CSV
    file_base = results/particle26/
    execute_on = 'TIMESTEP_END'
  []
  [particle27_out]
    type = CSV
    file_base = results/particle27/
    execute_on = 'TIMESTEP_END'
  []
  [particle28_out]
    type = CSV
    file_base = results/particle28/
    execute_on = 'TIMESTEP_END'
  []
  [particle29_out]
    type = CSV
    file_base = results/particle29/
    execute_on = 'TIMESTEP_END'
  []
  [particle30_out]
    type = CSV
    file_base = results/particle30/
    execute_on = 'TIMESTEP_END'
  []
  [particle31_out]
    type = CSV
    file_base = results/particle31/
    execute_on = 'TIMESTEP_END'
  []
  [particle32_out]
    type = CSV
    file_base = results/particle32/
    execute_on = 'TIMESTEP_END'
  []
[]
