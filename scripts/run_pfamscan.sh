#!/bin/bash

#SBATCH --job-name=PfamScan_all
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=20G
#SBATCH --time=2:00:00
#SBATCH --output=%x-%j.SLURMout

cd ~/Bonito/MRE_genomes/PfamScan_res
for i in *.faa
do
  if [ ! -f $i"_pfam_tbl.txt" ]; then
    echo $i"_pfam_tbl.txt"
    hmmscan --tblout $i"_pfam_tbl.txt" \
    --cpu 16 \
    -o $i"_pfam.out" ~/bin/PfamScan/Pfam-A.hmm $i
  fi
done
