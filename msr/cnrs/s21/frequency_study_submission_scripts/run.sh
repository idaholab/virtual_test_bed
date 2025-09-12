qsub -l select=4:ncpus=48:mpiprocs=48 -l walltime=96:00:00 -P neams -v FREQUENCY=0.0125 command_transient.sh
qsub -l select=4:ncpus=48:mpiprocs=48 -l walltime=96:00:00 -P neams -v FREQUENCY=0.025 command_transient.sh
qsub -l select=4:ncpus=48:mpiprocs=48 -l walltime=96:00:00 -P neams -v FREQUENCY=0.05 command_transient.sh
qsub -l select=4:ncpus=48:mpiprocs=48 -l walltime=96:00:00 -P neams -v FREQUENCY=0.1 command_transient.sh
qsub -l select=4:ncpus=48:mpiprocs=48 -l walltime=96:00:00 -P neams -v FREQUENCY=0.2 command_transient.sh
qsub -l select=4:ncpus=48:mpiprocs=48 -l walltime=96:00:00 -P neams -v FREQUENCY=0.4 command_transient.sh
qsub -l select=4:ncpus=48:mpiprocs=48 -l walltime=96:00:00 -P neams -v FREQUENCY=0.8 command_transient.sh