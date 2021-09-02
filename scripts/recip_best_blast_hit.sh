#!/bin/bash --login

mkdir BLASTp_dbs
mkdir BLASTp_res
for DB in ./Protein_seqs/*.faa
do
  echo ./BLASTp_dbs/"$(basename -- ${DB%.faa})"_BLASTp
  makeblastdb -in $DB -dbtype prot -out ./BLASTp_dbs/"$(basename -- ${DB%.faa})"_BLASTp
  for Q in ./Protein_seqs/*.faa
  do
    if [ "$Q" != "$DB" ]
    then
      echo "$(basename -- ${Q%.faa})"__"$(basename -- ${DB%.faa})"
      blastp -query $Q -db ./BLASTp_dbs/"$(basename -- ${DB%.faa})"_BLASTp -num_threads 4 \
        -outfmt "7 qacc sacc evalue bitscore pident qcovs" -max_target_seqs 1 > ./BLASTp_res/"$(basename -- ${Q%.faa})"__"$(basename -- ${DB%.faa})"__blast.out
      python ./scripts/recip_best_blast_hits_parsing.py -i ./BLASTp_res/"$(basename -- ${Q%.faa})"__"$(basename -- ${DB%.faa})"__blast.out \
        -o ./BLASTp_res/"$(basename -- ${Q%.faa})"__"$(basename -- ${DB%.faa})"__blast.csv -q "$(basename -- ${Q%.faa})" -s "$(basename -- ${DB%.faa})"
    fi
  done
done

python ./scripts/recip_best_blast_hits_combine.py -i "./BLASTp_res/*__blast.csv" -o ./BLASTp_res/combined_recip_bbh.csv
