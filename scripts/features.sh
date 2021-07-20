#!/bin/bash --login
#SBATCH --time=01:00:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=2G
#SBATCH --job-name=prokka_anot
for filename in "MorGam_AM1032_MRE.fa" "AD073_MRE_scaffolds.fa" "MortAD185_MRE_genomic.fa"  "Jlac_OSC162217.vizbin.1kb.MRE.fa" "Jflam_AD002.vizbin.1kb.MRE.fa" "GBAus27b-MRE-ap.1104331.scaffolds.fa" "Endogone_FLAS59071.vizbin.1kb.MRE.fa"
do
  java -cp ~/bin/CRT1.2-CLI.jar crt -minNR 5 ./Genomes/"$filename" "./CRISPRs/""$filename""_crispr.out"
  ~/bin/tRNAscan-SE-2.0/tRNAscan-SE ./Genomes/"$filename" -B -o "./tRNAs/""$filename""_tRNAs.out" -m "./tRNAs/""$filename""_tRNAs.stats"
  # hmmsearch --tblout "./rRNAs/""$filename""_rRNAs.out" -T 70 rRNA_prediction/rRNA_hmm_fs_wst_v0/HMM3/bac_ssu.hmm ./Genomes/"$filename" > hmm_temp.out
  hmmsearch --tblout "./rRNAs/""$filename""_rRNAs_ssu.out" -T 70 ~/bin/rRNA_prediction/rRNA_hmm_fs_wst_v0/HMM3/bac_ssu.hmm ./Genomes/"$filename" > hmm_temp.out
  hmmsearch --tblout "./rRNAs/""$filename""_rRNAs_lsu.out" -T 70 ~/bin/rRNA_prediction/rRNA_hmm_fs_wst_v0/HMM3/bac_lsu.hmm ./Genomes/"$filename" > hmm_temp.out
  hmmsearch --tblout "./rRNAs/""$filename""_rRNAs_tsu.out" -T 70 ~/bin/rRNA_prediction/rRNA_hmm_fs_wst_v0/HMM3/bac_tsu.hmm ./Genomes/"$filename" > hmm_temp.out
  ~/bin/Prodigal-2.6.3/prodigal -i ./Genomes/"$filename" -o "./genes/""$filename""_genes.gbk" -f gbk -a "./genes/""$filename""_prot.fa" -g 4
  prokka -outdir "$filename""prokka_genes" --prefix ./Genomes/"$filename" --gcode 4  $filename
  #~/bin/myblast/bin/makeblastdb -in "./genes/""$filename""_prot.fa" -dbtype prot -out "$filename"_prot
  #~/bin/myblast/bin/blastp -query "./genes/""$filename""_prot.fa" -db /mnt/research/common-data/Bio/
done
#for filename in ./genes/
