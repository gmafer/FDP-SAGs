#!/bin/sh

#SBATCH --account=emm2
#SBATCH --job-name=1colannotclean
#SBATCH --cpus-per-task=6
#SBATCH --mem=30G
#SBATCH --ntasks-per-node=1

DATA_DIR='data/clean/1col_annotation_clean'

for SAMPLE in $(cat data/clean/samples_file_clean.txt); \
do 
	
grep -f data/clean/annotation_clean/${SAMPLE}_annot_clean.txt results/${SAMPLE}/${SAMPLE}_eggnog.emapper.annotations | \
 awk '{print $1"\t"$6}' > ${DATA_DIR}/${SAMPLE}_1col_annot_clean.txt
	
done;

