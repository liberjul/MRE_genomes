#!/bin/bash --login
########## Define Resources Needed with SBATCH Lines ##########

#SBATCH --time=2:00:00             # limit of wall clock time - how long the job will run (same as -t)
#SBATCH --ntasks=1                 # number of tasks - how many tasks (nodes) that you require (same as -n)
#SBATCH --cpus-per-task=4          # number of CPUs (or cores) per task (same as -c)
#SBATCH --mem=4G                   # memory required per node - amount of memory (in bytes)
#SBATCH --job-name 16S_extract          # you can give your job a name for easier identification (same as -J)
#SBATCH --output=%x-%j.SLURMout

########## Command Lines to Run ##########

cd ${SLURM_SUBMIT_DIR}
for filename in *.fa
do
  echo $filename
  hmmsearch --domtblout $filename".out" --cpu 4 -T 70 ~/bin/rRNA_prediction/rRNA_hmm_fs_wst_v0/HMM3/bac_ssu.hmm $filename > hmm_temp.out
  python ../Ref_genomes/domain_hmm_hits_extract.py -i $filename -o ../Ref_genomes/16S_fastas/
  rm $filename".out"
done
cat ../Ref_genomes/16S_fastas/*.fa > ../Ref_genomes/combined_16S_seqs.fa
