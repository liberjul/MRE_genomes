paste -d, <(grep ' [0-9]\{5\} ' $1 |awk -F'[^ ]' '{print length($1)}') <(grep -o ' [0-9]\{5\} ' $1 | cut -d ' ' -f 2) <(grep -o ' [0-9]\{5\} .*' $1 | cut -d " " -f 3-) > temp_br.csv
