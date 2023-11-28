import glob
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import os

# Define axial coordinates
coords=[]
for z in np.arange(32):
   coords.append((z/31)*180)

# Obtain IPyC crack Rates
path1_ipyc = r"./TRISO/results/particle*/_particle?_ipyc_cracking_0001.csv"
path2_ipyc = r"./TRISO/results/particle*/_particle??_ipyc_cracking_0001.csv"
looper = 1
ipyc_cracks=[]
for fname in np.sort(glob.glob(path1_ipyc)):
   df=pd.read_csv(fname)
   ipyc_data=df["ipyc_cracking_particle"+str(looper)+":ipyc_cracking"]
   ipyc_cracks.append(ipyc_data[ipyc_data>0.5].count()/ipyc_data.count())
   looper+=1
for fname in np.sort(glob.glob(path2_ipyc)):
   df=pd.read_csv(fname)
   ipyc_data=df["ipyc_cracking_particle"+str(looper)+":ipyc_cracking"]
   ipyc_cracks.append(ipyc_data[ipyc_data>0.5].count()/ipyc_data.count())
   looper+=1

# Plot IPyC Crack Rates
plt.figure
plt.grid()
plt.plot(np.array(ipyc_cracks)*100,np.array(coords),'x')
plt.xlabel('Crack Rate (%)')
plt.ylabel('Axial Position (cm)')
plt.title('IPyC Crack Rates for HP-MR TRISO')
plt.savefig('IPyC_CrackRates')
plt.clf()

# Obtain SiC Failure Rates
path1_sic = r"./TRISO/results/particle*/_particle?_sic_failure_overall_0001.csv"
path2_sic = r"./TRISO/results/particle*/_particle??_sic_failure_overall_0001.csv"
looper=1
sic_cracks=[]
for fname in np.sort(glob.glob(path1_sic)):
   df=pd.read_csv(fname)
   sic_data=df["sic_failure_overall_particle"+str(looper)+":sic_failure_overall"]
   sic_cracks.append(sic_data[sic_data>0.5].count()/sic_data.count())
   looper+=1
for fname in np.sort(glob.glob(path2_sic)):
   df=pd.read_csv(fname)
   sic_data=df["sic_failure_overall_particle"+str(looper)+":sic_failure_overall"]
   sic_cracks.append(sic_data[sic_data>0.5].count()/sic_data.count())
   looper+=1

# Plot SiC Failure Rates
plt.figure
plt.grid()
plt.plot(np.array(sic_cracks)*100,np.array(coords),'x')
plt.xlabel('Crack Rate (%)')
plt.ylabel('Axial Position (cm)')
plt.title('SiC Crack Rates for HP-MR TRISO')
plt.savefig('SiC_CrackRates')
plt.clf()
