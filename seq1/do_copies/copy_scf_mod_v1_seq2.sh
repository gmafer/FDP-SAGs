#!/bin/sh

#SBATCH --account=emm2
#SBATCH --job-name=copy_v1_seq2
#SBATCH --cpus-per-task=24
#SBATCH --ntasks-per-node=1
#SBATCH --output=seq1/data/logs/copy_v1_seq2_%A_%a.out
#SBATCH --error=seq1/data/logs/copy_v1_seq2_%A_%a.err
#SBATCH --array=1-7%7

#================================================
DATA_DIR='seq2/data/clean/assembly/'

SAMPLE=$(cat seq1/data/clean/keep2.txt | awk "NR == ${SLURM_ARRAY_TASK_ID}")

cp ${DATA_DIR}/${SAMPLE}/scaffolds_mod.fasta neteja/v1/${SAMPLE}_scaffolds_mod_v1.fasta

