import argparse, os
from Bio.Seq import Seq

fold = 60

def gff_line_to_list(line):
    split = line.split("\t")
    scaf, start, stop, dir = split[0], int(split[3]), int(split[4]), split[6]
    descr = split[8]
    id = descr.split(";")[0].split("=")[1]
    return id, [scaf, start, stop, dir]

parser = argparse.ArgumentParser(description="Takes FASTA and GFF and outputs CDS files")
parser.add_argument("-o",
                    "--fo",
                    help="Output file for CDS sequences, in FASTA format",
                    type=str)
parser.add_argument("-g",
                    "--gff",
                    help="Input file for CDS indexes, in GFF format",
                    type=str)
parser.add_argument("-f",
                    "--fi",
                    help="Input file for genomic sequences, in FASTA format",
                    type=str,
                    default=None)
args = parser.parse_args()

cds_dict = {}
scaf_dict = {}
with open(args.gff, "r") as gff:
    line = gff.readline()
    while line[0] == '#':
        line = gff.readline()
    while line[0] != '#':
        id, cds_dat = gff_line_to_list(line)
        cds_dict[id] = cds_dat
        line = gff.readline()
    if args.fi == None:
        line = gff.readline()
        while line != "":
            header = line[1:-1]
            seq = ""
            line = gff.readline()
            while line != "" and line[0] != ">":
                seq += line.strip()
                line = gff.readline()
            scaf_dict[header] = seq
    else:
        with open(args.fi, "r") as gff:
            line = gff.readline()
            while line != "":
                header = line[1:-1]
                seq = ""
                line = gff.readline()
                while line[0] != ">":
                    seq += line.strip()
                    line = gff.readline()
                scaf_dict[header] = seq

buffer = ""
for i in sorted(cds_dict.keys()):
    scaf, start, stop, dir  = cds_dict[i]
    scaf_seq = scaf_dict[scaf]
    cds = scaf_seq[int(start - 1): int(stop)]
    if dir == "-":
        cds_seq = Seq(cds)
        cds = str(cds_seq.reverse_complement())
    buffer += F">{i}\n"
    out = 0
    while out < len(cds):
        buffer += F"{cds[out:out+fold]}\n"
        out += 60
with open(args.fo, "w") as ofile:
            ofile.write(buffer)
