#!/bin/sh

#SBATCH --account=emm2
#SBATCH --job-name=qbt_cons_un
#SBATCH --cpus-per-task=6
#SBATCH --ntasks-per-node=1
#SBATCH --output=data/logs/qbt_cons_un_%A_%a.out
#SBATCH --error=data/logs/qbt_cons_un_%A_%a.err 

#================================================

##########VARIABLES#########

# Path to files

DATA_DIR='data/clean/'

BUSCO_db=/home/gmarimon/MassanaLab/easig_sags/geneious_stuff/SAG_MAG_assembly/data/clean/eukaryota_odb10/

NUM_THREADS=6

module load quast

mkdir -p ${DATA_DIR}/qbt/

mkdir -p ${DATA_DIR}/qbt/quast/
mkdir -p ${DATA_DIR}/qbt/busco/
mkdir -p ${DATA_DIR}/qbt/tiara/

quast.py \
 --contig-thresholds 0,1000,3000,5000 \
 -o ${DATA_DIR}/qbt/quast/cons_un \
 -t ${NUM_THREADS} \
 ${DATA_DIR}/cons_unused.fasta



module load busco/5.4.6
conda activate busco-5.4.6

cd ${DATA_DIR}/qbt/busco/

export AUGUSTUS_CONFIG_PATH="../../config/"

busco \
 -i ../../cons_unused.fasta \
 -o cons_un \
 -l ${BUSCO_db} \
 -m geno

cd ../../../../

conda deactivate



module load tiara

tiara \
 -i ${DATA_DIR}/cons_unused.fasta \
 -o ${DATA_DIR}/qbt/tiara/cons_un
