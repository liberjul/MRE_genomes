#!/bin/bash --login

# For running on the MSU HPCC
module load GCC/6.4.0-2.28  OpenMPI/2.1.2 BBMap/37.93
for i in ./Fungal_genomes/*.fasta
do
  echo $i
  stats.sh in=$i
done
