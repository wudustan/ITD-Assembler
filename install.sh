mkdir temp
cp src/iterate_on_bins.hs temp/
cp src/cluster_bins.hs temp/
echo " ">>temp/cluster_bins.hs
echo "path::String" >>temp/cluster_bins.hs
echo "path=\"$PWD\"" >>temp/cluster_bins.hs
cat config.txt >>temp/cluster_bins.hs 
/hgsc_software/ghc/latest/bin/ghc temp/cluster_bins.hs -o cluster_bins
echo "" >>temp/iterate_on_bins.hs
echo "path::String" >>temp/iterate_on_bins.hs
echo "path=\"$PWD\"" >>temp/iterate_on_bins.hs
cat config.txt >>temp/iterate_on_bins.hs 
/hgsc_software/ghc/latest/bin/ghc temp/iterate_on_bins.hs -o iterate_on_bins
cp src/post_processing.hs  temp/ 
echo "" >>temp/post_processing.hs
echo "exec_path::String" >>temp/post_processing.hs
echo "exec_path=\"$PWD\"" >>temp/post_processing.hs
cat config.txt >>temp/post_processing.hs 
/hgsc_software/ghc/latest/bin/ghc temp/post_processing.hs -o post_processing
cp src/iterate_on_bins_light.hs  temp/
echo "" >>temp/iterate_on_bins_light.hs
echo "path::String" >>temp/iterate_on_bins_light.hs
echo "path=\"$PWD\"" >>temp/iterate_on_bins_light.hs
cat config.txt >>temp/iterate_on_bins_light.hs 
/hgsc_software/ghc/latest/bin/ghc temp/iterate_on_bins_light.hs -o iterate_on_bins_light
/hgsc_software/ghc/latest/bin/ghc src/fq2fasta.hs -o bin/fq2fasta
/hgsc_software/ghc/latest/bin/ghc src/filterN.hs -o bin/filterN 
/hgsc_software/ghc/latest/bin/ghc src/cluster_dup_first.hs -o bin/cluster_dup_first 
/hgsc_software/ghc/latest/bin/ghc src/cluster_sclip.hs -o bin/cluster_sclip
/hgsc_software/ghc/latest/bin/ghc src/make_fq.hs -o bin/make_fq 
/hgsc_software/ghc/latest/bin/ghc src/all_complement.hs -o bin/all_complement 
/hgsc_software/ghc/latest/bin/ghc src/find_kmers_2_latest.hs  -o bin/find_kmers_2_latest 
/hgsc_software/ghc/latest/bin/ghc src/extract_kmers_latest.hs -o bin/extract_kmers_latest
/hgsc_software/ghc/latest/bin/ghc src/fastq_line_2.hs -o bin/fastq_line_2
gcc -o bin/compute_cycles src/hgsc_test.c -lgsl -lgslcblas
/hgsc_software/ghc/latest/bin/ghc src/grep_reads.hs -o bin/grep_reads
/hgsc_software/ghc/latest/bin/ghc src/make_unique.hs -o bin/make_unique
/hgsc_software/ghc/latest/bin/ghc src/make_fq_pipeline.hs -o bin/make_fq_pipeline
/hgsc_software/ghc/latest/bin/ghc src/filter_frm_blast.hs -o bin/filter_frm_blast
/hgsc_software/ghc/latest/bin/ghc src/dup_rem_first.hs -o bin/dup_rem_first
/hgsc_software/ghc/latest/bin/ghc src/make_results_line.hs -o bin/make_results_line 
/hgsc_software/ghc/latest/bin/ghc src/rem_ref_contigs.hs -o bin/rem_ref_contigs
/hgsc_software/ghc/latest/bin/ghc src/make_results_line_2.hs -o bin/make_results_line_2
cd temp
rm * 
cd ..
rmdir temp 
