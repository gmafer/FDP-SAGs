#!/bin/sh

#SBATCH --account=emm2
#SBATCH --job-name=annotclean
#SBATCH --cpus-per-task=6
#SBATCH --mem=30G
#SBATCH --ntasks-per-node=1

DATA_DIR='data/clean/annotation_clean'

for SAMPLE in $(cat samples_file.txt); \
do 
	
cat results/${SAMPLE}/${SAMPLE}_eggnog.emapper.annotations | awk '{print $6}' | grep -vE ",|@" | grep -vF "." | grep "|" > ${DATA_DIR}/${SAMPLE}_annot_clean.txt
	
done;

