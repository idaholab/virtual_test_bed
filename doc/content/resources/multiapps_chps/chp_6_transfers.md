# Chapter 6: Transfer System Syntax & Examples

## Principle & Syntax

While the `MultiApp` system, discussed in [+Chapter 5+](/chp_5_multiapps.md) is in charge of establishing child applications within the parent application, the [`Transfer system`](https://mooseframework.inl.gov/syntax/Transfers/index.html) takes care of data interchange between the different applications. The Transfer system controls what type of information is transferred and how the transfer will occur. Various types of transfers are available; the user should take care to select the most appropriate type for their use case. Various types of data can be transferred between parent and child application through the `Transfer` system. This chapter discusses the main capabilities and required inputs to use the `Transfer` system.

### Target and Direction of Transfer

Every MultiApp Transfer requires a direction parameter to specify the flow of the information between MultiApp objects. This is controlled by either of the two options `from_multiapp` or `to_multiapp`, which is the name of the corresponding `MultiApp` block. Examples of the use of `from_multiapp` and `to_multiapp` will be given in the next sections. Note that transfers target MultiApp objects rather than child applications directly. For example, if the user transfers the data from the parent application to a MultiApp, depending on the type of `Transfer` being selected, the system automatically determines the data to be sent to the child applications contained by the `MultiApp` and this transfer of data to all child applications happens simultaneously. This is particularly useful for multi-scale situations like transferring temperature (from the parent application) to various micro-scale domains (child applications). This transfer will sample the temperature at each one of the positions of the child applications and give each child application its own temperature simultaneously.

### Timing of Transfer

As both parent and child applications run, the data in both applications will keep evolving. Therefore, the timing of `Transfer` is crucial for accurate coupling. Meanwhile, each data transfer consumes computational resources and thus the frequency of data transfers should be optimized. The timing of data transfer is controlled by the `execute_on` parameter that was discussed in [+Chapter 5+](/chp_5_multiapps.md). By default, the timing of the data transfer is consistent with that for the target `MultiApp`. In this case, parent-to-child transfer occurs right before the execution of the child applications to provide updated data from parent application, while child-to-parent transfer occurs right after the execution of the child application to collect the data for the parent application to proceed. The consistence in `execute_on` between the `MultiApp` and `Transfer` blocks is checked by default. Users can disable this check by setting `check_multiapp_execute_on` as `false`. The `check_multiapp_execute_on` is an optional `MultiApp` parameter.

In some special cases, the timing of the `Transfer` may need to be different than the timing of the `MultiApp` execution. One example is when the child application is restarted from a previous simulation. In this case, a child-to-parent transfer will be needed during the `INITIAL` stage to load the initial conditions from the restarted child application.

### Categories of Transfer

Transfers are mainly categorized by the type of data to be transferred: field variable, array of scalar, scalar, etc. Some discussion on how to select appropriate `Transfer` can be found in the "Selection of Transfer Methods" subsection of [+Chapter 4+](/chp_4_workflow.md). Here, the focus is mainly on the syntax.

#### Field Data -- Field Data Transfers

Field data transfers are used to transfer spatial distributions (i.e. temperature, power) in one applications to another application. The key input parameters for field data to field data transfers are `variable` and `source_variable`. The former gives the target field data container, which is usually an `AuxVariable`, whereas the latter gives the source field data, which can be either a `Variable` or an `AuxVariable`.

The most straightforward transfer algorithm is to directly copy the data on nodes/elements, which requires that the meshes on both sides of the transfer to be identical. This approach can be achieved by [`MultiAppCopyTransfer`](https://mooseframework.inl.gov/source/transfers/MultiAppCopyTransfer.html).

When the two meshes are different, the transfer can be performed using other options. Field data values may be transferred to target mesh using a nearest node approach: [`MultiAppNearestNodeTransfer`](https://mooseframework.inl.gov/source/transfers/MultiAppNearestNodeTransfer.html). If higher accuracy is needed, source data values at multiple nearest locations can be used to interpolate the target data value through [`MultiAppGeometricInterpolationTransfer`](https://mooseframework.inl.gov/source/transfers/MultiAppGeometricInterpolationTransfer.html). In [`MultiAppGeometricInterpolationTransfer`](https://mooseframework.inl.gov/source/transfers/MultiAppGeometricInterpolationTransfer.html), the interpolation algorithm can be adjusted by a number of parameters such as `num_points`, `power`, and `interp_type`. Note that is `num_points` is set as `1`, the algorithm is similar to nearest node transfer. If the integral of the transferred field data is demanded to be conserved, the transfer can be performed using $\mathcal{L}^2$ projection algorithm through [`MultiAppProjectionTransfer`](https://mooseframework.inl.gov/source/transfers/MultiAppProjectionTransfer.html).

#### Scalar Data -- Scalar Data Transfers

A scalar-to-scalar transfer is as simple as copying a single value and is relevant when a single non-spatially dependent value is needed from another application. The key is to select the correct `Transfer` class for needed source and target data type and direction.

| Transfer Type | Source Data Type | Target Data Type | Parent-Child Direction |
| - | - | - | - |
| [`MultiAppScalarToAuxScalarTransfer`](https://mooseframework.inl.gov/source/transfers/MultiAppScalarToAuxScalarTransfer.html) | Scalar Variable or AuxScalar  | AuxScalar | Both |
| [`MultiAppPostprocessorTransfer`](https://mooseframework.inl.gov/source/transfers/MultiAppPostprocessorTransfer.html) | Postprocessor | Postprocessor | Both |
| [`MultiAppPostprocessorToAuxScalarTransfer`](https://mooseframework.inl.gov/source/transfers/MultiAppPostprocessorToAuxScalarTransfer.html) | Postprocessor | AuxScalar | Both |

#### Field Data -- Scalar Data Transfers

Field data in the parent application can be sampled at the MultiApp `positions` and then transferred to the corresponding child application as a scalar data. On the other hand, scalar data values of child application at multiple `positions` can be transferred to the parent application and combined to form a field data. Similar to a scalar-to-scalar transfer, the key is to select the correct source and target data type and direction.

| Transfer Type | Parent Application Field Data Type | Child Application Scalar Data Type | Parent-Child Direction | Comments |
| - | - | - | - | - |
| [`MultiAppShapeEvaluationTransfer`](https://mooseframework.inl.gov/source/transfers/MultiAppShapeEvaluationTransfer.html) | Variable/AuxVariable | Variable/AuxVariable | Both | best for `CentroidMultiApp` |
| [`MultiAppPostprocessorInterpolationTransfer`](https://mooseframework.inl.gov/source/transfers/MultiAppPostprocessorInterpolationTransfer.html) | AuxVariable | Postprocessor | child-to-parent |  |
| [`MultiAppVariableValueSamplePostprocessorTransfer`](https://mooseframework.inl.gov/source/transfers/MultiAppVariableValueSamplePostprocessorTransfer.html) | Variable/AuxVariable | Postprocessor | parent-to-child |  |
| [`MultiAppVariableValueSampleTransfer`](https://mooseframework.inl.gov/source/transfers/MultiAppVariableValueSampleTransfer.html) | Variable/AuxVariable | AuxVariable | parent-to-child |  |

#### Array Data -- Scalar Data Transfers

This is similar to "Field Data -- Scalar Data Transfers". However, an array of data instead of a field data is involved in the parent application.

The typical array data type in MOOSE is a `VectorPostprocessor`. Thus, [`MultiAppVectorPostprocessorTransfer`](https://mooseframework.inl.gov/source/transfers/MultiAppVectorPostprocessorTransfer.html) can be used to distribute elements of a `VectorPostprocessor` array data in the parent application to single `Postprocessor`s in child applications and vice versa.

A spatial `UserObject` is another array data type. [`MultiAppUserObjectTransfer`](https://mooseframework.inl.gov/source/transfers/MultiAppUserObjectTransfer.html) can be used to distribute values in a spatial `UserObject` in the parent application to single `AuxVariable`s in child applications.

#### Array Data -- Array Data Transfers

An array-to-array transfer needs to be performed using [`MultiAppReporterTransfer`](https://mooseframework.inl.gov/source/transfers/MultiAppReporterTransfer.html). `Reporter` is a more generalized concept than `Postprocessor` and `VectorPostprocessor`.Thus, a VectorPostprocessor-to-VectorPostprocessor transfer can be made through [`MultiAppReporterTransfer`](https://mooseframework.inl.gov/source/transfers/MultiAppReporterTransfer.html) for both transfer directions. [`MultiAppCloneReporterTransfer`](https://mooseframework.inl.gov/source/transfers/MultiAppCloneReporterTransfer.html) "clones" `Reporter` from child application(s) to parent application without requiring an preexistent target "container". If multiple child applications are involved, the target `Reporter` will be an array of source `Reporter`s.

### Mesh/Position Related Parameters

Many types of data transfer are position-dependent, especially when it is desired to transfer field variables. As the original meshes in the source and receiving sides of the transfer can be subject to displacement (e.g., in tensor mechanics), users need to decide whether the displacement need to be considered or not. Based on the specific physics of the problem, if the mesh displacement needs to be considered, the user can use Boolean parameters: `displaced_source_mesh` and `displaced_target_mesh` during this position-dependent transfer.
Nevertheless, some position dependent-transfer algorithms, such as those involving nearest nodes, tends to be rather time consuming. Thus, if the physics of the problem includes no, or negligible, movement, or adaptivity, in the meshes, it will be useful in this case to set `fixed_meshes` to `true`. This will decrease the computational burden because the number of time-consuming transfer algorithms will be executed once.

### Domain of Transfer

By default, for a `Transfer` involving a field variable, the variable values in the whole mesh domain participate in the data transfer. However, in some cases, only the variable values on some specific boundaries are needed. In that case, the data transfer can be limited to such boundaries through `source_boundary` and `target_boundary` parameters to minimize the resources needed to perform such `Transfer`.

!style halign=right
[+Go to Chapter 7+](/chp_7_adv_topics.md)
