import numpy as np
import matplotlib.pyplot as plt

# To use this, you need to add the moose/modules/thermal_hydraulics/python
# directory to your PYTHONPATH environment variable.
from thm_utilities import readCSVFile, readMOOSEXML

data_main = readCSVFile('main.csv')

n_hp = 7
colors = ['orchid', 'indianred', 'orange', 'gold', 'lightgreen', 'cornflowerblue', 'mediumpurple']

def initializePlot():
  plt.figure(figsize=(8, 6))
  plt.rc('text', usetex=True)
  plt.rc('font', family='sans-serif')
  ax = plt.subplot(1, 1, 1)
  ax.get_yaxis().get_major_formatter().set_useOffset(False)

def finalizePlot(plot_filename):
  plt.legend(frameon=False, prop={'size':10})
  plt.tight_layout()
  plt.savefig(plot_filename, dpi=300)

def averageAdjacentPoints(x):
  n = int(len(x) / 2)
  xx = np.zeros(n)
  for i in range(n):
    xx[i] = 0.5 * (x[2*i] + x[2*i+1])
  return xx

# temperature transient

initializePlot()
plt.xlabel("Time [s]")
plt.ylabel("Temperature [K]")
plt.plot(data_main['time'], data_main['Tavg_fuel'], '-',  color='black', marker='', label='Fuel (Avg)')
plt.plot(data_main['time'], data_main['Tmax_fuel'], '--', color='black', marker='', label='Fuel (Max)')
plt.plot(data_main['time'], data_main['Tavg_hp_holes'], '-',  color='indianred', marker='', label='Heat Pipe (Avg)')
plt.plot(data_main['time'], data_main['Tmax_hp_holes'], '--', color='indianred', marker='', label='Heat Pipe (Max)')
plt.plot(data_main['time'], data_main['Tavg_monolith'], '-',  color='orange', marker='', label='Monolith (Avg)')
plt.plot(data_main['time'], data_main['Tmax_monolith'], '--', color='orange', marker='', label='Monolith (Max)')
plt.plot(data_main['time'], data_main['Tavg_brefl'], '-',  color='lightgreen', marker='', label='Bottom Reflector (Avg)')
plt.plot(data_main['time'], data_main['Tmax_brefl'], '--', color='lightgreen', marker='', label='Bottom Reflector (Max)')
plt.plot(data_main['time'], data_main['Tavg_trefl'], '-',  color='cornflowerblue', marker='', label='Top Reflector (Avg)')
plt.plot(data_main['time'], data_main['Tmax_trefl'], '--', color='cornflowerblue', marker='', label='Top Reflector (Max)')
finalizePlot('temperature_transient.png')

# steady temperature profile

initializePlot()
plt.xlabel("Axial Position [m]")
plt.ylabel("Temperature [K]")
for i in range(n_hp):
  data = readMOOSEXML('main_hp_app%d_xml.xml' % i)
  z_vapor = averageAdjacentPoints(data['core_vpp']['z'][-1])
  T_vapor = averageAdjacentPoints(data['core_vpp']['T'][-1])
  z_wall = data['clad_o_vpp']['z'][-1]
  T_wall = data['clad_o_vpp']['T_solid'][-1]
  plt.plot(z_vapor, T_vapor, '-', color=colors[i], marker='', label='HP %d Vapor' % i)
  plt.plot(z_wall, T_wall, '--', color=colors[i], marker='', label='HP %d Wall' % i)
finalizePlot('temperature_steady.png')
