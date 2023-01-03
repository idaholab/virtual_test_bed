## Step 2

Step 2 modifies the input for Step 1 by adding a pressure drop in the bed.
The pressure drop in the bed physically originates from the interaction of the fluid with the coexisting solid, which is essentially a transfer of momentum from the
fluid to the solid. In this tutorial, we use the German Kerntechnischer Ausschuss (KTA) correlations to compute the pressure drop. The KTA pressure drop for a one-dimensional flow is given by:

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
We estimate averages for $\rho$ and $\mu$ using postprocessors. These are included in the `step2.i` file but are not discussed here. We find $\rho \approx 8.628204$ kg/m$^3$ and
$\mu \approx 1.991242 \times 10^{-5}$ Pa-s.
With these numerical values, we obtain:

!equation
\text{Re} = 40125 \\
\psi = 1.983 \\
\frac{dp}{dx} = -3493 Pa/m

As the length of the bed is 10 m, we expect a pressure drop of $34.93$ kPa.

## Adding pressure drop to the channel flow

We will use the KTA drag coefficient material in Pronghorn.
To use this material, the characteristic length (aka hydraulic diameter)
of the bed has to be set. For pebble beds, the characteristic length is the
pebble diameter, which we assume to be $0.06$ m consistent with typical
gas-cooled reactor pebbles. We create a real valued variable called
`pebble_diameter` for convenience at the top of the input file:

!listing htgr/generic-pbr-tutorial/step2.i start=T_fluid end=flow_vel

Then we need to add the friction coefficients to the finite volume Navier-Stokes action. This is done by adding the `friction_types` and `friction_coeffs` parameters.

!listing htgr/generic-pbr-tutorial/step2.i block=Modules

Drag coefficients are often split up into a component that depends linearly
on fluid speed, called the Darcy coefficient and one that depends quadratically on flow speed, called the Forchheimer coefficient. The same distinction is made in Pronghorn.
The two parameters simply express that there is a Darcy coefficient called `Darcy_coefficient` and a Forchheimer coefficient called `Forchheimer_coefficient`.
The Darcy and Forchheimer coefficients are internally computed as functor material properties and almost always have the names given above.

Finally, we need to add the material that computes the `Darcy_coefficient`
and `Forchheimer_coefficient`. This is done here:

!listing htgr/generic-pbr-tutorial/step2.i block=drag_pebble_bed

Note how we use the ${pebble_diameter} variable to set the parameter of the same
name. The fluid and solid temperatures are simply set to constants here because
we have not added energy equations for the fluid and solid phases. The fluid and solid temperatures are used to evaluate material properties.

## Measuring Pressure Drop

We measure the pressure drop by averaging the pressure over the inlet and outlet and then taking the difference. This is performed here:

!listing htgr/generic-pbr-tutorial/step2.i start=inlet_pressure end=integral_density

Note that `inlet_pressure` and `outlet_pressure` are neither printed to screen nor written to any possible csv file because the parameter `outputs` is set to none.

## Executing and comparing the pressure drop

We execute by:

!listing
./pronghorn-opt -i step2.i

and find that the pressure is $3.4933 \times 10^4$, which is exactly
what we estimated it should be.
