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

splitOn :: String -> Char -> [String]
splitOn [] delim = [""]
splitOn (c:cs) delim
   | c == delim = "" : rest
   | otherwise = (c : head rest) : tail rest
   where
       rest = splitOn cs delim

findN::String->Int
findN x= (length(filter (=='N') x))

--f is the directory which will have all the bins . g will contain the path to the unused reads. 
main :: IO ()
main = getArgs >>=parse --f=directory where you want processing to happen, g is the bam file, c is N_cutoff,kmer=p_kmer value, path is the path of the executable.  
       --mainloop f g (read(c)::Int) (read(kmer)::Int)  


parse[]= usage >>exit
parse["-h"]=usage>>exit
parse fs =if (length(fs)==4)
              then mainloop (fs!!0) (fs!!1) (read(fs!!2)::Int) (read(fs!!3)::Int)
              else usage >>exit

usage=putStrLn "Usage : ./cluster_bins output_dir input_bam c pkmer">> putStrLn "c: is the integer cutoff for filtering out a read if it has  c 'N's or more" >>putStrLn "pkmer  : Integer value for the partial duplication parameter ">>putStrLn "The arguments should be in the order mentioned above">>putStrLn "All the paths should be complete and no trailing backslashes " 
exit =exitWith ExitSuccess


mainloop ::String->String->Int->Int->IO ()
mainloop patient bfile c kmer =do
                                 let main_dir=(patient++"/global")
                                 let log_file=(main_dir ++"/global_log.txt")
                                 let samtools=samt++" view -b -f 4 "
                                 createDirectoryIfMissing True main_dir 
                                 let samcommand1=(samtools++bfile++ " > "++patient++"/global/temp.bam")
                                 putStrLn ("creating a bam file with unused reads with name "++patient++"/global/temp.bam")
                                 exitId<-system samcommand1 
                                 let bamtools=(bamt++" convert  -in ")
                                 let bcommand=(bamtools++patient++"/global/temp.bam -format fastq"++" >"++patient++"/global/"++"unused_reads.fq" )
                                 putStrLn ("extracting reads from temp.bam. check for progress  in "++patient++"/global/global_log.txt") 
                                 exitID<-system bcommand
                                 writeFile log_file "making fq files from unused reads....\n"  
                                 let fastq2fq=path++"/bin/fq2fasta"
                                 let unused=patient++"/global/unused_reads.fq" 
                                 let command1=(fastq2fq++" "++unused++" "++main_dir++"/fq_reads.fq" )
                                 exitId<-system command1
                                 appendFile log_file "Filtering N's out of the file......\n"  
                                 let ncommand=(path++"/bin/filterN")
                                 let ncommand1=(ncommand++" "++main_dir++"/fq_reads.fq "++main_dir++"/"++"N_fq_reads.fq "++show(c))
                                 exitId<-system ncommand1 
                                 appendFile log_file "Preparing inputfile for binning.......\n"
                                 let find_dup=(path++"/bin/cluster_dup_first")      
                                 let p_dup=(find_dup++" "++main_dir++"/N_fq_reads.fq "++main_dir++"/cluster_N_fq_reads.txt "++show(kmer))
                                 exitId<-system p_dup
                                 appendFile log_file "extracting softclipped reads \n"   
                                 let extract_reads=(pythoncmd++" "++path++"/bin/extract_soft_clip.py "++bfile++" >"++patient++"/global/pre_sclip_reads.txt")
                                 exitId<-system extract_reads 
                                 let putinto_cluster=(path++"/bin/cluster_sclip "++patient++"/global/pre_sclip_reads.txt "++main_dir++"/cluster_N_fq_reads.txt") 
                                 exitId<-system(putinto_cluster)
                                 appendFile log_file "finished bin identification!\n"
                                 return()

