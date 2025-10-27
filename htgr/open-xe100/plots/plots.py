import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import os

# To make the relative paths work
os.chdir(os.path.dirname(os.path.realpath(__file__)))

# Load the CSV files
iqs_output = pd.read_csv('../iqs.csv')
pke_output = pd.read_csv('../pke_fuel_auto.csv')

time_iqs = iqs_output['time']
time_pke = pke_output['time']

# Plot the power density
plt.figure()
plt.plot(time_iqs, iqs_output['total_power'] / iqs_output['total_power'][0], label="IQS")
plt.plot(time_pke, pke_output['n'] / pke_output['n'][0], label="PKE")
plt.xlabel("Time (s)")
plt.ylabel("Normalized Power (-)")
plt.legend()
plt.tight_layout()
plt.savefig('power_comparison.png')
