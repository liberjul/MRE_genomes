#!/bin/bash

#SBATCH --job-name=spades_SRA1046112
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=50G
#SBATCH --time=6:00:00
#SBATCH --output=%x-%j.SLURMout

module load SPAdes

cd ~/Bonito_Lab/MRE_genomes/glom_SRA_reads
spades.py -o SRA1046112_spades \
--meta -t 16 \
-1 SRA1046112_1.fastq.gz \
-2 SRA1046112_2.fastq.gz
