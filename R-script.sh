#!/bin/bash
#$ -cwd -S /bin/bash
#$ -l mem=1G
#$ -l time=:10:

$MODULESHOME/init/bash
module load R/3.4.0

clear
echo "Testing an R scipt"> R-script.log

R CMD BATCH R_script.R


