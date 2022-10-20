# PG-26 Results

The main variables of interest in this model were the temperatures recorded in the ceramic core block and helium coolant channels. The 
following plots and figure represent results obtained from the MultiApp HTTF model.

Note: many thermocouples were not able to handle the temperatures experienced in the HTTF during the experiment and temporarily failed. This 
resulted in large vertical variations in the experimental data which were unrealistic. However, these failures were brief enough for the 
overall trend to still be visible. Also, during the heat up, a slow coolant leak occurred in the primary system which caused a decrease in 
primary coolant inventory. HTTF operators were able to fix the leak during the test, however, the amount of coolant lost, amount of 
make-up coolant added, temperature of the make-up coolant, and the time of the make-up coolant addition were unknown during the 
making of this model.

## Radial Temperature Distributions

Radial temperature distributions were plotted for core block 5 which is the mid-plane of the HTTF core. The core was divided into 3 radial 
sections, the inner ring (IR), middle ring (MR), and outer ring (OR). The temperatures in these plots represent the average of all 
`Postprocessor` temperature values within each radial region. 

!media /httf/T_avg_5_comp.png
    style=width:50%
    caption=Radially averaged ceramic core temperatures in core block 5.


!media /httf/Tf_avg_5_comp.png
    style=width:50%
    caption=Radially averaged helium coolant temperatures in core block 5.

## Axial Temperature Distributions

These plots represent temperatures recorded by `Postprocessors` located in the same `x` and `y` positions but at the 3 varying axial core block heights. These `Postprocessors` carry the same naming convention as their corresponding thermocouples in the HTTF core.

!media /httf/TS_05_comp.png
    style=width:50%
    caption=Axial distribution of ceramic core temperature at instrumentation position 05.

!media /httf/TF_18_comp.png
    style=width:50%
    caption=Axial distribution of helium coolant temperature at instrumentation position 18.

## 3-D Model Temperature Distribution

The 3-D model allowed for visualization of the temperature profile across the entire HTTF model. Below is an image of the HTTF model during the hottest point of the PG-26 transient.

!media /httf/httf_3D.png
    style=width:50%
    caption=Cutaway of the HTTF model during the hottest point of the PG-26 transient.