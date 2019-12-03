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

main = getArgs >>=parse --f=directory where you want processing to happen, g is the bam file, c is N_cutoff,kmer=p_kmer value, path is the path of the executable.  
       --mainloop f g (read(c)::Int) (read(kmer)::Int)  


parse[]= usage >>exit
parse["-h"]=usage>>exit
parse fs =if (length(fs)==3)
              then run_20_90 (fs!!0) (read(fs!!1)::Int) (read(fs!!2)::Int)
              else usage >>exit

usage=putStrLn "Usage : ./iterate_on_bins_light  output_dir max_bin  min_bin">>putStrLn "The arguments should be in the order mentioned above">>putStrLn "All the paths should be complete and no trailing backslashes ">>putStrLn "All the paths should be complete and no trailing backslashes "
exit =exitWith ExitSuccess



run_20_90::String->Int->Int->IO()
run_20_90  home i g  = if (i==g) 
                                     then return() 
                                       else do createDirectoryIfMissing True (home++"/"++show(i)++"_cluster")
                            		       let log_file=(home ++"/global/global_log.txt")
                                               let extract_reads=("cat "++home++"/global/cluster_N_fq_reads.txt"++" | grep \"^"++show(i)++"\" >"++home++"/"++show(i)++"_cluster/"++show(i)++"_reads.txt")
                                               exitId<-system extract_reads
                                               let this_dir=(home++"/"++show(i)++"_cluster")
                                               setCurrentDirectory this_dir
                                               exitId<-system(path++"/bin/make_fq "++this_dir++"/"++show(i)++"_reads.txt"++" "++this_dir++"/"++show(i)++"_reads.fq")
                                               content1<-system(phrap++" -ace "++this_dir++"/"++show(i)++"_reads.fq")
                                               run_20_90 home (i-1) g  
