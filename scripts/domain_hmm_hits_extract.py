import os, sys, argparse
import numpy as np

def convert_rec_line(rec_line):
    rec_spl = rec_line.split(" ")
    rec_spl = list(filter(("").__ne__, rec_spl))
    target = rec_spl[0]
    start, stop = rec_spl[17:19]
    return  [target, int(start), int(stop)]

parser = argparse.ArgumentParser()
parser.add_argument("-i", "--in_file", type=str, help="basename of hmmsearch domtblout file")
parser.add_argument("-o", "--out_path", type=str, help="path to fasta output", default="./")
args = parser.parse_args()

seq_dict = {}
with open(args.in_file, "r") as seqf:
    line = seqf.readline()
    while line != "":
        header = line[1:].strip().split(" ")[0]
        line = seqf.readline()
        seq = ""
        while line != "" and line[0] != ">":
            seq += line.strip()
            line = seqf.readline()
        seq_dict[header] = seq
    print("Number of seqs: ", len(seq_dict.keys()))

buffer = ""
with open(F"{args.in_file}.out", "r") as ifile:
    line = ifile.readline()
    print(line)
    while line != "" and line[0] == "#":
        line = ifile.readline()
    count = 0
    while line != "" and line[0] != "#":
        count += 1
        print(line)
        target, start, stop = convert_rec_line(line)
        print(target, start, stop)
        print(seq_dict[target][start - 1: stop])
        buffer += F">{args.in_file.strip('_genomic.fna')}_16S_{count}\n{seq_dict[target][start - 1: stop]}\n"
        line = ifile.readline()

with open(F"{args.out_path}{args.in_file}.16S.fa", "w") as ofile:
    ofile.write(buffer)
