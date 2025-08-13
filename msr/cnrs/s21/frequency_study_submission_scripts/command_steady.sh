#!/bin/bash

cd $PBS_O_WORKDIR
mpiexec -np 192 -machinefile $PBS_NODEFILE ../../blue_crab-opt -i cnrs_s14_griffin_neutronics.i
