#!/bin/bash

cd $PBS_O_WORKDIR
mpiexec -np 48 ../../blue_crab-opt -i cnrs_s14_griffin_neutronics.i \
MultiApps/ns_flow/cli_args="Ulid=${ULID}" PowerDensity/power=${POWER} Outputs/file_base="cnrs_s14_U_${ULID}_P_${POWER}" > cnrs_s14_U_${ULID}_P_${POWER}
