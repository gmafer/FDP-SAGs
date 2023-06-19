#!/bin/sh

#SBATCH --account=emm2
#SBATCH --job-name=copys_aug
#SBATCH --cpus-per-task=6
#SBATCH --ntasks-per-node=1

cp -r seq1/data/clean/augustus/ augustus/data/clean/

cp -r seq1/data/clean/results/ augustus/data/clean/
