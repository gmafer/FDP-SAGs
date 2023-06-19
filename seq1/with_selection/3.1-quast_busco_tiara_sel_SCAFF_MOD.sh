#!/bin/sh

#SBATCH --account=emm2
#SBATCH --job-name=quast_busco_sel
#SBATCH --cpus-per-task=6
#SBATCH --ntasks-per-node=1
#SBATCH --output=seq1/data/logs/quastbusco_selection_mod_%A_%a.out
#SBATCH --error=seq1/data/logs/quastbusco_selection_mod_%A_%a.err 
#SBATCH --array=1-69%10

#================================================

##########VARIABLES#########

mkdir -p seq1/data/clean/quast_busco_tiara/quast_sel_scaff_mod
mkdir -p seq1/data/clean/quast_busco_tiara/busco_sel_scaff_mod
mkdir -p seq1/data/clean/quast_busco_tiara/tiara_sel_scaff_mod

# Path to files

DATA_DIR='seq1/data/clean/final_assembly/scaffolds/'
SAMPLE=$(cat seq1/data/clean/keep.txt | awk "NR == ${SLURM_ARRAY_TASK_ID}")

BUSCO_db=/mnt/lustre/scratch/eukaryota_odb10/

NUM_THREADS=6

module load quast

quast.py \
 --contig-thresholds 0,1000,3000,5000 \
 -o seq1/data/clean/quast_busco_tiara/quast_sel_scaff_mod/${SAMPLE} \
 -t ${NUM_THREADS} \
 ${DATA_DIR}/${SAMPLE}_scaffolds_mod.fasta


module load busco

cd seq1/data/clean/quast_busco_tiara/busco_sel_scaff_mod/

export AUGUSTUS_CONFIG_PATH="../../config/"

run_BUSCO.py \
 --in ../../final_assembly/scaffolds/${SAMPLE}_scaffolds_mod.fasta \
 -o ${SAMPLE} \
 -l ${BUSCO_db} \
 -m geno

cd ../../../../../

module load tiara

tiara \
 -i ${DATA_DIR}/${SAMPLE}_scaffolds_mod.fasta \
 -o seq1/data/clean/quast_busco_tiara/tiara_sel_scaff_mod/${SAMPLE}
