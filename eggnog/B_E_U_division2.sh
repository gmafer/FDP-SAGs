#!/bin/sh

#SBATCH --account=emm2
#SBATCH --job-name=beu_div2
#SBATCH --cpus-per-task=6
#SBATCH --mem=30G
#SBATCH --ntasks-per-node=1


DATA_DIR="data/clean"


for SAMPLE in $(cat ${DATA_DIR}/samples_file_clean.txt)
do

grep -wf ${DATA_DIR}/db2/euk_uniq.txt data/clean/annotation_clean/${SAMPLE}_annot_clean.txt > ${DATA_DIR}/try2/euk/${SAMPLE}_euk.txt

grep -wf ${DATA_DIR}/db2/bact_uniq.txt data/clean/annotation_clean/${SAMPLE}_annot_clean.txt > ${DATA_DIR}/try2/bact/${SAMPLE}_bact.txt

grep -vwf ${DATA_DIR}/db2/euk_uniq.txt data/clean/annotation_clean/${SAMPLE}_annot_clean.txt | \
 grep -vwf ${DATA_DIR}/db2/bact_uniq.txt | \
 grep -vwf ${DATA_DIR}/db2/AV_uniq.txt > ${DATA_DIR}/try2/unkn/${SAMPLE}_unkn.txt 


done
