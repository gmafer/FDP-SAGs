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
 -i selected_scaffolds_illumina.fasta \
 -o data/clean/tiara_out
