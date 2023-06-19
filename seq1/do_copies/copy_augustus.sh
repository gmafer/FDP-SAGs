#!/bin/sh

#SBATCH --account=emm2
#SBATCH --job-name=copy_aug
#SBATCH --cpus-per-task=6
#SBATCH --ntasks-per-node=1

cp -r ../Programs/augustus/ seq1/data/clean/
