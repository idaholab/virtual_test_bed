#!/bin/bash

cd $PBS_O_WORKDIR
mpiexec -np 192 -machinefile $PBS_NODEFILE ../../blue_crab-opt -i cnrs_s21_griffin_neutronics.i \
frequency=${FREQUENCY} Outputs/file_base="cnrs_s21_f_${FREQUENCY}" > cnrs_s21_f_${FREQUENCY}
