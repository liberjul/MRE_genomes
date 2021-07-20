import sys
thresh = 1
e_val = 0
hits = set()
hmm_out = open(sys.argv[1] + ".out", "r")
line = hmm_out.readline()
while "E-value" not in line:
	line = hmm_out.readline()
for _ in range(2):
	line = hmm_out.readline()
while e_val < thresh and "#" not in line:
	spl_line = line.strip(" ").split(" "*12)
	print(spl_line)
	hits.add(spl_line[0].split(" ")[0])
	#e_val = float(spl_line[2].strip(" ").split(" ")[0])
	line = hmm_out.readline()
hmm_out.close()
#print(hits, len(hits))
if len(sys.argv) == 2:
	in_fa = open(sys.argv[1], "r")
else:
	in_fa = open(sys.argv[2], "r")
line = in_fa.readline()
hit_num = len(hits)
out_file = open("top_hits_" + sys.argv[1] + ".fa", "w")
count = 0
non_match = 0
while line != "" and count < hit_num:
	name = line.strip("\n")[1:].split(" ")[0]
	print(name)
	if name in hits:
		count += 1
		out_file.write(line)
		line = in_fa.readline()
		while line[0] != ">":
			out_file.write(line)
			line = in_fa.readline()
	else:
		line = in_fa.readline()
		while line != "" and line[0] != ">":
			line = in_fa.readline()
in_fa.close()
out_file.close()
