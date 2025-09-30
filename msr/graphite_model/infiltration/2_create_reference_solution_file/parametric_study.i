# Input file to be run to generate output files corresponding to different infiltration amounts
[ParameterStudy]
  input = 2D_CreateInfiltrationProfile.i
  parameters = 'vol_frac_threshold'
  sampling_type = input-matrix
  input_matrix = '0.1;0.2;0.3;0.4;0.5;0.6;0.7;0.8;0.9;1.0'
  min_procs_per_sample = 4
[]
