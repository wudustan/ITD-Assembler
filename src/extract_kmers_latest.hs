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

findN::String->Int 
findN x= (length(filter (=='N') x))


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
flt_disdup (x:xs)= if ((length(x)==2)) then (((fst(head(x)),(snd(head(tail(x)))-snd((head(x))))):[])++(flt_disdup xs)) else ((flt_disdup (br_2 x))++(flt_disdup xs))

br_2::[(String,Int)]->[[(String,Int)]]
br_2 []=[]
br_2 (x:[])=(((x:x:[])):[])
br_2 (x1:x2:xr)=((((x1):(x2):[]):[])++(br_2 (tail (x1:x2:xr))))


process_str::String->String
process_str x =(concat(map (\(x,y)->show(x)++"  "++show(y)++" ") (flt_disdup (filter (\t->(length(t)>1)) (groupBy grp_disdup (q_sort_str (break_str x 10 0)))))) )

main :: IO ()
main = do 
       [f,g1,g2] <-getArgs
       inh2<-openFile g1 ReadMode 
       outh <- openFile g2  WriteMode
       content1<-readFile f 
       mainloop (lines content1) inh2 outh
       hClose inh2
       hClose outh

       


mainloop ::[String]-> Handle -> Handle ->IO ()
mainloop db  inh outh =
                   do ineof <- hIsEOF inh
                      if ineof
                          then return ()
                             else do takestring1<- hGetLine inh
                                     hPutStrLn outh (head(words(extract_db db ((read(takestring1))::Int) 0)))
                                     mainloop db inh outh           

extract_db::[String]->Int->Int->String  
extract_db (x:xs) a b = if (b<a) then (extract_db xs a (b+1)) else x


