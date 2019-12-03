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

maincompute::String->Int->Int 
maincompute xs kmer= if ((flt_disdup(groupBy grp_disdup (q_sort_str (break_str xs kmer 0))))==[]) then 0 else (snd (head (flt_disdup(groupBy grp_disdup (q_sort_str (break_str xs kmer 0)))))) 



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

flt_disdup::[[(String,Int)]]->[(String,Int)]
flt_disdup []=[]
flt_disdup (x:xs)= if ((length(x)>=2)) then ((fst(head(x)),(snd(head(tail(x)))-snd((head(x))))):[]) else (flt_disdup xs)

br_2::[(String,Int)]->[[(String,Int)]]
br_2 []=[]
br_2 (x:[])=(((x:x:[])):[])
br_2 (x1:x2:xr)=((((x1):(x2):[]):[])++(br_2 (tail (x1:x2:xr))))


process_str::String->String
process_str x =(concat(map (\(x,y)->show(x)++"  "++show(y)++" ") (flt_disdup (filter (\t->(length(t)>1)) (groupBy grp_disdup (q_sort_str (break_str x 10 0)))))) )


main :: IO ()
main = do 
       [f,g1] <-getArgs
       inh <- openFile f ReadMode
       outh <- openFile g1  WriteMode
       mainloop inh outh
       hClose inh
       hClose outh

       


mainloop ::Handle -> Handle ->IO ()
mainloop inh outh =
                   do ineof <- hIsEOF inh
                      if ineof
                          then return ()
                             else do takestring1<- hGetLine inh
                                     takestring2<-hGetLine inh 
                                     let retvalue=(maincompute takestring2 10) 
                                     if (retvalue ==0)
                                       then mainloop inh outh 
                                        else  do 
                                                hPutStrLn outh (show(abs(retvalue)) ++" "++takestring1++"  "++takestring2)
                                                mainloop inh outh           





