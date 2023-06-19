#!/bin/sh

#SBATCH --account=emm2
#SBATCH --job-name=gen_count
#SBATCH --cpus-per-task=6
#SBATCH --ntasks-per-node=1
#SBATCH --array=1-69%5

DATA_DIR="augustus/data/clean/"
OUT_DIR="augustus/data/clean/all_scaffolds/"

SAMPLE=$(cat augustus/data/clean/samples_file.txt | awk "NR == ${SLURM_ARRAY_TASK_ID}")


grep ">" final_assembly/scaffolds/${SAMPLE}_scaffolds.fasta | sed 's/>//g' > ${OUT_DIR}/${SAMPLE}_all_scaffolds.txt
