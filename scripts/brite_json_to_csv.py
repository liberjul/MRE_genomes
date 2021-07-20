import glob, os, json
import pandas as pd
import numpy as np
with open("../KEGG_Res/ko_dict.json", "r") as ifile:
    ko_dict = json.load(ifile)
with open("../KEGG_Res/brite_names.json", "r") as ifile:
    brite_names = json.load(ifile)
files = glob.glob("../KEGG_Res/*_res.txt.csv")
buffer = ""
with open("../KEGG_res/brite_combined_counts.csv", "w") as ofile:
    ofile.write("Species,Brite,Br_name,Level,Count\n")
    for i in files:
        species = os.path.basename(i).split("_Kofam")[0]
        ko_dat = pd.read_csv(i)
        for lev in [1,2,3]:
            br_count_dict = {}
            for a in ko_dat.KO_annot:
                br_annot = ko_dict[a.strip()]
                br = br_annot[0][lev-1]
                if br in br_count_dict.keys():
                    br_count_dict[br] += 1
                else:
                    br_count_dict[br] = 1
            for a in br_count_dict.keys():
                buffer += F"{species},{a},{brite_names[a]},{lev},{br_count_dict[a]}\n"
    ofile.write(buffer)
