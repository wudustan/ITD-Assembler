import Control.Monad
import System.Environment
import Data.List as A
import Data.ByteString.Lazy.Char8 as B
import Data.Int 
import System.Process
import System.Directory
import System.IO
import Data.Map as C 
import Data.Maybe

traverse_data_base::[ByteString]->ByteString->Int->Int 
traverse_data_base [] q i = (-1)
traverse_data_base (x:xs) q i= if (q==x) then i else (traverse_data_base xs q (i+1)) 


lookUp::Map ByteString Int ->(ByteString,ByteString)->String 
lookUp database (x,y)=(show(C.lookup x database )++" "++show(C.lookup y database))

complement :: Char -> Char
complement g = case g of {'A' -> 'T'; 'T' -> 'A'; 'a' -> 't'; 't' -> 'a';
                                                    'C' -> 'G'; 'G' -> 'C'; 'c' -> 'g'; 'g' -> 'c'; 'N'->'N'}

rev_complement::ByteString->ByteString
rev_complement xs = B.pack(A.map complement (A.reverse (B.unpack (xs))))



kmer_unline::[ByteString]->ByteString 
kmer_unline (x:[])=x
kmer_unline (x:xs)= (B.append (B.snoc x '\n') (kmer_unline xs))

break_up_kmers::ByteString->Int64->[ByteString]
break_up_kmers xs k =if ((B.length xs)==k) then (xs:[]) else ((B.take k xs):(break_up_kmers (B.tail(xs)) k))  

return_kmers::Int64->[ByteString]->ByteString
return_kmers k (x:xs) =(kmer_unline (break_up_kmers  (A.head(xs)) k)) 

return_zip::Int64->[ByteString]->[(ByteString,ByteString)]
return_zip k (x:xs)=(A.zip (break_up_kmers  (A.head(xs)) k) (A.tail (break_up_kmers  (A.head(xs)) k)))

breakup_into4::[ByteString]->[[ByteString]]  
breakup_into4 []=[]
breakup_into4 xs= ((A.take 2 xs):(breakup_into4 (A.drop 2 xs)))  


main :: IO () --Start of the program
main= do 
           [filename,k,current,cut_min,cut_max]<-getArgs
           setCurrentDirectory current
           content1 <-(B.readFile filename)
           B.writeFile "all_kmers.txt" (B.unlines (A.map (return_kmers (read(k)::Int64)) (breakup_into4 (B.lines (content1)))))
           exitiId<-system "sort  all_kmers.txt -o sorted_all_kmers.txt" 
           content2 <-Prelude.readFile "sorted_all_kmers.txt" 
           Prelude.writeFile "kmer_frequency.txt" (A.unlines (A.map (\x->(A.head(x)++" "++show(A.length(x))) ) (A.group (A.lines (content2)))))
           exitId<- system "sort -r  -nk2 kmer_frequency.txt -o sorted_kmer_frequency.txt" 
           exitId<- system ("awk '($2>"++cut_min++")&&($2<"++cut_max++")' sorted_kmer_frequency.txt >filter_sorted_kmer_frequency.txt")
           content3<-(B.readFile "filter_sorted_kmer_frequency.txt")
           hasht<-return(C.fromList (A.zip (A.map (\x->A.head(B.words(x))) (B.lines content3)) [0..]))
           --hPutStrLn C.lookup B.pack(     
           Prelude.writeFile "adjacency_matrix.txt" (A.unlines  (A.map (\x->lookUp hasht x)  (A.concat (A.map (return_zip (read(k)::Int64))  (breakup_into4 (B.lines (content1))))) )) 
