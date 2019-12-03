import Control.Monad
import System.Environment
import Data.List as A
import Data.Int 
import System.Process
import System.Directory
import System.Process
import System.IO
--import System
import System.Exit

complement :: Char -> Char
complement g = case g of {'A' -> 'T'; 'T' -> 'A'; 'a' -> 't'; 't' -> 'a'; 'C' -> 'G'; 'G' -> 'C'; 'c' -> 'g'; 'g' -> 'c'; 'N'->'N'}

rev_complement::String->String
rev_complement xs = (map complement (reverse (xs)))


output_reads::[String]->String->[String] 
output_reads [] q =[] 
output_reads (x:xs) q= if ((isInfixOf q x==True) || (isInfixOf (rev_complement q) x ==True)) then (x:(output_reads xs q)) else (output_reads xs q)  




main :: IO () --Start of the program
main= do 
           [db,readin,outin]<-getArgs
           outh<- openFile outin  WriteMode
           inh <-openFile readin  ReadMode
           database<-readFile db 
           mainloop (lines (database)) inh outh 
           hClose inh 
           hClose outh



mainloop::[String]->Handle->Handle->IO () 
mainloop database inh outh =  do ineof <- hIsEOF inh
                                 if ineof
                                    then return ()
                                        else do hFlush outh 
                                                takestring1<-hGetLine inh
                                                hPutStrLn outh (concat (map (\x->(x++"\n")) (output_reads database (head(words (takestring1))))))
                                                mainloop database inh outh  
