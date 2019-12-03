import os 
import math 
import sys, string, os


in_fname=sys.argv[1]
max_n=sys.argv[2] 

fin=open((in_fname+"/f_l_results.fa.contigs"),"r") 
db_contigs=[]
for f in fin: 
   if (f[0]==">"):
      db_contigs.insert(0,("/".join((f[:-1].split("/"))[-3:])))
      #print db_contigs 
      #break;


fbed=open((in_fname+"/pre_f_results.bed"),"r") 
fout=open((in_fname+"/results_final.txt"),"w") 
fout.write("chr	start_contig_coordinate	stop_contig_coordinate	gene	Tandem_duplication	Tandem_duplication_length	tandem_duplication_start_position_in_contig	contig_path   info_bed")
fout.write("\n") 

for g in fbed: 
    s_term=("/".join((g[:-1].split("\t")[3]).split("/")[-3:]))
    if s_term in db_contigs:
        #print s_term
        continue; 
    else: 
       words=g[:-1].split("\t")
       #b_int=int(words[1])
       info=words[3].split(":")
       #mark_b=(b_int + int(info[1]))
       #mark_b_e=mark_b +len(info[2])
       #if ((int(words[-3])<=mark_b) and (mark_b<=int(words[-2]))) or ((int(words[-3])<=mark_b_e) and (mark_b_e<=int(words[-2]))): 
       if (len(info[2])<(int(max_n)+1)):
            fout.write(words[0]+"\t"+words[1]+"\t"+str(int(words[2])+int(info[0]))+"\t"+words[7]+"\t"+info[2]+"\t"+str(len(info[2]))+"\t"+info[1]+"\t"+info[-1]+"\t"+words[-1])
            fout.write("\n") 
   #print s_term 


