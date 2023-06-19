#!/bin/sh

#SBATCH --account=emm2
#SBATCH --output=augustus/data/logs/filt_scf_count_%A_%a.out
#SBATCH --error=augustus/data/logs/filt_scf_count_%A_%a.err
#SBATCH --job-name=filt_scf_count
#SBATCH --cpus-per-task=6
#SBATCH --ntasks-per-node=1
#SBATCH --array=1-69%5

DATA_DIR="augustus/data/clean/"

SAMPLE=$(cat ${DATA_DIR}/samples_file.txt | awk "NR == ${SLURM_ARRAY_TASK_ID}")

cat ${DATA_DIR}/pasted/pasted_${SAMPLE}_scf_counts.txt | grep length_[0-9][0-9][0-9][0-9] > ${DATA_DIR}/pasted_filter1000/pasted1000_${SAMPLE}_scf_counts.txt	


