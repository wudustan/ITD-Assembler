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



findN::String->Int
findN x= (length(filter (=='N') x))


main :: IO ()
main = getArgs >>=parse


parse[]= usage >>exit
parse["-h"]=usage>>exit
parse fs =if (length(fs)==6)
              then run_20_90 (fs!!0) (read(fs!!1)::Int) (read(fs!!2)::Int) (fs!!3) (fs!!4) (fs!!5)
              else usage >>exit

usage=putStrLn "Usage : ./iterate_on_bins output_dir max_bin min_bin kmer cov_cut_min cov_cut_max">>putStrLn "The arguments should be in the order mentioned above">>putStrLn "All the paths should be complete and no trailing backslashes "
exit =exitWith ExitSuccess



run_20_90::String->Int->Int->String->String->String->IO()
run_20_90  home i g  kmer c_min c_max= if (i==g) 
                                               then return() 
                                              else do 
                                               createDirectoryIfMissing True (home++"/"++show(i)++"_cluster")
                            		       let log_file=(home ++"/global/global_log.txt")
                                               let extract_reads=("cat "++home++"/global/cluster_N_fq_reads.txt"++" | grep \"^"++show(i)++"\" >"++home++"/"++show(i)++"_cluster/"++show(i)++"_reads.txt")
                                               exitId<-system extract_reads
                                               let this_dir=(home++"/"++show(i)++"_cluster")
                                               setCurrentDirectory this_dir
                                               exitId<-system(path++"/bin/make_fq "++this_dir++"/"++show(i)++"_reads.txt"++" "++this_dir++"/"++show(i)++"_reads.fq")
                                               exitId<-system(path++"/bin/all_complement "++this_dir++"/"++show(i)++"_reads.fq "++this_dir++"/both_reads.txt")
                                               exitId<-system(path++"/bin/find_kmers_2_latest"++" "++this_dir++"/both_reads.txt "++kmer++" "++this_dir++" "++c_min++" "++c_max)
                                               appendFile log_file (path++"\n:finished bucket "++show(i)++"\n")
                                               exitId<-system("cat adjacency_matrix.txt |grep -v \"Nothing\"|awk '{print $2\" \"$4}' >adjacency_matrix_1.txt")
                                               contentb<-readFile ("filter_sorted_kmer_frequency.txt")
                                               appendFile log_file ("starting to compute cycles...\n")
                                               exitid<-system(path++"/bin/compute_cycles adjacency_matrix_1.txt "++show(length(lines(contentb)))++" out_run.txt "++show(i)++" >first_run.txt")
                                               content1<-system(path++"/bin/extract_kmers_latest "++this_dir++"/filter_sorted_kmer_frequency.txt "++this_dir++"/"++"out_run.txt "++this_dir++"/in_hap_pipeline.txt")
                                               content1<-system(path++"/bin/fastq_line_2 "++this_dir++"/"++show(i)++"_reads.fq "++this_dir++"/lined_reads.fq")
                                               content1<-system(path++"/bin/grep_reads "++this_dir++"/lined_reads.fq "++this_dir++"/in_hap_pipeline.txt "++this_dir++"/out_phrap_reads.txt")
                                               content1<-system("sort "++this_dir++"/out_phrap_reads.txt "++"-o "++this_dir++"/s_out_phrap_reads.txt")
                                               content1<-system(path++"/bin/make_unique "++this_dir++"/s_out_phrap_reads.txt "++this_dir++"/u_out_phrap_reads.txt ")
                                               content1<-system(path++"/bin/make_fq_pipeline "++this_dir++"/u_out_phrap_reads.txt "++this_dir++"/u_out_phrap_reads.fq")
                                               appendFile log_file "starting to phrap....\n"
                                               content1<-system(phrap++" -ace "++this_dir++"/u_out_phrap_reads.fq")
                                               run_20_90 home (i-1) g kmer c_min c_max 
                                                
