#!/bin/bash

#$ -cwd -S /bin/bash
#$ -l mem=8G
#$ -l time=:1000:
#$ -t 1-161

clear
echo "---Metatranscriptomic workflow step 5 script v.1.0---" > step5_cRNA.log
/ifs/scratch/msph/arsenic/bjm2103/ncbi-blast-2.6.0+/bin/blastp -db nr \
-query cd-hit/reads_cRNA_sense90G_$SGE_TASK_ID.fasta \
-max_target_seqs 10 \
-num_threads 8 \
-outfmt 11 > cd-hit/reads_cRNA_sense90G_NRbest10_$SGE_TASK_ID.asn

