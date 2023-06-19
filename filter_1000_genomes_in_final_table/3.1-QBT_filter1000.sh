#!/bin/sh

#SBATCH --account=emm2
#SBATCH --job-name=qbt_filt1000
#SBATCH --cpus-per-task=6
#SBATCH --ntasks-per-node=1
#SBATCH --output=data/logs/qbt_filt1000_%A_%a.out
#SBATCH --error=data/logs/qbt_filt1000_%A_%a.err 
#SBATCH --array=1-7%7	

#================================================

##########VARIABLES#########

# Path to files

DATA_DIR='data/clean/'

SAMPLE=$(ls ${DATA_DIR}/genomes_filtered/ | awk -F "_" '{print $1}' | awk "NR == ${SLURM_ARRAY_TASK_ID}")

BUSCO_db=/home/gmarimon/MassanaLab/easig_sags/xabi_sags/all/data/clean/eukaryota_odb10/

NUM_THREADS=6

mkdir -p ${DATA_DIR}/qbt

mkdir -p ${DATA_DIR}/qbt/quast/
mkdir -p ${DATA_DIR}/qbt/busco/
mkdir -p ${DATA_DIR}/qbt/tiara/



module load quast

quast.py \
 --contig-thresholds 0,1000,3000,5000 \
 -o ${DATA_DIR}/qbt/quast/${SAMPLE} \
 -t ${NUM_THREADS} \
 ${DATA_DIR}/genomes_filtered/${SAMPLE}*.fasta



module load busco/5.4.6
conda activate busco-5.4.6

cd data/clean/qbt/busco/

export AUGUSTUS_CONFIG_PATH="../../config/"

busco \
 --in ../../../../${DATA_DIR}/genomes_filtered/${SAMPLE}*.fasta \
 -o ${SAMPLE} \
 -l ${BUSCO_db} \
 -m geno

cd ../../../../



module load tiara

tiara \
 -i ${DATA_DIR}/genomes_filtered/${SAMPLE}*.fasta \
 -o data/clean/qbt/tiara/${SAMPLE}
