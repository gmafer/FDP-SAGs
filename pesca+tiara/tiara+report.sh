#!/bin/sh

#SBATCH --account=emm2
#SBATCH --job-name=tiara
#SBATCH --cpus-per-task=6
#SBATCH --ntasks-per-node=1
#SBATCH --mem=200G
#SBATCH --output=data/logs/tiara_%A_%a.out
#SBATCH --error=data/logs/tiara_%A_%a.err

#================================================

##########VARIABLES#########

# Path to files

NUM_THREADS=6

module load tiara

tiara \
 -i selected_PACBIO_all.fasta \
 -o data/clean/tiara_out


DATA_DIR=data/clean/
OUT_FILE=data/clean/tiara_report_PACBIO_all.txt

for SAMPLE in $(ls ${DATA_DIR} | grep 'log')
do
  cat ${DATA_DIR}/${SAMPLE} | \
  grep -e 'archaea' -e 'bacteria' -e 'eukarya' -e 'organelle' -e 'unknown' | \
  awk -v var=${SAMPLE} '{print var$0}' OFS='\t' \
  >> ${OUT_FILE}
done
