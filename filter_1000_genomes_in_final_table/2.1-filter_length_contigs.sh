#!/bin/bash

#SBATCH --account=emm2
#SBATCH --job-name=filter_vsearch
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --output=data/logs/filter_vsearch_%A_%a.out
#SBATCH --error=data/logs/filter_vsearch_%A_%a.err
#SBATCH --array=1-7%7

# Load modules

module load vsearch

DATA_DIR='../genomes_in_final_table/'

OUT='data/clean/genomes_filtered'

mkdir -p ${OUT}

SAMPLE=$(ls ${DATA_DIR} | grep genome | awk "NR == ${SLURM_ARRAY_TASK_ID}")

MIN_LEN=1000

vsearch \
 --fastx_filter ${DATA_DIR}/${SAMPLE} \
 --fastq_minlen ${MIN_LEN} \
 --fastaout ${OUT}/${SAMPLE/.fasta/_filter_1000.fasta}
