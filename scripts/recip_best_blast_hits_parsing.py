#!/usr/bin/env python

'''
For this type of blast command:
blastn -query <query> -db Unite_04_02_2020 -num_threads 16 -outfmt "7 qacc sacc evalue bitscore pident qcovs" -max_target_seqs 20 > <output>
'''

import sys, argparse, os

parser = argparse.ArgumentParser()
parser.add_argument("-i", "--in_file", type=str, help="blastn output file")
parser.add_argument("-o", "--out_file", type=str, help="Output file for classifications")
parser.add_argument("-q", "--query", type=str, help="Query genome name")
parser.add_argument("-s", "--subject", type=str, help="Subject genome name")
args = parser.parse_args()

with open(args.in_file, "r") as ifile:
    with open(args.out_file, "w") as ofile:
        ofile.write("query_genome,subject_genome,query_gene_acc,subject_gene_acc,bitscore,e_value,percent_identity,query_coverage\n")
    line = ifile.readline()
    rec_count = 0
    while line != "":
        buffer = ""
        while line != "" and rec_count < 10000:
            if "# Query: " in line: # Checking if hits were found
                quer = line.strip().split("Query: ")[1]
                line = ifile.readline()
                line = ifile.readline()
                # if line == "# 0 hits found\n": # If no hits found
                #     buffer = F"{buffer}{args.query},{args.subject},{quer},{'__'},{1},{0},{0.0},{0}\n" # Add dummy row to be cut out later
            elif line[0] != "#" and line != "\n": # BLAST hit lines
                spl = line.strip().split("\t")
                sub = spl[1]
                eval, bitscore, id, qcov = spl[2:]
                buffer = F"{buffer}{args.query},{args.subject},{spl[0]},{sub},{bitscore},{eval},{id},{qcov}\n"
            line = ifile.readline()
            rec_count += 1
        rec_count = 0
        with open(args.out_file, "a+") as ofile:
            ofile.write(buffer)
