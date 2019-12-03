Readme  
-------------- 

The following softwares are needed for ITDASM to execute,

samtools 
bamtools 
python  
blastn 
intersectBed
phrap
GHC platform latest version. 

Notes
--pysam library required for python.(it is available in python 2.7+ ) 
-- gsl and gslcblas required for execution.   


Installation instructions 
-------------------------
1) Download the directory and unzip it 
2) Edit config.txt with suitable path names of utilities mentioned above. 
3) >./install.sh 

Notes 
--if there is a C Compilation error because of -lgsl and -lgslcblas please edit the install.sh file with appropriate path names in the line starting with gcc.  
-- please have ghc in your bin directory or edit the install.sh with appropriate path names.  

Execution flow Example
------------------------
There are four executables which are created in the home directory for ITDASM called cluster_bins, iterate_on_bins, iterate_on_bins_light, post_processing. Please use -h option to see the arguments for each of the executables. 

Flow :  cluster_bins->(iterate_on_bins_light/iterate_on_bins)->post_processing 

Notes:  A sample bed file called ref_baylor_main.bed has been released with this version  which contains annotated genes with gene coordinates.
Notes:The results of the calling are in a custom and self explanatory file format in a user specifed directory in the post Processing stage. The ace files and phrap generated contigs for a bin are in that bin.   


Contact :All questions should be directed to navin.rustagi@gmail.com or rustagi@bcm.edu --last edited Saturday 3:39 am on Novemver 22 
  
