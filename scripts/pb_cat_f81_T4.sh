#!/bin/bash --login
########## Define Resources Needed with SBATCH Lines ##########

#SBATCH --time=4:00:00             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --ntasks=8                 # number of tasks - how many tasks (nodes) that you require (same as -n)
#SBATCH --cpus-per-task=1          # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem=10G                   # memory required per node - amount of memory (in bytes)
#SBATCH --job-name 16S_pb_catf81_T1          # you can give your job a name for easier identification (same as -J)
#SBATCH --output=%x-%j.SLURMout

########## Command Lines to Run ##########

cd ${SLURM_SUBMIT_DIR}

mpirun -np 8 pb_mpi -d aligned_MRE_16S.fa.raxml.reduced.phy -cat -f81 -dgam 4 pb_MRE_16S_T2


scontrol show job $SLURM_JOB_ID     ### write job information to output file
