#!/bin/sh

#SBATCH --account=emm2
#SBATCH --job-name=g+NODE
#SBATCH --cpus-per-task=8
#SBATCH --mem=100G
#SBATCH --ntasks-per-node=1
#SBATCH --array=1-69%3

#================================================

##########VARIABLES#########

SAMPLE=$(cat data/clean/samples_file_69.txt | awk "NR == ${SLURM_ARRAY_TASK_ID}")

awk '{print $9"\t"$1}' data/clean/aug_gff_clean/${SAMPLE}_*_aug_gff_clean.txt > data/clean/aug_g+NODE/${SAMPLE}_g+NODE.txt

