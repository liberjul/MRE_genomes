#!/bin/bash

#SBATCH --job-name=orthofinder_MRE
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=20G
#SBATCH --time=1:00:00
#SBATCH --output=%x-%j.SLURMout

module load icc/2018.1.163-GCC-6.4.0-2.28
module load impi/2018.1.163
module load ifort/2018.1.163-GCC-6.4.0-2.28
module load impi/2018.1.163
module load FastME/2.1.6.1

cd ~/Bonito_Lab/MRE_genomes/OrthoFinder-2.1.2/
./orthofinder -f ../Genomes/ # You can you the protein alignments for this, all in a single folder
