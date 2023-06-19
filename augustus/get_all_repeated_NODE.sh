#!/bin/sh

#SBATCH --account=emm2
#SBATCH --job-name=rep_nod
#SBATCH --cpus-per-task=6
#SBATCH --ntasks-per-node=1
#SBATCH --array=1-69%5

DATA_DIR="augustus/data/clean/"
OUT_DIR="augustus/data/clean/repeated_NODEs/"

SAMPLE=$(cat ${DATA_DIR}/samples_file.txt | awk "NR == ${SLURM_ARRAY_TASK_ID}")


grep "NODE" ${DATA_DIR}/results/${SAMPLE}/${SAMPLE}_augustus.gff | grep -w "gene" | awk '{print $1}' > ${OUT_DIR}/${SAMPLE}_repeated_NODE.txt


