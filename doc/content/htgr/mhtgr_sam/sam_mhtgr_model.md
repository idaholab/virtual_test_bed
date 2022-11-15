# MHTGR SAM model

*Contact: Thanh Hua, hua.at.anl.gov*

The input file (MHTGR.i) is a model for the General Atomic’s 600-MWt Modular
High Temperature Gas-Cooled Reactor. Interested readers are referred
to the technical summary [!citep](Vollman2010) for more details about the
MHTGR system.
The SAM model [!citep](Hu2017, Vegendla2019)
was developed using the ring approach based on a specified coolant channel
pitch of fuel assembly. In this approach, all components including fuel,
reflectors, coolant channels, core barrel, reactor pressure vessel (RPV),
and reactor cavity cooling system (RCCS) are modeled as concentric cylindrical
rings.  The active core consists of three fuel rings; inner, middle and outer
ring. Each fuel ring is represented by 11 coolant channels and 22 heat
structures. Thus the active core is simulated with 99 circular rings where
66 rings for homogenized fuel heat structure and 33 rings for gas coolant.  
Each coolant ring is sandwiched between two heat structure rings. The two
surfaces of these two heat structure rings that form the walls of the coolant
ring are thermally equilibrated via surface coupling to prevent unphysical
temperature discontinuity.  In addition, six more rings are included to
represent the inner reflector, outer reflector, core barrel, RPV, RPV coolant
channel, and RCCS riser wall.  Note that the 600-MWt conceptual design
is similar to a previous 350-MWt design developed
in the 1980s [!citep](Turner1988, Neylan1988, GA2014, NEA2017).

The output files consist of: (1) a `csv` file that writes all user-specified
variables at each time step; (2) a checkpoint folder that saves the
snapshots of the simulation data including all meshes, solutions, and
stateful object data. They are saved for restarting the run if needed;
and (3) a `ExodusII` file that also has all mesh and solution data. Users
can use Paraview to visualize the solution and analyze the data.
This tutorial describes the content of the input file, the output
files and how the model can be run using the SAM code.

# Input Description

SAM uses a block-structured input syntax. Each block begins with square
brackets which contain the type of input and ends with empty square
brackets. Each block may contain sub-blocks. The blocks in the input
file are described in the order as they appear.
Before the first block entries, users can define variables and specify
their values which are subsequently used in the input model.  For example,

!listing
rad_R-1		    =	0  		    # the radius of Ring 1
w_R-1		    =	1.48		# the thickness of Ring 1
power_total     =   600e6		# the total power


In SAM, comments are entered after the `#` sign

## Global parameters

This block contains the parameters such as global initial pressure,
velocity, and temperature conditions, the scaling factors for primary
variable residuals, etc.  For example, to specify global pressure
of 1.e5 Pa, the user can input

```language=bash

global_init_P	 = 	1.e5

```

This block also contains a sub-block `PBModelParams` which specifies
the modeling parameters associated with the primitive-variable based
fluid model. New users should leave this sub-block unchanged.

## EOS

This block specifies the Equation of State. The user can choose
from built-in fluid library for common fluids like air, nitrogen,
helium, sodium, molten salts, etc. The user can also input the
properties of the fluid as constants or function of temperature.
For example,  the built-in eos for air can be input as

!listing htgr/mhtgr/mhtgr_sam/MHTGR.i block=eos_air language=cpp

Water is used as coolant at the RCCS, and its properties
in SI units are input as follows.

!listing htgr/mhtgr/mhtgr_sam/MHTGR.i block=eos_water language=cpp

## Functions

Users can define functions for parameters used in the model.
These include temporal, spatial, and temperature dependent functions.
For example, users can input enthalpy as a function of temperature,  
power history as a function of time, or power profile as a
function of position. The input below specifies graphite thermal
conductivity as a function of temperature (in K)

!listing htgr/mhtgr/mhtgr_sam/MHTGR.i block=kgraphite language=cpp

## MaterialProperties

Material properties are input in this block. The values
can be constants or temperature dependent as defined in
the Functions block. For example, the properties of graphite
are input as

!listing htgr/mhtgr/mhtgr_sam/MHTGR.i block=graphite-mat language=cpp

The thermal conductivity is defined by the function `kgraphite`
which appears under the `Functions` block.

## ComponentInputParameters

This block is used to input common features for `Components`
(section below) so that these common features do not need to
be repeated in the inputs for `Components` later on. For example,
if pipes are used in various parts of the model and the pipes
all have the same diameter, then the diameter can be specified
in `ComponentsInputParameters` and it applies to all pipes used
in the model.

!listing htgr/mhtgr/mhtgr_sam/MHTGR.i block=ComponentInputParameters

## Components

This block provides the specifications for all components
that make up the primary and secondary loops.  The components
consist of: reactor, coolant channels, heat structures (fuel,
reflectors, core barrel, RPV and RCCS), pipes, heat exchanger,
blower and junctions for connecting components. In the reactor
component, the reactor power is an input and this includes
normal operating power and decay heat.  

!listing htgr/mhtgr/mhtgr_sam/MHTGR.i block=reactor language=cpp

The coolant channels are modeled as 1-D fluid flow components,
and heat structures are modeled as 2-D components. Table 1
shows the names of the rings in the model starting from
the center of the core toward the RCCS.

!table id=table-floating caption=Names of rings in the SAM model.
| Name | Description | Note  |
| :- | :- | :- |
| `R1` | Inner reflector |   |
| `R2_n-L` | Inner fuel ring left structure |   |
| `R2C-n` | Inner fuel ring coolant channel | `n` ranges from 1 to 11 |
| `R2_n-R` | Inner fuel ring right structure | `n` ranges from 1 to 11 |
| `R3_n-L` | Middle fuel ring left structure | `n` ranges from 1 to 11 |
| `R3C-n` | Middle fuel ring coolant channel | `n` ranges from 1 to 11 |
| `R3_n-R` | Middle fuel ring right structure | `n` ranges from 1 to 11 |
| `R4_n-L` | Outer fuel ring left structure | `n` ranges from 1 to 11 |
| `R4C-n` | Outer fuel ring coolant channel | `n` ranges from 1 to 11 |
| `R4_n-R` | Outer fuel ring right structure | `n` ranges from 1 to 11 |
| `R5` | Outer reflector |   |
| `R6` | Core barrel |   |
| `R6_C` | Upcomer coolant channel |   |
| `R7` | Reactor pressure vessel |   |
| `RCCS_AC` | Reactor cavity cooling system |   |

In this configuration, each coolant channel communicates with
its two adjacent heat structures through the variable
`HT_surface_area_density_right` and  
`HT_surface_area_density_left` such as shown below

!listing htgr/mhtgr/mhtgr_sam/MHTGR.i language=cpp
        start=R4_9-L
        end=R4_10-L

Adjacent heat structures are connected using `SurfaceCoupling`
to assure temperature continuity

!listing htgr/mhtgr/mhtgr_sam/MHTGR.i block=Gap_R4_9 language=cpp

In SAM, 1-D components are connected using
`PBSingleJunction`.  The following input is
used to connect  the outlet of component `R4C-1` to
the inlet of component `R4CUP-1`.

!listing htgr/mhtgr/mhtgr_sam/MHTGR.i block=Branch_R4CUP-1 language=cpp

Heat exchangers are modeled using `PBHeatExchanger` including the
fluid flow in the primary and secondary sides, convective heat transfer,
and heat conduction in tube wall.  Pumps are modeled using `PBPump`.

## Postprocessors

This block is used to specify the output variables written
to a `csv` file that can be further processed in Excel or Python.
For example, to output the temperature and velocity in `R3C-11`:

!listing htgr/mhtgr/mhtgr_sam/MHTGR.i language=cpp
        start=R3C11_T_in
        end=R4C11_T_in

To output the maximum temperature in `R6`:

!listing htgr/mhtgr/mhtgr_sam/MHTGR.i block=R6_max language=cpp

## Preconditioning

This block describes the preconditioner used by the solver.  
New users can leave this block unchanged.

!listing htgr/mhtgr/mhtgr_sam/MHTGR.i block=Preconditioning

## Executioner

This block describes the calculation process flow. The user can specify
the start time, end time, time step size for the simulation. Other inputs
in this block include PETSc solver options, convergence tolerance,
quadrature for elements, etc. which can be left unchanged.

!listing htgr/mhtgr/mhtgr_sam/MHTGR.i block=Executioner
