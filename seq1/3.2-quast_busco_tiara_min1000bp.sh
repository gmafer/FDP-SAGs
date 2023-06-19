#!/bin/sh

#SBATCH --account=emm2
#SBATCH --job-name=quast_busco
#SBATCH --cpus-per-task=6
#SBATCH --ntasks-per-node=1
#SBATCH --output=seq1/data/logs/quastbusco_1000bp_%A_%a.out
#SBATCH --error=seq1/data/logs/quastbusco_1000bp_%A_%a.err 
#SBATCH --array=1-128%16

#================================================

##########VARIABLES#########

# Path to files

DATA_DIR='seq1/data/clean/assembly/'
SAMPLE=$(ls ${DATA_DIR} | awk "NR == ${SLURM_ARRAY_TASK_ID}")

BUSCO_db=/mnt/lustre/scratch/eukaryota_odb10

NUM_THREADS=6

module load quast

quast.py \
 -o seq1/data/quast/min1000bp/${SAMPLE} \
 -t ${NUM_THREADS} \
 ${DATA_DIR}/${SAMPLE}/scaffolds_min1000bp.fasta


module load busco

cd seq1/data/busco/min1000bp

export AUGUSTUS_CONFIG_PATH="../../../data/config/"

run_BUSCO.py \
 --in ../../../../${DATA_DIR}/${SAMPLE}/scaffolds_min1000bp.fasta \
 -o ${SAMPLE}_min1000bp \
 -l ${BUSCO_db} \
 -m geno

cd ../../../../

module load tiara

tiara \
 -i ${DATA_DIR}/${SAMPLE}/scaffolds_min1000bp.fasta \
 -o seq1/data/tiara/min1000bp/${SAMPLE}_min1000bp
