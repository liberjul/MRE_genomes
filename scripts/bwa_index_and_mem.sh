#!/bin/bash

#SBATCH --job-name=bwa_index_and_mem
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --mem=20G
#SBATCH --time=2:00:00
#SBATCH --output=%x-%j.SLURMout

cd ${PBS_O_WORKDIR}

module load BWA/0.7.17
module load SAMtools

bwa index \
-p MortAD185 \
-a is \
../genomes/MortAD185_MRE_genomic.fa

bwa mem -t 10 -R '@RG\tID:1\tSM:1_\tLB:1_\tPL:ILLUMINA' \
MortAD185 SRR1046112_1.fastq.gz SRR1046112_1.fastq.gz | samtools sort -o SRR1046112_sorted.bam
