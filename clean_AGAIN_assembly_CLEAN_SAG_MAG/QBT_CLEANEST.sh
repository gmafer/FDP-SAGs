#!/bin/sh

#SBATCH --account=emm2
#SBATCH --job-name=qbt
#SBATCH --cpus-per-task=6
#SBATCH --ntasks-per-node=1
#SBATCH --output=data/logs/qbt_CLEANEST_%J.out
#SBATCH --error=data/logs/qbt_CLEANEST_%J.err 

#================================================

##########VARIABLES#########

# Path to files

DATA_DIR='data/clean/'

#SAMPLE=$(cat ${DATA_DIR}/samples_file_ill_pac_307.txt | awk "NR == ${SLURM_ARRAY_TASK_ID}")

SAMPLE=CLEANEST

BUSCO_db=/home/gmarimon/MassanaLab/easig_sags/xabi_sags/all/data/clean/eukaryota_odb10/

NUM_THREADS=24

mkdir -p ${DATA_DIR}/qbt_CLEANEST

mkdir -p ${DATA_DIR}/qbt_CLEANEST/quast/
mkdir -p ${DATA_DIR}/qbt_CLEANEST/busco/
mkdir -p ${DATA_DIR}/qbt_CLEANEST/tiara/


module load quast

quast.py \
 --contig-thresholds 0,1000,3000,5000 \
 -o ${DATA_DIR}/qbt_CLEANEST/quast/${SAMPLE} \
 -t ${NUM_THREADS} \
 data/clean/CLEANEST.fasta



module load busco/5.4.6
conda activate busco-5.4.6

cd data/clean/qbt_CLEANEST/busco/

export AUGUSTUS_CONFIG_PATH="../../config/"

busco \
 --in ../../CLEANEST.fasta \
 -o ${SAMPLE} \
 -l ${BUSCO_db} \
 -m geno

cd ../../../../



module load tiara

tiara \
 -i data/clean/CLEANEST.fasta \
 -o data/clean/qbt_CLEANEST/tiara/${SAMPLE}
