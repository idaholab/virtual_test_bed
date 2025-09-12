#!/bin/bash
#PBS -j oe
#PBS -koe
#PBS -l select=4:ncpus=48:mpiprocs=48
#PBS -l walltime=20:00:00
#PBS -l place=scatter:excl
#PBS -P nasa

 

nprocs=`cat $PBS_NODEFILE | wc -l`
cat $PBS_NODEFILE
module purge
module load use.moose moose-apps blue_crab

#
cd $PBS_O_WORKDIR
JOB_NUM=${PBS_JOBID%\.*}
if [ $PBS_O_WORKDIR != $HOME ]
then
ln -s $HOME/$PBS_JOBNAME.o$JOB_NUM $PBS_JOBNAME.o$JOB_NUM
fi

time mpirun -np $nprocs blue_crab-opt -i cnrs_s14_griffin_neutronics.i > O_cnrs_s14_griffin_neutronics.out
time mpirun -np $nprocs blue_crab-opt -i cnrs_s21_griffin_neutronics.i > O_cnrs_s21_griffin_neutronics.out


if [ $PBS_O_WORKDIR != $HOME ]
then
rm $PBS_JOBNAME.o$JOB_NUM
mv $HOME/$PBS_JOBNAME.o$JOB_NUM $PBS_JOBNAME.o$JOB_NUM
fi
