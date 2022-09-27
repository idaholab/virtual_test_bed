# Model Name

Contact: Model Developer, model_developer.at.institute.com (contact email) 

## High Level Summary of Model

High level introduction is expected here about the model of interest. Figures and tables can be added 
in the model description, of which the examples are provided below. 


!devel! example id=example-figure caption=Example of adding a figure in VTB documentation.
!media msr/msre/SAM_MSRE_1D.png
       style=width:40%
       id=msre_sam
       caption=The steady-state temperature distribution in the 1-D MSRE primary loop.
!devel-end!

!alert note
One should put a copy of the figure at the specific file path.
The VTB media is now arranged by reactor types under the folder +/media+. 
For more detailed instructions on figure formatting, please refer to
the [MooseDocs media tutorial](https://mooseframework.inl.gov/python/MooseDocs/extensions/media.html). 


!devel! example id=example-table caption=Example of adding a table in VTB documentation.
!table id=fuel_salt_properties caption=Thermophysical properties of the fuel salt.
|   |   | Unit  | LiF-BeF$_4$-ZrF$_4$-UF$_4$  |
| :- | :- | :- | :- |
| Melting temperature | $T_{melt}$ | $K$ | $722.15$  |
| Density | $\rho$ | $kg/m^3$  | $2553.3-0.562\bullet T$ |
| Dynamic viscosity | $\mu$ | $Pa\bullet s$ | $8.4\times 10^{-5} exp(4340/T)$ |
| Thermal conductivity | $k$ | $W/(m\bullet K)$ | $1.0$ |
| Specific heat capacity | $c_p$ | $J/(kg\bullet K)$ | $2009.66$ |
!devel-end!

!alert note
For more detailed instructions on table formatting, please refer to
the [MooseDocs table tutorial](https://mooseframework.inl.gov/python/MooseDocs/extensions/table.html). 

!devel! example id=example-equations caption=Example of adding equations in VTB documentation.
NekRS solves the incompressible Navier-Stokes equations:

\begin{equation}
\label{eq:mass}
\nabla\cdot\mathbf u=0
\end{equation}

\begin{equation}
\label{eq:momentum}
\rho_f\left(\frac{\partial\mathbf u}{\partial t}+\mathbf u\cdot\nabla\mathbf u\right)=-\nabla P+\nabla\cdot\tau+\rho\ \mathbf f
\end{equation}

\begin{equation}
\label{eq:energy}
\rho_f C_{p,f}\left(\frac{\partial T_f}{\partial t}+\mathbf u\cdot\nabla T_f\right)=\nabla\cdot\left(k_f\nabla T_f\right)+\dot{q}_f
\end{equation}
!devel-end!

!alert note
For more detailed instructions on equation formatting, please refer to
the [MooseDocs equation tutorial](https://mooseframework.inl.gov/python/MooseDocs/extensions/katex.html).


### Adding references style=font-size:125%

If the model has been previously published, one should provide the reference to the published works together with key references used for model development. 
+MooseDocs+ supports BibTex style references, and some examples about how to cite technical report, conference proceeding and journal article are given below.  

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


The bibtex entries must be added into the VTB bibliography file +vtb.bib+. 
A reference list will be generated automatically at the end of the VTB documentation page.


!devel! example id=example-refs caption=Example of inserting citations in VTB documentation.
Description part A [!citep](Hu2017), description part B [!citep](novak_2021c), description part C [!citep](Fang2021)
!devel-end!


### Other key model details to provide in the high-level summary style=font-size:125%

- Reactor Type(s): e.g., Liquid Metal Cooled Fast Reactor

- Type of simulation: e.g., 3D core multiphysics (neutronics-TH) transient, 1D system steady-state

- NEAMS MOOSE Codes Used: Griffin, Heat Conduction, Cardinal, etc. 

- NEAMS non-MOOSE Codes Used: MC2-3, Nek5000/RS, etc. 

- Non-NEAMS Codes Used: Cubit, OpenFOAM, etc.


!alert note
More information is available online about [the list of NEAMS codes](https://neams.inl.gov/code-descriptions/) and the codes that have been used for [the models available in VTB repository](https://mooseframework.inl.gov/virtual_test_bed/resources/codes_used.html). 
Providing the related information in documentation can better help the VTB team to categorize/sort the model.

## Computational Model Description

Walk through the main kernel/blocks, show snippets of example inputs when needed. 
The markdown source can be as simple as the following to show the `EOS` block from the `msre_loop.i` input file:

!devel! example id=example-list caption=Example of including input block in VTB documentation.
!listing msr/msre/msre_loop_1d.i block=EOS language=cpp
!devel-end!


## Results

Here one can document the most important results from the related simulations. Please refer to aforementioned examples about how to add figures and tables when discussing the main results and discoveries. 


## Run Command 

Please provide the run command for model execution on INL’s HPC Cluster or otherwise. Below is a simple example how to run a SAM system modeling job. 

```language=bash
mpirun -np 48 /path/to/sam-opt -i sam_input.i

```


