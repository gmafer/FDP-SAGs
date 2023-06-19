#!/bin/sh

#SBATCH --account=emm2
#SBATCH --job-name=spades
#SBATCH --cpus-per-task=24
#SBATCH --ntasks-per-node=1
#SBATCH --output=seq1/data/logs/spades_%A_%a.out
#SBATCH --error=seq1/data/logs/spades_%A_%a.err 
#SBATCH --array=1-128%12

#================================================

##########VARIABLES#########

# Load modules

module load spades

# Path to files

DATA_DIR='seq1/data/clean/concatenated/'

#00_Kapa_SAGs, text file with SAGs codes of reads files

SAMPLE=$(ls ${DATA_DIR} | cut -f1,2 -d'_' | sort -u | awk "NR == ${SLURM_ARRAY_TASK_ID}")
OUT_DIR="seq1/data/clean/assembly/${SAMPLE}"
mkdir ${OUT_DIR}

# Parameters

NUM_THREADS=24

###########SCRIPT###########

spades.py \
 -1 ${DATA_DIR}/${SAMPLE}_1.fq.gz \
 -2 ${DATA_DIR}/${SAMPLE}_2.fq.gz \
 -t ${NUM_THREADS} \
 --sc \
 -k 21,33,55,77,99 \
 -o ${OUT_DIR}
