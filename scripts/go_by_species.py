import json
with open("../Pfam_res/pfam_dict.json", "r") as ifile:
    pfam_dict = json.load(ifile)
with open("../Pfam_res/pfam_to_ip.json", "r") as ifile:
    pfam_to_ip = json.load(ifile)
with open("../Pfam_res/interpro2go.json", "r") as ifile:
    interpro2go = json.load(ifile)
go_by_species = {}
for gene in pfam_dict.keys():
    species = gene.split(":")[0]
    if species not in go_by_species.keys():
        go_by_species[species] = {}
    pf = pfam_dict[gene]
    ip = pfam_to_ip[pf]
    if ip in interpro2go.keys():
        for go in interpro2go[ip]:
            if go[1] not in go_by_species[species].keys():
                go_by_species[species][go[1]] = [go[0], 1]
            else:
                go_by_species[species][go[1]][1] += 1
buffer = "Species\tGO_term\tGO_description\tCount\n"
for sp in go_by_species.keys():
    for go in go_by_species[sp].keys():
        go_descr, count = go_by_species[sp][go]
        go_descr = go_descr[3:].replace("\t", " ").replace(",", "")
        buffer += F"{sp}\t{go}\t{go_descr}\t{count}\n"
with open("../Pfam_res/go_by_species.tsv", "w") as ofile:
    ofile.write(buffer)
