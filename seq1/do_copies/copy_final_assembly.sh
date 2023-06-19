#!/bin/sh

#SBATCH --account=emm2
#SBATCH --job-name=copy_fin_as
#SBATCH --cpus-per-task=6
#SBATCH --ntasks-per-node=1
#SBATCH --output=seq1/data/logs/copyfinas_%A_%a.out
#SBATCH --error=seq1/data/logs/copyfinas_%A_%a.err


cp -r final_assembly seq1/data/clean/
