# Full-Core GCMR Single Coolant Channel Blockage Transient

The single coolant channel blockage transient is initiated by setting the coolant velocity of one coolant channel to zero (out of 440 total channels in the 1/6 model of the core). Such a setup effectively eliminates the heat removal capacity of the affected coolant channel. To emphasize the effect of the blockage event, the coolant channel of interest is selected to be in the middle radial region of the GC-MR where the maximum temperature is observed. It is also worth noting that the nominal "single channel blockage" actually involves 6 blocked channel in the full GCMR core as a 1/6 core model is used here to utilize symmetry to reduce computational cost.

The time evolution of the normalized power change is illustrated in [gcmr_scb_power]. The power dropped less than approximately 0.4% due to this localized coolant channel event. As indicated by [gcmr_scb_tfmax], the blockage of the single coolant channel near the hottest region of the GC-MR leads to an increase in the maximum fuel temperature by ~30 K. A temperature profile evolution is illustrated in [gcmr_scb_midplane], highlighting the localized nature of this transient event. In fact, the average fuel temperature is predicted to change by less than 0.1 K throughout the simulation. In summary, with a single coolant channel block, the temperature in the locally affected region slightly increases as nearby channels remove excess heat.

!media media/gcmr/FCMP/tr_scb_power.png
      id=gcmr_scb_power
      style=display: block;margin-left:auto;margin-right:auto;width:45%;
      caption=Time evolution of reactor power during a single coolant channel blockage transient

!media media/gcmr/FCMP/tr_scb_tfmax.png
      id=gcmr_scb_tfmax
      style=display: block;margin-left:auto;margin-right:auto;width:45%;
      caption=Time evolution of maximum fuel temperature during a single coolant channel blockage transient

!media media/gcmr/FCMP/gcmr_scb_ana.gif
      id=gcmr_scb_midplane
      style=display: block;margin-left:auto;margin-right:auto;width:65%;
      caption=The tempature change at the midplane of the core during a single coolant channel blockage transient. The blocked channel is marked by the white circle.