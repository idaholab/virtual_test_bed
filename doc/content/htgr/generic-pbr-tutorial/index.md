# Step-by-Step Tutorial to Model a Generic Pebble-Bed High-Temperature Gas-Cooled Reactor Using Pronghorn

## Setting up your environment

Navigate to the right virtual test bed directory

!listing
cd /path/to/VTB/htgr/generic-pbr-tutorial

and create a link to your Pronghorn executable:

!listing
ln -s /path/to/projects/pronghorn/pronghorn-opt

As an Idaho National Laboratory High Performance Computing user you do not need to create the link to the executable, you can just load the Pronghorn module and run all the inputs in this tutorial using `pronghorn-opt` instead of `./pronghorn-opt` e.g.:

!listing
pronghorn-opt -i step1.i

instead of

!listing
./pronghorn-opt -i step1.i

[Step 1: An axisymmetric flow channel with porosity](generic-pbr-tutorial/step1.md)

[Step 2: Adding pressure drop](generic-pbr-tutorial/step2.md)

[Step 3: Adding a cavity above the bed](generic-pbr-tutorial/step3.md)

[Step 4: Adding a solid conduction equation and a heat source in the pebble-bed](generic-pbr-tutorial/step4.md)

[Step 5: Adding reflectors](generic-pbr-tutorial/step5.md)

[Step 6: Adding plenums and riser](generic-pbr-tutorial/step6.md)

[Step 7: Adding control rod bypass](generic-pbr-tutorial/step7.md)

[Step 8: Adding the outer parts of the reactor](generic-pbr-tutorial/step8.md)