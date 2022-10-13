# 4. Workflow to Establish a MultiApps Simulation

## From Physics to Models

### Identification of Physical Phenomena and Their Domains

The first step when designing a MultiApps based simulation is to identify the physical phenomena that need to be modeled, and their spatial and time domains.

For a reactor system, neutronics is expected to be the essential (and usually dominant) physics. Heat conduction and thermal hydraulics are important in solid and fluid reactor components, respectively. The performance of specific reactor components, such as fuel, heat pipes, and coolant channels, may involve unique physical behaviors that need to be simulated separately. Meanwhile, diffusion controlled chemical reactions can exist in different regions of reactors.

Once all the physical phenomena of interest as well as the corresponding variables (i.e., physical quantities) and PDEs are identified, the corresponding space and time domains of these physical phenomena also need to be identified. The domain information is important to the determination of MultiApps hierarchy.

!media media/resources/step_1_SFR.png
      style=display: block;margin-left:auto;margin-right:auto;width:60%;
      id=wf_step_1
      caption=Identify all the physical phenomena to be simulated and their domains.

We take the VTB [Sodium Fast Reactor (SFR)](/sfr.md) case as an example. It is focused on reactor assembly analysis of SFR considering thermal expansion. The physical phenomena that need to be modeled are illustrated in [wf_step_1] along with their space domains. Neutronics needs to be simulated for the entire assembly. Detailed thermal physics is required in the fuel region, including computation of fuel temperatures and axial fuel expansion governed by tensor mechanics (reactivity is sensitive to these quantities). Thermal hydraulics of the assembly coolant is needed to support the fuel temperature simulation. Lastly, the radial expansion of the assembly structure also needs to be computed, which is mainly controlled by the thermal expansion of the supporting grid plate of the assembly.

### Selection of MOOSE Apps

Once the important physics has been identified, appropriate MOOSE-based (or MOOSE-wrapped) applications need to be selected to solve them. [Chapter 3](/chp_3_applications.md) discusses different MOOSE applications and their respective focuses in detail. The MOOSE Framework is equipped with a number of commonly used physics-dedicated applications termed [`Physics Modules`](https://mooseframework.inl.gov/modules/index.html). Many common physical phenomena, such as heat conduction and tensor mechanics, can be handled by these openly available MOOSE modules. However, to solve those physical phenomena that involve more complex physics phenomena or require advanced properties/models, a dedicated MOOSE application may need to be adopted. Some common MOOSE applications can be found [here](https://mooseframework.inl.gov/application_usage/tracked_apps.html).

To make these physical modules and applications work together in a MultiApps system, users can either dynamically load the libraries of the child applications in the parent application, or directly use a pre-compiled super application such as BlueCRAB and Direwolf. Licensing for coupled applications (BlueCRAB and Direwolf) can be obtained through INL's [NCRC](https://inl.gov/ncrc/).

!media media/resources/step_2_SFR.png
      style=display: block;margin-left:auto;margin-right:auto;width:60%;
      id=wf_step_2
      caption=Identify all the MOOSE applications/modules that are needed.

Continuing with the VTB SFR case as an example, as shown in [wf_step_2], the neutronics can be handled by Griffin; the thermal and tensor mechanics of the fuel region can be simulated using BISON; the thermal expansion of the supporting plate can be simulated using the MOOSE Tensor Mechanics module; and the coolant channel's thermal hydraulics can be simulated using the heat structure models in SAM.

### Interconnection between Physical Phenomena

With the physics and corresponding MOOSE applications identified, the next step is to figure out the data that need to be exchanged between the different physics (i.e., corresponding to each MOOSE application). This is the key step to connecting multiple single physics problems into a single multiphysics problem. With these data exchanges, which happen through the MOOSE transfer system, the physical phenomena are eventually +"coupled"+.

!media media/resources/step_3_SFR.png
      style=display: block;margin-left:auto;margin-right:auto;width:60%;
      id=wf_step_3
      caption=Identify the data exchanges needed to achieve coupling.

We consider the dependencies among the physics in the VTB SFR case, as shown in [wf_step_3]. Generally, neutronics will need temperature (particularly in fuel and coolant regions) and displacement information from other apps to account for reactivity feedback. The thermal physics of the fuel needs power density (heat source) from neutronics and it calculates the temperature distribution. This is important not only to account for the thermal reactivity feedback on the neutronic solution, but also to be used by a tensor mechanics app for thermal expansion and thermal stress calculations. Finally, the fuel region needs to exchange thermal information with coolant region to simulate the heat sink effects.

## Determine MultiApps Hierarchy

The required MOOSE apps (solving for physical phenomena) are interconnected by the data that needs to be exchanged. The MultiApps hierarchy needs to be established to finalize the design of the MultiApps system. There are generally many options for working hierarchies (i.e. not unique), but some hierarchies may provide better computational efficiency. One major limitation that could restrict the design of the MultiApps hierarchy is the allowed inter-application data exchange pathways in MOOSE. In 2022, MOOSE [`Transfers`](https://mooseframework.inl.gov/syntax/Transfers/index.html) system has been updated to support sibling-sibling data exchange in addition to the originally-supported parent-child data exchange, significantly increasing the flexibility in hierarchy design. However, grandparent-grandchild data exchange is not yet supported.

!media media/resources/step_4_SFR.png
      style=display: block;margin-left:auto;margin-right:auto;width:60%;
      id=wf_step_4
      caption=Determine the MultiApps hierarchy.

In the SFR example (see [wf_step_4]), Griffin is selected as the parent app because neutronics is the most global physical phenomenon. Griffin provides the power profile to the other applications and requires temperature and thermal expansion information from them. Therefore, the fuel thermal physics is set as a child application to calculate the fuel temperature. In this case, the fuel thermal expansion is handled by a grandchild app that obtains the temperature information from the child application. Displacement information is transferred through the child application to the parent application. For simplicity, a single fuel pin is simulated in this SFR example to model the axial thermal expansion of the fuel. In addition, a separate child application is dedicated to calculating the radial thermal expansion based on a support plate near the coolant inlet position. Moreover, the fuel thermal physics application needs thermal hydraulics calculations, for obtaining the heat sink information, which is set as another grandchild app.



## Single App Establishment and Standalone Testing

With the MultiApps hierarchy design in hand, users can start playing with the actual input files and application executables. First, input files for the separate MOOSE applications should be established. These input files need to be independent so that standalone testing can be performed. To achieve that, the outward data transfers can be directly disabled, while the inward data transfer can be replaced by constants or preset values. The following MOOSE classes may be useful to set such constants/presets:

- [`ConstantAux`](https://mooseframework.inl.gov/bison/source/auxkernels/ConstantAux.html)
- [`ConstantScalarAux`](https://mooseframework.inl.gov/bison/source/auxkernels/ConstantScalarAux.html)
- [`Receiver`](https://mooseframework.inl.gov/bison/source/postprocessors/Receiver.html)
- [`ConstantVectorPostprocessor`](https://mooseframework.inl.gov/bison/source/vectorpostprocessors/ConstantVectorPostprocessor.html)

Thus, these single application input files can be tested and debugged independently before being assembled into a complex problem. As shown in [wf_step_5], all the five standalone apps involved in the SFR example are tested independently.

!media media/resources/step_5_SFR.png
      style=display: block;margin-left:auto;margin-right:auto;width:100%;
      id=wf_step_5
      caption=Standalone app testing.

## Single App Testing with Dummy Parent or Child

In the previous step, single app's functionalities have been generally tested except for the `MultiApps` and `Transfers` blocks. To test these two blocks without involving other apps' input files, dummy parent or/and child app input files are made to only include a non-solving problem and constant data. A non-solving problem is a MOOSE based simulation without solving any PDEs, which can be set up by inserting the following block into the input file:

!listing
[Problem]
  solve = false
[]

With this set up, the MOOSE input file no longer needs `Variables` and `Kernels` blocks; and constants can just be set as `AuxVariables`, `Postprocessors`, ets. Thus, a single app testing with dummy parent or/and child apps can be performed. In order to efficiently and accurately transfer data between apps within the established MultiApps hierarchy, in this step, the `Transfers` methods need to be selected wisely. In fact, selection of appropriate `Transfer` methods are crucial for the correctness, accuracy, and efficiency of the simulations coupled through the MultiApps system. Therefore, special attention is paid to discuss this subtopic in the following subsection.

### Selection of Transfer Methods

A great variety of [`Transfers`](https://mooseframework.inl.gov/syntax/Transfers/index.html) methods are available to users in MOOSE; even more options are available through other MOOSE apps. Different `Transfers` methods are designed to match different data transfer needs. There are generally three categories of data involved in MOOSE simulations: scalar data, array (vector) of scalars data, and field data. Transfers are covered in additional detail in Chapter 6 of this tutorial.

Scalar data in MOOSE mainly include Scalar variables and Postprocessors. The scalar-to-scalar transfer is usually straightforward. Depending on the scalar data types on both sides of the transfer, [`MultiAppScalarToAuxScalarTransfer`](https://mooseframework.inl.gov/source/transfers/MultiAppScalarToAuxScalarTransfer.html), [`MultiAppPostprocessorTransfer`](https://mooseframework.inl.gov/source/transfers/MultiAppPostprocessorTransfer.html), [`MultiAppPostprocessorToAuxScalarTransfer`](https://mooseframework.inl.gov/source/transfers/MultiAppPostprocessorToAuxScalarTransfer.html), etc.

Array (vector) of scalars data are mainly VectorPostprocessors in MOOSE. [`MultiAppVectorPostprocessorTransfer`](https://mooseframework.inl.gov/source/transfers/MultiAppVectorPostprocessorTransfer.html) transfers values from parent app VectorPostprocessors to child application Postprocessors or vice versa.

MOOSE's [`Reporter`](https://mooseframework.inl.gov/syntax/Reporters/index.html) system allows more general types of single values (`VectorPostprocessors` and `Postprocessors` are just two special types of `Reporter`). `Reporter` values can be transferred between parent and child apps using [`MultiAppReporterTransfer`](https://mooseframework.inl.gov/source/transfers/MultiAppReporterTransfer.html). Note that VectorPostprocessor-to-VectorPostprocessor transfer can be achieved using `MultiAppReporterTransfer`, instead of `MultiAppVectorPostprocessorTransfer`.

More challenging and complex are the transfer of field data. Field data in MOOSE are usually `Variables` or `AuxVariables` (sometimes also `UserObjects`). The most straightforward case would be that the parent and child apps use the same mesh. In that case, both nodal and elemental field data can be directly transferred using [`MultiAppCopyTransfer`](https://mooseframework.inl.gov/source/transfers/MultiAppCopyTransfer.html). More generally, the meshes used by parent and child apps are different. In some cases, using the field data value of the nearest node is enough, which can be achieved by [`MultiAppNearestNodeTransfer`](https://mooseframework.inl.gov/source/transfers/MultiAppNearestNodeTransfer.html). Alternatively, interpolation based on multiple nearest nodes is used during the transfer using [`MultiAppGeometricInterpolationTransfer`](https://mooseframework.inl.gov/source/transfers/MultiAppGeometricInterpolationTransfer.html). Moreover, in some cases, the conservation of the integrated field data value is required, where [`MultiAppProjectionTransfer`](https://mooseframework.inl.gov/source/transfers/MultiAppProjectionTransfer.html) should be adopted leveraging $\mathcal{L}^2$ projection and an on-the-fly calculated adjusting factor.

If child applications are established at multiple positions, field data of the parent app may need to be sampled and transferred to each child application (usually as scalar data), or vice versa. Based on the different type of field data and different algorithm, [`MultiAppShapeEvaluationTransfer`](https://mooseframework.inl.gov/source/transfers/MultiAppShapeEvaluationTransfer.html)(+both directions+), [`MultiAppPostprocessorInterpolationTransfer`](https://mooseframework.inl.gov/source/transfers/MultiAppPostprocessorInterpolationTransfer.html)(+from child application only+), [`MultiAppUserObjectTransfer`](https://mooseframework.inl.gov/source/transfers/MultiAppUserObjectTransfer.html)(+to child application only+), [`MultiAppVariableValueSamplePostprocessorTransfer`](https://mooseframework.inl.gov/source/transfers/MultiAppVariableValueSamplePostprocessorTransfer.html)(+to child application only+), and [`MultiAppVariableValueSampleTransfer`](https://mooseframework.inl.gov/source/transfers/MultiAppVariableValueSampleTransfer.html)(+to child application only+).

For the SFR single assembly example, [wf_step_6] visualizes how the five apps involved are tested.

The field variable `power_density` calculated by Griffin is transferred to Bison thermal physics simulation using `MultiAppProjectionTransfer` as this transfer conserves the integrated power, leveraging $L^2$ projection to minimize difference between the integrated power and an adjusting factor based on the given postprocessor (i.e., `from_postprocessors_to_be_preserved` and `to_postprocessors_to_be_preserved`) to .

For the temperature variable from heat conduction and thermal hydraulics applications, as well as the displacement variables from tensor mechanics application, `MultiAppGeometricInterpolationTransfer` is used to ensure proper values can be obtained when meshes are different. Because the thermal physics application and the tensor mechanics applications use an identical mesh, field variables such as temperature and displacements are transferred by `MultiAppCopyTransfer`.

The data transfer between the thermal physics application (BISON) and the thermal hydraulics (SAM) application is special. Although both applications use 2D-RZ axisymmetric meshes, the applications are oriented in different coordinate systems. In BISON, the convention is that the R mesh exists in the XZ plane, while in SAM, the convention is that R mesh exists in the XY plane. `MultiAppCoordSwitchNearestNodeTransfer` (a SAM object) performs transfers with coordinate system conversion along with the nearest node transfer. Native support is also present in MOOSE for most coordinate-transformations during transfers.

Since `Transfers` can be time and resource consuming, optimization in `Transfers` methods can make the simulation more efficient. For example, the transferred data can be limited to some essential blocks instead of the entire mesh to reduce data volume, or the position-sensitive transfer such as nearest point transfers can use a recorded map instead of doing search every time if the source and destination meshes do not move or deform significantly.

!media media/resources/step_6_SFR.png
      style=display: block;margin-left:auto;margin-right:auto;width:100%;
      id=wf_step_6
      caption=MultiApps testing with dummy apps.

If things are all set correctly, the output with dummy parent/child apps should be the same as the standalone testing. Once the single applications are verified to work properly with dummy parent and child apps, these single apps are ready to be assembled together.

## Assembling the Complete MultiApps Hierarchy

Here, the dummy apps used in the last step are replaced by the real apps so that the hierarchy established before can be achieved. For example, the standalone apps in the SFR example can eventually be assembled as shown in [wf_step_4].

## Debugging Tips

Even after the successful assembly of the MultiApps hierarchy, due to the complexity of the coupled physics, it is still possible for problems to occur in the middle of the MultiApps simulation. The [Restart and Recover](https://mooseframework.inl.gov/application_usage/restart_recover.html) methods available in MOOSE apps are helpful during debugging. Users can adjust and monitor some key parameters or variables near the failure point and restart the simulation, which could facilitate the debugging processes.

!style halign=right
[+Go to Chapter 5+](/chp_5_multiapps.md)
