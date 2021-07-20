import json, os
if os.path.exists("../Pfam_res/interpro2go.json"):
    with open("../Pfam_res/interpro2go.json", "r") as ifile:
        ip2go_dict = json.load(ifile)
else:
    ip2go_dict = {}
    with open("../Pfam_res/interpro2go.txt", "r") as ifile:
        line = ifile.readline()
        while line[0] == "!":
            line = ifile.readline()
        while line != "":
            ip_term = line.split(":")[1].split(" ")[0]
            go_desc, go_term = line.split(" > ")[1].strip().split(" ; ")
            if ip_term in ip2go_dict.keys():
                ip2go_dict[ip_term].append([go_desc, go_term])
            else:
                ip2go_dict[ip_term] = [[go_desc, go_term]]
            line = ifile.readline()
    with open("../Pfam_res/interpro2go.json", "w") as ofile:
        json.dump(ip2go_dict, ofile)
