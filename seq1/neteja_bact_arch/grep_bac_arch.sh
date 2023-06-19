#!/bin/sh

#SBATCH --account=emm2
#SBATCH --job-name=grep_remove
#SBATCH --cpus-per-task=24
#SBATCH --ntasks-per-node=1
#SBATCH --output=seq1/data/logs/grep_remove%A_%a.out
#SBATCH --error=seq1/data/logs/grep_remove%A_%a.err
#SBATCH --array=1-128%16

#================================================
DATA_DIR='seq1/data/clean/assembly'
SAMPLE=$(ls ${DATA_DIR} | awk "NR == ${SLURM_ARRAY_TASK_ID}")

grep bacteria seq1/data/clean/quast_busco_tiara/tiara_c/${SAMPLE} | awk '{print $1}' > seq1/data/clean/all_toremove/${SAMPLE}_all.txt 
grep archaea seq1/data/clean/quast_busco_tiara/tiara_c/${SAMPLE} | awk '{print $1}' >> seq1/data/clean/all_toremove/${SAMPLE}_all.txt


