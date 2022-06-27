# 2. Important Terminology and Hierarchy Rules

## Important Terminology

In [Chapter 1](/chp_1_motives.md), we have described the basic purpose of the MOOSE MultiApp System, which is to enable flexible and computationally efficient multiphysics coupling among several physics solvers or applications. Now, how do we set up the coupling scheme? This chapter introduces basic terminology and recommendations for setting up coupled simulations. The flow of information and order of execution of individual applications is specified through a MultiApp hierarchy.

### MultiApp Hierarchy

The MultiApp system is designed for efficient parallel execution of hierarchical problems. The `MultiApp hierarchy` describes the sequence of execution of individual applications (which individually solve systems of fully coupled equations) and how data is transferred to couple them together. Nuclear reactor multiphysics problems can generally be mapped to such a hierarchical coupling scheme. The hierarchy is made up of a parent application and child(ren) (and potentially an arbitrary number of further generations of child(ren) applications). While an application solves its own system of fully coupled equations, dependent child (or `sub`) applications which receive data from the application above it in the hierarchy are unaware that they are dependent applications, nor are they aware of other child applications in the MultiApp hierarchy. Once an application completes its calculation, it may transfer information to its child(ren) applications or back up to its parent. Generally, data is transferred back and forth between physics which updates their initial conditions and provides a solution via tight coupling. An example MultiApp hierarchy is shown in [fig_2_1].

!media media/resources/Fig2-1.png
      style=display: block;margin-left:auto;margin-right:auto;width:80%;
      id= fig_2_1
      caption=An example hierarchy describing the sequence of execution and information transfer of various applications, coordinated by MultiApp system in MOOSE.

### Application

In the MOOSE environment, an application is an independent solver which solves a system of fully coupled equations. Applications make up units in the MultiApp hierarchy. Applications are further classified based on their roles in the hierarchy as either parent or child, and may contain MultiApp containers within them.

### Parent Application

The application at the top level of the MultiApp hierarchy drives the coupled simulation. This application is termed the parent (or main) application. The parent application can have any number of MultiApp objects. Every MultiApp hierarchy must have a parent application.

### MultiApp Objects

A `MultiApp` object may be added to any individual application to invoke one or more `child` applications. A `MultiApp` object may invoke thousands or even millions of child applications. A child application may solve completely different physics from the application above it, which may or may not be the parent application depending on its level in the hierarchy. The MultiApp system allows a tree of simulations to be constructed with large numbers of different applications potentially with different time and space scales.

### Child Application

A `child` (or `sub`) application is an independent application invoked by a `MultiApp` object. `Child` applications transfer data back and forth to applications above it in the hierarchy. A `child` application may solve different physics than the parent application, or could solve the same physics with different boundary conditions, material property, mesh, timescale, etc. A `child` application can be a `MOOSE-based` application or a `MOOSE-wrapped` external application. A child application can itself contain a `MultiApp` object which then spurs grandchild applications and creates a multi-level solve. Recall that a child application is not aware of the other child applications under the same, or other, MultiApp object. It operates independently and uses the information it is passed by its parent app, using the Transfers system.
For example, [fig_2_1] represents a MultiApp hierarchy in which the parent application has two MultiApp objects: the first and second MultiApp objects have two and three child applications, respectively. In addition, as demonstrated in [fig_2_1], child applications are given identification numbers on the form of `x-y` where x identifies the MultiApp object invoking the child application, and y identifies the child application itself. The child applications 1-1, 1-2, and 2-2 also contain MultiApp objects invoking additional child, or grand-child, applications. This creates a multi-level solve of the simulation. This example depicts a multi-level solve created by parent, child, and grand-child applications. The user may construct a very large tree of solves.


### Transfer System

The `Transfer System` is responsible for transferring data between applications. In the MultiApp hierarchy, data may be transferred only in the up-down and left-right directions as illustrated in [fig_2_1]. The transfer is performed by filling auxiliary field, scalar or vector postprocessors, userobjects, etc., with data. Then, the receiving application can obtain the transferred data. The user specifies parameters for the transfer such as the source and target (`from_/to_`)`multiapp` to transfer data to/from, the `source_variable`, the auxiliary `variable` field name that will receive the data, and the type of transfer. Transfers will be discussed in more detail in Chapter 4 of this tutorial.

## Hierarchy Rules

### Multi-Level structure

The MultiApp hierarchy has the following structure:

- A parent application can have any number of MultiApp objects.
- A MultiApp object can have any number of child applications.
- A child application can create a multi-level solve by defining any number of MultiApp objects.
- Creating thousands of MultiApps solves is possible in the MultiApp Hierarchy System.
- The applications in the hierarchy can be MOOSE-based or external (MOOSE-wrapped) applications.  
- Using multi-level solves can be advantageous for parallel execution and debugging.


### Iteration

In MOOSE, Picard iterations are used to iterate back and forth between applications to reach an equilibrium/stationary point. Picard iterations are particularly important in coupled systems that have different time and spatial scales. For example, it is common practice in thermal reactor simulations to perform non-linear iterations between the neutronics application (which calculates the power distribution) and the thermal-hydraulic application (which calculates the coolant and fuel temperature). The temperatures affect the cross-sections in the neutronics solution. Data on power and temperature are passed back and forth in Picard iterations until the power and temperature both stabilize and do not change further in a meaningful way.

### Parallel Execution

At any time in the system only one MultiApp application is executed. The number of parallel MPI ranks available are distributed across the number of the child applications of a MultiApp object.  An example is shown in [fig_2_2] where 12 MPI ranks were dedicated to executing the parent application. If the two MultiApps are set to execute on the same time step, then the order of execution between MultiApps (1) and (2) is arbitrary. In this case, if the system selects the MultiApp (1) to execute first, its child application (1-1), (1-2), (1-3), and (1-4) will be executed by 3 MPI ranks each and these child applications will run simultaneously. After the execution MultiApp (1) is completed, the MultiApp (2) will have access to the full set of MPI ranks because only one MultiApp is executed at a time (even in the case where one may only want half of the ranks on two separate MultiApps). This design executes transfers among the various MultiApps in a well-defined order. The child applications of the MultiApp (2) will be executed simultaneously with 4 MPI ranks each. Similarly, the 4 MPI ranks available for the MultiApp (3) will be distributed equally among its child applications.

!media media/resources/Fig2-2.png
      style=display: block;margin-left:auto;margin-right:auto;width:80%;
      id= fig_2_2
      caption=Example of parallel execution in the MultiApp hierarchy

## The Non-uniqueness Nature of a MultiApp Hierarchy

Generally speaking, there is no single unique hierarchy to solve a specific multiphysics problem.  The user must use assign roles of parent or child to each application and define relate MultiApp objects and related data transfers. Certain hierarchies may be advantageous computationally, but generally more than one hierarchy is possible.

## Suggested Approach to Selecting the Parent Application

Despite the possibility of using many different hierarchies to perform a Multiphysics simulation, it is recommended that the application with the longest time and largest spatial scale be selected as the parent application. Applications with smaller time and spatial spaces are better assigned as child applications. This ensures that the the application with the smallest time step does not control the entire simulation and invoke unnecessary calculations for applications which can use coarse time steps. A neutronics application is commonly assigned as the parent application due to its large spatial domain and longer time steps than other applications.

Find more details about MOOSE applications in Chapter 3.

!style halign=right
[+Go to Chapter 3+](/chp_3_applications.md)
