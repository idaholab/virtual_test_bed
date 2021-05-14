# MHTGR SAM model


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

```language=bash

rad_R-1		    =	0  		    # the radius of Ring 1
w_R-1		    =	1.48		# the thickness of Ring 1
power_total     =   600e6		# the total power

```

In SAM, comments are entered after the `#` sign

## Global parameters

This block contains the parameters such as global initial pressure, 
velocity, and temperature conditions, the scaling factors for primary 
variable residuals, etc.  For example, to specify global pressure 
of 1.e5 Pa, the user can input

```language=bash

global_init_P	 = 	1.e5

```

This block also contains a sub-block PBModelParams which specifies 
the modeling parameters associated with the primitive-variable based 
fluid model. New users should leave this sub-block unchanged.

## EOS

This block specifies the Equation of State. The user can choose 
from built-in fluid library for common fluids like air, nitrogen, 
helium, sodium, molten salts, etc. The user can also input the 
properties of the fluid as constants or function of temperature. 
For example,  the built-in eos for air can be input as

```language=bash

[./eos_air]
    type = AirEquationOfState
[../]

```

Water is used as coolant at the RCCS, and its properties 
in SI unites are input as follow. 

```language=bash

[./eos_water]
    type = PTConstantEOS
    p_0 = 70e5    
    rho_0 = 905
    beta = 0
    cp = 4330
    h_0 = 705000
    T_0 = 439
    mu = 0.00016
    k = 0.68
[../]

```

## Functions

Users can define functions for parameters used in the model. 
These include temporal, spatial, and temperature dependent functions. 
For example, users can input enthalpy as a function of temperature,  
power history as a function of time, or power profile as a 
function of position. The input below specifies graphite thermal 
conductivity as a function of temperature (in K)

```language=bash

[./kgraphite]					   #G-348 graphite therm. cond; x- Temperature [K], y-Thermal condiuctivity [W/m-K]
    type = PiecewiseLinear
	x ='295.75	374.15	472.45	574.75	674.75	774.75	874.75	974.85	1074.45	1173.95	1274.05'
	y ='133.02	128.54	117.62	106.03	96.7	88.61	82.22	76.52	71.78	67.88	64.26'
[../]

```

## MaterialProperties

Material properties are input in this block. The values 
can be constants or temperature dependent as defined in 
the Functions block. For example, the properties of graphite 
are input as

```language=bash

[./graphite-mat]                                 # Material name
    type = SolidMaterialProps
    k = kgraphite                                # Thermal conductivity
    Cp = cpgraphite                              # Specific heat
    rho = rhographite                            # Density
[../]

```

The thermal conductivity is defined by the function `kgraphite` 
which appears under the `Functions` block. 

## ComponentInputParameters

This block is used to input common features for `Components` 
(section below) so that these common features do not need to 
be repeated in the inputs for `Components` later on. For example, 
if pipes are used in various parts of the model and the pipes 
all have the same diameter, then the diameter can be specified 
in ComponentsInputParameters and it applies to all pipes used 
in the model. 

## Components

This block provides the specifications for all components 
that make up the primary and secondary loops.  The components 
consist of: reactor, coolant channels, heat structures (fuel, 
reflectors, core barrel, RPV and RCCS), pipes, heat exchanger, 
blower and junctions for connecting components. In the reactor 
component, the reactor power is an input and this includes 
normal operating power and decay heat.  

```language=bash

[./reactor]
    type = ReactorPower
    initial_power = 600e6
  [../]

```

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

```

[./R4_9-L]
    type = PBCoupledHeatStructure
    input_parameters = R4_LHS_param
    name_comp_right= R4C-9
    HT_surface_area_density_right = ${aw_R4-9-L}
    width_of_hs = ${w_R4-9-L}
    radius_i = ${rad_R4-9-L}
[../]

[./R4C-9]
    type = PBOneDFluidComponent
    position = '0 ${rad_R4C-9} 0'
    input_parameters = R4_channelParam
[../]

[./R4_9-R]
    type = PBCoupledHeatStructure
    input_parameters = R4_RHS_param
    name_comp_left= R4C-9
    HT_surface_area_density_left = ${aw_R4-9-R}
    width_of_hs = ${w_R4-9-R}
    radius_i = ${rad_R4-9-R}
[../]

```

Adjacent heat structures are connected using `SurfaceCoupling`
to assure temperature continuity 

```

[./Gap_R4_9]
    type = SurfaceCoupling
    use_displaced_mesh = true
    coupling_type = GapHeatTransfer
    surface1_name = 'R4_9-R:outer_wall'
    surface2_name = 'R4_10-L:inner_wall'
    width = 1e-20
    radius_1 = ${rad_R4-9-L}
    length = ${axial_length_1}
    eos = eos
    h_gap =  ${hGap_cond}
[../]

```

In SAM, 1-D components are connected using 
`PBSingleJunction`.  The following input is 
used to connect  the outlet of component `R4C-1` to 
the inlet of component `R4CUP-1`. 

```

[./Branch_R4CUP-1]
   	 type = PBSingleJunction
     inputs = 'R4C-1(out)'
     outputs = 'R4CUP-1(in)'
   	 eos = eos
[../]

```

Heat exchangers are modeled using `PBHeatExchanger` including the 
fluid flow in the primary and secondary sides, convective heat transfer, 
and heat conduction in tube wall.  Pumps are modeled using `PBPump`.

## Postprocessors

This block is used to specify the output variables written 
to a `csv` file that can be further processed in Excel. 
For example, to output the temperature and velocity in `R3C-11`:

```

[./R3C11_T_in]
    type = ComponentBoundaryVariableValue
    variable = temperature
    input = R3C-11(in)
[../]

[./R3C11_V_in]
    type = ComponentBoundaryVariableValue
    variable = velocity
    input = R3C-11(in)
[../]

```

To output the maximum temperature in `R6`:

```

[./R6_max]
    type = NodalMaxValue
    block = 'R6:hs0'
    variable = T_solid
[../]

```

## Preconditioning

This block describes the preconditioner used by the solver.  
New user can leave this block unchanged.

## Executioner

This block describes the calculation process flow. The user can specify 
the start time, end time, time step size for the simulation. Other inputs 
in this block include PETSc solver options, convergence tolerance, 
quadrature for elements, etc. which can be left unchanged. 
