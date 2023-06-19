#!/bin/sh

#SBATCH --account=emm2
#SBATCH --job-name=copy_sc_cont1
#SBATCH --cpus-per-task=24
#SBATCH --ntasks-per-node=1
#SBATCH --output=seq1/data/logs/copy_sc_cont_%A_%a.out
#SBATCH --error=seq1/data/logs/copy_sc_cont_%A_%a.err
#SBATCH --array=1-7%7

#================================================
DATA_DIR='seq2/data/clean/assembly'
SAMPLE=$(cat seq1/data/clean/keep2.txt | awk "NR == ${SLURM_ARRAY_TASK_ID}")

cp ${DATA_DIR}/${SAMPLE}/scaffolds.fasta final_assembly3/scaffolds/${SAMPLE}_scaffolds.fasta

cp ${DATA_DIR}/${SAMPLE}/contigs.fasta final_assembly3/contigs/${SAMPLE}_contigs.fasta
