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

splitOn :: String -> Char -> [String]
splitOn [] delim = [""]
splitOn (c:cs) delim
                   | c == delim = "" : rest
                   | otherwise = (c : head rest) : tail rest   where
                     rest = splitOn cs delim



findN::String->Int 
findN x= (length(filter (=='N') x))

maincompute::String->Int->[Int] 
maincompute xs kmer= if ((take kmer xs)==['N'|i<-[1..kmer]]) then [] else (tail((map (\x->snd(x)) (filter (\x->(fst(x)==(take kmer xs)))   (break_str xs kmer 0))))) 


sort_second::[(String,Int)]->[(String,Int)]
sort_second []=[]
sort_second (x:xs)= sort_second small ++mid ++ sort_second large 
  where 
      small=[y|y<-xs,snd(y)<snd(x)]
      mid   = [y | y<-xs, snd(y)==snd(x)] ++ [x]
      large = [y | y<-xs, snd(y)>snd(x)]

break_str::String->Int->Int->[(String,Int)]
break_str xs kmer count= if ((length xs)==kmer) then [] else (((take kmer xs),count):(break_str (tail xs) kmer (count +1)))  

q_sort_str::[(String,Int)]->[(String,Int)] 
q_sort_str []=[]
q_sort_str (x:xs) = q_sort_str small ++ mid ++ q_sort_str large
   where
      small = [y | y<-xs, fst(y)<fst(x)]
      mid   = [y | y<-xs, fst(y)==fst(x)] ++ [x]
      large = [y | y<-xs, fst(y)>fst(x)]



grp_disdup::(String,Int)->(String,Int)->Bool 
grp_disdup (x,i) (y,j)=(x==y)

flt_disdup::[[(String,Int)]]->[Int]
flt_disdup []=[]
flt_disdup (x:xs)= if ((length(x)>=2)) then ((snd(head(tail x))-snd((head(x)))):(flt_disdup xs)) else (flt_disdup xs)

br_2::[(String,Int)]->[[(String,Int)]]
br_2 []=[]
br_2 (x:[])=(((x:x:[])):[])
br_2 (x1:x2:xr)=((((x1):(x2):[]):[])++(br_2 (tail (x1:x2:xr))))


make_unique::[Int]->[Int] 
make_unique  xs= (map (\x->head(x)) (group xs)) 



main :: IO ()
main = do 
       [f,g1] <-getArgs
       inh <- openFile f ReadMode
       outh <- openFile g1  AppendMode
       takeString1<-hGetLine inh 
       takeString2<-hGetLine inh
       mainloop inh outh 
       hClose inh
       hClose outh

       

max_n::Int->Int->Int 
max_n plen 10 = if (plen >10 ) then 10 else plen 



mainloop ::Handle -> Handle ->IO ()
mainloop inh outh =
                   do ineof <- hIsEOF inh
                      if ineof
                          then return ()
                             else do takestring1<-hGetLine inh
                                     takestring2<-hGetLine inh 
                                     let plen=(read(head(splitOn takestring1 ':'))::Int)
                                     let pstring=concat(tail(splitOn takestring1 ':'))     
                                     let retvalue=(maincompute takestring2 (max_n plen 10) )
                                     if (retvalue ==[])
                                       then mainloop inh outh 
                                        else  do 
                                                hPutStrLn outh (unlines (map (\x->(show(x)++" "++">"++tail(pstring)++"  "++takestring2)) (make_unique (sort retvalue))))
                                                mainloop inh outh            





