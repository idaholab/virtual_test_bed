# ------------------- L I B R A R Y   I M P O R T S ------------------------- #
from matplotlib import pyplot as plt
from matplotlib import transforms
from matplotlib import dates
import matplotlib
import numpy as np
import pandas as pd
from scipy import interpolate
from datetime import date
import matplotlib.image as pltimg
# ------------------- P L O T   S E T T I N G S  ---------------------------- #
# time_griffin	Avg_Temp_Griffin	Max_Temp_Griffin	Total_Power_Griffin	time_vsop	Avg_Temp_VSOP	Max_Temp_VSOP
# time	Tfluid_core	Tfuel_avg	Tfuel_max	Tmod_avg	Tmod_max	Tsolid_core	UnscaledTotalPower	decay_power	dt	dt_max_pp	init_prompt_power	max_T_solid	power_peak	power_scaling	prompt_power	total_power

df         = pd.read_csv("results2_ref_dlofc.csv")
time_ref   = df['time_vsop']
avg_T_ref  = df['Avg_Temp_VSOP']
Max_T_ref  = df['Max_Temp_VSOP']

time_grif   = df['time_griffin']
avg_T_grif  = df['Avg_Temp_Griffin']
Max_T_grif  = df['Max_Temp_Griffin']
P_griffin   = df['Total_Power_Griffin']

df         = pd.read_csv("htr_pm_griffin_tr_dlofc_out.csv")
time_grif_nxs   = df['time']/3600
avg_T_grif_nxs  = df['Tfuel_avg']-273.15
Max_T_grif_nxs  = df['Tfuel_max']-273.15
P_griffin_nxs   = df['total_power']*1.0e-6

plt.plot(time_ref,avg_T_ref, color =  'black', linestyle='dashed', label='ref. Fuel Avg. Temp.')     
plt.plot(time_ref,Max_T_ref, color =  'red',   linestyle='dashed', label='ref. Fuel Max. Temp.')  

plt.plot(time_grif,avg_T_grif, color =  'black', label='Griffin. Fuel Avg. Temp.')     
plt.plot(time_grif,Max_T_grif, color =  'red',   label='Griffin. Fuel Max. Temp.')   
   
plt.plot(time_grif_nxs,avg_T_grif_nxs, color =  'orange', label='new XS Griffin. Fuel Avg. Temp.')     
plt.plot(time_grif_nxs,Max_T_grif_nxs, color =  'lime',   label='new XS Griffin. Fuel Max. Temp.')   
#plt.legend(loc='upper left')
#plt.legend(loc='lower center', bbox_to_anchor=(0.5, -1.35))
plt.legend(loc='center right', bbox_to_anchor=(1., 0.5))
plt.xlabel('Time (hr)',fontweight="bold")
plt.ylabel('Temperature (C)',fontweight="bold")
plt.xlim(0, 140)
plt.ylim(800, 1600)
plt.title('HTR-PM DLOFC',fontweight="bold")
plt.show()

#def plot_sec_ax(*data):
#    ti, P1, P2, Diff, P1_lab, P2_lab, Diff_lab, x_lab, y1_lab, y2_lab, title, leg_loc = data
#    fig, ax1 = plt.subplots()
#    ax2 = ax1.twinx()
#    ax1.plot(ti, P1, color = 'blue',label=P1_lab)
#    ax1.plot(ti, P2, color = 'red',label=P2_lab)
#    ax2.plot(ti, Diff, color = 'green',label=Diff_lab)
#    ax1.set_xlabel(x_lab )
#    ax1.set_ylabel(y1_lab)
#    ax1.legend(loc=leg_loc )
#    ax2.set_ylabel(y2_lab)
#    plt.title(title)
#    plt.show()
#
#
#P1_lab = 'RX.Eng. Data'
#P2_lab = 'Serpent Data'
#Diff_lab = 'Rel. Diff.'
#x_lab = 'Time (s)'
#y1_lab = 'Power (MW)'
#y2_lab = 'Relative Difference (%)'
#title = 'Point Kinetics Equation 6DNPG'
#leg_loc = 'upper left'
#data_plot=(t, P_rx*1.0e-6, P_sp*1.0e-6, Diff_1, P1_lab, P2_lab, Diff_lab, x_lab, y1_lab, y2_lab, title, leg_loc)
#plot_sec_ax(*data_plot)
##print(sum(P_sp))
#
#Diff_2 = [0.0]*n
#Diff_2 = np.array(0.0, dtype=float)
#data_diff_2g=(n, rho_rx1, rho_sp1)
#Diff_2 = diff_anal_1g([0.0]*n, *data_diff_2g)
#
#P1_lab = 'RX.Eng. Data'
#P2_lab = 'Serpent Data'
#Diff_lab = 'Rel. Diff.'
#x_lab = 'Time (s)'
#y1_lab = 'Energy (MJ)'
#y2_lab = 'Relative Difference (%)'
#title = 'Point Kinetics Equation 6DNPG'
#leg_loc = 'upper left'
#data_plot2=(t, rho_rx1/B_eff_1G_rx, rho_sp1/B_eff_1G_sp, Diff_2, P1_lab, P2_lab, Diff_lab, x_lab, y1_lab, y2_lab, title, leg_loc)
##or j in range(n):
##    print(t[j],P_rx[j]*1.0e-6, P_sp[j]*1.0e-6)
#plot_sec_ax(*data_plot2)