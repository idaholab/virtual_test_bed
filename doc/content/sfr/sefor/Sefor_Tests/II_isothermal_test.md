# SEFOR Core I-I Isothermal Test 

Reactivity feedback in SEFOR Core I-I during isothermal tests was computed using Griffin’s deterministic model. 

The total reactivity feedback was obtained by interpolating temperature-dependent cross-section 
libraries and updating the active core geometry according to the thermal expansion coefficients 
specified in the benchmark. 

The table below compares the calculated total reactivity feedback with the experimental values 
obtained from isothermal tests performed in Core I-I, where the core temperature was increased 
from 360 F to 760 F. The calculated results were obtained using Griffin with the ENDF/B-VII.0 
nuclear data library, while the experimental data serve as reference values. For comparison, the 
table also includes a previously reported value from Serpent2 calculations using the ENDF/B-VII.1 
library


| Core I-I      | Library        | Integral ∆ρ (cents) | C/E           |
|--------------|----------------|----------------------|----------------|
| Measurement  | —              | -248.8               | —              |
| Griffin      | ENDF/B-VII.0   | -244.34              | 0.9821         |
| Serpent2     | ENDF/B-VII.1   | -243.4 ± 3.61        | 0.9784         |


