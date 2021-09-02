#!/usr/bin/env python

import sys, argparse, os, glob

parser = argparse.ArgumentParser()
parser.add_argument("-i", "--in_file_wildcard", type=str, help="CSV BLAST results file")
parser.add_argument("-o", "--out_file", type=str, help="Output file for reciprocal best blast hits")
args = parser.parse_args()

files = glob.glob(args.in_file_wildcard)

hit_dict = {}
for i in files:
    with open(i, "r") as ifile:
        line = ifile.readline()
        while line != "":
            line = ifile.readline()
            spl = line.strip().split(",")
            quer_pair = (spl[0], spl[2])
            subj_pair = (spl[1], spl[3])
            info_list = spl[4:]
            hit_dict[(quer_pair, subj_pair)] = info_list
            line = ifile.readline()
buffer = "query_genome,subject_genome,query_gene_acc,subject_gene_acc,bitscore_qs,e_value_qs,percent_identity_qs,query_coverage_qs,bitscore_sq,e_value_sq,percent_identity_sq,query_coverage_sq\n"
for key in hit_dict.keys():
    if key[::-1] in hit_dict:
        info_str_qs = ",".join(hit_dict[key])
        info_str_sq = ",".join(hit_dict[key[::-1]])
        buffer = F"{buffer}{key[0][0]},{key[1][0]},{key[0][1]},{key[1][1]},{info_str_qs},{info_str_sq}\n"

with open(args.out_file, "w") as ofile:
    ofile.write(buffer)
