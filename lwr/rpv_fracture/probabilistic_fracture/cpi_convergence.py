#!/usr/bin/env python
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import pandas as pd

running_stats=pd.read_csv('rpv_pfm_3d_final_cpi_running_statistics_0035.csv')

plt.figure(figsize=(6.0,4.5))
ax=plt.gca()

running_stats.plot(ax=ax, y='mean')

ax.set_xlabel("Number of RPV Realizations")
ax.set_ylabel("Conditional Probability of Initiation (CPI)")

plt.savefig('cpi_convergence.png', bbox_inches='tight', pad_inches=0.1, dpi=200)
