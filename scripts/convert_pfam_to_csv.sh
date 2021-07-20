> ../Pfam_res/hits_eval_under_1e-2.out
for f in $1/*_pfam_tbl.txt
do
  echo $f >> ../Pfam_res/hits_eval_under_1e-2.out
  tac $f | grep -v '^#' | awk '{if($5 < 0.01) print $2,$3,$5}' >> ../Pfam_res/hits_eval_under_1e-2.out
done
