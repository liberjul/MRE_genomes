# for f in ../KEGG_Res/MorAlp_AD073*.txt
for f in ../KEGG_Res/*.txt
do
  cat header.txt <(paste -d, <(grep -o "* [^ ]*" $f | cut -d " " -f 2) <(grep -o "K[0-9]\{5\} " $f)) > $f.csv
done
