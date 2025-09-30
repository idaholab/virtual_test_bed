#!/bin/bash

#PBS -N PSS
#PBS -l select=25:ncpus=48:mpiprocs=40
#PBS -l walltime=05:00:00
#PBS -P nrc

# Change to the directory from which the job was submitted
cd $PBS_O_WORKDIR

# Load the necessary modules
module purge
module load use.moose moose-dev

mpiexec -n 1000 path_to_combined-opt -i pss.i | tee progress_log.txt 