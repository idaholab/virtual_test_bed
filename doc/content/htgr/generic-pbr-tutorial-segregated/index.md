# Step-by-Step Tutorial to Model a Generic Pebble-Bed High-Temperature Gas-Cooled Reactor Using Pronghorn with SIMPLE

!tag name=Generic Pebble Bed HTGR Pronghorn tutorial with SIMPLE
     description=In this tutorial we build a pebble bed HTGR simulation step by step using the SIMPLE solver
     image=https://mooseframework.inl.gov/virtual_test_bed/media/generic-pbr-tutorial/MeshP8.png
     pairs=reactor_type:HTGR
           reactor:generic_PBR
           tutorials:PBR
           geometry:core
           simulation_type:thermal_hydraulics
           transient:steady_state
           codes_used:Pronghorn
           computing_needs:Workstation
           fiscal_year:2024
           sponsor:ART;NRIC
           institution:INL

A companion version of this tutorial using the Newton solver is available at [Generic Pebble Bed HTGR Tutorial with Newton](generic-pbr-tutorial/index.md).

## Setting up your environment

Navigate to the right virtual test bed directory

!listing
cd /path/to/VTB/htgr/generic-pbr-tutorial-segregated

and create a link to your Pronghorn executable:

!listing
ln -s /path/to/projects/pronghorn/pronghorn-opt

As an Idaho National Laboratory High Performance Computing user, you do not need to create the link to the executable. You can just load the Pronghorn module and run all the inputs in this tutorial using `pronghorn-opt` instead of `./pronghorn-opt`, e.g.:

!listing
pronghorn-opt -i step1.i

instead of

!listing
./pronghorn-opt -i step1.i

[Step 1: An axisymmetric flow channel with porosity](generic-pbr-tutorial-segregated/step1.md)

[Step 2: Adding pressure drop](generic-pbr-tutorial-segregated/step2.md)

[Step 3: Adding a cavity above the bed](generic-pbr-tutorial-segregated/step3.md)

[Step 4: Adding a solid conduction equation and a heat source in the pebble-bed](generic-pbr-tutorial-segregated/step4.md)

[Step 5: Adding reflectors](generic-pbr-tutorial-segregated/step5.md)

[Step 6: Adding plenums and a riser](generic-pbr-tutorial-segregated/step6.md)

[Step 7: Adding control rod bypass](generic-pbr-tutorial-segregated/step7.md)

[Step 8: Adding the outer parts of the reactor](generic-pbr-tutorial-segregated/step8.md)
