#!/usr/bin/env python

import matplotlib.pyplot as plt
import matplotlib
matplotlib.use('Agg')
import matplotlib.cm as cm
import matplotlib.colors as colors
import matplotlib
import pandas as pd

faildata = pd.read_csv('rpv_pfm_3d_final_flaw_failure_data_0035.csv')

#Sort based on the column with CPI data so that the highest CPI points are last, and get plotted over the other ones
# Procedure from https://stackoverflow.com/questions/2828059/sorting-arrays-in-numpy-by-column
faildata = faildata.sort_values('cpi')

cpi = faildata['cpi']
ki = faildata['ki']
dt = faildata['relative_temperature']

min_cpi = cpi.min()
max_cpi = cpi.max()

plt.figure(figsize=(6.0,3.5))
ax=plt.gca()
cmap1=cm.get_cmap('rainbow')
sc=plt.scatter(dt,ki,c=cpi,s=1.5,linewidths=0,norm=colors.LogNorm(vmin=min_cpi, vmax=max_cpi),cmap=cmap1,rasterized=True)
cb=plt.colorbar(sc)
cb.solids.set_rasterized(True)
cb.set_label('CPI')
#plt.xlim(0,360)
plt.xlabel('$\mathregular{T-RT_{NDT}(^\circ F)}$',labelpad=10)
plt.ylabel('$\mathregular{K_{I}(ksi\sqrt{in}})$')
plt.savefig('scatter_temp_ki.png',dpi=300,bbox_inches='tight',pad_inches=0)
