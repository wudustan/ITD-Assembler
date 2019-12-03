import Control.Monad
import System.IO
import Data.Char
--import System.Random
--import System
import System.Environment
import Data.List
import Control.Concurrent 
import Data.Maybe
import Data.List

splitOn :: String -> Char -> [String]
splitOn [] delim = [""]
splitOn (c:cs) delim
                   | c == delim = "" : rest
                   | otherwise = (c : head rest) : tail rest   where
                     rest = splitOn cs delim

main :: IO ()
main = do 
       [f,g1,cut] <-getArgs
       outh <- openFile g1  WriteMode
       inh <-openFile  f  ReadMode
       mainloop inh outh (read(cut)::Int)
       hClose outh
       hClose inh 
       

find_bool_res::String->Int->Int->Bool 
find_bool_res xs i cut = ((length((splitOn xs ':')!!2) + i)>cut)



mainloop::Handle->Handle->Int->IO()
mainloop inh outh cut=  do ineof <- hIsEOF inh
                           if ineof
                           then return ()
                             else do hFlush outh
                                     takestring1<-hGetLine inh
                                     let in_filter=(words takestring1)
                                     let bool_res=(find_bool_res (in_filter!!0) (read(in_filter!!3)::Int) cut)
                                     if ((read(in_filter!!2)::Float)>95.00)&&bool_res&&((read(in_filter!!3)::Float)> ((read(head(splitOn (in_filter!!0) ':'))::Float)*(read(in_filter!!2)::Float)/100.00)-(2::Float))    
                                      then 
                                          if ((read(in_filter!!8)::Int) < (read(in_filter!!9)::Int))
                                           then do hPutStrLn outh ("chr"++(in_filter!!1)++"\t"++(in_filter!!8)++"\t"++(in_filter!!9)++"\t"++(in_filter!!0))
                                                   mainloop inh outh cut
                  			      else do hPutStrLn outh ("chr"++(in_filter!!1)++"\t"++(in_filter!!9)++"\t"++(in_filter!!8)++"\t"++(in_filter!!0)) 
                                                      mainloop inh outh cut  
                                          else mainloop inh outh cut  

