#!/bin/sh

#SBATCH --account=emm2
#SBATCH --job-name=eggnog
#SBATCH --cpus-per-task=8
#SBATCH --mem=100G
#SBATCH --ntasks-per-node=1
#SBATCH --output=data/logs/egg_%A_%a.out
#SBATCH --error=data/logs/egg_%A_%a.err
#SBATCH --array=1-69%3

#================================================

##########VARIABLES#########

SAMPLE=$(cat data/clean/samples_file_69.txt | awk "NR == ${SLURM_ARRAY_TASK_ID}")

DATA_SAG=/mnt/lustre/repos/bio/projects/MassanaLab/easig_sags/functional_annotation/data/clean/augustus+eggnog_results/

DATA_OUT=/mnt/lustre/repos/bio/projects/MassanaLab/easig_sags/functional_annotation/data/clean/augustus+eggnog_results/

cd ${DATA_OUT}

module load eggnog-mapper
source activate eggnog-mapper

emapper.py -i ${DATA_SAG}/${SAMPLE}/${SAMPLE}*.faa -o ${DATA_SAG}/${SAMPLE}/${SAMPLE}_eggnog --cpu 8

