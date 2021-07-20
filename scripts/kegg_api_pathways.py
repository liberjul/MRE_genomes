import os, glob, json
from get_brite_ids import get_brites
kegg_files = glob.glob("../KEGG_Res/*.txt.csv")
ko_dict = {}
brite_name_dict = {}
for filename in kegg_files:
    with open(filename, "r") as ifile:
        org_dict = {}
        line = ifile.readline()
        while line != "":
            print(line)
            gene, ko = line.strip().split(",")
            if ko not in ko_dict.keys():
                os.system(F"curl http://rest.kegg.jp/get/{ko} > temp.out")
                brite_list, new_brite_names = get_brites("temp.out")
                brite_name_dict.update(new_brite_names)
                ko_dict[ko] = brite_list
            else:
                brite_list = ko_dict[ko]
            org_dict[ko] = brite_list
            line = ifile.readline()
    with open("../" + filename.strip(".txt.csv") + "_brite.json", "w") as ofile:
        json.dump(org_dict, ofile, sort_keys=True, indent=4)
with open("../KEGG_Res/brite_names.json", "w") as ofile:
    json.dump(brite_name_dict, ofile, sort_keys=True, indent=4)
with open("../KEGG_Res/ko_dict.json", "w") as ofile:
    json.dump(ko_dict, ofile, sort_keys=True, indent=4)
