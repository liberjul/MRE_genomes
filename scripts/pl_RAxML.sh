#!/bin/bash --login
########## Define Resources Needed with SBATCH Lines ##########

#SBATCH --time=4:00:00             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH -N 4
#SBATCH -B 2:8:1
#SBATCH --ntasks-per-node=1                 # number of tasks - how many tasks (nodes) that you require (same as -n)
#SBATCH --cpus-per-task=16          # number of CPUs (or cores) per task (same as -c)
#SBATCH --hint=compute_bond
#SBATCH --mem=10G                   # memory required per node - amount of memory (in bytes)
#SBATCH --job-name 16S_raxml_bs          # you can give your job a name for easier identification (same as -J)
#SBATCH --output=%x-%j.SLURMout

########## Command Lines to Run ##########

cd ${SLURM_SUBMIT_DIR}

raxml-ng --parse --msa aligned_MRE_16S.fa --model GTR+R4+FO

raxml-ng --msa aligned_MRE_16S.fa.raxml.reduced.phy --model GTR+R4+FO --prefix T6 --threads 16 --seed 2 --tree pars{25},rand{25}

raxml-ng --bootstrap --msa aligned_MRE_16S.fa.raxml.reduced.phy --model GTR+R4+FO --prefix T7 --threads 16 --seed 486 --bs-trees 1000

raxml-ng --support --tree T7.raxml.bestTree --bs-trees T8.raxml.bootstraps --prefix T8 --threads 2

scontrol show job $SLURM_JOB_ID     ### write job information to output file
