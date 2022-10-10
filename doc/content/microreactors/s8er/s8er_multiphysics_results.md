# SNAP 8 Experimental Reactor (S8ER) Multiphysics Results

*Contact: Isaac Naupa, iaguirre6@gatech.edu*
*Contact: Stefano Terlizzi, Stefano.Terlizzi@inl.gov*

!alert note
For citing purposes, please cite [!citep](s8er_garcia2022) and [!citep](s8er_naupa2022).

## Results

Plots of the power density and temperature spatial profile are reported in (Griffin Power Density) (Bison Power Density), respectively. It is noticeable that both power and temperature peak in the center. This is expected based on the uniform enrichment in the core. The Griffin results were also compared in standalone fashion (i.e., no thermal feedback) with the Serpent results that are validated against experimental results showing agreement within ~300 pcm. 

!media s8er/results_power_density.png
  caption= Griffin Power Density, from [!citep](s8er_naupa2022)
  style=width:60%;margin-left:auto;margin-right:auto

!media s8er/results_bison_temperature.png
  caption= Bison Temperature, from [!citep](s8er_naupa2022)
  style=width:60%;margin-left:auto;margin-right:auto

## Future Work

Future work can be devoted to improving the model fidelity by creating a 3D model and by simulating the NaK flow with SAM or Pronghorn. The results from the improved model will then be compared with experimental results in a systematic way, therefore providing validation for NEAMS-based tools against experimental data.

!alert note
More information about the SNAP Reactors may be found [here](https://github.com/CORE-GATECH-GROUP/SNAP-REACTORS).

!bibtex bibliography


