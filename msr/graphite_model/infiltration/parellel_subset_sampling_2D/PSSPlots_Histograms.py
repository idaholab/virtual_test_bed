import json
import numpy as np
import os
import seaborn as sns
import matplotlib.pyplot as plt
import random
from scipy.stats import entropy

# plt.rcParams.update({'font.size': 18})

# cwd = '/Users/pritv/1_NRCProject_GraphiteModeling/Simulations/MSRE/MSRE_Refined_Simulations/SubsetSampling_2D/1P5X/'
# cwd = '/Users/pritv/1_NRCProject_GraphiteModeling/Simulations/MSRE/MSRE_Refined_Simulations/WithHotSpot_SubsetSampling_2D/1X/'

# bins1 = np.array([20, 20, 20, 20, 20, 20, 20, 20])  # Number of bins for Monte Carlo samples
# bins2 = np.array([10, 20, 10, 10, 15, 15, 15, 10])  # Number of bins for failed samples

cwd = '/Users/pritv/1_NRCProject_GraphiteModeling/Simulations/MSRE/MSRE_Refined_Simulations/SubsetSampling_2D/'

# Define number of bins for the two histograms
bins1 = np.array([20, 20, 20, 20, 20, 20, 20, 20])  # Number of bins for Monte Carlo samples
bins2 = np.array([4, 10, 4, 5, 15, 15, 15, 6])  # Number of bins for failed samples



os.chdir(cwd)

# Define file path
file_path = cwd + "pss_out.json"  # Replace with your JSON file path

Nsubsets_to_consider = 7000

# Initialize lists to store inputs and outputs
all_inputs = []
all_outputs = []

# Load the JSON file
with open(file_path, "r") as f:
    data = json.load(f)

# Extract data for each time step
time_steps = data["time_steps"]  # Adjust key if necessary
length_list = len(time_steps)

for i in range(1, length_list):
    step = time_steps[i]
    inputs = step["adaptive_MC"]["inputs"]  # Access the inputs
    transposed_inputs = np.array(inputs).T
    output = step["adaptive_MC"]["output_required"]  # Access the output

    # Append inputs and outputs
    all_inputs.extend(transposed_inputs)
    all_outputs.extend(output)

# Convert to NumPy arrays
inputs_array = np.array(all_inputs).reshape(-1, 8)  # Shape: (5000, 8)
outputs_array = np.array(all_outputs)  # Shape: (5000, 1)
inputs_array = inputs_array[:Nsubsets_to_consider,:]
outputs_array = outputs_array[:Nsubsets_to_consider]

# Check shapes
print("Inputs shape:", inputs_array.shape)  # Should be (5000, 8)
print("Outputs shape:", outputs_array.shape)  # Should be (5000, 1)

# Failure probability
last_1000_points = outputs_array[-1000:]
subset_prob_calc = len(last_1000_points[last_1000_points > 15e6]) / len(last_1000_points)
global_prob = subset_prob_calc * 1e-6
ind1 = outputs_array > 15e6
failed_points = len(outputs_array[ind1])

plt.figure(dpi=300)
plt.plot(outputs_array * 1e-6)
plt.xlabel('No. of samples')
plt.ylabel('Max. Stress (MPa)')
plt.grid(False)
plt.show()

rndvals = random.sample(range(1000), failed_points)
kl_divergence = np.zeros(8)


# Use LaTeX for all text rendering
# plt.rcParams['text.usetex'] = True

labels = [
    'Infiltration (\%)',
    r"Young's Modulus (GPa)",
    r'Thermal Conductivity (W/mK)',
    r'Power Density (MW/m$^3$)',
    r'Poisson Ratio',
    r'Interface Temperature (K)',
    r'Heat Transfer Coeff. (W/m$^2$K)',
    r'Coeff. of Thermal Expansion (1/K)'
]

bounds = [
    (0, 1),
    (9, 15),
    (25, 100),
    (10, 250),
    (0.13, 0.21),
    (823, 1023),
    (3500, 5500),
    (3.5e-6, 6.0e-6)
]

for idx0 in range(8):
    hist1 = inputs_array[rndvals, idx0]
    hist2 = inputs_array[ind1, idx0]
    
    # Normalize the histograms to create probability distributions
    prob_dist1 = hist1 / np.sum(hist1)
    prob_dist2 = hist2 / np.sum(hist2)
    
    # Compute KL divergence
    kl_divergence[idx0] = entropy(prob_dist1, prob_dist2)
    
    if idx0 == 3:
        fact = 1 / (0.2 * 1e6)
    elif idx0 == 1:
        fact = 1e-9
    else:
        fact = 1
    
    sns.set(style="whitegrid")
    plt.figure(figsize=(4, 4), dpi=300)
        

    
    plt.hist(inputs_array[0:1000, idx0] * fact, bins=bins1[idx0], density=True, alpha=0.5, color="b", label="Monte Carlo Samples")
    plt.hist(inputs_array[ind1, idx0] * fact, bins=bins2[idx0], density=True, alpha=0.5, color="r", label="Failed Samples")
    
    plt.xlabel(labels[idx0])
    plt.ylabel("Density")
    plt.legend()
    plt.grid(False)
    plt.show()

kl_divergence /= np.sum(kl_divergence)
# Set print options to format floats to 2 decimal places
np.set_printoptions(formatter={'float': '{:.2f}'.format})

print(kl_divergence)

# Extract the input and output data for the failed points
failed_inputs = inputs_array[ind1]
failed_outputs = outputs_array[ind1]

# Define the multiplication factors
factors = np.ones(8)
factors[1] = 1e-9
factors[3] = 1 / (0.2 * 1e6)

# Apply the multiplication factors to the inputs
adjusted_inputs = failed_inputs * factors

# Apply the multiplication factor to the output
adjusted_outputs = failed_outputs * 1e-6

# Combine the adjusted input and output data into one matrix
combined_matrix = np.hstack((adjusted_inputs, adjusted_outputs.reshape(-1, 1)))

# Initialize arrays to store the minimum and maximum values
min_values = np.zeros(8)
max_values = np.zeros(8)

# Calculate the minimum and maximum values for each column
for idx in range(8):
    min_values[idx] = np.min(combined_matrix[:, idx])
    max_values[idx] = np.max(combined_matrix[:, idx])

# Display the minimum and maximum values
print("Min values:")
for idx, min_val in enumerate(min_values):
    if idx == 7:
        print(f"{min_val:.4e}")
    else:
        print(f"{min_val:.4f}")

print("\nMax values:")
for idx, max_val in enumerate(max_values):
    if idx == 7:
        print(f"{max_val:.4e}")
    else:
        print(f"{max_val:.4f}")
