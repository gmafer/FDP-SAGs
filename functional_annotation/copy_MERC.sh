#!/bin/sh

#SBATCH --account=emm2
#SBATCH --job-name=copys_aug
#SBATCH --cpus-per-task=24
#SBATCH --ntasks-per-node=1
#SBATCH --mem=200G

cp -r /mnt/lustre/scratch/guillem/MERC.MMETSP.uniclust50/ . 
