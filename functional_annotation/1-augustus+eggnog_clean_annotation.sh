#!/bin/sh

#SBATCH --account=emm2
#SBATCH --job-name=eggfullannotclean
#SBATCH --cpus-per-task=6
#SBATCH --mem=50G
#SBATCH --ntasks-per-node=1

DATA_DIR='data/clean/'

for SAMPLE in $(cat ${DATA_DIR}/samples_file_69.txt); \
do 

 NUMa=$(grep "NODE" ${DATA_DIR}/augustus+eggnog_results/${SAMPLE}/${SAMPLE}_augustus.gff | grep -w  "gene" | wc -l)

 grep "NODE" ${DATA_DIR}/augustus+eggnog_results//${SAMPLE}/${SAMPLE}_augustus.gff | \
 	grep -w  "gene" > ${DATA_DIR}/aug_gff_clean/${SAMPLE}_${NUMa}_aug_gff_clean.txt


 NUMe=$(cat ${DATA_DIR}/augustus+eggnog_results/${SAMPLE}/${SAMPLE}_eggnog.emapper.annotations | \
 	awk -F "\t" '{print $1"\t"$6}' | \
	sed '/^$/d' | grep "|" | grep -v "-"| wc -l)

 cat ${DATA_DIR}/augustus+eggnog_results/${SAMPLE}/${SAMPLE}_eggnog.emapper.annotations | \
 	awk -F "\t" '{print $1"\t"$6}' | \
 	sed '/^$/d' | \
 	grep "|" | \
 	grep -v "-" > ${DATA_DIR}/eggnog_full_annot_clean/${SAMPLE}_${NUMe}_full_annot_clean.txt
	
done;

