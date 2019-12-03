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
import Data.Function
import System.Process
import System.Exit

splitOn :: String -> Char -> [String]
splitOn [] delim = [""]
splitOn (c:cs) delim
                   | c == delim = "" : rest
                   | otherwise = (c : head rest) : tail rest   where
                     rest = splitOn cs delim

main :: IO ()
main = do 
       [f,g1] <-getArgs
       outh <- openFile g1  WriteMode
       inh <-openFile  f  ReadMode
       mainloop inh outh
       hClose outh
       hClose inh 
       

find_bool_res::String->Int->Bool 
find_bool_res xs i = if (((fromIntegral i)/(fromIntegral (length((splitOn xs ':')!!1))))>0.95) then True else False 



mainloop::Handle->Handle->IO()
mainloop inh outh =  do ineof <- hIsEOF inh
                        if ineof
                           then return ()
                             else do hFlush outh
                                     takestring1<-hGetLine inh
                                     let in_filter=(words takestring1)
                                     let bool_res=(find_bool_res (in_filter!!0) (read(in_filter!!3)::Int))
                                     if ((read(in_filter!!2)::Float)>95.00)&&bool_res     
                                      then  
                                           do   
                                               hPutStrLn  outh (">"++((splitOn (in_filter!!0) ':')!!0))
                                               hPutStrLn  outh ((splitOn (in_filter!!0) ':')!!1)
                                               mainloop inh outh  
                                      else mainloop inh outh

