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

filterN::String->String
filterN xs= (filter (=='N') xs)



main :: IO ()
main = do 
       [f,g1,k] <-getArgs
       inh <- openFile f ReadMode
       outh <- openFile g1  WriteMode
       mainloop inh outh (read(k)::Int) 
       hClose inh
       hClose outh
       
mainloop ::Handle -> Handle ->Int->IO ()
mainloop inh outh k =
                   do ineof <- hIsEOF inh
                      if ineof
                          then return ()
                             else do takestring1<- hGetLine inh
                                     takestring2<-hGetLine inh 
                                     if (length(filterN takestring2) >k) 
                                         then mainloop inh outh k 
                                              else do hPutStrLn outh takestring1
                                                      hPutStrLn outh takestring2
                                                      mainloop inh outh k 
                   
