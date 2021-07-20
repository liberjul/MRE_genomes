echo "Species,Size" > ../KEGG_Res/sizes.csv
for f in ../Genomes/*.fa
do
  paste -d, <(echo $f | cut -d "/" -f 3 ) <(grep -v "^>" $f | wc -c) >> ../KEGG_Res/sizes.csv
done
sed -i 's/a_Genome.fa//g' ../KEGG_Res/sizes.csv
sed -i 's/_genomic.fa//g' ../KEGG_Res/sizes.csv
sed -i 's/-ap.1104331.scaffolds.fa//g' ../KEGG_Res/sizes.csv
sed -i 's/.vizbin.1kb.MRE.fa//g' ../KEGG_Res/sizes.csv
sed -i 's/.fa//g' ../KEGG_Res/sizes.csv
