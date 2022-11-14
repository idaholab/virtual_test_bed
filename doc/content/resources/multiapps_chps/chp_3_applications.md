# 3. MOOSE-Based/Wrapped Multiphysics Nuclear Reactor Simulations

## Physics Present in Reactors

The MultiApp system, described in previous chapters of this tutorial, provides powerful functionality to facilitate the tight or loose coupling of multiple physical phenomena, which is important to reactor simulation. Nuclear reactors involve a number of physical phenomena correlated with each other. We briefly describe these physical phenomena and their interconnections, the NEAMS codes available to solve these phenomena, and finally illustrate some MultiApp hierarchies for various reactor types.

### Some Common MOOSE Applications

First of all, some common MOOSE applications are listed here, which are dedicatedly developed for different physics in nuclear reactors.

| Physics | MOOSE Application	| Features |
| - | - | - |
| Fuel Performance | [+BISON+](https://mooseframework.inl.gov/bison/index.html) | A finite element-based nuclear fuel performance code applicable to a variety of fuel forms including light water reactor fuel rods, TRISO particle fuel, and metallic rod and plate fuel. It is a multiphysics fuel analysis tool that solves fully-coupled thermomechanical problems. |
| Neutronics | [+Griffin+](https://inldigitallibrary.inl.gov/sites/sti/sti/Sort_47321.pdf) | A reactor physics application for advanced reactor multiphysics modeling and simulation. |
| Structure Analysis | [+Grizzly+](https://moose.inl.gov/grizzly/SitePages/Home.aspx) | A code for modeling degradation of nuclear power plant systems, structures, and components due to exposure to normal operating conditions. |
| Thermal Hydraulics | [+nekRS+](https://github.com/neams-th-coe/nekRS) | An open-source Navier Stokes solver based on the spectral element method targeting classical processors and hardware accelerators like GPUs. Use of +nekRS+ in the MOOSE ecosystem is through [+Cardinal+](https://github.com/neams-th-coe/cardinal), a wrapping of the spectral element code CFD NekRS and the Monte Carlo radiation transport code OpenMC as a MOOSE application. |
| Thermal Hydraulics | [+Pronghorn+](https://www.tandfonline.com/doi/full/10.1080/00295450.2020.1825307) | A multiscale thermal-hydraulic (T/H) application developed by the Idaho National Laboratory |
| System analysis | [+RELAP-7+](https://moose.inl.gov/relap7/SitePages/Home.aspx) | A next generation nuclear systems safety analysis code being developed at the Idaho National Laboratory (INL). |
| System Analysis | [+System Analysis Module (SAM)+](https://www.anl.gov/nse/system-analysis-module) | A modern system analysis tool being developed at Argonne National Laboratory for advanced non-LWR safety analysis.  It aims to provide fast-running, whole-plant transient analyses capability with improved-fidelity for SFR, LFR, and MSR/FHR. |
| Heat Pipe | [+Sockeye+](https://www.tandfonline.com/doi/full/10.1080/00295450.2020.1861879) | A heat pipe analysis application based on the MOOSE framework. |
| Chemistry | [+MOSCATO+](https://www.osti.gov/biblio/1841593) | The +MO+lten +S+alt +C+hemistry +A+nd +T+ranspOrt (MOSCATO) code is a code being developed at Argonne that focuses on simulating chemical and electrochemical reactions in molten salts. |
| Chemistry | [+Mole+](https://www.osti.gov/biblio/1649062-engineering-scale-molten-salt-corrosion-chemistry-code-development) | An engineering scale MOOSE-based molten salt species transport code developed at Oak Ridge National Laboratory. |

### Neutronics

Neutronics, or neutron transport, involves the computation of neutron distributions in space, angle, energy, and time and their interaction with materials to generate heat via fission and other processes. The release of heat and energy through fission reactions is what makes a nuclear reactor unique from other energy systems. The MOOSE-based [Griffin](https://inldigitallibrary.inl.gov/sites/sti/sti/Sort_47321.pdf) application models the necessary radiation transport and resulting power production. Neutronics is often chosen as the parent application in a Multiapp hierarchy due to its large spatial domain - every region in the domain must be considered. Neutronics also affects every other physical phenomenon within the system. For instance, the neutron flux and cross-sections determine the fission density rate in fuels and thus controls the heat source. The neutron flux also causes fuel depletion and radiation-induced materials degradation, which is usually handled by fuel performance and structural mechanical applications (i.e., [BISON](https://mooseframework.inl.gov/bison/index.html) and [Grizzly](https://moose.inl.gov/grizzly/SitePages/Home.aspx)). Neutronics itself is impacted by other physical phenomena, especially thermal distributions (temperature) and expansion due to structural responses (displacement). Neutronics is usually tightly coupled with these two physics.

### Thermal Physics

As a thermal system, a nuclear reactor contains a heat source, heat sink, and thermal media, governed by different forms of heat transfer (heat conduction, heat convection, and thermal radiation). Heat conduction is handled by MOOSE's [Heat Conduction](https://mooseframework.inl.gov/modules/heat_conduction/index.html) module. Convection in reactors is usually studied as thermal hydraulics, which can be simulated by a dedicated [physics module](https://mooseframework.inl.gov/modules/thermal_hydraulics/index.html) of MOOSE with advanced features available in the [SAM](https://www.anl.gov/nse/system-analysis-module), [Pronghorn](https://www.tandfonline.com/doi/full/10.1080/00295450.2020.1825307) and [RELAP-7](https://moose.inl.gov/relap7/SitePages/Home.aspx) applications.

#### Heat Source (Fuel)

Neutron flux causes fission reactions within the nuclear fuel and contributes to the majority of the heat generation within the reactor. Therefore, fuels are also the main heat source in the thermal physics of a reactor. In addition, a variety of microstructural modifications occur in fuels during operation, which eventually lead to degradation of fuel properties and fuel depletion. These aspects are usually handled by a fuel performance code. [BISON](https://mooseframework.inl.gov/bison/index.html) is the advanced fuel performance code in the MOOSE ecosystem.

#### Heat Sink

The heat generated in the fuel must be removed from the reactor core by a heat transfer mechanism. The heat can be removed by coolant channels (with water, liquid sodium, molten salt, helium etc. as the working fluid) or through heat transfer components such as heat pipes. These are effectively the heat sink of the reactor as a thermal system. The performance of the heat sink region may be simulated by SAM, Pronghorn, [RELAP-7](https://moose.inl.gov/relap7/SitePages/Home.aspx), or [NekRS](https://github.com/neams-th-coe/nekRS) (via [Cardinal](https://github.com/neams-th-coe/cardinal)) for the coolant channel approach, or by [Sockeye](https://www.tandfonline.com/doi/full/10.1080/00295450.2020.1861879) or [SAM](https://www.anl.gov/nse/system-analysis-module) for the heat pipe approach.

#### Other Thermal Media

Components such as moderator, reflector or structures are neither major heat source nor heat sink. The [Heat Conduction](https://mooseframework.inl.gov/modules/heat_conduction/index.html) module may account for their thermal behavior, and the [Tensor Mechanics](https://mooseframework.inl.gov/modules/tensor_mechanics/index.html) module may be used to simulate the thermal expansion effect in these regions. In some cases, their radiation degradation also needs to be simulated, which depends on both temperature (thermal physics) and neutron fluence (neutronics).

### Structural Mechanics

Thermal expansion alters the density, size, and even shape of materials and thus affects neutronics. Different materials respond differently to elevated temperature. Within a homogeneous material, the thermal expansion may be non-uniform due to temperature gradients. Non-uniform expansion leads to thermal stress for solid-state materials. This thermomechanical behavior, as the name implies, needs to be handled by coupling thermal physics and solid mechanics, which is simulated by MOOSE's [Tensor Mechanics](https://mooseframework.inl.gov/modules/tensor_mechanics/index.html) module.

Mechanical behavior is extremely important for reactor structure components (e.g., pressure boundaries, supporting structures, etc.). At high temperatures under irradiation, materials deform through a number of different mechanisms, including elasticity, plasticity (irradiation creep), and irradiation swelling. The stress-strain relations of all these mechanisms are governed by the [Tensor Mechanics](https://mooseframework.inl.gov/modules/tensor_mechanics/index.html) module.

### Chemistry

Chemistry may also have crucial impact on reactor performance. Within the solid components of the reactor, chemistry controls species diffusion as well as secondary phases precipitation and interaction phase formation. At liquid-solid interfaces, chemistry governs erosion and corrosion of the solid components and subsequent performance degradation. Within liquid components, especially molten salts, chemistry determines species concentration and thus plays an important role in neutronics. General chemistry phenomena can be handled by MOOSE modules such as [Chemical Reactions](https://mooseframework.inl.gov/modules/chemical_reactions/index.html) and [Phase Field](https://mooseframework.inl.gov/modules/phase_field/index.html). Users seeking more advanced functionality may choose to leverage a specialized thermochemistry application.

### A Typical Reactor Model Powered by MultiApps

The MOOSE MultiApp system provides the flexibility to couple physics at different time and space scales into an efficient multiphysics simulation leveraging pre-existing MOOSE-based applications. Some clear benefits of using MultiApps for coupling follow:

- The MultiApp approach is more efficient than full coupling when some physical phenomena are restricted to only a few reactor components. (e.g. Fuel swelling and fission gas behavior are limited to the fuel regions, whereas neutronics is global.)
- The MultiApp approach can couple problems in different space dimensions by using the appropriate data transfers. (e.g. Fuel performance of a fuel pin may be simulated using an RZ-axisymmetric mesh, while coolant channels and heat pipes may be simplified as one-dimensional problem.)
- The user may specify and control how often each application solves and transfers data during a MultiApp solve, and minimal modifications are needed to plug a single physics application input into a MultiApp hierarchy.
- The individual applications can solve on their own space/time scale and with optimal preconditioners and solver settings.

!media media/resources/typical_reactor_multiapps.png
       style=display: block;margin-left:auto;margin-right:auto;width:80%;
       id=typical_multiapps
       caption=A typical hierarchy of MultiApps for nuclear reactor simulation.

[typical_multiapps] illustrates a typical multiphysics approach for reactor modeling. The application with largest spatial domain and longest timesteps, e.g. neutronics (Griffin), is typically selected as the parent application. Griffin typically provides the power distribution ($\mathbb{P}$) to a child application that solves thermal physics and provides the temperature distribution ($\mathbb{T}$) and sometimes thermal expansion as feedback ($e$). For solid-fueled reactors, the thermal physics is typically handled by MOOSE's heat conduction module (or MOOSE apps equipped by it). For liquid-fueled reactors, the thermal physics is usually handled by MOOSE's Navier Stokes module or specific apps such as Pronghorn and NekRS. While the thermal expansion of liquid can be solved by NS equations, thermal expansion of the solid needs to be handled by MOOSE's Tensor Mechanics module. Thermal physics and thermal stress induced by thermal expansion are closely interconnected in solids (known as thermomechanics) and can usually be fully coupled without using MultiApps. It is also feasible to set up tensor mechanics as a grandchild app, which receives temperature from the thermal child application and gives displacement as feedback.

Localized physics such as performance of coolant channels, heat pipes, and fuel can also be handled by grandchild applications. These local applications receive temperature and neutronics information from parent and child applications and perform their specific computation in their specific domain. In some cases, the local physics results are important to reactor thermal and neutronics, such as fuel volumetric swelling strain and coolant temperature, which will need to be transferred back to the parent and child applications for Picard iteration. In other cases, the local physics results do not affect reactor thermal and neutronics physics, such as fuel-cladding interaction, and can be loosely coupled without iteration.

### MultiApp Reactor Examples on VTB

The examples available on the Virtual Test Bed site adopt a number of different coupling approaches based on the specific reactor type and phenomena of focused interest. We briefly summarize a fraction of these VTB examples to show readers the flexibility in using MultiApps (see [vtb_examples]).

!media media/resources/vtb_examples.png
      style=display: block;margin-left:auto;margin-right:auto;width:100%;
      id=vtb_examples
      caption=Hierarchies of MultiApps for VTB examples.

#### VTB-MSFR

The [+Molten Salt Fast Reactor (MSFR) core multiphysics simulation model+](msfr/griffin_pgh_model.md) adopts a two-level MultiApps structure with Griffin as the parent app and Pronghorn as the child app. The parent app governs neutronics simulation, providing power distribution and fission source to the child app. The child app handles fluid dynamics simulation of molten salt fuels, providing temperature information as feedback to the parent app. Molten Salt Reactors are a special class of reactors as the molten salt is both fuel and coolant. As the molten salt flows out of the core region to transfer heat, the delayed neutron precursors concentrations are also calculated and transferred back to Griffin.

#### VTB-HTGR

A [+Pebble-Bed Microreactor core multiphysics model+](pbmr/model_description.md) is available on the VTB using a three-level MultiApps structure. Griffin is the parent application governing neutronics simulations, while Pronghorn solves a homogenized porous media flow problem. A CentroidMultiApp is then used to calculate the representative temperature profile within pebbles and TRISOs. This is an example of using MultiApps to handle similar physical phenomena (thermal heat transfer here) at different space scales.

#### VTB-HP-MR

The [+Heat-Pipe Microreactor (HP-MR) core multiphysics model+](mrad/index.md) uses a two-level MultiApps approach with a BISON parent application to govern the thermal physics within all the solid reactor components except for heat pipes, and a Sockeye child app to deal with heat pipe performance. A placeholder is added for future adoption of Griffin as parent app for neutronics simulation. When Griffin is integrated as parent, BISON and Sockeye will become child and grandchild applications, respectively.

#### VTB-PBFHR

The [+Pebble Bed Fluoride-Salt-Cooled High-Temperature Reactor (PB-FHR) Griffin-Pronghorn steady state model+](pbfhr/steady/griffin_pgh_model.md) uses an approach similar to the HTGR example. Unlike the MSFR model in VTB where fuel is dissolved in the salt, the fuel of PBFHR has a solid form. Therefore delayed neutron information no longer needs to be handled by fluid dynamics application. However, the thermal physics inside the fuel pebbles need to be simulated by an additional grandchild Heat Conduction application.

#### VTB-SFR

The [+Sodium-cooled Fast Reactor (SFR) single assembly example+](sfr/single_assembly/sfr.md) presently has the most complex MultiApp hierarchy. As explained earlier, neutronics (Griffin) is naturally the parent application. The radial thermal expansion is simulated by a child application using the Tensor Mechanics module on the support plate with a preset inlet coolant temperature. The axial expansion as well as the axial temperature profile is simulated by a BISON child application to capture fuel behavior. The fuel temperature boundary condition is calculated by a grandchild application using SAM's coolant channel models. A special approach used in this example is that the axial expansion of the fuel is simulated by another grandchild BISON (i.e. two BISON simulations/MultiApps are involved) application instead of fully coupled with fuel thermal physics.

## Other Applications

The VTB examples generally employ MultiApps to couple different physical phenomena within a nuclear reactor system. Aside from multiphysics coupling, the MultiApps system can also be used in other scenarios.

### Multi-Spacescale

The [+HTGR Pebble-Bed Microreactor core multiphysics model example+](pbmr/model_description.md) uses MultiApps for non-multiphysics coupling. As mentioned early in this chapter, MultiApps are used in this example to connect a similar physical phenomenon (i.e., heat conduction) at two different space scales. In the HTGR example, the macroscopic reactor components involved in neutronics and thermal hydraulics simulations such as fuel and coolant are meter level, while single TRISO particles with fuel pebble are only millimeter level. Due to the complex multilayered structure of a TRISO particle, the particle needs to be separately simulated to capture its internal maximum temperatures. It is impractical to fully couple them as that would require an ultra fine mesh to capture thousands of TRISO particles. Instead, using a CentroidMultiApp, a virtual representative TRISO particle is simulated for each macroscopic fuel mesh element, providing representative local maximum fuel temperature information. This example shows the advantage of using MultiApps to study similar (or dissimilar) physical phenomena happening at very different space scale. Using similar approaches, it is possible to connect engineering scale simulations with mesoscale or even microscale physics.

### Multi-Timescale and Dissimilar Timings

The MultiApps system can also be used to simulate phenomena with different time scales. Some correlated physics may have very different characteristic times. For example, during steady state depletion of nuclear fuels, thermo-mechanical phenomena are usually stable and do not change significantly over hours (or even days). However, diffusion of fission products and evolution of radiation-induced defects may evolve much more rapidly. In that case, the slow physical phenomena can be solved in the parent application with large time steps, while the rapid phenomena may be solved in the child application with small time steps.

Reactor physics often requires multiple timescales as well - such as the predictor-corrector quasi-static method use to reduce computational cost. In this method, the neutron shape is first predicted from the transient fixed source multi-dimensional neutronic solution for a relatively large time interval, which is referred to as a macro time step. The predicted shape function is used to obtain the point kinetic (PK) parameters for the macro step. Then, the PK equation is solved with a smaller time step, so-called micro time step, to correct the amplitude of the neutron flux. Finally, the variation of reactor power in thermal reactors leads to spontaneous effects on the thermal reactivity feedback which requires coupling with relatively small time-step. However, because the variation of Xe concentration with power is relatively slow (little Xe-135 results directly from fission and most comes from the decay of I-135), relatively large time-steps can be used to update the Xe concentration.

MultiApps may also be used to handle dissimilar timings. For example, the parent app simulates some physical phenomena throughout an entire reactor cycle, while some other physical phenomena are simulated at specific instances of interest in the child app. For example, during a neutronics-dominated simulation focused on fuel depletion effects, safety studies using detailed thermomechanics simulations can be executed at some specific burnup points instead of at every time step.

### Statistics

The MOOSE [Stochastic Tools](https://mooseframework.inl.gov/modules/stochastic_tools/index.html) may be included as the parent application in MultiApp hierarchy to drive statistical analysis. In this case, the parent app samples some key parameters of the child application and spawns several simulations with these sampled parameters.

!style halign=right
[+Go to Chapter 4+](/chp_4_workflow.md)
