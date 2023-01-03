# Step-by-Step Tutorial for a Generic Pebble-Bed High-Temperature Gas-Cooled Reactor HTGR Model in Pronghorn

## Setting up your environment

Navigate to the right virtual test bed directory

!listing
cd /path/to/VTB/htgr/generic-pbr-tutorial

and create a link to your Pronghorn executable:

!listing
ln -s /path/to/projects/pronghorn/pronghorn-opt

As an Idaho National Laboratory High Performance Computing user you may load the Pronghorn module and then
execute all commands in this tutorial except for swapping

!listing
./pronghorn-opt -> pronghorn-opt

[Step 1: An axisymmetric flow channel with porosity](generic-pbr-tutorial/step1.md)

[Step 2: Adding pressure drop](generic-pbr-tutorial/step2.md)

[Step 3: Adding a cavity above the bed](generic-pbr-tutorial/step3.md)

[Step 4: Adding a solid conduction equation and a heat source in the pebble-bed](generic-pbr-tutorial/step4.md)

[Step 5: Adding Reflectors](generic-pbr-tutorial/step5.md)

[Step 6: Adding Plenums and Riser](generic-pbr-tutorial/step6.md)

[Step 7: Adding Control Rod Bypass](generic-pbr-tutorial/step7.md)

[Step 8: Adding the Outer Parts of the Reactor](generic-pbr-tutorial/step8.md)