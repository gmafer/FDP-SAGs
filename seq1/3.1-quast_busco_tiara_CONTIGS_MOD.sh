#!/bin/sh

#SBATCH --account=emm2
#SBATCH --job-name=quast_busco_contigs
#SBATCH --cpus-per-task=6
#SBATCH --ntasks-per-node=1
#SBATCH --output=seq1/data/logs/quastbusco_contigs_mod_%A_%a.out
#SBATCH --error=seq1/data/logs/quastbusco_contigs_mod_%A_%a.err 
#SBATCH --array=1-128%16

#================================================

##########VARIABLES#########

mkdir -p seq1/data/clean/quast_busco_tiara/quast_c_mod
mkdir -p seq1/data/clean/quast_busco_tiara/busco_c_mod
mkdir -p seq1/data/clean/quast_busco_tiara/tiara_c_mod

# Path to files

DATA_DIR='seq1/data/clean/assembly/'
SAMPLE=$(ls ${DATA_DIR} | awk "NR == ${SLURM_ARRAY_TASK_ID}")

BUSCO_db=/mnt/lustre/scratch/eukaryota_odb10/

NUM_THREADS=6

module load quast

quast.py \
 --contig-thresholds 0,1000,3000,5000 \
 -o seq1/data/clean/quast_busco_tiara/quast_c_mod/${SAMPLE} \
 -t ${NUM_THREADS} \
 ${DATA_DIR}/${SAMPLE}/contigs_mod.fasta


module load busco

cd seq1/data/clean/quast_busco_tiara/busco_c_mod/

export AUGUSTUS_CONFIG_PATH="../../config/"

run_BUSCO.py \
 --in ../../assembly/${SAMPLE}/contigs_mod.fasta \
 -o ${SAMPLE} \
 -l ${BUSCO_db} \
 -m geno

cd ../../../../../

module load tiara

tiara \
 -i ${DATA_DIR}/${SAMPLE}/contigs_mod.fasta \
 -o seq1/data/clean/quast_busco_tiara/tiara_c_mod/${SAMPLE}
