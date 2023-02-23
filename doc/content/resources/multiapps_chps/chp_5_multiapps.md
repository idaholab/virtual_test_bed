# Chapter 5: MultiApp Input Syntax & Examples

## Principle & Syntax

The role of the [`MultiApps`](https://mooseframework.inl.gov/syntax/MultiApps/index.html) block in MOOSE is to allow the users to create vessels to contain any number of child applications.  Important input parameters for the MultiApp block include `app_type`, which describes the child application to be invoked, and `type`, which describes the time/space-based execution of the child application. Various MultiApp `type`s are available to facilitate different possible solution schemes of multi-physics problems. The `input_files` parameter is required for all `type`s and it points to the child application input file. The remaining parameters in the MultiApp block will depend on the `type`. In the following sections, the `app_type`, `type`, and common parameters will be discussed.

### Type of Child Application

The `app_type` parameter is the type of the child application to be executed. Child applications are [`MooseApp`](https://mooseframework.inl.gov/source/base/MooseApp.html) derived app or simply a physics module. Examples of `app_type` includes PronghornApp, GriffinApp, BisonApp, (MOOSE applications) as well as ReactorApp or TensorMechanicsApp (MOOSE physics modules). By default, the parent application is assumed to be capable of running the child applications so that no extra libraries need to be loaded. The user can alternatively provide a different application type for the child applications. In that case, the MOOSE application that runs the parent application will dynamically load the libraries that correspond to the specified `app_type` to run the child applications.

### Type of MultiApp

The `type` parameter describes the time/space-based execution of the child application. Various MultiApp `type`s are available to facilitate different possible solution schemes of multi-physics problems. Available `type`s include: [`FullSolveMultiApp`](https://mooseframework.inl.gov/source/multiapps/FullSolveMultiApp.html), [`TransientMultiApp`](https://mooseframework.inl.gov/source/multiapps/TransientMultiApp.html), [`CentroidMultiApp`](https://mooseframework.inl.gov/source/multiapps/CentroidMultiApp.html), and several app types specific to the [`Stochastic Tools`](https://mooseframework.inl.gov/modules/stochastic_tools/index.html) module (used for uncertainty quantification, parametric studies, meta-modeling and others).

#### FullSolveMultiApp

The [`FullSolveMultiApp`](https://mooseframework.inl.gov/source/multiapps/FullSolveMultiApp.html) object performs a complete child application simulation during each execution which means that the child applications will be solved from the first-time step to the last time step every time it is called. This is typically done for steady state or eigenvalue parent-app simulations or for initialization purposes.

!media media/resources/fullsolve.png
      style=display: block;margin-left:auto;margin-right:auto;width:40%;
      id= FullSolveMultiApp
      caption=Example of FullSolveMultiApp.

 [FullSolveMultiApp] shows an example of a FullSolveMultiApp where Griffin is the main application and SAM is the child application that will be solved throughout the entire time domain every time it is called. FullSolveMultiApp is generally used when we only need the end-time solution of the child application. In this example, the end-time SAM solution is used for the multiphysics coupling with a Griffin eigenvalue calculation.

#### TransientMultiApp

In the [`TransientMultiApp`](https://mooseframework.inl.gov/source/multiapps/TransientMultiApp.html) the child application will be solved at a single timestep, following the same timestep as the parent application.  The child applications must use a transient `Executioner`. TransientMultiApp is used for performing coupled simulations with the parent and child application when both physics are marching in time together.

!media media/resources/transientmultiapp.png
      style=display: block;margin-left:auto;margin-right:auto;width:37%;
      id= Transientmultiapp
      caption=Example of Transientmultiapp.

 [Transientmultiapp] shows an example of a `TransientMultiApp` where the main application (Griffin) and the child application (SAM) progress together in time.
 `TransientMultiApp` is simultaneously advancing the time-steps of the main and child applications by default. This means that no coupling fixed point iterations are done at any time-step. This approach is commonly referred to as loose coupling.

 If a tight coupling approach is desired,  Picard [`fixed point iterations`](https://mooseframework.inl.gov/syntax/Executioner/FixedPointAlgorithms/index.html) may be used by specifying appropriate `Executioner` parameters for the parent application. Picard iterations are nonlinear iterations for tight coupling which repeat the simulation at the same time-step until a convergence criterion is satisfied.  Picard iterations are particularly important if the physics solved in the different apps have very strong nonlinear effects.  

The following two examples describe the use of the `TransientMultiApp`. The definitions of execute_on and positions will be given in the optional parameters.

!listing
[MultiApps]
  [dynamic_executable]
    type = TransientMultiApp
    execute_on = 'TIMESTEP_END'
    input_files = 'pebble.i'
  []
[]

!listing
[MultiApps]
 [sub]
    type = TransientMultiApp
    app_type = BisonApp
    input_files = 'Bison_input.i'
    positions = '0   0   0
                 0.5 0.5 0
                 0.9 0.9 0'
  []
[]

The minimum time step over the main and all child applications will be used, by default, unless `sub_cycling` is enabled. If sub_cycling is enabled this will allow faster calculations, as the parent app will not be forced to use the smaller time step from the child app.

#### CentroidMultiApp

[`CentroidMultiApp`](https://mooseframework.inl.gov/source/multiapps/CentroidMultiApp.html) is used to allow a child application to be launched in space at the centroid of every element in the parent application. This option can be leveraged when multiscale solves are desired. This object requires no special parameters. The child applications can optionally be restricted to solve only on specified blocks (subdomains) by using the [`CentroidMultiApp`](https://mooseframework.inl.gov/source/interfaces/BlockRestrictable.html).

!listing
[MultiApps]
  [sub]
    type = CentroidMultiApp
    app_type = GriffinApp
    input_files = 'Griffin_input.i'
  []
[]

#### MultiApp Classes in `Stochastic Tools App`

The [`Stochastic Tools`](https://mooseframework.inl.gov/modules/stochastic_tools/index.html) module is a toolbox designed for performing stochastic analysis for MOOSE-based applications. It can be used as a parent application to statistically control some key parameters in other MOOSE applications as its child applications.

 The [`Stochastic Tools`](https://mooseframework.inl.gov/modules/stochastic_tools/index.html) apps include [`SamplerFullSolveMultiApp`](https://mooseframework.inl.gov/source/multiapps/SamplerFullSolveMultiApp.html) , [`SamplerTransientMultiApp `](https://mooseframework.inl.gov/source/multiapps/SamplerTransientMultiApp.html) , and [`PODFullSolveMultiApp`](https://mooseframework.inl.gov/source/multiapps/PODFullSolveMultiApp.html) . [`SamplerFullSolveMultiApp`](https://mooseframework.inl.gov/source/multiapps/SamplerFullSolveMultiApp.html)  and [`SamplerTransientMultiApp `](https://mooseframework.inl.gov/source/multiapps/SamplerTransientMultiApp.html) create full solve type, and transient type child application, respectively.


### Required Parameters

#### Input Files

The `input_files` parameter is required regardless of MultiApp `type`. The `input_files` parameter specifies the input file for the child application. If the `positions` parameter is used to specify multiple instances of the child application at different locations in the domain, the same input file will be used at each position. It is possible to specify different input files at each position. Meanwhile, if the user has N points specified by either `positions` or `positions_file`, the can provide an array of N input file names for `input_files`. The ith input file name will be used to run the child application at the $i^{th}$ position. In the example below, the input file (name.i) will be used for all the child applications within the MultiApps block named "micro".

!listing
[MultiApps]
  [micro]
    type = TransientMultiApp
    app_type  = BisonApp
    positions =   '0.01285  0.0       0
                   0.01285  0.0608    0
                   0.01285  0. 1216   0
                   0.01285  0.1824    0'
    input_files = name.i
    execute_on = 'timestep_end'
  []
[]

### Optional Parameters

#### Timing of Execution

The `execute_on` parameter specifies when a child application is to be executed, in relation to the parent application timesteps. The most common options are to execute the child application at the beginning of the time step, at the end of the time step, or at the initial condition of the entire simulation. By default, child application execution will occur at the beginning of time-step.  In the previous example, at every time step, the main application will be executed first, then the child applications will be executed at the end of the time step. Some common options of `execute_on` are summarized below:

  1. `TIMESTEP_BEGIN`: Launch child application at the beginning of the time step

  2. `TIMESTEP_END`: Launch child application at the end of the time step

  3. `INITIAL`: Launch child application only at the initial condition to set up the initial conditions for the solve

  4. `NONLINEAR`: This option has limited applications and is used to inject the coupling information into the middle of the Newton solve. It will likely slow down the newton convergence, as the contribution to the Jacobian are not considered, but could speed up the convergence of the entire system.  

#### Finer Timesteps in Child Applications

Applications may use different time step sizes by allowing `subcycling`. The subcycling option is useful for allowing different timescales. For instance, a relatively slow physics application may use bigger time steps (e.g. 10 sec) whereas a rapidly changing physics may use relatively small-time step (e.g. 0.1 sec). Thus, the first app takes one time-step of 10 sec while the other app takes 100 time-steps of 0.1 sec to reach the same end time as the first application.

!media media/resources/advsubcycling.png
      style=display: block;margin-left:auto;margin-right:auto;width:80%;
      id= subcycling
      caption=Schematic drawing of the sub-cycling concept.

 [subcycling] illustrates a transient Multiphysics simulation in which Griffin, Bison, and SAM are coupled at different timescales using the subcycling option. When performing sub-cycling, transferred auxiliary variables on child applications may be interpolated between the start time and the end time of the main app with the `interpolate_transfers` parameter. When using the TransientMultiApp type, the `sub_cycling` parameter can be used to invoke subcycling.

#### Locations of Child Applications

Child applications can be launched at various spatial positions of the parent application geometry by using the 'positions' input parameter. Positions are simply a list of 3D coordinates that describe the offset of the child application's origin from the parent application's origin. If no positions are provided, the child application will be launched at the position `0 0 0` within the parent application. Notice that in the example below, the number of child applications to be invoked is not explicitly defined but rather is inferred from the number of positions given. The example shows five different positions, thus, five independent versions of the child application `BisonApp` will be created and each of them will be associated with a different position within the parent application domain. The user may also provide a position file instead of explicitly providing the positions in the MultiApp block; this feature is useful when the user wants to invoke thousands of child application as the separate input file can contain all this information without cluttering the main input file. A common use of positions in nuclear reactor analysis is the launching of individual fuel rod (BISON) simulations at various fuel rods within a reactor assembly or core.  

!listing
[MultiApps]
  [micor]
    type = TransientMultiApp
    app_type  = BisonApp
    positions =   '0.013  0    0
                   0.013  0.09    0
                   0.013  0. 18   0
                   0.013  0.27    0'
                   0.013  0.36    0'
    input_files = name.i
    execute_on = 'timestep_end'
  []
[]

The user may also provide positions in a "position file" rather than in the the MultiApp block. This is useful when the number of positions is exceedingly large. For example, the heat-pipe cooled microreactor example demonstrates the use of the positions file to invoke Sockeye heat pipe temperatures calculations on each heat pipe in the domain.

!listing mrad/legacy/steady/MP_FC_ss_bison.i
         block=MultiApps

The list and location of each heat-pipe are provided in +hp_centers.txt+ as follows:

!listing mrad/legacy/steady/hp_centers.txt        

#### Parallel Options

 When the mesh requires large memory usage, it is useful to use [`Distributed Mesh`](https://mooseframework.inl.gov/syntax/Mesh/) by setting `parallel_type` as `distributed` in the `Mesh` block so that the different portions can be stored in different processors.

 It is also useful to assign a few processors for small or memory-intensive solves using `max_procs_per_app` which is the maximum number of processors to give to each App. However, for large solves, the user can assign the minimum number of processors to give to each App using `min_procs_per_app`.

#### Other Options

 For the MOOSE Apps: `FullSolveMultiApp`, `TransientMultiApp`, and `CentroidMultiApp`. There are various common optional parameters such as `app_type`, `bounding_box_inflation`, `bounding_box_padding`,  `catch_up`, `cli_args`, `cli_args_files` , `clone_master_mesh` , `detect_steady_state`,  `global_time_offset` , `keep_solution_during_restore`, `library_name`, `library_path`,`output_in_position`, and `execute_on`.

 Other parameters are allowed only for specific MultiApps type. For example, `positions` is an optional parameter for FullSolveMultiApp and TransientMultiApp, but it is not a parameter for CentroidMultiApp. Generally, these optional parameters were developed to facilitate flexible multi-physics simulations.  The `no_backup_and_restore` optional parameter is useful when doing steady-state Picard iterations where we want to use the solution of previous Picard iteration as the initial guess of the current Picard iteration.

 In addittion, if the user wants to pass additional command line argument to the sub apps this can be done using `cli_args`, or the file names that should be looked in for additional command line arguments to pass to the sub apps can be defined using `cli_args_files`.

#### Mesh Displacement

There are different [`mesh`](https://mooseframework.inl.gov/application_usage/mesh_block_type.html) options that are available in MOOSE. Calculations can be performed on the initial mesh configuration or, when requested, a `displaced` mesh configuration. To enable displacements, provide a vector of displacement variable names for each spatial dimension in the `displacements` parameters within the Mesh block. Once enabled, any object that should operate on the displaced configuration should set the `use_displaced_mesh` to true. For example, the following snippet enables the computation of a Postprocessor with and without the displaced configuration.

!listing
[Mesh]
  type = FileMesh
  file = truss_2d.e
  displacements = 'disp_x disp_y'
[]

!listing
[Postprocessors]
  [without]
    type = ElementIntegralVariablePostprocessor
    variable = c
    execute_on = initial
  []
  [with]
    type = ElementIntegralVariablePostprocessor
    variable = c
    use_displaced_mesh = true
    execute_on = initial
  []
[]

If the child application uses the same `mesh` as the parent application, the `clone_master_mesh` parameter allows for re-using the main application mesh in the child application.

#### Restart and Recovery

 [`Restart/Recover`](https://mooseframework.inl.gov/application_usage/restart_recover.html) is useful to restart a simulation using data from a previous simulation. If the same mesh file will be used, and the initial conditions need to be varied, the user can use `Variable Initialization`. Nevertheless, for the other situations, checkpoint files will be needed. The checkpoint files will include all the simulation information, including those of all the child and grandchild applications (infinite recursion), that are needed for advanced restart of the simulation. The following block should be added to the input file to create the checkpoint files.

!listing
[Outputs]
  checkpoint = true
[]

It should be noticed that enabling the checkpoint for the parent application will store all the required information to restart the data from all child applications. If a simulation is terminated by mistake, the user can recover the simulation using `--recover` command-line flag if checkpoint files were enabled.

!style halign=right
[+Go to Chapter 6+](/chp_6_transfers.md)
