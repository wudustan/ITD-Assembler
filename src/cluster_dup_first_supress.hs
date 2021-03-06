import Control.Monad
import System.IO
import Data.Char
import System.Random
import System
import System.Environment
import Data.List
import Control.Concurrent 
import Data.Maybe

findN::String->Int 
findN x= (length(filter (=='N') x))

maincompute::String->Int->[Int] 
maincompute xs kmer= if (suppress xs kmer ) then (flt_disdup (map sort_second (groupBy grp_disdup (q_sort_str (break_str xs kmer 0))))) else [] 


suppress::String->Int->Bool 
suppress xs kmer = if (length(filter (\x->(length(x)>2))  (groupBy grp_disdup (q_sort_str (break_str xs kmer 0))))>2) then False else True 

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
                                     let retvalue=(maincompute takestring2 k) 
                                     if (retvalue ==[])
                                       then mainloop inh outh k
                                        else  do 
                                                hPutStrLn outh (unlines (map (\x->(show(x)++" "++takestring1++"  "++takestring2)) (make_unique (sort retvalue))))
                                                mainloop inh outh k           





