#!/bin/bash
#PBS -l select=1:ncpus=48:mpiprocs=1
#PBS -N S8ER
#PBS -l walltime=2:00:00
#PBS -P moose

cd $PBS_O_WORKDIR
source /etc/profile.d/modules.sh


module load use.exp_ctl
module load serpent/2.1.32-intel-19.0


mpiexec sss2 SNAP8ER_C3_2D_NODRUMS_WET_4_1.i -omp 48 -nofatal
mpiexec sss2 SNAP8ER_C3_2D_NODRUMS_WET_4_2.i -omp 48 -nofatal
mpiexec sss2 SNAP8ER_C3_2D_NODRUMS_WET_4_3.i -omp 48 -nofatal
mpiexec sss2 SNAP8ER_C3_2D_NODRUMS_WET_4_4.i -omp 48 -nofatal
