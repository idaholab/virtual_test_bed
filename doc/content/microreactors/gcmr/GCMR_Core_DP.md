# Full-Core GCMR Coolant Depressurization Transient

Unlike the single-channel blockage transient, which has localized effects, the coolant depressurization transient is a global event that impacts the entire GCMR core. Within 13 seconds of the transient event's initiation, the coolant outlet pressure in all channels drops linearly from 7 MPa to ambient pressure (i.e., 0.1 MPa, see [plot_pressure]). Simultaneously, the coolant velocity decreases from 15 m/s to 0.1 m/s (see [plot_velocity]).

!plot scatter id=plot_pressure caption=Coolant outlet pressure during the coolant depressurization transient
              data=[{'x':[0,13,20], 'y':[7,0.1,0.1], 'name':'pressure'}]
              layout={'yaxis':{'title':'Coolant Outlet Pressure (MPa)', 'range':[0, 8]},
                      'xaxis':{'title':'Transient Time (s)', 'range':[0, 15]}}

!plot scatter id=plot_velocity caption=Coolant inlet velocity during the coolant depressurization transient
              data=[{'x':[0,13,20], 'y':[15,0.1,0.1], 'name':'velocity'}]
              layout={'yaxis':{'title':'Coolant Inlet Velocity (m/s)', 'range':[0, 16]},
                      'xaxis':{'title':'Transient Time (s)', 'range':[0, 15]}}

This event significantly reduces the global heat removal capacity of the GCMR, leading to a substantial temperature increase. Similar to the single coolant channel blockage case, temperature feedback during the high-temperature transient leads to a rapid decrease in reactor power, as shown in [gcmr_pv_ana]. The GC-MR almost loses all of its original operating power within 400 seconds, along with a maximum temperature increase in fuel by approximately 50 K.

!media media/gcmr/FCMP/gcmr_pv_ana.gif
      id=gcmr_pv_ana
      style=display: block;margin-left:auto;margin-right:auto;width:95%;
      caption=Time evolution of reactor power during a coolant depressurization transient