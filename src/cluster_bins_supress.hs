import System.IO
import Data.Char
import System.Random
import System
import System.Environment
import Data.List
import Control.Concurrent
import System.Directory
import System.Process

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
main = do
       [f,g,path,c,kmer,path] <-getArgs
       mainloop f g  (read(c)::Int) (read(kmer)::Int) path 


mainloop ::String->String->Int->Int->String->IO ()
mainloop patient unused c kmer path=do
                                 let main_dir=(patient++"/global")
                                 let log_file=(main_dir ++"/global_log.txt")
                                 createDirectoryIfMissing True main_dir 
                                 writeFile log_file "making fq files from unused reads....\n"  
                                 let fastq2fq=path++"/bin/fq2fasta"
                                 let command1=(fastq2fq++" "++unused++" "++main_dir++"/fq_reads.fq" )
                                 exitId<-system command1
                                 appendFile log_file "Filtering N's out of the file......\n"  
                                 let ncommand=(path++"/bin/filterN")
                                 let ncommand1=(ncommand++" "++main_dir++"/fq_reads.fq "++main_dir++"/"++"N_fq_reads.fq "++show(c))
                                 exitId<-system ncommand1 
                                 appendFile log_file "Preparing inputfile for binning.......\n"
                                 let find_dup=(path++"/bin/cluster_dup_first_supress")      
                                 let p_dup=(find_dup++" "++main_dir++"/N_fq_reads.fq "++main_dir++"/cluster_N_fq_reads.txt "++show(kmer))
                                 exitId<-system p_dup
                                 return()

