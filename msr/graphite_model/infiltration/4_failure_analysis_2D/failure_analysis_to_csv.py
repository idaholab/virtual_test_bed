import json
import numpy as np
import os
import csv

# === CONFIGURATION ===
cwd = os.getcwd()  # Replace with actual path
file_path = os.path.join(cwd, "pss_out.json")
Nsubsets_to_consider = 7000

# === LOAD DATA ===
with open(file_path, "r") as f:
    data = json.load(f)

time_steps = data["time_steps"]
all_inputs = []
all_outputs = []

for i in range(1, len(time_steps)):
    step = time_steps[i]
    inputs = np.array(step["adaptive_MC"]["inputs"]).T
    output = step["adaptive_MC"]["output_required"]
    all_inputs.extend(inputs)
    all_outputs.extend(output)

inputs_array = np.array(all_inputs).reshape(-1, 8)[:Nsubsets_to_consider]
outputs_array = np.array(all_outputs)[:Nsubsets_to_consider]

# === SAVE STRESS OUTPUT (MPa) ===
np.savetxt("stress_output.csv", outputs_array * 1e-6, delimiter=",", header="max_stress_mpa", comments='')

# === IDENTIFY FAILED POINTS ===
failed_mask = outputs_array > 15e6
failed_inputs = inputs_array[failed_mask]
failed_outputs = outputs_array[failed_mask]

# === APPLY SCALING FACTORS ===
factors = np.ones(8)
factors[1] = 1e-9
factors[3] = 1 / (0.2 * 1e6)

adjusted_inputs = failed_inputs * factors
adjusted_outputs = failed_outputs * 1e-6
combined_matrix = np.hstack((adjusted_inputs, adjusted_outputs.reshape(-1, 1)))

# === COMPUTE MIN/MAX VALUES ===
min_values = np.min(combined_matrix[:, :8], axis=0)
max_values = np.max(combined_matrix[:, :8], axis=0)

# === SIMPLIFIED HEADERS ===
headers = [
    'infiltration',
    'youngs_modulus',
    'thermal_conductivity',
    'power_density',
    'poisson_ratio',
    'interface_temperature',
    'heat_transfer_coeff',
    'thermal_expansion'
]

# === SAVE MIN/MAX TO CSV ===
with open("min_max_values.csv", "w", newline="") as f:
    writer = csv.writer(f)
    writer.writerow(["stat"] + headers)
    writer.writerow(["min"] + list(min_values))
    writer.writerow(["max"] + list(max_values))
