#!/bin/sh

#SBATCH --account=emm2
#SBATCH --job-name=kaiju_join
#SBATCH --cpus-per-task=8
#SBATCH --mem=100G
#SBATCH --ntasks-per-node=1
#SBATCH --array=1-69%3

#================================================

##########VARIABLES#########

SAMPLE=$(cat data/clean/samples_file_69.txt | awk "NR == ${SLURM_ARRAY_TASK_ID}")

OUT_DIR_NT=data/clean/aug+kaiju_joins_nt

sort --version-sort data/clean/aug_g+NODE/${SAMPLE}_g+NODE.txt > ${OUT_DIR_NT}/${SAMPLE}_A1.txt 

sort --version-sort data/clean/pastes/${SAMPLE}_nt_awk_2_6.txt > ${OUT_DIR_NT}/${SAMPLE}_B1.txt

join ${OUT_DIR_NT}/${SAMPLE}_A1.txt ${OUT_DIR_NT}/${SAMPLE}_B1.txt > ${OUT_DIR_NT}/${SAMPLE}_nt_aug+kaiju_join.txt

rm ${OUT_DIR_NT}/${SAMPLE}_A1.txt

rm ${OUT_DIR_NT}/${SAMPLE}_B1.txt


OUT_DIR_FAA=data/clean/aug+kaiju_joins_faa

sort --version-sort data/clean/aug_g+NODE/${SAMPLE}_g+NODE.txt > ${OUT_DIR_FAA}/${SAMPLE}_A2.txt

sort --version-sort data/clean/pastes/${SAMPLE}_faa_awk_2_6.txt > ${OUT_DIR_FAA}/${SAMPLE}_B2.txt

join ${OUT_DIR_FAA}/${SAMPLE}_A2.txt ${OUT_DIR_FAA}/${SAMPLE}_B2.txt > ${OUT_DIR_FAA}/${SAMPLE}_faa_aug+kaiju_join.txt

rm ${OUT_DIR_FAA}/${SAMPLE}_A2.txt

rm ${OUT_DIR_FAA}/${SAMPLE}_B2.txt

