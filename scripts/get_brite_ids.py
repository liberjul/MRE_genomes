import os
def get_brites(filename):
    os.system("bash br_extract.sh " + filename)
    br_list = []
    br_name_dict = {}
    with open("temp_br.csv", "r") as ifile:
        lines = ifile.readlines()
        cur_ind = 100
        cur_list = []
        for i in lines:
            #print(i)
            ind, br = i.strip().split(",")[:2]
            br_name = "".join(i.strip().split(",")[2:])
            br_name_dict[br] = br_name
            ind = int(ind)
            if ind < cur_ind: # If higher level annotation, export if not the first, then change to only current annotation
                cur_ind = ind
                if len(cur_list) != 0:
                    br_list.append(cur_list)
                if cur_ind == 13:
                    cur_list = [br]
                else:
                    cur_list = cur_list[:(cur_ind-13)]
                    cur_list.append(br)
            elif ind == cur_ind: # If same level annotation, export the current list
                cur_ind = ind
                br_list.append(cur_list.copy())
                cur_list[-1] = br
            else: # If lower level annotation, add to the current list
                cur_ind = ind
                cur_list.append(br)
        br_list.append(cur_list)
    return br_list, br_name_dict
