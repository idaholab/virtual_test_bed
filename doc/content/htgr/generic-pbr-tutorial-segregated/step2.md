## Step 2

Step 2 modifies the input for Step 1 by adding a pressure drop in the bed.
The pressure drop physically originates from the interaction of the fluid with
the coexisting solid, which is a transfer of momentum from the fluid to the
solid. In this tutorial, we use the German Kerntechnischer Ausschuss (KTA)
correlations to compute the pressure drop. The KTA pressure drop for a
one-dimensional flow is given by:

!equation
-\frac{dp}{dx} = \psi \frac{1-\epsilon}{\epsilon^3} \frac{1}{2 D_h \rho}\left(\frac{\dot{m}}{A}\right)^2,

where:

!equation
\psi = \frac{320}{\frac{\text{Re}}{1-\epsilon}} + \frac{6}{\left(\frac{\text{Re}}{1 - \epsilon}\right)^{0.1}},

where $\epsilon$ is the porosity, $D_h$ is the hydraulic diameter, $\rho$ is the density,
$\dot{m}$ is the mass flow rate, $A$ is the area of the cylindrical flow channel, and $\text{Re}$ is the Reynolds number. The Reynolds number is given by:

!equation
\text{Re}= \frac{\dot{m}/A D_h}{\mu},

where $\mu$ is the dynamic viscosity,
$D_h$ is the pebble diameter of $0.06$ m, and $A=4.523893$ m$^2$.
For this rough estimate, we use the average density and dynamic viscosity
computed by postprocessors. We find $\rho \approx 8.628046$ kg/m$^3$ and
$\mu \approx 1.991242 \times 10^{-5}$ Pa-s.
With these numerical values, we obtain:

!equation
\text{Re} = 39964 \\
\psi = 1.984 \\
\frac{dp}{dx} = -3467 Pa/m

As the length of the bed is 10 m, this rough calculation gives a pressure drop
of about $34.67$ kPa.

## Adding pressure drop to the channel flow

We will use the KTA drag coefficient material in Pronghorn.
To use this material, the characteristic length (aka hydraulic diameter)
of the bed has to be set. For pebble beds, the characteristic length is the
pebble diameter, which we assume to be $0.06$ m consistent with typical
gas-cooled reactor pebbles. We create a real valued variable called
`pebble_diameter` for convenience at the top of the input file:

!listing htgr/generic-pbr-tutorial-segregated/step2.i start=T_fluid end=flow_vel

The KTA correlation depends on the Reynolds number, which in a porous medium is
based on the interstitial velocity. The SIMPLE input therefore creates the
`speed` functor explicitly from the superficial velocity variables and the
porosity:

!listing htgr/generic-pbr-tutorial-segregated/step2.i block=speed_material

The fluid properties material uses this `speed` functor and the pebble diameter
as the characteristic length. This gives the fluid-property functors the same
information needed to compute density, viscosity, and Reynolds numbers:

!listing htgr/generic-pbr-tutorial-segregated/step2.i block=fluid_props_to_mat_props

Drag friction sources are split into a component that depends linearly on fluid
speed, called Darcy friction, and one that depends quadratically on fluid speed,
called Forchheimer friction. The KTA material computes these coefficients as
functor material properties named `Darcy_coefficient` and
`Forchheimer_coefficient`:

!listing htgr/generic-pbr-tutorial-segregated/step2.i block=drag_pebble_bed

Note how we use the ${pebble_diameter} variable to set the parameter of the same
name. The fluid and solid temperatures are simply set to constants here because
we have not added energy equations for the fluid and solid phases. The fluid
and solid temperatures are used to evaluate material properties.

The pressure-drop terms are applied to the x- and y-momentum equations using
`LinearFVMomentumPorousFriction`. Both momentum components use the same Darcy
and Forchheimer coefficient functors:

!listing htgr/generic-pbr-tutorial-segregated/step2.i start=u_friction end=p_diffusion

## Measuring Pressure Drop

We use postprocessors to compute the inlet and outlet mass flow rates, the
pressure drop, and the averaged density and viscosity:

!listing htgr/generic-pbr-tutorial-segregated/step2.i block=Postprocessors

The `inlet_mfr` and `outlet_mfr` postprocessors use `RhieChowMassFlowRate` so
that the measured mass flow rate is consistent with the face mass fluxes used by
the SIMPLE pressure correction. Note that `inlet_pressure`,
`outlet_pressure`, `integral_density`, `integral_mu`, and `area` are not printed
to screen or written to the CSV file because the parameter `outputs` is set to
none.

## Executioner

The input solves the steady problem using the `SIMPLE` executioner:

!listing htgr/generic-pbr-tutorial-segregated/step2.i block=Executioner

The `momentum_systems` parameter lists the segregated velocity systems and
`pressure_system` identifies the pressure system. The `rhie_chow_user_object`
parameter connects the executioner to the mass-flux object used by the momentum
and pressure equations. The momentum and pressure equations are under-relaxed,
and the linear systems are solved with hypre BoomerAMG.
Because the horizontal velocity remains zero in this one-dimensional flow, the
input gives `superficial_u` a looser residual tolerance and `superficial_v` a
tighter one, so the vertical momentum equation can converge without requiring
the horizontal momentum residual to reach `1e-8`.

## Executing and comparing the pressure drop

Execute `step2.i` by:

!listing
./pronghorn-opt -i step2.i

The input produces an Exodus file `step2_out.e` and a CSV file
`step2_out.csv`. The computed pressure drop is $34.66$ kPa, in close agreement
with the rough hand estimate of $34.67$ kPa obtained using the postprocessed
average density.
