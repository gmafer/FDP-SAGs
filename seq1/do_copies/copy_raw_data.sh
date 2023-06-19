#!/bin/sh

#SBATCH --account=emm2
#SBATCH --job-name=copy_pacbio
#SBATCH --cpus-per-task=6
#SBATCH --ntasks-per-node=1
#SBATCH --output=seq1/data/logs/copypacbio_%A_%a.out
#SBATCH --error=seq1/data/logs/copypacbio_%A_%a.err


cp -r ../01-RAW_DATA/EASI-g_metaG_PACBio/1_A01_raw.tar.gz seq1/data/raw/metaG_PACBio
