#!/bin/sh

#SBATCH --account=emm2
#SBATCH --job-name=copy_contig
#SBATCH --cpus-per-task=6
#SBATCH --ntasks-per-node=1
#SBATCH --output=seq1/data/logs/copycontig_%A_%a.out
#SBATCH --error=seq1/data/logs/copycontig_%A_%a.err


cp -r seq1/data/clean/assembly/ seq1/data/clean/assembly_copy
