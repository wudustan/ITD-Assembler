import os 
import zlib 
import pysam 
import sys, string, os



in_fname=sys.argv[1]


samfile=pysam.Samfile(in_fname,"rb")

for alignedread in samfile.fetch():
	if (alignedread.is_unmapped==False):
            if ((alignedread.cigar[0][0]==4)^(alignedread.cigar[-1][0]==4)): 
               if ((alignedread.cigar[0][0]==4)&(alignedread.cigar[0][1]>4)):
                  print (str(alignedread.cigar[0][1])+':>'+alignedread.qname) 
                  print alignedread.seq 
               elif ((alignedread.cigar[-1][0]==4)&(alignedread.cigar[-1][1]>4)):
                  print (str(alignedread.cigar[-1][1])+':>'+alignedread.qname) 
                  print alignedread.seq
             
              
