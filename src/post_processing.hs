
{-
Copyright (C) 2014  Navin Rustagi(navin.rustagi@gmail.com)

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
-}


import System.IO
import Data.Char
--import System.Random
--import System
import System.Environment
import Data.List
import Control.Concurrent
import System.Directory
import System.Process
import System.Exit


iterate_on_bins::Int->Int->String->String->IO()
iterate_on_bins x y z results= if (x <y)
                               then return() else do exitID<-system ("cat "++z++"/"++show(x)++"_cluster/*.contigs >>"++z++"/"++results++"/all_contigs.txt")
                                                     iterate_on_bins (x-1) y z results 


main = getArgs >>=parse --f=directory where you want processing to happen, g is the bam file, c is N_cutoff,kmer=p_kmer value, path is the path of the executable.  
       --mainloop f g (read(c)::Int) (read(kmer)::Int)  


parse[]= usage >>exit
parse["-h"]=usage>>exit
parse fs =if (length(fs)==6)
              then run_phrap (fs!!0) (fs!!1) (fs!!2) (fs!!3) (read(fs!!4)::Int) (read(fs!!5)::Int)
              else usage >>exit

usage=putStrLn "Usage : ./post_processing  output_dir results_dir_name annotation_bed_file cutoff min_bin  max_bin">>putStrLn "The arguments should be in the order mentioned above">>putStrLn "All the paths should be complete and no trailing backslashes "
exit =exitWith ExitSuccess




run_phrap::String->String->String->String->Int->Int->IO()
run_phrap path results annot cutoff min max= do
                               let ref_results=(path++"/"++results)
                               createDirectoryIfMissing True  (path++"/"++results++"/") 
                               iterate_on_bins max min path results
                               exitid<-system(exec_path++"/bin/make_results_line_2 "++path++"/"++results++"/all_contigs.txt "++path++"/"++results++"/pre_l_results.fa.contigs")
                               exitid<-system(blastn++" -db "++bdir++" -query "++path++"/"++results++"/pre_l_results.fa.contigs "++"-out "++path++"/"++results++"/f_original_contigs.fa -outfmt 6 -max_target_seqs 1")
                               exitid<-system(exec_path++"/bin/rem_ref_contigs "++path++"/"++results++"/f_original_contigs.fa "++path++"/"++results++"/f_l_results.fa.contigs")  
                               exitid<-system(exec_path++"/bin/make_results_line "++path++"/"++results++"/all_contigs.txt "++path++"/"++results++"/l_results.fa.contigs")
                               exitid<-system(exec_path++"/bin/dup_rem_first "++path++"/"++results++"/l_results.fa.contigs "++path++"/"++results++"/f_l_results.fa")
                               exitid<-system("cat "++exec_path++"/empty.txt >>"++path++"/"++results++"/f_l_results.fa")
                               --exitid<-system(exec_path++"/bin/d_complement "++path++"/f_l_results.fa "++path++"/w_f_l_results.fa")
                               exitid<-system(blastn++" -db "++bdir++" -query "++path++"/"++results++"/f_l_results.fa "++"-out "++path++"/"++results++"/blast_f_l_results.fa -outfmt 6 -max_target_seqs 1")
                               exitid<-system(exec_path++"/bin/filter_frm_blast "++path++"/"++results++"/blast_f_l_results.fa "++path++"/"++results++"/f_results.bed "++cutoff)
                               exitid<-system(intersectBed++" -a "++path++"/"++results++"/f_results.bed "++"-b "++annot++" -wa -wb >"++path++"/"++results++"/pre_f_results.bed")
                               exitid<-system(pythoncmd++" "++exec_path++"/bin/filter_frm_bed.py "++ref_results++" "++show(max))
                               return()         
      
