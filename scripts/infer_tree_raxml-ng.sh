raxml-ng --parse --msa aligned_MRE_16S.fa.raxml.reduced.phy --model GTR+G+FO --threads 5
raxml-ng --msa aligned_MRE_16S.fa.raxml.reduced.phy --model GTR+G+FO --prefix T3 --threads 5 --seed 2 --tree pars{25},rand{25}
