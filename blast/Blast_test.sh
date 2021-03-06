#!/bin/bash

#$ -cwd -S /bin/bash
#$ -l mem=1G
#$ -l time=:50:

clear
echo "---Metatranscriptomic workflow step 5 script v.1.0---" > output.log
/ifs/scratch/msph/arsenic/bjm2103/ncbi-blast-2.6.0+/bin/blastp -db nr \
-query SampleBJM.fasta \
-max_target_seqs 1 \
-num_threads 4 \
-outfmt 11 > blast_test.asn

/ifs/scratch/msph/arsenic/bjm2103/ncbi-blast-2.6.0+/bin/blast_formatter \
-archive blast_test.asn \
-outfmt "6 qseqid length evalue stitle" \
-out my_fits.out

