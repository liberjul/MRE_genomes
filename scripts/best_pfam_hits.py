import json, os
pfam_dict = {}
pfam_set = set()
with open("../Pfam_res/hits_eval_under_1e-2.out", "r") as ifile:
    line = ifile.readline()
    while line != "":
        if line[:2] == "..":
            species = line.strip("../Pfam_res/").split(".")[0]
        else:
            pf, gene, e = line.split(" ")
            pfam_dict[F"{species}:{gene}"] = pf.split(".")[0]
            pfam_set.add(pf.split(".")[0])
        line = ifile.readline()
with open("../Pfam_res/pfam_dict.json", "w") as ofile:
    json.dump(pfam_dict, ofile)
pfam_list = list(pfam_set)
print("Number of Pfam entries: ", len(pfam_list))
pfam_to_ip = {}
for pf in pfam_list:
    os.system(F"curl https://www.ebi.ac.uk/interpro/api/entry/pfam/{pf} > pf_entries.json")
    with open("pf_entries.json", "r") as ifile:
        pf_entry_dict = json.load(ifile)
        pfam_to_ip[pf] = pf_entry_dict["metadata"]["integrated"]
with open("../Pfam_res/pfam_to_ip.json", "w") as ofile:
    json.dump(pfam_to_ip, ofile)
