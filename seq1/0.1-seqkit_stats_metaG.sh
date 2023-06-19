#!/bin/sh

#SBATCH --account=emm2
#SBATCH --job-name=seqkit
#SBATCH --cpus-per-task=24
#SBATCH --ntasks-per-node=1
#SBATCH --output=seq1/data/logs/seqkit_metaG_%J.out
#SBATCH --error=seq1/data/logs/seqkit_metaG_%J.err

DATA=seq1/data/raw/metaG/*.gz
THREADS=24
OUT=seq1/data/clean/seqkit_metaG.txt

module load seqkit

seqkit stats \
  ${DATA} \
  -j ${THREADS} > ${OUT}
