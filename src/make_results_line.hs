import Control.Monad
import System.IO
import Data.Char
--import System.Random
--import System
import System.Environment
import Data.List
import Control.Concurrent 
import Data.Maybe
import System.Process
import System.Exit

complement :: Char -> Char
complement g = case g of {'A' -> 'T'; 'T' -> 'A'; 'a' -> 't'; 't' -> 'a'; 'C' -> 'G'; 'G' -> 'C'; 'c' -> 'g'; 'g' -> 'c'; 'N'->'N'}

rev_complement::String->String
rev_complement xs = (map complement (reverse (xs)))



main :: IO ()
main = do 
       [f,g1] <-getArgs
       outh <- openFile g1  WriteMode
       inh <-openFile  f  ReadMode
       mainloop inh outh
       hClose outh
       hClose inh 
       


mainloop::Handle->Handle->IO()
mainloop inh outh =  do ineof <- hIsEOF inh
                        if ineof
                          then return ()
                             else do hFlush outh
                                     takestring1<-hGetLine inh
                                     takestring2<-(seek_nextline inh []) 
                                     hPutStrLn outh takestring1
                                     hPutStrLn outh (concat (lines takestring2)) 
                                     mainloop inh outh 
                                     --hPutStrLn outh takestring1
                                     --hPutStrLn outh (rev_complement(takestring2))
         

seek_nextline::Handle->String->IO String 
seek_nextline inh ls=do carrot <- (hLookAhead inh)
                        if (carrot /= ('>'))
                               then  
                                    do 
                                       n_chr<-(hGetChar inh) 
                                       end <- hIsEOF inh
                                       if end
                                        then return(ls)
                                         else seek_nextline inh  (ls ++ (n_chr:[]))
                                     else return(ls)  


