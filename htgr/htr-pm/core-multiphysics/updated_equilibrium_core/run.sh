#!/bin/bash
#PBS -j oe
#PBS -koe
###PBS -l nodes=2:ppn=2
#PBS -l select=1:ncpus=48:mpiprocs=48
#PBS -l walltime=4:00:00
#PBS -l place=scatter:excl
#PBS -P nrc



nprocs=`cat $PBS_NODEFILE | wc -l`
cat $PBS_NODEFILE
module purge
module load use.moose moose-apps blue_crab

module load mpich/3.3.2
#module load mpich
#module load fftw
module list

export MV2_SMP_USE_CMA=0

#
cd $PBS_O_WORKDIR
JOB_NUM=${PBS_JOBID%\.*}
if [ $PBS_O_WORKDIR != $HOME ]
then
ln -s $HOME/$PBS_JOBNAME.o$JOB_NUM $PBS_JOBNAME.o$JOB_NUM
fi
#

time mpirun -np $nprocs blue_crab-opt -i htr_pm_neutronics_ss.i       > O_htr_pm_neutronics_ss.out

#
if [ $PBS_O_WORKDIR != $HOME ]
then
rm $PBS_JOBNAME.o$JOB_NUM
mv $HOME/$PBS_JOBNAME.o$JOB_NUM $PBS_JOBNAME.o$JOB_NUM
fi
