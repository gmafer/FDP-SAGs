#!/bin/sh

#SBATCH --account=emm2
#SBATCH --output=augustus/data/logs/scf_count_%A_%a.out
#SBATCH --error=augustus/data/logs/scf_count_%A_%a.err
#SBATCH --job-name=scf_count
#SBATCH --cpus-per-task=6
#SBATCH --ntasks-per-node=1
#SBATCH --array=1-69%5

DATA_DIR="augustus/data/clean/"

SAMPLE=$(cat ${DATA_DIR}/samples_file.txt | awk "NR == ${SLURM_ARRAY_TASK_ID}")

for word in $(cat ${DATA_DIR}/all_scaffolds/${SAMPLE}_all_scaffolds.txt); \
	do grep -c -w $word ${DATA_DIR}/repeated_NODEs/${SAMPLE}_repeated_NODE.txt >> ${DATA_DIR}/scaffolds_counts/scaffolds_counts_${SAMPLE}.txt; \
	done;

paste ${DATA_DIR}/all_scaffolds/${SAMPLE}_all_scaffolds.txt ${DATA_DIR}/scaffolds_counts/scaffolds_counts_${SAMPLE}.txt > ${DATA_DIR}/pasted/pasted_${SAMPLE}_scf_counts.txt
