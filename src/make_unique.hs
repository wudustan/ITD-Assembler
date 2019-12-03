import Control.Monad
import System.Environment
import Data.List as A
import Data.Int 
--import System.Process
import System.Directory
--import System.Process
import System.IO
--import System
import System.Process
import System.Exit

complement :: Char -> Char
complement g = case g of {'A' -> 'T'; 'T' -> 'A'; 'a' -> 't'; 't' -> 'a'; 'C' -> 'G'; 'G' -> 'C'; 'c' -> 'g'; 'g' -> 'c'; 'N'->'N'}

rev_complement::String->String
rev_complement xs = (map complement (reverse (xs)))


output_reads::[String]->[String] 
output_reads []=[] 
output_reads xs = (map (\x->head(x)) (group xs)) 




main :: IO () --Start of the program
main= do 
           [db,path_out]<-getArgs
           database<-readFile db 
           mainloop (lines (database)) path_out 



mainloop::[String]->String->IO () 
mainloop database p = writeFile p (unlines (output_reads database))  
                            
                                
                                  
                                                
                                                
