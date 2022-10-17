#!/bin/bash
#PBS -l select=5:ncpus=48:mpiprocs=1
#PBS -N pulse_refcube_run
#PBS -l walltime=48:00:00
#PBS -k doe
#PBS -j oe
#PBS -P imsr

cat $PBS_NODEFILE

module load use.moose
module load moose-apps
module load griffin

cd $PBS_O_WORKDIR

export TMPDIR=/tmp

time mpirun griffin-opt -i refcube_l.i -omp 48 -nofatal
