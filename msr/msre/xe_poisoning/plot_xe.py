##This plots the Xe concentration evolution over time
import matplotlib.pyplot as plt
import pandas as pd

# Set parameters as requested
plt.rcParams['font.family'] = 'DejaVu Sans Mono'
plt.rcParams['font.size'] = 12

# Load the CSV files into DataFrames
data_case1 = pd.read_csv('./th_xe_out.csv')
#data_case2 = pd.read_csv('th_xe_out_coupled01.csv')

# Extract the 1st and 2nd columns from both datasets
x_data_case1 = data_case1.iloc[:, 0] / 3600  # Convert seconds to hours
y_data_case1 = data_case1.iloc[:, 1]  # 2nd column for case 1

#x_data_case2 = data_case2.iloc[:, 0] / 3600  # Convert seconds to hours
#y_data_case2 = data_case2.iloc[:, 1]  # 2nd column for case 2

# Plot the data
plt.figure(figsize=(10, 6))

# Plot case 1 data
plt.plot(x_data_case1, y_data_case1, linestyle='-', color='#1f77b4', linewidth=2)

# Plot case 2 data
#plt.plot(x_data_case2, y_data_case2, marker='s', linestyle='--', color='r', label='Xe production scaling, 4.0e-18')

## Set y-axis to log scale
#plt.yscale('log')

# Add labels and title
plt.xlabel('Time (hours)')
plt.ylabel('Xe-135 Concentration (#/barn-cm)')
plt.title('Development of Xe-135 concentration')

# Display the plot
plt.grid(True, linestyle='--', alpha=0.6)

# Remove top and right spines for a cleaner look
ax = plt.gca()
ax.spines['top'].set_visible(False)
ax.spines['right'].set_visible(False)

plt.tight_layout()
plt.savefig('xe_feedback.png', dpi=300, bbox_inches='tight')
plt.show()

