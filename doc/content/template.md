# Model Name

Contact: Model Developer, model_developer.at.institute.com (contact email) 

## High Level Summary of Model

High level introduction is expected here about the model of interest. Figures and tables can be added 
in the model description, of which the examples are provided below. 

#### Adding a figure

The markdown source is shown below, and one should put a copy of the figure at the specific file path.

```language=bash
!media msr/msre/SAM_MSRE_1D.png
       style=width:60%
       id=msre_sam
       caption=The steady-state temperature distribution in the 1-D MSRE primary loop.

```

[Click here](msr/msre/msre_sam_model.md#msre_sam) to check out the formatted figure appeared on VTB website:


#### Adding a table

The markdown source is shown below:

```language=bash
!table id=fuel_salt_properties caption=Thermophysical properties of the fuel salt.
|   |   | Unit  | LiF-BeF$_4$-ZrF$_4$-UF$_4$  |
| :- | :- | :- | :- |
| Melting temperature | $T_{melt}$ | $K$ | $722.15$  |
| Density | $\rho$ | $kg/m^3$  | $2553.3-0.562\bullet T$ |
| Dynamic viscosity | $\mu$ | $Pa\bullet s$ | $8.4\times 10^{-5} exp(4340/T)$ |
| Thermal conductivity | $k$ | $W/(m\bullet K)$ | $1.0$ |
| Specific heat capacity | $c_p$ | $J/(kg\bullet K)$ | $2009.66$ |

```

[Click here](msr/msre/msre_sam_model.md#fuel_salt_properties) to check out the formatted table appeared on VTB website:

#### Adding references

If the model has been previously published, one should provide the reference to the published works together with the key references used for model development. 
The Latex style references are supported in MOOSE documentation, and some examples about how to cite technical report, conference proceedings and journal articles are given below. The bibtex entries have to be added into file `vtb.bib`. 
A bibliography list will be generated automatically at the end of the document. 

```language=bash
@techreport{Hu2017,
        address = {Lemont, IL},
        author = {Hu, Rui},
        number = {ANL/NE-17/4},
        mendeley-tags = {ANL/NE-17/4},
        institution = {Argonne National Laboratory},
        title = {{SAM Theory Manual}},
        year = {2017}
}

```

```language=bash
@InProceedings{novak_2021c,
  title       = {{Coupled {Monte} {Carlo} and Thermal-Hydraulics Modeling of a Prismatic Gas Reactor Fuel Assembly Using {Cardinal}}},
  author     = {A.J. Novak and D. Andrs and P. Shriwise and D. Shaver and P.K. Romano and E. Merzari and P. Keutelian},
  booktitle  = {{Proceedings of Physor}},
  year       = 2021
}

```

```language=bash
@article{Fang2021,
        author = {Fang, Jun and Shaver, Dillon R. and Min, Misun and Fischer, Paul
                and Lan, Yu-Hsiang and Rahaman, Ronald and Romano, Paul
                and Benhamadouche, Sofiane and Hassan, Yassin A.
                and Kraus, Adam and Merzari, Elia},
        doi = {10.1016/j.nucengdes.2021.111143},
        journal = {Nuclear Engineering and Design},
        title = {{Feasibility of Full-Core Pin Resolved CFD Simulations of
                Small Modular Reactor with Momentum Sources}},
        volume = {378},
        year = {2021}
}

```

To cite the references, one can do the following in the markdown file.

```language=bash
description part A [!citep](Hu2017), description part B [!citep](novak_2021c), description part C [!citep](Fang2021)

```

description part A [!citep](Hu2017), description part B [!citep](novak_2021c), description part C [!citep](Fang2021)


#### Other key model details to provide in the high-level summary

- MOOSE Based Applications Used: Griffin, Heat Conduction, Cardinal, etc. (Please click here to see the checklist, this can be used for Guillaume to categorize/sort)

- Type of simulation (e.g., 3D core multiphysics (neutronics-TH) transient, 1D system steady-state)

- External Code (non-MOOSE based) used: MC2-3, Cubit, etc.

- Reactor Category(s): e.g., Liquid Metal Cooled Fast Reactor


## Computational Model Description

Walk through the main kernel/blocks, show snippets of example inputs when needed. 

The markdown source can be as simple as the following:

```language=bash
!listing msr/msre/msre_loop_1d.i block=EOS language=cpp

```

It would bring up the corresponding block in the specific input file.

!listing msr/msre/msre_loop_1d.i block=EOS language=cpp


## Results

Here one can document the most important results from the related simulations. Please refer to aforementioned examples about how to add figures and tables when discussing the main results and discoveries. 


## Run Command 

Please provide the run command for model execution on INL’s HPC Cluster or otherwise. Below is a simple example how to run a SAM system modeling job. 

```language=bash
sam-opt -i pbfhr-ss.i

```


