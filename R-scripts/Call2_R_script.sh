#!/bin/bash
#$ -cwd -S /bin/bash
#$ -l mem=3G
#$ -l time=:40:

$MODULESHOME/init/bash
module load R/3.4.0

R CMD BATCH 2.R_script_for_bash.R