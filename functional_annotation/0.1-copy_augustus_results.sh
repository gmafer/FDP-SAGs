#!/bin/sh

#SBATCH --account=emm2
#SBATCH --job-name=copys_aug
#SBATCH --cpus-per-task=6
#SBATCH --ntasks-per-node=1

cp -r ../augustus/data/clean/results data/clean/

cp -r ../augustus/data/clean/results2 data/clean/

mv data/clean/results2/* data/clean/results

mv data/clean/results data/clean/augustus+eggnog_results

rm -r data/clean/results2
